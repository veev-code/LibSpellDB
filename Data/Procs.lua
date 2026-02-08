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
        name = "Enrage",
        ranks = {12880, 14201, 14202, 14203, 14204},
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 12,
        talent = true,
        procInfo = {
            description = "25% damage increase when enraged",
            stacks = false,
        },
    },
    -- Flurry (Fury talent) - procs on melee crit
    {
        spellID = 12970,
        name = "Flurry",
        ranks = {12966, 12967, 12968, 12969, 12970},
        tags = {C.PROC, C.DPS, C.MINOR},
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
        name = "Deep Wound",
        description = "Your critical strikes cause the opponent to bleed.",
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
    -- Blood Craze (Fury talent) - procs after being the victim of a critical strike
    {
        spellID = 16491,  -- Blood Craze buff (canonical = Rank 3, 3% health over 6s)
        name = "Blood Craze",
        ranks = {16488, 16490, 16491},  -- Rank 1 (1%), Rank 2 (2%), Rank 3 (3%)
        tags = {C.PROC, C.PERSONAL_DEFENSIVE, C.MINOR},
        cooldown = 0,
        duration = 6,
        talent = true,
        procInfo = {
            description = "Regenerates 3% of total health over 6 sec",
            stacks = false,
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
        name = "Blade Flurry",
        description = "Increases your attack speed by 20%. In addition, attacks strike an additional nearby opponent. Lasts 15 sec.",
        tags = {C.PROC, C.DPS, C.MAJOR},
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
        name = "Adrenaline Rush",
        description = "Increases your Energy regeneration rate by 100% for 15 sec.",
        tags = {C.PROC, C.DPS, C.MAJOR},
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
        name = "Clearcasting",
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
        name = "Arcane Power",
        description = "When activated, your spells deal 30% more damage while costing 30% more mana to cast. This effect lasts 15 sec.",
        tags = {C.PROC, C.DPS, C.MAJOR},
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
        name = "Icy Veins",
        description = "Hastens your spellcasting, increasing spell casting speed by 20% and gives you 100% chance to avoid interruption caused by damage while casting. Lasts 20 sec.",
        tags = {C.PROC, C.DPS, C.MAJOR},
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
        name = "Presence of Mind",
        description = "When activated, your next Mage spell with a casting time less than 10 sec becomes an instant cast spell.",
        tags = {C.PROC, C.DPS, C.MINOR},
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
        name = "Shadow Trance",
        tags = {C.PROC, C.DPS, C.MINOR},
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
        name = "Backlash",
        description = "Increases your critical strike chance with spells by an additional 3% and gives you a 25% chance when hit by a physical attack to reduce the cast time of your next Shadow Bolt or Incinerate spell by 100%. This effect lasts 8 sec and will not occur more than once every 8 seconds.",
        tags = {C.PROC, C.DPS, C.MINOR},
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
        name = "Spirit Tap",
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
        name = "Surge of Light",
        description = "Your spell criticals have a 50% chance to cause your next Smite spell to be instant cast, cost no mana but be incapable of a critical hit. This effect lasts 10 sec.",
        tags = {C.PROC, C.HEAL, C.MINOR},
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
        name = "Focused Will",
        tags = {C.PROC, C.PERSONAL_DEFENSIVE},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "4% damage reduction, 10% healing increase per stack",
            stacks = 3,
        },
    },
    -- Clearcasting (Holy Concentration proc) - procs on critical heal
    {
        spellID = 34754,
        name = "Clearcasting",
        tags = {C.PROC, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Next Flash Heal, Binding Heal, or Greater Heal costs no mana",
            stacks = false,
            consumedOnCast = true,
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
        name = "Clearcasting",
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
        name = "Unleashed Rage",
        description = "Causes your critical hits with melee attacks to increase all party members' melee attack power by 2% if within 20 yards of the Shaman. Lasts 10 sec.",
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "Party melee AP increased by 10%",
            stacks = false,
        },
    },
    -- Shamanistic Focus (Enhancement talent) - procs "Focused" on melee crit
    {
        spellID = 43339,  -- "Focused" buff ID
        name = "Focused",
        tags = {C.PROC, C.RESOURCE},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Next Shock spell costs 60% less mana",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Flurry (Enhancement talent) - procs on melee crit
    {
        spellID = 16280,  -- Flurry buff Rank 5 (30% haste)
        name = "Flurry",
        ranks = {16257, 16277, 16278, 16279, 16280},
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "30% attack speed increase",
            stacks = 3,
            consumedOnHit = true,
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
        name = "Clearcasting",
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
        name = "Nature's Grace",
        tags = {C.PROC, C.DPS, C.MINOR},
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
        name = "Vengeance",
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 30,
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
        name = "Quick Shots",
        tags = {C.PROC, C.DPS, C.MINOR},
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
        name = "The Beast Within",
        description = "When your pet is under the effects of Bestial Wrath, you also go into a rage causing 10% additional damage and reducing mana costs of all spells by 20% for 18 sec. While enraged, you do not feel pity or remorse or fear and you cannot be stopped unless killed.",
        tags = {C.PROC, C.DPS, C.MAJOR, C.CC_IMMUNITY},
        cooldown = 120,
        duration = 18,
        talent = true,
        procInfo = {
            description = "10% damage, immune to CC",
            stacks = false,
        },
    },
}, "HUNTER")
