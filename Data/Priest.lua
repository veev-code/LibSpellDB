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
local AT = lib.AuraTarget

-- Race constants (must match UnitRace("player") return values)
local HUMAN = "Human"
local DWARF = "Dwarf"
local NIGHTELF = "NightElf"
local UNDEAD = "Scourge"  -- Internal name for Undead
local TROLL = "Troll"
local BLOODELF = "BloodElf"
local DRAENEI = "Draenei"

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Crowd Control - Soft CC
    -------------------------------------------------------------------------------
    {
        spellID = 44046,  -- Chastise (Dwarf/Draenei racial, Humanoids only)
        name = "Chastise",
        description = "Chastise the target, causing 278 to 322 Holy damage and Immobilizing them for up to 2 sec. Only works against Humanoids. This spell causes very low threat.",
        tags = {C.CC_SOFT, C.ROOT},
        cooldown = 30,
        duration = 2,
        ranks = {44041, 44043, 44044, 44045, 44046},
        race = {DWARF, DRAENEI},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control - Hard CC
    -------------------------------------------------------------------------------
    {
        spellID = 8122,  -- Psychic Scream
        name = "Psychic Scream",
        description = "The caster lets out a psychic scream, causing 2 enemies within 8 yards to flee for 8 sec. Damage caused may interrupt the effect.",
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 30,
        duration = 8,
        ranks = {8122, 8124, 10888, 10890, 27610},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 605,  -- Mind Control
        name = "Mind Control",
        description = "Controls a humanoid mind up to level 44, but increases the time between its attacks by 25%. Lasts up to 1 min.",
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC, exclude from HUD
        cooldown = 0,
        duration = 60,
        singleTarget = true,
        ranks = {605, 10911, 10912, 27620},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 9484,  -- Shackle Undead
        name = "Shackle Undead",
        description = "Shackles the target undead enemy for up to 30 sec. The shackled unit is unable to move, attack or cast spells. Any damage caused will release the target. Only one target can be shackled at a time.",
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC, exclude from HUD
        cooldown = 0,
        duration = 50,
        singleTarget = true,
        ranks = {9484, 9485, 10955, 27655},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Silence
    -------------------------------------------------------------------------------
    {
        spellID = 15487,  -- Silence
        name = "Silence",
        description = "Silences the target, preventing them from casting spells for 5 sec.",
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
        name = "Fade",
        description = "Fade out, discouraging enemies from attacking you for 10 sec.",
        tags = {C.DEFENSIVE, C.MINOR, C.UTILITY},
        cooldown = 30,
        duration = 10,
        ranks = {586, 9578, 9579, 9592, 10941, 10942, 27614},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 15286,  -- Vampiric Embrace
        name = "Vampiric Embrace",
        description = "Afflicts your target with Shadow energy that causes all party members to be healed for 15% of any Shadow spell damage you deal for 1 min.",
        tags = {C.DPS, C.MAINTENANCE, C.HAS_DEBUFF},
        cooldown = 10,
        duration = 60,  -- Debuff on target, heals party based on shadow damage
        talent = true,
        specs = {S.SHADOW},
    },
    {
        spellID = 15473,  -- Shadowform
        name = "Shadowform",
        description = "Assume a Shadowform, increasing your Shadow damage by 15% and reducing Physical damage done to you by 15%. However, you may not cast Holy spells while in this form.",
        tags = {C.DPS, C.MAJOR, C.SHAPESHIFT},
        cooldown = 1.5,
        talent = true,
        specs = {S.SHADOW},
    },
    {
        spellID = 6346,  -- Fear Ward (preventative buff, not reactive CD)
        name = "Fear Ward",
        description = "Wards the friendly target against Fear. The next Fear effect used against the target will fail, using up the ward. Lasts 3 min.",
        tags = {C.CC_BREAK, C.CC_IMMUNITY, C.HAS_BUFF, C.IMPORTANT_EXTERNAL},
        cooldown = 180,
        duration = 180,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- External Defensives (Utility row - not throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 33206,  -- Pain Suppression (Discipline talent)
        name = "Pain Suppression",
        description = "Instantly reduces a friendly target's threat by 5%, reduces all damage taken by 40% and increases resistance to Dispel mechanics by 65% for 8 sec.",
        tags = {C.EXTERNAL_DEFENSIVE, C.MAJOR, C.HAS_BUFF, C.PVE_PVP, C.IMPORTANT_EXTERNAL},
        cooldown = 120,
        duration = 8,
        talent = true,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.DISCIPLINE},
    },
    {
        spellID = 13908,  -- Desperate Prayer (Dwarf/Human racial)
        name = "Desperate Prayer",
        description = "Instantly heals the caster for 148 to 185.",
        tags = {C.PERSONAL_DEFENSIVE, C.MAJOR, C.HEAL_SINGLE},
        cooldown = 600,
        ranks = {13908, 19236, 19238, 19240, 19241, 19242, 19243, 25437},
        auraTarget = AT.SELF,  -- Self-heal only
        race = {DWARF, HUMAN},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 724,  -- Lightwell
        name = "Lightwell",
        description = "Creates a Holy Lightwell. Members of your raid or party can click the Lightwell to restore 801 health over 6 sec. Any damage taken will cancel the effect. Lightwell lasts for 3 min or 5 charges.",
        tags = {C.RAID_DEFENSIVE, C.HEAL_AOE},
        cooldown = 360,
        duration = 180,
        talent = true,
        ranks = {724, 27870, 27871, 28276},
        auraTarget = AT.NONE,  -- Placed object, no unit target
        specs = {S.HOLY},
    },

    -------------------------------------------------------------------------------
    -- Healing/DPS Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 14751,  -- Inner Focus
        name = "Inner Focus",
        description = "When activated, reduces the mana cost of your next spell by 100% and increases its critical effect chance by 25% if it is capable of a critical effect.",
        tags = {C.HEAL, C.MAJOR, C.RESOURCE, C.HAS_BUFF},
        cooldown = 180,
        duration = 0,  -- Next spell only
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 10060,  -- Power Infusion
        name = "Power Infusion",
        description = "Infuses the target with power, increasing spell casting speed by 20% and reducing the mana cost of all spells by 20%. Lasts 15 sec.",
        tags = {C.DPS, C.HEAL, C.MAJOR, C.HAS_BUFF, C.IMPORTANT_EXTERNAL},
        cooldown = 180,
        duration = 15,
        talent = true,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.DISCIPLINE},
    },
    {
        spellID = 34433,  -- Shadowfiend
        name = "Shadowfiend",
        description = "Creates a shadowy fiend to attack the target. Caster receives mana when the Shadowfiend deals damage. Lasts 15 sec.",
        tags = {C.DPS, C.MAJOR, C.RESOURCE, C.PET_SUMMON, C.PET_SUMMON_TEMP, C.PVE},
        cooldown = 300,
        duration = 15,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Holy/Disc Healing (Priority: PoM → PW:S → CoH → Renew → GH/FH)
    -------------------------------------------------------------------------------
    {
        spellID = 33076,  -- Prayer of Mending (use on pull/CD)
        name = "Prayer of Mending",
        description = "Places a spell on the target that heals them for 800 the next time they take damage. When the heal occurs, Prayer of Mending jumps to a raid member within 20 yards. Jumps up to 5 times and lasts 30 sec after each jump. This spell can only be placed on one target at a time.",
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 10,
        duration = 30,
        singleTarget = true,
        priority = 1,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY, S.DISCIPLINE},
    },
    {
        spellID = 17,  -- Power Word: Shield (prevent damage)
        name = "Power Word: Shield",
        description = "Draws on the soul of the party member to shield them, absorbing 48 damage. Lasts 30 sec. While the shield holds, spellcasting will not be interrupted by damage. Once shielded, the target cannot be shielded again for 15 sec.",
        tags = {C.HEAL, C.ROTATIONAL, C.EXTERNAL_DEFENSIVE, C.HEAL_SINGLE, C.HAS_BUFF},
        specs = {S.DISCIPLINE, S.HOLY},
        cooldown = 4,
        duration = 30,
        priority = 2,
        ranks = {17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901, 25217, 25218},
        auraTarget = AT.ALLY,  -- Can target other players
        -- Weakened Soul debuff prevents casting PWS on same target for 15s
        -- Check friendly target first, fallback to self if targeting enemy
        targetLockoutDebuff = 6788,
    },
    {
        spellID = 34861,  -- Circle of Healing (instant AoE heal)
        name = "Circle of Healing",
        description = "Heals friendly target and that target's party members within 15 yards of the target for 250 to 274.",
        tags = {C.HEAL, C.FILLER, C.HEAL_AOE, C.PVE},
        cooldown = 0,
        priority = 10,
        talent = true,
        ranks = {34861, 34863, 34864, 34865, 34866},
        auraTarget = AT.ALLY,  -- Heals target's group
        specs = {S.HOLY},
    },
    {
        spellID = 139,  -- Renew (maintain on tank)
        name = "Renew",
        description = "Heals the target for 45 over 15 sec.",
        tags = {C.HEAL, C.ROTATIONAL, C.HOT, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        duration = 15,
        priority = 4,
        ranks = {139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315, 25221, 25222},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY, S.DISCIPLINE},
    },
    {
        spellID = 2060,  -- Greater Heal (big heal)
        name = "Greater Heal",
        description = "A slow casting spell that heals a single target for 924 to 1039.",
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE},
        cooldown = 0,
        priority = 5,
        ranks = {2060, 10963, 10964, 10965, 25314, 25210, 25213},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 2061,  -- Flash Heal (fast heal)
        name = "Flash Heal",
        description = "Heals a friendly target for 202 to 247.",
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 6,
        ranks = {2061, 9472, 9473, 9474, 10915, 10916, 10917, 25233, 25235},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 32546,  -- Binding Heal (heal self + target)
        name = "Binding Heal",
        description = "Heals a friendly target and the caster for 1053 to 1350. Low threat.",
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 7,
        auraTarget = AT.ALLY,  -- Can target other players (heals both)
        specs = {S.HOLY, S.DISCIPLINE},
    },
    {
        spellID = 596,  -- Prayer of Healing (group AoE)
        name = "Prayer of Healing",
        description = "A powerful prayer heals party members within 30 yards for 312 to 333.",
        tags = {C.HEAL, C.AOE, C.HEAL_AOE, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 8,
        ranks = {596, 996, 10960, 10961, 25316, 25308},
        auraTarget = AT.ALLY,  -- Heals group
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 2054,  -- Heal (downranked efficiency)
        name = "Heal",
        description = "Heal your target for 307 to 353.",
        tags = {C.HEAL_SINGLE, C.FILLER},
        cooldown = 0,
        priority = 9,
        ranks = {2054, 2055, 6063, 6064},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 2050,  -- Lesser Heal (leveling only)
        name = "Lesser Heal",
        description = "Heal your target for 47 to 58.",
        tags = {C.HEAL_SINGLE, C.FILLER},
        cooldown = 0,
        priority = 10,
        ranks = {2050, 2052, 2053},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.DISCIPLINE, S.HOLY},
    },

    -------------------------------------------------------------------------------
    -- Dispels (spammable, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 527,  -- Dispel Magic
        name = "Dispel Magic",
        description = "Dispels magic on the target, removing 1 harmful spell from a friend or 1 beneficial spell from an enemy.",
        tags = {C.DISPEL_MAGIC, C.PURGE, C.FILLER},
        cooldown = 0,
        ranks = {527, 988},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 552,  -- Abolish Disease
        name = "Abolish Disease",
        description = "Attempts to cure 1 disease effect on the target, and 1 more disease effect every 5 seconds for 20 sec.",
        tags = {C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
        duration = 20,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 528,  -- Cure Disease
        name = "Cure Disease",
        description = "Removes 1 disease from the friendly target.",
        tags = {C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Shadow (Priority: VT → SW:P → MB → MF → SW:D)
    -------------------------------------------------------------------------------
    {
        spellID = 34914,  -- Vampiric Touch (apply first for mana)
        name = "Vampiric Touch",
        description = "Causes 450 Shadow damage over 15 sec to your target and causes all party members to gain mana equal to 5% of any Shadow spell damage you deal.",
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
        name = "Shadow Word: Pain",
        description = "A word of darkness that causes 30 Shadow damage over 18 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 18,
        priority = 2,
        ranks = {589, 594, 970, 992, 2767, 10892, 10893, 10894, 25367, 25368},
        specs = {S.SHADOW},
    },
    {
        spellID = 8092,  -- Mind Blast (use on CD)
        name = "Mind Blast",
        description = "Blasts the target for 42 to 46 Shadow damage.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 8,
        priority = 3,
        ranks = {8092, 8102, 8103, 8104, 8105, 8106, 10945, 10946, 10947, 25372, 25375},
        specs = {S.SHADOW},
    },
    {
        spellID = 15407,  -- Mind Flay (filler between MBs)
        name = "Mind Flay",
        description = "Assault the target's mind with Shadow energy, causing 75 Shadow damage over 3 sec and slowing their movement speed by 50%.",
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
        name = "Shadow Word: Death",
        description = "A word of dark binding that inflicts 572 to 664 Shadow damage to the target. If the target is not killed by Shadow Word: Death, the caster takes damage equal to the damage inflicted upon the target.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 12,
        priority = 5,
        ranks = {32379, 32380, 32996},
        specs = {S.SHADOW},
    },
    {
        spellID = 2944,  -- Devouring Plague (Undead racial, extra DoT)
        name = "Devouring Plague",
        description = "Afflicts the target with a disease that causes 152 Shadow damage over 24 sec. Damage caused by the Devouring Plague heals the caster.",
        tags = {C.DPS, C.ROTATIONAL, C.HAS_DEBUFF, C.PVE_PVP},
        cooldown = 180,
        duration = 24,
        priority = 6,
        ranks = {2944, 19276, 19277, 19278, 19279, 19280, 25467},
        race = UNDEAD,
        specs = {S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Offensive - Holy/Smite (less common, not part of any core TBC rotation)
    -------------------------------------------------------------------------------
    {
        spellID = 14914,  -- Holy Fire (opener for Smite weaving / solo)
        name = "Holy Fire",
        description = "Consumes the enemy in Holy flames that cause 84 to 104 Holy damage and an additional 30 Holy damage over 10 sec.",
        tags = {C.DPS, C.MINOR, C.PVE},  -- Not ROTATIONAL - no Smite DPS spec in TBC
        cooldown = 10,
        ranks = {14914, 15262, 15263, 15264, 15265, 15266, 15267, 15261, 25384},
        specs = {},  -- Niche for all specs in TBC; available for manual enable
    },
    {
        spellID = 585,  -- Smite (filler)
        name = "Smite",
        description = "Smite an enemy for 15 to 20 Holy damage.",
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
        name = "Levitate",
        description = "Allows the caster to levitate, floating a few feet above the ground. While levitating, you will fall at a reduced speed and travel over water. Any damage will cancel the effect. Lasts 2 min.",
        tags = {C.UTILITY, C.MOVEMENT, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 120,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },
    {
        spellID = 14752,  -- Divine Spirit
        name = "Divine Spirit",
        description = "Holy power infuses the target, increasing their Spirit by 17 for 30 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        talent = true,
        ranks = {14752, 14818, 14819, 27841},
        specs = {S.DISCIPLINE},
        buffGroup = "PRIEST_SPIRIT",
    },
    {
        spellID = 27681,  -- Prayer of Spirit (raid version of Divine Spirit)
        name = "Prayer of Spirit",
        description = "Power infuses the target's party, increasing their Spirit by 40 for 1 hour.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 3600,
        dispelType = "Magic",
        talent = true,
        ranks = {27681, 32999},
        auraTarget = AT.NONE,  -- Raid-wide
        specs = {S.DISCIPLINE},
        buffGroup = "PRIEST_SPIRIT",
    },
    {
        spellID = 21562,  -- Prayer of Fortitude
        name = "Prayer of Fortitude",
        description = "Power infuses the target's party, increasing their Stamina by 43 for 1 hour.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 3600,
        dispelType = "Magic",
        ranks = {21562, 21564, 25392},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
        buffGroup = "PRIEST_FORTITUDE",
    },
    {
        spellID = 1243,  -- Power Word: Fortitude
        name = "Power Word: Fortitude",
        description = "Power infuses the target, increasing their Stamina by 3 for 30 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {1243, 1244, 1245, 2791, 10937, 10938, 25389},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
        buffGroup = "PRIEST_FORTITUDE",
    },
    {
        spellID = 976,  -- Shadow Protection
        name = "Shadow Protection",
        description = "Increases the target's resistance to Shadow spells by 30 for 10 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {976, 10957, 10958, 25433},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
        buffGroup = "PRIEST_SHADOW_PROT",
    },
    {
        spellID = 27683,  -- Prayer of Shadow Protection (raid version)
        name = "Prayer of Shadow Protection",
        description = "Power infuses the target's party, increasing their Shadow resistance by 60 for 20 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1200,
        dispelType = "Magic",
        ranks = {27683, 39374},
        auraTarget = AT.NONE,  -- Raid-wide
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
        buffGroup = "PRIEST_SHADOW_PROT",
    },
    {
        spellID = 15237,  -- Holy Nova (AoE, situational)
        name = "Holy Nova",
        description = "Causes an explosion of holy light around the caster, causing 29 to 34 Holy damage to all enemy targets within 10 yards and healing all party members within 10 yards for 54 to 63. These effects cause no threat.",
        tags = {C.HEAL, C.AOE, C.HEAL_AOE, C.FILLER},
        cooldown = 0,
        talent = true,
        ranks = {15237, 15430, 15431, 27799, 27800, 27801},
        auraTarget = AT.NONE,  -- AoE around caster, no unit target
        specs = {S.DISCIPLINE, S.HOLY},
    },
    {
        spellID = 8129,  -- Mana Burn
        name = "Mana Burn",
        description = "Destroy 198 to 211 mana from a target. For each mana destroyed in this way, the target takes 0.5 Shadow damage.",
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
        name = "Resurrection",
        description = "Brings a dead player back to life with 70 health and 135 mana. Cannot be cast when in combat.",
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
        name = "Inner Fire",
        description = "A burst of Holy energy fills the caster, increasing armor by 315. Each melee or ranged damage hit against the priest will remove one charge. Lasts 10 min or until 20 charges are used.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {588, 602, 1006, 7128, 10951, 10952, 25431},
        auraTarget = AT.SELF,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -------------------------------------------------------------------------------
    -- Priest Racial Abilities (race-restricted)
    -- In TBC 2.3+, Fear Ward, Desperate Prayer, and Chastise became baseline.
    -- The spells below remain locked to specific races.
    -------------------------------------------------------------------------------

    -- Night Elf: Starshards (level 10) - Instant Arcane DoT
    {
        spellID = 10797,  -- Starshards
        name = "Starshards",
        description = "Rains starshards down on the enemy target's head, causing 60 Arcane damage over 15 sec.",
        tags = {C.DPS, C.MINOR, C.HAS_DOT},
        cooldown = 30,
        duration = 15,
        ranks = {10797, 19296, 19299, 19302, 19303, 19304, 19305, 25446},
        race = NIGHTELF,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -- Night Elf: Elune's Grace (level 20) - Avoidance buff
    {
        spellID = 2651,  -- Elune's Grace
        name = "Elune's Grace",
        description = "Reduces the chance you'll be hit by melee and ranged attacks by 20% for 15 sec.",
        tags = {C.DEFENSIVE, C.PERSONAL_DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        duration = 15,
        auraTarget = AT.SELF,
        race = NIGHTELF,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -- Human: Feedback (level 20) - Anti-magic mana burn shield
    {
        spellID = 13896,  -- Feedback
        name = "Feedback",
        description = "The priest becomes surrounded with anti-magic energy. Any successful spell cast against the priest will burn 18 of the attacker's Mana, causing 1 Shadow damage for each point of Mana burned. Lasts 15 sec.",
        tags = {C.DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        duration = 15,
        ranks = {13896, 19271, 19273, 19274, 19275, 25441},
        auraTarget = AT.SELF,
        race = HUMAN,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -- Draenei: Symbol of Hope (level 10) - Party mana regeneration
    {
        spellID = 32548,  -- Symbol of Hope
        name = "Symbol of Hope",
        description = "Greatly increases the morale of party members, giving them 33 mana every 5 sec. Effect lasts 15 sec.",
        tags = {C.RESOURCE, C.MAJOR},
        cooldown = 300,
        duration = 15,
        race = DRAENEI,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -- Undead/Blood Elf: Touch of Weakness (level 10) - Reactive damage + debuff on attacker
    {
        spellID = 2652,  -- Touch of Weakness
        name = "Touch of Weakness",
        description = "The next melee attack against the caster will cause 8 Shadow damage and reduce the damage caused by the attacker by 2 for 2 min.",
        tags = {C.DEFENSIVE, C.LONG_BUFF, C.HAS_BUFF},
        cooldown = 0,
        duration = 600,
        ranks = {2652, 19261, 19262, 19264, 19265, 19266, 25461},
        auraTarget = AT.SELF,
        race = {UNDEAD, BLOODELF},
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -- Troll: Hex of Weakness (level 10) - Damage + healing reduction debuff
    {
        spellID = 9035,  -- Hex of Weakness
        name = "Hex of Weakness",
        description = "Weakens the target enemy, reducing damage caused by 2 and reducing the effectiveness of any healing by 20%. Lasts 2 min.",
        tags = {C.DEBUFF, C.UTILITY, C.FILLER},
        cooldown = 0,
        duration = 120,
        ranks = {9035, 19281, 19282, 19283, 19284, 19285, 25470},
        race = TROLL,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -- Troll: Shadowguard (level 20) - Shadow damage shield
    {
        spellID = 18137,  -- Shadowguard
        name = "Shadowguard",
        description = "The caster is surrounded by shadows. When a spell, melee or ranged attack hits the caster, the attacker will be struck for 20 Shadow damage. Attackers can only be damaged once every few seconds. This damage causes no threat. 3 charges. Lasts 10 min.",
        tags = {C.DPS, C.LONG_BUFF, C.HAS_BUFF},
        cooldown = 0,
        duration = 600,
        ranks = {18137, 19308, 19309, 19310, 19311, 19312, 25477},
        auraTarget = AT.SELF,
        race = TROLL,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

    -- Blood Elf: Consume Magic (level 20) - Self-dispel for mana
    {
        spellID = 32676,  -- Consume Magic
        name = "Consume Magic",
        description = "Dispels one beneficial Magic effect from the caster and gives them 120 to 154 mana. The dispelled effect must be a priest spell.",
        tags = {C.RESOURCE, C.UTILITY, C.MINOR},
        cooldown = 120,
        race = BLOODELF,
        specs = {S.DISCIPLINE, S.HOLY, S.SHADOW},
    },

}, "PRIEST")
