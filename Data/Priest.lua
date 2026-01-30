--[[
    LibSpellDB - Priest Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.DISCIPLINE, S.HOLY, S.SHADOW}
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories
local S = lib.Specs

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Crowd Control - Hard CC
    -------------------------------------------------------------------------------
    {
        spellID = 44046,  -- Chastise (Holy talent, Humanoids only)
        tags = {C.CC_HARD, C.ROOT},
        cooldown = 30,
        duration = 2,
        talent = true,
        ranks = {44041, 44043, 44044, 44045, 44046},
        specs = {S.HOLY},
    },
    {
        spellID = 8122,  -- Psychic Scream
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 30,
        duration = 8,
        ranks = {8122, 8124, 10888, 10890, 27610},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 605,  -- Mind Control
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC, exclude from HUD
        cooldown = 0,
        duration = 60,
        ranks = {605, 10911, 10912, 27620},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 9484,  -- Shackle Undead
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC, exclude from HUD
        cooldown = 0,
        duration = 50,
        ranks = {9484, 9485, 10955, 27655},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Silence
    -------------------------------------------------------------------------------
    {
        spellID = 15487,  -- Silence
        tags = {C.SILENCE, C.INTERRUPT},
        cooldown = 45,
        duration = 5,
        talent = true,
        specs = {S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 586,  -- Fade
        tags = {C.DEFENSIVE, C.MINOR, C.UTILITY},
        cooldown = 30,
        duration = 10,
        ranks = {586, 9578, 9579, 9592, 10941, 10942, 27614},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 15286,  -- Vampiric Embrace
        tags = {C.DPS, C.MAINTENANCE, C.HAS_DEBUFF},
        cooldown = 0,
        duration = 60,  -- Debuff on target, heals party based on shadow damage
        talent = true,
        specs = {S.SHADOW},
    },
    {
        spellID = 15473,  -- Shadowform
        tags = {C.DPS, C.MAJOR, C.SHAPESHIFT},
        cooldown = 1.5,
        talent = true,
        specs = {S.SHADOW},
    },
    {
        spellID = 6346,  -- Fear Ward (preventative buff, not reactive CD)
        tags = {C.CC_BREAK, C.CC_IMMUNITY, C.HAS_BUFF},
        cooldown = 30,
        duration = 180,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- External Defensives (Utility row - not throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 33206,  -- Pain Suppression (Discipline talent)
        tags = {C.EXTERNAL_DEFENSIVE, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 120,
        duration = 8,
        talent = true,
        specs = {S.DISCIPLINE},
    },
    {
        spellID = 13908,  -- Desperate Prayer (Dwarf/Human racial talent)
        tags = {C.HEAL, C.MAJOR, C.HEAL_SINGLE},
        cooldown = 600,
        ranks = {13908, 19236, 19238, 19240, 19241, 19242, 19243, 25437},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 724,  -- Lightwell
        tags = {C.RAID_DEFENSIVE, C.HEAL_AOE},
        cooldown = 600,
        duration = 180,
        talent = true,
        ranks = {724, 27870, 27871, 28276},
        specs = {S.HOLY},
    },

    -------------------------------------------------------------------------------
    -- Healing/DPS Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 14751,  -- Inner Focus
        tags = {C.HEAL, C.MAJOR, C.RESOURCE, C.HAS_BUFF},
        cooldown = 180,
        duration = 0,  -- Next spell only
        talent = true,
        specs = {S.DISCIPLINE},
    },
    {
        spellID = 10060,  -- Power Infusion
        tags = {C.DPS, C.HEAL, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        duration = 15,
        talent = true,
        specs = {S.DISCIPLINE},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Holy/Disc Healing (Priority: PoM → PW:S → CoH → Renew → GH/FH)
    -------------------------------------------------------------------------------
    {
        spellID = 33076,  -- Prayer of Mending (use on pull/CD)
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 10,
        duration = 30,
        priority = 1,
        specs = {S.HOLY, S.DISCIPLINE},
    },
    {
        spellID = 17,  -- Power Word: Shield (prevent damage)
        tags = {C.HEAL, C.ROTATIONAL, C.EXTERNAL_DEFENSIVE, C.HEAL_SINGLE, C.HAS_BUFF},
        specs = {S.DISCIPLINE, S.HOLY},
        cooldown = 0,
        duration = 30,
        priority = 2,
        ranks = {17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901, 25217, 25218},
        -- Weakened Soul debuff prevents casting PWS on same target for 15s
        -- Check friendly target first, fallback to self if targeting enemy
        targetLockoutDebuff = 6788,
    },
    {
        spellID = 34861,  -- Circle of Healing (instant AoE heal)
        tags = {C.HEAL, C.AOE, C.HEAL_AOE, C.PVE},
        cooldown = 0,
        priority = 10,
        talent = true,
        ranks = {34861, 34863, 34864, 34865, 34866},
        specs = {S.HOLY},
    },
    {
        spellID = 139,  -- Renew (maintain on tank)
        tags = {C.HEAL, C.ROTATIONAL, C.HOT, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        duration = 15,
        priority = 4,
        ranks = {139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315, 25221, 25222},
        specs = {S.HOLY, S.DISCIPLINE},
    },
    {
        spellID = 2060,  -- Greater Heal (big heal)
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE},
        cooldown = 0,
        priority = 5,
        ranks = {2060, 10963, 10964, 10965, 25314, 25210},
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 2061,  -- Flash Heal (fast heal)
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 6,
        ranks = {2061, 9472, 9473, 9474, 10915, 10916, 10917, 25233, 25235},
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 32546,  -- Binding Heal (heal self + target)
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 7,
        specs = {S.HOLY, S.DISCIPLINE},
    },
    {
        spellID = 596,  -- Prayer of Healing (group AoE)
        tags = {C.HEAL, C.AOE, C.HEAL_AOE, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 8,
        ranks = {596, 996, 10960, 10961, 25316, 25308},
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 2054,  -- Heal (downranked efficiency)
        tags = {C.HEAL_SINGLE, C.FILLER},
        cooldown = 0,
        priority = 9,
        ranks = {2054, 2055, 6063, 6064},
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 2050,  -- Lesser Heal (leveling only)
        tags = {C.HEAL_SINGLE, C.FILLER},
        cooldown = 0,
        priority = 10,
        ranks = {2050, 2052, 2053},
        specs = {S.DISCIPLINE, S.HOLY},
    },

    -------------------------------------------------------------------------------
    -- Dispels (spammable, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 527,  -- Dispel Magic
        tags = {C.DISPEL_MAGIC, C.PURGE, C.FILLER},
        cooldown = 0,
        ranks = {527, 988},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 552,  -- Abolish Disease
        tags = {C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
        duration = 20,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 528,  -- Cure Disease
        tags = {C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Shadow (Priority: VT → SW:P → MB → MF → SW:D)
    -------------------------------------------------------------------------------
    {
        spellID = 34914,  -- Vampiric Touch (apply first for mana)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.RESOURCE, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 1,
        talent = true,
        ranks = {34914, 34916, 34917, 34918, 34919},
        specs = {S.SHADOW},
    },
    {
        spellID = 589,  -- Shadow Word: Pain (maintain DoT)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 18,
        priority = 2,
        ranks = {589, 594, 970, 992, 2767, 10892, 10893, 10894, 25367, 25368},
        specs = {S.SHADOW},
    },
    {
        spellID = 8092,  -- Mind Blast (use on CD)
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 8,
        priority = 3,
        ranks = {8092, 8102, 8103, 8104, 8105, 8106, 10945, 10946, 10947, 25372, 25375},
        specs = {S.SHADOW},
    },
    {
        spellID = 15407,  -- Mind Flay (filler between MBs)
        tags = {C.DPS, C.ROTATIONAL, C.CC_SOFT, C.PVE_PVP},
        cooldown = 0,
        duration = 3,
        priority = 4,
        talent = true,
        ranks = {15407, 17311, 17312, 17313, 17314, 18807, 25387},
        specs = {S.SHADOW},
    },
    {
        spellID = 32996,  -- Shadow Word: Death (execute / finisher)
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 12,
        priority = 5,
        ranks = {32379, 32380, 32996},
        specs = {S.SHADOW},
    },
    {
        spellID = 2944,  -- Devouring Plague (Undead racial, extra DoT)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 180,
        duration = 24,
        priority = 6,
        ranks = {2944, 19276, 19277, 19278, 19279, 19280, 25467},
        specs = {S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Offensive - Holy/Smite (less common, not part of any core TBC rotation)
    -------------------------------------------------------------------------------
    {
        spellID = 14914,  -- Holy Fire (opener for Smite weaving / solo)
        tags = {C.DPS, C.MINOR, C.PVE},  -- Not ROTATIONAL - no Smite DPS spec in TBC
        cooldown = 10,
        ranks = {14914, 15262, 15263, 15264, 15265, 15266, 15267, 15261, 25384},
        specs = {S.DISCIPLINE, S.HOLY},  -- Exclude from Shadow
    },
    {
        spellID = 585,  -- Smite (filler)
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        ranks = {585, 591, 598, 984, 1004, 6060, 10933, 10934, 25363, 25364},
        specs = {S.DISCIPLINE, S.HOLY},
    },

    -------------------------------------------------------------------------------
    -- Utility (mostly out of combat)
    -------------------------------------------------------------------------------
    {
        spellID = 1706,  -- Levitate
        tags = {C.UTILITY, C.MOVEMENT, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 120,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 14752,  -- Divine Spirit
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        talent = true,
        ranks = {14752, 14818, 14819, 27841, 32999},
        specs = {S.DISCIPLINE},
    },
    {
        spellID = 21562,  -- Prayer of Fortitude
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 3600,
        ranks = {21562, 21564, 25392},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 1243,  -- Power Word: Fortitude
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {1243, 1244, 1245, 2791, 10937, 10938, 25389},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 976,  -- Shadow Protection
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        ranks = {976, 10957, 10958, 25433},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 15237,  -- Holy Nova (AoE, situational)
        tags = {C.HEAL, C.AOE, C.HEAL_AOE, C.FILLER},
        cooldown = 0,
        talent = true,
        ranks = {15237, 15430, 15431, 27799, 27800, 27801},
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 8129,  -- Mana Burn
        tags = {C.UTILITY, C.RESOURCE, C.FILLER},  -- Spammable
        cooldown = 0,
        ranks = {8129, 8131, 10874, 10875, 10876, 25379, 25380},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Resurrection (out of combat)
    -------------------------------------------------------------------------------
    {
        spellID = 2006,  -- Resurrection
        tags = {C.RESURRECT, C.UTILITY, C.OUT_OF_COMBAT},
        cooldown = 0,
        ranks = {2006, 2010, 10880, 10881, 20770, 25435},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Mana Management
    -------------------------------------------------------------------------------
    {
        spellID = 588,  -- Inner Fire
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        ranks = {588, 602, 1006, 7128, 10951, 10952, 25431},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

}, "PRIEST")
