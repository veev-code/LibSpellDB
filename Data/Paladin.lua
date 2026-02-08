--[[
    LibSpellDB - Paladin Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.HOLY, S.PROTECTION, S.RETRIBUTION}
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories
local S = lib.Specs
local AT = lib.AuraTarget

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 853,  -- Hammer of Justice
        name = "Hammer of Justice",
        description = "Stuns the target for 3 sec.",
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 6,
        ranks = {853, 5588, 5589, 10308, 27148},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },
    {
        spellID = 20066,  -- Repentance
        name = "Repentance",
        description = "Puts the enemy target in a state of meditation, incapacitating them for up to 6 sec. Any damage caused will awaken the target. Only works against Humanoids.",
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 60,
        duration = 6,
        talent = true,
        specs = {S.RETRIBUTION},
    },
    {
        spellID = 2878,  -- Turn Undead
        name = "Turn Undead",
        description = "The targeted undead enemy will be compelled to flee for up to 10 sec. Damage caused may interrupt the effect. Only one target can be turned at a time.",
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 30,
        duration = 20,
        ranks = {2878, 5627, 10326},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },

    -------------------------------------------------------------------------------
    -- Immunities (Utility row - defensive, not throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 642,  -- Divine Shield
        name = "Divine Shield",
        description = "Protects the paladin from all damage and spells for 10 sec, but increases the time between your attacks by 100%. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection, Blessing of Protection again or use Avenging Wrath for 1 min.",
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 300,
        duration = 12,
        ranks = {642, 1020},
        auraTarget = AT.SELF,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        -- Forbearance debuff prevents casting for 1 min
        targetLockoutDebuff = 25771,
    },
    {
        spellID = 498,  -- Divine Protection
        name = "Divine Protection",
        description = "You are protected from all physical attacks and spells for 6 sec, but during that time you cannot attack or use physical abilities yourself. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.",
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 300,
        duration = 8,
        ranks = {498, 5573},
        auraTarget = AT.SELF,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        -- Forbearance debuff prevents casting for 1 min
        targetLockoutDebuff = 25771,
    },

    -------------------------------------------------------------------------------
    -- External Defensives (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 1022,  -- Blessing of Protection
        name = "Blessing of Protection",
        description = "A targeted party member is protected from all physical attacks for 6 sec, but during that time they cannot attack or use physical abilities. Players may only have one Blessing on them per Paladin at any one time. Once protected, the target cannot be made invulnerable by Divine Shield, Divine Protection or Blessing of Protection again for 1 min.",
        tags = {C.EXTERNAL_DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 300,
        duration = 10,
        ranks = {1022, 5599, 10278},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        -- Forbearance debuff prevents casting on same target for 1 min
        targetLockoutDebuff = 25771,
    },
    {
        spellID = 6940,  -- Blessing of Sacrifice
        name = "Blessing of Sacrifice",
        description = "Places a Blessing on the party member, transfering 45 damage taken per hit to the caster. Lasts 30 sec. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.EXTERNAL_DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {6940, 20729},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },
    {
        spellID = 1044,  -- Blessing of Freedom
        name = "Blessing of Freedom",
        description = "Places a Blessing on the friendly target, granting immunity to movement impairing effects for 10 sec. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.DEFENSIVE, C.MINOR, C.CC_BREAK, C.HAS_BUFF},
        cooldown = 25,
        duration = 10,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },
    {
        spellID = 19752,  -- Divine Intervention
        name = "Divine Intervention",
        description = "The paladin sacrifices himself to remove the targeted party member from harms way. Enemies will stop attacking the protected party member, who will be immune to all harmful attacks but cannot take any action for 3 min.",
        tags = {C.DEFENSIVE, C.MAJOR, C.UTILITY},
        cooldown = 3600,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },
    {
        spellID = 20216,  -- Divine Favor (throughput CD for healing)
        name = "Divine Favor",
        description = "When activated, gives your next Flash of Light, Holy Light, or Holy Shock spell a 100% critical effect chance.",
        tags = {C.HEAL, C.MAJOR, C.HAS_BUFF},
        cooldown = 120,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.HOLY},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 633,  -- Lay on Hands
        name = "Lay on Hands",
        description = "Heals a friendly target for an amount equal to the Paladin's maximum health. Drains all of the Paladin's remaining mana when used.",
        tags = {C.HEAL, C.MAJOR, C.EXTERNAL_DEFENSIVE, C.HEAL_SINGLE},
        cooldown = 3600,
        ranks = {633, 2800, 10310, 27154},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Holy Healing (Priority: HS → FoL → HL)
    -------------------------------------------------------------------------------
    {
        spellID = 20473,  -- Holy Shock (instant, use on CD)
        name = "Holy Shock",
        description = "Blasts the target with Holy energy, causing 277 to 299 Holy damage to an enemy, or 351 to 379 healing to an ally.",
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 15,
        priority = 1,
        talent = true,
        ranks = {20473, 20929, 20930, 27174, 33072},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY},
    },
    {
        spellID = 19750,  -- Flash of Light (efficient, fast)
        name = "Flash of Light",
        description = "Heals a friendly target for 67 to 77.",
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 2,
        ranks = {19750, 19939, 19940, 19941, 19942, 19943, 27137},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY},
    },
    {
        spellID = 635,  -- Holy Light (big heal when needed)
        name = "Holy Light",
        description = "Heals a friendly target for 42 to 51.",
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {635, 639, 647, 1026, 1042, 3472, 10328, 10329, 25292, 27135, 27136},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.HOLY},
    },
    {
        spellID = 31842,  -- Divine Illumination (mana CD - throughput via sustain)
        name = "Divine Illumination",
        description = "Reduces the mana cost of all spells by 50% for 15 sec.",
        tags = {C.HEAL, C.MAJOR, C.RESOURCE, C.HAS_BUFF, C.PVE},
        cooldown = 180,
        duration = 15,
        priority = 4,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.HOLY},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Retribution (Priority: Seal → CS → Judge → Consec → HoW)
    -------------------------------------------------------------------------------
    {
        spellID = 31892,  -- Seal of Blood (maintain, Horde)
        name = "Seal of Blood",
        description = "All melee attacks deal additional Holy damage equal to 35% of normal weapon damage, but the Paladin loses health equal to 10% of the total damage inflicted.Unleashing this Seal's energy will judge an enemy, instantly causing 295 to 325 Holy damage at the cost of health equal to 33% of the damage caused.",
        tags = {C.DPS, C.MAINTENANCE, C.BUFF, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 1,
        auraTarget = AT.SELF,
        specs = {S.RETRIBUTION},
    },
    {
        spellID = 35395,  -- Crusader Strike (use on CD)
        name = "Crusader Strike",
        description = "An instant strike that causes 110% weapon damage and refreshes all Judgements on the target.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 6,
        priority = 2,
        talent = true,
        specs = {S.RETRIBUTION},
    },
    {
        spellID = 20271,  -- Judgement (use on CD)
        name = "Judgement",
        description = "Unleashes the energy of a Seal spell upon an enemy. Refer to individual Seals for Judgement effect.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 10,
        priority = 3,
        specs = {S.RETRIBUTION, S.PROTECTION},
    },
    {
        spellID = 26573,  -- Consecration (use on CD - both ST and AoE)
        name = "Consecration",
        description = "Consecrates the land beneath the Paladin, doing 64 Holy damage over 8 sec to enemies who enter the area.",
        tags = {C.DPS, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 8,
        duration = 8,
        priority = 4,
        talent = true,
        ranks = {20116, 20922, 20923, 20924, 26573, 27173},
        specs = {S.RETRIBUTION, S.PROTECTION},
    },
    {
        spellID = 24275,  -- Hammer of Wrath (sub-20% execute)
        name = "Hammer of Wrath",
        description = "Hurls a hammer that strikes an enemy for 316 to 348 Holy damage. Only usable on enemies that have 20% or less health.",
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.REACTIVE, C.PVE_PVP},
        cooldown = 6,
        priority = 5,
        ranks = {24275, 24274, 24239, 27180, 32772},
        specs = {S.RETRIBUTION},
    },
    {
        spellID = 879,  -- Exorcism (vs Undead/Demon only - situational)
        name = "Exorcism",
        description = "Causes 90 to 102 Holy damage to an Undead or Demon target.",
        tags = {C.DPS, C.MINOR, C.PVE},
        cooldown = 15,
        priority = 10,
        ranks = {879, 5614, 5615, 10312, 10313, 10314, 27138, 33632},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Protection (Priority: Holy Shield → AS → Consec → Judge)
    -------------------------------------------------------------------------------
    {
        spellID = 20925,  -- Holy Shield (maintain for block)
        name = "Holy Shield",
        description = "Increases chance to block by 30% for 10 sec and deals 59 Holy damage for each attack blocked while active. Damage caused by Holy Shield causes 35% additional threat. Each block expends a charge. 4 charges.",
        tags = {C.TANK, C.ROTATIONAL, C.DEFENSIVE, C.HAS_BUFF, C.PVE},
        cooldown = 10,
        duration = 10,
        priority = 1,
        talent = true,
        ranks = {20925, 20927, 20928, 27179, 32778},
        auraTarget = AT.SELF,
        specs = {S.PROTECTION},
    },
    {
        spellID = 31935,  -- Avenger's Shield (pull / on CD)
        name = "Avenger's Shield",
        description = "Hurls a holy shield at the enemy, dealing 270 to 330 Holy damage, Dazing them and then jumping to additional nearby enemies. Affects 3 total targets. Lasts 6 sec.",
        tags = {C.TANK, C.ROTATIONAL, C.CC_SOFT, C.PVE},
        cooldown = 30,
        priority = 2,
        talent = true,
        specs = {S.PROTECTION},
    },
    {
        spellID = 31884,  -- Avenging Wrath (DPS CD - throughput)
        name = "Avenging Wrath",
        description = "Increases all damage caused by 30% for 20 sec. Causes Forebearance, preventing the use of Divine Shield, Divine Protection, Blessing of Protection again for 1 min.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        duration = 20,
        priority = 7,
        auraTarget = AT.SELF,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        -- Forbearance debuff prevents casting for 1 min
        targetLockoutDebuff = 25771,
    },

    -------------------------------------------------------------------------------
    -- Auras (long buffs, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 465,  -- Devotion Aura
        name = "Devotion Aura",
        description = "Gives 55 additional armor to party members within 30 yards. Players may only have one Aura on them per Paladin at any one time.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {465, 643, 1032, 10290, 10291, 10292, 10293, 27149},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_AURAS",
    },
    {
        spellID = 19746,  -- Concentration Aura
        name = "Concentration Aura",
        description = "Gives a 35% chance of ignoring spell interruption when damaged to all party members within 30 yards. Players may only have one Aura on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_AURAS",
    },
    {
        spellID = 7294,  -- Retribution Aura
        name = "Retribution Aura",
        description = "Causes 5 Holy damage to any creature that strikes a party member within 30 yards. Players may only have one Aura on them per Paladin at any one time.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        ranks = {7294, 10298, 10299, 10300, 10301, 27150},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_AURAS",
    },
    {
        spellID = 19891,  -- Fire Resistance Aura
        name = "Fire Resistance Aura",
        description = "Gives 30 additional Fire resistance to all party members within 30 yards. Players may only have one Aura on them per Paladin at any one time.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {19891, 19899, 19900, 27153},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_AURAS",
    },
    {
        spellID = 19888,  -- Frost Resistance Aura
        name = "Frost Resistance Aura",
        description = "Gives 30 additional Frost resistance to all party members within 30 yards. Players may only have one Aura on them per Paladin at any one time.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {19888, 19897, 19898, 27152},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_AURAS",
    },
    {
        spellID = 19876,  -- Shadow Resistance Aura
        name = "Shadow Resistance Aura",
        description = "Gives 30 additional Shadow resistance to all party members within 30 yards. Players may only have one Aura on them per Paladin at any one time.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        ranks = {19876, 19895, 19896, 27151},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_AURAS",
    },
    {
        spellID = 20218,  -- Sanctity Aura
        name = "Sanctity Aura",
        description = "Increases Holy damage done by party members within 30 yards by 10%. Players may only have one Aura on them per Paladin at any one time.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        talent = true,
        specs = {S.RETRIBUTION},
        buffGroup = "PALADIN_AURAS",
    },

    -------------------------------------------------------------------------------
    -- Blessings
    -------------------------------------------------------------------------------
    {
        spellID = 19740,  -- Blessing of Might
        name = "Blessing of Might",
        description = "Places a Blessing on the friendly target, increasing attack power by 20 for 10 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {19740, 19834, 19835, 19836, 19837, 19838, 25291, 27140},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 20217,  -- Blessing of Kings
        name = "Blessing of Kings",
        description = "Places a Blessing on the friendly target, increasing total stats by 10% for 10 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        talent = true,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 19742,  -- Blessing of Wisdom
        name = "Blessing of Wisdom",
        description = "Places a Blessing on the friendly target, restoring 10 mana every 5 seconds for 10 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.RESOURCE, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {19742, 19850, 19852, 19853, 19854, 25290, 27142},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 20911,  -- Blessing of Sanctuary
        name = "Blessing of Sanctuary",
        description = "Places a Blessing on the friendly target, reducing damage dealt from all sources by up to 10 for 10 min. In addition, when the target blocks a melee attack the attacker will take 14 Holy damage. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.EXTERNAL_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        talent = true,
        ranks = {20911, 20912, 20913, 20914, 27168},
        auraTarget = AT.ALLY,
        specs = {S.PROTECTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 1038,  -- Blessing of Salvation
        name = "Blessing of Salvation",
        description = "Places a Blessing on the party member, reducing the amount of all threat generated by 30% for 10 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 25782,  -- Greater Blessing of Might
        name = "Greater Blessing of Might",
        description = "Gives all members of the raid or group that share the same class with the target the Greater Blessing of Might, increasing attack power by 155 for 30 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {25782, 25916, 27141},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 25894,  -- Greater Blessing of Wisdom
        name = "Greater Blessing of Wisdom",
        description = "Gives all members of the raid or group that share the same class with the target the Greater Blessing of Wisdom, restoring 30 mana every 5 seconds for 30 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.RESOURCE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {25894, 25918, 27143},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 25898,  -- Greater Blessing of Kings
        name = "Greater Blessing of Kings",
        description = "Gives all members of the raid or group that share the same class with the target the Greater Blessing of Kings, increasing total stats by 10% for 30 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        talent = true,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 25899,  -- Greater Blessing of Sanctuary
        name = "Greater Blessing of Sanctuary",
        description = "Gives all members of the raid or group that share the same class with the target the Greater Blessing of Sanctuary, reducing damage dealt from all sources by up to 24 for 30 min. In addition, when the target blocks a melee attack the attacker will take 35 Holy damage. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.EXTERNAL_DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        talent = true,
        ranks = {25899, 27169},
        auraTarget = AT.ALLY,
        specs = {S.PROTECTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 25895,  -- Greater Blessing of Salvation
        name = "Greater Blessing of Salvation",
        description = "Gives all members of the raid or group that share the same class with the target the Greater Blessing of Salvation, reducing the amount of all threat generated by 30% for 30 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 19977,  -- Blessing of Light
        name = "Blessing of Light",
        description = "Places a Blessing on the friendly target, increasing the effects of Holy Light spells used on the target by up to 210 and the effects of Flash of Light spells used on the target by up to 60. Lasts 10 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.HEAL, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {19977, 19978, 19979, 27144},
        auraTarget = AT.ALLY,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 25890,  -- Greater Blessing of Light
        name = "Greater Blessing of Light",
        description = "Gives all members of the raid or group that share the same class with the target the Greater Blessing of Light, increasing the effects of Holy Light spells used on the target by up to 400 and the effects of Flash of Light spells used on the target by up to 115. Lasts 30 min. Players may only have one Blessing on them per Paladin at any one time.",
        tags = {C.BUFF, C.HEAL, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {25890, 27145},
        auraTarget = AT.ALLY,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
        buffGroup = "PALADIN_BLESSINGS",
    },
    {
        spellID = 25780,  -- Righteous Fury (threat increase)
        name = "Righteous Fury",
        description = "Increases the threat generated by your Holy spells by 60%. Lasts 30 min.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 1800,
        specs = {S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Seals (for reference)
    -------------------------------------------------------------------------------
    {
        spellID = 21082,  -- Seal of the Crusader
        name = "Seal of the Crusader",
        description = "Fills the Paladin with the spirit of a crusader for 30 sec, granting 41 melee attack power. The Paladin also attacks 40% faster, but deals less damage with each attack. Only one Seal can be active on the Paladin at any one time.Unleashing this Seal's energy will judge an enemy for 20 sec, increasing Holy damage taken by up to 23. Your melee strikes will refresh the spell's duration. Only one Judgement per Paladin can be active at any one time.",
        tags = {C.BUFF, C.DPS, C.MAINTENANCE},
        cooldown = 0,
        duration = 30,
        ranks = {21082, 20162, 20305, 20306, 20307, 20308, 27158},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },
    {
        spellID = 20154,  -- Seal of Righteousness
        name = "Seal of Righteousness",
        description = "Fills the Paladin with holy spirit for 30 sec, granting each melee attack an additional [1.2 * (216 * 1.2 * 1.03 * Mainhand weapon max base speed / 100) + 0.03 * (Mainhand weapon max damage + Mainhand weapon min damage) / 2 + 1] Holy damage. Only one Seal can be active on the Paladin at any one time.",
        tags = {C.BUFF, C.DPS, C.MAINTENANCE},
        cooldown = 0,
        duration = 30,
        ranks = {20154, 20287, 20288, 20289, 20290, 20291, 20292, 20293, 27155},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },
    {
        spellID = 20375,  -- Seal of Command
        name = "Seal of Command",
        description = "Gives the Paladin a chance to deal additional Holy damage equal to 70% of normal weapon damage. Only one Seal can be active on the Paladin at any one time. Lasts 30 sec.Unleashing this Seal's energy will judge an enemy, instantly causing 68 to 73 Holy damage, 137 to 146 if the target is stunned or incapacitated.",
        tags = {C.BUFF, C.DPS, C.MAINTENANCE},
        cooldown = 0,
        duration = 30,
        talent = true,
        ranks = {20375, 20915, 20918, 20919, 20920, 27170},
        specs = {S.RETRIBUTION},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 2812,  -- Holy Wrath
        name = "Holy Wrath",
        description = "Sends bolts of holy power in all directions, causing 368 to 435 Holy damage to all Undead and Demon targets within 20 yds.",
        tags = {C.DPS, C.AOE},
        cooldown = 60,
        ranks = {2812, 10318, 27139},
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },

    -------------------------------------------------------------------------------
    -- Taunt
    -------------------------------------------------------------------------------
    {
        spellID = 31789,  -- Righteous Defense (TBC+)
        name = "Righteous Defense",
        description = "Come to the defense of a friendly target, commanding up to 3 enemies attacking the target to attack the Paladin instead.",
        tags = {C.TAUNT},
        cooldown = 15,
        specs = {S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Cleanse / Dispel (spammable, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 4987,  -- Cleanse
        name = "Cleanse",
        description = "Cleanses a friendly target, removing 1 poison effect, 1 disease effect, and 1 magic effect.",
        tags = {C.DISPEL_MAGIC, C.DISPEL_POISON, C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },
    {
        spellID = 1152,  -- Purify
        name = "Purify",
        description = "Purifies the friendly target, removing 1 disease effect and 1 poison effect.",
        tags = {C.DISPEL_POISON, C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
        specs = {S.HOLY, S.PROTECTION, S.RETRIBUTION},
    },

}, "PALADIN")
