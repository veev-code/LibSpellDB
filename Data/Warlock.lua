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
        name = "Spell Lock",
        description = "Silences the enemy for 3 sec. If used on a casting target, it will counter the enemy's spellcast, preventing any spell from that school of magic from being cast for 5 sec.",
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
        name = "Fear",
        description = "Strikes fear in the enemy, causing it to run in fear for up to 10 sec. Damage caused may interrupt the effect. Only 1 target can be feared at a time.",
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 0,
        duration = 20,
        singleTarget = true,
        ranks = {5782, 6213, 6215, 27228},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 6789,  -- Death Coil
        name = "Death Coil",
        description = "Causes the enemy target to run in horror for 3 sec and causes 258 Shadow damage. The caster gains 100% of the damage caused in health.",
        tags = {C.CC_HARD, C.FEAR, C.HEAL_SINGLE, C.DPS, C.MINOR},
        cooldown = 120,
        duration = 3,
        ranks = {6789, 17925, 17926, 27223},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5484,  -- Howl of Terror
        name = "Howl of Terror",
        description = "Howl, causing 5 enemies within 10 yds to flee in terror for 6 sec. Damage caused may interrupt the effect.",
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 40,
        duration = 8,
        talent = true,
        ranks = {5484, 17928},
        specs = {S.AFFLICTION},
    },
    {
        spellID = 6358,  -- Seduction (Succubus)
        name = "Seduction",
        description = "Seduces the target, preventing all actions for up to 15 sec. Any damage caused will remove the effect. Only works against Humanoids.",
        tags = {C.CC_HARD, C.DISORIENT, C.PET},
        cooldown = 0,
        duration = 15,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 710,  -- Banish
        name = "Banish",
        description = "Banishes the enemy target, preventing all action but making it invulnerable for up to 20 sec. Only one target can be banished at a time. Only works on Demons and Elementals.",
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 30,
        singleTarget = true,
        ranks = {710, 18647},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1098,  -- Enslave Demon
        name = "Subjugate Demon",
        description = "Subjugates the target demon, up to level 45, forcing it to do your bidding. While subjugated, the time between the demon's attacks is increased by 40% and its casting speed is slowed by 30%. Lasts up to 5 min. If you repeatedly subjugate the same demon, it will become more difficult to control with each attempt.",
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 300,
        singleTarget = true,
        ranks = {1098, 11725, 11726},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },

    -------------------------------------------------------------------------------
    -- Soft CC
    -------------------------------------------------------------------------------
    {
        spellID = 18223,  -- Curse of Exhaustion
        name = "Curse of Exhaustion",
        description = "Reduces the target's movement speed by 30% for 12 sec. Only one Curse per Warlock can be active on any one target.",
        tags = {C.CC_SOFT, C.DEBUFF},
        cooldown = 0,
        duration = 12,
        talent = true,
        specs = {S.AFFLICTION},
    },
    {
        spellID = 1714,  -- Curse of Tongues
        name = "Curse of Tongues",
        description = "Forces the target to speak in Demonic, increasing the casting time of all spells by 50%. Only one Curse per Warlock can be active on any one target. Lasts 30 sec.",
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
        name = "Shadow Ward",
        description = "Absorbs 290 shadow damage. Lasts 30 sec.",
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {6229, 11739, 11740, 28610},
        auraTarget = AT.SELF,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 7812,  -- Sacrifice (Voidwalker)
        name = "Sacrifice",
        description = "Sacrifices the Voidwalker, giving its owner a shield that will absorb 319 damage for 30 sec. While the shield holds, spellcasting will not be interrupted by damage.",
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
        name = "Amplify Curse",
        description = "Increases the effect of your next Curse of Doom or Curse of Agony by 50%, or your next Curse of Exhaustion by an additional 20%. Lasts 30 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.AFFLICTION},
    },
    {
        spellID = 17962,  -- Conflagrate (Destruction talent)
        name = "Conflagrate",
        description = "Ignites a target that is already afflicted by your Immolate, dealing 249 to 316 Fire damage and consuming the Immolate spell.",
        tags = {C.DPS, C.ROTATIONAL},
        cooldown = 10,
        talent = true,
        specs = {S.DESTRUCTION},
    },
    {
        spellID = 1122,  -- Inferno (Summon Infernal)
        name = "Inferno",
        description = "Summons a meteor from the Twisting Nether, causing 200 Fire damage and stunning all enemy targets in the area for 2 sec. An Infernal rises from the crater, under the command of the caster for 5 min. Once control is lost, the Infernal must be Subjugated to maintain control. Can only be used outdoors.",
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.PET_SUMMON_TEMP},
        cooldown = 3600,
        duration = 300,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 18540,  -- Ritual of Doom (Summon Doomguard)
        name = "Ritual of Doom",
        description = "Begins a ritual that sacrifices a random participant to summon a doomguard. The doomguard must be immediately subjugated or it will attack the ritual participants. Requires the caster and 4 additional party members to complete the ritual. In order to participate, all players must right-click the portal and not move until the ritual is complete.",
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.OUT_OF_COMBAT},
        cooldown = 3600,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 17877,  -- Shadowburn (Destruction talent, execute phase)
        name = "Shadowburn",
        description = "Instantly blasts the target for 91 to 104 Shadow damage. If the target dies within 5 sec of Shadowburn, and yields experience or honor, the caster gains a Soul Shard.",
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
        name = "Devour Magic",
        description = "Purges 1 harmful magic effect from a friend or 1 beneficial magic effect from an enemy. If an effect is devoured, the Felhunter will be healed for 258.",
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
        name = "Curse of Doom",
        description = "Curses the target with impending doom, causing 3200 Shadow damage after 1 min. If the target dies from this damage, there is a chance that a Doomguard will be summoned. Cannot be cast on players.",
        tags = {C.DPS, C.MAINTENANCE, C.DEBUFF, C.PVE},
        cooldown = 60,
        duration = 60,
        priority = 1,
        ranks = {603, 30910},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 980,  -- Curse of Agony (shorter fights)
        name = "Curse of Agony",
        description = "Curses the target with agony, causing 84 Shadow damage over 24 sec. This damage is dealt slowly at first, and builds up as the Curse reaches its full duration. Only one Curse per Warlock can be active on any one target.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 24,
        priority = 1,
        ranks = {980, 1014, 6217, 11711, 11712, 11713, 27218},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 30108,  -- Unstable Affliction (apply early)
        name = "Unstable Affliction",
        description = "Shadow energy slowly destroys the target, causing 660 damage over 18 sec. In addition, if the Unstable Affliction is dispelled it will cause 990 damage to the dispeller and silence them for 5 sec.",
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
        name = "Corruption",
        description = "Corrupts the target, causing 40 Shadow damage over 12 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 18,
        priority = 3,
        ranks = {172, 6222, 6223, 7648, 11671, 11672, 25311, 27216},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 18265,  -- Siphon Life (maintain if talented)
        name = "Siphon Life",
        description = "Transfers 15 health from the target to the caster every 3 sec. Lasts 30 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.HAS_DEBUFF, C.PVE},
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
        name = "Immolate",
        description = "Burns the enemy for 11 Fire damage and then an additional 20 Fire damage over 15 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 1,
        ranks = {348, 707, 1094, 2941, 11665, 11667, 11668, 25309, 27215},
        specs = {S.DESTRUCTION},
    },
    {
        spellID = 29722,  -- Incinerate (main nuke with Immolate up)
        name = "Incinerate",
        description = "Deals 416 to 480 Fire damage to your target and an additional 103 to 120 Fire damage if the target is affected by an Immolate spell.",
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
        name = "Shadow Bolt",
        description = "Sends a shadowy bolt at the enemy, causing 13 to 18 Shadow damage.",
        tags = {C.DPS, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {686, 695, 705, 1088, 1106, 7641, 11659, 11660, 11661, 25307, 27209},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5676,  -- Searing Pain (threat issues / low rank snipe)
        name = "Searing Pain",
        description = "Inflict searing pain on the enemy target, causing 38 to 47 Fire damage. Causes a high amount of threat.",
        tags = {C.DPS, C.FILLER, C.PVP},
        cooldown = 0,
        priority = 6,
        ranks = {5676, 17919, 17920, 17921, 17922, 17923, 27210},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 6353,  -- Soul Fire (opener/finisher - situational)
        name = "Soul Fire",
        description = "Burn the enemy's soul, causing 640 to 801 Fire damage.",
        tags = {C.DPS, C.MINOR, C.PVE},
        cooldown = 60,
        priority = 10,
        ranks = {6353, 17924, 27211},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1120,  -- Drain Soul (execute phase / shard - situational)
        name = "Drain Soul",
        description = "Drains the soul of the target, causing 55 Shadow damage over 15 sec. If the target dies while being drained, and yields experience or honor, the caster gains a Soul Shard. Soul Shards are required for other spells.",
        tags = {C.DPS, C.MINOR, C.UTILITY, C.RESOURCE, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 11,
        ranks = {1120, 8288, 8289, 11675, 27217},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 689,  -- Drain Life (self-sustain - situational)
        name = "Drain Life",
        description = "Transfers 10 health every 1 sec from the target to the caster. Lasts 5 sec.",
        tags = {C.DPS, C.MINOR, C.HEAL_SINGLE, C.PVP},
        cooldown = 0,
        duration = 5,
        priority = 12,
        ranks = {689, 699, 709, 7651, 11699, 11700, 27219, 27220},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 27243,  -- Seed of Corruption (AoE)
        name = "Seed of Corruption",
        description = "Imbeds a demon seed in the enemy target, causing 1044 Shadow damage over 18 sec. When the target takes 1044 total damage or dies, the seed will inflict 1110 to 1290 Shadow damage to all other enemies within 15 yards of the target. Only one Corruption spell per Warlock can be active on any one target.",
        tags = {C.DPS, C.AOE, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 18,
        priority = 13,
        specs = {S.AFFLICTION},
    },
    {
        spellID = 5740,  -- Rain of Fire (AoE)
        name = "Rain of Fire",
        description = "Calls down a fiery rain to burn enemies in the area of effect for (44 * 4) Fire damage over 8 sec.",
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 8,
        priority = 14,
        ranks = {5740, 6219, 11677, 11678, 27212},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1949,  -- Hellfire (AoE)
        name = "Hellfire",
        description = "Ignites the area surrounding the caster, causing 87 Fire damage to himself and 87 Fire damage to all nearby enemies every 1 sec. Lasts 15 sec.",
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 15,
        ranks = {1949, 11683, 11684, 27213},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5138,  -- Drain Mana (PvP utility)
        name = "Drain Mana",
        description = "Transfers 42 Mana every 1 sec from the target to the caster. Lasts 5 sec.",
        tags = {C.UTILITY, C.RESOURCE, C.PVP},
        cooldown = 0,
        duration = 5,
        ranks = {5138, 6226, 11703, 11704, 27221},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1454,  -- Life Tap (health → mana conversion)
        name = "Life Tap",
        description = "Converts 20 health into 20 mana.",
        tags = {C.RESOURCE},
        cooldown = 0,
        ranks = {1454, 1455, 1456, 11687, 11688, 11689, 27222},
        specs = {},  -- Available for manual enable; not shown by default (no cooldown to track)
    },

    -------------------------------------------------------------------------------
    -- Pet Summons
    -------------------------------------------------------------------------------
    {
        spellID = 688,  -- Summon Imp
        name = "Summon Imp",
        description = "Summons an Imp under the command of the Warlock.",
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 697,  -- Summon Voidwalker
        name = "Summon Voidwalker",
        description = "Summons a Voidwalker under the command of the Warlock.",
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 712,  -- Summon Succubus
        name = "Summon Succubus",
        description = "Summons a Succubus under the command of the Warlock.",
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 691,  -- Summon Felhunter
        name = "Summon Felhunter",
        description = "Summons a Felhunter under the command of the Warlock.",
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 30146,  -- Summon Felguard (Demonology capstone)
        name = "Summon Felguard",
        description = "Summons a Felguard under the command of the Warlock.",
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        talent = true,
        specs = {S.DEMONOLOGY},
    },
    {
        spellID = 18708,  -- Fel Domination
        name = "Fel Domination",
        description = "Your next Imp, Voidwalker, Succubus, Incubus, Felhunter or Felguard Summon spell has its casting time reduced by 5.5 sec and its Mana cost reduced by 50%.",
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 900,
        talent = true,
        specs = {S.DEMONOLOGY},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 693,  -- Create Soulstone
        name = "Create Soulstone",
        description = "Creates a Soulstone. The Soulstone can be used to store the soul of a friendly target. If the target dies while his soul is stored, he will be able to resurrect.",
        tags = {C.RESURRECT, C.BATTLE_REZ, C.UTILITY, C.HAS_BUFF},
        cooldown = 0,
        duration = 1800,
        auraTarget = AT.ALLY,
        singleTarget = true,
        cooldownItemIDs = {5232, 16892, 16893, 16895, 16896, 22116},
        ranks = {693, 20752, 20755, 20756, 20757, 27238},
        appliesBuff = {20707, 20762, 20763, 20764, 20765, 27239},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 698,  -- Ritual of Summoning
        name = "Ritual of Summoning",
        description = "Begins a ritual that summons the targeted group member. Requires the caster and 2 additional party members to complete the ritual. In order to participate, all players must be out of combat and right-click the portal and not move until the ritual is complete.",
        tags = {C.UTILITY, C.OUT_OF_COMBAT},
        cooldown = 0,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 126,  -- Eye of Kilrogg
        name = "Eye of Kilrogg",
        description = "Summons an Eye of Kilrogg and binds your vision to it. The eye moves quickly but is very fragile.",
        tags = {C.UTILITY, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 45,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 5697,  -- Unending Breath
        name = "Unending Breath",
        description = "Allows the target to breathe underwater for 10 min.",
        tags = {C.UTILITY, C.BUFF, C.OUT_OF_COMBAT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 132,  -- Detect Invisibility
        name = "Detect Invisibility",
        description = "Allows the friendly target to detect lesser invisibility for 10 min.",
        tags = {C.UTILITY, C.BUFF, C.OUT_OF_COMBAT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 19028,  -- Soul Link (Demonology tier 6 talent)
        name = "Soul Link",
        description = "When active, 20% of all damage taken by the caster is taken by the demon instead. In addition, both the demon and master will inflict 5% more damage.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF, C.REQUIRES_PET},
        cooldown = 0,
        duration = 0,  -- Permanent while pet is alive
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.AFFLICTION, S.DEMONOLOGY},
    },
    -- Nightfall (18094) is a passive talent — the proc buff it triggers is
    -- Shadow Trance (17941), registered in Procs.lua with procInfo metadata.
    {
        spellID = 702,  -- Curse of Weakness
        name = "Curse of Weakness",
        description = "Target's melee attack power is reduced by 21 for 2 min. Only one Curse per Warlock can be active on any one target.",
        tags = {C.DEBUFF, C.UTILITY},
        cooldown = 0,
        duration = 120,
        ranks = {702, 1108, 6205, 7646, 11707, 11708, 27224},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 1490,  -- Curse of the Elements
        name = "Curse of the Elements",
        description = "Curses the target for 5 min, reducing Arcane, Fire, Frost, and Shadow resistances by 45 and increasing Arcane, Fire, Frost, and Shadow damage taken by 6%. Only one Curse per Warlock can be active on any one target.",
        tags = {C.DEBUFF, C.UTILITY, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 300,
        ranks = {1490, 11721, 11722, 27229},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 17862,  -- Curse of Shadow
        name = "Curse of Shadow",
        description = "Curses the target for 5 min, reducing Shadow and Arcane resistances by 60 and increasing Shadow and Arcane damage taken by 8%. Only one Curse per Warlock can be active on any one target.",
        tags = {C.DEBUFF, C.UTILITY, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 300,
        ranks = {17862, 17937},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
    },
    {
        spellID = 704,  -- Curse of Recklessness
        name = "Curse of Recklessness",
        description = "Curses the target with recklessness, increasing melee attack power by 20 but reducing armor by 140 for 2 min. Cursed enemies will not flee and will ignore Fear and Horror effects. Only one Curse per Warlock can be active on any one target.",
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
        name = "Demon Armor",
        description = "Protects the caster, increasing armor by 210, Shadow resistance by 3 and restores 7 health every 5 sec. Only one type of Armor spell can be active on the Warlock at any time. Lasts 30 min.",
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
        name = "Demon Skin",
        description = "Protects the caster, increasing armor by 40 and restores 3 Health per 5 sec. for 30 min.",
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
        name = "Fel Armor",
        description = "Surrounds the caster with fel energy, increasing the amount of health generated through spells and effects by 20% and increasing spell damage by up to 50. Only one type of Armor spell can be active on the Warlock at any time. Lasts 30 min.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,  -- Self-buff, not purgeable
        ranks = {28176, 28189},
        specs = {S.AFFLICTION, S.DEMONOLOGY, S.DESTRUCTION},
        buffGroup = "WARLOCK_ARMOR",
    },

    -------------------------------------------------------------------------------
    -- Demonic Sacrifice (21-point Demonology talent)
    -- Casting spell (18788) and its passive buff outcomes.
    -- Buff IDs are not castable spells — detected via talentGate on the BuffGroup.
    -- The casting spell uses triggersAuras so CooldownIcons can detect active buffs.
    -------------------------------------------------------------------------------
    {
        spellID = 18788,  -- Demonic Sacrifice (casting spell)
        name = "Demonic Sacrifice",
        description = "When activated, sacrifices your summoned demon to grant you an effect that lasts 30 min. The effect is canceled if any Demon is summoned.",
        tags = {C.BUFF, C.DPS, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 1800,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.DEMONOLOGY},
        triggersAuras = {
            { spellID = 18789, type = "BUFF", onTarget = false, duration = 1800 },  -- Burning Wish (Imp)
            { spellID = 18790, type = "BUFF", onTarget = false, duration = 1800 },  -- Fel Stamina (Voidwalker)
            { spellID = 18791, type = "BUFF", onTarget = false, duration = 1800 },  -- Touch of Shadow (Succubus)
            { spellID = 18792, type = "BUFF", onTarget = false, duration = 1800 },  -- Fel Energy (Felhunter)
            { spellID = 35701, type = "BUFF", onTarget = false, duration = 1800 },  -- Touch of Shadow (Felguard)
        },
    },
    {
        spellID = 18789,  -- Burning Wish (Imp sacrifice)
        name = "Burning Wish",
        description = "Increases your Fire damage by 15%. Obtained by sacrificing an Imp.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,
        buffGroup = "WARLOCK_DEMONIC_SACRIFICE",
    },
    {
        spellID = 18790,  -- Fel Stamina (Voidwalker sacrifice)
        name = "Fel Stamina",
        description = "Increases your Stamina by 15%. Obtained by sacrificing a Voidwalker.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,
        buffGroup = "WARLOCK_DEMONIC_SACRIFICE",
    },
    {
        spellID = 18791,  -- Touch of Shadow (Succubus sacrifice)
        name = "Touch of Shadow",
        description = "Increases your Shadow damage by 15%. Obtained by sacrificing a Succubus.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,
        buffGroup = "WARLOCK_DEMONIC_SACRIFICE",
    },
    {
        spellID = 18792,  -- Fel Energy (Felhunter sacrifice)
        name = "Fel Energy",
        description = "Restores 2% of total Mana every 4 sec. Obtained by sacrificing a Felhunter.",
        tags = {C.BUFF, C.RESOURCE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,
        buffGroup = "WARLOCK_DEMONIC_SACRIFICE",
    },
    {
        spellID = 35701,  -- Touch of Shadow (Felguard sacrifice, TBC)
        name = "Touch of Shadow",
        description = "Increases your damage done by 10%. Obtained by sacrificing a Felguard.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,
        buffGroup = "WARLOCK_DEMONIC_SACRIFICE",
    },

}, "WARLOCK")
