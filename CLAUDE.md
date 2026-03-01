# LibSpellDB - Addon Context

LibSpellDB is a shared spell database library for World of Warcraft addon developers (TBC Classic / Anniversary Edition). It provides a centralized, curated repository of spell data with extensive tagging for categorization, spec detection, rank handling, and proc tracking.

**LibSpellDB is consumer-agnostic.** It must never reference, depend on, or assume VeevHUD (or any specific addon). It is a general-purpose library that any addon can use. All API design, data structures, and tag semantics should make sense independently of how any particular consumer uses them.

## File Structure

### Root
- `LibSpellDB.toc` — TOC file, MIT license
- `lib.xml` — Core library loader (load order)
- `README.md` — Main documentation
- `CHANGELOG.md` — Version history
- `.pkgmeta` — CurseForge package metadata

### Core (`Core/`)
- `LibSpellDB.lua` — Main library: spell registration, query API, aura indexing, rank mapping
- `Categories.lua` — Category/tag constants, AuraTarget constants, category metadata (name, color, priority)
- `SpecDetection.lua` — Talent-based spec detection, spec constants, signature spell fallback
- `Commands.lua` — `/spelldb` and `/lsdb` slash commands

### Data (`Data/`)
- `Data.xml` — Data file loader
- Per-class files: `Warrior.lua`, `Paladin.lua`, `Hunter.lua`, `Mage.lua`, `Priest.lua`, `Rogue.lua`, `Shaman.lua`, `Warlock.lua`, `Druid.lua`
- `Racials.lua` — Racial abilities and PvP trinkets (`class = "SHARED"`)
- `Procs.lua` — Proc buff definitions with `procInfo` metadata
- `Externals.lua` — Cross-class external buffs: drums, item-based effects (`class = "SHARED"`)

### Other
- `LibStub/LibStub.lua` — Embedded LibStub
- `Tools/` — Python audit/parse scripts for spell data maintenance
- `TBC_Procs.md`, `TBC_Rotations.md` — Reference documentation

## Library Registration

Registered as `"LibSpellDB-1.0"` via LibStub. All core and data files access the library with:
```lua
local lib = LibStub and LibStub:GetLibrary("LibSpellDB-1.0", true)
if not lib then return end
```

## Spell Data Structure

```lua
{
    -- Required
    spellID = 12345,                    -- Primary spell ID
    class = "WARRIOR",                  -- Class token (or "SHARED" for racials)
    tags = {C.DPS, C.ROTATIONAL},       -- Category tags (array)

    -- Optional (auto-resolved if nil)
    name = "Spell Name",                -- Override display name
    description = "Spell description.", -- Full spell description text
    icon = 12345,                       -- Override icon texture ID (returned by GetSpellIcon instead of auto-resolved)

    -- Optional metadata
    cooldown = 10,                      -- Base cooldown in seconds
    duration = 5,                       -- Buff/effect duration in seconds
    rankDurations = {[100]=5,[101]=8},  -- Per-rank durations when they differ (spellID -> seconds)
    charges = 2,                        -- Number of charges
    priority = 1,                       -- Sort priority within rows
    talent = true,                      -- Requires talent point
    ranks = {100, 101, 102},            -- All rank spell IDs (low to high)
    specs = {S.ARMS, S.FURY},           -- Spec restrictions (nil = all specs)
    race = "Orc",                       -- Race restriction (racials only)
    dispelType = "Magic",               -- Dispel type of the spell's buff ("Magic", "Curse", etc.)
    buffGroup = "WARRIOR_SHOUTS",       -- BuffGroup this spell belongs to (see BuffGroup System below)
    requiredItemIDs = {28441, 28442},   -- Item IDs; spell only relevant when one is equipped (weapon procs)

    -- Aura targeting
    auraTarget = AT.SELF,               -- Where buff appears: "self", "ally", "pet", "none"
    cooldownPriority = true,            -- Show cooldown/prediction first, then aura when ready
    -- consumesAllResource: REMOVED — use CONSUMES_ALL_RESOURCE tag instead
    targetLockoutDebuff = 6788,         -- Debuff that blocks re-casting (e.g. Weakened Soul)
    singleTarget = true,                -- Only one instance can be active at a time (Polymorph, Prayer of Mending)
    reactiveWindow = 20,                -- Duration (seconds) of usability window for REACTIVE spells
    reactiveWindowEvent = "PARTY_KILL", -- CLEU sub-event that triggers/refreshes the window
    dodgeReactive = 5,                  -- Duration (seconds) of usability window after target dodges (Overpower)
    clearsTotems = true,                -- When cast, destroys all active totems (Totemic Call)
    appliesBuff = {8076, 8162},         -- Buff spell IDs applied to player/party (all ranks, low to high)
    cooldownItemIDs = {5232, 16892},    -- Item IDs whose cooldown to check (for spells that create usable items, e.g. Soulstone)
    itemCooldown = 120,                 -- Duration (seconds) of cooldown when a created item is consumed (for consumption detection)

    -- Triggered auras (when aura ID differs from spell ID)
    triggersAuras = {
        {
            spellID = 7922,             -- Aura spell ID
            tags = {"CC_HARD"},         -- Tags for THIS aura
            type = "DEBUFF",            -- "BUFF" or "DEBUFF"
            onTarget = true,            -- true = on target, false = on player
            duration = 5,               -- Aura duration
        },
    },

    -- Shared cooldowns
    sharedCooldownGroup = "WARRIOR_30MIN_CD",

    -- Proc metadata (Procs.lua only)
    procInfo = {
        description = "Increases attack speed by 30%",
        stacks = 3,                     -- Max stacks (or false)
        consumedOnCast = false,
        consumedOnHit = true,
        onTarget = false,
        lowPriority = true,             -- Minor/passive proc, not worth actively tracking
    },
}
```

## Category System (`lib.Categories`)

### Role Tags
`DPS`, `HEAL`, `TANK`

### Usage Pattern Tags
- `ROTATIONAL` — Core rotation, used on cooldown
- `MAINTENANCE` — Buff/debuff to keep up
- `MINOR` — Cooldown <60s, tactical usage
- `MAJOR` — Cooldown 60s+, save for key moments
- `AOE` — AoE version of ability
- `FINISHER` — Combo point / resource spenders
- `CONSUMES_ALL_RESOURCE` — Drains ALL remaining resource, not just base cost (Execute)

### Exclusion Tags
- `FILLER` — Mana-based spammables with no cooldown (excluded from HUD by default)
- `OUT_OF_COMBAT` — Only used out of combat
- `LONG_BUFF` — 30+ min buffs cast out of combat

### Defensive Tags
`DEFENSIVE`, `PERSONAL_DEFENSIVE`, `EXTERNAL_DEFENSIVE`, `RAID_DEFENSIVE`, `IMMUNITY`, `DAMAGE_REDUCTION`

### Movement Tags
`MOVEMENT`, `MOVEMENT_SPEED`, `MOVEMENT_GAP_CLOSE`, `MOVEMENT_ESCAPE`

### Crowd Control Tags
`INTERRUPT`, `CC_HARD`, `CC_SOFT`, `ROOT`, `SILENCE`, `FEAR`, `DISORIENT`, `KNOCKBACK`, `CC_BREAK`, `CC_IMMUNITY`

### Dispel Tags
`DISPEL_MAGIC`, `DISPEL_CURSE`, `DISPEL_POISON`, `DISPEL_DISEASE`, `PURGE`

### Utility Tags
`UTILITY`, `BUFF`, `DEBUFF`, `TAUNT`, `RESOURCE`, `RESURRECT`, `BATTLE_REZ`

### Pet Tags
`PET`, `PET_SUMMON`, `PET_CONTROL`, `PET_SUMMON_TEMP`, `REQUIRES_PET`

### Totem Tags
- `TOTEM` — Totem summon (tracks duration via SPELL_SUMMON)
- `TOTEM_EARTH` — Earth totem (one active at a time)
- `TOTEM_FIRE` — Fire totem (one active at a time)
- `TOTEM_WATER` — Water totem (one active at a time)
- `TOTEM_AIR` — Air totem (one active at a time)

### Stealth / Shapeshift Tags
`STEALTH`, `STEALTH_BREAK`, `SHAPESHIFT`, `STANCE`, `CAT_FORM`, `BEAR_FORM`

### Effect Tags
- `PROC`, `REACTIVE` — Proc-based / conditional abilities (Execute, Overpower, Revenge)
- `HAS_BUFF`, `HAS_DEBUFF`, `HAS_HOT`, `HAS_DOT` — Spell applies an effect

### External / Cross-Player Tags
- `IMPORTANT_EXTERNAL` — High-impact buff from another player or shared source (Bloodlust, PI, Innervate)
- `MINOR_EXTERNAL` — Lower-priority external buff (Drums) — available but not actively tracked by default

### Healing Subtypes
`HEAL_SINGLE`, `HEAL_AOE`, `HOT`

### Content Type Tags
`PVE`, `PVP`, `PVE_PVP`

### Deprecated Tags (still functional)
`CORE_ROTATION`, `SITUATIONAL`, `OFFENSIVE_CD`, `OFFENSIVE_CD_MINOR`, `HEALING_CD`, `HEALING_CD_MINOR`

### Tagging Guidelines

These rules ensure spells are categorized correctly for any consumer:

- **FILLER vs ROTATIONAL** — `FILLER` is for mana-gated spammables with no cooldown (Flash Heal, Fireball, Binding Heal). Rage/energy-gated abilities without cooldowns are `ROTATIONAL`, not `FILLER` — their resource cost is meaningful and worth displaying.
- **PERSONAL_DEFENSIVE vs HEAL** — Self-only emergency heals (Desperate Prayer) should use `PERSONAL_DEFENSIVE`, not `HEAL`. The `HEAL` role tag implies ally-targetable throughput. `HEAL_SINGLE`/`HEAL_AOE` subtypes can still be present as metadata.
- **specs field** — Only include specs that realistically use the spell in their default role. DPS spells shouldn't list healer specs (and vice versa). Niche/cross-role spells can use `specs = {}` (empty = no spec by default, available for manual enable).
- **talent field** — Only set `talent = true` for abilities learned via talent points. Baseline trainable abilities (even high-level ones like Shadowfiend at 66) should not have this flag.

## AuraTarget Constants (`lib.AuraTarget`)

Defined in `Categories.lua`:
```lua
lib.AuraTarget = {
    SELF = "self",   -- Buff appears on caster only (Barkskin, Evasion)
    ALLY = "ally",   -- Can target other players (Renew, BoP, PWS)
    PET  = "pet",    -- Targets pet (Mend Pet)
    NONE = "none",   -- No unit to track (AoE, totems, placed objects)
}
```

## Spec Constants (`lib.Specs`)

```lua
ARMS, FURY, PROTECTION,         -- Warrior
HOLY, RETRIBUTION,              -- Paladin (PROTECTION shared)
BEAST_MASTERY, MARKSMANSHIP, SURVIVAL,  -- Hunter
ASSASSINATION, COMBAT, SUBTLETY,       -- Rogue
DISCIPLINE, SHADOW,             -- Priest (HOLY shared)
ELEMENTAL, ENHANCEMENT, RESTORATION,   -- Shaman
ARCANE, FIRE, FROST,            -- Mage
AFFLICTION, DEMONOLOGY, DESTRUCTION,   -- Warlock
BALANCE, FERAL,                 -- Druid (RESTORATION shared)
```

`lib.CLASS_SPECS` maps class tokens to arrays of 3 spec names (by talent tree index).

## Key API Functions

### Spell Registration
- `lib:RegisterSpell(spellData)` — Register a single spell; returns boolean
- `lib:RegisterSpells(spellList, defaultClass)` — Register multiple; returns count

### Spell Queries
- `lib:GetSpellInfo(spellID)` — Get spell data (handles rank lookup via `rankToCanonical`)
- `lib:GetSpellsByClass(class)` — All spells for a class
- `lib:GetSpellsByTag(tag)` — All spells with a tag
- `lib:GetSpellsByTags(tags)` — Spells matching ANY tag (union)
- `lib:GetSpellsByAllTags(tags)` — Spells matching ALL tags (intersection)
- `lib:GetSpellsByClassAndTag(class, tag)` — Intersection of class + tag
- `lib:HasTag(spellID, tag)` — Check if spell has a tag
- `lib:GetTagsForSpell(spellID)` — Get all tags for a spell (tag -> true)
- `lib:GetAllSpells()` — Get entire spell database

### Aura Targeting
- `lib:GetAuraTarget(spellID)` — Returns "self", "ally", "pet", or "none" (also handles legacy `selfOnly` field conversion)
- `lib:IsSelfOnly(spellID)` — Returns true for "self" or "none"
- `lib:IsRotational(spellID)` — Check ROTATIONAL tag
- `lib:IsSingleTarget(spellID)` — Check if only one instance can be active at a time
- `lib:GetDispelType(spellID)` — Returns dispel type string for a spell's buff
- `lib:GetSpellIcon(spellID)` — Returns override icon texture ID, or nil (falls back to auto-resolved)

### Item Cooldowns & Requirements
- `lib:GetCooldownItemIDs(spellID)` — Returns array of item IDs for spells with item-based cooldowns, or nil
- `lib:GetItemCooldown(spellID)` — Queries `GetItemCooldown()` for each item; returns `remaining, duration, startTime` or nil
- `lib:GetRequiredItemIDs(spellID)` — Returns array of item IDs spell is gated behind (e.g., weapon procs), or nil

### Triggered Aura Queries
- `lib:GetAuraInfo(auraSpellID)` — Get `{sourceSpellID, tags, type, onTarget, duration}`
- `lib:GetAuraSourceSpellID(auraSpellID)` — Source spell for a triggered aura
- `lib:GetAuraTags(auraSpellID)` — Tags for a triggered aura
- `lib:AuraHasTag(auraSpellID, tag)` — Check if aura has tag

### Rank Utilities
- `lib:GetCanonicalSpellID(spellID)` — Base ID for any rank
- `lib:GetAllRankIDs(spellID)` — Set of all rank IDs
- `lib:GetHighestKnownRank(spellID)` — Highest rank player knows

### Spec Detection
- `lib:DetectPlayerSpec()` — Returns spec string + talent points table
- `lib:GetPlayerSpec()` — Cached spec
- `lib:GetTalentPoints()` / `lib:GetTalentDistribution()` — Talent point info
- `lib:DetectSpecBySignatureSpells(class)` — Fallback detection (deep talents)
- `lib:IsSpellRelevantForSpec(spellID)` — Check spec + race restrictions
- `lib:IsRaceRelevant(spellID)` — Check if spell matches player's race (ignores spec)
- `lib:GetSpellsForCurrentSpec(class)` — Filtered spells for current spec
- `lib:GetSpecDisplayName(specID)` — Display name for a spec

### Duration
- `lib:GetSpellDuration(spellID)` — Get duration for a specific rank (uses `rankDurations` if present, else `duration`)

### Procs
- `lib:GetProcs(class)` — Array of proc spell data for class
- `lib:GetProcInfo(spellID)` — Proc metadata for a spell
- `lib:GetReactiveWindow(spellID)` — Duration of usability window for reactive spells, or nil
- `lib:GetDodgeReactive(spellID)` — Duration of usability window after target dodges (e.g., Overpower), or nil

### Shared Cooldowns
- `lib:GetSharedCooldownGroup(spellID)` — Group name + info
- `lib:GetSharedCooldownSpells(spellID)` — All spells in same group

### BuffGroups
- `lib:GetBuffGroup(spellID)` — Returns group name and info table, or nil
- `lib:GetBuffGroupSpells(spellID)` — Returns array of spell IDs in the same group
- `lib:IsInBuffGroup(spellID)` — Boolean check if spell belongs to a BuffGroup
- `lib:GetBuffGroupRelationship(spellID)` — Returns `"equivalent"` or `"exclusive"`

### Iteration
- `lib:IterateSpells(filterFn)` — Iterator with filter function
- `lib:GetSortedSpells(spells, priorityFn)` — Sorted array

### Category Metadata
- `lib:GetCategoryInfo(category)` — Full metadata table
- `lib:GetCategoryName(category)` — Display name
- `lib:GetCategoryColor(category)` — `{r, g, b}`
- `lib:GetCategoryPriority(category)` — Priority number
- `lib:GetAllCategories()` — All category constants

### Utility / Debug
- `lib:GetGameVersion()` — "tbc", "anniversary", "wrath", "cata", "retail", "vanilla", "unknown"
- `lib:GetSpellCount()` / `lib:GetClassSpellCount(class)` — Counts
- `lib:GetInvalidSpellCount()` / `lib:DumpInvalidSpells()` — Invalid spell tracking
- `lib:SetDebugMode(enabled)` — Toggle debug warnings
- `lib:DumpSpellsByClass(class)` / `lib:DumpSpellsByTag(tag)` — Print to chat

## BuffGroup System (`lib.BuffGroups`)

Defined in `Categories.lua`. Groups related buff spells for consumer features like buff reminders.

### Relationship Types
- **`equivalent`** — Different spells providing the same buff (e.g., Fortitude / Prayer of Fortitude). Any one satisfies the requirement.
- **`exclusive`** — Only one spell from the group can be active at a time (e.g., Paladin Blessings, Mage Armors).

### BuffGroup Definition Structure
```lua
lib.BuffGroups.GROUP_NAME = {
    spells = {spellID1, spellID2},      -- Array of canonical spell IDs in this group
    relationship = "equivalent",         -- or "exclusive"
    -- Optional fields:
    talentGate = 18788,                  -- Check IsSpellKnown() on this ID instead of buff IDs
    excludeIfKnown = {19028, 30146},     -- If player knows any of these, default to disabled
    weaponEnchant = true,                -- Tracked via GetWeaponEnchantInfo(), not UnitBuff()
    itemBased = true,                    -- Applied via crafted items (e.g., poisons), not castable
    minLevel = 20,                       -- Minimum level to learn this ability
}
```

Spells reference their group via the `buffGroup` field in spell data.

## Internal Index Tables

- `spells` — Main database (`spellID -> spellData`)
- `spellsByClass` — Indexed by class token
- `spellsByTag` — Indexed by tag string
- `spellIDToTags` — Reverse index (`spellID -> {tag -> true}`)
- `rankToCanonical` — Rank mapping (any rank ID -> canonical base ID)
- `auraToSource` — Aura reverse index (`auraID -> {sourceSpellID, tags, type, onTarget}`)

## Slash Commands

`/spelldb` or `/lsdb`:
- `help` — Command list
- `stats` — Database statistics
- `class <CLASS>` — List spells for a class
- `tag <TAG>` — List spells with a tag
- `spell <ID>` — Show spell info
- `categories` — List all categories
- `invalid` — Show invalid spell IDs (wrong game version)
- `debug` — Toggle debug mode
- `version` — Show library + game version

## Code Conventions

- LibStub for library versioning (`"LibSpellDB-1.0"`, version `1`)
- All data files use shorthand: `local C = lib.Categories`, `local S = lib.Specs`, `local AT = lib.AuraTarget`
- Spells require `spellID`, `tags`; `class` is set by `defaultClass` in `RegisterSpells`
- Rank arrays ordered low to high
- `class = "SHARED"` for racials, trinkets, cross-class abilities
- Invalid spells (wrong game version) silently skipped, logged in debug mode
- Tags are uppercase snake_case strings
- Spec detection uses `GetTalentInfo()` iteration, falls back to signature spell detection
- Permissive when spec unknown (shows all class spells)
