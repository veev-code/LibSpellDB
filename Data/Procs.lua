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
            lowPriority = true,
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
            lowPriority = true,
        },
    },
    -- Mace Stun Effect (Mace Specialization Arms talent) - stuns target on melee hit with maces
    {
        spellID = 5530,  -- Mace Stun Effect debuff on target
        name = "Mace Stun Effect",
        icon = 133476,  -- Mace Specialization talent icon
        tags = {C.PROC, C.CC_HARD},
        cooldown = 0,
        duration = 3,
        talent = true,
        procInfo = {
            description = "Stuns target for 3 sec on melee hit with maces",
            stacks = false,
            onTarget = true,
        },
    },

    -- Improved Hamstring (Arms talent) - immobilizes target on Hamstring hit
    {
        spellID = 23694,
        name = "Improved Hamstring",
        tags = {C.PROC, C.ROOT},
        cooldown = 0,
        duration = 5,
        talent = true,
        procInfo = {
            description = "Immobilizes target for 5 sec on Hamstring hit",
            stacks = false,
            onTarget = true,
        },
    },

    -- Second Wind (Arms talent) - heals and generates rage when stunned/immobilized
    {
        spellID = 29841,  -- Buff ID (name fallback recommended for Anniversary Edition)
        name = "Second Wind",
        tags = {C.PROC, C.PERSONAL_DEFENSIVE, C.MINOR},
        cooldown = 0,
        duration = 10,
        ranks = {29841, 29842},
        talent = true,
        procInfo = {
            description = "Regenerates health and generates rage when stunned or immobilized",
            stacks = false,
            lowPriority = true,  -- PvP-oriented, disabled by default
        },
    },
    -- Blood Frenzy (Arms talent) - physical damage taken debuff on target from Rend/Deep Wounds
    {
        spellID = 30070,  -- Blood Frenzy debuff on target Rank 2 (name fallback recommended)
        name = "Blood Frenzy",
        ranks = {30069, 30070},
        tags = {C.PROC, C.DEBUFF, C.DPS},
        cooldown = 0,
        duration = 0,  -- Duration tied to Rend/Deep Wounds, no independent timer
        talent = true,
        procInfo = {
            description = "Target takes 4% increased physical damage",
            stacks = false,
            onTarget = true,
            lowPriority = true,  -- Duration tied to parent debuffs, not independently timed
        },
    },
}, "WARRIOR")

-------------------------------------------------------------------------------
-- Shared / Equipment Procs (any class)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Stun proc from Deep Thunder / Stormherald crafted maces (same spell for both weapons)
    -- Chance on hit: Stuns target for 4 sec
    {
        spellID = 34510,  -- Stun debuff on target
        name = "Stun",
        description = "Stuns target for 4 sec (Deep Thunder / Stormherald proc)",
        tags = {C.PROC, C.CC_HARD},
        cooldown = 0,
        duration = 4,
        requiredItemIDs = {28441, 28442},  -- Deep Thunder (28441), Stormherald (28442)
        procInfo = {
            description = "Stuns target for 4 sec (Deep Thunder / Stormherald)",
            stacks = false,
            onTarget = true,
        },
    },
}, "SHARED")

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
    -- Ignite (Fire talent) - DoT on target from Fire crits
    {
        spellID = 12654,  -- Ignite debuff on target
        name = "Ignite",
        tags = {C.PROC, C.DEBUFF, C.DPS},
        cooldown = 0,
        duration = 4,
        talent = true,
        procInfo = {
            description = "Target burns for 40% of Fire crit damage over 4 sec",
            stacks = false,
            onTarget = true,
        },
    },
    -- Winter's Chill (Frost talent) - stacking frost crit debuff on target
    {
        spellID = 12579,  -- Winter's Chill debuff on target (name fallback recommended)
        name = "Winter's Chill",
        tags = {C.PROC, C.DEBUFF, C.DPS},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Target's chance to be crit by Frost spells increased by 2% per stack",
            stacks = 5,
            onTarget = true,
        },
    },
    -- Blazing Speed (Fire talent) - movement speed buff after being hit
    {
        spellID = 31643,  -- Blazing Speed buff on player (name fallback recommended)
        name = "Blazing Speed",
        tags = {C.PROC, C.MOVEMENT_SPEED},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "50% movement speed, removes movement impairing effects",
            stacks = false,
            lowPriority = true,  -- PvP-oriented
        },
    },
    -- Fire Vulnerability (Improved Scorch talent) - stacking fire damage debuff on target
    {
        spellID = 22959,  -- Fire Vulnerability debuff on target (name fallback recommended)
        name = "Fire Vulnerability",
        tags = {C.PROC, C.DEBUFF, C.DPS},
        cooldown = 0,
        duration = 30,
        talent = true,
        procInfo = {
            description = "Target takes 3% increased Fire damage per stack",
            stacks = 5,
            onTarget = true,
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
    -- Shadow Vulnerability (Improved Shadow Bolt) - shadow damage debuff on target after SB crit
    {
        spellID = 17800,  -- Shadow Vulnerability debuff on target (name fallback recommended)
        name = "Shadow Vulnerability",
        tags = {C.PROC, C.DEBUFF, C.DPS},
        cooldown = 0,
        duration = 12,
        talent = true,
        procInfo = {
            description = "Target takes 20% increased Shadow damage, 4 charges",
            stacks = 4,
            onTarget = true,
        },
    },
    -- Shadow Embrace (Affliction talent) - reduces target physical damage dealt
    {
        spellID = 32391,  -- Shadow Embrace debuff on target (name fallback recommended)
        name = "Shadow Embrace",
        tags = {C.PROC, C.DEBUFF, C.DPS},
        cooldown = 0,
        duration = 12,
        talent = true,
        procInfo = {
            description = "Target's physical damage dealt reduced by 5%",
            stacks = false,
            onTarget = true,
            lowPriority = true,
        },
    },
    -- Nether Protection (Destruction talent) - spell immunity after being hit by Shadow/Fire
    {
        spellID = 30300,  -- Nether Protection buff on player (name fallback recommended)
        name = "Nether Protection",
        tags = {C.PROC, C.PERSONAL_DEFENSIVE},
        cooldown = 0,
        duration = 4,
        talent = true,
        procInfo = {
            description = "Immune to Shadow and Fire spells for 4 sec",
            stacks = false,
            lowPriority = true,  -- PvP-oriented
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
    -- Inspiration (Holy talent) - armor buff on heal target after crit heal
    {
        spellID = 15363,
        name = "Inspiration",
        ranks = {14892, 15362, 15363},
        tags = {C.PROC, C.HEAL, C.MINOR},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Target's armor increased by 25% for 15 sec",
            stacks = false,
            onAlly = true,  -- Buff appears on heal target, not on player
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
    -- Blessed Recovery (Holy/Disc talent) - HoT on self after being critted
    {
        spellID = 27813,  -- Blessed Recovery buff (name fallback recommended)
        name = "Blessed Recovery",
        tags = {C.PROC, C.PERSONAL_DEFENSIVE, C.MINOR},
        cooldown = 0,
        duration = 6,
        talent = true,
        procInfo = {
            description = "Heals for 25% of crit damage taken over 6 sec",
            stacks = false,
            lowPriority = true,  -- PvP-oriented
        },
    },
    -- Shadow Weaving (Shadow talent) - stacking shadow damage debuff on target
    {
        spellID = 15258,  -- Shadow Weaving debuff on target (name fallback recommended)
        name = "Shadow Weaving",
        tags = {C.PROC, C.DEBUFF, C.DPS},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Increases shadow damage taken by 2% per stack",
            stacks = 5,
            onTarget = true,
        },
    },
    -- Focused Casting (Martyrdom talent) - pushback immunity after being critted
    {
        spellID = 14743,  -- Focused Casting buff on player (name fallback recommended)
        name = "Focused Casting",
        tags = {C.PROC, C.MINOR},
        cooldown = 0,
        duration = 6,
        talent = true,
        procInfo = {
            description = "Immune to spell pushback, +10% interrupt resist for 6 sec",
            stacks = false,
            lowPriority = true,  -- PvP-oriented
        },
    },
    -- Blackout (Shadow talent) - stun on target from Shadow damage
    {
        spellID = 15269,  -- Blackout stun debuff on target
        name = "Blackout",
        tags = {C.PROC, C.CC_HARD},
        cooldown = 0,
        duration = 3,
        talent = true,
        procInfo = {
            description = "Stuns target for 3 sec from Shadow damage",
            stacks = false,
            onTarget = true,
            lowPriority = true,  -- PvP-oriented, low proc chance
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
        spellID = 30807,  -- Unleashed Rage buff Rank 5 (talent IDs are 30802 etc.)
        name = "Unleashed Rage",
        ranks = {30803, 30804, 30805, 30806, 30807},
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
    -- Ancestral Fortitude (Ancestral Healing proc, Restoration talent) - armor buff on crit heal target
    {
        spellID = 16237,  -- Ancestral Fortitude Rank 3 buff (25% armor)
        name = "Ancestral Fortitude",
        ranks = {16177, 16236, 16237},
        tags = {C.PROC, C.HEAL, C.MINOR},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Target's armor increased by 25% for 15 sec",
            stacks = false,
            onAlly = true,  -- Buff appears on heal target, not on player
        },
    },
    -- Healing Way (Restoration talent) - stacking buff on Healing Wave target
    {
        spellID = 29203,  -- Healing Way buff (all ranks apply same buff ID)
        name = "Healing Way",
        tags = {C.PROC, C.HEAL, C.MINOR},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Healing Wave effectiveness increased by 6% per stack",
            stacks = 3,
            onAlly = true,  -- Buff appears on heal target, not on player
        },
    },
    -- Elemental Devastation (Elemental talent) - crit chance buff on spell crit
    {
        spellID = 29178,  -- Elemental Devastation buff on player (Rank 3)
        name = "Elemental Devastation",
        ranks = {30165, 29177, 29178},
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "Melee crit chance increased by 9% for 10 sec",
            stacks = false,
        },
    },
    -- Focused Casting (Eye of the Storm, Elemental talent) - pushback immunity on crit
    {
        spellID = 29063,  -- Focused Casting buff on player (name fallback recommended)
        name = "Focused Casting",
        tags = {C.PROC, C.MINOR},
        cooldown = 0,
        duration = 6,
        talent = true,
        procInfo = {
            description = "Immune to spell pushback for 6 sec after being critted",
            stacks = false,
            lowPriority = true,
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
    -- Natural Perfection (Balance/Restoration talent) - crit resist after being critted
    {
        spellID = 45283,  -- Natural Perfection buff on player (Rank 3)
        name = "Natural Perfection",
        ranks = {45281, 45282, 45283},
        tags = {C.PROC, C.PERSONAL_DEFENSIVE, C.MINOR},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "Spell crit chance against you reduced by 4% per stack",
            stacks = 3,
            lowPriority = true,
        },
    },
    -- Starfire Stun (Celestial Focus talent) - stun on target from Starfire
    {
        spellID = 16922,  -- Starfire Stun debuff on target
        name = "Starfire Stun",
        tags = {C.PROC, C.CC_HARD},
        cooldown = 0,
        duration = 3,
        talent = true,
        procInfo = {
            description = "Stuns target for 3 sec from Starfire",
            stacks = false,
            onTarget = true,
            lowPriority = true,  -- Low proc chance (5-15%)
        },
    },
}, "DRUID")

-------------------------------------------------------------------------------
-- Rogue Procs
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Remorseless (Remorseless Attacks talent) - crit buff after killing a target
    {
        spellID = 14149,  -- Remorseless buff on player (Rank 2)
        name = "Remorseless",
        ranks = {14143, 14149},
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 20,
        talent = true,
        procInfo = {
            description = "Next Sinister Strike, Backstab, or Ambush has 40% increased crit chance",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Mace Stun Effect (Mace Specialization Combat talent) - stuns target on melee hit with maces
    {
        spellID = 5530,  -- Mace Stun Effect debuff on target (same spell as Warrior)
        name = "Mace Stun Effect",
        icon = 133476,  -- Mace Specialization talent icon
        tags = {C.PROC, C.CC_HARD},
        cooldown = 0,
        duration = 3,
        talent = true,
        procInfo = {
            description = "Stuns target for 3 sec on melee hit with maces",
            stacks = false,
            onTarget = true,
        },
    },
    -- Find Weakness (Subtlety talent) - damage buff after finishing moves
    {
        spellID = 31238,  -- Find Weakness buff Rank 5 on player (name fallback recommended)
        name = "Find Weakness",
        ranks = {31234, 31235, 31236, 31237, 31238},
        tags = {C.PROC, C.DPS},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "Offensive ability damage increased by 10% for 10 sec",
            stacks = false,
        },
    },
    -- Blade Twisting (Combat talent) - daze on target from melee hits
    {
        spellID = 31125,  -- Dazed debuff on target (name fallback recommended)
        name = "Dazed",
        tags = {C.PROC, C.CC_SOFT},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "Target movement speed reduced by 50% for 8 sec",
            stacks = false,
            onTarget = true,
            lowPriority = true,  -- PvP-oriented
        },
    },
}, "ROGUE")

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
    -- Light's Grace (Holy talent) - reduces Holy Light cast time after casting Holy Light
    {
        spellID = 31834,  -- Light's Grace buff on player (name fallback recommended)
        name = "Light's Grace",
        tags = {C.PROC, C.HEAL, C.MINOR},
        cooldown = 0,
        duration = 15,
        talent = true,
        procInfo = {
            description = "Next Holy Light cast time reduced by 0.5 sec",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Redoubt (Protection talent) - block chance buff after being critted
    {
        spellID = 20128,  -- Redoubt buff on player (name fallback recommended)
        name = "Redoubt",
        ranks = {20127, 20130, 20128},
        tags = {C.PROC, C.TANK, C.MINOR},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "Block chance increased by 30% for 10 sec or 5 blocks",
            stacks = false,
        },
    },
    -- Reckoning (Protection talent) - extra attacks after being hit
    {
        spellID = 20178,  -- Reckoning buff on player (name fallback recommended)
        name = "Reckoning",
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "Next 4 weapon swings generate an extra attack",
            stacks = 4,
            lowPriority = true,  -- PvP-oriented, niche
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
    -- Ferocious Inspiration (BM talent) - party damage buff on pet crit
    {
        spellID = 34456,  -- Ferocious Inspiration buff on party members
        name = "Ferocious Inspiration",
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 10,
        talent = true,
        procInfo = {
            description = "All damage increased by 3%",
            stacks = false,
        },
    },
    -- Expose Weakness (Survival talent) - debuff on target after crit with ranged
    {
        spellID = 34501,  -- Expose Weakness debuff on target (name fallback recommended)
        name = "Expose Weakness",
        ranks = {34500, 34502, 34503},
        tags = {C.PROC, C.DPS, C.DEBUFF},
        cooldown = 0,
        duration = 7,
        talent = true,
        procInfo = {
            description = "Target takes additional damage equal to 25% of your Agility",
            stacks = false,
            onTarget = true,
        },
    },
    -- Master Tactician (Survival talent) - crit chance buff on ranged hit
    {
        spellID = 34837,  -- Master Tactician buff on player (name fallback recommended)
        name = "Master Tactician",
        tags = {C.PROC, C.DPS, C.MINOR},
        cooldown = 0,
        duration = 8,
        talent = true,
        procInfo = {
            description = "Ranged crit chance increased by 6%",
            stacks = false,
        },
    },
    -- Rapid Killing (Marksmanship talent) - buff after killing blow
    {
        spellID = 35099,  -- Rapid Killing buff on player (name fallback recommended)
        name = "Rapid Killing",
        ranks = {35098, 35099},
        tags = {C.PROC, C.DPS},
        cooldown = 0,
        duration = 20,
        talent = true,
        procInfo = {
            description = "Next Aimed Shot or Multi-Shot deals additional damage",
            stacks = false,
            consumedOnCast = true,
        },
    },
    -- Improved Wing Clip (Survival talent) - root on target from Wing Clip
    {
        spellID = 19229,  -- Improved Wing Clip root debuff on target
        name = "Improved Wing Clip",
        tags = {C.PROC, C.ROOT},
        cooldown = 0,
        duration = 5,
        talent = true,
        procInfo = {
            description = "Immobilizes target for 5 sec on Wing Clip hit",
            stacks = false,
            onTarget = true,
            lowPriority = true,  -- PvP-oriented, low proc chance
        },
    },
    -- Improved Concussive Shot (Marksmanship talent) - stun on target from Concussive Shot
    {
        spellID = 19410,  -- Improved Concussive Shot stun debuff on target
        name = "Improved Concussive Shot",
        tags = {C.PROC, C.CC_HARD},
        cooldown = 0,
        duration = 3,
        talent = true,
        procInfo = {
            description = "Stuns target for 3 sec on Concussive Shot hit",
            stacks = false,
            onTarget = true,
            lowPriority = true,  -- PvP-oriented, low proc chance
        },
    },
}, "HUNTER")
