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
        tags = {C.CC_HARD},
        cooldown = 0,  -- Trap has arming time, shared with other traps
        duration = 20,
        ranks = {3355, 14308, 14309, 31932},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 19386,  -- Wyvern Sting
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
        tags = {C.CC_HARD, C.FEAR},
        cooldown = 30,
        duration = 20,
        ranks = {1513, 14326, 14327},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1499,  -- Freezing Trap (the trap itself)
        tags = {C.CC_HARD, C.UTILITY},
        cooldown = 15,  -- Trap cooldown
        ranks = {1499, 14310, 14311, 27753},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Soft CC / Slows
    -------------------------------------------------------------------------------
    {
        spellID = 5116,  -- Concussive Shot
        tags = {C.CC_SOFT},
        cooldown = 12,
        duration = 4,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 2974,  -- Wing Clip
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
        tags = {C.DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 10,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.SURVIVAL},
    },
    {
        spellID = 5384,  -- Feign Death
        tags = {C.DEFENSIVE, C.MINOR, C.UTILITY},
        cooldown = 30,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 19574,  -- Bestial Wrath
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PET},
        cooldown = 120,
        duration = 18,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.BEAST_MASTERY},
    },
    {
        spellID = 3045,  -- Rapid Fire
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        auraTarget = AT.SELF,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 23989,  -- Readiness (resets CDs - utility aspect but DPS gain)
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
        tags = {C.UTILITY},
        cooldown = 5,
        ranks = {781, 14272, 14273, 27015},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 5118,  -- Aspect of the Cheetah
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13159,  -- Aspect of the Pack
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Dispels
    -------------------------------------------------------------------------------
    {
        spellID = 19801,  -- Tranquilizing Shot
        tags = {C.PURGE, C.DISPEL_MAGIC},
        cooldown = 20,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Pet Control
    -------------------------------------------------------------------------------
    {
        spellID = 2641,  -- Dismiss Pet
        tags = {C.PET_CONTROL, C.UTILITY},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 883,  -- Call Pet
        tags = {C.PET_SUMMON, C.UTILITY},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 136,  -- Mend Pet
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
        tags = {C.DPS, C.MINOR, C.DEBUFF},
        cooldown = 15,
        ranks = {13795, 14302, 14303, 14304, 14305, 27023},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13813,  -- Explosive Trap
        tags = {C.DPS, C.MINOR, C.AOE},
        cooldown = 15,
        ranks = {13813, 14316, 14317, 27025},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13809,  -- Frost Trap
        tags = {C.CC_SOFT, C.UTILITY},
        cooldown = 15,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation (Priority: MD → Serpent → Kill Command → Steady → Multi → Arcane → Aimed)
    -------------------------------------------------------------------------------
    {
        spellID = 34477,  -- Misdirection (use on pull)
        tags = {C.UTILITY, C.PVE},
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
        spellID = 1978,  -- Serpent Sting (maintain DoT)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 15,
        priority = 2,
        ranks = {1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295, 27016},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 34026,  -- Kill Command (use on CD with pet)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 5,
        priority = 3,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 34120,  -- Steady Shot (main shot, weave with Auto)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 4,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 2643,  -- Multi-Shot (AoE / cleave - used in both ST and AoE)
        tags = {C.DPS, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 10,
        priority = 10,
        ranks = {2643, 14288, 14289, 14290, 25294, 27021},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1510,  -- Volley (AoE only)
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 6,
        priority = 11,
        ranks = {1510, 14294, 14295, 27022},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 3044,  -- Arcane Shot (mana dump / BM rotation)
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 6,
        priority = 7,
        ranks = {3044, 14281, 14282, 14283, 14284, 14285, 14286, 14287, 27019},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 19434,  -- Aimed Shot (when procs / opener)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 6,
        priority = 8,
        talent = true,
        ranks = {19434, 20900, 20901, 20902, 20903, 20904, 27065, 27632},
        specs = {S.MARKSMANSHIP},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 1543,  -- Flare
        tags = {C.UTILITY, C.STEALTH_BREAK},
        cooldown = 15,
        duration = 30,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 1462,  -- Beast Lore
        tags = {C.UTILITY},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13161,  -- Aspect of the Beast
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13163,  -- Aspect of the Monkey
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },
    {
        spellID = 13165,  -- Aspect of the Hawk
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        ranks = {13165, 14318, 14319, 14320, 14321, 14322, 25296, 27044},
        specs = {S.BEAST_MASTERY, S.MARKSMANSHIP, S.SURVIVAL},
    },

}, "HUNTER")
