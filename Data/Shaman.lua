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
    -- Interrupts
    -------------------------------------------------------------------------------
    {
        spellID = 8042,  -- Earth Shock
        tags = {C.INTERRUPT, C.CORE_ROTATION},
        cooldown = 6,
        duration = 2,  -- Interrupt lockout
        ranks = {8042, 8044, 8045, 8046, 10412, 10413, 10414},
    },

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
        spellID = 8056,  -- Frost Shock
        tags = {C.CC_SOFT, C.CORE_ROTATION},
        cooldown = 6,
        duration = 8,
        ranks = {8056, 8058, 10472, 10473},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives
    -------------------------------------------------------------------------------
    {
        spellID = 30823,  -- Shamanistic Rage (TBC+)
        tags = {C.PERSONAL_DEFENSIVE, C.RESOURCE, C.TRACK_BUFF},
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
    -- Offensive Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 16166,  -- Elemental Mastery
        tags = {C.OFFENSIVE_CD, C.TRACK_BUFF},
        cooldown = 180,
        talent = true,
    },
    {
        spellID = 17364,  -- Stormstrike
        tags = {C.CORE_ROTATION, C.OFFENSIVE_CD_MINOR, C.DEBUFF},
        cooldown = 20,
        duration = 12,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Raid Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 2825,  -- Bloodlust (Horde)
        tags = {C.OFFENSIVE_CD, C.RAID_DEFENSIVE, C.TRACK_BUFF},
        cooldown = 600,
        duration = 40,
    },
    {
        spellID = 32182,  -- Heroism (Alliance) - TBC+
        tags = {C.OFFENSIVE_CD, C.RAID_DEFENSIVE, C.TRACK_BUFF},
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
    -- Healing Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 16188,  -- Nature's Swiftness
        tags = {C.HEALING_CD, C.TRACK_BUFF},
        cooldown = 180,
        talent = true,
    },
    {
        spellID = 16190,  -- Mana Tide Totem
        tags = {C.HEALING_CD, C.RESOURCE, C.RAID_DEFENSIVE},
        cooldown = 300,
        duration = 12,
        talent = true,
    },

    -------------------------------------------------------------------------------
    -- Heals
    -------------------------------------------------------------------------------
    {
        spellID = 331,  -- Healing Wave
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {331, 332, 547, 913, 939, 959, 8005, 10395, 10396, 25357},
    },
    {
        spellID = 8004,  -- Lesser Healing Wave
        tags = {C.HEAL_SINGLE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {8004, 8008, 8010, 10466, 10467, 10468},
    },
    {
        spellID = 1064,  -- Chain Heal
        tags = {C.HEAL_AOE, C.CORE_ROTATION},
        cooldown = 0,
        ranks = {1064, 10622, 10623},
    },

    -------------------------------------------------------------------------------
    -- Dispels / Purge
    -------------------------------------------------------------------------------
    {
        spellID = 370,  -- Purge
        tags = {C.PURGE, C.DISPEL_MAGIC},
        cooldown = 0,
        ranks = {370, 8012},
    },
    {
        spellID = 526,  -- Cure Poison
        tags = {C.DISPEL_POISON},
        cooldown = 0,
    },
    {
        spellID = 2870,  -- Cure Disease
        tags = {C.DISPEL_DISEASE},
        cooldown = 0,
    },
    {
        spellID = 8170,  -- Disease Cleansing Totem
        tags = {C.DISPEL_DISEASE, C.UTILITY},
        cooldown = 0,
        duration = 120,
    },
    {
        spellID = 8166,  -- Poison Cleansing Totem
        tags = {C.DISPEL_POISON, C.UTILITY},
        cooldown = 0,
        duration = 120,
    },

    -------------------------------------------------------------------------------
    -- Core Rotation / Damage
    -------------------------------------------------------------------------------
    {
        spellID = 403,  -- Lightning Bolt
        tags = {C.CORE_ROTATION, C.FILLER},
        cooldown = 0,
        ranks = {403, 529, 548, 915, 943, 6041, 10391, 10392, 15207, 15208},
    },
    {
        spellID = 421,  -- Chain Lightning
        tags = {C.CORE_ROTATION},
        cooldown = 6,
        ranks = {421, 930, 2860, 10605},
    },
    {
        spellID = 8050,  -- Flame Shock
        tags = {C.CORE_ROTATION, C.DEBUFF},
        cooldown = 6,
        duration = 12,
        ranks = {8050, 8052, 8053, 10447, 10448, 29228},
    },

    -------------------------------------------------------------------------------
    -- Totems (Fire)
    -------------------------------------------------------------------------------
    {
        spellID = 3599,  -- Searing Totem
        tags = {C.CORE_ROTATION, C.UTILITY},
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
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 1800,
        ranks = {8024, 8027, 8030, 16339, 16341, 16342},
    },
    {
        spellID = 8232,  -- Windfury Weapon
        tags = {C.BUFF, C.UTILITY},
        cooldown = 0,
        duration = 1800,
        ranks = {8232, 8235, 10486, 16362},
    },
    {
        spellID = 8033,  -- Frostbrand Weapon
        tags = {C.BUFF, C.UTILITY, C.CC_SOFT},
        cooldown = 0,
        duration = 1800,
        ranks = {8033, 8038, 10456, 16355, 16356},
    },
    {
        spellID = 8017,  -- Rockbiter Weapon
        tags = {C.BUFF, C.UTILITY},
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
        tags = {C.UTILITY, C.MOVEMENT},
        cooldown = 0,
        duration = 600,
    },
    {
        spellID = 131,  -- Water Breathing
        tags = {C.UTILITY},
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
