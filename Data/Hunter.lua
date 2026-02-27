--[[
    LibSpellDB - Hunter Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL}
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
        spellID = 19503,  -- Scatter Shot
        name = "Scatter Shot",
        description = "A short-range shot that deals 50% weapon damage and disorients the target for 4 sec. Any damage caused will remove the effect. Turns off your attack when used.",
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 30,
        duration = 4,
        talent = true,
        specs = {S.MARKSMANSHIP},
        triggersAuras = {
            { spellID = 37506, tags = {C.CC_HARD, C.DISORIENT}, type = "DEBUFF", onTarget = true },  -- Scatter Shot effect
        },
    },
    {
        spellID = 3355,  -- Freezing Trap
        name = "Freezing Trap Effect",
        tags = {C.CC_HARD},
        cooldown = 0,  -- Trap has arming time, shared with other traps
        duration = 20,
        ranks = {3355, 14308, 14309, 31932},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 19386,  -- Wyvern Sting
        name = "Wyvern Sting",
        description = "A stinging shot that puts the target to sleep for 12 sec. Any damage will cancel the effect. When the target wakes up, the Sting causes 300 Nature damage over 12 sec. Only one Sting per Hunter can be active on the target at a time.",
        tags = {C.CC_HARD},
        cooldown = 120,
        duration = 12,
        talent = true,
        ranks = {19386, 24132, 24133, 27068},
        specs = {S.SURVIVAL},
        triggersAuras = {
            { spellID = 24131, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Wyvern Sting DoT R1
            { spellID = 24134, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Wyvern Sting DoT R2
            { spellID = 24135, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Wyvern Sting DoT R3
            { spellID = 27069, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Wyvern Sting DoT R4
        },
    },
    {
        spellID = 19577,  -- Intimidation
        name = "Intimidation",
        description = "Command your pet to intimidate the target on the next successful melee attack, causing a high amount of threat and stunning the target for 3 sec.",
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 3,
        talent = true,
        specs = {S.BEAST_MASTERY},
        triggersAuras = {
            {
                spellID = 24394,  -- Intimidation (stun effect from pet)
                tags = {C.CC_HARD},
                type = "DEBUFF",
                onTarget = true,
            },
        },
    },
    {
        spellID = 1513,  -- Scare Beast
        name = "Scare Beast",
        description = "Scares a beast, causing it to run in fear for up to 10 sec. Damage caused may interrupt the effect. Only one beast can be feared at a time.",
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 30,
        duration = 20,
        ranks = {1513, 14326, 14327},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1499,  -- Freezing Trap (the trap itself)
        name = "Freezing Trap",
        description = "Place a frost trap that freezes the first enemy that approaches, preventing all action for up to 10 sec. Any damage caused will break the ice. Trap will exist for 1 min. Only one trap can be active at a time.",
        tags = {C.CC_HARD, C.UTILITY},
        cooldown = 30,
        ranks = {1499, 14310, 14311, 27753},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Soft CC / Slows
    -------------------------------------------------------------------------------
    {
        spellID = 5116,  -- Concussive Shot
        name = "Concussive Shot",
        description = "Dazes the target, slowing movement speed by 50% for 4 sec.",
        tags = {C.CC_SOFT},
        cooldown = 12,
        duration = 4,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 2974,  -- Wing Clip
        name = "Wing Clip",
        description = "Inflicts 5 damage and reduces the enemy target's movement speed by 50% for 10 sec.",
        tags = {C.CC_SOFT},
        cooldown = 0,
        duration = 10,
        ranks = {2974, 14267, 14268, 27633},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 19263,  -- Deterrence
        name = "Deterrence",
        description = "When activated, increases your Dodge and Parry chance by 25% for 10 sec.",
        tags = {C.DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 10,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.SURVIVAL},
    },
    {
        spellID = 5384,  -- Feign Death
        name = "Feign Death",
        description = "Feign death which may trick enemies into ignoring you. Lasts up to 6 min.",
        tags = {C.DEFENSIVE, C.MINOR, C.UTILITY},
        cooldown = 30,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 19574,  -- Bestial Wrath
        name = "Bestial Wrath",
        description = "Send your pet into a rage causing 50% additional damage for 18 sec. While enraged, the beast does not feel pity or remorse or fear and it cannot be stopped unless killed.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PET},
        cooldown = 120,
        duration = 18,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.BEAST_MASTERY},
    },
    {
        spellID = 3045,  -- Rapid Fire
        name = "Rapid Fire",
        description = "Increases ranged attack speed by 40% for 15 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        auraTarget = AT.SELF,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 23989,  -- Readiness (resets CDs - utility aspect but DPS gain)
        name = "Readiness",
        description = "When activated, this ability immediately finishes the cooldown on your other Hunter abilities.",
        tags = {C.DPS, C.MAJOR, C.UTILITY},
        cooldown = 300,
        talent = true,
        specs = {S.MARKSMANSHIP},
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 781,  -- Disengage (Classic version - threat drop)
        name = "Disengage",
        description = "Attempts to disengage from the target, reducing threat. Character exits combat mode.",
        tags = {C.UTILITY},
        cooldown = 5,
        ranks = {781, 14272, 14273, 27015},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 5118,  -- Aspect of the Cheetah
        name = "Aspect of the Cheetah",
        description = "The hunter takes on the aspects of a cheetah, increasing movement speed by 30%. If the hunter is struck, he will be dazed for 4 sec. Only one Aspect can be active at a time.",
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
        buffGroup = "HUNTER_ASPECTS",
    },
    {
        spellID = 13159,  -- Aspect of the Pack
        name = "Aspect of the Pack",
        description = "The hunter and group members within 30 yards take on the aspects of a pack of cheetahs, increasing movement speed by 30%. If a pack member is struck, they will be dazed for 4 sec. Only one Aspect can be active at a time.",
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
        buffGroup = "HUNTER_ASPECTS",
    },

    -------------------------------------------------------------------------------
    -- Dispels
    -------------------------------------------------------------------------------
    {
        spellID = 19801,  -- Tranquilizing Shot
        name = "Tranquilizing Shot",
        description = "Attempts to remove 1 Frenzy effect from an enemy creature.",
        tags = {C.PURGE, C.DISPEL_MAGIC},
        cooldown = 20,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Pet Control
    -------------------------------------------------------------------------------
    {
        spellID = 2641,  -- Dismiss Pet
        name = "Dismiss Pet",
        description = "Dismiss your pet. Dismissing your pet will reduce its happiness by 50.",
        tags = {C.PET_CONTROL, C.UTILITY, C.OUT_OF_COMBAT},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 883,  -- Call Pet
        name = "Call Pet",
        description = "Summons your pet to you.",
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 136,  -- Mend Pet
        name = "Mend Pet",
        description = "Heals your pet for 125 health over 15 sec.",
        tags = {C.PET, C.HEAL_SINGLE},
        cooldown = 0,
        duration = 15,
        ranks = {136, 3111, 3661, 3662, 13542, 13543, 13544, 27046},
        auraTarget = AT.PET,  -- Targets pet
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Traps
    -------------------------------------------------------------------------------
    {
        spellID = 13795,  -- Immolation Trap
        name = "Immolation Trap",
        description = "Place a fire trap that will burn the first enemy to approach for (Ranged Attack Power * 0.1 + 21 * 5) Fire damage over 15 sec. Trap will exist for 1 min. Only one trap can be active at a time.",
        tags = {C.DPS, C.MINOR, C.DEBUFF},
        cooldown = 30,
        ranks = {13795, 14302, 14303, 14304, 14305, 27023},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13813,  -- Explosive Trap
        name = "Explosive Trap",
        description = "Place a fire trap that explodes when an enemy approaches, causing (Ranged Attack Power * 0.1 + 100) to (Ranged Attack Power * 0.1 + 130) Fire damage and burning all enemies for 150 additional Fire damage over 20 sec to all within 10 yards. Trap will exist for 1 min. Only one trap can be active at a time.",
        tags = {C.DPS, C.MINOR, C.AOE},
        cooldown = 30,
        ranks = {13813, 14316, 14317, 27025},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13809,  -- Frost Trap
        name = "Frost Trap",
        description = "Place a frost trap that creates an ice slick around itself for 30 sec when the first enemy approaches it. All enemies within 10 yards will be slowed by 60% while in the area of effect. Trap will exist for 1 min. Only one trap can be active at a time.",
        tags = {C.CC_SOFT, C.UTILITY},
        cooldown = 30,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation (Priority: MD → Serpent → Kill Command → Steady → Multi → Arcane → Aimed)
    -------------------------------------------------------------------------------
    {
        spellID = 34477,  -- Misdirection (use on pull)
        name = "Misdirection",
        description = "Threat caused by your next 3 attacks is redirected to the target raid member. Caster and target can only be affected by one Misdirection spell at a time. Effect lasts 30 sec.",
        tags = {C.UTILITY, C.PVE, C.IMPORTANT_EXTERNAL},
        cooldown = 120,
        duration = 30,
        priority = 1,
        ranks = {34477, 35079},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
        triggersAuras = {
            { spellID = 35079, tags = {C.BUFF}, type = "BUFF", onTarget = true },  -- Misdirection on target
        },
    },
    {
        spellID = 1130,  -- Hunter's Mark (maintain on target)
        name = "Hunter's Mark",
        description = "Places the Hunter's Mark on the target, increasing the ranged attack power of all attackers against that target by 20 and by an additional 2 each time they are struck by a ranged attack, up to a maximum of 80. In addition, the target of this ability can always be seen by the hunter whether it stealths or turns invisible. The target also appears on the mini-map. Lasts for 2 min.",
        tags = {C.DPS, C.MAINTENANCE, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 120,
        priority = 2,
        ranks = {1130, 14323, 14324, 14325},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1978,  -- Serpent Sting (maintain DoT)
        name = "Serpent Sting",
        description = "Stings the target, causing (Ranged Attack Power * 0.1 + 4 * 5) Nature damage over 15 sec. Only one Sting per Hunter can be active on any one target.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 15,
        priority = 2,
        ranks = {1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295, 27016},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 34026,  -- Kill Command (use on CD with pet)
        name = "Kill Command",
        description = "Give the command to kill, causing your pet to instantly attack for an additional 127 damage. Can only be used after the Hunter lands a critical strike on the target.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 5,
        priority = 3,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 34120,  -- Steady Shot (main shot, weave with Auto)
        name = "Steady Shot",
        description = "A steady shot that causes base weapon damage plus (Ranged Attack Power * 0.2 + 150). Causes an additional 175 against Dazed targets.",
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 4,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 2643,  -- Multi-Shot (AoE / cleave - used in both ST and AoE)
        name = "Multi-Shot",
        description = "Fires several missiles, hitting 3 targets.",
        tags = {C.DPS, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 10,
        priority = 10,
        ranks = {2643, 14288, 14289, 14290, 25294, 27021},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1510,  -- Volley (AoE only)
        name = "Volley",
        description = "Continuously fires a volley of ammo at the target area, causing 50 Arcane damage to enemy targets within 8 yards every second for 6 sec.",
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 60,
        duration = 6,
        priority = 11,
        ranks = {1510, 14294, 14295, 27022},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 3044,  -- Arcane Shot (mana dump / BM rotation)
        name = "Arcane Shot",
        description = "An instant shot that causes (Ranged Attack Power * 0.15 + 15) Arcane damage.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 6,
        priority = 7,
        ranks = {3044, 14281, 14282, 14283, 14284, 14285, 14286, 14287, 27019},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 19434,  -- Aimed Shot (when procs / opener)
        name = "Aimed Shot",
        description = "An aimed shot that increases ranged damage by 70 and reduces healing done to that target by 50%. Lasts 10 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 6,
        priority = 8,
        talent = true,
        ranks = {19434, 20900, 20901, 20902, 20903, 20904, 27065, 27632},
        specs = {S.MARKSMANSHIP},
    },

    -------------------------------------------------------------------------------
    -- Melee / Reactive
    -------------------------------------------------------------------------------
    {
        spellID = 2973,  -- Raptor Strike
        name = "Raptor Strike",
        description = "A strong attack that increases melee damage by 5.",
        tags = {C.DPS, C.MINOR, C.PVE_PVP},
        cooldown = 6,
        ranks = {2973, 14260, 14261, 14262, 14263, 14264, 14265, 14266, 27014},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1495,  -- Mongoose Bite
        name = "Mongoose Bite",
        description = "Counterattack the enemy for (Attack Power * 0.2 + 25) damage. Can only be performed after you dodge.",
        tags = {C.DPS, C.MINOR, C.REACTIVE, C.PVE_PVP},
        cooldown = 5,
        ranks = {1495, 14269, 14270, 14271, 36916},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 1543,  -- Flare
        name = "Flare",
        description = "Exposes all hidden and invisible enemies within 10 yards of the targeted area for 20 sec.",
        tags = {C.UTILITY, C.STEALTH_BREAK},
        cooldown = 20,
        duration = 20,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1462,  -- Beast Lore
        name = "Beast Lore",
        description = "Gather information about the target beast. The tooltip will display damage, health, armor, any special resistances, and diet. In addition, Beast Lore will reveal whether or not the creature is tameable and what abilities the tamed creature has.",
        tags = {C.UTILITY, C.OUT_OF_COMBAT},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13161,  -- Aspect of the Beast
        name = "Aspect of the Beast",
        description = "The hunter takes on the aspects of a beast, becoming untrackable. Only one Aspect can be active at a time.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
        buffGroup = "HUNTER_ASPECTS",
    },
    {
        spellID = 13163,  -- Aspect of the Monkey
        name = "Aspect of the Monkey",
        description = "The hunter takes on the aspects of a monkey, increasing chance to dodge by 8%. Only one Aspect can be active at a time.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
        buffGroup = "HUNTER_ASPECTS",
    },
    {
        spellID = 13165,  -- Aspect of the Hawk
        name = "Aspect of the Hawk",
        description = "The hunter takes on the aspects of a hawk, increasing ranged attack power by 20. Only one Aspect can be active at a time.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        ranks = {13165, 14318, 14319, 14320, 14321, 14322, 25296, 27044},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
        buffGroup = "HUNTER_ASPECTS",
    },
    {
        spellID = 34074,  -- Aspect of the Viper (mana regen, TBC)
        name = "Aspect of the Viper",
        description = "The hunter takes on the aspects of a viper, regenerating mana equal to up to 55% of his Intellect plus 35% of his level every 5 sec. The lower the hunter's current mana, the more mana will be regenerated. Only one Aspect can be active at a time.",
        tags = {C.BUFF, C.RESOURCE},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
        buffGroup = "HUNTER_ASPECTS",
    },

    -------------------------------------------------------------------------------
    -- Long-Duration Buffs (Buff Reminders)
    -------------------------------------------------------------------------------
    {
        spellID = 19506,  -- Trueshot Aura (party AP buff, permanent)
        name = "Trueshot Aura",
        description = "Increases the attack power of party members within 45 yards by 50. Lasts until cancelled.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        dispelType = nil,  -- Passive aura, not purgeable
        talent = true,
        ranks = {19506, 20905, 20906},
        auraTarget = AT.NONE,  -- Affects party, no single target
        specs = {S.MARKSMANSHIP},
    },

}, "HUNTER")
