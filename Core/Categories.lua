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
    SITUATIONAL         = "SITUATIONAL",         -- DEPRECATED: Use MINOR/MAJOR + role tag
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

    -- Stealth
    STEALTH             = "STEALTH",             -- Stealth abilities
    STEALTH_BREAK       = "STEALTH_BREAK",       -- Breaks stealth on use

    -- Shapeshift / Stance
    SHAPESHIFT          = "SHAPESHIFT",          -- Form changes
    STANCE              = "STANCE",              -- Stance changes

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
        description = "DEPRECATED: Use MINOR/MAJOR + role tag",
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
