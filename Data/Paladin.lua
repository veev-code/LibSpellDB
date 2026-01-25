--[[
    LibSpellDB - Paladin Spells (Anniversary Edition / Classic)
    TODO: Populate with full spell list
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 853,  -- Hammer of Justice
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 6,
        ranks = {853, 5588, 5589, 10308},
    },
    {
        spellID = 20066,  -- Repentance
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 60,
        duration = 6,
        talent = true,
    },
    {
        spellID = 2878,  -- Turn Undead
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 30,
        duration = 20,
        ranks = {2878, 5627, 10326},
    },

    -------------------------------------------------------------------------------
    -- Immunities
    -------------------------------------------------------------------------------
    {
        spellID = 642,  -- Divine Shield
        tags = {C.IMMUNITY, C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 300,
        duration = 12,
        ranks = {642, 1020},
    },
    {
        spellID = 498,  -- Divine Protection
        tags = {C.IMMUNITY, C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 300,
        duration = 8,
        ranks = {498, 5573},
    },

    -------------------------------------------------------------------------------
    -- External Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 1022,  -- Blessing of Protection
        tags = {C.EXTERNAL_DEFENSIVE, C.IMMUNITY, C.TRACK_BUFF},
        cooldown = 300,
        duration = 10,
        ranks = {1022, 5599, 10278},
    },
    {
        spellID = 6940,  -- Blessing of Sacrifice
        tags = {C.EXTERNAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 0,  -- No CD in Classic
        duration = 30,
        ranks = {6940, 20729},
    },
    {
        spellID = 1044,  -- Blessing of Freedom
        tags = {C.EXTERNAL_DEFENSIVE, C.CC_BREAK, C.TRACK_BUFF},
        cooldown = 20,
        duration = 10,
    },
    {
        spellID = 19752,  -- Divine Intervention
        tags = {C.EXTERNAL_DEFENSIVE, C.UTILITY},
        cooldown = 3600,
    },
    {
        spellID = 20216,  -- Divine Favor
        tags = {C.HEALING_CD, C.TRACK_BUFF},
        cooldown = 120,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 633,  -- Lay on Hands
        tags = {C.PERSONAL_DEFENSIVE, C.EXTERNAL_DEFENSIVE, C.HEAL_SINGLE, C.HEALING_CD},
        cooldown = 3600,
        ranks = {633, 2800, 10310},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Holy Healing (Priority: HS → FoL → HL)
    -------------------------------------------------------------------------------
    {
        spellID = 20473,  -- Holy Shock (instant, use on CD)
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION, C.OFFENSIVE_CD_MINOR, C.PVE_PVP},
        cooldown = 30,
        priority = 1,
        talent = true,
        ranks = {20473, 20929, 20930, 27174, 33072},
        specs = {"HOLY"},
    },
    {
        spellID = 19750,  -- Flash of Light (efficient, fast)
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 2,
        ranks = {19750, 19939, 19940, 19941, 19942, 19943, 27137},
    },
    {
        spellID = 635,  -- Holy Light (big heal when needed)
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {635, 639, 647, 1026, 1042, 3472, 10328, 10329, 25292, 27135, 27136},
    },
    {
        spellID = 31842,  -- Divine Illumination (mana CD)
        tags = {C.HEALING_CD, C.RESOURCE, C.TRACK_BUFF, C.PVE},
        cooldown = 180,
        duration = 15,
        priority = 4,
        talent = true,
        specs = {"HOLY"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Retribution (Priority: Seal → CS → Judge → Consec → HoW)
    -------------------------------------------------------------------------------
    {
        spellID = 31892,  -- Seal of Blood (maintain, Horde)
        tags = {C.BUFF, C.CORE_ROTATION, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 1,
        specs = {"RETRIBUTION"},
    },
    {
        spellID = 35395,  -- Crusader Strike (use on CD)
        tags = {C.CORE_ROTATION, C.PVE_PVP},
        cooldown = 6,
        priority = 2,
        talent = true,
        specs = {"RETRIBUTION"},
    },
    {
        spellID = 20271,  -- Judgement (use on CD)
        tags = {C.CORE_ROTATION, C.PVE_PVP},
        cooldown = 10,
        priority = 3,
    },
    {
        spellID = 26573,  -- Consecration (use on CD)
        tags = {C.CORE_ROTATION, C.PVE_PVP},
        cooldown = 8,
        duration = 8,
        priority = 4,
        talent = true,
        ranks = {26573, 20116, 20922, 20923, 20924, 27173},
    },
    {
        spellID = 24275,  -- Hammer of Wrath (sub-20% execute)
        tags = {C.CORE_ROTATION, C.FINISHER, C.REACTIVE, C.PVE_PVP},
        cooldown = 6,
        priority = 5,
        ranks = {24275, 24274, 24239, 27180},
        specs = {"RETRIBUTION"},
    },
    {
        spellID = 879,  -- Exorcism (vs Undead/Demon only - situational)
        tags = {C.SITUATIONAL, C.PVE},
        cooldown = 15,
        priority = 10,
        ranks = {879, 5614, 5615, 10312, 10313, 10314, 27138},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Protection (Priority: Holy Shield → AS → Consec → Judge)
    -------------------------------------------------------------------------------
    {
        spellID = 20925,  -- Holy Shield (maintain for block)
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF, C.CORE_ROTATION, C.PVE},
        cooldown = 10,
        duration = 10,
        priority = 1,
        talent = true,
        ranks = {20925, 20927, 20928, 27179},
        specs = {"PROTECTION"},
    },
    {
        spellID = 31935,  -- Avenger's Shield (pull / on CD)
        tags = {C.CORE_ROTATION, C.CC_SOFT, C.PVE},
        cooldown = 30,
        priority = 2,
        talent = true,
        specs = {"PROTECTION"},
    },
    {
        spellID = 31884,  -- Avenging Wrath (DPS CD)
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF, C.PVE_PVP},
        cooldown = 180,
        duration = 20,
        priority = 7,
    },

    -------------------------------------------------------------------------------
    -- Auras (long buffs, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 465,  -- Devotion Aura
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {465, 10290, 643, 10291, 1032, 10292, 10293},
    },
    {
        spellID = 19746,  -- Concentration Aura
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
    },
    {
        spellID = 7294,  -- Retribution Aura
        tags = {C.BUFF, C.OFFENSIVE_CD_MINOR, C.LONG_BUFF},
        cooldown = 0,
        ranks = {7294, 10298, 10299, 10300, 10301},
    },
    {
        spellID = 19891,  -- Fire Resistance Aura
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {19891, 19899, 19900},
    },
    {
        spellID = 19888,  -- Frost Resistance Aura
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {19888, 19897, 19898},
    },
    {
        spellID = 19876,  -- Shadow Resistance Aura
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {19876, 19895, 19896},
    },
    {
        spellID = 20218,  -- Sanctity Aura
        tags = {C.BUFF, C.OFFENSIVE_CD_MINOR, C.LONG_BUFF},
        cooldown = 0,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Blessings
    -------------------------------------------------------------------------------
    {
        spellID = 19740,  -- Blessing of Might
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 300,
        ranks = {19740, 19834, 19835, 19836, 19837, 19838, 25291},
    },
    {
        spellID = 20217,  -- Blessing of Kings
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 300,
        talent = true,
    },
    {
        spellID = 19742,  -- Blessing of Wisdom
        tags = {C.BUFF, C.UTILITY, C.RESOURCE, C.LONG_BUFF},
        cooldown = 0,
        duration = 300,
        ranks = {19742, 19850, 19852, 19853, 19854, 25290},
    },
    {
        spellID = 20911,  -- Blessing of Sanctuary
        tags = {C.BUFF, C.EXTERNAL_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 300,
        talent = true,
        ranks = {20911, 20912, 20913, 20914},
    },
    {
        spellID = 1038,  -- Blessing of Salvation
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 300,
    },
    {
        spellID = 25782,  -- Greater Blessing of Might
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 900,
        ranks = {25782, 25916},
    },

    -------------------------------------------------------------------------------
    -- Seals (for reference)
    -------------------------------------------------------------------------------
    {
        spellID = 20154,  -- Seal of Righteousness
        tags = {C.BUFF, C.CORE_ROTATION},
        cooldown = 0,
        duration = 30,
        ranks = {20154, 20287, 20288, 20289, 20290, 20291, 20292, 20293},
    },
    {
        spellID = 20375,  -- Seal of Command
        tags = {C.BUFF, C.CORE_ROTATION},
        cooldown = 0,
        duration = 30,
        talent = true,
        ranks = {20375, 20915, 20918, 20919, 20920},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 2812,  -- Holy Wrath
        tags = {C.OFFENSIVE_CD_MINOR},
        cooldown = 60,
        ranks = {2812, 10318, 27139},
    },

    -------------------------------------------------------------------------------
    -- Taunt
    -------------------------------------------------------------------------------
    {
        spellID = 31789,  -- Righteous Defense (TBC+)
        tags = {C.TAUNT},
        cooldown = 15,
    },

    -------------------------------------------------------------------------------
    -- Cleanse / Dispel (spammable, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 4987,  -- Cleanse
        tags = {C.DISPEL_MAGIC, C.DISPEL_POISON, C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
    },
    {
        spellID = 1152,  -- Purify
        tags = {C.DISPEL_POISON, C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
    },

}, "PALADIN")
