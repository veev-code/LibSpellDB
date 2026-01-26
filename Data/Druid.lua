--[[
    LibSpellDB - Druid Spells (Anniversary Edition / Classic)
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
        spellID = 16979,  -- Feral Charge
        tags = {C.INTERRUPT, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 15,
        duration = 4,  -- Interrupt lockout
        talent = true,
    },
    {
        spellID = 5211,  -- Bash
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 4,
        ranks = {5211, 6798, 8983},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 339,  -- Entangling Roots
        tags = {C.ROOT, C.CC_SOFT},
        cooldown = 0,
        duration = 27,
        ranks = {339, 1062, 5195, 5196, 9852, 9853},
    },
    {
        spellID = 2637,  -- Hibernate
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 40,
        ranks = {2637, 18657, 18658},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 22812,  -- Barkskin
        tags = {C.DEFENSIVE, C.MINOR, C.DAMAGE_REDUCTION, C.HAS_BUFF},
        cooldown = 60,
        duration = 12,
    },
    {
        spellID = 22842,  -- Frenzied Regeneration
        tags = {C.DEFENSIVE, C.MAJOR, C.HEAL_SINGLE, C.HAS_BUFF},
        cooldown = 180,
        duration = 10,
    },
    {
        spellID = 16689,  -- Nature's Grasp
        tags = {C.DEFENSIVE, C.MINOR, C.ROOT, C.HAS_BUFF},
        cooldown = 60,
        duration = 45,
        ranks = {16689, 16810, 16811, 16812, 16813, 17329},
    },

    -------------------------------------------------------------------------------
    -- Healing/DPS Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 17116,  -- Nature's Swiftness
        tags = {C.HEAL, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Raid Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 740,  -- Tranquility
        tags = {C.HEAL, C.MAJOR, C.HEAL_AOE},
        cooldown = 300,
        duration = 10,
        ranks = {740, 8918, 9862, 9863},
    },
    {
        spellID = 29166,  -- Innervate
        tags = {C.HEAL, C.MAJOR, C.RESOURCE, C.HAS_BUFF},
        cooldown = 360,
        duration = 20,
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 1850,  -- Dash
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        ranks = {1850, 9821},
    },
    {
        spellID = 5215,  -- Prowl
        tags = {C.STEALTH},
        cooldown = 10,
        ranks = {5215, 6783, 9913},
    },

    -------------------------------------------------------------------------------
    -- Shapeshifts
    -------------------------------------------------------------------------------
    {
        spellID = 768,  -- Cat Form
        tags = {C.SHAPESHIFT},
        cooldown = 0,
    },
    {
        spellID = 5487,  -- Bear Form
        tags = {C.SHAPESHIFT},
        cooldown = 0,
    },
    {
        spellID = 9634,  -- Dire Bear Form
        tags = {C.SHAPESHIFT},
        cooldown = 0,
    },
    {
        spellID = 783,  -- Travel Form
        tags = {C.SHAPESHIFT, C.MOVEMENT},
        cooldown = 0,
    },
    {
        spellID = 24858,  -- Moonkin Form
        tags = {C.SHAPESHIFT, C.DPS},
        cooldown = 0,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 20484,  -- Rebirth
        tags = {C.BATTLE_REZ, C.RESURRECT, C.UTILITY},
        cooldown = 1800,
        ranks = {20484, 20739, 20742, 20747, 20748},
    },
    {
        spellID = 5209,  -- Challenging Roar
        tags = {C.TAUNT},
        cooldown = 600,
        duration = 6,
    },
    {
        spellID = 6795,  -- Growl
        tags = {C.TAUNT},
        cooldown = 10,
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Balance (Priority: MF → IS → Starfire → FoN)
    -------------------------------------------------------------------------------
    {
        spellID = 8921,  -- Moonfire (apply first, instant)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 12,
        priority = 1,
        ranks = {8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835, 26987, 26988},
    },
    {
        spellID = 5570,  -- Insect Swarm (maintain DoT)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 12,
        priority = 2,
        talent = true,
        ranks = {5570, 24974, 24975, 24976, 24977, 27013},
        specs = {"BALANCE"},
    },
    {
        spellID = 2912,  -- Starfire (main nuke)
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {2912, 8949, 8950, 8951, 9875, 9876, 25298, 26986},
        specs = {"BALANCE"},
    },
    {
        spellID = 33831,  -- Force of Nature (use on CD - throughput CD)
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.PVE},
        cooldown = 180,
        duration = 30,
        priority = 4,
        talent = true,
        specs = {"BALANCE"},
    },
    {
        spellID = 16914,  -- Hurricane (AoE)
        tags = {C.DPS, C.AOE, C.CC_SOFT, C.PVE},
        cooldown = 60,
        duration = 10,
        priority = 10,
        ranks = {16914, 17401, 17402, 27012},
        specs = {"BALANCE"},
    },
    {
        spellID = 770,  -- Faerie Fire (armor debuff)
        tags = {C.DEBUFF, C.UTILITY, C.PVE_PVP},
        cooldown = 0,
        duration = 40,
        priority = 6,
        ranks = {770, 778, 9749, 9907, 26993},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Feral Cat (Priority: Mangle → Shred → Rip → FB)
    -------------------------------------------------------------------------------
    {
        spellID = 33983,  -- Mangle (Cat) (apply debuff first)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        priority = 1,
        talent = true,
        specs = {"FERAL"},
    },
    {
        spellID = 27002,  -- Shred (main CP builder from behind)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 2,
        ranks = {5221, 6800, 8992, 9829, 9830, 27001, 27002},
        specs = {"FERAL"},
    },
    {
        spellID = 1079,  -- Rip (maintain at 5 CP)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 12,
        priority = 3,
        ranks = {1079, 9492, 9493, 9752, 9894, 9896, 27008},
        specs = {"FERAL"},
    },
    {
        spellID = 22568,  -- Ferocious Bite (dump excess CP/energy)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {22568, 22827, 22828, 22829, 31018, 24248},
        specs = {"FERAL"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Feral Bear (Priority: Mangle → Lacerate → Swipe → Maul)
    -------------------------------------------------------------------------------
    {
        spellID = 33987,  -- Mangle (Bear) (highest threat on CD)
        tags = {C.TANK, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 6,
        priority = 1,
        talent = true,
        specs = {"FERAL"},
    },
    {
        spellID = 33745,  -- Lacerate (stack and maintain)
        tags = {C.TANK, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 2,
        specs = {"FERAL"},
    },
    {
        spellID = 779,  -- Swipe (AoE threat)
        tags = {C.TANK, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 0,
        priority = 3,
        ranks = {779, 780, 769, 9754, 9908, 26997},
        specs = {"FERAL"},
    },
    {
        spellID = 6807,  -- Maul (rage dump - situational)
        tags = {C.TANK, C.MINOR, C.PVE},
        cooldown = 0,
        priority = 10,
        ranks = {6807, 6808, 6809, 8972, 9745, 9880, 9881, 26996},
        specs = {"FERAL"},
    },
    {
        spellID = 99,  -- Demoralizing Roar (maintain debuff)
        tags = {C.DEBUFF, C.UTILITY, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 5,
        ranks = {99, 1735, 9490, 9747, 9898, 26998},
        specs = {"FERAL"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Restoration (Priority: LB x3 → Rejuv → Regrowth → SM)
    -------------------------------------------------------------------------------
    {
        spellID = 33763,  -- Lifebloom (stack to 3, maintain)
        tags = {C.HEAL, C.ROTATIONAL, C.HOT, C.HEAL_SINGLE, C.PVE},
        cooldown = 0,
        duration = 7,
        priority = 1,
        specs = {"RESTORATION"},
    },
    {
        spellID = 774,  -- Rejuvenation (maintain on targets)
        tags = {C.HEAL, C.ROTATIONAL, C.HOT, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        duration = 12,
        priority = 2,
        ranks = {774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299, 26981, 26982},
        specs = {"RESTORATION"},
    },
    {
        spellID = 8936,  -- Regrowth (spot heal + HoT)
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.HOT, C.PVE_PVP},
        cooldown = 0,
        duration = 21,
        priority = 3,
        ranks = {8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858, 26980},
        specs = {"RESTORATION"},
    },
    {
        spellID = 18562,  -- Swiftmend (emergency heal)
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 15,
        priority = 4,
        talent = true,
        specs = {"RESTORATION"},
    },
    {
        spellID = 5185,  -- Healing Touch (big heal / NS combo)
        tags = {C.HEAL_SINGLE, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {5185, 5186, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889, 25297, 26978, 26979},
    },
    {
        spellID = 33891,  -- Tree of Life (maintain form)
        tags = {C.SHAPESHIFT, C.BUFF, C.PVE},
        cooldown = 0,
        priority = 0,  -- Pre-combat form
        talent = true,
        specs = {"RESTORATION"},
    },

}, "DRUID")
