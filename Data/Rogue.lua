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
        name = "Kick",
        description = "A quick kick that injures a single foe for 15 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 5 sec.",
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
        name = "Blind",
        description = "Blinds the target, causing it to wander disoriented for up to 10 sec. Any damage caused will remove the effect.",
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 180,
        duration = 10,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 6770,  -- Sap
        name = "Sap",
        description = "Incapacitates the target for up to 25 sec. Must be stealthed. Only works on Humanoids that are not in combat. Any damage caused will revive the target. Only 1 target may be sapped at a time.",
        tags = {C.CC_HARD, C.DISORIENT, C.FILLER},  -- Spammable (stealth-only)
        cooldown = 0,
        duration = 45,
        singleTarget = true,
        ranks = {2070, 6770, 11297, 51724},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1776,  -- Gouge
        name = "Gouge",
        description = "Causes 10 damage, incapacitating the opponent for 4 sec, and turns off your attack. Target must be facing you. Any damage caused will revive the target. Awards 1 combo point.",
        tags = {C.CC_HARD, C.DISORIENT},
        cooldown = 10,
        duration = 4,
        ranks = {1776, 1777, 8629, 11285, 11286, 38764},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 408,  -- Kidney Shot
        name = "Kidney Shot",
        description = "Finishing move that stuns the target. Lasts longer per combo point: 1 point : 1 second 2 points: 2 seconds 3 points: 3 seconds 4 points: 4 seconds 5 points: 5 seconds",
        tags = {C.CC_HARD, C.FINISHER},
        cooldown = 20,
        duration = 6,  -- Max duration at 5 CP
        ranks = {408, 8643},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1833,  -- Cheap Shot
        name = "Cheap Shot",
        description = "Stuns the target for 4 sec. Must be stealthed. Awards 2 combo points.",
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
        name = "Evasion",
        description = "The rogue's dodge chance will increase by 50% for 15 sec.",
        tags = {C.DEFENSIVE, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        ranks = {5277, 26669},
        auraTarget = AT.SELF,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1856,  -- Vanish
        name = "Vanish",
        description = "Allows the rogue to vanish from sight, entering an improved stealth mode for 10 sec. Also breaks movement impairing effects.",
        tags = {C.DEFENSIVE, C.MAJOR, C.MOVEMENT_ESCAPE, C.STEALTH},
        cooldown = 300,
        ranks = {1856, 1857, 26889},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 31224,  -- Cloak of Shadows (TBC+)
        name = "Cloak of Shadows",
        description = "Instantly removes all existing harmful spell effects and increases your chance to resist all spells by 90% for 5 sec. Does not remove effects that prevent you from using Cloak of Shadows.",
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 60,
        duration = 5,
        auraTarget = AT.SELF,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },

    -------------------------------------------------------------------------------
    -- Reactive Abilities
    -------------------------------------------------------------------------------
    {
        spellID = 14251,  -- Riposte (usable after parry)
        name = "Riposte",
        description = "A strike that becomes active after parrying an opponent's attack. This attack deals 150% weapon damage and disarms the target for 6 sec.",
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
        name = "Adrenaline Rush",
        description = "Increases your Energy regeneration rate by 100% for 15 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 300,
        duration = 15,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.COMBAT},
    },
    {
        spellID = 13877,  -- Blade Flurry
        name = "Blade Flurry",
        description = "Increases your attack speed by 20%. In addition, attacks strike an additional nearby opponent. Lasts 15 sec.",
        tags = {C.DPS, C.MAJOR, C.AOE, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.COMBAT},
    },
    {
        spellID = 14177,  -- Cold Blood
        name = "Cold Blood",
        description = "When activated, increases the critical strike chance of your next offensive ability by 100%.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ASSASSINATION},
    },
    {
        spellID = 14185,  -- Preparation (resets CDs - utility, not throughput)
        name = "Preparation",
        description = "When activated, this ability immediately finishes the cooldown on your Evasion, Sprint, Vanish, Cold Blood, Shadowstep and Premeditation abilities.",
        tags = {C.UTILITY},
        cooldown = 600,
        talent = true,
        specs = {S.SUBTLETY},
    },
    {
        spellID = 14278,  -- Ghostly Strike (damage + dodge, minor throughput)
        name = "Ghostly Strike",
        description = "A strike that deals 125% weapon damage and increases your chance to dodge by 15% for 7 sec. Awards 1 combo point.",
        tags = {C.DPS, C.MINOR, C.DEFENSIVE},
        cooldown = 20,
        duration = 7,
        talent = true,
        specs = {S.SUBTLETY},
    },
    {
        spellID = 14183,  -- Premeditation (CP generation)
        name = "Premeditation",
        description = "When used, adds 2 combo points to your target. You must add to or use those combo points within 10 sec or the combo points are lost.",
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
        name = "Sprint",
        description = "Increases the rogue's movement speed by 50% for 15 sec. Does not break stealth.",
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
        name = "Stealth",
        description = "Allows the rogue to sneak around, but reduces your speed by 50%. Lasts until cancelled.",
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
        name = "Slice and Dice",
        description = "Finishing move that increases melee attack speed by 20%. Lasts longer per combo point: 1 point : 9 seconds 2 points: 12 seconds 3 points: 15 seconds 4 points: 18 seconds 5 points: 21 seconds",
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
        name = "Expose Armor",
        description = "Finishing move that exposes the target for 30 sec, reducing armor per combo point: 1 point : 80 armor 2 points: 160 armor 3 points: 240 armor 4 points: 320 armor 5 points: 400 armor",
        tags = {C.DPS, C.MAINTENANCE, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 30,
        priority = 10,
        ranks = {8647, 8649, 8650, 11197, 11198, 26866},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1943,  -- Rupture (maintain DoT)
        name = "Rupture",
        description = "Finishing move that causes damage over time, increased by your attack power. Lasts longer per combo point: 1 point : 40 damage over 8 secs 2 points: 60 damage over 10 secs 3 points: 84 damage over 12 secs 4 points: 112 damage over 14 secs 5 points: 144 damage over 16 secs",
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.DEBUFF, C.PVE},
        cooldown = 0,
        duration = 22,  -- Max at 5 CP
        priority = 3,
        ranks = {1943, 8639, 8640, 11273, 11274, 11275, 26867},
        specs = {S.COMBAT, S.ASSASSINATION, S.SUBTLETY},
    },
    {
        spellID = 1752,  -- Sinister Strike (CP builder)
        name = "Sinister Strike",
        description = "An instant strike that causes 3 damage in addition to your normal weapon damage. Awards 1 combo point.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 4,
        ranks = {1752, 1757, 1758, 1759, 1760, 8621, 11293, 11294, 26861, 26862},
        specs = {S.COMBAT},
    },
    {
        spellID = 2098,  -- Eviscerate (dump excess CP)
        name = "Eviscerate",
        description = "Finishing move that causes damage per combo point: 1 point : (1 + 5 + Attack Power * 0.03)-(5 + 5 + Attack Power * 0.03) damage 2 points: [1 + (10) + Attack Power * 0.06]-[5 + (10) + Attack Power * 0.06] damage 3 points: [1 + (15) + Attack Power * 0.09]-[5 + (15) + Attack Power * 0.09] damage 4 points: [1 + (20) + Attack Power * 0.12]-[5 + (20) + Attack Power * 0.12] damage 5 points: [1 + (25) + Attack Power * 0.15]-[5 + (25) + Attack Power * 0.15] damage",
        tags = {C.DPS, C.ROTATIONAL, C.FINISHER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016, 26865},
        specs = {S.COMBAT, S.ASSASSINATION, S.SUBTLETY},
    },
    {
        spellID = 5938,  -- Shiv (apply poisons / utility - situational)
        name = "Shiv",
        description = "Performs an instant off-hand weapon attack that automatically applies the poison from your off-hand weapon to the target. Slower weapons require more Energy. Awards 1 combo point.",
        tags = {C.DPS, C.MINOR, C.UTILITY, C.PVE_PVP},
        cooldown = 0,
        priority = 11,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 53,  -- Backstab (from behind)
        name = "Backstab",
        description = "Backstab the target, causing 150% weapon damage plus 15 to the target. Must be behind the target. Requires a dagger in the main hand. Awards 1 combo point.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {53, 2589, 2590, 2591, 8721, 11279, 11280, 11281, 25300, 26863},
        specs = {S.ASSASSINATION, S.SUBTLETY},
    },
    {
        spellID = 1329,  -- Mutilate (Assassination builder)
        name = "Mutilate",
        description = "Instantly attacks with both weapons for an additional 44 with each weapon. Damage is increased by 50% against Poisoned targets. Must be behind the target. Awards 2 combo points.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 4,
        talent = true,
        specs = {S.ASSASSINATION},
    },
    {
        spellID = 16511,  -- Hemorrhage (Subtlety builder)
        name = "Hemorrhage",
        description = "An instant strike that deals 110% weapon damage and causes the target to hemorrhage, increasing any Physical damage dealt to the target by up to 13. Lasts 10 charges or 15 sec. Awards 1 combo point.",
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
        name = "Distract",
        description = "Throws a distraction, attracting the attention of all nearby monsters for 10 seconds. Does not break stealth.",
        tags = {C.UTILITY},
        cooldown = 30,
        duration = 10,
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
    },
    {
        spellID = 1966,  -- Feint
        name = "Feint",
        description = "Performs a feint, causing no damage but lowering your threat by a small amount, making the enemy less likely to attack you.",
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
        name = "Crippling Poison",
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
        name = "Instant Poison",
        description = "Coats a weapon with poison that lasts for 1 hour.Each strike has a 20% chance of poisoning the enemy which instantly inflicts 19 to 25 Nature damage.",
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
        name = "Deadly Poison",
        description = "Coats a weapon with poison that lasts for 1 hour.Each strike has a 30% chance of poisoning the enemy for 36 Nature damage over 12 sec. Stacks up to 5 times on a single target.",
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
        name = "Wound Poison",
        description = "Coats a weapon with poison that lasts for 1 hour.Each strike has a 30% chance of poisoning the enemy, causing 17 Nature damage and reducing all healing effects used on them by 10% for 15 sec. Stacks up to 5 times on a single target.",
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
        name = "Mind-numbing Poison",
        description = "Coats a weapon with poison that lasts for 1 hour.Each strike has a 20% chance of poisoning the enemy, increasing their casting time by 40% for 10 sec.",
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
        name = "Crippling Poison",
        description = "Coats a weapon with poison that lasts for 1 hour.Each strike has a 30% chance of poisoning the enemy, slowing their movement speed by 50% for 12 sec.",
        tags = {C.BUFF, C.UTILITY, C.CC_SOFT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 1800,
        ranks = {3408, 11202},
        specs = {S.ASSASSINATION, S.COMBAT, S.SUBTLETY},
        buffGroup = "ROGUE_POISONS",
        weaponEnchant = true,
    },

}, "ROGUE")
