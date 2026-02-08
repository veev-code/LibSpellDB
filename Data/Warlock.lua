--[[
    LibSpellDB - Warlock Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION}
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories
local S = lib.Specs
local AT = lib.AuraTarget

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
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 5782,  -- Fear
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 0,
        duration = 20,
        ranks = {5782, 6213, 6215, 27228},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 6789,  -- Death Coil
        tags = {C.CC_HARD, C.FEAR, C.HEAL_SINGLE, C.DPS, C.MINOR},
        cooldown = 120,
        duration = 3,
        ranks = {6789, 17925, 17926, 27223},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5484,  -- Howl of Terror
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 40,
        duration = 15,
        talent = true,
        ranks = {5484, 17928},
        specs = {S.AFFLICTION},
    },
    {
        spellID = 6358,  -- Seduction (Succubus)
        tags = {C.CC_HARD, C.DISORIENT, C.PET},
        cooldown = 0,
        duration = 15,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 710,  -- Banish
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 30,
        ranks = {710, 18647},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1098,  -- Enslave Demon
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 300,
        ranks = {1098, 11725, 11726},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
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
        specs = {S.AFFLICTION},
    },
    {
        spellID = 1714,  -- Curse of Tongues
        tags = {C.CC_SOFT, C.DEBUFF, C.SILENCE},
        cooldown = 0,
        duration = 30,
        ranks = {1714, 11719},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 6229,  -- Shadow Ward
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {6229, 11739, 11740, 28610},
        auraTarget = AT.SELF,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 7812,  -- Sacrifice (Voidwalker)
        tags = {C.DEFENSIVE, C.MAJOR, C.PET, C.HAS_BUFF},
        cooldown = 0,
        duration = 30,
        ranks = {7812, 19438, 19440, 19441, 19442, 19443, 27273},
        auraTarget = AT.SELF,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 18288,  -- Amplify Curse
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.AFFLICTION},
    },
    {
        spellID = 17962,  -- Conflagrate (Destruction talent)
        tags = {C.DPS, C.ROTATIONAL},
        cooldown = 10,
        talent = true,
        specs = {S.DESTRUCTION},
    },
    {
        spellID = 1122,  -- Inferno (Summon Infernal)
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.PET_SUMMON_TEMP},
        cooldown = 3600,
        duration = 300,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 18540,  -- Ritual of Doom (Summon Doomguard)
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON},
        cooldown = 3600,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 17877,  -- Shadowburn (Destruction talent, execute phase)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER},
        cooldown = 15,
        talent = true,
        ranks = {17877, 18867, 18868, 18869, 18870, 18871, 30546},
        specs = {S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Dispels
    -------------------------------------------------------------------------------
    {
        spellID = 19505,  -- Devour Magic (Felhunter)
        tags = {C.DISPEL_MAGIC, C.PET},
        cooldown = 8,
        ranks = {19505, 19731, 19734, 19736, 27276},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Affliction (Priority: CoE → UA → Corr → SL → SB)
    -------------------------------------------------------------------------------
    {
        spellID = 603,  -- Curse of Doom (on long boss fights)
        tags = {C.DPS, C.MAINTENANCE, C.DEBUFF, C.PVE},
        cooldown = 60,
        duration = 60,
        priority = 1,
        ranks = {603, 30910},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 980,  -- Curse of Agony (shorter fights)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 24,
        priority = 1,
        ranks = {980, 1014, 6217, 11711, 11712, 11713, 27218},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 30108,  -- Unstable Affliction (apply early)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 18,
        priority = 2,
        talent = true,
        specs = {S.AFFLICTION},
        ranks = {30108, 30404, 30405},
    },
    {
        spellID = 172,  -- Corruption (maintain)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 18,
        priority = 3,
        ranks = {172, 6222, 6223, 7648, 11671, 11672, 25311, 27216},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 18265,  -- Siphon Life (maintain if talented)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.HEAL_SINGLE, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 4,
        talent = true,
        specs = {S.AFFLICTION},
        ranks = {18265, 18879, 18880, 18881, 27264},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Destruction (Priority: Immolate → Incinerate/SB)
    -------------------------------------------------------------------------------
    {
        spellID = 348,  -- Immolate (apply first for Conflag/Incinerate)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 1,
        ranks = {348, 707, 1094, 2941, 11665, 11667, 11668, 25309, 27215},
        specs = {S.DESTRUCTION},
    },
    {
        spellID = 29722,  -- Incinerate (main nuke with Immolate up)
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 2,
        ranks = {29722, 32231},
        specs = {S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Filler/Shared
    -------------------------------------------------------------------------------
    {
        spellID = 686,  -- Shadow Bolt (main filler)
        tags = {C.DPS, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {686, 695, 705, 1088, 1106, 7641, 11659, 11660, 11661, 25307, 27209},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5676,  -- Searing Pain (threat issues / low rank snipe)
        tags = {C.DPS, C.FILLER, C.PVP},
        cooldown = 0,
        priority = 6,
        ranks = {5676, 17919, 17920, 17921, 17922, 17923, 27210},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 6353,  -- Soul Fire (opener/finisher - situational)
        tags = {C.DPS, C.MINOR, C.PVE},
        cooldown = 60,
        priority = 10,
        ranks = {6353, 17924, 27211},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1120,  -- Drain Soul (execute phase / shard - situational)
        tags = {C.DPS, C.MINOR, C.UTILITY, C.RESOURCE, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 11,
        ranks = {1120, 8288, 8289, 11675, 27217},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 689,  -- Drain Life (self-sustain - situational)
        tags = {C.DPS, C.MINOR, C.HEAL_SINGLE, C.PVP},
        cooldown = 0,
        duration = 5,
        priority = 12,
        ranks = {689, 699, 709, 7651, 11699, 11700, 27219, 27220},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 27243,  -- Seed of Corruption (AoE)
        tags = {C.DPS, C.AOE, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 18,
        priority = 13,
        specs = {S.AFFLICTION},
    },
    {
        spellID = 5740,  -- Rain of Fire (AoE)
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 8,
        priority = 14,
        ranks = {5740, 6219, 11677, 11678, 27212},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1949,  -- Hellfire (AoE)
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 15,
        ranks = {1949, 11683, 11684, 27213},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5138,  -- Drain Mana (PvP utility)
        tags = {C.UTILITY, C.RESOURCE, C.PVP},
        cooldown = 0,
        duration = 5,
        ranks = {5138, 6226, 11703, 11704, 27221},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Pet Summons
    -------------------------------------------------------------------------------
    {
        spellID = 688,  -- Summon Imp
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 697,  -- Summon Voidwalker
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 712,  -- Summon Succubus
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 691,  -- Summon Felhunter
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 18708,  -- Fel Domination
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 900,
        talent = true,
        specs = {S.DEMONOLOGY},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 20707,  -- Soulstone Resurrection
        tags = {C.RESURRECT, C.BATTLE_REZ, C.UTILITY},
        cooldown = 1800,
        ranks = {20707, 20762, 20763, 20764, 20765, 27238, 27239},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 698,  -- Ritual of Summoning
        tags = {C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 126,  -- Eye of Kilrogg
        tags = {C.UTILITY},
        cooldown = 0,
        duration = 45,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5697,  -- Unending Breath
        tags = {C.UTILITY, C.BUFF, C.OUT_OF_COMBAT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 132,  -- Detect Invisibility
        tags = {C.UTILITY, C.BUFF, C.OUT_OF_COMBAT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 18094,  -- Nightfall (proc tracking)
        tags = {C.PROC, C.HAS_BUFF},
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.AFFLICTION},
    },
    {
        spellID = 702,  -- Curse of Weakness
        tags = {C.DEBUFF, C.UTILITY},
        cooldown = 0,
        duration = 120,
        ranks = {702, 1108, 6205, 7646, 11707, 11708, 27224},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1490,  -- Curse of the Elements
        tags = {C.DEBUFF, C.UTILITY, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 300,
        ranks = {1490, 11721, 11722, 27229},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 17862,  -- Curse of Shadow
        tags = {C.DEBUFF, C.UTILITY, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 300,
        ranks = {17862, 17937},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 704,  -- Curse of Recklessness
        tags = {C.DEBUFF, C.UTILITY, C.CC_BREAK},
        cooldown = 0,
        duration = 120,
        ranks = {704, 7658, 7659, 11717, 27226},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Healthstone / Buffs
    -------------------------------------------------------------------------------
    {
        spellID = 706,  -- Demon Armor
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,  -- Self-buff, not purgeable
        ranks = {706, 1086, 11733, 11734, 11735, 27260},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
        buffGroup = "WARLOCK_ARMOR",
    },
    {
        spellID = 687,  -- Demon Skin
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,  -- Self-buff, not purgeable
        ranks = {687, 696},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
        buffGroup = "WARLOCK_ARMOR",
    },
    {
        spellID = 28176,  -- Fel Armor (TBC+)
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,  -- Self-buff, not purgeable
        ranks = {28176, 28189},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
        buffGroup = "WARLOCK_ARMOR",
    },

}, "WARLOCK")
