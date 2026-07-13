#!/usr/bin/env python3
"""Offline regression tests for the live spell-data audit."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path


TOOLS_DIR = Path(__file__).resolve().parent
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

import wowhead_audit as audit  # noqa: E402


class FakeWowhead:
    def __init__(self, payloads):
        self.payloads = payloads

    def fetch(self, branch, spell_id):
        return self.payloads[(branch, spell_id)]

    def save(self):
        pass


class FakeWago:
    def __init__(self, names, cooldowns=None):
        self.names = names
        self.cooldowns = cooldowns or {"tbc": {}, "classic": {}}


class NamePolicyTests(unittest.TestCase):
    def test_rank_roman_numeral_is_normalized(self):
        reference = audit.SpellReference(8686, "tbc", "rank", "Rogue.lua", 1, "Instant Poison")
        self.assertTrue(audit.name_matches("Instant Poison II", reference))

    def test_explicit_alias_is_accepted(self):
        reference = audit.SpellReference(
            10326, "tbc", "rank", "Paladin.lua", 1, "Turn Undead", ("Turn Evil",)
        )
        self.assertTrue(audit.name_matches("Turn Evil", reference))

    def test_primary_name_is_not_fuzzily_matched(self):
        reference = audit.SpellReference(33938, "tbc", "primary", "Mage.lua", 1, "Fire Blast")
        self.assertFalse(audit.name_matches("Pyroblast", reference))

    def test_rank_duration_values_are_not_treated_as_spell_ids(self):
        payload = """{
spellID = 3599,
name = \"Searing Totem\",
rankDurations = {[3599] = 30, [6363] = 35},
}"""
        references = audit._references_for_payload(
            payload, branch="tbc", filename="Shaman.lua", line=1,
            expected_name="Searing Totem", aliases=(), include_stats=True,
        )
        duration_ids = {item.spell_id for item in references if item.kind == "rank_duration"}
        self.assertEqual(duration_ids, {3599, 6363})


class ConsensusTests(unittest.TestCase):
    def test_agreed_sources_confirm_mismatch(self):
        reference = audit.SpellReference(33938, "tbc", "rank", "Mage.lua", 1, "Fire Blast")
        wowhead = FakeWowhead({("tbc", 33938): {"name": "Pyroblast", "tooltip": ""}})
        wago = FakeWago({"tbc": {33938: "Pyroblast"}, "classic": {}})
        findings = audit.audit([reference], wowhead, wago)
        self.assertEqual([item.code for item in findings], ["confirmed_name_mismatch"])

    def test_source_disagreement_is_not_a_confirmed_data_error(self):
        reference = audit.SpellReference(33938, "tbc", "rank", "Mage.lua", 1, "Fire Blast")
        wowhead = FakeWowhead({("tbc", 33938): {"name": "Pyroblast", "tooltip": ""}})
        wago = FakeWago({"tbc": {33938: "Fire Blast"}, "classic": {}})
        findings = audit.audit([reference], wowhead, wago)
        self.assertEqual([item.code for item in findings], ["source_conflict"])
        self.assertEqual(findings[0].severity, "warning")

    def test_cooldown_requires_source_consensus(self):
        reference = audit.SpellReference(29858, "tbc", "primary", "Warlock.lua", 1,
                                         "Soulshatter", cooldown=180)
        tooltip = "<!--baseCooldown:5 min cooldown-->"
        wowhead = FakeWowhead({("tbc", 29858): {"name": "Soulshatter", "tooltip": tooltip}})
        wago = FakeWago({"tbc": {29858: "Soulshatter"}, "classic": {}},
                        {"tbc": {29858: 300.0}, "classic": {}})
        findings = audit.audit([reference], wowhead, wago)
        self.assertEqual([item.code for item in findings], ["confirmed_cooldown_mismatch"])


class RepositoryRegressionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.references = [
            reference
            for references in audit.parse_all_files().values()
            for reference in references
        ]

    def _ranks(self, filename, line_spell_id):
        primaries = [
            reference for reference in self.references
            if reference.filename == filename
            and reference.kind == "primary"
            and reference.spell_id == line_spell_id
        ]
        self.assertEqual(len(primaries), 1)
        line = primaries[0].line
        return {
            reference.spell_id for reference in self.references
            if reference.filename == filename and reference.line == line and reference.kind == "rank"
        }

    def test_corrected_tbc_rank_families(self):
        self.assertEqual(self._ranks("Mage.lua", 2136),
                         {2136, 2137, 2138, 8412, 8413, 10197, 10199, 27078, 27079})
        self.assertEqual(self._ranks("Paladin.lua", 853), {853, 5588, 5589, 10308})
        self.assertEqual(self._ranks("Paladin.lua", 20925), {20925, 20927, 20928, 27179})
        self.assertEqual(self._ranks("Priest.lua", 586),
                         {586, 9578, 9579, 9592, 10941, 10942, 25429})
        self.assertEqual(self._ranks("Priest.lua", 724), {724, 27870, 27871, 28275})
        self.assertEqual(self._ranks("Priest.lua", 32996), {32379, 32996})
        self.assertEqual(self._ranks("Priest.lua", 34914), {34914, 34916, 34917})
        self.assertEqual(self._ranks("Rogue.lua", 2983), {2983, 8696, 11305})
        self.assertEqual(self._ranks("Warrior.lua", 694), {694, 7400, 7402, 20559, 20560, 25266})

    def test_sod_warlock_identities_are_separate(self):
        primaries = {
            reference.spell_id: reference.expected_name
            for reference in self.references
            if reference.filename == "Warlock.lua" and reference.kind == "primary"
        }
        self.assertEqual(primaries[403789], "Metamorphosis")
        self.assertEqual(primaries[412789], "Demonic Howl")
        self.assertEqual(primaries[412758], "Incinerate")

    def test_classic_only_insignias_use_classic_source(self):
        branches = {
            reference.spell_id: reference.branch
            for reference in self.references
            if reference.filename == "Racials.lua" and reference.spell_id in {23273, 23276}
        }
        self.assertEqual(branches, {23273: "classic", 23276: "classic"})

    def test_classic_only_hot_streak_proc_uses_classic_source(self):
        matches = [
            reference for reference in self.references
            if reference.filename == "Procs.lua" and reference.spell_id == 48108
        ]
        self.assertTrue(matches)
        self.assertEqual({reference.branch for reference in matches}, {"classic"})

    def test_item_table_spell_references_are_included(self):
        kinds = {
            reference.kind for reference in self.references
            if reference.filename in {"Consumables.lua", "Potions.lua", "Trinkets.lua"}
        }
        self.assertIn("buffSpellID", kinds)
        self.assertIn("procBuffID", kinds)

    def test_major_holy_protection_uses_the_live_buff_id(self):
        matches = [
            reference for reference in self.references
            if reference.filename == "Potions.lua" and reference.kind == "buffSpellID"
        ]
        self.assertIn(28538, {reference.spell_id for reference in matches})
        self.assertNotIn(28510, {reference.spell_id for reference in matches})


if __name__ == "__main__":
    unittest.main()
