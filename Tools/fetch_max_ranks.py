#!/usr/bin/env python3
"""Fetch max-rank spellIDs from Wowhead for audit comparison."""
import re
import time
from pathlib import Path
from wowhead_audit import load_cache, save_cache, fetch_spell, extract_cooldown, extract_duration, extract_description, parse_all_files

DATA_DIR = Path(__file__).parent.parent / "Data"
FILES = [
    "Warrior.lua", "Paladin.lua", "Hunter.lua", "Mage.lua", "Priest.lua",
    "Rogue.lua", "Shaman.lua", "Warlock.lua", "Druid.lua", "Racials.lua", "Procs.lua",
]


def extract_ranks_and_fields(filepath):
    """Extract spellID -> {ranks, cooldown, duration} from a Lua data file."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    result = {}
    # Match top-level spell blocks (8-space indent spellID)
    for block in re.finditer(
        r"^        spellID\s*=\s*(\d+),.*?(?=\n    \{|\n\},|\Z)",
        content, re.DOTALL | re.MULTILINE
    ):
        sid = int(block.group(1))
        text = block.group(0)

        ranks = None
        rm = re.search(r"ranks\s*=\s*\{([^}]+)\}", text)
        if rm:
            ranks = [int(x) for x in re.findall(r"(\d+)", rm.group(1))]

        cd = None
        cm = re.search(r"cooldown\s*=\s*([\d.]+)", text)
        if cm:
            cd = float(cm.group(1))

        dur = None
        dm = re.search(r"duration\s*=\s*([\d.]+)", text)
        if dm:
            dur = float(dm.group(1))

        result[sid] = {"ranks": ranks, "cooldown": cd, "duration": dur}

    return result


def main():
    cache = load_cache()

    # Collect all spell data from Lua files
    all_spells = {}
    file_for_spell = {}
    for fn in FILES:
        fp = DATA_DIR / fn
        if fp.exists():
            spells = extract_ranks_and_fields(fp)
            all_spells.update(spells)
            for sid in spells:
                file_for_spell[sid] = fn

    # Find max-rank IDs that need fetching
    max_rank_ids = set()
    for sid, data in all_spells.items():
        if data["ranks"] and data["ranks"][-1] != sid:
            max_rank_ids.add(data["ranks"][-1])

    not_cached = sorted([s for s in max_rank_ids if str(s) not in cache])
    print(f"Max-rank IDs to fetch: {len(not_cached)} of {len(max_rank_ids)} total")

    for i, spell_id in enumerate(not_cached):
        if (i + 1) % 20 == 0 or i == 0:
            print(f"  Fetching {i+1}/{len(not_cached)}...")
        fetch_spell(spell_id, cache, delay=0.15)

    save_cache(cache)
    print(f"Cache updated.\n")

    # Now do the comprehensive audit
    print("=" * 90)
    print("COMPREHENSIVE AUDIT (using max-rank Wowhead data where available)")
    print("=" * 90)

    mismatches = []

    for fn in FILES:
        fp = DATA_DIR / fn
        if not fp.exists():
            continue

        spells = extract_ranks_and_fields(fp)
        file_mismatches = []

        for sid, data in spells.items():
            # Determine which Wowhead entry to compare against
            compare_id = sid
            if data["ranks"] and data["ranks"][-1] != sid:
                compare_id = data["ranks"][-1]  # Use max rank

            wh = cache.get(str(compare_id))
            if not wh or "error" in wh:
                # Fall back to base spellID
                wh = cache.get(str(sid))
                compare_id = sid
                if not wh or "error" in wh:
                    continue

            wh_name = wh.get("name", "?")
            wh_cd = extract_cooldown(wh.get("tooltip", ""))
            wh_dur = extract_duration(wh.get("buff", ""))
            lib_cd = data["cooldown"]
            lib_dur = data["duration"]

            issues = []

            # Cooldown comparison
            if lib_cd is not None and wh_cd is not None:
                if lib_cd != wh_cd and not (lib_cd == 0 and wh_cd is None):
                    issues.append(("cooldown", lib_cd, wh_cd))
            elif lib_cd is not None and lib_cd > 0 and wh_cd is None:
                # Wowhead doesn't always show cooldown for long CDs
                if lib_cd < 3600:
                    issues.append(("cooldown", lib_cd, "NONE"))
            elif (lib_cd is None or lib_cd == 0) and wh_cd is not None and wh_cd > 0:
                issues.append(("cooldown", lib_cd or 0, wh_cd))

            # Duration comparison
            if lib_dur is not None and wh_dur is not None:
                if lib_dur != wh_dur:
                    issues.append(("duration", lib_dur, wh_dur))
            elif lib_dur is None and wh_dur is not None and wh_dur > 0:
                issues.append(("duration", "NONE", wh_dur))

            if issues:
                file_mismatches.append({
                    "spellID": sid,
                    "compare_id": compare_id,
                    "name": wh_name,
                    "issues": issues,
                    "lib_cd": lib_cd,
                    "lib_dur": lib_dur,
                    "wh_cd": wh_cd,
                    "wh_dur": wh_dur,
                    "ranks": data["ranks"],
                })

        if file_mismatches:
            print(f"\n--- {fn} ({len(file_mismatches)} issues) ---")
            for m in file_mismatches:
                rank_note = ""
                if m["ranks"] and m["compare_id"] != m["spellID"]:
                    rank_note = f" [compared max rank {m['compare_id']}]"
                print(f"  {m['spellID']:<6} {m['name']:<35}{rank_note}")
                for field, lib_val, wh_val in m["issues"]:
                    print(f"         {field}: lib={lib_val}  wh={wh_val}")
            mismatches.extend(file_mismatches)

    print(f"\n{'=' * 90}")
    print(f"Total mismatches: {len(mismatches)}")


if __name__ == "__main__":
    main()
