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
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 4,
        ranks = {5211, 6798, 8983, 25515},
        specs = {S.FERAL},
    },
    {
        spellID = 9005,  -- Pounce
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 2,  -- Stun duration
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
        tags = {C.ROOT, C.CC_SOFT},
        cooldown = 0,
        duration = 27,
        ranks = {339, 1062, 5195, 5196, 9852, 9853, 26989},
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 2637,  -- Hibernate
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
        tags = {C.DEFENSIVE, C.MINOR, C.DAMAGE_REDUCTION, C.HAS_BUFF},
        cooldown = 60,
        duration = 12,
        auraTarget = AT.SELF,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 22842,  -- Frenzied Regeneration
        tags = {C.DEFENSIVE, C.MAJOR, C.HEAL_SINGLE, C.HAS_BUFF},
        cooldown = 180,
        duration = 10,
        ranks = {22842, 22895, 22896, 26999},
        auraTarget = AT.SELF,
        specs = {S.FERAL},
    },
    {
        spellID = 16689,  -- Nature's Grasp
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
        tags = {C.HEAL, C.MAJOR, C.HEAL_AOE},
        cooldown = 300,
        duration = 10,
        ranks = {740, 8918, 9862, 9863, 26983},
        auraTarget = AT.SELF,  -- Channeled, heals party around caster
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 29166,  -- Innervate
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
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        ranks = {1850, 9821, 33357},
        auraTarget = AT.SELF,
        specs = {S.FERAL},
    },
    {
        spellID = 5215,  -- Prowl
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
        tags = {C.SHAPESHIFT},
        cooldown = 0,
        specs = {S.FERAL},
    },
    {
        spellID = 5487,  -- Bear Form
        tags = {C.SHAPESHIFT},
        cooldown = 0,
        specs = {S.FERAL},
    },
    {
        spellID = 9634,  -- Dire Bear Form
        tags = {C.SHAPESHIFT},
        cooldown = 0,
        specs = {S.FERAL},
    },
    {
        spellID = 783,  -- Travel Form
        tags = {C.SHAPESHIFT, C.MOVEMENT},
        cooldown = 0,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 24858,  -- Moonkin Form
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
        tags = {C.BATTLE_REZ, C.RESURRECT, C.UTILITY},
        cooldown = 1800,
        ranks = {20484, 20739, 20742, 20747, 20748, 26994},
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },
    {
        spellID = 5209,  -- Challenging Roar
        tags = {C.TAUNT},
        cooldown = 600,
        duration = 6,
        specs = {S.FERAL},
    },
    {
        spellID = 6795,  -- Growl
        tags = {C.TAUNT},
        cooldown = 10,
        specs = {S.FERAL},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Balance (Priority: MF → IS → Starfire → FoN)
    -------------------------------------------------------------------------------
    {
        spellID = 8921,  -- Moonfire (apply first, instant)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 12,
        priority = 1,
        ranks = {563, 8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835, 26987, 26988},
        specs = {S.BALANCE},
    },
    {
        spellID = 5570,  -- Insect Swarm (maintain DoT)
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
        tags = {C.DPS, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {5176, 5177, 5178, 5179, 5180, 6780, 8905, 9912, 26984, 26985},
        specs = {S.BALANCE},
    },
    {
        spellID = 2912,  -- Starfire (main nuke - Balance spec filler)
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {2912, 8949, 8950, 8951, 9875, 9876, 25298, 26986},
        specs = {S.BALANCE},
    },
    {
        spellID = 33831,  -- Force of Nature (use on CD - throughput CD)
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.PET_SUMMON_TEMP, C.PVE},
        cooldown = 180,
        duration = 30,
        priority = 4,
        talent = true,
        specs = {S.BALANCE},
    },
    {
        spellID = 16914,  -- Hurricane (AoE)
        tags = {C.DPS, C.AOE, C.CC_SOFT, C.PVE},
        cooldown = 60,
        duration = 10,
        priority = 10,
        ranks = {16914, 17401, 17402, 27012},
        specs = {S.BALANCE},
    },
    {
        spellID = 770,  -- Faerie Fire (caster form, armor debuff)
        tags = {C.DEBUFF, C.UTILITY, C.PVE_PVP},
        cooldown = 0,
        duration = 40,
        priority = 6,
        ranks = {770, 778, 9749, 9907, 26993},
        specs = {S.BALANCE, S.RESTORATION},
    },
    {
        spellID = 27011,  -- Faerie Fire (Feral) - usable in cat/bear form
        tags = {C.DEBUFF, C.MAINTENANCE, C.PVE_PVP},
        cooldown = 0,
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
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        priority = 1,
        talent = true,
        ranks = {33876, 33982, 33983},
        specs = {S.FERAL},
    },
    {
        spellID = 27002,  -- Shred (main CP builder from behind)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 2,
        ranks = {5221, 6800, 8992, 9829, 9830, 27001, 27002, 27555},
        specs = {S.FERAL},
    },
    {
        spellID = 27003,  -- Rake (applies DoT debuff)
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
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 0,
        priority = 3,
        ranks = {1082, 3029, 5201, 9849, 9850, 27000},
        specs = {S.FERAL},
    },
    {
        spellID = 1079,  -- Rip (maintain at 5 CP)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 12,
        priority = 3,
        ranks = {1079, 9492, 9493, 9752, 9894, 9896, 27008},
        specs = {S.FERAL},
    },
    {
        spellID = 22568,  -- Ferocious Bite (dump excess CP/energy)
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
        tags = {C.TANK, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 2,
        specs = {S.FERAL},
    },
    {
        spellID = 779,  -- Swipe (AoE threat)
        tags = {C.TANK, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 0,
        priority = 3,
        ranks = {779, 780, 769, 9754, 9908, 26997},
        specs = {S.FERAL},
    },
    {
        spellID = 6807,  -- Maul (rage dump - situational)
        tags = {C.TANK, C.ROTATIONAL, C.MINOR, C.PVE},
        cooldown = 0,
        priority = 10,
        ranks = {6807, 6808, 6809, 7092, 8972, 9745, 9880, 9881, 26996},
        specs = {S.FERAL},
    },
    {
        spellID = 99,  -- Demoralizing Roar (maintain debuff)
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
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 15,
        priority = 4,
        talent = true,
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 5185,  -- Healing Touch (big heal / NS combo)
        tags = {C.HEAL_SINGLE, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {5185, 5186, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889, 25297, 26978, 26979},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 33891,  -- Tree of Life (maintain form)
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
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 600,
        talent = true,
        specs = {S.BALANCE, S.FERAL, S.RESTORATION},
    },

}, "DRUID")
