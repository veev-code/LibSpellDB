#!/usr/bin/env python3
"""
LibSpellDB Wowhead Audit & Name/Description Enrichment Tool

Scrapes Wowhead's TBC tooltip API to:
1. Audit cooldown/duration values against LibSpellDB data files
2. Add name and description fields to all spell entries

Usage:
    python wowhead_audit.py --fetch              # Fetch all spells from Wowhead (cached)
    python wowhead_audit.py --audit              # Compare cached data vs LibSpellDB
    python wowhead_audit.py --apply --dry-run    # Preview name/description insertion
    python wowhead_audit.py --apply              # Write name/description to Lua files
    python wowhead_audit.py --fetch --audit --apply  # All steps

Options:
    --delay FLOAT       Delay between API requests in seconds (default: 0.15)
    --force-fetch       Re-fetch even if cached
    --dry-run           Preview --apply changes without writing
"""

import argparse
import json
import os
import re
import sys
import time
import urllib.request
import urllib.error
from html import unescape
from pathlib import Path

# ─── Constants ───────────────────────────────────────────────────────────────

SCRIPT_DIR = Path(__file__).parent
DATA_DIR = SCRIPT_DIR.parent / "Data"
CACHE_FILE = SCRIPT_DIR / "wowhead_cache.json"
WOWHEAD_URL = "https://nether.wowhead.com/tbc/tooltip/spell/{spell_id}"

DATA_FILES = [
    "Warrior.lua",
    "Paladin.lua",
    "Hunter.lua",
    "Mage.lua",
    "Priest.lua",
    "Rogue.lua",
    "Shaman.lua",
    "Warlock.lua",
    "Druid.lua",
    "Racials.lua",
    "Procs.lua",
]

# ─── Lua Parsing ─────────────────────────────────────────────────────────────


def parse_lua_file(filepath):
    """
    Parse a LibSpellDB data file, extracting top-level spell entries.

    Uses brace-depth tracking to distinguish top-level entries (depth 2)
    from nested sub-entries like triggersAuras (depth 4+).

    Returns list of dicts:
        {spellID, line, cooldown, duration, has_name, has_description}
    """
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    entries = []
    depth = 0

    for i, line in enumerate(lines):
        # Strip comments for brace counting (but keep strings simple —
        # our data files don't have braces inside string literals)
        code = line.split("--")[0]
        opens = code.count("{")
        closes = code.count("}")

        # Check for spellID at current depth (before updating for this line's braces)
        spell_match = re.match(r"^(\s+)spellID\s*=\s*(\d+)", line)
        if spell_match:
            indent_len = len(spell_match.group(1))
            spell_id = int(spell_match.group(2))

            # Top-level entries have spellID at depth 2 (8-space indent)
            # triggersAuras sub-entries are at depth 4+ (16+ space indent)
            if depth == 2 and indent_len == 8:
                # Look ahead for existing name/description and extract cooldown/duration
                has_name = False
                has_description = False
                cooldown = None
                duration = None

                for j in range(i + 1, min(i + 25, len(lines))):
                    ahead = lines[j].strip()
                    if ahead.startswith("name ="):
                        has_name = True
                    if ahead.startswith("description ="):
                        has_description = True
                    cd_match = re.match(r"cooldown\s*=\s*([\d.]+)", ahead)
                    if cd_match:
                        cooldown = float(cd_match.group(1))
                    dur_match = re.match(r"duration\s*=\s*([\d.]+)", ahead)
                    if dur_match:
                        duration = float(dur_match.group(1))
                    # Stop at next entry or closing brace at depth 2
                    if ahead == "},":
                        break

                entries.append(
                    {
                        "spellID": spell_id,
                        "line": i,
                        "cooldown": cooldown,
                        "duration": duration,
                        "has_name": has_name,
                        "has_description": has_description,
                    }
                )

        depth += opens - closes

    return entries


def parse_all_files():
    """Parse all data files. Returns dict: filename -> list of entries."""
    result = {}
    for filename in DATA_FILES:
        filepath = DATA_DIR / filename
        if filepath.exists():
            result[filename] = parse_lua_file(filepath)
    return result


# ─── Wowhead API ─────────────────────────────────────────────────────────────


def load_cache():
    """Load cached Wowhead responses."""
    if CACHE_FILE.exists():
        with open(CACHE_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}


def save_cache(cache):
    """Save cache to disk."""
    with open(CACHE_FILE, "w", encoding="utf-8") as f:
        json.dump(cache, f, indent=2, ensure_ascii=False)


def fetch_spell(spell_id, cache, delay=0.15, force=False):
    """Fetch a single spell from Wowhead tooltip API, with caching."""
    key = str(spell_id)
    if key in cache and not force:
        return cache[key]

    url = WOWHEAD_URL.format(spell_id=spell_id)
    retries = 3

    for attempt in range(retries):
        try:
            req = urllib.request.Request(
                url, headers={"User-Agent": "LibSpellDB-Audit/1.0"}
            )
            with urllib.request.urlopen(req, timeout=15) as resp:
                data = json.loads(resp.read().decode("utf-8"))
                cache[key] = data
                time.sleep(delay)
                return data
        except urllib.error.HTTPError as e:
            if e.code == 404:
                cache[key] = {"error": "not_found", "spell_id": spell_id}
                time.sleep(delay)
                return cache[key]
            if attempt < retries - 1:
                wait = 2 ** (attempt + 1)
                print(f"  HTTP {e.code} for spell {spell_id}, retrying in {wait}s...")
                time.sleep(wait)
            else:
                print(f"  FAILED: spell {spell_id} after {retries} attempts: HTTP {e.code}")
                cache[key] = {"error": f"http_{e.code}", "spell_id": spell_id}
                return cache[key]
        except Exception as e:
            if attempt < retries - 1:
                wait = 2 ** (attempt + 1)
                print(f"  Error for spell {spell_id}: {e}, retrying in {wait}s...")
                time.sleep(wait)
            else:
                print(f"  FAILED: spell {spell_id} after {retries} attempts: {e}")
                cache[key] = {"error": str(e), "spell_id": spell_id}
                return cache[key]

    return cache.get(key)


def fetch_all(all_files, delay=0.15, force=False):
    """Fetch all unique spellIDs from Wowhead. Returns updated cache."""
    cache = load_cache()

    # Collect unique spellIDs
    all_ids = set()
    for filename, entries in all_files.items():
        for entry in entries:
            all_ids.add(entry["spellID"])

    all_ids = sorted(all_ids)
    to_fetch = [sid for sid in all_ids if str(sid) not in cache or force]

    print(f"Total unique spellIDs: {len(all_ids)}")
    print(f"Already cached: {len(all_ids) - len(to_fetch)}")
    print(f"To fetch: {len(to_fetch)}")

    if not to_fetch:
        print("Nothing to fetch — cache is complete.")
        return cache

    est_time = len(to_fetch) * delay
    print(f"Estimated time: {est_time:.0f}s ({est_time/60:.1f}m)\n")

    for i, spell_id in enumerate(to_fetch):
        if (i + 1) % 50 == 0 or i == 0:
            print(f"  Fetching {i+1}/{len(to_fetch)}...")
        fetch_spell(spell_id, cache, delay=delay, force=force)

        # Save cache every 100 fetches for crash safety
        if (i + 1) % 100 == 0:
            save_cache(cache)

    save_cache(cache)
    print(f"\nFetch complete. Cache saved to {CACHE_FILE}")

    # Report errors
    errors = {k: v for k, v in cache.items() if k in [str(s) for s in all_ids] and isinstance(v, dict) and "error" in v}
    if errors:
        print(f"\n{len(errors)} spells had errors:")
        for k, v in sorted(errors.items(), key=lambda x: int(x[0])):
            print(f"  {k}: {v['error']}")

    return cache


# ─── Tooltip Parsing ─────────────────────────────────────────────────────────


def extract_description(tooltip_html):
    """Extract clean description text from Wowhead tooltip HTML."""
    if not tooltip_html:
        return None

    # Find the last <div class="q"> block (description is always in this div)
    matches = re.findall(r'<div class="q">(.*?)</div>', tooltip_html, re.DOTALL)
    if not matches:
        return None

    # Use the last match (sometimes there are multiple divs; description is last)
    desc = matches[-1]

    # Strip HTML comments (cooldown variant references etc.)
    desc = re.sub(r"<!--.*?-->", "", desc)

    # Strip remaining HTML tags
    desc = re.sub(r"<[^>]+>", "", desc)

    # Decode HTML entities
    desc = unescape(desc)

    # Normalize whitespace
    desc = desc.replace("\xa0", " ")
    desc = re.sub(r"\s+", " ", desc).strip()

    return desc if desc else None


def extract_cooldown(tooltip_html):
    """Extract base cooldown in seconds from tooltip HTML."""
    if not tooltip_html:
        return None

    match = re.search(r"<!--baseCooldown:(.+?)-->", tooltip_html)
    if not match:
        return None

    cd_text = match.group(1)

    # Parse "6 sec cooldown" or "3 min cooldown" or "1 hr cooldown"
    hr_match = re.search(r"([\d.]+)\s*hr", cd_text)
    min_match = re.search(r"([\d.]+)\s*min", cd_text)
    sec_match = re.search(r"([\d.]+)\s*sec", cd_text)

    if hr_match:
        return int(float(hr_match.group(1)) * 3600)
    if min_match:
        return int(float(min_match.group(1)) * 60)
    if sec_match:
        val = float(sec_match.group(1))
        return int(val) if val == int(val) else val
    return None


def extract_duration(buff_html):
    """Extract buff/debuff duration in seconds from the buff field."""
    if not buff_html:
        return None

    match = re.search(
        r"<span class=\"q\">(\d+)\s*(seconds?|minutes?|hours?)\s*remaining</span>",
        buff_html,
    )
    if not match:
        return None

    value = int(match.group(1))
    unit = match.group(2)

    if "hour" in unit:
        return value * 3600
    if "minute" in unit:
        return value * 60
    return value


def lua_escape(s):
    """Escape a string for use in a Lua double-quoted string literal."""
    s = s.replace("\\", "\\\\")
    s = s.replace('"', '\\"')
    s = s.replace("\n", "\\n")
    return s


# ─── Audit ────────────────────────────────────────────────────────────────────


def run_audit(all_files, cache):
    """Compare LibSpellDB values against Wowhead data. Print report."""
    print("=" * 80)
    print("WOWHEAD AUDIT REPORT")
    print("=" * 80)

    total = 0
    not_found = 0
    cd_mismatch = 0
    dur_mismatch = 0
    ok = 0
    errors = 0

    for filename in DATA_FILES:
        entries = all_files.get(filename, [])
        if not entries:
            continue

        print(f"\n{'-' * 70}")
        print(f"  {filename} ({len(entries)} entries)")
        print(f"{'-' * 70}")

        for entry in entries:
            total += 1
            sid = entry["spellID"]
            wh = cache.get(str(sid))

            if not wh or "error" in wh:
                err_type = wh.get("error", "missing") if wh else "not_cached"
                print(f"  [{err_type.upper():>9}]  {sid}")
                if err_type == "not_found":
                    not_found += 1
                else:
                    errors += 1
                continue

            name = wh.get("name", "?")
            wh_cd = extract_cooldown(wh.get("tooltip", ""))
            wh_dur = extract_duration(wh.get("buff", ""))
            lib_cd = entry["cooldown"]
            lib_dur = entry["duration"]

            issues = []

            # Cooldown comparison
            if lib_cd is not None and wh_cd is not None:
                if lib_cd != wh_cd:
                    issues.append(f"cd: lib={lib_cd} wh={wh_cd}")
                    cd_mismatch += 1
            elif lib_cd is not None and lib_cd > 0 and wh_cd is None:
                issues.append(f"cd: lib={lib_cd} wh=NONE")
            elif lib_cd is None and wh_cd is not None and wh_cd > 0:
                issues.append(f"cd: lib=NONE wh={wh_cd}")

            # Duration comparison
            if lib_dur is not None and wh_dur is not None:
                if lib_dur != wh_dur:
                    issues.append(f"dur: lib={lib_dur} wh={wh_dur}")
                    dur_mismatch += 1
            elif lib_dur is not None and lib_dur > 0 and wh_dur is None:
                # Many spells have duration in LibSpellDB but no buff field on Wowhead
                # (e.g., totems, instant effects) — skip these as warnings only
                pass
            elif lib_dur is None and wh_dur is not None and wh_dur > 0:
                issues.append(f"dur: lib=NONE wh={wh_dur}")

            if issues:
                print(f"  [    DIFF]  {sid:<6} {name:<35} {' | '.join(issues)}")
            else:
                ok += 1

    print(f"\n{'=' * 80}")
    print("SUMMARY")
    print(f"{'=' * 80}")
    print(f"  Total entries:        {total}")
    print(f"  OK (match):           {ok}")
    print(f"  Cooldown mismatches:  {cd_mismatch}")
    print(f"  Duration mismatches:  {dur_mismatch}")
    print(f"  Not found (404):      {not_found}")
    print(f"  Other errors:         {errors}")


# ─── Apply ────────────────────────────────────────────────────────────────────


def apply_to_file(filepath, cache, dry_run=False):
    """Insert name and description fields into a Lua data file."""
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    new_lines = []
    depth = 0
    insertions = 0
    i = 0

    while i < len(lines):
        line = lines[i]
        code = line.split("--")[0]

        # Update depth BEFORE checking (brace on previous line already counted)
        opens = code.count("{")
        closes = code.count("}")

        # Check for top-level spellID at depth 2, 8-space indent
        spell_match = re.match(r"^(        )spellID\s*=\s*(\d+)", line)
        if spell_match and depth == 2:
            indent = spell_match.group(1)
            spell_id = int(spell_match.group(2))

            # Check if name/description already exist on next lines
            next_line = lines[i + 1].strip() if i + 1 < len(lines) else ""
            already_has = next_line.startswith("name =") or next_line.startswith(
                "description ="
            )

            wh = cache.get(str(spell_id))
            can_insert = (
                wh
                and "error" not in wh
                and not already_has
            )

            if can_insert:
                name = wh.get("name", "")
                desc = extract_description(wh.get("tooltip", ""))

                insert_lines = []
                if name:
                    insert_lines.append(f'{indent}name = "{lua_escape(name)}",\n')
                if desc:
                    insert_lines.append(
                        f'{indent}description = "{lua_escape(desc)}",\n'
                    )

                if insert_lines:
                    if dry_run:
                        print(f"  + {spell_id} ({name})")
                        for il in insert_lines:
                            print(f"    {il.rstrip()}")
                    new_lines.append(line)
                    new_lines.extend(insert_lines)
                    insertions += len(insert_lines)
                    depth += opens - closes
                    i += 1
                    continue

        new_lines.append(line)
        depth += opens - closes
        i += 1

    if not dry_run and insertions > 0:
        with open(filepath, "w", encoding="utf-8") as f:
            f.writelines(new_lines)

    return insertions


def apply_all(all_files, cache, dry_run=False):
    """Apply name/description to all data files."""
    action = "DRY RUN" if dry_run else "APPLYING"
    print(f"\n{'=' * 80}")
    print(f"{action}: Insert name/description fields")
    print(f"{'=' * 80}")

    total_insertions = 0

    for filename in DATA_FILES:
        filepath = DATA_DIR / filename
        if not filepath.exists():
            continue

        print(f"\n{'-' * 50}")
        print(f"  {filename}")
        print(f"{'-' * 50}")

        count = apply_to_file(filepath, cache, dry_run=dry_run)
        lines_added = count
        entries_enriched = count // 2  # Each entry gets 2 lines (name + description)
        total_insertions += count

        if not dry_run:
            print(f"  {entries_enriched} entries enriched ({lines_added} lines added)")

    print(f"\n{'=' * 80}")
    print(f"Total: {total_insertions} lines {'would be ' if dry_run else ''}inserted")
    if not dry_run and total_insertions > 0:
        print("Files updated successfully.")


# ─── Main ─────────────────────────────────────────────────────────────────────


def main():
    parser = argparse.ArgumentParser(
        description="LibSpellDB Wowhead Audit & Enrichment Tool"
    )
    parser.add_argument(
        "--fetch", action="store_true", help="Fetch spell data from Wowhead"
    )
    parser.add_argument(
        "--audit",
        action="store_true",
        help="Audit cooldown/duration against Wowhead",
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Insert name/description into Lua files",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview --apply changes without writing",
    )
    parser.add_argument(
        "--delay",
        type=float,
        default=0.15,
        help="Delay between API requests (default: 0.15s)",
    )
    parser.add_argument(
        "--force-fetch",
        action="store_true",
        help="Re-fetch even if already cached",
    )

    args = parser.parse_args()

    if not any([args.fetch, args.audit, args.apply, args.dry_run]):
        parser.print_help()
        sys.exit(1)

    # If --dry-run without --apply, treat as --apply --dry-run
    if args.dry_run:
        args.apply = True

    print(f"Data directory: {DATA_DIR}")
    print(f"Cache file: {CACHE_FILE}\n")

    # Step 1: Parse all Lua files
    print("Parsing LibSpellDB data files...")
    all_files = parse_all_files()
    total_entries = sum(len(entries) for entries in all_files.values())
    print(f"Found {total_entries} top-level spell entries across {len(all_files)} files\n")

    for filename, entries in all_files.items():
        print(f"  {filename:<20} {len(entries):>3} entries")

    # Step 2: Fetch from Wowhead (if requested)
    cache = load_cache()
    if args.fetch:
        print(f"\n{'=' * 80}")
        print("FETCHING FROM WOWHEAD")
        print(f"{'=' * 80}\n")
        cache = fetch_all(all_files, delay=args.delay, force=args.force_fetch)
    elif not cache:
        print(
            "\nWARNING: No cache found. Run with --fetch first to populate the cache."
        )
        if args.audit or args.apply:
            sys.exit(1)

    # Step 3: Audit (if requested)
    if args.audit:
        print()
        run_audit(all_files, cache)

    # Step 4: Apply (if requested)
    if args.apply:
        apply_all(all_files, cache, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
