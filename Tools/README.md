# LibSpellDB Tools

This folder contains tools to help identify spells where the cast spell ID differs from the applied aura spell ID.

## Why This Matters

In WoW, many abilities apply buffs/debuffs with **different spell IDs** than the ability itself. For example:
- Warrior's **Charge** (spell ID 100) applies **Charge Stun** (spell ID 7922)
- Warrior's **Bloodrage** (spell ID 2687) applies the **Bloodrage buff** (spell ID 29131)

LibSpellDB tracks these with the `triggersAuras` field so addons can correctly correlate casts with their effects.

## Tools

### Audit Script (`audit_existing.py`)

Audits existing LibSpellDB spell definitions against exported CSV data from [wago.tools](https://wago.tools) to find:
- Missing spell ranks for existing abilities
- Missing trigger mappings (spells that trigger other aura spells)

**Getting the Data:**
1. Go to https://wago.tools
2. **Important**: Select the correct build (e.g., 2.5.5 for TBC Anniversary)
3. Export the following CSVs:
   - `SpellName.csv` from https://wago.tools/db2/SpellName
   - `Spell.csv` from https://wago.tools/db2/Spell
   - `SpellEffect.csv` from https://wago.tools/db2/SpellEffect

**Running the Audit:**
```bash
python audit_existing.py SpellName.csv Spell.csv SpellEffect.csv
```

**Output:**
- Console report grouped by class showing:
  - Missing ranks for existing spells
  - Missing trigger mappings

## Known Spell→Aura Mappings (TBC)

Key examples of spells with different aura IDs:

### Warrior
| Cast Spell ID | Cast Spell Name | Aura Spell ID | Aura Name |
|--------------|-----------------|---------------|-----------|
| 100 | Charge | 7922 | Charge Stun |
| 20252 | Intercept | 20615 | Intercept Stun |
| 5246 | Intimidating Shout | 20511 | Intimidating Shout (Cower) |
| 2687 | Bloodrage | 29131 | Bloodrage |

### Druid
| Cast Spell ID | Cast Spell Name | Aura Spell ID | Aura Name |
|--------------|-----------------|---------------|-----------|
| 16979 | Feral Charge | 45334 | Feral Charge Effect |
| 9005/9823/9827 | Pounce | 9007/9824/9826 | Pounce Bleed |
| 16689+ | Nature's Grasp | 19975 | Nature's Grasp Root |

### Hunter
| Cast Spell ID | Cast Spell Name | Aura Spell ID | Aura Name |
|--------------|-----------------|---------------|-----------|
| 19386 | Wyvern Sting R1 | 24131 | Wyvern Sting DoT |
| 24132 | Wyvern Sting R2 | 24134 | Wyvern Sting DoT |
| 24133 | Wyvern Sting R3 | 24135 | Wyvern Sting DoT |
| 19577 | Intimidation | 24394 | Intimidation Stun |

### Shaman
| Cast Spell ID | Cast Spell Name | Aura Spell ID | Aura Name |
|--------------|-----------------|---------------|-----------|
| 2484 | Earthbind Totem | 3600 | Earthbind (slow) |

## Contributing

If you find new mismatches:
1. Test in-game to confirm the mismatch
2. Add to the appropriate class file in `LibSpellDB/Data/`
3. Use the `triggersAuras` structure:

```lua
{
    spellID = 12345,  -- Cast spell ID
    tags = {...},
    triggersAuras = {
        {
            spellID = 67890,  -- Applied aura spell ID
            tags = {C.DEBUFF},
            type = "DEBUFF",  -- or "BUFF"
            onTarget = true,  -- true for enemy debuffs, false for self-buffs
        },
    },
},
```

## Resources

- [wago.tools](https://wago.tools) - WoW database file browser (source of CSV exports)
