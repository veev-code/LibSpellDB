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
        tags = {C.CC_HARD, C.DISORIENT},
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
    -- Core Rotation
    -------------------------------------------------------------------------------
    {
        spellID = 1752,  -- Sinister Strike
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {1752, 1757, 1758, 1759, 1760, 8621, 11293, 11294},
    },
    {
        spellID = 2098,  -- Eviscerate
        tags = {C.CORE_ROTATION, C.FINISHER},
        cooldown = 0,
        ranks = {2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300},
    },
    {
        spellID = 1943,  -- Rupture
        tags = {C.CORE_ROTATION, C.FINISHER, C.DEBUFF},
        cooldown = 0,
        duration = 22,  -- Max at 5 CP
        ranks = {1943, 8639, 8640, 11273, 11274, 11275},
    },
    {
        spellID = 5171,  -- Slice and Dice
        tags = {C.CORE_ROTATION, C.FINISHER, C.BUFF, C.TRACK_BUFF},
        cooldown = 0,
        duration = 21,  -- Max at 5 CP
        ranks = {5171, 6774},
    },
    {
        spellID = 16511,  -- Hemorrhage
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 0,
        talent = true,
        ranks = {16511, 17347, 17348},
    },
    {
        spellID = 1329,  -- Mutilate (TBC+)
        tags = {C.CORE_ROTATION},
        cooldown = 0,
        talent = true,
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
