--[[
    LibSpellDB - Priest Spells (Anniversary Edition / Classic)
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Crowd Control - Hard CC
    -------------------------------------------------------------------------------
    {
        spellID = 8122,  -- Psychic Scream
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 30,
        duration = 8,
        ranks = {8122, 8124, 10888, 10890},
    },
    {
        spellID = 605,  -- Mind Control
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 60,
        ranks = {605, 10911, 10912},
    },
    {
        spellID = 9484,  -- Shackle Undead
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 50,
        ranks = {9484, 9485, 10955},
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
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 586,  -- Fade
        tags = {C.PERSONAL_DEFENSIVE, C.UTILITY},
        cooldown = 30,
        duration = 10,
        ranks = {586, 9578, 9579, 9592, 10941, 10942},
    },
    {
        spellID = 15286,  -- Vampiric Embrace
        tags = {C.PERSONAL_DEFENSIVE, C.BUFF, C.TRACK_BUFF},
        cooldown = 0,
        duration = 60,  -- Buff on self, heals based on shadow damage
        talent = true,
    },
    {
        spellID = 15473,  -- Shadowform
        tags = {C.PERSONAL_DEFENSIVE, C.SHAPESHIFT, C.OFFENSIVE_CD},
        cooldown = 1.5,
        talent = true,
    },
    {
        spellID = 6346,  -- Fear Ward
        tags = {C.PERSONAL_DEFENSIVE, C.EXTERNAL_DEFENSIVE, C.CC_IMMUNITY, C.TRACK_BUFF},
        cooldown = 30,
        duration = 180,
    },

    -------------------------------------------------------------------------------
    -- External Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 17,  -- Power Word: Shield
        tags = {C.EXTERNAL_DEFENSIVE, C.PERSONAL_DEFENSIVE, C.HEAL_SINGLE, C.TRACK_BUFF},
        cooldown = 0,
        duration = 30,
        ranks = {17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901},
    },
    {
        spellID = 13908,  -- Desperate Prayer (Dwarf/Human racial talent)
        tags = {C.PERSONAL_DEFENSIVE, C.HEAL_SINGLE},
        cooldown = 600,
        ranks = {13908, 19236, 19238, 19240, 19241, 19242, 19243},
    },
    {
        spellID = 724,  -- Lightwell
        tags = {C.RAID_DEFENSIVE, C.HEAL_AOE},
        cooldown = 600,
        duration = 180,
        talent = true,
        ranks = {724, 27870, 27871},
    },

    -------------------------------------------------------------------------------
    -- Healing Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 14751,  -- Inner Focus
        tags = {C.HEALING_CD, C.RESOURCE, C.TRACK_BUFF},
        cooldown = 180,
        duration = 0,  -- Next spell only
        talent = true,
    },
    {
        spellID = 10060,  -- Power Infusion
        tags = {C.HEALING_CD, C.OFFENSIVE_CD, C.EXTERNAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 180,
        duration = 15,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Single Target Heals
    -------------------------------------------------------------------------------
    {
        spellID = 2050,  -- Lesser Heal
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {2050, 2052, 2053},
    },
    {
        spellID = 2054,  -- Heal
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {2054, 2055, 6063, 6064},
    },
    {
        spellID = 2060,  -- Greater Heal
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {2060, 10963, 10964, 10965, 25314},
    },
    {
        spellID = 596,  -- Prayer of Healing
        tags = {C.HEAL_AOE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {596, 996, 10960, 10961, 25316},
    },
    {
        spellID = 2061,  -- Flash Heal
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {2061, 9472, 9473, 9474, 10915, 10916, 10917},
    },

    -------------------------------------------------------------------------------
    -- HoTs
    -------------------------------------------------------------------------------
    {
        spellID = 139,  -- Renew
        tags = {C.HOT, C.HEAL_SINGLE, C.CORE_ROTATION},
        cooldown = 0,
        duration = 15,
        ranks = {139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315},
    },

    -------------------------------------------------------------------------------
    -- Dispels
    -------------------------------------------------------------------------------
    {
        spellID = 527,  -- Dispel Magic
        tags = {C.DISPEL_MAGIC, C.PURGE},
        cooldown = 0,
        ranks = {527, 988},
    },
    {
        spellID = 552,  -- Abolish Disease
        tags = {C.DISPEL_DISEASE},
        cooldown = 0,
        duration = 20,
    },
    {
        spellID = 528,  -- Cure Disease
        tags = {C.DISPEL_DISEASE},
        cooldown = 0,
    },

    -------------------------------------------------------------------------------
    -- Offensive / Shadow
    -------------------------------------------------------------------------------
    {
        spellID = 8092,  -- Mind Blast
        tags = {C.CORE_ROTATION},
        cooldown = 8,
        ranks = {8092, 8102, 8103, 8104, 8105, 8106, 10945, 10946, 10947},
    },
    {
        spellID = 589,  -- Shadow Word: Pain
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 0,
        duration = 18,
        ranks = {589, 594, 970, 992, 2767, 10892, 10893, 10894},
    },
    {
        spellID = 2944,  -- Devouring Plague (Undead racial)
        tags = {C.CORE_ROTATION, C.DEBUFF, C.PERSONAL_DEFENSIVE},
        cooldown = 180,
        duration = 24,
        ranks = {2944, 19276, 19277, 19278, 19279, 19280},
    },
    {
        spellID = 15407,  -- Mind Flay
        tags = {C.CORE_ROTATION, C.CC_SOFT},
        cooldown = 0,
        duration = 3,
        talent = true,
        ranks = {15407, 17311, 17312, 17313, 17314, 18807},
    },
    {
        spellID = 34914,  -- Vampiric Touch
        tags = {C.CORE_ROTATION, C.DEBUFF, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        talent = true,
        ranks = {34914, 34916, 34917},
    },
    {
        spellID = 585,  -- Smite
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {585, 591, 598, 984, 1004, 6060, 10933, 10934},
    },
    {
        spellID = 14914,  -- Holy Fire
        tags = {C.CORE_ROTATION},
        cooldown = 10,
        ranks = {14914, 15262, 15263, 15264, 15265, 15266, 15267, 15261},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 1706,  -- Levitate
        tags = {C.UTILITY, C.MOVEMENT},
        cooldown = 0,
        duration = 120,
    },
    {
        spellID = 14752,  -- Divine Spirit
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 1800,
        talent = true,
        ranks = {14752, 14818, 14819, 27841},
    },
    {
        spellID = 21562,  -- Prayer of Fortitude
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 3600,
        ranks = {21562, 21564},
    },
    {
        spellID = 1243,  -- Power Word: Fortitude
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 1800,
        ranks = {1243, 1244, 1245, 2791, 10937, 10938},
    },
    {
        spellID = 976,  -- Shadow Protection
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 600,
        ranks = {976, 10957, 10958},
    },
    {
        spellID = 15237,  -- Holy Nova
        tags = {C.HEAL_AOE, C.CORE_ROTATION},
        cooldown = 0,
        talent = true,
        ranks = {15237, 15430, 15431, 27799, 27800, 27801},
    },
    {
        spellID = 8129,  -- Mana Burn
        tags = {C.UTILITY, C.RESOURCE},
        cooldown = 0,
        ranks = {8129, 8131, 10874, 10875, 10876},
    },

    -------------------------------------------------------------------------------
    -- Resurrection
    -------------------------------------------------------------------------------
    {
        spellID = 2006,  -- Resurrection
        tags = {C.RESURRECT, C.UTILITY},
        cooldown = 0,
        ranks = {2006, 2010, 10880, 10881, 20770},
    },

    -------------------------------------------------------------------------------
    -- Mana Management
    -------------------------------------------------------------------------------
    {
        spellID = 588,  -- Inner Fire
        tags = {C.BUFF, C.PERSONAL_DEFENSIVE},
        cooldown = 0,
        duration = 600,
        ranks = {588, 7128, 602, 1006, 10951, 10952},
    },

}, "PRIEST")
