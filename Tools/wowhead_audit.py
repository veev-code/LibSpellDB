#!/usr/bin/env python3
"""Two-source live spell-data audit for LibSpellDB.

The authored Lua files are expectations, never the authority. A finding is
"confirmed" only when Wowhead and Wago's current DB2 export agree. The audit
covers primary spell IDs, rank arrays, variants, triggered auras, applied buffs,
cooldown-reset references, rank-duration keys, and explicit version overrides.

Examples:
    python Tools/wowhead_audit.py --audit --ids 33938,403789
    python Tools/wowhead_audit.py --audit --strict
    python Tools/wowhead_audit.py --audit --strict --no-cache --json-report report.json

The optional cache is disposable acceleration. It records source URL, branch,
and fetch time, lives under Tools/.cache, and is never a source of truth.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import re
import sys
import time
import urllib.error
import urllib.request
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from html import unescape
from pathlib import Path
from typing import Iterable


SCRIPT_DIR = Path(__file__).resolve().parent
DATA_DIR = SCRIPT_DIR.parent / "Data"
DEFAULT_CACHE = SCRIPT_DIR / ".cache" / "wowhead-live.json"
WAGO_BUILDS_URL = "https://wago.tools/api/builds"
WAGO_CSV_URL = "https://wago.tools/db2/{table}/csv?build={build}"
WOWHEAD_URL = "https://nether.wowhead.com/{branch}/tooltip/spell/{spell_id}"

TBC_PRODUCT = "wow_anniversary"
CLASSIC_PRODUCT = "wow_classic_era"
NON_SPELL_FILES = {"SpellColors.lua"}
ITEM_SPELL_FIELDS = {
    "Consumables.lua": ("buffSpellID",),
    "Potions.lua": ("buffSpellID",),
    "Trinkets.lua": ("procBuffID", "onUseBuffID"),
}
ROMAN_RANK_SUFFIX = re.compile(r"\s+[IVXLCDM]+$", re.IGNORECASE)


@dataclass(frozen=True)
class SpellReference:
    spell_id: int
    branch: str
    kind: str
    filename: str
    line: int
    expected_name: str | None = None
    aliases: tuple[str, ...] = ()
    cooldown: float | None = None


@dataclass
class Finding:
    severity: str
    code: str
    spell_id: int
    branch: str
    message: str
    contexts: list[str]
    wowhead: str | float | None = None
    wago: str | float | None = None


def _request_text(url: str, timeout: int = 30) -> str:
    request = urllib.request.Request(url, headers={"User-Agent": "LibSpellDB-Live-Audit/2.0"})
    with urllib.request.urlopen(request, timeout=timeout) as response:
        return response.read().decode("utf-8")


def _balanced_table(text: str, start: int) -> tuple[str, int] | None:
    brace = text.find("{", start)
    if brace == -1:
        return None
    depth = 0
    in_string = False
    escaped = False
    for index in range(brace, len(text)):
        char = text[index]
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue
        if char == '"':
            in_string = True
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return text[brace : index + 1], index + 1
    return None


def _remove_named_table(text: str, field: str) -> tuple[str, str | None]:
    match = re.search(rf"\b{re.escape(field)}\s*=", text)
    if not match:
        return text, None
    table = _balanced_table(text, match.end())
    if not table:
        return text, None
    payload, end = table
    return text[: match.start()] + text[end:], payload


def _named_subtable(text: str, field: str) -> str | None:
    match = re.search(rf"\b{re.escape(field)}\s*=\s*", text)
    if not match:
        return None
    if text[match.end() :].lstrip().startswith("false"):
        return None
    table = _balanced_table(text, match.end())
    return table[0] if table else None


def _number_array(text: str, field: str) -> list[int]:
    match = re.search(rf"^\s*{re.escape(field)}\s*=\s*\{{([^}}]*)\}}", text, re.MULTILINE)
    return [int(value) for value in re.findall(r"\d+", match.group(1))] if match else []


def _string_array(text: str, field: str) -> tuple[str, ...]:
    match = re.search(rf"^\s*{re.escape(field)}\s*=\s*\{{([^}}]*)\}}", text, re.MULTILINE)
    return tuple(re.findall(r'"([^"]+)"', match.group(1))) if match else ()


def _scalar_number(text: str, field: str) -> float | None:
    match = re.search(rf"^\s*{re.escape(field)}\s*=\s*([\d.]+)", text, re.MULTILINE)
    return float(match.group(1)) if match else None


def _scalar_string(text: str, field: str) -> str | None:
    match = re.search(rf'^\s*{re.escape(field)}\s*=\s*"([^"]+)"', text, re.MULTILINE)
    return match.group(1) if match else None


def iter_entry_blocks(path: Path) -> Iterable[tuple[str, int]]:
    lines = path.read_text(encoding="utf-8-sig").splitlines()
    in_register = False
    depth = 0
    current: list[str] = []
    start_line = 0

    for line_number, line in enumerate(lines, 1):
        stripped = line.strip()
        if "lib:RegisterSpells(" in stripped:
            in_register = True
            depth += stripped.count("{") - stripped.count("}")
            continue
        if not in_register:
            continue

        opens = stripped.count("{")
        closes = stripped.count("}")
        if depth == 1 and stripped.startswith("{") and opens:
            current = [line]
            start_line = line_number
            depth += opens - closes
            continue

        depth += opens - closes
        if current:
            current.append(line)
            if depth <= 1:
                yield "\n".join(current), start_line
                current = []
        if depth <= 0:
            in_register = False
            depth = 0


def _infer_branch(primary_id: int, explicit: str | None) -> str:
    if explicit in {"tbc", "classic"}:
        return explicit
    return "classic" if primary_id >= 398000 else "tbc"


def _references_for_payload(
    payload: str,
    *,
    branch: str,
    filename: str,
    line: int,
    expected_name: str | None,
    aliases: tuple[str, ...],
    include_stats: bool,
) -> list[SpellReference]:
    primary_match = re.search(r"^\s*spellID\s*=\s*(\d+)", payload, re.MULTILINE)
    if not primary_match:
        return []
    primary_id = int(primary_match.group(1))
    cooldown = _scalar_number(payload, "cooldown") if include_stats else None
    references = [
        SpellReference(primary_id, branch, "primary", filename, line, expected_name, aliases, cooldown)
    ]

    for spell_id in _number_array(payload, "ranks"):
        references.append(SpellReference(spell_id, branch, "rank", filename, line, expected_name, aliases))
    for field, kind in (("variants", "variant"), ("appliesBuff", "applied_aura")):
        for spell_id in _number_array(payload, field):
            references.append(SpellReference(spell_id, branch, kind, filename, line))

    # Nested spellID fields are triggered/helper auras. The first occurrence is
    # the primary ID already recorded above.
    nested_ids = [int(value) for value in re.findall(r"\bspellID\s*=\s*(\d+)", payload)][1:]
    for spell_id in nested_ids:
        references.append(SpellReference(spell_id, branch, "triggered_aura", filename, line))

    reset_match = re.search(r"\bcooldownResetBy\s*=\s*(\{.*?\}|\d+)", payload, re.DOTALL)
    if reset_match:
        for value in re.findall(r"\d+", reset_match.group(1)):
            references.append(SpellReference(int(value), branch, "reset_source", filename, line))

    duration_match = re.search(r"\brankDurations\s*=\s*(\{.*?\})", payload, re.DOTALL)
    if duration_match:
        for value in re.findall(r"\[(\d+)\]\s*=", duration_match.group(1)):
            references.append(SpellReference(int(value), branch, "rank_duration", filename, line))
    return references


def parse_lua_file(path: Path) -> list[SpellReference]:
    if path.name in ITEM_SPELL_FIELDS:
        references: list[SpellReference] = []
        fields = "|".join(map(re.escape, ITEM_SPELL_FIELDS[path.name]))
        pattern = re.compile(rf"\b({fields})\s*=\s*(\d+)")
        for line, text in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
            for match in pattern.finditer(text):
                references.append(
                    SpellReference(int(match.group(2)), "tbc", match.group(1), path.name, line)
                )
        return references

    references: list[SpellReference] = []
    for block, line in iter_entry_blocks(path):
        base, overrides = _remove_named_table(block, "versionOverrides")
        primary_match = re.search(r"^\s*spellID\s*=\s*(\d+)", base, re.MULTILINE)
        if not primary_match:
            continue
        primary_id = int(primary_match.group(1))
        name = _scalar_string(base, "name")
        aliases = _string_array(base, "auditAliases")
        branch = _infer_branch(primary_id, _scalar_string(base, "auditBranch"))
        references.extend(
            _references_for_payload(
                base,
                branch=branch,
                filename=path.name,
                line=line,
                expected_name=name,
                aliases=aliases,
                include_stats=True,
            )
        )

        if overrides:
            for version, override_branch in (("vanilla", "classic"), ("tbc", "tbc")):
                payload = _named_subtable(overrides, version)
                if payload and re.search(r"\b(?:spellID|ranks)\s*=", payload):
                    # An override can replace only ranks while retaining the base
                    # primary ID, so synthesize the inherited ID when necessary.
                    if not re.search(r"\bspellID\s*=", payload):
                        payload = "{\nspellID = %d,\n%s\n}" % (primary_id, payload[1:-1])
                    references.extend(
                        _references_for_payload(
                            payload,
                            branch=override_branch,
                            filename=path.name,
                            line=line,
                            expected_name=name,
                            aliases=aliases,
                            include_stats=False,
                        )
                    )
    return references


def parse_all_files() -> dict[str, list[SpellReference]]:
    result: dict[str, list[SpellReference]] = {}
    for path in sorted(DATA_DIR.glob("*.lua")):
        if path.name not in NON_SPELL_FILES:
            result[path.name] = parse_lua_file(path)
    return result


def extract_cooldown(tooltip_html: str) -> float | None:
    match = re.search(r"<!--baseCooldown:(.+?)-->", tooltip_html or "")
    if not match:
        return None
    for unit, multiplier in (("hr", 3600), ("min", 60), ("sec", 1)):
        value = re.search(rf"([\d.]+)\s*{unit}", match.group(1))
        if value:
            return float(value.group(1)) * multiplier
    return None


def extract_duration(buff_html: str) -> float | None:
    match = re.search(
        r'<span class="q">([\d.]+)\s*(seconds?|minutes?|hours?)\s*remaining</span>',
        buff_html or "",
    )
    if not match:
        return None
    multiplier = 3600 if "hour" in match.group(2) else 60 if "minute" in match.group(2) else 1
    return float(match.group(1)) * multiplier


def extract_description(tooltip_html: str) -> str | None:
    matches = re.findall(r'<div class="q">(.*?)</div>', tooltip_html or "", re.DOTALL)
    if not matches:
        return None
    text = re.sub(r"<!--.*?-->|<[^>]+>", "", matches[-1], flags=re.DOTALL)
    return re.sub(r"\s+", " ", unescape(text).replace("\xa0", " ")).strip() or None


class WowheadClient:
    def __init__(self, cache_path: Path | None, max_age_hours: float, delay: float):
        self.cache_path = cache_path
        self.max_age = max_age_hours * 3600
        self.delay = delay
        self.cache: dict[str, dict] = {}
        if cache_path and cache_path.exists():
            try:
                document = json.loads(cache_path.read_text(encoding="utf-8"))
                if document.get("schema") == 1:
                    self.cache = document.get("entries", {})
            except (OSError, ValueError):
                self.cache = {}

    def fetch(self, branch: str, spell_id: int) -> dict:
        key = f"{branch}:{spell_id}"
        now = time.time()
        cached = self.cache.get(key)
        if cached and now - cached.get("fetched_at_epoch", 0) <= self.max_age:
            return cached["payload"]
        url = WOWHEAD_URL.format(branch=branch, spell_id=spell_id)
        try:
            payload = json.loads(_request_text(url))
        except urllib.error.HTTPError as error:
            payload = {"error": f"http_{error.code}"}
        except Exception as error:  # network failures must remain distinguishable from 404s
            payload = {"error": "network", "detail": str(error)}
        self.cache[key] = {
            "branch": branch,
            "spell_id": spell_id,
            "source_url": url,
            "fetched_at": datetime.now(timezone.utc).isoformat(),
            "fetched_at_epoch": now,
            "payload": payload,
        }
        time.sleep(self.delay)
        return payload

    def save(self) -> None:
        if not self.cache_path:
            return
        self.cache_path.parent.mkdir(parents=True, exist_ok=True)
        document = {"schema": 1, "entries": self.cache}
        self.cache_path.write_text(json.dumps(document, indent=2, sort_keys=True), encoding="utf-8")


class WagoClient:
    def __init__(self, tbc_build: str | None = None, classic_build: str | None = None):
        builds = json.loads(_request_text(WAGO_BUILDS_URL))
        self.builds = {
            "tbc": tbc_build or self._latest(builds, TBC_PRODUCT),
            "classic": classic_build or self._latest(builds, CLASSIC_PRODUCT),
        }
        self.names: dict[str, dict[int, str]] = {}
        self.cooldowns: dict[str, dict[int, float]] = {}
        for branch, build in self.builds.items():
            self.names[branch] = self._load_names(build)
            self.cooldowns[branch] = self._load_cooldowns(build)

    @staticmethod
    def _latest(builds: dict, product: str) -> str:
        candidates = builds.get(product) or []
        if not candidates:
            raise RuntimeError(f"Wago returned no builds for {product}")
        return candidates[0]["version"]

    @staticmethod
    def _load_names(build: str) -> dict[int, str]:
        text = _request_text(WAGO_CSV_URL.format(table="SpellName", build=build))
        return {int(row["ID"]): row["Name_lang"] for row in csv.DictReader(io.StringIO(text))}

    @staticmethod
    def _load_cooldowns(build: str) -> dict[int, float]:
        text = _request_text(WAGO_CSV_URL.format(table="SpellCooldowns", build=build))
        result: dict[int, float] = {}
        for row in csv.DictReader(io.StringIO(text)):
            spell_id = int(row["SpellID"])
            milliseconds = max(int(row["RecoveryTime"]), int(row["CategoryRecoveryTime"]))
            if milliseconds:
                result[spell_id] = milliseconds / 1000
        return result


def normalize_name(name: str, *, rank: bool) -> str:
    normalized = re.sub(r"\s+", " ", name.strip()).casefold()
    return ROMAN_RANK_SUFFIX.sub("", normalized) if rank else normalized


def name_matches(actual: str, reference: SpellReference) -> bool:
    if not reference.expected_name:
        return True
    accepted = (reference.expected_name,) + reference.aliases
    rank = reference.kind == "rank"
    normalized_actual = normalize_name(actual, rank=rank)
    return any(normalized_actual == normalize_name(candidate, rank=rank) for candidate in accepted)


def _context(reference: SpellReference) -> str:
    return f"{reference.filename}:{reference.line} ({reference.kind})"


def audit(
    references: list[SpellReference],
    wowhead: WowheadClient,
    wago: WagoClient,
) -> list[Finding]:
    findings: list[Finding] = []
    grouped: dict[tuple[str, int], list[SpellReference]] = {}
    for reference in references:
        grouped.setdefault((reference.branch, reference.spell_id), []).append(reference)

    for index, ((branch, spell_id), contexts) in enumerate(sorted(grouped.items()), 1):
        wh = wowhead.fetch(branch, spell_id)
        wh_name = None if wh.get("error") else wh.get("name")
        wago_name = wago.names[branch].get(spell_id)
        context_labels = sorted({_context(reference) for reference in contexts})

        if wh_name is None and wago_name is None:
            findings.append(Finding("error", "confirmed_missing", spell_id, branch,
                                    "Both live sources have no spell record", context_labels))
            continue
        if wh_name is None or wago_name is None:
            findings.append(Finding("warning", "source_incomplete", spell_id, branch,
                                    "Only one live source returned this spell", context_labels,
                                    wh_name, wago_name))
            continue
        if normalize_name(wh_name, rank=False) != normalize_name(wago_name, rank=False):
            findings.append(Finding("warning", "source_conflict", spell_id, branch,
                                    "Wowhead and Wago disagree on spell identity", context_labels,
                                    wh_name, wago_name))
            continue

        strict_contexts = [reference for reference in contexts if reference.expected_name]
        mismatched = [reference for reference in strict_contexts if not name_matches(wh_name, reference)]
        if mismatched:
            expected = sorted({reference.expected_name for reference in mismatched if reference.expected_name})
            findings.append(Finding("error", "confirmed_name_mismatch", spell_id, branch,
                                    f"Authored identity {expected} disagrees with both live sources",
                                    sorted({_context(reference) for reference in mismatched}),
                                    wh_name, wago_name))

        for reference in contexts:
            if reference.kind != "primary" or reference.cooldown is None or reference.filename == "Procs.lua":
                continue
            wh_cooldown = extract_cooldown(wh.get("tooltip", ""))
            wago_cooldown = wago.cooldowns[branch].get(spell_id)
            if wh_cooldown is None or wago_cooldown is None:
                continue
            if wh_cooldown != wago_cooldown:
                findings.append(Finding("warning", "source_cooldown_conflict", spell_id, branch,
                                        "Wowhead and Wago disagree on cooldown", [_context(reference)],
                                        wh_cooldown, wago_cooldown))
            elif reference.cooldown != wh_cooldown:
                findings.append(Finding("error", "confirmed_cooldown_mismatch", spell_id, branch,
                                        f"Authored cooldown {reference.cooldown:g}s disagrees with both live sources",
                                        [_context(reference)], wh_cooldown, wago_cooldown))

        if index % 100 == 0:
            print(f"Checked {index}/{len(grouped)} unique branch/ID pairs...", file=sys.stderr)
    wowhead.save()
    return findings


def _flatten(parsed: dict[str, list[SpellReference]]) -> list[SpellReference]:
    return [reference for references in parsed.values() for reference in references]


def _parse_ids(values: list[str]) -> set[int]:
    result: set[int] = set()
    for value in values:
        result.update(int(item) for item in value.split(",") if item.strip())
    return result


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--audit", action="store_true", help="run the two-source live audit")
    parser.add_argument("--ids", action="append", default=[], help="comma-separated IDs to audit")
    parser.add_argument("--strict", action="store_true", help="exit nonzero for any error or source warning")
    parser.add_argument("--delay", type=float, default=0.15, help="delay after Wowhead requests")
    parser.add_argument("--no-cache", action="store_true", help="do not read or write the disposable cache")
    parser.add_argument("--cache", type=Path, default=DEFAULT_CACHE, help="disposable Wowhead cache path")
    parser.add_argument("--max-cache-age-hours", type=float, default=24)
    parser.add_argument("--tbc-build", help="override auto-discovered Wago Anniversary build")
    parser.add_argument("--classic-build", help="override auto-discovered Wago Classic Era build")
    parser.add_argument("--json-report", type=Path, help="write a machine-readable report")
    args = parser.parse_args(argv)

    if not args.audit:
        parser.print_help()
        return 2

    parsed = parse_all_files()
    references = _flatten(parsed)
    selected_ids = _parse_ids(args.ids)
    if selected_ids:
        references = [reference for reference in references if reference.spell_id in selected_ids]
    if not references:
        print("No matching spell references found.", file=sys.stderr)
        return 2

    print(f"Parsed {len(references)} references from {len(parsed)} data files.")
    wago = WagoClient(args.tbc_build, args.classic_build)
    print(f"Wago builds: TBC={wago.builds['tbc']} Classic={wago.builds['classic']}")
    wowhead = WowheadClient(None if args.no_cache else args.cache, args.max_cache_age_hours, args.delay)
    findings = audit(references, wowhead, wago)

    for finding in findings:
        print(f"[{finding.severity.upper()}] {finding.code} {finding.branch}:{finding.spell_id} - {finding.message}")
        if finding.wowhead is not None or finding.wago is not None:
            print(f"        Wowhead={finding.wowhead!r} Wago={finding.wago!r}")
        for context in finding.contexts:
            print(f"        {context}")

    counts = {severity: sum(item.severity == severity for item in findings) for severity in ("error", "warning")}
    print(f"Summary: {counts['error']} confirmed error(s), {counts['warning']} warning(s)")
    if args.json_report:
        args.json_report.parent.mkdir(parents=True, exist_ok=True)
        report = {
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "wago_builds": wago.builds,
            "findings": [asdict(finding) for finding in findings],
        }
        args.json_report.write_text(json.dumps(report, indent=2), encoding="utf-8")
    # Strict mode means the data was fully verified, not merely that no agreed
    # mismatch was found. A source outage or disagreement must fail the gate so
    # CI cannot approve committed data from only one source.
    return 1 if args.strict and findings else 0


if __name__ == "__main__":
    raise SystemExit(main())
