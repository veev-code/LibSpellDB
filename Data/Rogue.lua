--[[
    LibSpellDB - Rogue Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.ASSASSINATION, S.COMBAT, S.SUBTLETY}
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
        spellID = 1766,  -- Kick
        tags = {C.INTERRUPT},
        cooldown = 10,
        duration = 5,  -- Lockout duration
        ranks = {1766, 1767, 1768, 1769, 27613},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control - Hard CC
    -------------------------------------------------------------------------------
    {
        spellID = 2094,  -- Blind
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 300,
        duration = 10,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 6770,  -- Sap
        tags = {C.CC_HARD, C.DISORIENT, C.FILLER},  -- Spammable (stealth-only)
        cooldown = 0,
        duration = 45,
        ranks = {2070, 6770, 11297, 51724},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1776,  -- Gouge
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 10,
        duration = 4,
        ranks = {1776, 1777, 8629, 11285, 11286, 38764},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 408,  -- Kidney Shot
        tags = {C.CC_HARD, C.FINISHER},
        cooldown = 20,
        duration = 6,  -- Max duration at 5 CP
        ranks = {408, 8643},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1833,  -- Cheap Shot
        tags = {C.CC_HARD},
        cooldown = 0,
        duration = 4,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (Utility row - not throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 5277,  -- Evasion
        tags = {C.DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        ranks = {5277, 26669},
        auraTarget = AT.SELF,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1856,  -- Vanish
        tags = {C.DEFENSIVE, C.MAJOR, C.MOVEMENT_ESCAPE, C.STEALTH},
        cooldown = 300,
        ranks = {1856, 1857, 26889},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 31224,  -- Cloak of Shadows (TBC+)
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 90,
        duration = 5,
        auraTarget = AT.SELF,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Reactive Abilities
    -------------------------------------------------------------------------------
    {
        spellID = 14251,  -- Riposte (usable after parry)
        tags = {C.DPS, C.ROTATIONAL, C.REACTIVE, C.PVP},
        cooldown = 6,
        talent = true,
        specs = {S.COMBAT},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 13750,  -- Adrenaline Rush
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.COMBAT},
    },
    {
        spellID = 13877,  -- Blade Flurry
        tags = {C.DPS, C.MAJOR, C.AOE, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.COMBAT},
    },
    {
        spellID = 14177,  -- Cold Blood
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ASSASSINATION},
    },
    {
        spellID = 14185,  -- Preparation (resets CDs - utility, not throughput)
        tags = {C.UTILITY},
        cooldown = 600,
        talent = true,
        specs = {S.SUBTLETY},
    },
    {
        spellID = 14278,  -- Ghostly Strike (damage + dodge, minor throughput)
        tags = {C.DPS, C.MINOR, C.DEFENSIVE},
        cooldown = 20,
        duration = 7,
        talent = true,
        specs = {S.SUBTLETY},
    },
    {
        spellID = 14183,  -- Premeditation (CP generation)
        tags = {C.DPS, C.MINOR, C.RESOURCE},
        cooldown = 120,
        talent = true,
        specs = {S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 2983,  -- Sprint
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        ranks = {2983, 8696, 11305, 27621},
        auraTarget = AT.SELF,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Stealth
    -------------------------------------------------------------------------------
    {
        spellID = 1784,  -- Stealth
        tags = {C.STEALTH},
        cooldown = 10,
        ranks = {1784, 1785, 1786, 1787},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation (Priority: SnD → Expose → Rupture → Builder → Evis)
    -------------------------------------------------------------------------------
    {
        spellID = 5171,  -- Slice and Dice (maintain first, #1 priority)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.BUFF, C.HAS_BUFF, C.PVE},
        cooldown = 0,
        duration = 21,  -- Max at 5 CP
        priority = 1,
        ranks = {5171, 6774},
        auraTarget = AT.SELF,
        specs = {S.COMBAT, S.ASSASSINATION, S.SUBTLETY},
    },
    {
        spellID = 8647,  -- Expose Armor (situational - only if no warrior)
        tags = {C.DPS, C.MAINTENANCE, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 10,
        ranks = {8647, 8649, 8650, 11197, 11198, 26866},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1943,  -- Rupture (maintain DoT)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 22,  -- Max at 5 CP
        priority = 3,
        ranks = {1943, 8639, 8640, 11273, 11274, 11275, 26867},
        specs = {S.COMBAT, S.ASSASSINATION, S.SUBTLETY},
    },
    {
        spellID = 1752,  -- Sinister Strike (CP builder)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 4,
        ranks = {1752, 1757, 1758, 1759, 1760, 8621, 11293, 11294, 26861, 26862},
        specs = {S.COMBAT},
    },
    {
        spellID = 2098,  -- Eviscerate (dump excess CP)
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016, 26865},
        specs = {S.COMBAT, S.ASSASSINATION, S.SUBTLETY},
    },
    {
        spellID = 5938,  -- Shiv (apply poisons / utility - situational)
        tags = {C.DPS, C.MINOR, C.UTILITY, C.PVE_PVP},
        cooldown = 0,
        priority = 11,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 53,  -- Backstab (from behind)
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {53, 2589, 2590, 2591, 8721, 11279, 11280, 11281, 25300, 26863},
        specs = {S.ASSASSINATION, S.SUBTLETY},
    },
    {
        spellID = 1329,  -- Mutilate (Assassination builder)
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 4,
        talent = true,
        specs = {S.ASSASSINATION},
    },
    {
        spellID = 16511,  -- Hemorrhage (Subtlety builder)
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        talent = true,
        specs = {S.SUBTLETY},
        ranks = {16511, 17347, 17348, 26864},
        cooldownPriority = true,  -- Debuff tracking would hide the intelligent cooldown display
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 1725,  -- Distract
        tags = {C.UTILITY},
        cooldown = 30,
        duration = 10,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1966,  -- Feint
        tags = {C.UTILITY},
        cooldown = 10,
        ranks = {1966, 6768, 8637, 11303, 25302, 27448},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Poisons (weapon enchants, tracked via GetWeaponEnchantInfo)
    -------------------------------------------------------------------------------
    {
        spellID = 3409,  -- Crippling Poison
        tags = {C.CC_SOFT, C.DEBUFF},
        duration = 12,
        ranks = {3409, 11201},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Poison Buffs (long-duration weapon applications for Buff Reminders)
    -------------------------------------------------------------------------------
    {
        spellID = 8679,  -- Instant Poison (MH/OH weapon application)
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8679, 8686, 8688, 11338, 11339, 11340, 26890},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
        buffGroup = "ROGUE_POISONS",
        weaponEnchant = true,
    },
    {
        spellID = 2823,  -- Deadly Poison (MH/OH weapon application)
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {2823, 2824, 11355, 11356, 25347, 26967, 27186},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
        buffGroup = "ROGUE_POISONS",
        weaponEnchant = true,
    },
    {
        spellID = 13219,  -- Wound Poison (MH/OH weapon application)
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {13219, 13225, 13226, 13227, 27189},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
        buffGroup = "ROGUE_POISONS",
        weaponEnchant = true,
    },
    {
        spellID = 5761,  -- Mind-numbing Poison (MH/OH weapon application)
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 1800,
        ranks = {5761, 8694, 11400},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
        buffGroup = "ROGUE_POISONS",
        weaponEnchant = true,
    },
    {
        spellID = 3408,  -- Crippling Poison (MH/OH weapon application)
        tags = {C.BUFF, C.UTILITY, C.CC_SOFT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 1800,
        ranks = {3408, 11202},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
        buffGroup = "ROGUE_POISONS",
        weaponEnchant = true,
    },

}, "ROGUE")
