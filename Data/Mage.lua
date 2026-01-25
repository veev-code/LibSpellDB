--[[
    LibSpellDB - Mage Spells (Anniversary Edition / Classic)
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
        spellID = 2139,  -- Counterspell
        tags = {C.INTERRUPT},
        cooldown = 30,
        duration = 10,  -- Lockout duration
    },

    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 118,  -- Polymorph
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 0,
        duration = 50,
        ranks = {118, 12824, 12825, 12826},
    },
    {
        spellID = 122,  -- Frost Nova
        tags = {C.ROOT, C.CC_SOFT},
        cooldown = 25,
        duration = 8,
        ranks = {122, 865, 6131, 10230},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives / Immunities
    -------------------------------------------------------------------------------
    {
        spellID = 11958,  -- Ice Block (Cold Snap can reset this)
        tags = {C.IMMUNITY, C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 300,
        duration = 10,
        talent = true,
    },
    {
        spellID = 45438,  -- Ice Block (learned version in later expansions)
        tags = {C.IMMUNITY, C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 300,
        duration = 10,
    },
    {
        spellID = 11426,  -- Ice Barrier
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 30,
        duration = 60,
        talent = true,
        ranks = {11426, 13031, 13032, 13033},
    },
    {
        spellID = 543,  -- Fire Ward
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {543, 8457, 8458, 10223, 10225},
    },
    {
        spellID = 6143,  -- Frost Ward
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {6143, 8461, 8462, 10177, 28609},
    },
    {
        spellID = 1463,  -- Mana Shield
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 0,
        duration = 60,
        ranks = {1463, 8494, 8495, 10191, 10192, 10193},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 12042,  -- Arcane Power
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 180,
        duration = 15,
        talent = true,
    },
    {
        spellID = 12043,  -- Presence of Mind
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 180,
        talent = true,
    },
    {
        spellID = 11129,  -- Combustion
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 180,
        talent = true,
    },
    {
        spellID = 12472,  -- Icy Veins / Cold Snap
        tags = {C.OFFENSIVE_CD, C.UTILITY},
        cooldown = 600,  -- Resets frost cooldowns
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 1953,  -- Blink
        tags = {C.MOVEMENT, C.MOVEMENT_ESCAPE},
        cooldown = 15,
    },

    -------------------------------------------------------------------------------
    -- Resource
    -------------------------------------------------------------------------------
    {
        spellID = 12051,  -- Evocation
        tags = {C.RESOURCE, C.UTILITY},
        cooldown = 480,
        duration = 8,
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 130,  -- Slow Fall
        tags = {C.UTILITY, C.MOVEMENT},
        cooldown = 0,
        duration = 30,
    },
    {
        spellID = 11113,  -- Blast Wave
        tags = {C.CORE_ROTATION, C.CC_SOFT, C.KNOCKBACK},
        cooldown = 45,
        talent = true,
        ranks = {11113, 13018, 13019, 13020, 13021},
    },

}, "MAGE")
