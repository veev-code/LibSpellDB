# LibSpellDB Changelog

## [1.0.88] - 2026-04-02

### Changed
- **Aimed Shot (19434)** — Added `cooldownPriority = true`. The 10s healing debuff outlasts the 6s cooldown, so consumers should prioritize cooldown display over debuff tracking (same pattern as Mortal Strike).

## [1.0.87] - 2026-04-01

### Fixed
- **Taunt (355)** — Added missing `duration = 3` and `auraTarget = AT.ENEMY`. Taunt applies a 3s forced-attack debuff but had no aura data, so consumers couldn't track it.
- **Growl (6795)** — Same fix as Taunt: added `duration = 3, auraTarget = AT.ENEMY`.
- **Righteous Defense (31789)** — Same fix as Taunt: added `duration = 3, auraTarget = AT.ENEMY`.
- **Aimed Shot (19434)** — Added missing `duration = 10, auraTarget = AT.ENEMY` for the 50% healing reduction debuff.
- **Blast Wave (11113)** — Added missing `duration = 6, auraTarget = AT.ENEMY` for the daze debuff.
- **Avenger's Shield (31935)** — Added missing `duration = 6, auraTarget = AT.ENEMY` for the daze debuff.
- **Riposte (14251)** — Added missing `duration = 6, auraTarget = AT.ENEMY` for the disarm debuff.
- **Ghostly Strike (14278)** — Fixed `auraTarget` from `AT.ENEMY` to `AT.SELF`. The 15% dodge buff applies to the caster, not the target.

## [1.0.86] - 2026-04-01

### Changed
- **Warrior Rend** — Removed from Arms spec defaults. Still available for manual enable.
- **Warrior Slam** — Removed from Arms spec defaults. Still available for manual enable.
- **Shared cooldown group descriptions** — Shortened to concise labels.

## [1.0.85] - 2026-03-27

### Added
- **PvP Powerup buffs** — Added 4 battleground/arena pickup buffs: Berserking (24378), Restoration (24379), Speed (23978), Shadow Sight (34709). Tagged `MINOR_EXTERNAL` + `PVP_POWERUP`.
- **`DRUMS` tag** — New category tag for leatherworking drum buffs. Applied to all 6 existing drum entries.
- **`PVP_POWERUP` tag** — New category tag for battleground/arena pickup buffs.

## [1.0.84] - 2026-03-26

### Changed
- **Fear Ward** — Added `LONG_BUFF` tag. Fear Ward has a 3-minute duration matching its 3-minute cooldown, making it appropriate for buff reminder tracking rather than cooldown icon display.

## [1.0.83] - 2026-03-18

### Fixed
- **Rebirth Rank 6 reagent** — Fixed incorrect reagent item ID for Rebirth Rank 6 (spell 26994). Was mapped to Hornbeam Seed (R5's reagent) instead of Flintweed Seed (22147).
- **Gift of the Wild Rank 3 reagent** — Fixed incorrect reagent item ID for Gift of the Wild Rank 3 (spell 26991). Was mapped to Wild Thornroot (R2's reagent, 17026) instead of Wild Quillvine (22148).

## [1.0.82] - 2026-03-18

### Added
- **Silencing Shot** — Added Marksmanship Hunter's Silencing Shot (34490). Interrupt talent, 20s cooldown, 3s silence debuff.
- **Counterattack** — Added Survival Hunter's Counterattack (19306). Reactive parry talent, 5s cooldown, 5s root debuff. 4 ranks.
- **Shadowfury** — Added Destruction Warlock's Shadowfury (30283). AoE stun talent, 20s cooldown, 2s stun. 3 ranks.
- **Dark Pact** — Added Affliction Warlock's Dark Pact (18220). Pet mana drain talent, no cooldown. 4 ranks.

## [1.0.81] - 2026-03-18

### Added
- **Shadowstep** — Added Subtlety Rogue's Shadowstep (36554) with gap-close tags, 30s cooldown, and `appliesBuff` mapping to the 20% damage buff (36563).

## [1.0.80] - 2026-03-13

### Added
- **Cheating Death proc** — Added Subtlety Rogue's Cheating Death buff (45182) to proc tracking. 90% damage reduction for 3 sec when Cheat Death talent triggers.

## [1.0.79] - 2026-03-12

### Changed
- **Default visibility reduction across 6 classes** — Situational and niche spells are now hidden by default (`specs = {}`) to reduce icon clutter out of the box. All remain available for manual enable via consumer config.
  - **Druid**: Claw (tagged FILLER, removed ROTATIONAL), Entangling Roots (tagged FILLER)
  - **Hunter**: Raptor Strike, Mongoose Bite, Scare Beast, Disengage, Flare, Immolation Trap, Explosive Trap (hidden by default); Wing Clip (tagged FILLER)
  - **Mage**: Fire Ward, Frost Ward, Mana Shield (hidden by default)
  - **Paladin**: Exorcism, Holy Wrath, Turn Undead, Divine Intervention (hidden by default)
  - **Rogue**: Distract, Feint, Crippling Poison (hidden by default); Shiv (tagged FILLER)
  - **Warrior**: Challenging Shout (Protection-only); Heroic Strike, Cleave, Hamstring, Piercing Howl (tagged FILLER)

## [1.0.78] - 2026-03-12

### Added
- **`rankReagents` field** — New optional spell data field for spells where different ranks require different reagents (e.g., Rebirth seeds, Gift of the Wild herbs, Prayer of Fortitude candles). Maps rank spell IDs to their reagent item IDs.
- **`GetAllReagentItemIDs(spellID)`** — New API function returning a deduplicated array of all reagent item IDs across all ranks of a spell, or nil. For single-reagent spells, returns `{itemID}`. For per-rank spells, collects all unique reagent IDs from `rankReagents`.

### Changed
- **`GetReagentItemID(spellID)`** — Now also checks `rankReagents` when given a specific rank spell ID. Falls back to `reagentItemID` for single-reagent spells.
- **Comprehensive reagent data** — Added reagent requirements to 15 spells across 6 classes:
  - **Druid**: Rebirth (`rankReagents` — Maple/Stranglethorn/Ashwood/Ironwood/Hornbeam Seeds), Gift of the Wild (`rankReagents` — Wild Berries, Wild Quillvine)
  - **Mage**: Slow Fall (Light Feather), Arcane Brilliance (Arcane Powder)
  - **Priest**: Levitate (Light Feather), Prayer of Fortitude (`rankReagents` — Holy/Sacred Candle), Prayer of Shadow Protection (Sacred Candle), Prayer of Spirit (Sacred Candle)
  - **Paladin**: Divine Intervention (Symbol of Divinity), Greater Blessings ×6 (Symbol of Kings)
  - **Rogue**: Blind (Blinding Powder), Vanish (Flash Powder)
  - **Shaman**: Reincarnation (Ankh), Water Walking (Fish Oil), Water Breathing (Shiny Fish Scales)

## [1.0.77] - 2026-03-12

### Added
- **`reagentItemID` field** — New optional spell data field indicating the item consumed when casting (e.g., Soul Shard 6265, Infernal Stone 5565). Enables consumers to display reagent counts on spell icons.
- **`GetReagentItemID(spellID)`** — New API function returning the reagent item ID for a spell, or nil.

### Changed
- **Warlock: Soul Fire** — Now Destruction-only (`specs = {S.DESTRUCTION}`). Long cast time and soul shard cost make it impractical outside Destruction's Ruin talent scaling.
- **Warlock: Drain Soul, Drain Life, Drain Mana, Rain of Fire, Hellfire** — Tagged as `FILLER`. These are spammable channels/AoE with no cooldown, not worth tracking by default.
- **Warlock: Inferno** — Changed to `specs = {}` (manual enable only). 1-hour cooldown with Infernal Stone reagent; extremely niche.
- **Warlock: Pet Summons** (Imp, Voidwalker, Succubus, Felhunter, Felguard) — Tagged `OUT_OF_COMBAT`. 10-second cast time makes these pre-fight preparation. Fel Domination remains visible for Demonology as the in-combat emergency summon.
- **Warlock: Reagent data** — Added `reagentItemID` to 13 warlock spells: Soul Shard (Soul Fire, Shadowburn, Soulshatter, Enslave Demon, Create Soulstone, Create Healthstone, Ritual of Summoning, Summon Voidwalker/Succubus/Felhunter/Felguard), Infernal Stone (Inferno), Demonic Figurine (Ritual of Doom).

## [1.0.76] - 2026-03-11

### Changed
- **`GetAuraTarget()` is now explicit-only** — No longer infers aura target from tags, `selfOnly`, or `triggersAuras`. Returns the explicit `auraTarget` field or nil. All spells with `duration > 0` now have an explicit `auraTarget` field.
- **`class` is now required** — `RegisterSpell` asserts if `class` is missing. Previously defaulted silently to `"SHARED"`.
- **Racials use explicit `"SHARED"` class** — All `RegisterSpells` calls in `Racials.lua` now pass `"SHARED"` as the default class.

### Added
- **`GetAuraType(spellID)`** — Returns `"BUFF"` (self/ally/pet), `"DEBUFF"` (enemy), or nil (none/unknown). Derived from `auraTarget`.
- **`IsHelpfulSpell(spellID)`** — Returns `true` for self/ally/pet/none targets, `false` for enemy. Derived from `auraTarget`.
- **32-rule CI validation** — `Tools/validate_spells.py` now enforces 32 data integrity rules across all spell files, including auraTarget consistency, tag validity, rank/appliesBuff length matching, duplicate detection, and class resolution.
- **CI pipeline on every push** — Lua syntax checking (`luac5.1 -p`) and spell data validation run on every push to main, not just on tags.

### Fixed
- **5 spells missing `auraTarget`** — Pounce (Druid), Misdirection (Hunter), Stormstrike (Shaman), Bloodrage and Rampage (Warrior) had `duration > 0` but no `auraTarget`. Previously bypassed validation due to a `triggersAuras` exemption bug.
- **Mana Spring Totem ranks** — Removed buff ID 25569 from `ranks` array (was mixed in with summon spell IDs), fixing ranks/appliesBuff length mismatch.
- **Validator Rule 1 `triggersAuras` exemption** — Removed incorrect exemption that let spells with `triggersAuras` bypass the `auraTarget` requirement. The source spell still needs its own `auraTarget`.

## [1.0.75] - 2026-03-11

### Added
- **New AuraTarget: `"enemy"`** — `GetAuraTarget()` now returns `"enemy"` for spells tagged with `DEBUFF`, `HAS_DEBUFF`, `DOT`, or `HAS_DOT`. Previously these spells defaulted to `"self"`, making `IsSelfOnly()` incorrectly return `true` for enemy debuffs. This caused consumers that trust `IsSelfOnly()` for target resolution to check the player instead of the enemy target.
- **`AuraTarget.ENEMY`** constant added to `lib.AuraTarget` table.

### Changed
- **`GetAuraTarget()` priority** — Added step 5: debuff/DOT tags → `"enemy"`, before the `"self"` default. Explicit `auraTarget` fields, `selfOnly`, `triggersAuras`, and ally/heal tags still take precedence.
- **`IsSelfOnly()` semantics** — Now correctly returns `false` for enemy debuff spells. Only `"self"` and `"none"` are considered self-only; `"enemy"`, `"ally"`, and `"pet"` all return `false`.

## [1.0.74] - 2026-03-09

### Added
- **Mage: Arcane Blast self-debuff tracking** — Added `triggersAuras` mapping for Arcane Blast (30451) to its self-debuff (36032, `type = "DEBUFF"`, `onTarget = false`, 8s duration). Consumers can now track the caster's stacking debuff (up to 3 stacks) instead of looking for a debuff on the target.

## [1.0.73] - 2026-03-09

### Fixed
- **Missing `auraTarget` on ally-targetable buff spells** — 18 LONG_BUFF spells across 5 classes were missing their `auraTarget` field, causing them to incorrectly resolve as `"self"`. This prevented consumers (e.g., Buff Reminders) from offering party/raid tracking for these buffs.
  - **Priest** (4): Power Word: Fortitude → `AT.ALLY`, Prayer of Fortitude → `AT.NONE`, Divine Spirit → `AT.ALLY`, Shadow Protection → `AT.ALLY`
  - **Paladin** (8): Blessing of Might/Kings/Wisdom/Salvation → `AT.ALLY`, Greater Blessing of Might/Wisdom/Kings/Salvation → `AT.NONE`
  - **Hunter** (2): Aspect of the Pack → `AT.NONE`, Aspect of the Wild → `AT.NONE`
  - **Shaman** (2): Water Walking → `AT.ALLY`, Water Breathing → `AT.ALLY`
  - **Warlock** (2): Unending Breath → `AT.ALLY`, Detect Invisibility → `AT.ALLY`

## [1.0.72] - 2026-03-09

### Added
- **Warrior: Stances** — Added Battle Stance (2457), Defensive Stance (71), and Berserker Stance (2458) with `STANCE` tag. All three available to all warrior specs.

### Fixed
- **Druid: Moonkin Form** — Removed incorrect `DPS` tag. Moonkin Form is a shapeshift, not a DPS cooldown. Retains `SHAPESHIFT` tag.

## [1.0.71] - 2026-03-06

### Added
- **Priest: Spirit of Redemption** — Added proc entry for angel form on death (27827), 15s duration.

## [1.0.70] - 2026-03-06

### Added
- **`TIMED_EFFECT` tag** — New tag for cast-and-forget spells with a fixed-duration effect but no trackable buff/debuff (ground effects, placed effects). Consumers can start a countdown timer on `SPELL_CAST_SUCCEEDED` using the spell's `duration` field.
- **`IsTimedEffect(spellID)`** — New API method. Returns `true` if the spell has the `TIMED_EFFECT` tag. Accepts spell ID (number) or spell data table.
- **4 spells tagged `TIMED_EFFECT`:**
  - Mage: Flamestrike (8s ground fire)
  - Rogue: Distract (10s distraction)
  - Paladin: Consecration (8s ground AoE)
  - Hunter: Flare (20s stealth reveal)
- Set `auraTarget = AT.NONE` on all 4 spells (no unit to track for UnitBuff/UnitDebuff).

## [1.0.69] - 2026-03-04

### Added
- **`sharedAura` field** — New boolean field marking debuffs that are shared across all players (only one instance per target, any player can apply/refresh). Examples: Thunder Clap, Sunder Armor, Faerie Fire. Consumers can query `IsSharedAura(spellID)` to determine if a debuff should be shown regardless of source.
- **`IsSharedAura(spellID)`** — New API method. Returns `true` if the spell's aura is shared across all players. Accepts spell ID (number) or spell data table.
- **17 spells tagged `sharedAura = true`:**
  - Warrior: Thunder Clap, Demoralizing Shout, Sunder Armor
  - Druid: Faerie Fire, Faerie Fire (Feral), Demoralizing Roar, Mangle (Cat), Mangle (Bear)
  - Warlock: Curse of Elements, Curse of Shadow, Curse of Weakness, Curse of Recklessness, Curse of Tongues, Curse of Exhaustion (utility curses only — Curse of Agony and Curse of Doom are per-warlock damage and NOT shared)
  - Hunter: Hunter's Mark
  - Rogue: Expose Armor
  - Shaman: Stormstrike

## [1.0.68] - 2026-03-04

### Added
- **`charges` field** — Added to Earth Shield (6) and Shadowguard (3). Completes charge data for all charge-based LONG_BUFF spells.

## [1.0.67] - 2026-03-04

### Added
- **`formType` field for shapeshift spells** — New optional string field on SHAPESHIFT-tagged spells indicating form type (`"BEAR"`, `"CAT"`, `"AQUATIC"`, `"TRAVEL"`, `"MOONKIN"`). Consumers can query `GetSpellsByClassAndTag("DRUID", "SHAPESHIFT")` and read `data.formType` to build form-detection lookups without hardcoding spell IDs.
- **Aquatic Form (1066)** — Added to Druid data with `SHAPESHIFT`, `MOVEMENT`, `OUT_OF_COMBAT` tags and `formType = "AQUATIC"`.
- **`charges` field** — Populated on Inner Fire (20), Lightning Shield (3), Water Shield (3). The field existed in the schema but was not set on these spells.
- **`GetFormType(spellID)`** — Returns the shapeshift form type string for a spell, or nil.
- **`HasCharges(spellID)`** — Returns true if a spell has charges.

## [1.0.66] - 2026-03-04

### Fixed
- **Divine Intervention `appliesBuff` format** — Changed `appliesBuff = 19753` (bare number) to `appliesBuff = {19753}` (table). The bare number caused `ipairs()` errors in consumers that iterate `appliesBuff` entries.

## [1.0.65] - 2026-03-04

### Added
- **`SWING_RESET` tag** — New melee mechanic tag for abilities that replace the next white hit with yellow damage, resetting the swing timer. Tagged: Heroic Strike, Cleave, Slam (Warrior), Raptor Strike (Hunter), Maul (Druid). Consumers can query `GetSpellsByTag("SWING_RESET")` + `GetAllRankIDs()` to build a complete rank-expanded lookup.

## [1.0.64] - 2026-03-04

### Added
- **Divine Intervention (Paladin)** — Tagged as `IMPORTANT_EXTERNAL` with `HAS_BUFF`, `duration = 180`, `appliesBuff = 19753`, and `auraTarget = ALLY`. Enables consumers to track this buff when cast on the player by another Paladin.

## [1.0.63] - 2026-03-04

### Changed
- **LibStub externalized** — LibStub is no longer committed to the repository. It is now fetched via `.pkgmeta` externals at release time (from `repos.wowace.com`), matching the standard WoW library packaging convention. Added `Tools/fetch-libs.sh` for local development, `.gitignore` for `Libs/`, and updated `lib.xml` load path to `Libs\LibStub\LibStub.lua`.

## [1.0.62] - 2026-03-04

### Fixed
- **Trinket API `self` consistency** — `RegisterTrinket()`, `RegisterTrinkets()`, and `GetTrinketInfo()` now use `self` instead of the module-level `lib` variable, matching the convention used by all other API methods.
- **Schema comment accuracy** — Trinket `name` field documentation no longer claims auto-resolution via `GetItemInfo`; consumers handle name resolution.

## [1.0.61] - 2026-03-04

### Fixed
- **Duplicate file load warning** — `Data\Data.xml` was listed in both `lib.xml` and the TOC file, causing a "Duplicate File Load Detected" LUA_WARNING when loaded as a standalone addon. The TOC now loads only `lib.xml`, which already includes the data files.

## [1.0.60] - 2026-03-01

### Added
- **Trinket Database** — New `Trinkets.lua` with 35 TBC proc trinkets organized by raid tier. Includes proc buff IDs, internal cooldowns, on-use buff overrides, and target-applied flags.
- **Trinket API** — `RegisterTrinket()`, `RegisterTrinkets()`, `GetTrinketInfo(itemID)` for querying trinket proc data by item ID.
- **`TRINKET` category tag** — New equipment tag for trinket abilities.

## [1.0.59] - 2026-03-01

### Fixed
- **Kick (Rogue)** — Added Anniversary Edition spell ID 38768 for Kick rank 5. The previous highest rank ID (27613) does not exist in the Anniversary Edition client, causing `IsSpellKnown()` to return false for all ranks and making Kick invisible to consumers.

## [1.0.58] - 2026-02-28

### Fixed
- **Prayer of Mending** — Added `appliesBuff = {41635}`. The buff spell ID (41635) differs from the cast spell ID (33076), causing CLEU aura events to be unmapped by consumers. Removed `singleTarget` — PoM should follow target context rather than tracking globally, since it bounces to targets that may not benefit from the heal.
- **Lightwell** — Added missing `C.HEAL` tag for correct role classification.

## [1.0.57] - 2026-02-28

### Added
- **Mangle (Cat) and Mangle (Bear)** — Added `sharedAuraSpells` field linking both spells' rank IDs. Cat Mangle and Bear Mangle apply the same gameplay debuff (30% increased bleed damage) but have separate spell ID ranges. This field allows consumers to detect the debuff regardless of which form applied it.

## [1.0.56] - 2026-02-28

### Fixed
- **Mangle (Cat) and Mangle (Bear)** — Added missing `duration = 12` to both spells. The 12-second debuff duration was not declared in the spell data, causing consumers to fall back to estimated defaults.

## [1.0.55] - 2026-02-27

### Added
- **Aspect of the Wild** — Added all 3 ranks (20043, 20190, 27045) to Hunter spell data and `HUNTER_ASPECTS` BuffGroup. Fixes buff reminder false positives when using Aspect of the Wild.

## [1.0.54] - 2026-02-27

### Added
- **New tags: `IMPORTANT_EXTERNAL`, `MINOR_EXTERNAL`** — Two-tier classification for buffs received from other players or shared sources. `IMPORTANT_EXTERNAL` marks high-impact buffs (Bloodlust, Heroism, Power Infusion, Innervate, Pain Suppression, Blessing of Protection/Sacrifice/Freedom, Fear Ward, Earth Shield, Misdirection). `MINOR_EXTERNAL` marks lower-priority externals (Drums). Tags are mutually exclusive — a spell has one or the other, never both.
- **New data file: `Data/Externals.lua`** — Leatherworking drums (6 variants: Drums of Battle/War/Speed + Greater versions) registered as `SHARED` class with `MINOR_EXTERNAL` tag.
- **Expanded proc database** — 30+ new proc definitions across all classes:
  - **Warrior**: Second Wind, Blood Frenzy, Victory Rush (now also tagged `PROC` with `procInfo`)
  - **Rogue**: Remorseless, Mace Stun Effect, Find Weakness, Blade Twisting (Dazed)
  - **Mage**: Ignite, Winter's Chill, Blazing Speed, Fire Vulnerability (Improved Scorch). Removed Arcane Power, Icy Veins, Presence of Mind (active abilities, not procs).
  - **Warlock**: Shadow Vulnerability (ISB), Shadow Embrace, Nether Protection
  - **Priest**: Blessed Recovery, Shadow Weaving, Focused Casting (Martyrdom), Blackout
  - **Shaman**: Elemental Devastation, Focused Casting (Eye of the Storm). Fixed Unleashed Rage to use buff spell IDs with all 5 ranks.
  - **Druid**: Natural Perfection, Starfire Stun (Celestial Focus)
  - **Paladin**: Light's Grace, Redoubt, Reckoning
  - **Hunter**: Expose Weakness, Master Tactician, Rapid Killing, Improved Wing Clip, Improved Concussive Shot
- **Rogue procs reorganized** — Removed Blade Flurry and Adrenaline Rush from procs (they are active abilities, not procs). Added actual rogue proc talents.
- **`IMPORTANT_EXTERNAL` tags on existing spells** — Bloodlust, Heroism, Power Infusion, Pain Suppression, Innervate, Blessing of Protection/Sacrifice/Freedom, Fear Ward, Earth Shield, Misdirection.

### Changed
- **Stormstrike**: Added `cooldownPriority = true` — consumers should show cooldown first, debuff uptime is secondary.

## [1.0.53] - 2026-02-24

### Added
- **Warlock: Soulshatter (29858)** — Threat reduction ability (50% threat drop, 3min CD). Tagged `UTILITY`, available for all warlock specs.

## [1.0.52] - 2026-02-24

### Added
- **New BuffGroup: `WARLOCK_CURSES`** — All 8 warlock curses (Agony, Doom, Exhaustion, Tongues, Weakness, Elements, Shadow, Recklessness) grouped as exclusive. Only one curse can be active per target.
- **New BuffGroup: `PALADIN_SEALS`** — All 8 paladin seals (Blood, Crusader, Righteousness, Command, Wisdom, Light, Justice, Vengeance) grouped as exclusive. Only one seal can be active at a time.
- **Warlock curse spells** — Added `buffGroup = "WARLOCK_CURSES"` to all 8 curse spell definitions.

### Fixed
- **Missing `PALADIN_SEALS` group definition** — 8 paladin seal spells referenced `buffGroup = "PALADIN_SEALS"` but the group was never defined in Categories.lua.

## [1.0.51] - 2026-02-24

### Fixed
- **Warlock: Missing TBC ranks** — 8 spells were missing their highest-level TBC rank, causing rank-to-base mapping failures when the player casts the max rank. Affected spells and added rank IDs:
  - Siphon Life — Rank 6 (30911, level 70)
  - Searing Pain — Rank 8 (30459, level 70)
  - Soul Fire — Rank 4 (30545, level 70)
  - Shadowburn — Rank 7 (27263, level 63)
  - Drain Mana — Rank 6 (30908, level 70)
  - Curse of Weakness — Rank 8 (30909, level 69)
  - Devour Magic (Felhunter) — Rank 6 (27277, level 70)
  - Curse of Shadow — Rank 3 (27229, level 67)
- **Warlock: Curse of the Elements / Fear spell ID swap** — Curse of the Elements Rank 4 (27228) was incorrectly placed in Fear's ranks array, and Curse of Shadow Rank 3 (27229) was in Curse of the Elements' ranks. This caused Curse of the Elements to never match in aura tracking at max rank, and Fear to have a phantom fourth rank. All three spells corrected.
- **Priest: Greater Heal missing rank** — Added Rank 7 (25213, level 68).

## [1.0.50] - 2026-02-22

### Added
- **New API: `GetSpellIcon(spellIDOrData)`** — Returns the display icon for a spell, respecting the `icon` override field if set. Accepts spell ID (number) or spell data table.
- **New API: `GetDodgeReactive(spellIDOrData)`** — Returns the dodge-reactive window duration for spells like Overpower that become usable when the target dodges. Used by consumers for stance-independent ready glow.
- **New API: `GetRequiredItemIDs(spellIDOrData)`** — Returns the `requiredItemIDs` array for spells gated behind equipped items (e.g., weapon procs), or nil.
- **New spell data field: `dodgeReactive`** — Duration (seconds) of the usability window after a target dodges. Added to Warrior's Overpower (5s).
- **New spell data field: `requiredItemIDs`** — Array of item IDs; spell is only relevant when one of these items is equipped. Used for weapon proc spells.
- **New spell data field: `icon`** — Override icon texture ID, returned by `GetSpellIcon()` instead of the auto-resolved spell icon.
- **`GetProcs()` now includes SHARED procs** — Equipment procs registered under `class = "SHARED"` (e.g., weapon stun procs) are now returned alongside class-specific procs.
- **Warrior: Overpower** — Added `dodgeReactive = 5` for stance-independent dodge-reactive glow.
- **Warrior: Mace Stun Effect (5530)** — New proc entry for Mace Specialization talent stun (3s, on target). Custom icon (Mace Specialization talent texture).
- **Warrior: Improved Hamstring (23694)** — New proc entry for Improved Hamstring talent root (5s, on target). Tagged `ROOT`.
- **Shared: Deep Thunder / Stormherald Stun (34510)** — New proc entry for crafted mace weapon stun proc (4s, on target). Equipment-gated to item IDs 28441 (Deep Thunder) and 28442 (Stormherald).

### Changed
- **Warrior: Piercing Howl, Death Wish, Sweeping Strikes** — Expanded `specs` arrays to include `ARMS` alongside `FURY`, so these commonly-taken off-tree talents appear for Arms warriors via spec filtering.

## [1.0.49] - 2026-02-20

### Added
- **New procInfo field: `lowPriority`** — Boolean flag indicating a minor/passive proc not worth actively tracking. Consumers can use this to default-disable low-value procs while still allowing users to opt in.
- **Warrior: Deep Wounds** — Marked `lowPriority = true` (passive bleed debuff on target, no player decision)
- **Warrior: Blood Craze** — Marked `lowPriority = true` (passive self-heal on being crit, no action needed)

## [1.0.48] - 2026-02-20

### Added
- **Warlock: Create Healthstone** — New spell entry with all 18 Healthstone item IDs (6 standard, 6 improved rank 1, 6 improved rank 2). Tagged `PERSONAL_DEFENSIVE` + `UTILITY`. Includes `cooldownItemIDs` for item-based cooldown tracking.
- **New spell data field: `itemCooldown`** — Duration in seconds of the cooldown when a created item is consumed. Used by consumers for consumption detection when the item leaves bags (e.g., Healthstone 120s, Soulstone 1800s). Added to both Create Healthstone and Create Soulstone entries.

## [1.0.47] - 2026-02-19

### Added
- **New tag: `REQUIRES_PET`** — Marks spells that require an alive pet to function (e.g., Soul Link). Consumers can check this tag to suppress reminders when no pet is active.
- **New API: `IsRaceRelevant(spellID)`** — Returns true if a spell has no race restriction or matches the current player's race. Accepts spellID (number) or spellData (table).
- **New BuffGroup field: `excludeIfKnown`** — Array of spell IDs; if the player knows any of them, the buff group defaults to disabled. Used for Demonic Sacrifice (disabled when Soul Link or Summon Felguard is known).
- **Warlock: Soul Link** — Added as `LONG_BUFF` with `REQUIRES_PET` tag for buff reminder support.
- **Warlock: Summon Felguard** — Added as `PET_SUMMON` (Demonology capstone pet).
- **Warlock: Life Tap** — Added as `RESOURCE` with `specs = {}` (available for manual enable).

### Changed
- **Warlock: Demonic Sacrifice buffs** — Removed `specs = {DEMONOLOGY}` restriction from all 5 DS buff spells. The `talentGate` + `excludeIfKnown` combination now handles filtering more precisely than spec detection.
- **Warlock: Nightfall** — Removed from database. Nightfall (18094) is a passive talent; the proc buff it triggers (Shadow Trance, 17941) is the correct entry in Procs.lua.
- **Paladin: Righteous Fury** — Removed `SITUATIONAL` tag. With spec-aware defaults, Protection gets it enabled by default while Holy/Ret get it disabled.

## [1.0.46] - 2026-02-19

### Fixed
- **Warlock: Soulstone spell ID mismatch** — The Soulstone entry used buff spell IDs (20707 "Soulstone Resurrection") as the canonical and rank IDs, but the player's spellbook contains "Create Soulstone" with entirely different IDs (693, 20752, etc.). This caused `IsSpellKnown()` to always fail, preventing the spell from appearing in any consumer addon. Fixed canonical to 693, ranks to the actual cast spell IDs, and added `appliesBuff` array with the buff spell IDs for aura tracking.

## [1.0.45] - 2026-02-15

### Added
- **New API: `GetCooldownItemIDs(spellID)`** — Returns the `cooldownItemIDs` array for spells that track cooldowns via created items (e.g., Soulstone), or nil.
- **New API: `GetItemCooldown(spellID)`** — Queries `GetItemCooldown()` for each item in the spell's `cooldownItemIDs` array. Returns `remaining, duration, startTime` for the first active cooldown, or nil. Accepts spellID (number) or spellData (table).
- **New spell data field: `cooldownItemIDs`** — Array of item IDs for spells where the cooldown lives on a created item rather than the spell itself.

### Changed
- **Warlock: Soulstone Resurrection** — Corrected `cooldown` from 1800 to 0 (creation spell has no cooldown; the item does). Added `duration = 1800`, `auraTarget = "ally"`, `singleTarget = true`, `HAS_BUFF` tag, and `cooldownItemIDs` for all 6 Soulstone item ranks (Minor through Master).

## [1.0.44] - 2026-02-15

### Fixed
- **Warlock: Siphon Life** — Replaced incorrect `DEBUFF` + `HEAL_SINGLE` tags with `HAS_DEBUFF`. The `HEAL_SINGLE` tag caused aura tracking consumers to misidentify this as an ally-targeted buff instead of an enemy-targeted debuff, breaking duration display.
- **Priest: Devouring Plague** — Same fix. DoTs that heal the caster are enemy debuffs, not ally heals.

## [1.0.43] - 2026-02-15

### Changed
- **Druid: Travel Form** — Tagged `OUT_OF_COMBAT` (outdoor-only movement form, not combat-relevant)
- **Hunter: Dismiss Pet** — Tagged `OUT_OF_COMBAT`
- **Hunter: Beast Lore** — Tagged `OUT_OF_COMBAT`
- **Shaman: Ghost Wolf** — Tagged `OUT_OF_COMBAT` (outdoor-only movement form)
- **Shaman: Astral Recall** — Tagged `OUT_OF_COMBAT`
- **Warlock: Ritual of Doom** — Tagged `OUT_OF_COMBAT`
- **Warlock: Ritual of Summoning** — Tagged `OUT_OF_COMBAT`
- **Warlock: Eye of Kilrogg** — Tagged `OUT_OF_COMBAT`

## [1.0.42] - 2026-02-14

### Added
- **Warlock: Demonic Sacrifice** (18788) — Casting spell with `triggersAuras` mapping all 5 buff outcomes (Burning Wish, Fel Stamina, Touch of Shadow, Fel Energy, Felguard Touch of Shadow). Tags: `BUFF`, `DPS`, `OUT_OF_COMBAT`. Demonology spec.
- **Warlock: Demonic Sacrifice buff entries** — 5 passive buff spells (18789, 18790, 18791, 18792, 35701) tagged `LONG_BUFF` with `buffGroup = "WARLOCK_DEMONIC_SACRIFICE"` for Buff Reminder support.
- **New BuffGroup: `WARLOCK_DEMONIC_SACRIFICE`** — Exclusive group with `talentGate = 18788`. The `talentGate` field is a new BuffGroup property: when present, consumers should check `IsSpellKnown(talentGate)` instead of iterating group spell IDs (which are passive buff auras, not castable spells).

## [1.0.41] - 2026-02-12

### Added
- **New API: `GetSpellDuration(spellID)`** — Returns the duration for a specific spell rank. Supports a new `rankDurations` field (map of `spellID -> duration`) for spells where duration varies by rank. Falls back to the base `duration` field for spells without per-rank data.
- **Shaman: Magma Totem** (8190) — Fire element totem, 5 ranks, 20s duration. Tags: `DPS`, `AOE`, `TOTEM`, `TOTEM_FIRE`.
- **Shaman: Searing Totem per-rank durations** — Added `rankDurations` mapping: Rank 1 = 30s, Rank 2 = 35s, up to Rank 7 = 60s. Previously all ranks used 60s.

## [1.0.40] - 2026-02-12

### Added
- **Priest: Inspiration** (15363) — Holy talent proc. Buff on heal target after critical heal. Ranks 1-3, `onAlly = true`.
- **Shaman: Ancestral Fortitude** (16237) — Restoration talent proc (Ancestral Healing). Armor buff on heal target after critical heal. Ranks 1-3, `onAlly = true`.
- **Shaman: Healing Way** (29203) — Restoration talent proc. Stacking buff (+6% Healing Wave effectiveness per stack, max 3) on Healing Wave target. `onAlly = true`.
- **Hunter: Ferocious Inspiration** (34456) — Beast Mastery talent proc. Party damage buff (+3%) on pet critical hit.

## [1.0.39] - 2026-02-12

### Fixed
- **Warrior: Intercept missing ranks** — Added Rank 4 (25272) and Rank 5 (25275). Learning these ranks previously caused Intercept to disappear from addons that use LibSpellDB, because `rankToCanonical` couldn't map the unknown spell IDs back to the base entry.

## [1.0.38] - 2026-02-11

### Added
- **Shaman: Fire Resistance Totem** (8184) — Water element totem with 4 ranks and `appliesBuff` for range detection
- **Shaman: Nature Resistance Totem** (10595) — Air element totem with 4 ranks and `appliesBuff` for range detection

### Fixed
- **Shaman: Mana Tide Totem** — Removed incorrect `appliesBuff` (totem pulses mana, does not apply a persistent `UnitBuff`)
- **Shaman: Windfury Totem** — Removed incorrect `appliesBuff` (applies a weapon enchant via `GetWeaponEnchantInfo`, not a `UnitBuff`)
- **Shaman: Flametongue Totem** — Removed incorrect `appliesBuff` (applies a weapon enchant, not a `UnitBuff`)

## [1.0.37] - 2026-02-11

### Changed
- **Priest: Binding Heal** — Retagged from `ROTATIONAL` to `FILLER` (no cooldown, mana-gated spammable)
- **Priest: Circle of Healing** — Retagged from `AOE` to `FILLER` (no cooldown, mana-gated spammable)
- **Priest: Desperate Prayer** — Retagged from `HEAL` to `PERSONAL_DEFENSIVE` (self-only emergency heal)
- **Priest: Inner Focus** — Added Holy spec (was Discipline-only; common 14/47 builds take this talent)
- **Priest: Shadowfiend** — Now available for all 3 specs, removed incorrect `talent = true` (trainable at level 66)
- **Priest: Holy Fire** — Set `specs = {}` (niche for all specs in TBC; available for manual enable)
- **Mage: Ice Block** — Removed duplicate entry that incorrectly made it available to all specs (Frost talent in TBC)
- **Hunter: Steady Shot** — Retagged from `ROTATIONAL` to `FILLER` (no cooldown, mana-gated spammable)

### Added
- **Tagging Guidelines** in CLAUDE.md — Documented rules for FILLER vs ROTATIONAL, PERSONAL_DEFENSIVE vs HEAL, `specs` field, and `talent` field usage

## [1.0.36] - 2026-02-10

### Changed
- **`IsRotational()` performance** — O(1) hash lookup via `spellIDToTags` index instead of O(n) tag array iteration and `GetSpellInfo()` lookup
- **`GetAuraTarget()` performance** — O(1) hash lookup for healing/defensive tags instead of O(n) `ipairs` iteration over tag array
- **`GetSortedSpells()` performance** — Pre-computes priority per spell before sorting, reducing comparator cost from O(n^2 * t) to O(n*t + n log n)

## [1.0.35] - 2026-02-10

### Added
- **Paladin: Missing seals** — Added 4 seals that were absent from the database:
  - Seal of Wisdom (20166) — mana restore on melee, 4 ranks
  - Seal of Light (20165) — heal on melee, 5 ranks
  - Seal of Justice (20164) — stun on melee, 2 ranks
  - Seal of Vengeance (31801) — stacking Holy DoT (Alliance)
- **`buffGroup = "PALADIN_SEALS"`** — All 8 seals now tagged with a shared buff group for mutual exclusivity tracking

### Changed
- **Seal of Blood** — Broadened spec coverage from Retribution-only to Retribution + Protection (Prot Paladins use it for threat generation)
- **All existing seals** — Added `auraTarget = AT.SELF` for consistent aura targeting metadata

## [1.0.34] - 2026-02-10

### Added
- **`appliesBuff` field** — New spell data field containing an array of buff spell IDs that a totem applies to nearby party members (ordered low to high by rank). Used for range detection — if the player lacks the buff, they've moved out of range. 12 Shaman totems annotated: Strength of Earth, Stoneskin, Grace of Air, Windfury, Tranquil Air, Wrath of Air, Frost Resistance, Flametongue, Totem of Wrath, Healing Stream, Mana Spring, Mana Tide
- **Wrath of Air Totem** (spell 3738) — New TBC Air totem entry with `TOTEM_AIR` tag and `appliesBuff = {2895}`
- **Mage: Scorch `triggersAuras`** — Improved Scorch talent now maps to its Fire Vulnerability debuff (spell 22959), enabling aura tracking on the target. Added `HAS_DEBUFF` tag.

## [1.0.33] - 2026-02-09

### Added
- **`singleTarget` field** — New spell data field marking spells that can only be active on one target at a time (e.g., Polymorph: "Only one target can be polymorphed at a time", Prayer of Mending: "This spell can only be placed on one target at a time")
- **`IsSingleTarget(spellID)` API** — Returns `true` if a spell has the `singleTarget` flag. Accepts spell ID or spell data table, consistent with `IsSelfOnly()` and `IsRotational()`
- **12 spells tagged** with `singleTarget = true`:
  - Mage: Polymorph, Slow
  - Rogue: Sap
  - Warlock: Fear, Banish, Enslave Demon
  - Druid: Hibernate
  - Priest: Mind Control, Shackle Undead, Prayer of Mending
  - Paladin: Turn Undead
  - Shaman: Earth Shield

## [1.0.32] - 2026-02-09

### Added
- **Priest racial abilities** — 8 race-restricted priest spells added with proper `race` fields:
  - Night Elf: Starshards (Arcane DoT), Elune's Grace (avoidance buff)
  - Human: Feedback (anti-magic shield)
  - Draenei: Symbol of Hope (party mana regen)
  - Undead/Blood Elf: Touch of Weakness (reactive damage buff)
  - Troll: Hex of Weakness (healing reduction debuff), Shadowguard (shadow damage shield)
  - Blood Elf: Consume Magic (self-dispel for mana)
- **Multi-race `race` field support** — `IsSpellRelevantForSpec()` now accepts a table of race strings (e.g., `race = {"Dwarf", "Human"}`) in addition to a single string

### Changed
- **Priest: Chastise** — Correctly flagged as Dwarf/Draenei racial (was `talent = true`)
- **Priest: Desperate Prayer** — Added `race = {Dwarf, Human}` restriction
- **Priest: Devouring Plague** — Added `race = Undead` restriction

## [1.0.31] - 2026-02-09

### Changed
- **Druid: Rake** — Removed `cooldownPriority` flag so the DoT duration is displayed when active, letting players track when it needs refreshing. Previously the icon suppressed the aura display in favor of energy prediction.

## [1.0.30] - 2026-02-08

### Added
- **`CAT_FORM` and `BEAR_FORM` category tags** — New tags for classifying feral druid spells by required shapeshift form
- **Druid form tagging** — 19 feral spells tagged with their required form:
  - `CAT_FORM`: Mangle (Cat), Shred, Rake, Claw, Rip, Ferocious Bite, Pounce, Prowl, Dash
  - `BEAR_FORM`: Mangle (Bear), Lacerate, Swipe, Maul, Demoralizing Roar, Feral Charge, Bash, Growl, Challenging Roar, Frenzied Regeneration

### Changed
- **TBC_Rotations.md** — Comprehensive rewrite sourced from Wowhead/Icy Veins TBC Classic guides. Corrected rotation priorities, added missing abilities, fixed TBC-era inaccuracies (e.g., Pyroblast not rotational, Fingers of Frost doesn't exist in TBC), added notes on key mechanics (powershifting, shot weaving, seal twisting)

## [1.0.29] - 2026-02-08

### Added
- **`name` and `description` fields** on all 451 spell entries across 11 data files, sourced from Wowhead TBC tooltip API. Provides AI/developer context for each spell.
- **Druid: Omen of Clarity** — Added `dispelType = "Magic"` field, enabling consumers to detect it as a purgeable buff.
- **Audit tooling** (`Tools/wowhead_audit.py`) — Python script for fetching, caching, auditing, and enriching spell data against Wowhead's TBC database. Cached responses in `Tools/wowhead_cache.json`.

### Fixed
Comprehensive cooldown/duration audit against Wowhead TBC database. All corrections verified against live TBC tooltip data:
- **Warrior**: Last Stand cd 600→480
- **Paladin**: All Blessing durations updated to TBC values (5min→10min, 15min→30min), Blessing of Sacrifice cd 0→30, Blessing of Freedom cd 20→25, Holy Shock cd 30→15
- **Priest**: Fear Ward cd 30→180, Vampiric Embrace cd 0→10, Power Word: Shield cd 0→4, Lightwell cd 600→360, removed incorrect Divine Spirit rank 32999
- **Mage**: Ice Block spellID corrected (11958→45438), Cold Snap cd 600→480, Counterspell cd 30→24, Blast Wave cd 45→30
- **Hunter**: Trap cooldowns 15→30 (Freezing, Immolation, Explosive, Frost), Flare cd 15→20 dur 30→20, Volley cd 0→60
- **Rogue**: Blind cd 300→180, Cloak of Shadows cd 90→60
- **Warlock**: Howl of Terror dur 15→8
- **Druid**: Tranquility cd 300→600 dur 10→8, Rebirth cd 1800→1200, Faerie Fire (Feral) cd 0→6, Omen of Clarity dur 600→1800, Pounce dur 2→3
- **Racials**: Escape Artist cd 60→105, Mana Tap cd 120→30 dur 2→600 + tags corrected, removed bogus spellID 28732 (was Widow's Embrace, not Arcane Torrent)
- **Procs**: Vengeance dur 8→30

## [1.0.28] - 2026-02-08

### Added
- **Shaman: Totemic Call** (36936) — Added with `clearsTotems = true` field for generic totem-recall detection by consumers
- **`clearsTotems` spell data field** — New boolean field indicating a spell destroys all active totems when cast. Documented in CLAUDE.md.

### Fixed
- **Searing Totem duration**: 55s → 60s (correct for max-rank TBC)
- **Healing Stream Totem duration**: 60s → 120s
- **Mana Spring Totem duration**: 60s → 120s

## [1.0.27] - 2026-02-08

### Added
- **Reactive Window** — New `reactiveWindow` and `reactiveWindowEvent` spell data fields for modeling REACTIVE abilities with time-limited usability windows. `reactiveWindow` specifies the duration (seconds) and `reactiveWindowEvent` specifies the CLEU sub-event that triggers or refreshes the window.
- **`GetReactiveWindow(spellID)` API** — Returns the reactive window duration for a spell, or nil. Accepts spell ID or spell data table.
- **Warrior: Victory Rush** — Added `reactiveWindow = 20` and `reactiveWindowEvent = "PARTY_KILL"` metadata, enabling consumers to display a 20-second usability countdown after a qualifying killing blow.

## [1.0.26] - 2026-02-08

### Added
- **Druid: Claw** — All 6 ranks (1082, 3029, 5201, 9849, 9850, 27000) for Feral spec
- **Druid: Rake** — All 5 ranks (1822, 1823, 1824, 9904, 27003) with `cooldownPriority` flag for Feral spec

### Changed
- **Renamed `ignoreAura` to `cooldownPriority`** across all data files (Druid, Warrior, Rogue) and documentation. The new name better reflects the behavior: cooldown/prediction display takes priority over aura tracking, rather than ignoring the aura entirely. Affected spells: Mortal Strike, Bloodthirst, Hemorrhage, Mangle (Bear), Rake.

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
