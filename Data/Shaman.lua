--[[
    LibSpellDB - Shaman Spells (Anniversary Edition / Classic)
    TODO: Populate with full spell list
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

lib:RegisterSpells({
    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 2484,  -- Earthbind Totem
        tags = {C.CC_SOFT, C.UTILITY},
        cooldown = 15,
        duration = 45,
    },
    {
        spellID = 8056,  -- Frost Shock (slow/CC utility)
        tags = {C.CC_SOFT},
        cooldown = 6,
        duration = 8,
        ranks = {8056, 8058, 10472, 10473},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 30823,  -- Shamanistic Rage (TBC+)
        tags = {C.PERSONAL_DEFENSIVE, C.RESOURCE, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- CC Counter
    -------------------------------------------------------------------------------
    {
        spellID = 8177,  -- Grounding Totem
        tags = {C.CC_IMMUNITY, C.UTILITY},
        cooldown = 15,
        duration = 45,
    },
    {
        spellID = 8143,  -- Tremor Totem
        tags = {C.CC_BREAK, C.UTILITY},
        cooldown = 0,
        duration = 120,
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Enhancement (Priority: SS → ES → FS)
    -------------------------------------------------------------------------------
    {
        spellID = 17364,  -- Stormstrike (use on CD, top priority)
        tags = {C.CORE_ROTATION, C.OFFENSIVE_CD_MINOR, C.DEBUFF, C.PVE_PVP},
        cooldown = 10,  -- 10s with talents in TBC
        duration = 12,
        priority = 1,
        talent = true,
        specs = {"ENHANCEMENT"},
        appliesAura = {
            spellID = 17364,  -- Stormstrike debuff (same ID in TBC)
            type = "DEBUFF",
            onTarget = true,
        },
    },
    {
        spellID = 8042,  -- Earth Shock (interrupt / damage)
        tags = {C.INTERRUPT, C.CORE_ROTATION, C.PVE_PVP},
        cooldown = 6,
        duration = 2,
        priority = 2,
        ranks = {8042, 8044, 8045, 8046, 10412, 10413, 10414, 25454},
        specs = {"ENHANCEMENT"},
    },
    {
        spellID = 8056,  -- Frost Shock (kiting / PvP)
        tags = {C.CC_SOFT, C.CORE_ROTATION, C.PVP},
        cooldown = 6,
        duration = 8,
        priority = 3,
        ranks = {8056, 8058, 10472, 10473, 25464},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 16166,  -- Elemental Mastery
        tags = {C.OFFENSIVE_CD, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        talent = true,
        specs = {"ELEMENTAL"},
    },

    -------------------------------------------------------------------------------
    -- Raid Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 2825,  -- Bloodlust (Horde)
        tags = {C.OFFENSIVE_CD, C.RAID_DEFENSIVE, C.HAS_BUFF},
        cooldown = 600,
        duration = 40,
    },
    {
        spellID = 32182,  -- Heroism (Alliance) - TBC+
        tags = {C.OFFENSIVE_CD, C.RAID_DEFENSIVE, C.HAS_BUFF},
        cooldown = 600,
        duration = 40,
    },
    {
        spellID = 2894,  -- Fire Elemental Totem
        tags = {C.OFFENSIVE_CD, C.PET_SUMMON},
        cooldown = 1200,
        duration = 120,
    },
    {
        spellID = 2062,  -- Earth Elemental Totem
        tags = {C.PERSONAL_DEFENSIVE, C.PET_SUMMON, C.TAUNT},
        cooldown = 1200,
        duration = 120,
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Restoration (Priority: ES → WS → CH → HW/LHW)
    -------------------------------------------------------------------------------
    {
        spellID = 32594,  -- Earth Shield (maintain on tank)
        tags = {C.CORE_ROTATION, C.HEAL_SINGLE, C.HAS_BUFF, C.PVE},
        cooldown = 0,
        duration = 600,
        priority = 1,
        talent = true,
        specs = {"RESTORATION"},
    },
    {
        spellID = 33736,  -- Water Shield (maintain on self)
        tags = {C.BUFF, C.RESOURCE, C.HAS_BUFF, C.CORE_ROTATION, C.PVE_PVP},
        cooldown = 0,
        duration = 600,
        priority = 2,
    },
    {
        spellID = 1064,  -- Chain Heal (main heal, bounces)
        tags = {C.HEAL_AOE, C.CORE_ROTATION, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {1064, 10622, 10623, 25422, 25423},
    },
    {
        spellID = 331,  -- Healing Wave (big single target)
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {331, 332, 547, 913, 939, 959, 8005, 10395, 10396, 25357, 25391, 25396},
    },
    {
        spellID = 8004,  -- Lesser Healing Wave (fast heal)
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {8004, 8008, 8010, 10466, 10467, 10468, 25420},
    },
    {
        spellID = 16188,  -- Nature's Swiftness (emergency)
        tags = {C.HEALING_CD, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        priority = 6,
        talent = true,
    },
    {
        spellID = 16190,  -- Mana Tide Totem (mana CD)
        tags = {C.HEALING_CD, C.RESOURCE, C.RAID_DEFENSIVE, C.PVE},
        cooldown = 300,
        duration = 12,
        priority = 7,
        talent = true,
        specs = {"RESTORATION"},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Elemental (Priority: ToW → LB → CL)
    -------------------------------------------------------------------------------
    {
        spellID = 30706,  -- Totem of Wrath (maintain)
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.CORE_ROTATION, C.PVE},
        cooldown = 0,
        duration = 120,
        priority = 1,
        talent = true,
        specs = {"ELEMENTAL"},
    },

    -------------------------------------------------------------------------------
    -- Dispels / Purge (spammable, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 370,  -- Purge
        tags = {C.PURGE, C.DISPEL_MAGIC, C.FILLER},
        cooldown = 0,
        ranks = {370, 8012},
    },
    {
        spellID = 526,  -- Cure Poison
        tags = {C.DISPEL_POISON, C.FILLER},
        cooldown = 0,
    },
    {
        spellID = 2870,  -- Cure Disease
        tags = {C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
    },
    {
        spellID = 8170,  -- Disease Cleansing Totem
        tags = {C.DISPEL_DISEASE, C.UTILITY, C.FILLER},
        cooldown = 0,
        duration = 120,
    },
    {
        spellID = 8166,  -- Poison Cleansing Totem
        tags = {C.DISPEL_POISON, C.UTILITY, C.FILLER},
        cooldown = 0,
        duration = 120,
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Elemental/Enhancement Damage (Priority: LB → CL → FS/ES)
    -------------------------------------------------------------------------------
    {
        spellID = 403,  -- Lightning Bolt (main nuke)
        tags = {C.CORE_ROTATION, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 2,
        ranks = {403, 529, 548, 915, 943, 6041, 10391, 10392, 15207, 15208, 25448, 25449},
        specs = {"ELEMENTAL"},
    },
    {
        spellID = 421,  -- Chain Lightning (AoE / cleave - situational in ST)
        tags = {C.SITUATIONAL, C.PVE_PVP},
        cooldown = 6,
        priority = 10,
        ranks = {421, 930, 2860, 10605, 25439, 25442},
        specs = {"ELEMENTAL"},
    },
    {
        spellID = 8050,  -- Flame Shock (maintain DoT)
        tags = {C.CORE_ROTATION, C.DEBUFF, C.PVE_PVP},
        cooldown = 6,
        duration = 12,
        priority = 4,
        ranks = {8050, 8052, 8053, 10447, 10448, 29228, 25457},
    },

    -------------------------------------------------------------------------------
    -- Totems (Fire)
    -------------------------------------------------------------------------------
    {
        spellID = 3599,  -- Searing Totem (utility, not core rotation)
        tags = {C.UTILITY},
        cooldown = 0,
        duration = 55,
        ranks = {3599, 6363, 6364, 6365, 10437, 10438},
    },
    {
        spellID = 8181,  -- Frost Resistance Totem
        tags = {C.BUFF, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 120,
        ranks = {8181, 10478, 10479},
    },
    {
        spellID = 8227,  -- Flametongue Totem
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 120,
        ranks = {8227, 8249, 10526, 16387},
    },

    -------------------------------------------------------------------------------
    -- Totems (Air)
    -------------------------------------------------------------------------------
    {
        spellID = 8512,  -- Windfury Totem
        tags = {C.BUFF, C.OFFENSIVE_CD_MINOR, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 120,
        ranks = {8512, 10613, 10614},
    },
    {
        spellID = 8835,  -- Grace of Air Totem
        tags = {C.BUFF, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 120,
        ranks = {8835, 10627, 25359},
    },
    {
        spellID = 6495,  -- Sentry Totem
        tags = {C.UTILITY},
        cooldown = 0,
        duration = 300,
    },
    {
        spellID = 8835,  -- Tranquil Air Totem
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 120,
    },

    -------------------------------------------------------------------------------
    -- Totems (Water)
    -------------------------------------------------------------------------------
    {
        spellID = 5394,  -- Healing Stream Totem
        tags = {C.HEAL_AOE, C.UTILITY},
        cooldown = 0,
        duration = 60,
        ranks = {5394, 6375, 6377, 10462, 10463},
    },
    {
        spellID = 5675,  -- Mana Spring Totem
        tags = {C.RESOURCE, C.UTILITY},
        cooldown = 0,
        duration = 60,
        ranks = {5675, 10495, 10496, 10497},
    },

    -------------------------------------------------------------------------------
    -- Totems (Earth)
    -------------------------------------------------------------------------------
    {
        spellID = 5730,  -- Stoneclaw Totem
        tags = {C.UTILITY, C.TAUNT},
        cooldown = 30,
        duration = 15,
        ranks = {5730, 6390, 6391, 6392, 10427, 10428},
    },
    {
        spellID = 8071,  -- Stoneskin Totem
        tags = {C.BUFF, C.RAID_DEFENSIVE},
        cooldown = 0,
        duration = 120,
        ranks = {8071, 8154, 8155, 10406, 10407, 10408},
    },
    {
        spellID = 8075,  -- Strength of Earth Totem
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 120,
        ranks = {8075, 8160, 8161, 10442, 25361},
    },

    -------------------------------------------------------------------------------
    -- Weapon Enchants
    -------------------------------------------------------------------------------
    {
        spellID = 8024,  -- Flametongue Weapon
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8024, 8027, 8030, 16339, 16341, 16342},
    },
    {
        spellID = 8232,  -- Windfury Weapon
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8232, 8235, 10486, 16362},
    },
    {
        spellID = 8033,  -- Frostbrand Weapon
        tags = {C.BUFF, C.UTILITY, C.CC_SOFT, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8033, 8038, 10456, 16355, 16356},
    },
    {
        spellID = 8017,  -- Rockbiter Weapon
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8017, 8018, 8019, 10399, 16314, 16315, 16316},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 20608,  -- Reincarnation
        tags = {C.RESURRECT, C.UTILITY},
        cooldown = 3600,
    },
    {
        spellID = 546,  -- Water Walking
        tags = {C.UTILITY, C.MOVEMENT, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 600,
    },
    {
        spellID = 131,  -- Water Breathing
        tags = {C.UTILITY, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 600,
    },
    {
        spellID = 2645,  -- Ghost Wolf
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.SHAPESHIFT},
        cooldown = 0,
    },
    {
        spellID = 556,  -- Astral Recall
        tags = {C.UTILITY},
        cooldown = 900,
    },

}, "SHAMAN")
