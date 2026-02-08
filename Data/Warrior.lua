--[[
    LibSpellDB - Warrior Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.ARMS, S.FURY, S.PROTECTION}
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories
local S = lib.Specs
local AT = lib.AuraTarget

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- CC Breaks (utility priority 1)
    -------------------------------------------------------------------------------
    {
        spellID = 18499,  -- Berserker Rage (CC break - moved to top)
        name = "Berserker Rage",
        description = "The warrior enters a berserker rage, becoming immune to Fear, Sap and Incapacitate effects and generating extra rage when taking damage. Lasts 10 sec.",
        tags = {C.CC_BREAK, C.CC_IMMUNITY, C.HAS_BUFF},
        cooldown = 30,
        duration = 10,
        priority = 1,  -- CC break = highest utility priority
        auraTarget = AT.SELF,
        specs = {S.ARMS, S.FURY, S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Movement / Gap Closers (utility priority 2)
    -------------------------------------------------------------------------------
    {
        spellID = 100,  -- Charge
        name = "Charge",
        description = "Charge an enemy, generate 9 rage, and stun it for 1 sec. Cannot be used in combat.",
        tags = {C.CC_HARD, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 15,
        duration = 1,
        priority = 2,  -- Movement
        ranks = {100, 6178, 11578},
        specs = {S.ARMS, S.FURY, S.PROTECTION},
        triggersAuras = {
            {
                spellID = 7922,  -- Charge Stun
                tags = {C.CC_HARD},
                type = "DEBUFF",
                onTarget = true,
            },
        },
    },
    {
        spellID = 20252,  -- Intercept (next to Charge)
        name = "Intercept",
        description = "Charge an enemy, causing 25 damage and stunning it for 3 sec.",
        tags = {C.CC_HARD, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 30,
        duration = 3,
        priority = 2,  -- Movement
        ranks = {20252, 20616, 20617},
        specs = {S.ARMS, S.FURY, S.PROTECTION},
        triggersAuras = {
            {
                spellID = 20615,  -- Intercept Stun
                tags = {C.CC_HARD},
                type = "DEBUFF",
                onTarget = true,
            },
        },
    },
    {
        spellID = 3411,  -- Intervene (movement utility, intercepts next attack)
        name = "Intervene",
        description = "Run at high speed towards a party member, intercepting the next melee or ranged attack made against them.",
        tags = {C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 30,
        priority = 2,  -- Movement
        specs = {S.ARMS, S.FURY, S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Hard CC (utility priority 3)
    -------------------------------------------------------------------------------
    {
        spellID = 5246,  -- Intimidating Shout
        name = "Intimidating Shout",
        description = "The warrior shouts, causing enemies within 8 yards to cower in fear. Up to 5 total nearby enemies will flee in fear. Lasts 8 sec.",
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 180,
        duration = 8,
        priority = 3,  -- Hard CC
        specs = {S.ARMS, S.FURY, S.PROTECTION},
        triggersAuras = {
            {
                spellID = 20511,  -- Intimidating Shout (Cower) on main target
                tags = {C.CC_HARD},
                type = "DEBUFF",
                onTarget = true,
            },
        },
    },
    {
        spellID = 12809,  -- Concussion Blow
        name = "Concussion Blow",
        description = "Stuns the opponent for 5 sec.",
        tags = {C.CC_HARD},
        cooldown = 45,
        duration = 5,
        priority = 3,  -- Hard CC
        talent = true,
        specs = {S.PROTECTION},
    },
    {
        spellID = 676,  -- Disarm
        name = "Disarm",
        description = "Disarm the enemy's weapon for 10 sec.",
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 10,
        priority = 3,  -- Hard CC
        specs = {S.ARMS, S.FURY, S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Interrupts (utility priority 4)
    -------------------------------------------------------------------------------
    {
        spellID = 6552,  -- Pummel
        name = "Pummel",
        description = "Pummel the target for 20 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.",
        tags = {C.INTERRUPT},
        cooldown = 10,
        duration = 4,
        priority = 4,  -- Interrupt
        ranks = {6552, 6554, 13491},
        specs = {S.ARMS, S.FURY},
    },
    {
        spellID = 72,  -- Shield Bash
        name = "Shield Bash",
        description = "Bashes the target with your shield for 6 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 6 sec.",
        tags = {C.INTERRUPT},
        cooldown = 12,
        duration = 6,
        priority = 4,  -- Interrupt
        ranks = {72, 1671, 1672, 29704},
        specs = {S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Soft CC (utility priority 5)
    -------------------------------------------------------------------------------
    {
        spellID = 1715,  -- Hamstring
        name = "Hamstring",
        description = "Maims the enemy, causing 5 damage and slowing the enemy's movement by 40% for 15 sec.",
        tags = {C.CC_SOFT},
        cooldown = 0,
        duration = 15,
        priority = 5,  -- Soft CC
        ranks = {1715, 7372, 7373, 25212, 27584},
        specs = {S.ARMS, S.FURY, S.PROTECTION},
    },
    {
        spellID = 12323,  -- Piercing Howl
        name = "Piercing Howl",
        description = "Causes all enemies within 10 yards to be Dazed, reducing movement speed by 50% for 6 sec.",
        tags = {C.CC_SOFT},
        cooldown = 0,
        duration = 6,
        priority = 5,  -- Soft CC
        talent = true,
        specs = {S.FURY},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (utility priority 6)
    -------------------------------------------------------------------------------
    {
        spellID = 871,  -- Shield Wall
        name = "Shield Wall",
        description = "Reduces the damage taken from melee attacks, ranged attacks and spells by 75% for 10 sec.",
        tags = {C.DEFENSIVE, C.MAJOR, C.DAMAGE_REDUCTION, C.HAS_BUFF},
        cooldown = 1800,
        duration = 10,
        priority = 6,  -- Personal defensive
        specs = {S.PROTECTION},
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },
    {
        spellID = 12975,  -- Last Stand
        name = "Last Stand",
        description = "When activated, this ability temporarily grants you 30% of your maximum health for 20 sec. After the effect expires, the health is lost.",
        tags = {C.DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 480,
        duration = 20,
        priority = 6,  -- Personal defensive
        talent = true,
        ranks = {12975, 12976},
        specs = {S.PROTECTION},
    },
    {
        spellID = 23920,  -- Spell Reflection
        name = "Spell Reflection",
        description = "Raise your shield, reflecting the next spell cast on you. Lasts 5 sec.",
        tags = {C.DEFENSIVE, C.MINOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 10,
        duration = 5,
        priority = 6,  -- Personal defensive
        specs = {S.ARMS, S.FURY, S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Resource (utility priority 7)
    -------------------------------------------------------------------------------
    {
        spellID = 2687,  -- Bloodrage
        name = "Bloodrage",
        description = "Generates 10 rage at the cost of health, and then generates an additional 10 rage over 10 sec.",
        tags = {C.DPS, C.MINOR, C.RESOURCE, C.HAS_BUFF},
        cooldown = 60,
        duration = 10,
        priority = 7,  -- Resource
        specs = {S.ARMS, S.FURY, S.PROTECTION},
        triggersAuras = {
            {
                spellID = 29131,  -- Bloodrage buff ID (different from ability ID)
                tags = {C.BUFF, C.RESOURCE},
                type = "BUFF",
                onTarget = false,
            },
        },
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 1719,  -- Recklessness
        name = "Recklessness",
        description = "The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 1800,
        duration = 15,
        specs = {S.FURY},
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },
    {
        spellID = 12292,  -- Death Wish
        name = "Death Wish",
        description = "When activated, increases your physical damage by 20% and makes you immune to Fear effects, but increases all damage taken by 5%. Lasts 30 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        duration = 30,
        talent = true,
        specs = {S.FURY},
    },
    {
        spellID = 12328,  -- Sweeping Strikes (Fury talent in TBC/Anniversary)
        name = "Sweeping Strikes",
        description = "Your next 10 melee attacks strike an additional nearby opponent.",
        tags = {C.DPS, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 10,
        talent = true,
        ranks = {12328, 12723, 26654},
        specs = {S.FURY},  -- Fury tree talent in TBC
    },
    {
        spellID = 20230,  -- Retaliation
        name = "Retaliation",
        description = "Instantly counterattack any enemy that strikes you in melee for 15 sec. Melee attacks made from behind cannot be counterattacked. A maximum of 30 attacks will cause retaliation.",
        tags = {C.DPS, C.MAJOR, C.DEFENSIVE, C.HAS_BUFF},
        cooldown = 1800,
        duration = 15,
        ranks = {20230, 20240},
        specs = {S.ARMS},
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },


    -------------------------------------------------------------------------------
    -- Core Rotation - Arms (Priority: Rend → MS → Overpower → WW → Slam → Execute)
    -------------------------------------------------------------------------------
    {
        spellID = 772,  -- Rend (apply first for Deep Wounds/Trauma)
        name = "Rend",
        description = "Wounds the target causing them to bleed for 15 damage plus an additional [0.00743 * 3 * ((Mainhand weapon max base damage + Mainhand weapon min base damage) / 2 + Attack Power / 14 * Mainhand weapon max base speed)] (based on weapon damage) over 9 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 1,
        ranks = {772, 6546, 6547, 6548, 11572, 11573, 11574, 25208},
        specs = {S.ARMS},
    },
    {
        spellID = 12294,  -- Mortal Strike (highest damage, use on CD)
        name = "Mortal Strike",
        description = "A vicious strike that deals weapon damage plus 85 and wounds the target, reducing the effectiveness of any healing by 50% for 10 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 6,
        duration = 10,
        priority = 2,
        talent = true,
        ranks = {12294, 21551, 21552, 21553, 25248, 27580, 30330},
        specs = {S.ARMS},
        cooldownPriority = true,  -- Debuff (healing reduction) is longer than CD and not worth tracking
    },
    {
        spellID = 7384,  -- Overpower (use when proc available)
        name = "Overpower",
        description = "Instantly overpower the enemy, causing weapon damage plus 5. Only useable after the target dodges. The Overpower cannot be blocked, dodged or parried.",
        tags = {C.DPS, C.ROTATIONAL, C.REACTIVE, C.PVE_PVP},
        cooldown = 5,
        priority = 3,
        ranks = {7384, 7887, 11584, 11585},
        specs = {S.ARMS},
    },
    {
        spellID = 1680,  -- Whirlwind (after MS, strong damage - used in both ST and AoE)
        name = "Whirlwind",
        description = "In a whirlwind of steel you attack up to 4 enemies within 8 yards, causing weapon damage from both melee weapons to each enemy.",
        tags = {C.DPS, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 10,
        priority = 4,
        specs = {S.FURY, S.ARMS},
    },
    {
        spellID = 1464,  -- Slam (filler between abilities)
        name = "Slam",
        description = "Slams the opponent, causing weapon damage plus 32.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 5,
        ranks = {1464, 8820, 11604, 11605, 25241, 25242},
        specs = {S.ARMS},
    },
    {
        spellID = 5308,  -- Execute (sub-20% finisher)
        name = "Execute",
        description = "Attempt to finish off a wounded foe, causing 125 damage and converting each extra point of rage into 3 additional damage. Only usable on enemies that have less than 20% health.",
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.REACTIVE, C.CONSUMES_ALL_RESOURCE, C.PVE_PVP},
        cooldown = 0,
        priority = 6,
        ranks = {5308, 7160, 20658, 20660, 20661, 20662, 25234, 25236},
        specs = {S.ARMS, S.FURY},
    },
    {
        spellID = 34428,  -- Victory Rush (TBC, usable after killing blow)
        name = "Victory Rush",
        description = "Instantly attack the target causing (Attack Power * 45 / 100) damage. Can only be used within 20 sec after you kill an enemy that yields experience or honor. Damage is based on your attack power.",
        tags = {C.DPS, C.ROTATIONAL, C.REACTIVE, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 7,
        auraTarget = AT.SELF,  -- Self-heal on kill
        specs = {S.ARMS, S.FURY},
        reactiveWindow = 20,  -- Usable for 20s after killing blow
        reactiveWindowEvent = "PARTY_KILL",  -- CLEU sub-event that triggers/refreshes the window
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Fury (Priority: BT → WW → HS dump → Execute)
    -------------------------------------------------------------------------------
    {
        spellID = 23881,  -- Bloodthirst (use on CD)
        name = "Bloodthirst",
        description = "Instantly attack the target causing (Attack Power * 45 / 100) damage. In addition, the next 5 successful melee attacks will restore 10 health. This effect lasts 8 sec. Damage is based on your attack power.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 6,
        priority = 1,
        talent = true,
        ranks = {23881, 23892, 23893, 23894, 25251, 30335},
        specs = {S.FURY},
        cooldownPriority = true,  -- Buff (healing on next 5 hits) is longer than CD and not worth tracking
    },
    {
        spellID = 29801,  -- Rampage (critical buff to maintain, procs on crit)
        name = "Rampage",
        description = "Warrior goes on a rampage, increasing attack power by 30 and causing most successful melee attacks to increase attack power by an additional 30. This effect will stack up to 5 times. Lasts 30 sec. This ability can only be used after scoring a critical hit.",
        tags = {C.DPS, C.ROTATIONAL, C.BUFF, C.HAS_BUFF, C.REACTIVE, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 2,
        talent = true,
        ranks = {29801, 30030, 30033},  -- Rank 1, 2, 3
        specs = {S.FURY},
        -- All ability ranks check all buff ranks (resolved via canonical ID)
        triggersAuras = {
            { spellID = 30029, tags = {C.BUFF, C.DPS}, type = "BUFF", onTarget = false },  -- Buff R1
            { spellID = 30031, tags = {C.BUFF, C.DPS}, type = "BUFF", onTarget = false },  -- Buff R2
            { spellID = 30032, tags = {C.BUFF, C.DPS}, type = "BUFF", onTarget = false },  -- Buff R3
        },
    },
    {
        spellID = 78,  -- Heroic Strike (rage dump, use when >50 rage)
        name = "Heroic Strike",
        description = "A strong attack that increases melee damage by 11 and causes a high amount of threat.",
        tags = {C.DPS, C.MINOR, C.PVE},
        cooldown = 0,
        priority = 10,  -- Lower priority (situational)
        ranks = {78, 284, 285, 1608, 11564, 11565, 11566, 11567, 25286, 25712, 29707, 30324},
        specs = {S.ARMS, S.FURY, S.PROTECTION},
    },
    {
        spellID = 845,  -- Cleave (AoE rage dump)
        name = "Cleave",
        description = "A sweeping attack that does your weapon damage plus 5 to the target and his nearest ally.",
        tags = {C.DPS, C.MINOR, C.AOE, C.PVE},
        cooldown = 0,
        priority = 11,  -- Lower priority (situational)
        ranks = {845, 7369, 11608, 11609, 20569, 25231},
        specs = {S.ARMS, S.FURY, S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Protection (Priority: Shield Block → Revenge → Shield Slam → Devastate)
    -------------------------------------------------------------------------------
    {
        spellID = 2565,  -- Shield Block (use on CD for survivability)
        name = "Shield Block",
        description = "Increases chance to block by 75% for 5 sec, but will only block 1 attack.",
        tags = {C.TANK, C.ROTATIONAL, C.DEFENSIVE, C.HAS_BUFF, C.PVE},
        cooldown = 5,
        duration = 5,
        priority = 1,
        specs = {S.PROTECTION},
    },
    {
        spellID = 6572,  -- Revenge (highest threat when proc'd)
        name = "Revenge",
        description = "Instantly counterattack an enemy for 50 to 60 damage and a high amount of threat. Revenge must follow a block, dodge or parry.",
        tags = {C.TANK, C.ROTATIONAL, C.REACTIVE, C.PVE},
        cooldown = 5,
        priority = 2,
        ranks = {6572, 6574, 7379, 11600, 11601, 25288, 25269, 30357},
        specs = {S.PROTECTION},
    },
    {
        spellID = 23922,  -- Shield Slam (high threat on CD)
        name = "Shield Slam",
        description = "Slam the target with your shield, causing 225 to 235 damage, modified by your shield block value, and dispels 1 magic effect on the target. Also causes a high amount of threat.",
        tags = {C.TANK, C.ROTATIONAL, C.PVE},
        cooldown = 6,
        priority = 3,
        talent = true,
        ranks = {23922, 23923, 23924, 23925, 25258, 30356},
        specs = {S.PROTECTION},
    },
    {
        spellID = 20243,  -- Devastate (filler, stacks Sunder)
        name = "Devastate",
        description = "Sunder the target's armor causing the Sunder Armor effect. In addition, causes 50% of weapon damage plus 15 for each application of Sunder Armor on the target. The Sunder Armor effect can stack up to 5 times.",
        tags = {C.TANK, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        priority = 4,
        talent = true,
        ranks = {20243, 30016, 30022},
        specs = {S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Tank Maintenance (debuffs to keep up)
    -------------------------------------------------------------------------------
    {
        spellID = 6343,  -- Thunder Clap (maintain attack speed debuff)
        name = "Thunder Clap",
        description = "Blasts nearby enemies increasing the time between their attacks by 10% for 10 sec and doing 10 damage to them. This ability causes additonal threat and will affect up to 4 targets.",
        tags = {C.TANK, C.MAINTENANCE, C.DEBUFF, C.CC_SOFT, C.PVE},
        cooldown = 4,
        duration = 30,
        priority = 5,
        ranks = {6343, 8198, 8204, 8205, 11580, 11581, 13532, 25264},
        specs = {S.PROTECTION},
    },
    {
        spellID = 1160,  -- Demoralizing Shout (maintain AP reduction debuff)
        name = "Demoralizing Shout",
        description = "Reduces the melee attack power of all enemies within 10 yards by 45 for 30 sec.",
        tags = {C.TANK, C.MAINTENANCE, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 6,
        ranks = {1160, 6190, 11554, 11555, 11556, 25202, 25203, 27579},
        specs = {S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Taunt (tanks only)
    -------------------------------------------------------------------------------
    {
        spellID = 355,  -- Taunt
        name = "Taunt",
        description = "Taunts the target to attack you, but has no effect if the target is already attacking you.",
        tags = {C.TAUNT},
        cooldown = 10,
        specs = {S.PROTECTION},
    },
    {
        spellID = 1161,  -- Challenging Shout
        name = "Challenging Shout",
        description = "Forces all enemies within 10 yards to focus attacks on you for 6 sec.",
        tags = {C.TAUNT},
        cooldown = 600,
        duration = 6,
        specs = {S.PROTECTION},
    },
    {
        spellID = 694,  -- Mocking Blow
        name = "Mocking Blow",
        description = "A mocking attack that causes 22 damage, a moderate amount of threat and forces the target to focus attacks on you for 6 sec.",
        tags = {C.TAUNT},
        cooldown = 120,
        duration = 6,
        ranks = {694, 7400, 7402, 7814, 7815, 7816, 20559, 20560, 25266},
        specs = {S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Utility (not typically tracked)
    -------------------------------------------------------------------------------
    {
        spellID = 7386,  -- Sunder Armor
        name = "Sunder Armor",
        description = "Sunders the target's armor, reducing it by 90 per Sunder Armor and causes a high amount of threat. Can be applied up to 5 times. Lasts 30 sec.",
        tags = {C.DEBUFF, C.UTILITY},
        cooldown = 0,
        duration = 30,
        ranks = {7386, 7405, 8380, 11596, 11597, 25225},
        specs = {S.PROTECTION},
    },

    -------------------------------------------------------------------------------
    -- Long-Duration Buffs (Buff Reminders)
    -------------------------------------------------------------------------------
    {
        spellID = 6673,  -- Battle Shout (party AP buff)
        name = "Battle Shout",
        description = "The warrior shouts, increasing the melee attack power of all party members within 20 yards by 20. Lasts 2 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 120,
        dispelType = nil,  -- Physical buff, cannot be purged
        ranks = {6673, 5242, 6192, 11549, 11550, 11551, 25289, 2048},
        auraTarget = AT.NONE,  -- Affects party, no single target
        specs = {S.ARMS, S.FURY, S.PROTECTION},
        buffGroup = "WARRIOR_SHOUTS",
    },
    {
        spellID = 469,  -- Commanding Shout (party HP buff)
        name = "Commanding Shout",
        description = "Increases maximum health of all party members within 20 yards by 1080. Lasts 2 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 120,
        dispelType = nil,  -- Physical buff, cannot be purged
        ranks = {469, 47439, 47440},
        auraTarget = AT.NONE,  -- Affects party, no single target
        specs = {S.ARMS, S.FURY, S.PROTECTION},
        buffGroup = "WARRIOR_SHOUTS",
    },

}, "WARRIOR")
