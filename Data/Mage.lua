--[[
    LibSpellDB - Mage Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.ARCANE, S.FIRE, S.FROST}
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories
local S = lib.Specs
local AT = lib.AuraTarget

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Interrupts
    -------------------------------------------------------------------------------
    {
        spellID = 2139,  -- Counterspell
        tags = {C.INTERRUPT},
        cooldown = 30,
        duration = 10,  -- Lockout duration
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 118,  -- Polymorph
        tags = {C.CC_HARD, C.DISORIENT, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 50,
        ranks = {118, 12824, 12825, 12826, 28270, 28271, 28272},
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 122,  -- Frost Nova
        tags = {C.ROOT, C.CC_SOFT},
        cooldown = 25,
        duration = 8,
        ranks = {122, 865, 6131, 10230, 27088},
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives / Immunities (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 11958,  -- Ice Block (Cold Snap can reset this)
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 300,
        duration = 10,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.FROST},
    },
    {
        spellID = 45438,  -- Ice Block (learned version in later expansions)
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 300,
        duration = 10,
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 11426,  -- Ice Barrier
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 60,
        talent = true,
        ranks = {11426, 13031, 13032, 13033, 27134, 33405},
        auraTarget = AT.SELF,
        specs = {S.FROST},
    },
    {
        spellID = 543,  -- Fire Ward
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {543, 8457, 8458, 10223, 10225, 27128},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 6143,  -- Frost Ward
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {6143, 8461, 8462, 10177, 28609, 32796},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 1463,  -- Mana Shield
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 0,
        duration = 60,
        ranks = {1463, 8494, 8495, 10191, 10192, 10193, 27131},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 12042,  -- Arcane Power
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE},
        cooldown = 180,
        duration = 15,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ARCANE},
    },
    {
        spellID = 12043,  -- Presence of Mind
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ARCANE},
    },
    {
        spellID = 11129,  -- Combustion
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.FIRE},
    },
    {
        spellID = 12472,  -- Icy Veins (TBC)
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE},
        cooldown = 180,
        duration = 20,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.FROST, S.ARCANE, S.FIRE},  -- Used by all specs in TBC
    },
    {
        spellID = 11958,  -- Cold Snap (resets CDs - utility, not pure throughput)
        tags = {C.DPS, C.MAJOR, C.UTILITY, C.PVE_PVP},
        cooldown = 600,  -- Resets frost cooldowns
        talent = true,
        specs = {S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Fire (Priority: Scorch debuff → Fireball → Fire Blast)
    -------------------------------------------------------------------------------
    {
        spellID = 2948,  -- Scorch (maintain Improved Scorch debuff first)
        tags = {C.DPS, C.MAINTENANCE, C.DEBUFF, C.PVE},
        cooldown = 0,
        priority = 1,
        ranks = {2948, 8444, 8445, 8446, 10205, 10206, 10207, 27073, 27074},
        specs = {S.FIRE},
    },
    {
        spellID = 133,  -- Fireball (main nuke - filler, not tracked)
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 2,
        ranks = {133, 143, 145, 3140, 8400, 8401, 8402, 10148, 10149, 10150, 10151, 25306, 27070, 38692},
        specs = {S.FIRE},
    },
    {
        spellID = 2136,  -- Fire Blast (instant, use while moving)
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 8,
        priority = 3,
        ranks = {2136, 2137, 2138, 8412, 8413, 10197, 10199, 27078, 27079, 33938},
        specs = {S.FIRE},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Arcane (Priority: Arcane Blast → Frostbolt/Missiles filler)
    -------------------------------------------------------------------------------
    {
        spellID = 30451,  -- Arcane Blast (main nuke, build stacks)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 1,
        specs = {S.ARCANE},
    },
    {
        spellID = 116,  -- Frostbolt (filler/mana conservation - main for Frost)
        tags = {C.DPS, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 2,
        ranks = {116, 205, 837, 7322, 8406, 8407, 8408, 10179, 10180, 10181, 25304, 27071, 27072, 38697},
        specs = {S.FROST, S.ARCANE},
    },
    {
        spellID = 5143,  -- Arcane Missiles (Clearcasting proc / filler)
        tags = {C.DPS, C.ROTATIONAL, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {5143, 5144, 5145, 8416, 8417, 10211, 10212, 25345, 27075, 38699, 38704},
        specs = {S.ARCANE},
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 1953,  -- Blink
        tags = {C.MOVEMENT, C.MOVEMENT_ESCAPE},
        cooldown = 15,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Resource
    -------------------------------------------------------------------------------
    {
        spellID = 12051,  -- Evocation
        tags = {C.RESOURCE, C.UTILITY},
        cooldown = 480,
        duration = 8,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- AoE / Soft CC
    -------------------------------------------------------------------------------
    {
        spellID = 120,  -- Cone of Cold
        tags = {C.DPS, C.AOE, C.CC_SOFT},
        cooldown = 10,
        duration = 8,
        ranks = {120, 8492, 10159, 10160, 10161, 27087},
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 31661,  -- Dragon's Breath
        tags = {C.DPS, C.AOE, C.CC_HARD, C.DISORIENT},
        cooldown = 20,
        duration = 3,
        talent = true,
        ranks = {31661, 33041, 33042, 33043},
        specs = {S.FIRE},
    },
    {
        spellID = 2120,  -- Flamestrike
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 8,
        ranks = {2120, 2121, 8422, 8423, 10215, 10216, 27086},
        specs = {S.FIRE},
    },
    {
        spellID = 10,  -- Blizzard
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 8,
        ranks = {10, 6141, 8427, 10185, 10186, 10187, 27085},
        specs = {S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 130,  -- Slow Fall
        tags = {C.UTILITY, C.MOVEMENT, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 30,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 31589,  -- Slow
        tags = {C.CC_SOFT, C.UTILITY},
        cooldown = 0,
        duration = 15,
        talent = true,
        specs = {S.ARCANE},
    },
    {
        spellID = 11113,  -- Blast Wave (AoE, situational)
        tags = {C.DPS, C.AOE, C.CC_SOFT, C.KNOCKBACK},
        cooldown = 45,
        talent = true,
        ranks = {11113, 13018, 13019, 13020, 13021, 27133, 33933},
        specs = {S.FIRE},
    },

}, "MAGE")
