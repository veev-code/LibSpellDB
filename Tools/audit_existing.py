#!/usr/bin/env python3
"""
LibSpellDB Focused Audit Tool

Compares existing LibSpellDB entries against wago.tools CSV data to find:
1. Missing ranks for existing abilities
2. Missing trigger mappings for existing abilities
3. Abilities that might need triggersAuras added

Usage:
    python audit_existing.py <SpellName.csv> <Spell.csv> <SpellEffect.csv>
"""

import csv
import re
import os
from collections import defaultdict
from pathlib import Path

# TBC player spell IDs are generally under this threshold
# NPC/mob versions often have much higher IDs
MAX_PLAYER_SPELL_ID = 50000

# Spell IDs that are known to be player abilities (for edge cases)
KNOWN_PLAYER_SPELL_IDS = {
    # Add any edge cases here
}

# Spell IDs known to be NPC/mob versions (to exclude)
KNOWN_NPC_SPELL_IDS = {
    # Common false positives
    18350,  # Unknown passive
}


def load_spell_names(filepath):
    """Load SpellName.csv: ID -> Name"""
    names = {}
    with open(filepath, 'r', encoding='utf-8-sig') as f:
        reader = csv.reader(f)
        next(reader)  # Skip header
        for row in reader:
            if len(row) >= 2:
                spell_id = int(row[0])
                name = row[1]
                names[spell_id] = name
    return names


def load_spell_data(filepath):
    """Load Spell.csv: ID -> {rank, description, auraDescription}"""
    spells = {}
    with open(filepath, 'r', encoding='utf-8-sig') as f:
        reader = csv.reader(f)
        next(reader)  # Skip header
        for row in reader:
            if len(row) >= 4:
                spell_id = int(row[0])
                spells[spell_id] = {
                    'rank': row[1],  # NameSubtext_lang (e.g., "Rank 1")
                    'description': row[2],
                    'auraDescription': row[3],
                }
    return spells


def load_spell_effects(filepath):
    """Load SpellEffect.csv and extract trigger mappings"""
    triggers = defaultdict(list)  # source_spell_id -> [triggered_spell_ids]
    
    with open(filepath, 'r', encoding='utf-8-sig') as f:
        reader = csv.reader(f)
        header = next(reader)
        
        # Find column indices
        trigger_idx = header.index('EffectTriggerSpell') if 'EffectTriggerSpell' in header else 18
        spell_id_idx = header.index('SpellID') if 'SpellID' in header else -1
        
        for row in reader:
            if len(row) > max(trigger_idx, spell_id_idx):
                try:
                    source_spell_id = int(row[spell_id_idx])
                    triggered_spell_id = int(row[trigger_idx])
                    
                    if triggered_spell_id > 0 and triggered_spell_id != source_spell_id:
                        if triggered_spell_id not in triggers[source_spell_id]:
                            triggers[source_spell_id].append(triggered_spell_id)
                except (ValueError, IndexError):
                    continue
    
    return triggers


def parse_rank_number(rank_str):
    """Extract rank number from 'Rank X' string"""
    if not rank_str:
        return None
    match = re.search(r'Rank\s*(\d+)', rank_str, re.IGNORECASE)
    if match:
        return int(match.group(1))
    return None


def is_likely_player_spell(spell_id, spell_data, base_spell_id=None):
    """Determine if a spell ID is likely a player ability vs NPC version"""
    # Explicit exclusions
    if spell_id in KNOWN_NPC_SPELL_IDS:
        return False
    
    # Explicit inclusions
    if spell_id in KNOWN_PLAYER_SPELL_IDS:
        return True
    
    # High spell IDs are usually NPC versions
    if spell_id > MAX_PLAYER_SPELL_ID:
        return False
    
    data = spell_data.get(spell_id, {})
    rank = data.get('rank', '')
    
    # Must have a proper rank for ranked abilities, or be close to base ID
    if base_spell_id:
        # For ranked abilities, check if it has "Rank X" pattern
        if 'Rank' in rank:
            return True
        # Or if it's very close to the base ID (likely same spell family)
        if abs(spell_id - base_spell_id) < 2000:
            return True
        return False
    
    # Standalone check - must have Rank or be a known pattern
    if 'Rank' in rank:
        return True
    
    # Check for other player ability patterns
    if rank in ['', 'Passive', 'Racial', 'Shapeshift', 'Summon']:
        return True
    
    return False


def find_player_ranks(spell_names, spell_data, base_name, base_id):
    """Find all player spell IDs that are ranks of the same ability"""
    matches = []
    base_name_lower = base_name.lower().strip()
    
    for spell_id, name in spell_names.items():
        # Must match name exactly
        if name.lower().strip() != base_name_lower:
            continue
        
        # Must be a likely player spell
        if not is_likely_player_spell(spell_id, spell_data, base_id):
            continue
        
        data = spell_data.get(spell_id, {})
        rank_str = data.get('rank', '')
        rank_num = parse_rank_number(rank_str)
        
        matches.append({
            'id': spell_id,
            'name': name,
            'rank': rank_str,
            'rank_num': rank_num,
        })
    
    # Sort by rank number (if available) then by ID
    matches.sort(key=lambda x: (x['rank_num'] or 0, x['id']))
    
    return matches


def parse_existing_libspelldb(data_dir):
    """Parse existing LibSpellDB Lua files to extract spell definitions"""
    spells_by_class = {}
    
    class_files = {
        'Warrior.lua': 'WARRIOR',
        'Druid.lua': 'DRUID', 
        'Hunter.lua': 'HUNTER',
        'Mage.lua': 'MAGE',
        'Paladin.lua': 'PALADIN',
        'Priest.lua': 'PRIEST',
        'Rogue.lua': 'ROGUE',
        'Shaman.lua': 'SHAMAN',
        'Warlock.lua': 'WARLOCK',
    }
    
    for filename, class_name in class_files.items():
        filepath = os.path.join(data_dir, filename)
        if not os.path.exists(filepath):
            continue
            
        spells_by_class[class_name] = []
        
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find spell blocks with spellID
        # Match the whole spell entry more carefully
        spell_entries = re.findall(
            r'\{\s*\n\s*spellID\s*=\s*(\d+),.*?(?=\n\s*\{|\n\s*\},\s*"|\Z)',
            content,
            re.DOTALL
        )
        
        for entry in spell_entries:
            if isinstance(entry, tuple):
                spell_id = int(entry[0])
                block = entry[1] if len(entry) > 1 else ""
            else:
                spell_id = int(entry)
                # Re-find the full block for this spell
                block_match = re.search(
                    rf'\{{\s*\n\s*spellID\s*=\s*{spell_id},(.+?)(?=\n\s*\{{|\n\s*\}},\s*"|\Z)',
                    content,
                    re.DOTALL
                )
                block = block_match.group(1) if block_match else ""
            
            # Extract ranks
            ranks = [spell_id]
            ranks_match = re.search(r'ranks\s*=\s*\{([^}]+)\}', block)
            if ranks_match:
                for rank_id in re.findall(r'(\d+)', ranks_match.group(1)):
                    rid = int(rank_id)
                    if rid not in ranks:
                        ranks.append(rid)
            
            # Check for triggersAuras
            has_triggers = 'triggersAuras' in block
            trigger_ids = []
            if has_triggers:
                triggers_match = re.search(r'triggersAuras\s*=\s*\{(.+?)\}\s*,?\s*\n\s*\}', block, re.DOTALL)
                if triggers_match:
                    for tid in re.findall(r'spellID\s*=\s*(\d+)', triggers_match.group(1)):
                        trigger_ids.append(int(tid))
            
            spells_by_class[class_name].append({
                'base_id': spell_id,
                'ranks': sorted(ranks),
                'has_triggers': has_triggers,
                'trigger_ids': trigger_ids,
            })
    
    return spells_by_class


def main():
    import sys
    
    if len(sys.argv) < 4:
        print("Usage: python audit_existing.py <SpellName.csv> <Spell.csv> <SpellEffect.csv>")
        sys.exit(1)
    
    spell_name_file = sys.argv[1]
    spell_file = sys.argv[2]
    spell_effect_file = sys.argv[3]
    
    print("Loading spell data...")
    spell_names = load_spell_names(spell_name_file)
    spell_data = load_spell_data(spell_file)
    spell_triggers = load_spell_effects(spell_effect_file)
    
    print(f"Loaded {len(spell_names)} spell names")
    print(f"Loaded {len(spell_data)} spell data entries")
    print(f"Found {len(spell_triggers)} spells with triggers")
    
    # Find LibSpellDB Data directory
    script_dir = Path(__file__).parent
    data_dir = script_dir.parent / 'Data'
    
    print(f"\nParsing existing LibSpellDB from {data_dir}...")
    existing_spells = parse_existing_libspelldb(data_dir)
    
    print("\n" + "=" * 80)
    print("AUDIT RESULTS (Filtered for player abilities only)")
    print("=" * 80)
    
    # Collect all issues for summary
    all_missing_ranks = []
    all_missing_triggers = []
    
    for class_name, spells in sorted(existing_spells.items()):
        if not spells:
            continue
            
        print(f"\n{'=' * 60}")
        print(f"{class_name}")
        print(f"{'=' * 60}")
        
        class_missing_ranks = []
        class_missing_triggers = []
        
        for spell in spells:
            base_id = spell['base_id']
            current_ranks = set(spell['ranks'])
            has_triggers = spell['has_triggers']
            current_trigger_ids = set(spell['trigger_ids'])
            
            base_name = spell_names.get(base_id, f"Unknown({base_id})")
            
            issues = []
            
            # 1. Check for missing ranks (filtered for player spells only)
            all_ranks = find_player_ranks(spell_names, spell_data, base_name, base_id)
            all_rank_ids = set(r['id'] for r in all_ranks)
            missing_ranks = all_rank_ids - current_ranks
            
            if missing_ranks:
                # Format with rank numbers
                missing_info = []
                for r in all_ranks:
                    if r['id'] in missing_ranks:
                        rank_str = f" ({r['rank']})" if r['rank'] else ""
                        missing_info.append(f"{r['id']}{rank_str}")
                
                if missing_info:
                    issues.append(f"MISSING RANKS: {', '.join(missing_info)}")
                    class_missing_ranks.append({
                        'base_id': base_id,
                        'base_name': base_name,
                        'current_ranks': sorted(current_ranks),
                        'missing': [(r['id'], r['rank']) for r in all_ranks if r['id'] in missing_ranks],
                    })
            
            # 2. Check for trigger mappings we might be missing
            if not has_triggers:
                for rank_id in current_ranks:
                    if rank_id in spell_triggers:
                        triggered = spell_triggers[rank_id]
                        for tid in triggered:
                            # Filter for likely player-relevant triggers
                            if tid > MAX_PLAYER_SPELL_ID:
                                continue
                            if tid in KNOWN_NPC_SPELL_IDS:
                                continue
                            
                            tname = spell_names.get(tid, f"Unknown({tid})")
                            
                            # Filter out obvious non-player triggers
                            if "Unknown" in tname:
                                continue
                            
                            issues.append(f"NEEDS TRIGGER: {rank_id} -> {tid} ({tname})")
                            class_missing_triggers.append({
                                'base_id': base_id,
                                'base_name': base_name,
                                'source_id': rank_id,
                                'trigger_id': tid,
                                'trigger_name': tname,
                            })
            
            if issues:
                rank_info = spell_data.get(base_id, {}).get('rank', '')
                print(f"\n  {base_name} (ID: {base_id}) {rank_info}")
                print(f"    Current ranks: {sorted(current_ranks)}")
                for issue in issues:
                    print(f"    -> {issue}")
        
        all_missing_ranks.extend(class_missing_ranks)
        all_missing_triggers.extend(class_missing_triggers)
        
        if not class_missing_ranks and not class_missing_triggers:
            print("  No issues found!")
    
    # Print summary for easy copying
    print("\n" + "=" * 80)
    print("SUMMARY - MISSING RANKS TO ADD")
    print("=" * 80)
    
    for class_name, spells in sorted(existing_spells.items()):
        class_issues = [m for m in all_missing_ranks if m['base_id'] in [s['base_id'] for s in spells]]
        if class_issues:
            print(f"\n-- {class_name}")
            for issue in class_issues:
                missing_ids = [str(m[0]) for m in issue['missing']]
                print(f"-- {issue['base_name']}: ranks = {{{', '.join(map(str, issue['current_ranks'] + [int(m[0]) for m in issue['missing']]))}}}")
    
    print("\n" + "=" * 80)
    print("SUMMARY - TRIGGER MAPPINGS TO ADD")
    print("=" * 80)
    
    for class_name, spells in sorted(existing_spells.items()):
        class_triggers = [m for m in all_missing_triggers if m['base_id'] in [s['base_id'] for s in spells]]
        if class_triggers:
            print(f"\n-- {class_name}")
            # Group by base ability
            by_ability = defaultdict(list)
            for t in class_triggers:
                by_ability[t['base_name']].append(t)
            
            for ability, triggers in sorted(by_ability.items()):
                print(f"-- {ability}:")
                for t in triggers:
                    print(f"--   triggersAuras = {{ {{ spellID = {t['trigger_id']}, type = \"DEBUFF\", onTarget = true }} }},  -- {t['trigger_name']}")
    
    # Generate Lua snippet file
    output_file = script_dir / 'missing_data.lua'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- Auto-generated missing spell data from wago.tools audit\n")
        f.write("-- Review and merge into class files manually\n\n")
        
        for class_name, spells in sorted(existing_spells.items()):
            class_ranks = [m for m in all_missing_ranks if m['base_id'] in [s['base_id'] for s in spells]]
            class_triggers = [m for m in all_missing_triggers if m['base_id'] in [s['base_id'] for s in spells]]
            
            if class_ranks or class_triggers:
                f.write(f"-- {class_name}\n")
                f.write("-" * 60 + "\n")
                
                if class_ranks:
                    f.write("-- Missing Ranks:\n")
                    for issue in class_ranks:
                        all_ids = sorted(set(issue['current_ranks'] + [m[0] for m in issue['missing']]))
                        f.write(f"-- {issue['base_name']} ({issue['base_id']}): ranks = {{{', '.join(map(str, all_ids))}}}\n")
                
                if class_triggers:
                    f.write("-- Missing Triggers:\n")
                    by_ability = defaultdict(list)
                    for t in class_triggers:
                        by_ability[(t['base_id'], t['base_name'])].append(t)
                    
                    for (base_id, ability), triggers in sorted(by_ability.items()):
                        f.write(f"-- {ability} ({base_id}):\n")
                        f.write("--   triggersAuras = {\n")
                        for t in triggers:
                            f.write(f"--       {{ spellID = {t['trigger_id']}, type = \"DEBUFF\", onTarget = true }},  -- {t['trigger_name']}\n")
                        f.write("--   },\n")
                
                f.write("\n")
    
    print(f"\n\nDetailed output written to: {output_file}")


if __name__ == '__main__':
    main()
