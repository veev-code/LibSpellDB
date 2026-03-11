#!/usr/bin/env python3
"""
LibSpellDB Spell Data Validator

Parses all Data/*.lua files and validates spell definitions for correctness.
Designed to run in CI to catch data errors before release.

Checks:
  Aura targeting:
    1. Every spell with duration > 0 must have an explicit auraTarget field
    2. auraTarget value must be a valid constant (AT.SELF/ALLY/ENEMY/PET/NONE)
    3. Procs with onTarget=true must have auraTarget=AT.ENEMY
    4. Procs with onAlly=true must have auraTarget=AT.ALLY
    5. Files using auraTarget must import AT = lib.AuraTarget

  Tag validation:
    6. All tags must be valid constants defined in Categories.lua
    7. Mutually exclusive tags: MAJOR+MINOR
    8. TIMED_EFFECT tag requires duration > 0
   19. TIMED_EFFECT must have auraTarget=AT.NONE
   20. Duplicate tags within a spell
   21. Empty tags array

  Totem rules:
    9. TOTEM tag must have exactly one element tag (TOTEM_EARTH/FIRE/WATER/AIR)
   10. Element tags must have base TOTEM tag
   11. TOTEM spells with duration must have auraTarget=AT.NONE

  Rank ordering:
   12. ranks arrays must be sorted numerically ascending

  triggersAuras integrity:
   13. Each triggersAuras entry must have spellID, type, and onTarget fields

  Reference integrity:
   14. buffGroup values must reference a defined BuffGroup in Categories.lua
   15. sharedCooldownGroup values must reference a defined group in Categories.lua

  Proc metadata:
   16. procInfo must have description and stacks fields

  Structural:
   17. appliesBuff must be an array (contain comma or single ID), not missing brackets
   18. Duplicate spellIDs across all files

  Consistency:
   22. spellID must appear in its own ranks array (if ranks present)
   23. appliesBuff length must match ranks length (if both present)
   24. rankDurations keys must all appear in ranks array
   25. reactiveWindow/dodgeReactive requires REACTIVE tag
   26. singleTarget requires auraTarget ENEMY or ALLY
   27. sharedAura requires auraTarget ENEMY
   28. class must be a valid WoW class token or "SHARED"
   29. class field in RegisterSpells default must match filename
   30. (reserved)
   31. Every spell must resolve to a class (per-spell or RegisterSpells default)
   32. auraTarget consistency with tags (ENEMY↔BUFF/HAS_BUFF, SELF/ALLY/PET↔DEBUFF/HAS_DEBUFF/HAS_DOT)

Usage:
    python validate_spells.py           # from Tools/ directory
    python Tools/validate_spells.py     # from repo root

Exit code 0 = all checks pass, 1 = validation errors found.
"""

import re
import sys
from pathlib import Path

# Resolve directories relative to this script
SCRIPT_DIR = Path(__file__).parent
ROOT_DIR = SCRIPT_DIR.parent
DATA_DIR = ROOT_DIR / "Data"
CORE_DIR = ROOT_DIR / "Core"

# Valid auraTarget values (the AT.X constants resolve to these strings)
VALID_AURA_TARGETS = {"AT.SELF", "AT.ALLY", "AT.ENEMY", "AT.PET", "AT.NONE"}

# Files to skip (no spell registrations)
SKIP_FILES = {"Data.xml", "Trinkets.lua"}

# Totem element tags
TOTEM_ELEMENT_TAGS = {"TOTEM_EARTH", "TOTEM_FIRE", "TOTEM_WATER", "TOTEM_AIR"}

# Mutually exclusive tag pairs
# Note: ROTATIONAL+FILLER is allowed — a spell can be core rotation AND mana-gated spammable
# (e.g., Arcane Missiles, Chain Heal). Consumers filter on FILLER independently.
EXCLUSIVE_TAG_PAIRS = [
    ("MAJOR", "MINOR"),
]

# Valid WoW class tokens
VALID_CLASSES = {
    "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST",
    "SHAMAN", "MAGE", "WARLOCK", "DRUID", "SHARED",
}

# Expected class per filename (for cross-referencing RegisterSpells default class)
FILENAME_TO_CLASS = {
    "Warrior.lua": "WARRIOR",
    "Paladin.lua": "PALADIN",
    "Hunter.lua": "HUNTER",
    "Rogue.lua": "ROGUE",
    "Priest.lua": "PRIEST",
    "Shaman.lua": "SHAMAN",
    "Mage.lua": "MAGE",
    "Warlock.lua": "WARLOCK",
    "Druid.lua": "DRUID",
    "Racials.lua": "SHARED",
    "Procs.lua": "SHARED",
    "Externals.lua": "SHARED",
}


def extract_valid_tags(categories_path):
    """Extract all valid tag strings from Categories.lua."""
    content = categories_path.read_text(encoding="utf-8")
    tags = set()
    # Match patterns like: TAG_NAME = "TAG_NAME",
    for m in re.finditer(r'(\w+)\s*=\s*"(\w+)"', content):
        lua_key, lua_value = m.group(1), m.group(2)
        # Category constants have key == value (e.g., DPS = "DPS")
        if lua_key == lua_value:
            tags.add(lua_value)
    return tags


def extract_buff_groups(categories_path):
    """Extract all defined BuffGroup names from Categories.lua."""
    content = categories_path.read_text(encoding="utf-8")
    groups = set()
    # Match: GROUP_NAME = { in lib.BuffGroups block
    in_buff_groups = False
    brace_depth = 0
    for line in content.split("\n"):
        stripped = line.strip()
        if "lib.BuffGroups" in stripped and "=" in stripped:
            in_buff_groups = True
            brace_depth = stripped.count("{") - stripped.count("}")
            continue
        if in_buff_groups:
            brace_depth += stripped.count("{") - stripped.count("}")
            # Top-level keys at depth 1
            m = re.match(r"(\w+)\s*=\s*\{", stripped)
            if m and brace_depth >= 2:
                groups.add(m.group(1))
            if brace_depth <= 0:
                in_buff_groups = False
    return groups


def extract_shared_cd_groups(categories_path):
    """Extract all defined SharedCooldownGroup names from Categories.lua."""
    content = categories_path.read_text(encoding="utf-8")
    groups = set()
    in_shared_cd = False
    brace_depth = 0
    for line in content.split("\n"):
        stripped = line.strip()
        if "lib.SharedCooldownGroups" in stripped and "=" in stripped:
            in_shared_cd = True
            brace_depth = stripped.count("{") - stripped.count("}")
            continue
        if in_shared_cd:
            brace_depth += stripped.count("{") - stripped.count("}")
            m = re.match(r"(\w+)\s*=\s*\{", stripped)
            if m and brace_depth >= 2:
                groups.add(m.group(1))
            if brace_depth <= 0:
                in_shared_cd = False
    return groups


def parse_spell_blocks(lua_content, filepath):
    """
    Extract spell definition blocks from a Lua file.
    Yields (spell_dict, line_number) for each spell block found.
    """
    lines = lua_content.split("\n")
    in_register_block = False
    brace_depth = 0
    current_spell_lines = []
    current_spell_start = 0

    for i, line in enumerate(lines, 1):
        stripped = line.strip()

        if "lib:RegisterSpells(" in stripped:
            in_register_block = True
            brace_depth += stripped.count("{") - stripped.count("}")
            continue

        if not in_register_block:
            continue

        open_count = stripped.count("{")
        close_count = stripped.count("}")

        if brace_depth == 1 and open_count > 0 and stripped.startswith("{"):
            current_spell_lines = [stripped]
            current_spell_start = i
            brace_depth += open_count - close_count
            continue

        brace_depth += open_count - close_count

        if current_spell_lines:
            current_spell_lines.append(stripped)

            if brace_depth <= 1:
                spell_text = "\n".join(current_spell_lines)
                spell_data = parse_spell_fields(spell_text)
                if spell_data.get("spellID"):
                    yield spell_data, current_spell_start
                current_spell_lines = []

        if brace_depth <= 0:
            in_register_block = False
            brace_depth = 0


def parse_spell_fields(block_text):
    """Parse key-value pairs from a spell definition block."""
    fields = {}

    # spellID
    m = re.search(r"spellID\s*=\s*(\d+)", block_text)
    if m:
        fields["spellID"] = int(m.group(1))

    # name
    m = re.search(r'name\s*=\s*"([^"]*)"', block_text)
    if m:
        fields["name"] = m.group(1)

    # class (per-spell override)
    m = re.search(r'class\s*=\s*"(\w+)"', block_text)
    if m:
        fields["class"] = m.group(1)

    # duration (top-level only, not inside nested tables)
    m = re.search(r"^\s*duration\s*=\s*(\d+\.?\d*)", block_text, re.MULTILINE)
    if m:
        fields["duration"] = float(m.group(1))

    # cooldown
    m = re.search(r"^\s*cooldown\s*=\s*(\d+\.?\d*)", block_text, re.MULTILINE)
    if m:
        fields["cooldown"] = float(m.group(1))

    # auraTarget
    m = re.search(r"auraTarget\s*=\s*(AT\.\w+)", block_text)
    if m:
        fields["auraTarget"] = m.group(1)

    # selfOnly (legacy field)
    m = re.search(r"selfOnly\s*=\s*(true|false)", block_text)
    if m:
        fields["selfOnly"] = m.group(1)

    # singleTarget
    m = re.search(r"singleTarget\s*=\s*(true|false)", block_text)
    if m:
        fields["singleTarget"] = m.group(1)

    # sharedAura
    m = re.search(r"sharedAura\s*=\s*(true|false)", block_text)
    if m:
        fields["sharedAura"] = m.group(1)

    # reactiveWindow
    m = re.search(r"reactiveWindow\s*=\s*(\d+\.?\d*)", block_text)
    if m:
        fields["reactiveWindow"] = float(m.group(1))

    # dodgeReactive
    m = re.search(r"dodgeReactive\s*=\s*(\d+\.?\d*)", block_text)
    if m:
        fields["dodgeReactive"] = float(m.group(1))

    # tags - extract the tag references (C.TAG_NAME)
    tags_match = re.search(r"tags\s*=\s*\{([^}]*)\}", block_text)
    if tags_match:
        tag_text = tags_match.group(1)
        # Extract C.TAG_NAME references
        fields["tags"] = re.findall(r"C\.(\w+)", tag_text)
        fields["tags_raw"] = tag_text.strip()

    # ranks array - extract numeric IDs
    ranks_match = re.search(r"ranks\s*=\s*\{([^}]+)\}", block_text)
    if ranks_match:
        rank_text = ranks_match.group(1)
        rank_ids = [int(x) for x in re.findall(r"\d+", rank_text)]
        fields["ranks"] = rank_ids

    # rankDurations - extract keys
    rd_match = re.search(r"rankDurations\s*=\s*\{([^}]+)\}", block_text)
    if rd_match:
        rd_text = rd_match.group(1)
        # Keys are in [spellID] = value format
        rd_keys = [int(x) for x in re.findall(r"\[(\d+)\]", rd_text)]
        fields["rankDurations_keys"] = rd_keys

    # buffGroup
    m = re.search(r'buffGroup\s*=\s*"(\w+)"', block_text)
    if m:
        fields["buffGroup"] = m.group(1)

    # sharedCooldownGroup
    m = re.search(r'sharedCooldownGroup\s*=\s*"(\w+)"', block_text)
    if m:
        fields["sharedCooldownGroup"] = m.group(1)

    # procInfo block
    proc_match = re.search(r"procInfo\s*=\s*\{(.*?)\}", block_text, re.DOTALL)
    if proc_match:
        proc_text = proc_match.group(1)
        fields["has_procInfo"] = True

        m = re.search(r"onTarget\s*=\s*(true|false)", proc_text)
        if m:
            fields["procInfo.onTarget"] = m.group(1)
        m = re.search(r"onAlly\s*=\s*(true|false)", proc_text)
        if m:
            fields["procInfo.onAlly"] = m.group(1)

        # Check for required procInfo sub-fields
        fields["procInfo.has_description"] = bool(re.search(r'description\s*=\s*"', proc_text))
        fields["procInfo.has_stacks"] = bool(re.search(r'stacks\s*=\s*(false|\d+)', proc_text))

    # triggersAuras - check for required fields in each entry
    ta_match = re.search(r"triggersAuras\s*=\s*\{(.+)\}", block_text, re.DOTALL)
    if ta_match:
        ta_text = ta_match.group(1)
        fields["has_triggersAuras"] = True
        fields["triggersAuras.onTarget"] = None

        m = re.search(r"onTarget\s*=\s*(true|false)", ta_text)
        if m:
            fields["triggersAuras.onTarget"] = m.group(1)

        # Check each sub-entry has spellID
        fields["triggersAuras.has_spellID"] = bool(re.search(r"spellID\s*=\s*\d+", ta_text))
        fields["triggersAuras.has_type"] = bool(re.search(r'type\s*=\s*"(BUFF|DEBUFF)"', ta_text))
        fields["triggersAuras.has_onTarget"] = bool(re.search(r"onTarget\s*=\s*(true|false)", ta_text))

    # appliesBuff - check it's an array and extract IDs
    ab_match = re.search(r"appliesBuff\s*=\s*(\{[^}]+\}|\d+)", block_text)
    if ab_match:
        value = ab_match.group(1)
        fields["has_appliesBuff"] = True
        fields["appliesBuff_is_array"] = value.startswith("{")
        if value.startswith("{"):
            buff_ids = [int(x) for x in re.findall(r"\d+", value)]
            fields["appliesBuff_count"] = len(buff_ids)
        else:
            fields["appliesBuff_count"] = 1

    return fields


def extract_default_classes(lua_content):
    """Extract all default class arguments from lib:RegisterSpells(..., "CLASS") calls.

    Returns a list of (start_line, class_string) tuples, sorted by line number.
    Each entry marks the start of a RegisterSpells block with its default class.
    """
    results = []
    lines = lua_content.split("\n")
    # Track brace depth to find the closing ) of each RegisterSpells call
    in_register = False
    register_start = 0
    brace_depth = 0

    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if "lib:RegisterSpells(" in stripped:
            in_register = True
            register_start = i
            brace_depth = stripped.count("{") - stripped.count("}")
            # Check if it closes on the same line (unlikely but handle it)
            m = re.search(r'\}\s*,\s*"(\w+)"\s*\)', stripped)
            if m:
                results.append((register_start, m.group(1)))
                in_register = False
            continue
        if in_register:
            brace_depth += stripped.count("{") - stripped.count("}")
            if brace_depth <= 0:
                # End of RegisterSpells — check for class argument
                m = re.search(r'\}\s*,\s*"(\w+)"\s*\)', stripped)
                if m:
                    results.append((register_start, m.group(1)))
                else:
                    results.append((register_start, None))
                in_register = False

    return results


def get_default_class_for_line(register_blocks, line_num):
    """Given a spell's line number, find which RegisterSpells block it belongs to."""
    result = None
    for start_line, default_class in register_blocks:
        if start_line <= line_num:
            result = default_class
        else:
            break
    return result


def validate_spell(spell, line_num, filepath, valid_tags, buff_groups, shared_cd_groups, resolved_class=None):
    """Validate a single spell. Returns list of error strings."""
    errors = []
    spell_id = spell.get("spellID", "???")
    spell_name = spell.get("name", "unknown")
    duration = spell.get("duration", 0)
    aura_target = spell.get("auraTarget")
    self_only = spell.get("selfOnly")
    tags = spell.get("tags", [])
    label = f"[{spell_id}] {spell_name} ({filepath.name}:{line_num})"

    # === Aura targeting rules ===

    # Rule 1: duration > 0 requires auraTarget
    if duration > 0 and not aura_target:
        errors.append(f"MISSING auraTarget: {label} has duration={duration} but no auraTarget field")

    # Rule 2: auraTarget value must be valid
    if aura_target and aura_target not in VALID_AURA_TARGETS:
        errors.append(f"INVALID auraTarget: {label} has auraTarget={aura_target} (valid: {', '.join(sorted(VALID_AURA_TARGETS))})")

    # Rule 3: procInfo.onTarget=true should have auraTarget=AT.ENEMY
    if spell.get("procInfo.onTarget") == "true" and aura_target and aura_target != "AT.ENEMY":
        errors.append(f"MISMATCH: {label} has procInfo.onTarget=true but auraTarget={aura_target} (expected AT.ENEMY)")

    # Rule 4: procInfo.onAlly=true should have auraTarget=AT.ALLY
    if spell.get("procInfo.onAlly") == "true" and aura_target and aura_target != "AT.ALLY":
        errors.append(f"MISMATCH: {label} has procInfo.onAlly=true but auraTarget={aura_target} (expected AT.ALLY)")

    # === Tag validation ===

    # Rule 6: All tags must be valid
    for tag in tags:
        if tag not in valid_tags:
            errors.append(f"INVALID TAG: {label} has unknown tag '{tag}' (not defined in Categories.lua)")

    # Rule 7: Mutually exclusive tags
    tag_set = set(tags)
    for tag_a, tag_b in EXCLUSIVE_TAG_PAIRS:
        if tag_a in tag_set and tag_b in tag_set:
            errors.append(f"EXCLUSIVE TAGS: {label} has both {tag_a} and {tag_b} (mutually exclusive)")

    # Rule 8: TIMED_EFFECT requires duration > 0
    if "TIMED_EFFECT" in tag_set and duration <= 0:
        errors.append(f"TIMED_EFFECT: {label} has TIMED_EFFECT tag but duration={duration} (must be > 0)")

    # Rule 19: TIMED_EFFECT must have auraTarget=AT.NONE
    if "TIMED_EFFECT" in tag_set and aura_target and aura_target != "AT.NONE":
        errors.append(f"TIMED_EFFECT: {label} has TIMED_EFFECT tag but auraTarget={aura_target} (expected AT.NONE)")

    # Rule 20: Duplicate tags within a spell
    if len(tags) != len(set(tags)):
        seen = set()
        dupes = set()
        for tag in tags:
            if tag in seen:
                dupes.add(tag)
            seen.add(tag)
        errors.append(f"DUPLICATE TAGS: {label} has duplicate tag(s): {', '.join(sorted(dupes))}")

    # Rule 21: Empty tags array
    if "tags_raw" in spell and not tags:
        errors.append(f"EMPTY TAGS: {label} has empty tags array")

    # === Totem rules ===

    has_totem = "TOTEM" in tag_set
    element_tags = tag_set & TOTEM_ELEMENT_TAGS

    # Rule 9: TOTEM must have exactly one element tag
    if has_totem and len(element_tags) == 0:
        errors.append(f"TOTEM: {label} has TOTEM tag but no element tag (need one of {', '.join(sorted(TOTEM_ELEMENT_TAGS))})")
    if has_totem and len(element_tags) > 1:
        errors.append(f"TOTEM: {label} has TOTEM tag with multiple element tags: {', '.join(sorted(element_tags))} (need exactly one)")

    # Rule 10: Element tags require base TOTEM tag
    if element_tags and not has_totem:
        errors.append(f"TOTEM: {label} has element tag(s) {', '.join(sorted(element_tags))} but missing base TOTEM tag")

    # Rule 11: TOTEM spells with duration must have auraTarget=AT.NONE
    if has_totem and duration > 0 and aura_target and aura_target != "AT.NONE":
        errors.append(f"TOTEM: {label} is a totem but auraTarget={aura_target} (expected AT.NONE)")

    # === Rank ordering ===

    # Rule 12: ranks must be sorted ascending
    ranks = spell.get("ranks", [])
    if len(ranks) >= 2:
        for i in range(len(ranks) - 1):
            if ranks[i] >= ranks[i + 1]:
                errors.append(f"RANK ORDER: {label} ranks not sorted ascending: {ranks}")
                break

    # === triggersAuras integrity ===

    # Rule 13: triggersAuras entries must have required fields
    if spell.get("has_triggersAuras"):
        if not spell.get("triggersAuras.has_spellID"):
            errors.append(f"TRIGGERS_AURAS: {label} triggersAuras entry missing spellID")
        if not spell.get("triggersAuras.has_type"):
            errors.append(f"TRIGGERS_AURAS: {label} triggersAuras entry missing type (\"BUFF\" or \"DEBUFF\")")
        if not spell.get("triggersAuras.has_onTarget"):
            errors.append(f"TRIGGERS_AURAS: {label} triggersAuras entry missing onTarget (true/false)")

    # === Reference integrity ===

    # Rule 14: buffGroup must reference a defined group
    buff_group = spell.get("buffGroup")
    if buff_group and buff_group not in buff_groups:
        errors.append(f"BUFFGROUP: {label} references undefined buffGroup '{buff_group}'")

    # Rule 15: sharedCooldownGroup must reference a defined group
    shared_cd = spell.get("sharedCooldownGroup")
    if shared_cd and shared_cd not in shared_cd_groups:
        errors.append(f"SHARED_CD: {label} references undefined sharedCooldownGroup '{shared_cd}'")

    # === Proc metadata ===

    # Rule 16: procInfo must have description and stacks
    if spell.get("has_procInfo"):
        if not spell.get("procInfo.has_description"):
            errors.append(f"PROCINFO: {label} procInfo missing 'description' field")
        if not spell.get("procInfo.has_stacks"):
            errors.append(f"PROCINFO: {label} procInfo missing 'stacks' field (use false if no stacking)")

    # === Structural ===

    # Rule 17: appliesBuff must be an array
    if spell.get("has_appliesBuff") and not spell.get("appliesBuff_is_array"):
        errors.append(f"APPLIES_BUFF: {label} appliesBuff should be an array {{id1, id2}}, not a bare number")

    # === Consistency rules ===

    # Rule 22: spellID must appear in its own ranks array
    # Exception: procs where the tracked aura ID differs from talent rank IDs
    if ranks and spell_id != "???" and spell_id not in ranks and not spell.get("has_procInfo"):
        errors.append(f"SPELL_IN_RANKS: {label} spellID {spell_id} not found in its own ranks array: {ranks}")

    # Rule 23: appliesBuff length must match ranks length
    if ranks and spell.get("has_appliesBuff") and spell.get("appliesBuff_is_array"):
        ab_count = spell.get("appliesBuff_count", 0)
        if ab_count != len(ranks):
            errors.append(f"BUFF_RANK_MISMATCH: {label} appliesBuff has {ab_count} entries but ranks has {len(ranks)} (must match)")

    # Rule 24: rankDurations keys must all appear in ranks array
    rd_keys = spell.get("rankDurations_keys", [])
    if rd_keys and ranks:
        rank_set = set(ranks)
        orphaned = [k for k in rd_keys if k not in rank_set]
        if orphaned:
            errors.append(f"RANK_DURATIONS: {label} rankDurations has keys not in ranks: {orphaned}")

    # Rule 25: reactiveWindow/dodgeReactive requires REACTIVE tag
    has_reactive_field = spell.get("reactiveWindow") or spell.get("dodgeReactive")
    if has_reactive_field and "REACTIVE" not in tag_set:
        errors.append(f"REACTIVE: {label} has reactiveWindow/dodgeReactive but missing REACTIVE tag")

    # Rule 26: singleTarget requires auraTarget ENEMY or ALLY
    if spell.get("singleTarget") == "true" and aura_target:
        if aura_target not in ("AT.ENEMY", "AT.ALLY"):
            errors.append(f"SINGLE_TARGET: {label} has singleTarget=true but auraTarget={aura_target} (expected AT.ENEMY or AT.ALLY)")

    # Rule 27: sharedAura requires auraTarget ENEMY
    if spell.get("sharedAura") == "true" and aura_target:
        if aura_target != "AT.ENEMY":
            errors.append(f"SHARED_AURA: {label} has sharedAura=true but auraTarget={aura_target} (expected AT.ENEMY)")

    # Rule 28: class must be a valid WoW class token
    spell_class = spell.get("class")
    if spell_class and spell_class not in VALID_CLASSES:
        errors.append(f"INVALID CLASS: {label} has class='{spell_class}' (not a valid class token)")

    # Rule 31: Every spell must resolve to a class (per-spell or RegisterSpells default)
    if resolved_class is None:
        errors.append(f"MISSING CLASS: {label} has no class (set per-spell or use RegisterSpells with defaultClass)")

    # Rule 32: auraTarget consistency with tags
    # ENEMY auraTarget should not have BUFF/HAS_BUFF tags (it's a debuff, not a buff)
    # SELF/ALLY/PET auraTarget should not have DEBUFF/HAS_DEBUFF/HAS_DOT tags
    # Exception: spells with triggersAuras can have mixed buff/debuff via triggered auras
    if aura_target and not spell.get("has_triggersAuras"):
        tag_set = set(tags)
        if aura_target == "AT.ENEMY" and (tag_set & {"BUFF", "HAS_BUFF"}):
            bad_tags = ", ".join(sorted(tag_set & {"BUFF", "HAS_BUFF"}))
            errors.append(f"AURA_TAG_MISMATCH: {label} has auraTarget={aura_target} but also has buff tag(s): {bad_tags} (enemy auras are debuffs)")
        if aura_target in ("AT.SELF", "AT.ALLY", "AT.PET") and (tag_set & {"DEBUFF", "HAS_DEBUFF", "HAS_DOT"}):
            bad_tags = ", ".join(sorted(tag_set & {"DEBUFF", "HAS_DEBUFF", "HAS_DOT"}))
            errors.append(f"AURA_TAG_MISMATCH: {label} has auraTarget={aura_target} but also has debuff tag(s): {bad_tags} (self/ally auras are buffs)")

    return errors


def validate_file(filepath, valid_tags, buff_groups, shared_cd_groups):
    """Validate all spells in a single Lua file. Returns (errors, spell_id_list)."""
    errors = []
    spell_ids = []
    content = filepath.read_text(encoding="utf-8")

    # Rule 5: Check AT import exists if any spell uses auraTarget
    has_at_import = bool(re.search(r"local\s+AT\s*=\s*lib\.AuraTarget", content))
    spells_with_at = any(
        spell.get("auraTarget") for spell, _ in parse_spell_blocks(content, filepath)
    )
    if spells_with_at and not has_at_import:
        errors.append(f"MISSING IMPORT: {filepath.name} uses auraTarget but missing 'local AT = lib.AuraTarget'")

    # Extract all RegisterSpells default class arguments
    register_blocks = extract_default_classes(content)

    # Rule 29: default class in RegisterSpells should match filename (single-class files only)
    expected_class = FILENAME_TO_CLASS.get(filepath.name)
    if expected_class:
        unique_classes = set(c for _, c in register_blocks if c)
        # Only check single-class files (Procs.lua has multiple classes, skip it)
        if len(unique_classes) == 1:
            actual_class = unique_classes.pop()
            if actual_class != expected_class:
                errors.append(f"CLASS MISMATCH: {filepath.name} RegisterSpells default class is '{actual_class}' but expected '{expected_class}'")

    for spell, line_num in parse_spell_blocks(content, filepath):
        # Resolve class: per-spell override > default from enclosing RegisterSpells
        # Note: resolved_class may be None if neither is set (Rule 31 will catch this)
        default_class = get_default_class_for_line(register_blocks, line_num)
        resolved_class = spell.get("class") or default_class
        spell_ids.append((spell.get("spellID"), spell.get("name", "unknown"), resolved_class or "SHARED", filepath.name, line_num))
        errors.extend(validate_spell(spell, line_num, filepath, valid_tags, buff_groups, shared_cd_groups, resolved_class=resolved_class))

    return errors, spell_ids


def check_duplicate_spell_ids(all_spell_ids):
    """Rule 18: Check for duplicate spellIDs across all files.

    Allows duplicate spellIDs when they have different classes (cross-class spells
    like Mace Stun Effect shared between Warrior and Rogue).
    """
    errors = []
    seen = {}
    for spell_id, name, spell_class, filename, line_num in all_spell_ids:
        if spell_id in seen:
            prev_name, prev_class, prev_file, prev_line = seen[spell_id]
            if spell_class == prev_class:
                errors.append(
                    f"DUPLICATE SPELLID: [{spell_id}] {name} ({filename}:{line_num}) "
                    f"duplicates [{spell_id}] {prev_name} ({prev_file}:{prev_line}) — same class '{spell_class}'"
                )
        else:
            seen[spell_id] = (name, spell_class, filename, line_num)
    return errors


def main():
    if not DATA_DIR.is_dir():
        print(f"ERROR: Data directory not found: {DATA_DIR}")
        return 1

    categories_path = CORE_DIR / "Categories.lua"
    if not categories_path.is_file():
        print(f"ERROR: Categories.lua not found: {categories_path}")
        return 1

    # Extract valid constants from Categories.lua
    valid_tags = extract_valid_tags(categories_path)
    buff_groups = extract_buff_groups(categories_path)
    shared_cd_groups = extract_shared_cd_groups(categories_path)

    if not valid_tags:
        print("ERROR: No valid tags found in Categories.lua")
        return 1

    lua_files = sorted(DATA_DIR.glob("*.lua"))
    lua_files = [f for f in lua_files if f.name not in SKIP_FILES]

    if not lua_files:
        print(f"ERROR: No Lua files found in {DATA_DIR}")
        return 1

    all_errors = []
    all_spell_ids = []
    files_checked = 0
    spells_checked = 0

    for filepath in lua_files:
        content = filepath.read_text(encoding="utf-8")
        file_spell_count = sum(1 for _ in parse_spell_blocks(content, filepath))
        spells_checked += file_spell_count
        files_checked += 1

        errors, spell_ids = validate_file(filepath, valid_tags, buff_groups, shared_cd_groups)
        all_errors.extend(errors)
        all_spell_ids.extend(spell_ids)

    # Rule 18: Cross-file duplicate spellID check
    all_errors.extend(check_duplicate_spell_ids(all_spell_ids))

    # Report
    print(f"LibSpellDB Validation: checked {spells_checked} spells across {files_checked} files")
    print(f"  Valid tags: {len(valid_tags)}, BuffGroups: {len(buff_groups)}, SharedCDGroups: {len(shared_cd_groups)}")

    if all_errors:
        # Group errors by category for readability
        print(f"\n{len(all_errors)} error(s) found:\n")
        for error in all_errors:
            print(f"  ERROR: {error}")
        print(f"\nValidation FAILED with {len(all_errors)} error(s).")
        return 1
    else:
        print("\nAll checks passed.")
        return 0


if __name__ == "__main__":
    sys.exit(main())
