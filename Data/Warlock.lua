--[[
    LibSpellDB - Warlock Spells (Anniversary Edition / Classic)
    TODO: Populate with full spell list
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Interrupts (Pet)
    -------------------------------------------------------------------------------
    {
        spellID = 19244,  -- Spell Lock (Felhunter)
        tags = {C.INTERRUPT, C.PET},
        cooldown = 24,
        duration = 6,
        ranks = {19244, 19647},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 5782,  -- Fear
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 0,
        duration = 20,
        ranks = {5782, 6213, 6215},
    },
    {
        spellID = 6789,  -- Death Coil
        tags = {C.CC_HARD, C.FEAR, C.HEAL_SINGLE, C.OFFENSIVE_CD_MINOR},
        cooldown = 120,
        duration = 3,
        ranks = {6789, 17925, 17926},
    },
    {
        spellID = 5484,  -- Howl of Terror
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 40,
        duration = 15,
        talent = true,
        ranks = {5484, 17928},
    },
    {
        spellID = 6358,  -- Seduction (Succubus)
        tags = {C.CC_HARD, C.DISORIENT, C.PET},
        cooldown = 0,
        duration = 15,
    },
    {
        spellID = 710,  -- Banish
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 30,
        ranks = {710, 18647},
    },
    {
        spellID = 1098,  -- Enslave Demon
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 300,
        ranks = {1098, 11725, 11726},
    },

    -------------------------------------------------------------------------------
    -- Soft CC
    -------------------------------------------------------------------------------
    {
        spellID = 18223,  -- Curse of Exhaustion
        tags = {C.CC_SOFT, C.DEBUFF},
        cooldown = 0,
        duration = 12,
        talent = true,
    },
    {
        spellID = 1714,  -- Curse of Tongues
        tags = {C.CC_SOFT, C.DEBUFF, C.SILENCE},
        cooldown = 0,
        duration = 30,
        ranks = {1714, 11719},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 6229,  -- Shadow Ward
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {6229, 11739, 11740, 28610},
    },
    {
        spellID = 7812,  -- Sacrifice (Voidwalker)
        tags = {C.PERSONAL_DEFENSIVE, C.PET, C.TRACK_BUFF},
        cooldown = 0,
        duration = 30,
        ranks = {7812, 19438, 19440, 19441, 19442, 19443},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 18288,  -- Amplify Curse
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 180,
        talent = true,
    },
    {
        spellID = 17962,  -- Conflagrate
        tags = {C.CORE_ROTATION, C.OFFENSIVE_CD_MINOR},
        cooldown = 10,
        talent = true,
    },
    {
        spellID = 1122,  -- Inferno (Summon Infernal)
        tags = {C.OFFENSIVE_CD, C.PET_SUMMON},
        cooldown = 3600,
        duration = 300,
    },
    {
        spellID = 18540,  -- Ritual of Doom (Summon Doomguard)
        tags = {C.OFFENSIVE_CD, C.PET_SUMMON},
        cooldown = 3600,
    },
    {
        spellID = 17877,  -- Shadowburn
        tags = {C.CORE_ROTATION, C.FINISHER},
        cooldown = 15,
        talent = true,
        ranks = {17877, 18867, 18868, 18869, 18870, 18871},
    },

    -------------------------------------------------------------------------------
    -- Dispels
    -------------------------------------------------------------------------------
    {
        spellID = 19505,  -- Devour Magic (Felhunter)
        tags = {C.DISPEL_MAGIC, C.PET},
        cooldown = 8,
        ranks = {19505, 19731, 19734, 19736},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation / DoTs
    -------------------------------------------------------------------------------
    {
        spellID = 172,  -- Corruption
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 0,
        duration = 18,
        ranks = {172, 6222, 6223, 7648, 11671, 11672, 25311},
    },
    {
        spellID = 980,  -- Curse of Agony
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 0,
        duration = 24,
        ranks = {980, 1014, 6217, 11711, 11712, 11713},
    },
    {
        spellID = 603,  -- Curse of Doom
        tags = {C.CORE_ROTATION, C.DEBUFF, C.OFFENSIVE_CD},
        cooldown = 60,
        duration = 60,
    },
    {
        spellID = 348,  -- Immolate
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 0,
        duration = 15,
        ranks = {348, 707, 1094, 2941, 11665, 11667, 11668, 25309},
    },
    {
        spellID = 30108,  -- Unstable Affliction (TBC+)
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 0,
        duration = 18,
        talent = true,
    },
    {
        spellID = 18265,  -- Siphon Life
        tags = {C.CORE_ROTATION, C.DEBUFF, C.HEAL_SINGLE},
        cooldown = 0,
        duration = 30,
        talent = true,
        ranks = {18265, 18879, 18880, 18881},
    },

    -------------------------------------------------------------------------------
    -- Direct Damage
    -------------------------------------------------------------------------------
    {
        spellID = 686,  -- Shadow Bolt
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {686, 695, 705, 1088, 1106, 7641, 11659, 11660, 11661, 25307},
    },
    {
        spellID = 5676,  -- Searing Pain
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {5676, 17919, 17920, 17921, 17922, 17923},
    },
    {
        spellID = 6353,  -- Soul Fire
        tags = {C.CORE_ROTATION, C.OFFENSIVE_CD},
        cooldown = 60,
        ranks = {6353, 17924},
    },
    {
        spellID = 1120,  -- Drain Soul
        tags = {C.CORE_ROTATION, C.UTILITY, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        ranks = {1120, 8288, 8289, 11675},
    },
    {
        spellID = 689,  -- Drain Life
        tags = {C.CORE_ROTATION, C.HEAL_SINGLE},
        cooldown = 0,
        duration = 5,
        ranks = {689, 699, 709, 7651, 11699, 11700},
    },
    {
        spellID = 5138,  -- Drain Mana
        tags = {C.CORE_ROTATION, C.RESOURCE},
        cooldown = 0,
        duration = 5,
        ranks = {5138, 6226, 11703, 11704},
    },

    -------------------------------------------------------------------------------
    -- Pet Summons
    -------------------------------------------------------------------------------
    {
        spellID = 688,  -- Summon Imp
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
    },
    {
        spellID = 697,  -- Summon Voidwalker
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
    },
    {
        spellID = 712,  -- Summon Succubus
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
    },
    {
        spellID = 691,  -- Summon Felhunter
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
    },
    {
        spellID = 18708,  -- Fel Domination
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 900,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 20707,  -- Soulstone Resurrection
        tags = {C.RESURRECT, C.BATTLE_REZ, C.UTILITY},
        cooldown = 1800,
        ranks = {20707, 20762, 20763, 20764, 20765},
    },
    {
        spellID = 698,  -- Ritual of Summoning
        tags = {C.UTILITY},
        cooldown = 0,
    },
    {
        spellID = 126,  -- Eye of Kilrogg
        tags = {C.UTILITY},
        cooldown = 0,
        duration = 45,
    },
    {
        spellID = 5697,  -- Unending Breath
        tags = {C.UTILITY, C.BUFF},
        cooldown = 0,
        duration = 600,
    },
    {
        spellID = 132,  -- Detect Invisibility
        tags = {C.UTILITY, C.BUFF},
        cooldown = 0,
        duration = 600,
    },
    {
        spellID = 1098,  -- Enslave Demon
        tags = {C.CC_HARD, C.PET_CONTROL},
        cooldown = 0,
        duration = 300,
        ranks = {1098, 11725, 11726},
    },
    {
        spellID = 18094,  -- Nightfall (proc tracking)
        tags = {C.PROC, C.TRACK_BUFF},
        talent = true,
    },
    {
        spellID = 702,  -- Curse of Weakness
        tags = {C.DEBUFF, C.UTILITY},
        cooldown = 0,
        duration = 120,
        ranks = {702, 1108, 6205, 7646, 11707, 11708},
    },
    {
        spellID = 1490,  -- Curse of the Elements
        tags = {C.DEBUFF, C.UTILITY, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 300,
        ranks = {1490, 11721, 11722},
    },
    {
        spellID = 17862,  -- Curse of Shadow
        tags = {C.DEBUFF, C.UTILITY, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 300,
        ranks = {17862, 17937},
    },
    {
        spellID = 704,  -- Curse of Recklessness
        tags = {C.DEBUFF, C.UTILITY, C.CC_BREAK},
        cooldown = 0,
        duration = 120,
        ranks = {704, 7658, 7659, 11717},
    },

    -------------------------------------------------------------------------------
    -- Healthstone / Buffs
    -------------------------------------------------------------------------------
    {
        spellID = 706,  -- Demon Armor
        tags = {C.BUFF, C.PERSONAL_DEFENSIVE},
        cooldown = 0,
        duration = 1800,
        ranks = {706, 1086, 11733, 11734, 11735},
    },
    {
        spellID = 687,  -- Demon Skin
        tags = {C.BUFF, C.PERSONAL_DEFENSIVE},
        cooldown = 0,
        duration = 1800,
        ranks = {687, 696},
    },
    {
        spellID = 28176,  -- Fel Armor (TBC+)
        tags = {C.BUFF, C.PERSONAL_DEFENSIVE},
        cooldown = 0,
        duration = 1800,
    },

}, "WARLOCK")
