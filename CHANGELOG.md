# LibSpellDB Changelog

## [1.0.25] - 2026-02-08

### Added
- **Buff Groups** — New `BuffGroups` system for modeling relationships between related buffs. Two relationship types:
  - `equivalent`: Different spells providing the same buff (e.g., Power Word: Fortitude / Prayer of Fortitude)
  - `exclusive`: Only one can be active from the same caster (e.g., Battle Shout / Commanding Shout)
- **Buff group definitions** for all classes:
  - Equivalent: `PRIEST_FORTITUDE`, `PRIEST_SPIRIT`, `PRIEST_SHADOW_PROT`, `DRUID_MOTW`, `MAGE_INTELLECT`
  - Exclusive: `WARRIOR_SHOUTS`, `WARLOCK_ARMOR`, `MAGE_ARMOR`, `MAGE_MAGIC_MODIFIER`, `SHAMAN_SHIELD`, `PALADIN_AURAS`, `PALADIN_BLESSINGS`, `HUNTER_ASPECTS`, `ROGUE_POISONS`, `SHAMAN_WEAPON_IMBUES`
- **Buff group API** — `GetBuffGroup()`, `GetBuffGroupSpells()`, `IsInBuffGroup()`, `GetBuffGroupRelationship()`
- **Weapon enchant support** — Buff groups can be marked with `weaponEnchant = true` for spells tracked via `GetWeaponEnchantInfo()` instead of `UnitBuff()`. Additional fields: `itemBased` (applied via crafted items, not castable spells) and `minLevel` (level gating)
- **`GetDispelType()` API** — Returns a spell's dispel classification ("Magic", "Curse", "Disease", "Poison", or nil)
- **`SITUATIONAL` tag** — Un-deprecated and repurposed to mark situational/niche utility spells that are not critical for general uptime
- **Long-duration buff data** — Comprehensive `LONG_BUFF`-tagged spell data across all classes:
  - **Druid**: Mark of the Wild, Gift of the Wild, Thorns, Omen of Clarity
  - **Hunter**: Trueshot Aura, all 6 Aspects (Hawk, Monkey, Cheetah, Pack, Beast, Viper)
  - **Mage**: Arcane Intellect, Arcane Brilliance, Mage/Ice/Molten/Frost Armor, Amplify/Dampen Magic
  - **Paladin**: All 6 Blessings + 6 Greater Blessings, Blessing of Light, 7 Auras, Righteous Fury
  - **Priest**: Power Word: Fortitude, Prayer of Fortitude, Divine Spirit, Prayer of Spirit, Shadow Protection, Prayer of Shadow Protection, Inner Fire
  - **Rogue**: Instant/Deadly/Wound/Mind-numbing/Crippling Poison
  - **Shaman**: Water Shield, Lightning Shield, Earth Shield, 4 weapon imbues (Flametongue/Windfury/Frostbrand/Rockbiter), Water Walking, Water Breathing
  - **Warlock**: Demon Skin, Demon Armor, Fel Armor, Unending Breath, Detect Invisibility
  - **Warrior**: Battle Shout, Commanding Shout
- **`dispelType` field** added to all relevant long-duration buff spells for accurate purgeable/non-purgeable classification
- **`buffGroup` field** added to all grouped spells linking them to their `BuffGroups` definition

## [1.0.24] - 2026-02-07

### Added
- **Totem tags** — New `TOTEM` category tag for all shaman totems, plus element tags `TOTEM_EARTH`, `TOTEM_FIRE`, `TOTEM_WATER`, `TOTEM_AIR` to classify totems by element slot (only one totem per element can be active). All 22 shaman totems tagged with their element and have duration data for tracking.
- **`CONSUMES_ALL_RESOURCE` tag** — New category tag for spells that drain all remaining resource (e.g. Execute). Replaces the `consumesAllResource` field.

### Changed
- **Warrior Execute** — Now uses `CONSUMES_ALL_RESOURCE` tag instead of `consumesAllResource` field (breaking change for addons that read the field directly — use `HasTag()` instead)

## [1.0.23] - 2026-02-07

### Changed
- **Proc descriptions updated to max rank** — Enrage description corrected from "5% damage increase" to "25% damage increase" (max rank); Blood Craze corrected from "1/2/3% health" to "3% health" (max rank)
- **Warrior Execute** — Added `consumesAllResource = true` flag indicating Execute drains all remaining rage (not just base cost)

## [1.0.22] - 2026-02-07

### Added
- **Multi-rank proc matching** — Proc entries for Enrage, Flurry (Warrior), Flurry (Shaman), and Blood Craze now include `ranks` arrays with all talent rank spell IDs, enabling dependent addons to match any rank of the proc buff (not just the highest)

## [1.0.21] - 2026-02-06

### Added
- **Paladin: Seal of the Crusader** — All 7 ranks (21082, 20162, 20305, 20306, 20307, 20308, 27158) added to spell data, available to all specs
- **Shaman procs: Shamanistic Focus** — "Focused" buff (43339) tracked as a proc; reduces next Shock mana cost by 60%, consumed on cast
- **Shaman procs: Flurry** — Enhancement Flurry buff (16280) tracked as a proc; 30% attack speed, 3 stacks consumed on hit
- **Priest procs: Clearcasting** — Holy Concentration proc buff (34754) tracked; next Flash Heal, Binding Heal, or Greater Heal costs no mana
- **Warrior procs: Blood Craze** — Fury talent proc buff (16491) tracked; regenerates health over 6 sec after taking a critical strike

## [1.0.20] - 2026-02-05

### Added
- **Faerie Fire (Feral)** — All 5 ranks (16857, 17390, 17391, 17392, 27011) as separate spell from caster Faerie Fire

### Changed
- **Mangle (Bear)** now uses `cooldownPriority = true` — cooldown display is more useful than debuff tracking (you spam on 6s CD, debuff lasts 12s)
- Caster Faerie Fire no longer shows for Feral spec (use Feral version instead)

## [1.0.19] - 2026-02-05

### Added
- **Temporary summon tag** — New `TEMPORARY_SUMMON` tag for short-duration pet abilities (Snake Trap snakes, Mirror Image, etc.)
- Hunter abilities: Multi-Shot, Volley, Arcane Shot, Steady Shot, Kill Command, and all Snake Trap ranks
- Fixed Maul missing `ROTATIONAL` tag for Feral Druids

## [1.0.18] - 2026-02-04

### Added
- **AuraTarget system** — New `auraTarget` field and `lib.AuraTarget` constants for specifying where a spell's buff appears:
  - `SELF`: Buff appears on caster only (Barkskin, Evasion, Ice Block)
  - `ALLY`: Can target other friendly players (Renew, BoP, PWS)
  - `PET`: Targets pet (Mend Pet)
  - `NONE`: No unit to track (AoE around caster, totems, placed objects)
- **`GetAuraTarget(spellID)`** — New API function returning "self", "ally", "pet", or "none"
- Added `auraTarget` field to spells across all classes (Druid, Hunter, Mage, Paladin, Priest, Rogue, Shaman, Warlock, Warrior, Racials)

### Changed
- `IsSelfOnly()` now uses `GetAuraTarget()` internally — returns true for "self" or "none", false for "ally" or "pet"
- Removed `HAS_BUFF` and `CC_IMMUNITY` tag-based inference from `IsSelfOnly()` in favor of explicit `auraTarget` fields

## [1.0.17] - 2026-02-03

### Fixed
- `IsSelfOnly()` now correctly identifies `HAS_BUFF` and `CC_IMMUNITY` tagged spells as abilities that can target others

## [1.0.16] - 2026-01-31

### Added
- `IsSelfOnly(spellID)` - Check if a spell can only target self (vs. other friendly players)
- `IsRotational(spellID)` - Check if a spell has the ROTATIONAL tag (for smart buff tracking)

## [1.0.15] - 2026-01-31

### Added
- **Chastise** soft CC for all Priest specs (Holy, Discipline, Shadow)

### Fixed
- Duplicate spell IDs in data files causing registration warnings
- Nil access bug when querying unregistered spells
- Migrated deprecated tag names to current conventions

### Changed
- Removed unused `TBC_SpellAuraMappings.lua` reference file from Tools folder
- Minor code cleanup (unused variable warning)

## [1.0.14] - 2026-01-30

### Added
- **Orc Blood Fury variants** for all caster classes:
  - 20572: Attack Power version (Warriors, Hunters, Rogues)
  - 33697: Attack Power + Spell Power (Shamans)
  - 33702: Spell Power only (Warlocks, Mages)
- **Fire Nova Totem** (all 7 ranks: 1535-25547) — AoE fire totem with 15s cooldown

## [1.0.13] - 2026-01-30

### Changed
- Hemorrhage now uses `cooldownPriority = true` — debuff tracking was hiding the cooldown display; cooldown visibility is more useful for rotation tracking

## [1.0.12] - 2026-01-30

### Added
- **triggersAuras array** for spells that apply multiple auras (e.g., Pounce applies both stun and bleed)
- Each triggered aura can have its own tags, type (BUFF/DEBUFF), and targeting rules
- Reverse index `auraToSource` for efficient lookup of source spell from aura ID
- New APIs: `GetAuraInfo()`, `GetAuraSourceSpellID()`, `GetAuraTags()`, `AuraHasTag()`
- **Comprehensive TBC spell ranks** from wago.tools data for all 9 classes
- Missing trigger mappings for spells with different aura IDs (Wyvern Sting DoTs, Pounce Bleeds, Nature's Grasp roots, etc.)
- New spells: Mage Cone of Cold, Dragon's Breath, Flamestrike, Blizzard, Slow; Rogue Backstab
- Audit script (`Tools/audit_existing.py`) for comparing LibSpellDB against wago.tools exports

### Changed
- Replaced `appliesAura` with `triggersAuras` array structure for multi-aura support

## [1.0.11] - 2026-01-29

### Fixed
- Vampiric Embrace now correctly tagged as HAS_DEBUFF (it's a debuff on target, not a buff on self)

## [1.0.10] - 2026-01-28

### Added
- Forbearance lockout tracking for Paladin immunity spells (Divine Shield, Divine Protection, Blessing of Protection, Avenging Wrath)
- Uses `targetLockoutDebuff` field to indicate spells blocked by Forbearance debuff

## [1.0.9] - 2026-01-28

### Fixed
- Include spell data files in `lib.xml` so embedded copies (e.g., bundled with VeevHUD) load correctly
- Previously, only the core library loaded when embedded, resulting in zero spells being registered

## [1.0.8] - 2026-01-28

### Added
- Deep Wounds proc tracking for Warriors (target debuff)
- `cooldownPriority` flag (renamed from `ignoreAura`) for spells where cooldown/prediction display takes priority over aura tracking (e.g., Mortal Strike, Bloodthirst, Rake)

## [1.0.7] - 2026-01-27

### Added
- `lib.Specs` constants for type-safe spec tagging in data files
- All spells now have explicit `specs` field (no more implicit "all specs" behavior)

### Changed
- Data files now use `S.ARMS`, `S.SHADOW`, etc. instead of string literals
- Reduces typo risk and enables IDE autocomplete for spec names

## [1.0.6] - 2026-01-27

### Added
- `GetAllRankIDs(spellID)` - Returns set of all rank spell IDs for a spell
- `GetHighestKnownRank(spellID)` - Returns highest rank the player knows

These utility functions enable addons to accurately determine spell costs and usability for ranked spells.

## [1.0.5] - 2026-01-27

### Changed
- Updated changelog for CurseForge

## [1.0.4] - 2026-01-27

### Fixed
- Added Mocking Blow ranks for proper debuff tracking

## [1.0.3] - 2026-01-25

### Fixed
- Added Charge Stun and Intercept Stun aura mappings for Warriors

## [1.0.2] - 2026-01-25

### Fixed
- CurseForge publishing configuration

## [1.0.1] - 2026-01-24

### Fixed
- TBC Classic interface version

## [1.0.0] - 2025-01-24

### Added
- Initial release
- Complete spell database for all TBC Classic classes
- Spec detection and filtering
- Category/tag system for spell classification
- Proc tracking data for all classes
- Shared cooldown group support
- PvE and PvP rotation tags
- Reactive ability detection
