--[[
    LibSpellDB - Proc Buff Data
    
    Defines important proc buffs for each class.
    These are passive buffs that proc from talents/abilities and are worth tracking.
    
    Note: The spellID here is the BUFF ID (what appears in UnitBuff), not the ability ID.
    This may differ from the triggering ability's spell ID.
]]

local MAJOR, MINOR = "LibSpellDB-1.0", 1
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

-------------------------------------------------------------------------------
-- Warrior Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Enrage (Fury talent) - procs when taking damage after crit
    {
        spellID = 14204,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 12,
        talent = true,
        procInfo = {
            description = "5% damage increase when enraged",
            stacks = false,
        },
    },
    -- Flurry (Fury talent) - procs on melee crit
    {
        spellID = 12970,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "25% attack speed increase",
            stacks = 3,
            consumedOnHit = true,
        },
    },
    -- Deep Wounds (Arms talent) - debuff applied to target on melee crit
    {
        spellID = 12721,  -- Deep Wounds debuff (all ranks use this buff ID)
        tags = {C.PROC, C.DEBUFF},
        cooldown = 0,
        duration = 12,
        talent = true,
        procInfo = {
            description = "Bleed damage over 12 sec",
            stacks = false,
            onTarget = true,  -- This is a debuff on target, not a buff on player
        },
    },
}, "WARRIOR")

-------------------------------------------------------------------------------
-- Rogue Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Note: Blade Flurry and Adrenaline Rush are active abilities, not procs
    -- But they can be tracked as important buffs
    
    -- Blade Flurry buff (from ability)
    {
        spellID = 13877,
        tags = {C.PROC, C.OFFENSIVE_CD},
        cooldown = 120,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Attacks hit an additional nearby enemy",
            stacks = false,
        },
    },
    -- Adrenaline Rush buff (from ability)
    {
        spellID = 13750,
        tags = {C.PROC, C.OFFENSIVE_CD},
        cooldown = 300,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Energy regeneration increased 100%",
            stacks = false,
        },
    },
}, "ROGUE")

-------------------------------------------------------------------------------
-- Mage Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Clearcasting (Arcane Concentration proc)
    {
        spellID = 12536,
        tags = {C.PROC, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Next spell costs no mana",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Arcane Power buff
    {
        spellID = 12042,
        tags = {C.PROC, C.OFFENSIVE_CD},
        cooldown = 180,
        duration = 15,
        talent = true,
        procInfo = {
            description = "30% spell damage, 30% mana cost",
            stacks = false,
        },
    },
    -- Icy Veins buff
    {
        spellID = 12472,
        tags = {C.PROC, C.OFFENSIVE_CD},
        cooldown = 180,
        duration = 20,
        talent = true,
        procInfo = {
            description = "20% spell haste",
            stacks = false,
        },
    },
    -- Presence of Mind buff
    {
        spellID = 12043,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 180,
        duration = 0, -- Until used
        talent = true,
        procInfo = {
            description = "Next spell is instant cast",
            stacks = false,
            consumedOnCast = true,
        },
    },
}, "MAGE")

-------------------------------------------------------------------------------
-- Warlock Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Shadow Trance (Nightfall proc)
    {
        spellID = 17941,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "Next Shadow Bolt is instant",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Backlash (Destruction talent proc)
    {
        spellID = 34939,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "Next Shadow Bolt or Incinerate is instant",
            stacks = false,
            consumedOnCast = true,
        },
    },
}, "WARLOCK")

-------------------------------------------------------------------------------
-- Priest Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Spirit Tap (Shadow talent, on kill)
    {
        spellID = 15271,
        tags = {C.PROC, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "100% spirit, 50% mana regen while casting",
            stacks = false,
        },
    },
    -- Surge of Light (Holy talent proc) - Note: may need ID verification
    {
        spellID = 33154,
        tags = {C.PROC, C.HEALING_CD_MINOR},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "Next Flash Heal or Smite is instant and costs no mana",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Focused Will (Discipline talent, procs on crit received)
    {
        spellID = 45242,
        tags = {C.PROC, C.PERSONAL_DEFENSIVE},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "4% damage reduction, 10% healing increase per stack",
            stacks = 3,
        },
    },
}, "PRIEST")

-------------------------------------------------------------------------------
-- Shaman Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Clearcasting (Elemental Focus proc)
    {
        spellID = 16246,
        tags = {C.PROC, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Next 2 damage spells cost 40% less mana",
            stacks = 2,
            consumedOnCast = true,
        },
    },
    -- Unleashed Rage (Enhancement talent, on crit)
    {
        spellID = 30802,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "Party melee AP increased by 10%",
            stacks = false,
        },
    },
}, "SHAMAN")

-------------------------------------------------------------------------------
-- Druid Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Clearcasting (Omen of Clarity proc)
    {
        spellID = 16870,
        tags = {C.PROC, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Next ability costs no mana/energy/rage",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Nature's Grace (Balance talent, on crit)
    {
        spellID = 16886,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Next spell cast time reduced by 0.5s",
            stacks = false,
            consumedOnCast = true,
        },
    },
}, "DRUID")

-------------------------------------------------------------------------------
-- Paladin Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Vengeance (Retribution talent, stacking on crit)
    {
        spellID = 20055,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "Physical and Holy damage increased",
            stacks = 3,
        },
    },
}, "PALADIN")

-------------------------------------------------------------------------------
-- Hunter Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Quick Shots (Improved Aspect of the Hawk proc)
    {
        spellID = 6150,
        tags = {C.PROC, C.OFFENSIVE_CD_MINOR},
        cooldown = 0,
        duration = 12,
        talent = true,
        procInfo = {
            description = "30% ranged attack speed",
            stacks = false,
        },
    },
    -- The Beast Within (BM talent CD buff)
    {
        spellID = 34471,
        tags = {C.PROC, C.OFFENSIVE_CD, C.CC_IMMUNITY},
        cooldown = 120,
        duration = 18,
        talent = true,
        procInfo = {
            description = "10% damage, immune to CC",
            stacks = false,
        },
    },
}, "HUNTER")
