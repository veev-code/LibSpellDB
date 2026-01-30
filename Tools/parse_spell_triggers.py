#!/usr/bin/env python3
"""
LibSpellDB - Spell Trigger Parser

This script parses exported data from wago.tools to find spells where
the cast spell ID differs from the applied aura spell ID.

Usage:
1. Go to https://wago.tools/db2/SpellEffect
2. Select your build (e.g., wow_classic for TBC 3.4.3)
3. Export as CSV
4. Run: python parse_spell_triggers.py SpellEffect.csv

The script will identify:
- Spells with TRIGGER_SPELL effects (Effect = 64)
- Spells that apply different auras
"""

import csv
import sys
import json
from collections import defaultdict
from pathlib import Path

# Spell class families (from SpellClassSet in Spell.dbc)
SPELL_FAMILIES = {
    0: "GENERIC",
    1: "EVENTS",
    3: "MAGE",
    4: "WARRIOR",
    5: "WARLOCK",
    6: "PRIEST",
    7: "DRUID",
    8: "ROGUE",
    9: "HUNTER",
    10: "PALADIN",
    11: "SHAMAN",
    13: "POTION",
    15: "DEATHKNIGHT",
    17: "PET",
}

# Effect types we care about
EFFECT_TRIGGER_SPELL = 64
EFFECT_APPLY_AURA = 6
EFFECT_APPLY_AREA_AURA_PARTY = 35
EFFECT_APPLY_AREA_AURA_RAID = 65

# Known player ability spells to focus on (add more as needed)
# These are base spell IDs for common abilities
PLAYER_ABILITIES = {
    # Warrior
    100: "Charge",
    5246: "Intimidating Shout",
    2687: "Bloodrage",
    20252: "Intercept",
    
    # Druid
    770: "Faerie Fire",
    16857: "Faerie Fire (Feral)",
    339: "Entangling Roots",
    5211: "Bash",
    16979: "Feral Charge",
    
    # Mage
    122: "Frost Nova",
    12472: "Icy Veins",
    
    # Rogue
    2094: "Blind",
    1776: "Gouge",
    408: "Kidney Shot",
    
    # Hunter
    3044: "Arcane Shot",
    19386: "Wyvern Sting",
    
    # Paladin
    853: "Hammer of Justice",
    20066: "Repentance",
    
    # Priest
    8122: "Psychic Scream",
    605: "Mind Control",
    
    # Shaman
    8042: "Earth Shock",
    8056: "Frost Shock",
    
    # Warlock
    5782: "Fear",
    6789: "Death Coil",
    710: "Banish",
}


def parse_spell_effect_csv(filepath):
    """Parse SpellEffect.csv from wago.tools"""
    triggers = []
    
    with open(filepath, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            try:
                effect_type = int(row.get('Effect', 0))
                spell_id = int(row.get('SpellID', 0))
                trigger_spell = int(row.get('EffectTriggerSpell', 0))
                
                # Look for TRIGGER_SPELL effects with a different target spell
                if effect_type == EFFECT_TRIGGER_SPELL and trigger_spell > 0:
                    if trigger_spell != spell_id:
                        triggers.append({
                            'source_spell': spell_id,
                            'triggered_spell': trigger_spell,
                            'effect_index': int(row.get('EffectIndex', 0)),
                            'effect_type': 'TRIGGER_SPELL',
                        })
                        
            except (ValueError, KeyError) as e:
                continue
    
    return triggers


def parse_spell_csv(filepath):
    """Parse Spell.csv to get spell names and class families"""
    spells = {}
    
    if not Path(filepath).exists():
        return spells
        
    with open(filepath, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            try:
                spell_id = int(row.get('ID', 0))
                
                # Try different possible column names for the spell name
                name = (row.get('Name_lang', '') or 
                       row.get('Name', '') or 
                       row.get('Name_0', ''))
                
                spell_class = int(row.get('SpellClassSet', 0))
                
                spells[spell_id] = {
                    'name': name,
                    'class': SPELL_FAMILIES.get(spell_class, 'UNKNOWN'),
                    'spell_class_id': spell_class,
                }
            except (ValueError, KeyError):
                continue
    
    return spells


def find_class_relevant_triggers(triggers, spells, class_filter=None):
    """Filter triggers to only class-relevant spells"""
    
    relevant = []
    
    for trigger in triggers:
        source_id = trigger['source_spell']
        target_id = trigger['triggered_spell']
        
        source_info = spells.get(source_id, {})
        target_info = spells.get(target_id, {})
        
        spell_class = source_info.get('class', 'UNKNOWN')
        
        # Filter by class if specified
        if class_filter and spell_class != class_filter:
            continue
            
        # Skip generic/event spells unless they're known player abilities
        if spell_class in ('GENERIC', 'EVENTS', 'UNKNOWN'):
            if source_id not in PLAYER_ABILITIES:
                continue
        
        relevant.append({
            'source_spell_id': source_id,
            'source_spell_name': source_info.get('name', 'Unknown'),
            'triggered_spell_id': target_id,
            'triggered_spell_name': target_info.get('name', 'Unknown'),
            'class': spell_class,
            'effect_type': trigger['effect_type'],
        })
    
    return relevant


def generate_lua_code(triggers):
    """Generate LibSpellDB appliesAura snippets"""
    
    output = []
    
    # Group by class
    by_class = defaultdict(list)
    for t in triggers:
        by_class[t['class']].append(t)
    
    for class_name in sorted(by_class.keys()):
        output.append(f"\n-- {class_name}")
        output.append("-" * 60)
        
        for t in sorted(by_class[class_name], key=lambda x: x['source_spell_id']):
            snippet = f"""{{
    spellID = {t['source_spell_id']},  -- {t['source_spell_name']}
    -- TODO: Add tags and other fields
    appliesAura = {{
        spellID = {t['triggered_spell_id']},  -- {t['triggered_spell_name']}
        type = "DEBUFF",  -- Verify: BUFF or DEBUFF?
        onTarget = true,  -- Verify: onTarget or onPlayer?
    }},
}},"""
            output.append(snippet)
    
    return '\n'.join(output)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        print("\nUsage: python parse_spell_triggers.py <SpellEffect.csv> [Spell.csv]")
        print("\nTo get the CSV files:")
        print("1. Go to https://wago.tools/db2/SpellEffect")
        print("2. Select build: wow_classic (for TBC 3.4.3)")
        print("3. Click 'Export CSV'")
        print("4. Optionally also export Spell.csv for names")
        sys.exit(1)
    
    effect_csv = sys.argv[1]
    spell_csv = sys.argv[2] if len(sys.argv) > 2 else None
    
    print(f"Parsing {effect_csv}...")
    triggers = parse_spell_effect_csv(effect_csv)
    print(f"Found {len(triggers)} spells with TRIGGER_SPELL effects")
    
    spells = {}
    if spell_csv:
        print(f"Parsing {spell_csv} for spell names...")
        spells = parse_spell_csv(spell_csv)
        print(f"Loaded {len(spells)} spell definitions")
    
    # Filter to relevant class spells
    relevant = find_class_relevant_triggers(triggers, spells)
    print(f"\nFiltered to {len(relevant)} class-relevant triggers")
    
    # Group by class for display
    by_class = defaultdict(list)
    for t in relevant:
        by_class[t['class']].append(t)
    
    print("\n" + "=" * 70)
    print("SPELL TRIGGER MAPPINGS (Cast Spell -> Triggered Aura)")
    print("=" * 70)
    
    for class_name in sorted(by_class.keys()):
        print(f"\n### {class_name} ###")
        for t in sorted(by_class[class_name], key=lambda x: x['source_spell_id']):
            print(f"  {t['source_spell_id']:5d} {t['source_spell_name'][:30]:30s} -> "
                  f"{t['triggered_spell_id']:5d} {t['triggered_spell_name']}")
    
    # Generate Lua code
    lua_output = generate_lua_code(relevant)
    
    output_file = Path(effect_csv).stem + "_triggers.lua"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- Auto-generated spell trigger mappings\n")
        f.write("-- Review and add to appropriate class files in LibSpellDB/Data/\n\n")
        f.write(lua_output)
    
    print(f"\nLua code written to: {output_file}")
    
    # Also save JSON for programmatic use
    json_output = Path(effect_csv).stem + "_triggers.json"
    with open(json_output, 'w', encoding='utf-8') as f:
        json.dump(relevant, f, indent=2)
    
    print(f"JSON data written to: {json_output}")


if __name__ == '__main__':
    main()
