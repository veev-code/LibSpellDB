--[[
    LibSpellDB - Mage Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.ARCANE, S.FIRE, S.FROST}
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
        spellID = 2139,  -- Counterspell
        name = "Counterspell",
        description = "Counters the enemy's spellcast, preventing any spell from that school of magic from being cast for 8 sec. Generates a high amount of threat.",
        tags = {C.INTERRUPT},
        cooldown = 24,
        duration = 10,  -- Lockout duration
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Crowd Control
    -------------------------------------------------------------------------------
    {
        spellID = 118,  -- Polymorph
        name = "Polymorph",
        description = "Transforms the enemy into a sheep, forcing it to wander around for up to 20 sec. While wandering, the sheep cannot attack or cast spells but will regenerate very quickly. Any damage will transform the target back into its normal form. Only one target can be polymorphed at a time. Only works on Beasts, Humanoids and Critters.",
        tags = {C.CC_HARD, C.DISORIENT, C.FILLER},  -- Spammable CC
        cooldown = 0,
        duration = 50,
        singleTarget = true,
        ranks = {118, 12824, 12825, 12826, 28270, 28271, 28272},
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 122,  -- Frost Nova
        name = "Frost Nova",
        description = "Blasts enemies near the caster for 21 to 24 Frost damage and freezes them in place for up to 8 sec. Damage caused may interrupt the effect.",
        tags = {C.ROOT, C.CC_SOFT},
        cooldown = 25,
        duration = 8,
        ranks = {122, 865, 6131, 10230, 27088},
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives / Immunities (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 45438,  -- Ice Block
        name = "Ice Block",
        description = "You become encased in a block of ice, protecting you from all physical attacks and spells for 10 sec, but during that time you cannot attack, move or cast spells. Also causes Hypothermia, preventing you from recasting Ice Block for 30 sec.",
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 300,
        duration = 10,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.FROST},
    },
    {
        spellID = 45438,  -- Ice Block (learned version in later expansions)
        name = "Ice Block",
        description = "You become encased in a block of ice, protecting you from all physical attacks and spells for 10 sec, but during that time you cannot attack, move or cast spells. Also causes Hypothermia, preventing you from recasting Ice Block for 30 sec.",
        tags = {C.DEFENSIVE, C.MAJOR, C.IMMUNITY, C.HAS_BUFF},
        cooldown = 300,
        duration = 10,
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 11426,  -- Ice Barrier
        name = "Ice Barrier",
        description = "Instantly shields you, absorbing 455 damage. Lasts 1 min. While the shield holds, spells will not be interrupted.",
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 60,
        talent = true,
        ranks = {11426, 13031, 13032, 13033, 27134, 33405},
        auraTarget = AT.SELF,
        specs = {S.FROST},
    },
    {
        spellID = 543,  -- Fire Ward
        name = "Fire Ward",
        description = "Absorbs 165 Fire damage. Lasts 30 sec.",
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {543, 8457, 8458, 10223, 10225, 27128},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 6143,  -- Frost Ward
        name = "Frost Ward",
        description = "Absorbs 165 Frost damage. Lasts 30 sec.",
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 30,
        duration = 30,
        ranks = {6143, 8461, 8462, 10177, 28609, 32796},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 1463,  -- Mana Shield
        name = "Mana Shield",
        description = "Absorbs 120 damage, draining mana instead. Drains 2 mana per damage absorbed. Lasts 1 min.",
        tags = {C.DEFENSIVE, C.MINOR, C.HAS_BUFF},
        cooldown = 0,
        duration = 60,
        ranks = {1463, 8494, 8495, 10191, 10192, 10193, 27131},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 12042,  -- Arcane Power
        name = "Arcane Power",
        description = "When activated, your spells deal 30% more damage while costing 30% more mana to cast. This effect lasts 15 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE},
        cooldown = 180,
        duration = 15,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ARCANE},
    },
    {
        spellID = 12043,  -- Presence of Mind
        name = "Presence of Mind",
        description = "When activated, your next Mage spell with a casting time less than 10 sec becomes an instant cast spell.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ARCANE},
    },
    {
        spellID = 11129,  -- Combustion
        name = "Combustion",
        description = "When activated, this spell causes each of your Fire damage spell hits to increase your critical strike chance with Fire damage spells by 10%. This effect lasts until you have caused 3 critical strikes with Fire spells.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.FIRE},
    },
    {
        spellID = 12472,  -- Icy Veins (TBC)
        name = "Icy Veins",
        description = "Hastens your spellcasting, increasing spell casting speed by 20% and gives you 100% chance to avoid interruption caused by damage while casting. Lasts 20 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE},
        cooldown = 180,
        duration = 20,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.FROST, S.ARCANE, S.FIRE},  -- Used by all specs in TBC
    },
    {
        spellID = 11958,  -- Cold Snap (resets CDs - utility, not pure throughput)
        name = "Cold Snap",
        description = "When activated, this spell finishes the cooldown on all Frost spells you recently cast.",
        tags = {C.DPS, C.MAJOR, C.UTILITY, C.PVE_PVP},
        cooldown = 480,
        talent = true,
        specs = {S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Pet Summons
    -------------------------------------------------------------------------------
    {
        spellID = 31687,  -- Summon Water Elemental
        name = "Summon Water Elemental",
        description = "Summon a Water Elemental to fight for the caster for 45 sec.",
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.PET_SUMMON_TEMP, C.PVE},
        cooldown = 180,
        duration = 45,
        talent = true,
        specs = {S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Fire (Priority: Scorch debuff → Fireball → Fire Blast)
    -------------------------------------------------------------------------------
    {
        spellID = 2948,  -- Scorch (maintain Improved Scorch debuff first)
        name = "Scorch",
        description = "Scorch the enemy for 56 to 69 Fire damage.",
        tags = {C.DPS, C.MAINTENANCE, C.DEBUFF, C.HAS_DEBUFF, C.PVE},
        cooldown = 0,
        priority = 1,
        ranks = {2948, 8444, 8445, 8446, 10205, 10206, 10207, 27073, 27074},
        specs = {S.FIRE},
        -- Improved Scorch talent applies Fire Vulnerability debuff (stacks to 5, +3% fire dmg each)
        triggersAuras = {
            { spellID = 22959, tags = {C.DEBUFF, C.DPS}, type = "DEBUFF", onTarget = true, duration = 30 },
        },
    },
    {
        spellID = 133,  -- Fireball (main nuke - filler, not tracked)
        name = "Fireball",
        description = "Hurls a fiery ball that causes 16 to 25 Fire damage and an additional 2 Fire damage over 4 sec.",
        tags = {C.DPS, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 2,
        ranks = {133, 143, 145, 3140, 8400, 8401, 8402, 10148, 10149, 10150, 10151, 25306, 27070, 38692},
        specs = {S.FIRE},
    },
    {
        spellID = 2136,  -- Fire Blast (instant, use while moving)
        name = "Fire Blast",
        description = "Blasts the enemy for 27 to 35 Fire damage.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE_PVP},
        cooldown = 8,
        priority = 3,
        ranks = {2136, 2137, 2138, 8412, 8413, 10197, 10199, 27078, 27079, 33938},
        specs = {S.FIRE},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Arcane (Priority: Arcane Blast → Frostbolt/Missiles filler)
    -------------------------------------------------------------------------------
    {
        spellID = 30451,  -- Arcane Blast (main nuke, build stacks)
        name = "Arcane Blast",
        description = "Blasts the target with energy, dealing 668 to 772 Arcane damage. Each time you cast Arcane Blast, the casting time is reduced while mana cost is increased. Effect stacks up to 3 times and lasts 8 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.PVE},
        cooldown = 0,
        priority = 1,
        specs = {S.ARCANE},
    },
    {
        spellID = 116,  -- Frostbolt (filler/mana conservation - main for Frost)
        name = "Frostbolt",
        description = "Launches a bolt of frost at the enemy, causing 20 to 22 Frost damage and slowing movement speed by 40% for 5 sec.",
        tags = {C.DPS, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 2,
        ranks = {116, 205, 837, 7322, 8406, 8407, 8408, 10179, 10180, 10181, 25304, 27071, 27072, 38697},
        specs = {S.FROST, S.ARCANE},
    },
    {
        spellID = 5143,  -- Arcane Missiles (Clearcasting proc / filler)
        name = "Arcane Missiles",
        description = "Launches Arcane Missiles at the enemy, causing 26 Arcane damage every 1 sec for 3 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {5143, 5144, 5145, 8416, 8417, 10211, 10212, 25345, 27075, 38699, 38704},
        specs = {S.ARCANE},
    },

    -------------------------------------------------------------------------------
    -- Movement
    -------------------------------------------------------------------------------
    {
        spellID = 1953,  -- Blink
        name = "Blink",
        description = "Teleports the caster 20 yards forward, unless something is in the way. Also frees the caster from stuns and bonds.",
        tags = {C.MOVEMENT, C.MOVEMENT_ESCAPE},
        cooldown = 15,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Resource
    -------------------------------------------------------------------------------
    {
        spellID = 12051,  -- Evocation
        name = "Evocation",
        description = "While channeling this spell, you gain 60% of your total mana over 8 sec.",
        tags = {C.RESOURCE, C.UTILITY},
        cooldown = 480,
        duration = 8,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },

    -------------------------------------------------------------------------------
    -- AoE / Soft CC
    -------------------------------------------------------------------------------
    {
        spellID = 120,  -- Cone of Cold
        name = "Cone of Cold",
        description = "Targets in a cone in front of the caster take 102 to 112 Frost damage and are slowed by 50% for 8 sec.",
        tags = {C.DPS, C.AOE, C.CC_SOFT},
        cooldown = 10,
        duration = 8,
        ranks = {120, 8492, 10159, 10160, 10161, 27087},
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 31661,  -- Dragon's Breath
        name = "Dragon's Breath",
        description = "Targets in a cone in front of the caster take 382 to 442 Fire damage and are Disoriented for 3 sec. Any direct damaging attack will revive targets. Turns off your attack when used.",
        tags = {C.DPS, C.AOE, C.CC_HARD, C.DISORIENT},
        cooldown = 20,
        duration = 3,
        talent = true,
        ranks = {31661, 33041, 33042, 33043},
        specs = {S.FIRE},
    },
    {
        spellID = 2120,  -- Flamestrike
        name = "Flamestrike",
        description = "Calls down a pillar of fire, burning all enemies within the area for 55 to 71 Fire damage and an additional 48 Fire damage over 8 sec.",
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 8,
        ranks = {2120, 2121, 8422, 8423, 10215, 10216, 27086},
        specs = {S.FIRE},
    },
    {
        spellID = 10,  -- Blizzard
        name = "Blizzard",
        description = "Ice shards pelt the target area doing (26 * 8) Frost damage over 8 sec.",
        tags = {C.DPS, C.AOE, C.PVE},
        cooldown = 0,
        duration = 8,
        ranks = {10, 6141, 8427, 10185, 10186, 10187, 27085},
        specs = {S.FROST},
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 130,  -- Slow Fall
        name = "Slow Fall",
        description = "Slows falling speed for 30 sec.",
        tags = {C.UTILITY, C.MOVEMENT, C.OUT_OF_COMBAT},
        cooldown = 0,
        duration = 30,
        specs = {S.ARCANE, S.FIRE, S.FROST},
    },
    {
        spellID = 31589,  -- Slow
        name = "Slow",
        description = "Reduces target's movement speed by 50%, increases the time between ranged attacks by 50% and increases casting time by 50%. Lasts 15 sec. Slow can only affect one target at a time.",
        tags = {C.CC_SOFT, C.UTILITY},
        cooldown = 0,
        duration = 15,
        singleTarget = true,
        talent = true,
        specs = {S.ARCANE},
    },
    {
        spellID = 11113,  -- Blast Wave (AoE, situational)
        name = "Blast Wave",
        description = "A wave of flame radiates outward from the caster, damaging all enemies caught within the blast for 160 to 192 Fire damage, and Dazing them for 6 sec.",
        tags = {C.DPS, C.AOE, C.CC_SOFT, C.KNOCKBACK},
        cooldown = 30,
        talent = true,
        ranks = {11113, 13018, 13019, 13020, 13021, 27133, 33933},
        specs = {S.FIRE},
    },

    -------------------------------------------------------------------------------
    -- Long-Duration Buffs (Buff Reminders)
    -------------------------------------------------------------------------------
    {
        spellID = 1459,  -- Arcane Intellect (single ally intellect buff)
        name = "Arcane Intellect",
        description = "Increases the target's Intellect by 2 for 30 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {1459, 1460, 1461, 10156, 10157, 27126},
        auraTarget = AT.ALLY,
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_INTELLECT",
    },
    {
        spellID = 23028,  -- Arcane Brilliance (raid intellect buff)
        name = "Arcane Brilliance",
        description = "Infuses the target's party with brilliance, increasing their Intellect by 31 for 1 hour.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 3600,
        dispelType = "Magic",
        ranks = {23028, 27127},
        auraTarget = AT.NONE,  -- Raid-wide, no single target
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_INTELLECT",
    },
    {
        spellID = 6117,  -- Mage Armor (magic resistance + mana regen, cannot be dispelled)
        name = "Mage Armor",
        description = "Increases your resistance to all magic by 5 and allows 30% of your mana regeneration to continue while casting. Only one type of Armor spell can be active on the Mage at any time. Lasts 30 min.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = nil,  -- Mage Armor specifically cannot be dispelled
        ranks = {6117, 22782, 22783, 27125},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_ARMOR",
    },
    {
        spellID = 7302,  -- Ice Armor (frost resistance + melee slow)
        name = "Ice Armor",
        description = "Increases Armor by 290 and frost resistance by 6. If an enemy strikes the caster, they may have their movement slowed by 30% and the time between their attacks increased by 25% for 5 sec. Only one type of Armor spell can be active on the Mage at any time. Lasts 30 min.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {7302, 7320, 10219, 10220, 27124},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_ARMOR",
    },
    {
        spellID = 30482,  -- Molten Armor (crit + fire damage on hit, TBC)
        name = "Molten Armor",
        description = "Causes 75 Fire damage when hit, increases your chance to critically hit with spells by 3%, and reduces the chance you are critically hit by 5%. Only one type of Armor spell can be active on the Mage at any time. Lasts 30 min.",
        tags = {C.BUFF, C.DPS, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {30482},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_ARMOR",
    },
    {
        spellID = 168,  -- Frost Armor (pre-Ice Armor, low level)
        name = "Frost Armor",
        description = "Increases Armor by 30. If an enemy strikes the caster, they may have their movement slowed by 30% and the time between their attacks increased by 25% for 5 sec. Only one type of Armor spell can be active on the Mage at any time. Lasts 30 min.",
        tags = {C.BUFF, C.DEFENSIVE, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        dispelType = "Magic",
        ranks = {168, 7300, 7301},
        auraTarget = AT.SELF,
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_ARMOR",
    },
    {
        spellID = 1008,  -- Amplify Magic (increase healing/magic damage taken)
        name = "Amplify Magic",
        description = "Amplifies magic used against the targeted party member, increasing damage taken from spells by up to 15 and healing spells by up to 30. Lasts 10 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {1008, 8455, 10169, 10170, 27130, 33946},
        auraTarget = AT.ALLY,
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_MAGIC_MODIFIER",
    },
    {
        spellID = 604,  -- Dampen Magic (reduce healing/magic damage taken)
        name = "Dampen Magic",
        description = "Dampens magic used against the targeted party member, decreasing damage taken from spells by up to 10 and healing spells by up to 20. Lasts 10 min.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        dispelType = "Magic",
        ranks = {604, 8450, 8451, 10173, 10174, 33944},
        auraTarget = AT.ALLY,
        specs = {S.ARCANE, S.FIRE, S.FROST},
        buffGroup = "MAGE_MAGIC_MODIFIER",
    },

}, "MAGE")
