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
    -- Interrupts (all specs use these)
    -------------------------------------------------------------------------------
    {
        spellID = 6552,  -- Pummel
        tags = {C.INTERRUPT},
        cooldown = 10,
        duration = 4,
        ranks = {6552, 6554},
        specs = {"ARMS", "FURY"},  -- Berserker stance, so DPS specs
    },
    {
        spellID = 72,  -- Shield Bash
        tags = {C.INTERRUPT},
        cooldown = 12,
        duration = 6,
        ranks = {72, 1671, 1672},
        specs = {"PROTECTION"},  -- Requires shield
    },

    -------------------------------------------------------------------------------
    -- Gap Closers / CC (all specs in PvP, but context matters)
    -------------------------------------------------------------------------------
    {
        spellID = 100,  -- Charge
        tags = {C.CC_HARD, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 15,
        duration = 1,
        ranks = {100, 6178, 11578},
        specs = nil,  -- All specs
    },
    {
        spellID = 20252,  -- Intercept
        tags = {C.CC_HARD, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 30,
        duration = 3,
        ranks = {20252, 20616, 20617},
        specs = nil,  -- All specs use for stun
    },
    {
        spellID = 12809,  -- Concussion Blow
        tags = {C.CC_HARD},
        cooldown = 45,
        duration = 5,
        talent = true,
        specs = {"PROTECTION"},  -- Prot talent
    },
    {
        spellID = 5246,  -- Intimidating Shout
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 180,
        duration = 8,
        specs = nil,  -- All specs (PvP essential)
        -- Track the fear debuff when active on targets
        appliesAura = {
            spellID = 20511,  -- Fear debuff ID
            type = "DEBUFF",
            onTarget = true,  -- Track on enemy targets
        },
    },

    -------------------------------------------------------------------------------
    -- Soft CC
    -------------------------------------------------------------------------------
    {
        spellID = 1715,  -- Hamstring
        tags = {C.CC_SOFT, C.CORE_ROTATION},
        cooldown = 0,
        duration = 15,
        ranks = {1715, 7372, 7373},
        specs = nil,  -- All specs in PvP
    },
    {
        spellID = 12323,  -- Piercing Howl
        tags = {C.CC_SOFT},
        cooldown = 0,
        duration = 6,
        talent = true,
        specs = {"FURY"},  -- Fury talent
    },

    -------------------------------------------------------------------------------
    -- Disarm
    -------------------------------------------------------------------------------
    {
        spellID = 676,  -- Disarm
        tags = {C.CC_HARD},
        cooldown = 60,
        duration = 10,
        specs = nil,  -- All specs in PvP
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 1719,  -- Recklessness
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 1800,
        duration = 15,
        specs = {"FURY"},  -- Show for Fury (Berserker Stance CD)
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },
    {
        spellID = 12292,  -- Death Wish
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 180,
        duration = 30,
        talent = true,
        specs = {"FURY"},  -- Fury talent
    },
    {
        spellID = 12328,  -- Sweeping Strikes
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 30,
        duration = 10,
        talent = true,
        specs = {"ARMS"},  -- Arms talent
    },
    {
        spellID = 2687,  -- Bloodrage
        tags = {C.OFFENSIVE_CD_MINOR, C.RESOURCE},
        cooldown = 60,
        duration = 10,
        specs = nil,  -- All specs use for rage
    },
    {
        spellID = 20230,  -- Retaliation
        tags = {C.OFFENSIVE_CD, C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 1800,
        duration = 15,
        specs = {"ARMS"},  -- Show for Arms (Battle Stance CD)
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 871,  -- Shield Wall
        tags = {C.PERSONAL_DEFENSIVE, C.DAMAGE_REDUCTION, C.TRACK_BUFF},
        cooldown = 1800,
        duration = 10,
        specs = {"PROTECTION"},  -- Show for Protection (Defensive Stance CD)
        sharedCooldownGroup = "WARRIOR_30MIN_CD",
    },
    {
        spellID = 12975,  -- Last Stand
        tags = {C.PERSONAL_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 600,
        duration = 20,
        talent = true,
        specs = {"PROTECTION"},  -- Prot talent
    },
    {
        spellID = 23920,  -- Spell Reflection
        tags = {C.PERSONAL_DEFENSIVE, C.IMMUNITY, C.TRACK_BUFF},
        cooldown = 10,
        duration = 5,
        specs = nil,  -- All specs in PvP (with shield swap)
    },

    -------------------------------------------------------------------------------
    -- External / Utility Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 3411,  -- Intervene
        tags = {C.EXTERNAL_DEFENSIVE, C.MOVEMENT_GAP_CLOSE, C.MOVEMENT},
        cooldown = 30,
        specs = nil,  -- All specs (mobility + save ally)
    },

    -------------------------------------------------------------------------------
    -- CC Break
    -------------------------------------------------------------------------------
    {
        spellID = 18499,  -- Berserker Rage
        tags = {C.CC_BREAK, C.CC_IMMUNITY, C.TRACK_BUFF},
        cooldown = 30,
        duration = 10,
        specs = nil,  -- All specs (essential PvP)
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Arms
    -------------------------------------------------------------------------------
    {
        spellID = 12294,  -- Mortal Strike
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 6,
        duration = 10,
        talent = true,
        ranks = {12294, 21551, 21552, 21553},
        specs = {"ARMS"},
    },
    {
        spellID = 7384,  -- Overpower
        tags = {C.CORE_ROTATION, C.REACTIVE},
        cooldown = 5,
        ranks = {7384, 7887, 11584, 11585},
        specs = {"ARMS"},  -- Arms primary, procs off dodge
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Fury
    -------------------------------------------------------------------------------
    {
        spellID = 23881,  -- Bloodthirst
        tags = {C.CORE_ROTATION},
        cooldown = 6,
        talent = true,
        ranks = {23881, 23892, 23893, 23894},
        specs = {"FURY"},
    },
    {
        spellID = 1680,  -- Whirlwind
        tags = {C.CORE_ROTATION},
        cooldown = 10,
        specs = {"FURY", "ARMS"},  -- Both DPS specs
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Protection
    -------------------------------------------------------------------------------
    {
        spellID = 23922,  -- Shield Slam
        tags = {C.CORE_ROTATION},
        cooldown = 6,
        talent = true,
        ranks = {23922, 23923, 23924, 23925},
        specs = {"PROTECTION"},
    },
    {
        spellID = 6572,  -- Revenge
        tags = {C.CORE_ROTATION, C.REACTIVE},
        cooldown = 5,
        ranks = {6572, 6574, 7379, 11600, 11601, 25288},
        specs = {"PROTECTION"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Shared
    -------------------------------------------------------------------------------
    {
        spellID = 78,  -- Heroic Strike
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {78, 284, 285, 1608, 11564, 11565, 11566, 11567, 25286},
        specs = nil,  -- All specs (rage dump)
    },
    {
        spellID = 845,  -- Cleave
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {845, 7369, 11608, 11609, 20569},
        specs = nil,  -- All specs (AoE rage dump)
    },
    {
        spellID = 6343,  -- Thunder Clap
        tags = {C.CORE_ROTATION, C.DEBUFF, C.CC_SOFT},
        cooldown = 4,
        duration = 30,
        ranks = {6343, 8198, 8204, 8205, 11580, 11581},
        specs = {"PROTECTION"},  -- Tanks primarily
    },
    {
        spellID = 772,  -- Rend
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 0,
        duration = 15,
        ranks = {772, 6546, 6547, 6548, 11572, 11573, 11574},
        specs = {"ARMS"},  -- Arms (trauma synergy)
    },
    {
        spellID = 1464,  -- Slam
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {1464, 8820, 11604, 11605},
        specs = {"ARMS"},  -- Arms slam build
    },
    {
        spellID = 5308,  -- Execute
        tags = {C.CORE_ROTATION, C.FINISHER, C.REACTIVE},
        cooldown = 0,
        ranks = {5308, 20658, 20660, 20661, 20662},
        specs = {"ARMS", "FURY"},  -- DPS specs
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
