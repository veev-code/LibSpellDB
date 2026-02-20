--[[
    LibSpellDB - Categories
    Defines all spell categories/tags used for classification
]]

local MAJOR, MINOR = "LibSpellDB-1.0", 1
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

-------------------------------------------------------------------------------
-- Category Definitions
-------------------------------------------------------------------------------

-- Category constants for type safety and autocomplete
lib.Categories = {
    -------------------------------------------------------------------------------
    -- Role Tags (what type of throughput/role the ability serves)
    -------------------------------------------------------------------------------
    DPS                 = "DPS",                 -- Deals or increases damage
    HEAL                = "HEAL",                -- Heals or increases healing output
    TANK                = "TANK",                -- Tank-specific ability

    -------------------------------------------------------------------------------
    -- Usage Pattern Tags (how/when you use the ability)
    -------------------------------------------------------------------------------
    ROTATIONAL          = "ROTATIONAL",          -- Core rotation, used on cooldown (Primary Row)
    MAINTENANCE         = "MAINTENANCE",         -- Buff/debuff to keep up (Secondary Row)
    MINOR               = "MINOR",               -- Cooldown <60s, tactical usage (Secondary Row)
    MAJOR               = "MAJOR",               -- Cooldown 60s+, save for key moments (Secondary Row)
    AOE                 = "AOE",                 -- AoE version of ability

    -------------------------------------------------------------------------------
    -- Legacy Tags (kept for compatibility, will migrate away)
    -------------------------------------------------------------------------------
    CORE_ROTATION       = "CORE_ROTATION",       -- DEPRECATED: Use ROTATIONAL + role tag
    SITUATIONAL         = "SITUATIONAL",         -- Situational/niche utility (not critical uptime)
    OFFENSIVE_CD        = "OFFENSIVE_CD",        -- DEPRECATED: Use DPS + MAJOR
    OFFENSIVE_CD_MINOR  = "OFFENSIVE_CD_MINOR",  -- DEPRECATED: Use DPS + MINOR

    -------------------------------------------------------------------------------
    -- Exclusion Tags (abilities to hide from HUD)
    -------------------------------------------------------------------------------
    FILLER              = "FILLER",              -- Mana-based spammables (excluded from HUD by default)
    OUT_OF_COMBAT       = "OUT_OF_COMBAT",       -- Abilities only used out of combat (excluded from HUD)
    LONG_BUFF           = "LONG_BUFF",           -- Long-duration buffs cast out of combat (excluded from HUD)

    -------------------------------------------------------------------------------
    -- Ability Mechanics
    -------------------------------------------------------------------------------
    FINISHER            = "FINISHER",            -- Combo point / resource spenders
    CONSUMES_ALL_RESOURCE = "CONSUMES_ALL_RESOURCE", -- Drains ALL remaining resource, not just base cost (Execute)

    -------------------------------------------------------------------------------
    -- Healing Subtypes
    -------------------------------------------------------------------------------
    HEALING_CD          = "HEALING_CD",          -- DEPRECATED: Use HEAL + MAJOR
    HEALING_CD_MINOR    = "HEALING_CD_MINOR",    -- DEPRECATED: Use HEAL + MINOR
    HEAL_SINGLE         = "HEAL_SINGLE",         -- Single-target heals
    HEAL_AOE            = "HEAL_AOE",            -- AoE/group heals
    HOT                 = "HOT",                 -- Heal over time

    -------------------------------------------------------------------------------
    -- Defensive
    -------------------------------------------------------------------------------
    DEFENSIVE           = "DEFENSIVE",           -- Reduces damage taken (composable with MINOR/MAJOR)
    PERSONAL_DEFENSIVE  = "PERSONAL_DEFENSIVE",  -- Self-survival cooldowns
    EXTERNAL_DEFENSIVE  = "EXTERNAL_DEFENSIVE",  -- Defensives castable on others
    RAID_DEFENSIVE      = "RAID_DEFENSIVE",      -- Raid-wide damage reduction

    -- Immunity & Damage Reduction
    IMMUNITY            = "IMMUNITY",            -- Full immunity effects
    DAMAGE_REDUCTION    = "DAMAGE_REDUCTION",    -- Flat damage reduction

    -- Movement
    MOVEMENT            = "MOVEMENT",            -- Movement speed / gap closers
    MOVEMENT_SPEED      = "MOVEMENT_SPEED",      -- Speed increases
    MOVEMENT_GAP_CLOSE  = "MOVEMENT_GAP_CLOSE",  -- Charges, blinks, leaps
    MOVEMENT_ESCAPE     = "MOVEMENT_ESCAPE",     -- Disengages, vanishes

    -- Crowd Control
    INTERRUPT           = "INTERRUPT",           -- Spell interrupts
    CC_HARD             = "CC_HARD",             -- Hard CC (stuns, incapacitates, polymorphs)
    CC_SOFT             = "CC_SOFT",             -- Soft CC (slows, snares)
    ROOT                = "ROOT",                -- Root effects
    SILENCE             = "SILENCE",             -- Silence effects
    FEAR                = "FEAR",                -- Fear effects
    DISORIENT           = "DISORIENT",           -- Disorients (sap, blind, etc)
    KNOCKBACK           = "KNOCKBACK",           -- Knockback effects

    -- CC Breaking / Prevention
    CC_BREAK            = "CC_BREAK",            -- Breaks CC (trinket, berserker rage)
    CC_IMMUNITY         = "CC_IMMUNITY",         -- Prevents CC application

    -- Dispels
    DISPEL_MAGIC        = "DISPEL_MAGIC",        -- Dispels magic effects
    DISPEL_CURSE        = "DISPEL_CURSE",        -- Dispels curses
    DISPEL_POISON       = "DISPEL_POISON",       -- Dispels poisons
    DISPEL_DISEASE      = "DISPEL_DISEASE",      -- Dispels diseases
    PURGE               = "PURGE",               -- Offensive dispel (removes enemy buffs)

    -- Utility
    UTILITY             = "UTILITY",             -- General utility
    BUFF                = "BUFF",                -- Beneficial buffs to apply
    DEBUFF              = "DEBUFF",              -- Harmful debuffs to apply
    TAUNT               = "TAUNT",               -- Threat / taunt abilities
    RESOURCE            = "RESOURCE",            -- Resource generation / management
    RESURRECT           = "RESURRECT",           -- Resurrection abilities
    BATTLE_REZ          = "BATTLE_REZ",          -- In-combat resurrection

    -- Pet Related
    PET                 = "PET",                 -- Pet abilities
    PET_SUMMON          = "PET_SUMMON",          -- Pet summoning
    PET_CONTROL         = "PET_CONTROL",         -- Pet control abilities
    PET_SUMMON_TEMP     = "PET_SUMMON_TEMP",     -- Temporary pet/guardian summons
    REQUIRES_PET        = "REQUIRES_PET",        -- Spell requires an alive pet (Soul Link)
    TOTEM               = "TOTEM",               -- Totem summon (tracks duration via SPELL_SUMMON)
    TOTEM_EARTH         = "TOTEM_EARTH",         -- Earth totem (only one Earth totem active at a time)
    TOTEM_FIRE          = "TOTEM_FIRE",          -- Fire totem (only one Fire totem active at a time)
    TOTEM_WATER         = "TOTEM_WATER",         -- Water totem (only one Water totem active at a time)
    TOTEM_AIR           = "TOTEM_AIR",           -- Air totem (only one Air totem active at a time)

    -- Stealth
    STEALTH             = "STEALTH",             -- Stealth abilities
    STEALTH_BREAK       = "STEALTH_BREAK",       -- Breaks stealth on use

    -- Shapeshift / Stance
    SHAPESHIFT          = "SHAPESHIFT",          -- Form changes
    STANCE              = "STANCE",              -- Stance changes
    CAT_FORM            = "CAT_FORM",            -- Requires Cat Form (feral druid)
    BEAR_FORM           = "BEAR_FORM",           -- Requires Bear Form (feral druid)

    -- Proc / Reactive
    PROC                = "PROC",                -- Proc-based abilities
    REACTIVE            = "REACTIVE",            -- Reactive/conditional abilities - usability shown via overlay (Overpower, Revenge, Execute)

    -- Spell Effects (describes what the spell applies)
    HAS_BUFF            = "HAS_BUFF",            -- Applies a buff (same ID as spell unless appliesAura set)
    HAS_DEBUFF          = "HAS_DEBUFF",          -- Applies a debuff on target
    HAS_HOT             = "HAS_HOT",             -- Applies a heal over time
    HAS_DOT             = "HAS_DOT",             -- Applies a damage over time

    -- Content Type (for filtering)
    PVE                 = "PVE",                 -- Primarily PvE ability
    PVP                 = "PVP",                 -- Primarily PvP ability
    PVE_PVP             = "PVE_PVP",             -- Important in both contexts
}

-------------------------------------------------------------------------------
-- Aura Target Types (where the buff/effect appears for tracking purposes)
-------------------------------------------------------------------------------

lib.AuraTarget = {
    SELF = "self",   -- Buff appears on caster only (Barkskin, Evasion, Ice Block)
    ALLY = "ally",   -- Can target other friendly players (Renew, BoP, PWS)
    PET  = "pet",    -- Targets pet (Mend Pet)
    NONE = "none",   -- No unit to track - AoE around caster, totems, placed objects
}

-------------------------------------------------------------------------------
-- Category Metadata
-------------------------------------------------------------------------------

lib.CategoryInfo = {
    -- Role Tags
    [lib.Categories.DPS] = {
        name = "DPS",
        description = "Deals or increases damage",
        color = {1.0, 0.2, 0.2},  -- Red
        priority = 100,
    },
    [lib.Categories.HEAL] = {
        name = "Healing",
        description = "Heals or increases healing output",
        color = {0.2, 1.0, 0.2},  -- Green
        priority = 100,
    },
    [lib.Categories.TANK] = {
        name = "Tank",
        description = "Tank-specific ability",
        color = {0.3, 0.6, 1.0},  -- Blue
        priority = 100,
    },
    -- Usage Pattern Tags
    [lib.Categories.ROTATIONAL] = {
        name = "Rotational",
        description = "Core rotation, used on cooldown",
        color = {1.0, 0.8, 0.0},  -- Gold
        priority = 100,
    },
    [lib.Categories.MAINTENANCE] = {
        name = "Maintenance",
        description = "Buff/debuff to keep up",
        color = {0.8, 0.6, 0.2},  -- Bronze
        priority = 90,
    },
    [lib.Categories.MINOR] = {
        name = "Minor Cooldown",
        description = "Cooldown <60s, tactical usage",
        color = {1.0, 0.5, 0.0},  -- Orange
        priority = 85,
    },
    [lib.Categories.MAJOR] = {
        name = "Major Cooldown",
        description = "Cooldown 60s+, save for key moments",
        color = {1.0, 0.3, 0.3},  -- Bright red
        priority = 80,
    },
    -- Legacy (deprecated)
    [lib.Categories.CORE_ROTATION] = {
        name = "Core Rotation",
        description = "DEPRECATED: Use ROTATIONAL + role tag",
        color = {1.0, 0.8, 0.0},  -- Gold
        priority = 100,
    },
    [lib.Categories.SITUATIONAL] = {
        name = "Situational",
        description = "Situational/niche utility — not critical for general uptime",
        color = {1.0, 0.5, 0.0},  -- Orange
        priority = 95,
    },
    [lib.Categories.OFFENSIVE_CD] = {
        name = "Offensive Cooldowns",
        description = "DEPRECATED: Use DPS + MAJOR",
        color = {1.0, 0.2, 0.2},  -- Red
        priority = 90,
    },
    [lib.Categories.HEALING_CD] = {
        name = "Healing Cooldowns",
        description = "DEPRECATED: Use HEAL + MAJOR",
        color = {0.2, 1.0, 0.2},  -- Green
        priority = 90,
    },
    [lib.Categories.PERSONAL_DEFENSIVE] = {
        name = "Personal Defensives",
        description = "Self-survival cooldowns",
        color = {0.3, 0.6, 1.0},  -- Blue
        priority = 85,
    },
    [lib.Categories.EXTERNAL_DEFENSIVE] = {
        name = "External Defensives",
        description = "Defensive cooldowns for others",
        color = {0.5, 0.8, 1.0},  -- Light blue
        priority = 80,
    },
    [lib.Categories.IMMUNITY] = {
        name = "Immunities",
        description = "Full immunity effects",
        color = {1.0, 1.0, 0.5},  -- Yellow
        priority = 95,
    },
    [lib.Categories.MOVEMENT] = {
        name = "Movement",
        description = "Movement and mobility abilities",
        color = {0.8, 0.5, 1.0},  -- Purple
        priority = 70,
    },
    [lib.Categories.INTERRUPT] = {
        name = "Interrupts",
        description = "Spell interrupt abilities",
        color = {1.0, 0.5, 0.0},  -- Orange
        priority = 88,
    },
    [lib.Categories.CC_HARD] = {
        name = "Hard CC",
        description = "Stuns, incapacitates, polymorphs",
        color = {0.9, 0.9, 0.0},  -- Yellow
        priority = 85,
    },
    [lib.Categories.CC_SOFT] = {
        name = "Soft CC",
        description = "Slows, snares, roots",
        color = {0.7, 0.7, 0.3},  -- Dim yellow
        priority = 60,
    },
    [lib.Categories.DISPEL_MAGIC] = {
        name = "Dispel Magic",
        description = "Dispels magic effects",
        color = {0.5, 0.5, 1.0},  -- Blue-purple
        priority = 75,
    },
    [lib.Categories.UTILITY] = {
        name = "Utility",
        description = "General utility abilities",
        color = {0.6, 0.6, 0.6},  -- Gray
        priority = 40,
    },
    [lib.Categories.PET_SUMMON_TEMP] = {
        name = "Temporary Pet Summon",
        description = "Summons a temporary pet or guardian",
        color = {0.4, 0.8, 1.0},  -- Light blue
        priority = 55,
    },
    [lib.Categories.TOTEM] = {
        name = "Totem",
        description = "Totem summon with known duration (tracked via SPELL_SUMMON)",
        color = {0.0, 0.6, 0.8},  -- Teal
        priority = 55,
    },
    [lib.Categories.TOTEM_EARTH] = {
        name = "Earth Totem",
        description = "Earth element totem (only one active at a time)",
        color = {0.6, 0.4, 0.2},  -- Brown
        priority = 55,
    },
    [lib.Categories.TOTEM_FIRE] = {
        name = "Fire Totem",
        description = "Fire element totem (only one active at a time)",
        color = {1.0, 0.4, 0.1},  -- Orange-red
        priority = 55,
    },
    [lib.Categories.TOTEM_WATER] = {
        name = "Water Totem",
        description = "Water element totem (only one active at a time)",
        color = {0.2, 0.5, 1.0},  -- Blue
        priority = 55,
    },
    [lib.Categories.TOTEM_AIR] = {
        name = "Air Totem",
        description = "Air element totem (only one active at a time)",
        color = {0.7, 0.7, 1.0},  -- Light blue-white
        priority = 55,
    },
    [lib.Categories.TAUNT] = {
        name = "Taunt",
        description = "Threat and taunt abilities",
        color = {0.8, 0.4, 0.1},  -- Brown-orange
        priority = 82,
    },
}

-------------------------------------------------------------------------------
-- Shared Cooldown Groups
-- Some abilities share cooldowns (e.g., Warrior's 30-min CDs).
-- Use sharedCooldownGroup field in spell data to document these relationships.
-- Filter by spec to show only the most relevant ability from each group.
-------------------------------------------------------------------------------

lib.SharedCooldownGroups = {
    WARRIOR_30MIN_CD = {
        description = "Recklessness, Retaliation, Shield Wall share a 30-minute cooldown",
        spells = {1719, 20230, 871},  -- Recklessness, Retaliation, Shield Wall
    },
}

-- Get shared cooldown group info for a spell
function lib:GetSharedCooldownGroup(spellID)
    local spellData = self:GetSpellInfo(spellID)
    if spellData and spellData.sharedCooldownGroup then
        return spellData.sharedCooldownGroup, self.SharedCooldownGroups[spellData.sharedCooldownGroup]
    end
    return nil, nil
end

-- Get all spell IDs that share a cooldown with the given spell
function lib:GetSharedCooldownSpells(spellID)
    local groupName, groupInfo = self:GetSharedCooldownGroup(spellID)
    if groupInfo then
        return groupInfo.spells
    end
    return nil
end

-------------------------------------------------------------------------------
-- Buff Groups
-- Spells that are related for buff reminder purposes.
-- Use buffGroup field in spell data to document these relationships.
--
-- Relationship types:
--   "equivalent" - Different spells providing the same buff (e.g., PW:Fort / Prayer of Fort).
--                  If ANY version is active on the target, the group is satisfied.
--   "exclusive"  - Only one can be active from the same caster (e.g., Battle Shout / Commanding Shout).
--                  If ANY is active, the group is satisfied. Player configures which to prioritize.
-------------------------------------------------------------------------------

lib.BuffGroups = {
    -- Equivalent groups (single-target + group version of the same buff)
    PRIEST_FORTITUDE = {
        description = "Stamina buff",
        spells = {1243, 21562},
        relationship = "equivalent",
    },
    PRIEST_SPIRIT = {
        description = "Spirit buff",
        spells = {14752, 27681},
        relationship = "equivalent",
    },
    PRIEST_SHADOW_PROT = {
        description = "Shadow resistance",
        spells = {976, 27683},
        relationship = "equivalent",
    },
    DRUID_MOTW = {
        description = "Mark of the Wild",
        spells = {1126, 21849},
        relationship = "equivalent",
    },
    MAGE_INTELLECT = {
        description = "Intellect buff",
        spells = {1459, 23028},
        relationship = "equivalent",
    },
    PALADIN_BLESSINGS = {
        description = "Paladin blessings",
        spells = {19740, 19742, 20217, 1038, 20911, 19977, 25782, 25894, 25898, 25895, 25899, 25890},
        relationship = "exclusive",
    },

    -- Exclusive groups (same caster can only maintain one at a time)
    WARRIOR_SHOUTS = {
        description = "Warrior shouts",
        spells = {6673, 469},
        relationship = "exclusive",
    },
    WARLOCK_ARMOR = {
        description = "Warlock armor",
        spells = {687, 706, 28176},
        relationship = "exclusive",
    },
    WARLOCK_DEMONIC_SACRIFICE = {
        description = "Demonic Sacrifice",
        spells = {18789, 18790, 18791, 18792, 35701},
        relationship = "exclusive",
        talentGate = 18788,  -- Check this spell for IsSpellKnown instead of buff IDs
        excludeIfKnown = {19028, 30146},  -- Soul Link, Summon Felguard: if known, player keeps pet alive
    },
    MAGE_ARMOR = {
        description = "Mage armor",
        spells = {6117, 7302, 30482, 168},
        relationship = "exclusive",
    },
    MAGE_MAGIC_MODIFIER = {
        description = "Magic modifier",
        spells = {1008, 604},
        relationship = "exclusive",
    },
    SHAMAN_SHIELD = {
        description = "Shaman shields",
        spells = {24398, 324, 974},
        relationship = "exclusive",
    },
    PALADIN_AURAS = {
        description = "Paladin auras",
        spells = {465, 19746, 7294, 19891, 19888, 19876, 20218},
        relationship = "exclusive",
    },
    HUNTER_ASPECTS = {
        description = "Hunter aspects",
        spells = {13165, 13163, 5118, 13159, 13161, 34074},
        relationship = "exclusive",
    },

    -- Weapon enchant groups (tracked via GetWeaponEnchantInfo, not UnitBuff)
    ROGUE_POISONS = {
        description = "Rogue poisons",
        spells = {8679, 2823, 13219, 5761, 3408},
        relationship = "exclusive",
        weaponEnchant = true,
        itemBased = true,   -- Applied via crafted items, not castable spells
        minLevel = 20,      -- Rogues learn poisons at level 20
    },
    SHAMAN_WEAPON_IMBUES = {
        description = "Shaman weapon imbues",
        spells = {8024, 8232, 8033, 8017},
        relationship = "exclusive",
        weaponEnchant = true,
    },
}

-- Get buff group info for a spell
function lib:GetBuffGroup(spellID)
    local spellData = self:GetSpellInfo(spellID)
    if spellData and spellData.buffGroup then
        return spellData.buffGroup, self.BuffGroups[spellData.buffGroup]
    end
    return nil, nil
end

-- Get all spell IDs in the same buff group as the given spell
function lib:GetBuffGroupSpells(spellID)
    local groupName, groupInfo = self:GetBuffGroup(spellID)
    if groupInfo then
        return groupInfo.spells
    end
    return nil
end

-- Check if a spell belongs to a buff group
function lib:IsInBuffGroup(spellID)
    local spellData = self:GetSpellInfo(spellID)
    return spellData and spellData.buffGroup ~= nil
end

-- Get the relationship type for a spell's buff group
function lib:GetBuffGroupRelationship(spellID)
    local _, groupInfo = self:GetBuffGroup(spellID)
    if groupInfo then
        return groupInfo.relationship
    end
    return nil
end

-------------------------------------------------------------------------------
-- Helper Functions
-------------------------------------------------------------------------------

function lib:GetCategoryInfo(category)
    return self.CategoryInfo[category]
end

function lib:GetCategoryName(category)
    local info = self.CategoryInfo[category]
    return info and info.name or category
end

function lib:GetCategoryColor(category)
    local info = self.CategoryInfo[category]
    return info and info.color or {1, 1, 1}
end

function lib:GetCategoryPriority(category)
    local info = self.CategoryInfo[category]
    return info and info.priority or 50
end

function lib:GetAllCategories()
    return self.Categories
end
