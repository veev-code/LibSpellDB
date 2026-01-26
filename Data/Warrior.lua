--[[
    LibSpellDB - Warrior Spells (Anniversary Edition / Classic)
    
    specs field: nil = all specs, or list specific specs where ability is RELEVANT
    Note: Relevance != exclusive. Arms can use Shield Wall, it's just more relevant for Prot.
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- CC Breaks (utility priority 1)
    -------------------------------------------------------------------------------
    {
        spellID = 18499,  -- Berserker Rage (CC break - moved to top)
        tags = {C.CC_BREAK, C.CC_IMMUNITY, C.HAS_BUFF},
        cooldown = 30,
        duration = 10,
        priority = 1,  -- CC break = highest utility priority
        specs = nil,
    },

    -------------------------------------------------------------------------------
    -- Movement / Gap Closers (utility priority 2)
    -------------------------------------------------------------------------------
    {
        spellID = 100,  -- Charge
        tags = {C.CC_HARD, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 15,
        duration = 1,
        priority = 2,  -- Movement
        ranks = {100, 6178, 11578},
        specs = nil,
    },
    {
        spellID = 20252,  -- Intercept (next to Charge)
        tags = {C.CC_HARD, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 30,
        duration = 3,
        priority = 2,  -- Movement
        ranks = {20252, 20616, 20617},
        specs = nil,
    },
    {
        spellID = 3411,  -- Intervene (movement utility, intercepts next attack)
        tags = {C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 30,
        priority = 2,  -- Movement
        specs = nil,
    },

    -------------------------------------------------------------------------------
    -- Hard CC (utility priority 3)
    -------------------------------------------------------------------------------
    {
        spellID = 5246,  -- Intimidating Shout
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 180,
        duration = 8,
        priority = 3,  -- Hard CC
        specs = nil,
        appliesAura = {
            spellID = 20511,
            type = "DEBUFF",
            onTarget = true,
        },
    },
    {
        spellID = 12809,  -- Concussion Blow
        tags = {C.CC_HARD},
        cooldown = 45,
        duration = 5,
        priority = 3,  -- Hard CC
        talent = true,
        specs = {"PROTECTION"},
    },
    {
        spellID = 676,  -- Disarm
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 10,
        priority = 3,  -- Hard CC
        specs = nil,
    },

    -------------------------------------------------------------------------------
    -- Interrupts (utility priority 4)
    -------------------------------------------------------------------------------
    {
        spellID = 6552,  -- Pummel
        tags = {C.INTERRUPT},
        cooldown = 10,
        duration = 4,
        priority = 4,  -- Interrupt
        ranks = {6552, 6554},
        specs = {"ARMS", "FURY"},
    },
    {
        spellID = 72,  -- Shield Bash
        tags = {C.INTERRUPT},
        cooldown = 12,
        duration = 6,
        priority = 4,  -- Interrupt
        ranks = {72, 1671, 1672},
        specs = {"PROTECTION"},
    },

    -------------------------------------------------------------------------------
    -- Soft CC (utility priority 5)
    -------------------------------------------------------------------------------
    {
        spellID = 1715,  -- Hamstring
        tags = {C.CC_SOFT},
        cooldown = 0,
        duration = 15,
        priority = 5,  -- Soft CC
        ranks = {1715, 7372, 7373},
        specs = nil,
    },
    {
        spellID = 12323,  -- Piercing Howl
        tags = {C.CC_SOFT},
        cooldown = 0,
        duration = 6,
        priority = 5,  -- Soft CC
        talent = true,
        specs = {"FURY"},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (utility priority 6)
    -------------------------------------------------------------------------------
    {
        spellID = 871,  -- Shield Wall
        tags = {C.DEFENSIVE, C.MAJOR, C.DAMAGE_REDUCTION, C.HAS_BUFF},
        cooldown = 1800,
        duration = 10,
        priority = 6,  -- Personal defensive
        specs = {"PROTECTION"},
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },
    {
        spellID = 12975,  -- Last Stand
        tags = {C.DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 600,
        duration = 20,
        priority = 6,  -- Personal defensive
        talent = true,
        specs = {"PROTECTION"},
    },
    {
        spellID = 23920,  -- Spell Reflection
        tags = {C.DEFENSIVE, C.MINOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 10,
        duration = 5,
        priority = 6,  -- Personal defensive
        specs = nil,
    },

    -------------------------------------------------------------------------------
    -- Resource (utility priority 7)
    -------------------------------------------------------------------------------
    {
        spellID = 2687,  -- Bloodrage
        tags = {C.DPS, C.MINOR, C.RESOURCE, C.HAS_BUFF},
        cooldown = 60,
        duration = 10,
        priority = 7,  -- Resource
        specs = nil,
        appliesAura = {
            spellID = 29131,  -- Bloodrage buff ID (different from ability ID)
            type = "BUFF",
            onPlayer = true,
        },
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 1719,  -- Recklessness
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 1800,
        duration = 15,
        specs = {"FURY"},
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },
    {
        spellID = 12292,  -- Death Wish
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        duration = 30,
        talent = true,
        specs = {"FURY"},
    },
    {
        spellID = 12328,  -- Sweeping Strikes (Fury talent in TBC/Anniversary)
        tags = {C.DPS, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 10,
        talent = true,
        specs = {"FURY"},  -- Fury tree talent in TBC
    },
    {
        spellID = 20230,  -- Retaliation
        tags = {C.DPS, C.MAJOR, C.DEFENSIVE, C.HAS_BUFF},
        cooldown = 1800,
        duration = 15,
        specs = {"ARMS"},
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },


    -------------------------------------------------------------------------------
    -- Core Rotation - Arms (Priority: Rend → MS → Overpower → WW → Slam → Execute)
    -------------------------------------------------------------------------------
    {
        spellID = 772,  -- Rend (apply first for Deep Wounds/Trauma)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 15,
        priority = 1,
        ranks = {772, 6546, 6547, 6548, 11572, 11573, 11574, 25208},
        specs = {"ARMS"},
    },
    {
        spellID = 12294,  -- Mortal Strike (highest damage, use on CD)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 6,
        duration = 10,
        priority = 2,
        talent = true,
        ranks = {12294, 21551, 21552, 21553, 25248, 30330},
        specs = {"ARMS"},
    },
    {
        spellID = 7384,  -- Overpower (use when proc available)
        tags = {C.DPS, C.ROTATIONAL, C.REACTIVE, C.PVE_PVP},
        cooldown = 5,
        priority = 3,
        ranks = {7384, 7887, 11584, 11585},
        specs = {"ARMS"},
    },
    {
        spellID = 1680,  -- Whirlwind (after MS, strong damage - used in both ST and AoE)
        tags = {C.DPS, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 10,
        priority = 4,
        specs = {"FURY", "ARMS"},
    },
    {
        spellID = 1464,  -- Slam (filler between abilities)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 5,
        ranks = {1464, 8820, 11604, 11605, 25241, 25242},
        specs = {"ARMS"},
    },
    {
        spellID = 5308,  -- Execute (sub-20% finisher)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.REACTIVE, C.PVE_PVP},
        cooldown = 0,
        priority = 6,
        ranks = {5308, 20658, 20660, 20661, 20662, 25234, 25236},
        specs = {"ARMS", "FURY"},
    },
    {
        spellID = 34428,  -- Victory Rush (TBC, usable after killing blow)
        tags = {C.DPS, C.ROTATIONAL, C.REACTIVE, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 7,
        specs = {"ARMS", "FURY"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Fury (Priority: BT → WW → HS dump → Execute)
    -------------------------------------------------------------------------------
    {
        spellID = 23881,  -- Bloodthirst (use on CD)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 6,
        priority = 1,
        talent = true,
        ranks = {23881, 23892, 23893, 23894, 25251, 30335},
        specs = {"FURY"},
        ignoreAura = true,  -- Buff (healing on next 5 hits) is longer than CD and not worth tracking
    },
    {
        spellID = 29801,  -- Rampage (critical buff to maintain, procs on crit)
        tags = {C.DPS, C.ROTATIONAL, C.BUFF, C.HAS_BUFF, C.REACTIVE, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 2,
        talent = true,
        specs = {"FURY"},
        appliesAura = {
            spellID = 30031,  -- Rampage buff ID (different from ability ID)
            type = "BUFF",
            onPlayer = true,
        },
    },
    {
        spellID = 78,  -- Heroic Strike (rage dump, use when >50 rage)
        tags = {C.DPS, C.MINOR, C.PVE},
        cooldown = 0,
        priority = 10,  -- Lower priority (situational)
        ranks = {78, 284, 285, 1608, 11564, 11565, 11566, 11567, 25286, 29707},
        specs = nil,
    },
    {
        spellID = 845,  -- Cleave (AoE rage dump)
        tags = {C.DPS, C.MINOR, C.AOE, C.PVE},
        cooldown = 0,
        priority = 11,  -- Lower priority (situational)
        ranks = {845, 7369, 11608, 11609, 20569, 25231},
        specs = nil,
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Protection (Priority: Shield Block → Revenge → Shield Slam → Devastate)
    -------------------------------------------------------------------------------
    {
        spellID = 2565,  -- Shield Block (use on CD for survivability)
        tags = {C.TANK, C.ROTATIONAL, C.DEFENSIVE, C.HAS_BUFF, C.PVE},
        cooldown = 5,
        duration = 5,
        priority = 1,
        specs = {"PROTECTION"},
    },
    {
        spellID = 6572,  -- Revenge (highest threat when proc'd)
        tags = {C.TANK, C.ROTATIONAL, C.REACTIVE, C.PVE},
        cooldown = 5,
        priority = 2,
        ranks = {6572, 6574, 7379, 11600, 11601, 25288, 25269, 30357},
        specs = {"PROTECTION"},
    },
    {
        spellID = 23922,  -- Shield Slam (high threat on CD)
        tags = {C.TANK, C.ROTATIONAL, C.PVE},
        cooldown = 6,
        priority = 3,
        talent = true,
        ranks = {23922, 23923, 23924, 23925, 25258, 30356},
        specs = {"PROTECTION"},
    },
    {
        spellID = 20243,  -- Devastate (filler, stacks Sunder)
        tags = {C.TANK, C.ROTATIONAL, C.DEBUFF, C.PVE},
        cooldown = 0,
        priority = 4,
        talent = true,
        ranks = {20243, 30016, 30022},
        specs = {"PROTECTION"},
    },

    -------------------------------------------------------------------------------
    -- Tank Maintenance (debuffs to keep up)
    -------------------------------------------------------------------------------
    {
        spellID = 6343,  -- Thunder Clap (maintain attack speed debuff)
        tags = {C.TANK, C.MAINTENANCE, C.DEBUFF, C.CC_SOFT, C.PVE},
        cooldown = 4,
        duration = 30,
        priority = 5,
        ranks = {6343, 8198, 8204, 8205, 11580, 11581, 25264},
        specs = {"PROTECTION"},
    },
    {
        spellID = 1160,  -- Demoralizing Shout (maintain AP reduction debuff)
        tags = {C.TANK, C.MAINTENANCE, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 6,
        ranks = {1160, 6190, 11554, 11555, 11556, 25202, 25203},
        specs = {"PROTECTION"},
    },

    -------------------------------------------------------------------------------
    -- Taunt (tanks only)
    -------------------------------------------------------------------------------
    {
        spellID = 355,  -- Taunt
        tags = {C.TAUNT},
        cooldown = 10,
        specs = {"PROTECTION"},
    },
    {
        spellID = 1161,  -- Challenging Shout
        tags = {C.TAUNT},
        cooldown = 600,
        duration = 6,
        specs = {"PROTECTION"},
    },
    {
        spellID = 694,  -- Mocking Blow
        tags = {C.TAUNT},
        cooldown = 120,
        duration = 6,
        specs = {"PROTECTION"},
    },

    -------------------------------------------------------------------------------
    -- Utility (not typically tracked)
    -------------------------------------------------------------------------------
    {
        spellID = 7386,  -- Sunder Armor
        tags = {C.DEBUFF, C.UTILITY},
        cooldown = 0,
        duration = 30,
        ranks = {7386, 7405, 8380, 11596, 11597},
        specs = {"PROTECTION"},
    },

}, "WARRIOR")
