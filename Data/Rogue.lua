--[[
    LibSpellDB - Rogue Spells (Anniversary Edition / Classic)
    TODO: Populate with full spell list
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Interrupts
    -------------------------------------------------------------------------------
    {
        spellID = 1766,  -- Kick
        tags = {C.INTERRUPT},
        cooldown = 10,
        duration = 5,  -- Lockout duration
        ranks = {1766, 1767, 1768, 1769},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control - Hard CC
    -------------------------------------------------------------------------------
    {
        spellID = 2094,  -- Blind
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 300,
        duration = 10,
    },
    {
        spellID = 6770,  -- Sap
        tags = {C.CC_HARD, C.DISORIENT, C.FILLER},  -- Spammable (stealth-only)
        cooldown = 0,
        duration = 45,
        ranks = {6770, 2070, 11297},
    },
    {
        spellID = 1776,  -- Gouge
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 10,
        duration = 4,
        ranks = {1776, 1777, 8629, 11285, 11286},
    },
    {
        spellID = 408,  -- Kidney Shot
        tags = {C.CC_HARD, C.FINISHER},
        cooldown = 20,
        duration = 6,  -- Max duration at 5 CP
        ranks = {408, 8643},
    },
    {
        spellID = 1833,  -- Cheap Shot
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 4,
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 5277,  -- Evasion
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 300,
        duration = 15,
    },
    {
        spellID = 1856,  -- Vanish
        tags = {C.PERSONAL_DEFENSIVE, C.MOVEMENT_ESCAPE, C.STEALTH},
        cooldown = 300,
        ranks = {1856, 1857},
    },
    {
        spellID = 31224,  -- Cloak of Shadows (TBC+, may not exist in Classic)
        tags = {C.PERSONAL_DEFENSIVE, C.IMMUNITY, C.TRACK_BUFF},
        cooldown = 90,
        duration = 5,
    },

    -------------------------------------------------------------------------------
    -- Reactive Abilities
    -------------------------------------------------------------------------------
    {
        spellID = 14251,  -- Riposte (usable after parry)
        tags = {C.CORE_ROTATION, C.REACTIVE, C.PVP},
        cooldown = 6,
        talent = true,
        specs = {"COMBAT"},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 13750,  -- Adrenaline Rush
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 300,
        duration = 15,
        talent = true,
    },
    {
        spellID = 13877,  -- Blade Flurry
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 120,
        duration = 15,
        talent = true,
    },
    {
        spellID = 14177,  -- Cold Blood
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 180,
        talent = true,
    },
    {
        spellID = 14185,  -- Preparation
        tags = {C.OFFENSIVE_CD, C.UTILITY},
        cooldown = 600,
        talent = true,
    },
    {
        spellID = 14278,  -- Ghostly Strike
        tags = {C.OFFENSIVE_CD_MINOR, C.PERSONAL_DEFENSIVE},
        cooldown = 20,
        duration = 7,
        talent = true,
    },
    {
        spellID = 14183,  -- Premeditation
        tags = {C.OFFENSIVE_CD_MINOR, C.RESOURCE},
        cooldown = 120,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 2983,  -- Sprint
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.TRACK_BUFF},
        cooldown = 300,
        duration = 15,
        ranks = {2983, 8696, 11305},
    },

    -------------------------------------------------------------------------------
    -- Stealth
    -------------------------------------------------------------------------------
    {
        spellID = 1784,  -- Stealth
        tags = {C.STEALTH},
        cooldown = 10,
        ranks = {1784, 1785, 1786, 1787},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation (Priority: SnD → Expose → Rupture → Builder → Evis)
    -------------------------------------------------------------------------------
    {
        spellID = 5171,  -- Slice and Dice (maintain first, #1 priority)
        tags = {C.CORE_ROTATION, C.FINISHER, C.BUFF, C.TRACK_BUFF, C.PVE},
        cooldown = 0,
        duration = 21,  -- Max at 5 CP
        priority = 1,
        ranks = {5171, 6774},
    },
    {
        spellID = 8647,  -- Expose Armor (situational - only if no warrior)
        tags = {C.SITUATIONAL, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 10,
        ranks = {8647, 8649, 8650, 11197, 11198, 26866},
    },
    {
        spellID = 1943,  -- Rupture (maintain DoT)
        tags = {C.CORE_ROTATION, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 22,  -- Max at 5 CP
        priority = 3,
        ranks = {1943, 8639, 8640, 11273, 11274, 11275, 26867},
    },
    {
        spellID = 1752,  -- Sinister Strike (CP builder)
        tags = {C.CORE_ROTATION, C.PVE},
        cooldown = 0,
        priority = 4,
        ranks = {1752, 1757, 1758, 1759, 1760, 8621, 11293, 11294, 26861, 26862},
        specs = {"COMBAT"},
    },
    {
        spellID = 2098,  -- Eviscerate (dump excess CP)
        tags = {C.CORE_ROTATION, C.FINISHER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016, 26865},
    },
    {
        spellID = 5938,  -- Shiv (apply poisons / utility - situational)
        tags = {C.SITUATIONAL, C.UTILITY, C.PVE_PVP},
        cooldown = 0,
        priority = 11,
    },
    {
        spellID = 1329,  -- Mutilate (Assassination builder)
        tags = {C.CORE_ROTATION, C.PVE},
        cooldown = 0,
        priority = 4,
        talent = true,
        specs = {"ASSASSINATION"},
    },
    {
        spellID = 16511,  -- Hemorrhage (Subtlety builder)
        tags = {C.CORE_ROTATION, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        talent = true,
        specs = {"SUBTLETY"},
        ranks = {16511, 17347, 17348, 26864},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 1725,  -- Distract
        tags = {C.UTILITY},
        cooldown = 30,
        duration = 10,
    },
    {
        spellID = 1966,  -- Feint
        tags = {C.UTILITY},
        cooldown = 10,
        ranks = {1966, 6768, 8637, 11303},
    },

    -------------------------------------------------------------------------------
    -- Poisons (for tracking application)
    -------------------------------------------------------------------------------
    {
        spellID = 3409,  -- Crippling Poison
        tags = {C.CC_SOFT, C.DEBUFF},
        duration = 12,
        ranks = {3409, 11201},
    },

}, "ROGUE")
