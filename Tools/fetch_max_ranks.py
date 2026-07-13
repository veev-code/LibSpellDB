#!/usr/bin/env python3
"""Compatibility entry point for auditing the highest authored spell ranks.

This no longer populates or trusts the committed Wowhead cache. It delegates to
the two-source live audit and verifies each family's highest rank with both
Wowhead and Wago DB2.
"""

from __future__ import annotations

import sys

import wowhead_audit


def max_rank_ids() -> list[int]:
    references = [
        reference
        for file_references in wowhead_audit.parse_all_files().values()
        for reference in file_references
    ]
    grouped: dict[tuple[str, int], list[wowhead_audit.SpellReference]] = {}
    for reference in references:
        grouped.setdefault((reference.filename, reference.line), []).append(reference)

    result: set[int] = set()
    for entry_references in grouped.values():
        ranks = [reference.spell_id for reference in entry_references if reference.kind == "rank"]
        if ranks:
            # Rank order is authored order; numeric spell IDs are not an API for
            # rank ordering and are not guaranteed to increase monotonically.
            result.add(ranks[-1])
    return sorted(result)


def main() -> int:
    spell_ids = max_rank_ids()
    args = ["--audit", "--strict", "--ids", ",".join(map(str, spell_ids)), *sys.argv[1:]]
    return wowhead_audit.main(args)


if __name__ == "__main__":
    raise SystemExit(main())
