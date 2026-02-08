--[[
    LibSpellDB - Druid Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.BALANCE, S.FERAL, S.RESTORATION}
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories
local S = lib.Specs
local AT = lib.AuraTarget

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Interrupts
    -------------------------------------------------------------------------------
    {
        spellID = 16979,  -- Feral Charge
        name = "Feral Charge",
        description = "Causes you to charge an enemy, immobilizing and interrupting any spell being cast for 4 sec.",
        tags = {C.INTERRUPT, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 15,
        duration = 4,  -- Interrupt lockout / root duration
        talent = true,
        specs = {S.FERAL},
        triggersAuras = {
            {
                spellID = 45334,  -- Feral Charge Effect (root/immobilize)
                tags = {C.ROOT, C.CC_SOFT},
                type = "DEBUFF",
                onTarget = true,
            },
        },
    },
    {
        spellID = 5211,  -- Bash
        name = "Bash",
        description = "Stuns the target for 2 sec.",
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 4,
        ranks = {5211, 6798, 8983, 25515},
        specs = {S.FERAL},
    },
    {
        spellID = 9005,  -- Pounce
        name = "Pounce",
        description = "Pounce, stunning the target for 3 sec and causing 270 damage over 18 sec. Must be prowling. Awards 1 combo point.",
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 3,  -- Stun duration
        ranks = {9005, 9823, 9827, 27006},
        specs = {S.FERAL},
        triggersAuras = {
            { spellID = 9007, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Pounce Bleed R1
            { spellID = 9824, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Pounce Bleed R2
            { spellID = 9826, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Pounce Bleed R3
            { spellID = 27007, tags = {C.HAS_DOT, C.DEBUFF}, type = "DEBUFF", onTarget = true },  -- Pounce Bleed R4
        },
    },

    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 339,  -- Entangling Roots
        name = "Entangling Roots",
        description = "Roots the target in place and causes 20 Nature damage over 12 sec. Damage caused may interrupt the effect. Only useable outdoors.",
        tags = {C.ROOT, C.CC_SOFT},
        cooldown = 0,
        duration = 27,
        ranks = {339, 1062, 5195, 5196, 9852, 9853, 26989},
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 2637,  -- Hibernate
        name = "Hibernate",
        description = "Forces the enemy target to sleep for up to 20 sec. Any damage will awaken the target. Only one target can be forced to hibernate at a time. Only works on Beasts and Dragonkin.",
        tags = {C.CC_HARD, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 40,
        ranks = {2637, 18657, 18658},
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 22812,  -- Barkskin
        name = "Barkskin",
        description = "The druid's skin becomes as tough as bark. All damage taken is reduced by 20%. While protected, damaging attacks will not cause spellcasting delays. This spell is usable while stunned, frozen, incapacitated, feared or asleep. Lasts 12 sec.",
        tags = {C.DEFENSIVE, C.MINOR, C.DAMAGE_REDUCTION, C.HAS_BUFF},
        cooldown = 60,
        duration = 12,
        auraTarget = AT.SELF,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 22842,  -- Frenzied Regeneration
        name = "Frenzied Regeneration",
        description = "Converts up to 10 rage per second into health for 10 sec. Each point of rage is converted into 10 health.",
        tags = {C.DEFENSIVE, C.MAJOR, C.HEAL_SINGLE, C.HAS_BUFF},
        cooldown = 180,
        duration = 10,
        ranks = {22842, 22895, 22896, 26999},
        auraTarget = AT.SELF,
        specs = {S.FERAL},
    },
    {
        spellID = 16689,  -- Nature's Grasp
        name = "Nature's Grasp",
        description = "While active, any time an enemy strikes the caster they have a 35% chance to become afflicted by Entangling Roots (Rank 1). Only useable outdoors. 1 charge. Lasts 45 sec.",
        tags = {C.DEFENSIVE, C.MINOR, C.ROOT, C.HAS_BUFF},
        cooldown = 60,
        duration = 45,
        ranks = {16689, 16810, 16811, 16812, 16813, 17329, 27009},
        auraTarget = AT.SELF,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
        triggersAuras = {
            { spellID = 19975, tags = {C.ROOT, C.CC_SOFT}, type = "DEBUFF", onTarget = true },  -- Nature's Grasp Root R1
            { spellID = 19974, tags = {C.ROOT, C.CC_SOFT}, type = "DEBUFF", onTarget = true },  -- R2
            { spellID = 19973, tags = {C.ROOT, C.CC_SOFT}, type = "DEBUFF", onTarget = true },  -- R3
            { spellID = 19972, tags = {C.ROOT, C.CC_SOFT}, type = "DEBUFF", onTarget = true },  -- R4
            { spellID = 19971, tags = {C.ROOT, C.CC_SOFT}, type = "DEBUFF", onTarget = true },  -- R5
            { spellID = 19970, tags = {C.ROOT, C.CC_SOFT}, type = "DEBUFF", onTarget = true },  -- R6
            { spellID = 27010, tags = {C.ROOT, C.CC_SOFT}, type = "DEBUFF", onTarget = true },  -- R7
        },
    },

    -------------------------------------------------------------------------------
    -- Healing/DPS Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 17116,  -- Nature's Swiftness
        name = "Nature's Swiftness",
        description = "When activated, your next Nature spell becomes an instant cast spell.",
        tags = {C.HEAL, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Raid Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 740,  -- Tranquility
        name = "Tranquility",
        description = "Heals all nearby group members for 365 every 2 seconds for 8 sec. Druid must channel to maintain the spell.",
        tags = {C.HEAL, C.MAJOR, C.HEAL_AOE},
        cooldown = 600,
        duration = 8,
        ranks = {740, 8918, 9862, 9863, 26983},
        auraTarget = AT.SELF,  -- Channeled, heals party around caster
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 29166,  -- Innervate
        name = "Innervate",
        description = "Increases the target's Spirit based mana regeneration by 400% and allows full mana regeneration while casting. Lasts 20 sec.",
        tags = {C.HEAL, C.MAJOR, C.RESOURCE, C.HAS_BUFF},
        cooldown = 360,
        duration = 20,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 1850,  -- Dash
        name = "Dash",
        description = "Increases movement speed by 50% for 15 sec. Does not break prowling.",
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        ranks = {1850, 9821, 33357},
        auraTarget = AT.SELF,
        specs = {S.FERAL},
    },
    {
        spellID = 5215,  -- Prowl
        name = "Prowl",
        description = "Allows the Druid to prowl around, but reduces your movement speed by 40%. Lasts until cancelled.",
        tags = {C.STEALTH},
        cooldown = 10,
        ranks = {5215, 6783, 9913},
        specs = {S.FERAL},
    },

    -------------------------------------------------------------------------------
    -- Shapeshifts
    -------------------------------------------------------------------------------
    {
        spellID = 768,  -- Cat Form
        name = "Cat Form",
        description = "Shapeshift into cat form, increasing melee attack power by 40 plus Agility. Also protects the caster from Polymorph effects and allows the use of various cat abilities.The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
        tags = {C.SHAPESHIFT},
        cooldown = 0,
        specs = {S.FERAL},
    },
    {
        spellID = 5487,  -- Bear Form
        name = "Bear Form",
        description = "Shapeshift into bear form, increasing melee attack power by 120, armor contribution from items by 180%, and Stamina by 25%. Also protects the caster from Polymorph effects and allows the use of various bear abilities.The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
        tags = {C.SHAPESHIFT},
        cooldown = 0,
        specs = {S.FERAL},
    },
    {
        spellID = 9634,  -- Dire Bear Form
        name = "Dire Bear Form",
        description = "Shapeshift into dire bear form, increasing melee attack power by 210, armor contribution from items by 400%, and Stamina by 25%. Also protects the caster from Polymorph effects and allows the use of various bear abilities.The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
        tags = {C.SHAPESHIFT},
        cooldown = 0,
        specs = {S.FERAL},
    },
    {
        spellID = 783,  -- Travel Form
        name = "Travel Form",
        description = "Shapeshift into travel form, increasing movement speed by 40%. Also protects the caster from Polymorph effects. Only useable outdoors.The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
        tags = {C.SHAPESHIFT, C.MOVEMENT},
        cooldown = 0,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 24858,  -- Moonkin Form
        name = "Moonkin Form",
        description = "Shapeshift into Moonkin Form. While in this form the armor contribution from items is increased by 400%, attack power is increased by 150% of your level and all party members within 30 yards have their spell critical chance increased by 5%. Melee attacks in this form have a chance on hit to regenerate mana based on attack power. The Moonkin can only cast Balance and Remove Curse spells while shapeshifted.The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
        tags = {C.SHAPESHIFT, C.DPS},
        cooldown = 0,
        talent = true,
        specs = {S.BALANCE},
        triggersAuras = {
            { spellID = 24907, tags = {C.BUFF}, type = "BUFF", onTarget = false },  -- Moonkin Aura
        },
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 20484,  -- Rebirth
        name = "Rebirth",
        description = "Returns the spirit to the body, restoring a dead target to life with 400 health and 700 mana.",
        tags = {C.BATTLE_REZ, C.RESURRECT, C.UTILITY},
        cooldown = 1200,
        ranks = {20484, 20739, 20742, 20747, 20748, 26994},
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 5209,  -- Challenging Roar
        name = "Challenging Roar",
        description = "Forces all nearby enemies to focus attacks on you for 6 sec.",
        tags = {C.TAUNT},
        cooldown = 600,
        duration = 6,
        specs = {S.FERAL},
    },
    {
        spellID = 6795,  -- Growl
        name = "Growl",
        description = "Taunts the target to attack you, but has no effect if the target is already attacking you.",
        tags = {C.TAUNT},
        cooldown = 10,
        specs = {S.FERAL},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Balance (Priority: MF → IS → Starfire → FoN)
    -------------------------------------------------------------------------------
    {
        spellID = 8921,  -- Moonfire (apply first, instant)
        name = "Moonfire",
        description = "Burns the enemy for 9 to 12 Arcane damage and then an additional 12 Arcane damage over 9 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 12,
        priority = 1,
        ranks = {563, 8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835, 26987, 26988},
        specs = {S.BALANCE},
    },
    {
        spellID = 5570,  -- Insect Swarm (maintain DoT)
        name = "Insect Swarm",
        description = "The enemy target is swarmed by insects, decreasing their chance to hit by 2% and causing 108 Nature damage over 12 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 12,
        priority = 2,
        talent = true,
        ranks = {5570, 24974, 24975, 24976, 24977, 27013},
        specs = {S.BALANCE},
    },
    {
        spellID = 5176,  -- Wrath (filler nuke - mana-based, not shown on HUD by default)
        name = "Wrath",
        description = "Causes 13 to 16 Nature damage to the target.",
        tags = {C.DPS, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {5176, 5177, 5178, 5179, 5180, 6780, 8905, 9912, 26984, 26985},
        specs = {S.BALANCE},
    },
    {
        spellID = 2912,  -- Starfire (main nuke - Balance spec filler)
        name = "Starfire",
        description = "Causes 95 to 115 Arcane damage to the target.",
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {2912, 8949, 8950, 8951, 9875, 9876, 25298, 26986},
        specs = {S.BALANCE},
    },
    {
        spellID = 33831,  -- Force of Nature (use on CD - throughput CD)
        name = "Force of Nature",
        description = "Summons 3 treants to attack enemy targets for 30 sec.",
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.PET_SUMMON_TEMP, C.PVE},
        cooldown = 180,
        duration = 30,
        priority = 4,
        talent = true,
        specs = {S.BALANCE},
    },
    {
        spellID = 16914,  -- Hurricane (AoE)
        name = "Hurricane",
        description = "Creates a violent storm in the target area causing 72 Nature damage to enemies every 1 sec, and increasing the time between attacks of enemies by 25%. Lasts 10 sec. Druid must channel to maintain the spell.",
        tags = {C.DPS, C.AOE, C.CC_SOFT, C.PVE},
        cooldown = 60,
        duration = 10,
        priority = 10,
        ranks = {16914, 17401, 17402, 27012},
        specs = {S.BALANCE},
    },
    {
        spellID = 770,  -- Faerie Fire (caster form, armor debuff)
        name = "Faerie Fire",
        description = "Decrease the armor of the target by 175 for 40 sec. While affected, the target cannot stealth or turn invisible.",
        tags = {C.DEBUFF, C.UTILITY, C.PVE_PVP},
        cooldown = 0,
        duration = 40,
        priority = 6,
        ranks = {770, 778, 9749, 9907, 26993},
        specs = {S.BALANCE, S.RESTORATION},
    },
    {
        spellID = 27011,  -- Faerie Fire (Feral) - usable in cat/bear form
        name = "Faerie Fire (Feral)",
        description = "Decrease the armor of the target by 610 for 40 sec. While affected, the target cannot stealth or turn invisible.",
        tags = {C.DEBUFF, C.MAINTENANCE, C.PVE_PVP},
        cooldown = 6,
        duration = 40,
        priority = 5,
        ranks = {16857, 17390, 17391, 17392, 27011},
        specs = {S.FERAL},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Feral Cat (Priority: Mangle → Shred → Rip → FB)
    -------------------------------------------------------------------------------
    {
        spellID = 33983,  -- Mangle (Cat) (apply debuff first)
        name = "Mangle (Cat)",
        description = "Mangle the target for 160% normal damage plus 264 and causes the target to take 30% additional damage from Shred and bleed effects for 12 sec. Awards 1 combo point.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        priority = 1,
        talent = true,
        ranks = {33876, 33982, 33983},
        specs = {S.FERAL},
    },
    {
        spellID = 27002,  -- Shred (main CP builder from behind)
        name = "Shred",
        description = "Shred the target, causing 225% damage plus 405 to the target. Must be behind the target. Awards 1 combo point.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 2,
        ranks = {5221, 6800, 8992, 9829, 9830, 27001, 27002, 27555},
        specs = {S.FERAL},
    },
    {
        spellID = 27003,  -- Rake (applies DoT debuff)
        name = "Rake",
        description = "Rake the target for (Attack Power / 100 + 78) bleed damage and an additional (36 * 3 + Attack Power * 0.06) damage over 9 sec. Awards 1 combo point.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 9,
        priority = 2,
        ranks = {1822, 1823, 1824, 9904, 27003},
        specs = {S.FERAL},
        cooldownPriority = true,  -- Show energy prediction first, debuff shown when ability is ready
    },
    {
        spellID = 27000,  -- Claw (basic cat form attack)
        name = "Claw",
        description = "Claw the enemy, causing 190 additional damage. Awards 1 combo point.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 0,
        priority = 3,
        ranks = {1082, 3029, 5201, 9849, 9850, 27000},
        specs = {S.FERAL},
    },
    {
        spellID = 1079,  -- Rip (maintain at 5 CP)
        name = "Rip",
        description = "Finishing move that causes damage over time. Damage increases per combo point and by your attack power: 1 point : 42 damage over 12 sec. 2 points: 66 damage over 12 sec. 3 points: 90 damage over 12 sec. 4 points: 114 damage over 12 sec. 5 points: 138 damage over 12 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 12,
        priority = 3,
        ranks = {1079, 9492, 9493, 9752, 9894, 9896, 27008},
        specs = {S.FERAL},
    },
    {
        spellID = 22568,  -- Ferocious Bite (dump excess CP/energy)
        name = "Ferocious Bite",
        description = "Finishing move that causes damage per combo point and converts each extra point of energy into 1 additional damage. Damage is increased by your attack power. 1 point : 50-66 damage 2 points: 86-102 damage 3 points: 122-138 damage 4 points: 158-174 damage 5 points: 194-210 damage",
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {22568, 22827, 22828, 22829, 31018, 24248},
        specs = {S.FERAL},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Feral Bear (Priority: Mangle → Lacerate → Swipe → Maul)
    -------------------------------------------------------------------------------
    {
        spellID = 33987,  -- Mangle (Bear) (highest threat on CD)
        name = "Mangle (Bear)",
        description = "Mangle the target for 115% normal damage plus 155 and causes the target to take 30% additional damage from Shred and bleed effects for 12 sec.",
        tags = {C.TANK, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 6,
        priority = 1,
        talent = true,
        ranks = {33878, 33986, 33987},
        specs = {S.FERAL},
        cooldownPriority = true,  -- Debuff lasts 12s but you spam on 6s CD; cooldown display is more useful
    },
    {
        spellID = 33745,  -- Lacerate (stack and maintain)
        name = "Lacerate",
        description = "Lacerates the enemy target, dealing 31 bleed damage and making them bleed for 155 damage over 15 sec and causing a high amount of threat. Damage increased by attack power. This effect stacks up to 5 times on the same target.",
        tags = {C.TANK, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 2,
        specs = {S.FERAL},
    },
    {
        spellID = 779,  -- Swipe (AoE threat)
        name = "Swipe",
        description = "Swipe 3 nearby enemies, inflicting 10 damage. Damage increased by attack power.",
        tags = {C.TANK, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 0,
        priority = 3,
        ranks = {779, 780, 769, 9754, 9908, 26997},
        specs = {S.FERAL},
    },
    {
        spellID = 6807,  -- Maul (rage dump - situational)
        name = "Maul",
        description = "Increases the druid's next attack by 18 damage.",
        tags = {C.TANK, C.ROTATIONAL, C.MINOR, C.PVE},
        cooldown = 0,
        priority = 10,
        ranks = {6807, 6808, 6809, 7092, 8972, 9745, 9880, 9881, 26996},
        specs = {S.FERAL},
    },
    {
        spellID = 99,  -- Demoralizing Roar (maintain debuff)
        name = "Demoralizing Roar",
        description = "The druid roars, decreasing nearby enemies' melee attack power by 40. Lasts 30 sec.",
        tags = {C.DEBUFF, C.UTILITY, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 5,
        ranks = {99, 1735, 9490, 9747, 9898, 26998},
        specs = {S.FERAL},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Restoration (Priority: LB x3 → Rejuv → Regrowth → SM)
    -------------------------------------------------------------------------------
    {
        spellID = 33763,  -- Lifebloom (stack to 3, maintain)
        name = "Lifebloom",
        description = "Heals the target for 273 over 7 sec. When Lifebloom completes its duration or is dispelled, the target instantly heals themself for 600. This effect can stack up to 3 times on the same target.",
        tags = {C.HEAL, C.ROTATIONAL, C.HOT, C.HEAL_SINGLE, C.PVE},
        cooldown = 0,
        duration = 7,
        priority = 1,
        ranks = {33763, 33778},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 774,  -- Rejuvenation (maintain on targets)
        name = "Rejuvenation",
        description = "Heals the target for 32 over 12 sec.",
        tags = {C.HEAL, C.ROTATIONAL, C.HOT, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        duration = 12,
        priority = 2,
        ranks = {774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299, 26981, 26982},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 8936,  -- Regrowth (spot heal + HoT)
        name = "Regrowth",
        description = "Heals a friendly target for 93 to 107 and another 98 over 21 sec.",
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.HOT, C.PVE_PVP},
        cooldown = 0,
        duration = 21,
        priority = 3,
        ranks = {8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858, 26980},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 18562,  -- Swiftmend (emergency heal)
        name = "Swiftmend",
        description = "Consumes a Rejuvenation or Regrowth effect on a friendly target to instantly heal them an amount equal to 12 sec. of Rejuvenation or 18 sec. of Regrowth.",
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 15,
        priority = 4,
        talent = true,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 5185,  -- Healing Touch (big heal / NS combo)
        name = "Healing Touch",
        description = "Heals a friendly target for 40 to 55.",
        tags = {C.HEAL_SINGLE, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {5185, 5186, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889, 25297, 26978, 26979},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 33891,  -- Tree of Life (maintain form)
        name = "Tree of Life",
        description = "Shapeshift into the Tree of Life. While in this form you increase healing received by 25% of your total Spirit for all party members within 45 yards, your movement speed is reduced by 20%, and you can only cast Swiftmend, Innervate, Nature's Swiftness, Rebirth, Barkskin, poison removing and healing over time spells, but the mana cost of these spells is reduced by 20%.The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.",
        tags = {C.SHAPESHIFT, C.BUFF, C.PVE},
        cooldown = 0,
        priority = 0,  -- Pre-combat form
        talent = true,
        specs = {S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Long-Duration Buffs (Buff Reminders)
    -------------------------------------------------------------------------------
    {
        spellID = 1126,  -- Mark of the Wild (single ally stats + armor + resistances)
        name = "Mark of the Wild",
        description = "Increases the friendly target's armor by 25 for 30 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {1126, 5232, 6756, 5234, 8907, 9884, 9885, 26990},
        auraTarget = AT.ALLY,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
        buffGroup = "DRUID_MOTW",
    },
    {
        spellID = 21849,  -- Gift of the Wild (raid version of MOTW)
        name = "Gift of the Wild",
        description = "Gives the Gift of the Wild to the target's party, increasing armor by 240, all attributes by 10 and all resistances by 15 for 1 hour.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 3600,
        dispelType = "Magic",
        ranks = {21849, 21850, 26991},
        auraTarget = AT.NONE,  -- Raid-wide, no single target
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
        buffGroup = "DRUID_MOTW",
    },
    {
        spellID = 467,  -- Thorns (damage shield on ally)
        name = "Thorns",
        description = "Thorns sprout from the friendly target causing 3 Nature damage to attackers when hit. Lasts 10 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {467, 782, 1075, 8914, 9756, 9910, 26992},
        auraTarget = AT.ALLY,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 16864,  -- Omen of Clarity (Clearcasting proc on melee/spell)
        name = "Omen of Clarity",
        description = "Imbues the Druid with natural energy. Each of the Druid's melee attacks has a chance of causing the caster to enter a Clearcasting state. The Clearcasting state reduces the Mana, Rage or Energy cost of your next damage or healing spell or offensive ability by 100%. Lasts 30 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        talent = true,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },

}, "DRUID")
