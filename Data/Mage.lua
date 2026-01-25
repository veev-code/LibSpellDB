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
        tags = {C.CC_HARD, C.DISORIENT, C.FILLER},  -- Spammable CC
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
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF, C.PVE},
        cooldown = 180,
        duration = 15,
        talent = true,
        specs = {"ARCANE"},
    },
    {
        spellID = 12043,  -- Presence of Mind
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF, C.PVE_PVP},
        cooldown = 180,
        talent = true,
        specs = {"ARCANE"},
    },
    {
        spellID = 11129,  -- Combustion
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF, C.PVE},
        cooldown = 180,
        talent = true,
        specs = {"FIRE"},
    },
    {
        spellID = 12472,  -- Icy Veins (TBC)
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF, C.PVE},
        cooldown = 180,
        duration = 20,
        talent = true,
        specs = {"FROST", "ARCANE", "FIRE"},  -- Used by all specs in TBC
    },
    {
        spellID = 11958,  -- Cold Snap
        tags = {C.OFFENSIVE_CD, C.UTILITY, C.PVE_PVP},
        cooldown = 600,  -- Resets frost cooldowns
        talent = true,
        specs = {"FROST"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Fire (Priority: Scorch debuff → Fireball → Fire Blast)
    -------------------------------------------------------------------------------
    {
        spellID = 2948,  -- Scorch (maintain Improved Scorch debuff first)
        tags = {C.CORE_ROTATION, C.DEBUFF, C.PVE},
        cooldown = 0,
        priority = 1,
        ranks = {2948, 8444, 8445, 8446, 10205, 10206, 10207, 27073, 27074},
        specs = {"FIRE"},
    },
    {
        spellID = 133,  -- Fireball (main nuke)
        tags = {C.CORE_ROTATION, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 2,
        ranks = {133, 143, 145, 3140, 8400, 8401, 8402, 10148, 10149, 10150, 10151, 25306, 27070},
        specs = {"FIRE"},
    },
    {
        spellID = 2136,  -- Fire Blast (instant, use while moving)
        tags = {C.CORE_ROTATION, C.PVE_PVP},
        cooldown = 8,
        priority = 3,
        ranks = {2136, 2137, 2138, 8412, 8413, 10197, 10199, 27078, 27079},
        specs = {"FIRE"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Arcane (Priority: Arcane Blast → Frostbolt/Missiles filler)
    -------------------------------------------------------------------------------
    {
        spellID = 30451,  -- Arcane Blast (main nuke, build stacks)
        tags = {C.CORE_ROTATION, C.PVE},
        cooldown = 0,
        priority = 1,
        specs = {"ARCANE"},
    },
    {
        spellID = 116,  -- Frostbolt (filler/mana conservation)
        tags = {C.CORE_ROTATION, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 2,
        ranks = {116, 205, 837, 7322, 8406, 8407, 8408, 10179, 10180, 10181, 25304, 27071, 27072},
        specs = {"FROST", "ARCANE"},
    },
    {
        spellID = 5143,  -- Arcane Missiles (Clearcasting proc / filler)
        tags = {C.CORE_ROTATION, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {5143, 5144, 5145, 8416, 8417, 10211, 10212, 25345, 27075, 38699, 38704},
        specs = {"ARCANE"},
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
        tags = {C.UTILITY, C.MOVEMENT, C.OUT_OF_COMBAT},
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
