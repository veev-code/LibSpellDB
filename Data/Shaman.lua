--[[
    LibSpellDB - Shaman Spells (Anniversary Edition / Classic)
    
    All spells must have explicit specs field listing which specs the ability is relevant for.
    Class-wide abilities should list all specs: {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION}
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
        spellID = 2484,  -- Earthbind Totem
        name = "Earthbind Totem",
        description = "Summons an Earthbind Totem with 5 health at the feet of the caster for 45 sec that slows the movement speed of enemies within 10 yards.",
        tags = {C.CC_SOFT, C.UTILITY, C.TOTEM, C.TOTEM_EARTH},
        cooldown = 15,
        duration = 45,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
        triggersAuras = {
            {
                spellID = 3600,  -- Earthbind (slow effect applied to enemies)
                tags = {C.CC_SOFT},
                type = "DEBUFF",
                onTarget = true,
            },
        },
    },
    {
        spellID = 8056,  -- Frost Shock (slow/CC utility)
        name = "Frost Shock",
        description = "Instantly shocks the target with frost, causing 95 to 101 Frost damage and slowing movement speed by 50%. Lasts 8 sec. Causes a high amount of threat.",
        tags = {C.CC_SOFT},
        cooldown = 6,
        duration = 8,
        ranks = {8056, 8058, 10472, 10473, 25464},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Personal Defensives (Utility row)
    -------------------------------------------------------------------------------
    {
        spellID = 30823,  -- Shamanistic Rage (TBC+)
        name = "Shamanistic Rage",
        description = "Reduces all damage taken by 30% and gives your successful melee attacks a chance to regenerate mana equal to 30% of your attack power. Lasts 15 sec.",
        tags = {C.DEFENSIVE, C.MAJOR, C.RESOURCE, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ENHANCEMENT},
    },

    -------------------------------------------------------------------------------
    -- CC Counter
    -------------------------------------------------------------------------------
    {
        spellID = 8177,  -- Grounding Totem
        name = "Grounding Totem",
        description = "Summons a Grounding Totem with 5 health at the feet of the caster that will redirect one harmful spell cast on a nearby party member to itself, destroying the totem. Will not redirect area of effect spells. Lasts 45 sec.",
        tags = {C.CC_IMMUNITY, C.UTILITY, C.TOTEM, C.TOTEM_AIR},
        cooldown = 15,
        duration = 45,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8143,  -- Tremor Totem
        name = "Tremor Totem",
        description = "Summons a Tremor Totem with 5 health at the feet of the caster that shakes the ground around it, removing Fear, Charm and Sleep effects from party members within 30 yards. Lasts 2 min.",
        tags = {C.CC_BREAK, C.UTILITY, C.TOTEM, C.TOTEM_EARTH},
        cooldown = 0,
        duration = 120,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    {
        spellID = 36936,  -- Totemic Call (destroys all totems, returns partial mana)
        name = "Totemic Call",
        description = "Returns your totems to the earth, giving you 25% of the mana required to cast each totem destroyed by Totemic Call.",
        tags = {C.UTILITY, C.TOTEM},
        cooldown = 0,
        clearsTotems = true,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Enhancement (Priority: SS → ES → FS)
    -------------------------------------------------------------------------------
    {
        spellID = 17364,  -- Stormstrike (use on CD, top priority)
        name = "Stormstrike",
        description = "Instantly attack with both weapons. In addition, the next 2 sources of Nature damage dealt to the target are increased by 20%. Lasts 12 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 10,  -- 10s with talents in TBC
        duration = 12,
        priority = 1,
        talent = true,
        specs = {S.ENHANCEMENT},
        triggersAuras = {
            {
                spellID = 17364,  -- Stormstrike debuff (same ID in TBC)
                tags = {C.DEBUFF, C.DPS},
                type = "DEBUFF",
                onTarget = true,
            },
        },
    },
    {
        spellID = 8042,  -- Earth Shock (interrupt / damage)
        name = "Earth Shock",
        description = "Instantly shocks the target with concussive force, causing 19 to 22 Nature damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 2 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.INTERRUPT, C.PVE_PVP},
        cooldown = 6,
        duration = 2,
        priority = 2,
        ranks = {8042, 8044, 8045, 8046, 10412, 10413, 10414, 25454},
        specs = {S.ENHANCEMENT},
    },

    -------------------------------------------------------------------------------
    -- Offensive Cooldowns (Secondary Row - throughput)
    -------------------------------------------------------------------------------
    {
        spellID = 16166,  -- Elemental Mastery
        name = "Elemental Mastery",
        description = "When activated, this spell gives your next Fire, Frost, or Nature damage spell a 100% critical strike chance and reduces the mana cost by 100%.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.ELEMENTAL},
    },

    -------------------------------------------------------------------------------
    -- Raid Cooldowns
    -------------------------------------------------------------------------------
    {
        spellID = 2825,  -- Bloodlust (Horde)
        name = "Bloodlust",
        description = "Increases melee, ranged, and spell casting speed by 30% for all party members. Lasts 40 sec.",
        tags = {C.DPS, C.MAJOR, C.RAID_DEFENSIVE, C.HAS_BUFF},
        cooldown = 600,
        duration = 40,
        auraTarget = AT.SELF,  -- Buff appears on self, affects raid
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 32182,  -- Heroism (Alliance) - TBC+
        name = "Heroism",
        description = "Increases melee, ranged, and spell haste by 30% for all party and raid members. Lasts 40 sec.Allies receiving this effect will become Exhausted and be unable to benefit from Heroism again for 10 min.",
        tags = {C.DPS, C.MAJOR, C.RAID_DEFENSIVE, C.HAS_BUFF},
        cooldown = 600,
        duration = 40,
        auraTarget = AT.SELF,  -- Buff appears on self, affects raid
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 2894,  -- Fire Elemental Totem
        name = "Fire Elemental Totem",
        description = "Summons an elemental totem that calls forth a greater fire elemental to rain destruction on the caster's enemies. Lasts 2 min.",
        tags = {C.DPS, C.MAJOR, C.PET_SUMMON, C.PET_SUMMON_TEMP, C.TOTEM, C.TOTEM_FIRE},
        cooldown = 1200,
        duration = 120,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 2062,  -- Earth Elemental Totem
        name = "Earth Elemental Totem",
        description = "Summon an elemental totem that calls forth a greater earth elemental to protect the caster and his allies. Lasts 2 min.",
        tags = {C.DEFENSIVE, C.MAJOR, C.PET_SUMMON, C.PET_SUMMON_TEMP, C.TOTEM, C.TOTEM_EARTH, C.TAUNT},
        cooldown = 1200,
        duration = 120,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Restoration (Priority: ES → WS → CH → HW/LHW)
    -------------------------------------------------------------------------------
    {
        spellID = 974,  -- Earth Shield (maintain on tank or self)
        name = "Earth Shield",
        description = "Protects the target with an earthen shield, giving a 30% chance of ignoring spell interruption when damaged and causing attacks to heal the shielded target for 150. This effect can only occur once every few seconds. 6 charges. Lasts 10 min. Earth Shield can only be placed on one target at a time and only one Elemental Shield can be active on a target at a time.",
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_SINGLE, C.HAS_BUFF, C.LONG_BUFF, C.PVE},
        cooldown = 0,
        duration = 600,
        singleTarget = true,
        dispelType = "Magic",
        priority = 1,
        talent = true,
        ranks = {974, 32593, 32594},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
        buffGroup = "SHAMAN_SHIELD",
    },
    {
        spellID = 24398,  -- Water Shield (maintain on self)
        name = "Water Shield",
        description = "The caster is surrounded by 3 globes of water, granting 43 mana per 5 sec. When a spell, melee or ranged attack hits the caster, 182 mana is restored to the caster. This expends one water globe. Only one globe will activate every few seconds. Lasts 10 min. Only one Elemental Shield can be active on the Shaman at any one time.",
        tags = {C.HEAL, C.MAINTENANCE, C.BUFF, C.RESOURCE, C.HAS_BUFF, C.LONG_BUFF, C.PVE_PVP},
        cooldown = 0,
        duration = 600,
        dispelType = nil,  -- Self-only shield, not purgeable
        priority = 2,
        ranks = {24398, 33736},
        auraTarget = AT.SELF,
        specs = {S.RESTORATION},
        buffGroup = "SHAMAN_SHIELD",
    },
    {
        spellID = 1064,  -- Chain Heal (main heal, bounces)
        name = "Chain Heal",
        description = "Heals the friendly target for 332 to 381, then jumps to heal additional nearby targets. If cast on a party member, the heal will only jump to other party members. Each jump reduces the effectiveness of the heal by 50%. Heals 3 total targets.",
        tags = {C.HEAL, C.ROTATIONAL, C.HEAL_AOE, C.FILLER, C.PVE},
        cooldown = 0,
        priority = 3,
        ranks = {1064, 10622, 10623, 25422, 25423},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 331,  -- Healing Wave (big single target)
        name = "Healing Wave",
        description = "Heals a friendly target for 36 to 47.",
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 4,
        ranks = {331, 332, 547, 913, 939, 959, 8005, 10395, 10396, 25357, 25391, 25396},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 8004,  -- Lesser Healing Wave (fast heal)
        name = "Lesser Healing Wave",
        description = "Heals a friendly target for 170 to 195.",
        tags = {C.HEAL, C.FILLER, C.HEAL_SINGLE, C.PVE_PVP},
        cooldown = 0,
        priority = 5,
        ranks = {8004, 8008, 8010, 10466, 10467, 10468, 25420},
        auraTarget = AT.ALLY,  -- Can target other players
        specs = {S.RESTORATION},
    },
    {
        spellID = 16188,  -- Nature's Swiftness (emergency - throughput CD)
        name = "Nature's Swiftness",
        description = "When activated, your next Nature spell with a casting time less than 10 sec. becomes an instant cast spell.",
        tags = {C.HEAL, C.MAJOR, C.HAS_BUFF, C.PVE_PVP},
        cooldown = 180,
        priority = 6,
        talent = true,
        auraTarget = AT.SELF,
        specs = {S.RESTORATION},
    },
    {
        spellID = 16190,  -- Mana Tide Totem (mana CD - throughput via sustain)
        name = "Mana Tide Totem",
        description = "Summons a Mana Tide Totem with 5 health at the feet of the caster for 12 sec that restores 6% of total mana every 3 seconds to group members within 20 yards.",
        tags = {C.HEAL, C.MAJOR, C.RESOURCE, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_WATER, C.PVE},
        cooldown = 300,
        duration = 12,
        priority = 7,
        talent = true,
        auraTarget = AT.NONE,  -- Totem placed at caster location
        specs = {S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Elemental (Priority: ToW → LB → CL)
    -------------------------------------------------------------------------------
    {
        spellID = 30706,  -- Totem of Wrath (maintain)
        name = "Totem of Wrath",
        description = "Summons a Totem of Wrath with 5 health at the feet of the caster. The totem increases the chance to hit and critically strike with spells by 3% for all party members within 20 yards. Lasts 2 min.",
        tags = {C.DPS, C.MAINTENANCE, C.BUFF, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_FIRE, C.PVE},
        cooldown = 0,
        duration = 120,
        priority = 1,
        talent = true,
        appliesBuff = {30708},
        specs = {S.ELEMENTAL},
    },

    -------------------------------------------------------------------------------
    -- Dispels / Purge (spammable, excluded from HUD)
    -------------------------------------------------------------------------------
    {
        spellID = 370,  -- Purge
        name = "Purge",
        description = "Purges the enemy target, removing 1 beneficial magic effect.",
        tags = {C.PURGE, C.DISPEL_MAGIC, C.FILLER},
        cooldown = 0,
        ranks = {370, 8012, 27626},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 526,  -- Cure Poison
        name = "Cure Poison",
        description = "Cures 1 poison effect on the target.",
        tags = {C.DISPEL_POISON, C.FILLER},
        cooldown = 0,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 2870,  -- Cure Disease
        name = "Cure Disease",
        description = "Cures 1 disease on the target.",
        tags = {C.DISPEL_DISEASE, C.FILLER},
        cooldown = 0,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8170,  -- Disease Cleansing Totem
        name = "Disease Cleansing Totem",
        description = "Summons a Disease Cleansing Totem with 5 health at the feet of the caster that attempts to remove 1 disease effect from party members within 20 yards every 5 seconds. Lasts 2 min.",
        tags = {C.DISPEL_DISEASE, C.UTILITY, C.TOTEM, C.TOTEM_WATER, C.FILLER},
        cooldown = 0,
        duration = 120,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8166,  -- Poison Cleansing Totem
        name = "Poison Cleansing Totem",
        description = "Summons a Poison Cleansing Totem with 5 health at the feet of the caster that attempts to remove 1 poison effect from party members within 20 yards every 5 seconds. Lasts 2 min.",
        tags = {C.DISPEL_POISON, C.UTILITY, C.TOTEM, C.TOTEM_WATER, C.FILLER},
        cooldown = 0,
        duration = 120,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Core Rotation - Elemental/Enhancement Damage (Priority: LB → CL → FS/ES)
    -------------------------------------------------------------------------------
    {
        spellID = 403,  -- Lightning Bolt (main nuke)
        name = "Lightning Bolt",
        description = "Casts a bolt of lightning at the target for 15 to 17 Nature damage.",
        tags = {C.DPS, C.FILLER, C.PVE_PVP},
        cooldown = 0,
        priority = 2,
        ranks = {403, 529, 548, 915, 943, 6041, 10391, 10392, 15207, 15208, 25448, 25449},
        specs = {S.ELEMENTAL},
    },
    {
        spellID = 421,  -- Chain Lightning (AoE / cleave - used in rotation when available)
        name = "Chain Lightning",
        description = "Hurls a lightning bolt at the enemy, dealing 200 to 227 Nature damage and then jumping to additional nearby enemies. Each jump reduces the damage by 30%. Affects 3 total targets.",
        tags = {C.DPS, C.ROTATIONAL, C.AOE, C.PVE_PVP},
        cooldown = 6,
        priority = 10,
        ranks = {421, 930, 2860, 10605, 25439, 25442},
        specs = {S.ELEMENTAL},
    },
    {
        spellID = 8050,  -- Flame Shock (maintain DoT)
        name = "Flame Shock",
        description = "Instantly sears the target with fire, causing 25 Fire damage immediately and 28 Fire damage over 12 sec.",
        tags = {C.DPS, C.ROTATIONAL, C.DEBUFF, C.PVE_PVP},
        cooldown = 6,
        duration = 12,
        priority = 4,
        ranks = {8050, 8052, 8053, 10447, 10448, 29228, 25457},
        specs = {S.ELEMENTAL, S.ENHANCEMENT},
    },

    -------------------------------------------------------------------------------
    -- Totems (Fire)
    -------------------------------------------------------------------------------
    {
        spellID = 3599,  -- Searing Totem (utility, not core rotation)
        name = "Searing Totem",
        description = "Summons a Searing Totem with 5 health at your feet for 30 sec that repeatedly attacks an enemy within 20 yards for 9 to 11 Fire damage.",
        tags = {C.UTILITY, C.TOTEM, C.TOTEM_FIRE},
        cooldown = 0,
        duration = 60,
        ranks = {3599, 6363, 6364, 6365, 10437, 10438, 25533},
        rankDurations = {
            [3599] = 30, [6363] = 35, [6364] = 40, [6365] = 45,
            [10437] = 50, [10438] = 55, [25533] = 60,
        },
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8190,  -- Magma Totem
        name = "Magma Totem",
        description = "Summons a Magma Totem with 5 health at the feet of the caster for 20 sec that causes 22 Fire damage to creatures within 8 yards every 2 seconds.",
        tags = {C.DPS, C.AOE, C.TOTEM, C.TOTEM_FIRE},
        cooldown = 0,
        duration = 20,
        ranks = {8190, 10585, 10586, 10587, 25552},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 1535,  -- Fire Nova Totem (AoE damage totem, 15s CD)
        name = "Fire Nova Totem",
        description = "Summons a Fire Nova Totem that has 5 health and lasts 5 sec. Unless it is destroyed within 4 sec., the totem inflicts 53 to 62 fire damage to enemies within 10 yd.",
        tags = {C.DPS, C.AOE, C.MINOR, C.TOTEM, C.TOTEM_FIRE},
        cooldown = 15,
        duration = 5,  -- Explodes after 5 seconds (4 with Improved Fire Totems talent)
        ranks = {1535, 8498, 8499, 11314, 11315, 25546, 25547},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8181,  -- Frost Resistance Totem
        name = "Frost Resistance Totem",
        description = "Summons a Frost Resistance Totem with 5 health at the feet of the caster for 2 min. The totem increases party members' frost resistance by 30, if within 20 yards.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_FIRE},
        cooldown = 0,
        duration = 120,
        ranks = {8181, 10478, 10479, 25560},
        appliesBuff = {8182, 10476, 10477, 25559},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8227,  -- Flametongue Totem
        name = "Flametongue Totem",
        description = "Summons a Flametongue Totem that enchants all party members' main-hand weapons with fire if they are within 20 yards. Each hit causes 6.4 to 19.6 additional Fire damage. Lasts 2 min.",
        tags = {C.BUFF, C.UTILITY, C.TOTEM, C.TOTEM_FIRE},
        cooldown = 0,
        duration = 120,
        ranks = {8227, 8249, 10526, 16387, 25557},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Totems (Air)
    -------------------------------------------------------------------------------
    {
        spellID = 8512,  -- Windfury Totem
        name = "Windfury Totem",
        description = "Summons a Windfury Totem with 5 health at the feet of the caster. The totem enchants all party members main-hand weapons with wind, if they are within 20 yards. Each hit has a 20% chance of granting the attacker 1 extra attack with 122 extra melee attack power. Lasts 2 min.",
        tags = {C.BUFF, C.DPS, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_AIR},
        cooldown = 0,
        duration = 120,
        ranks = {8512, 10613, 10614, 25585, 25587},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8835,  -- Grace of Air Totem
        name = "Grace of Air Totem",
        description = "Summons a Grace of Air Totem with 5 health at the feet of the caster. The totem increases the agility of party members within 20 yards by 43. Lasts 2 min.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_AIR},
        cooldown = 0,
        duration = 120,
        ranks = {8835, 10627, 25359},
        appliesBuff = {8836, 10626, 25360},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 6495,  -- Sentry Totem
        name = "Sentry Totem",
        description = "Summons an immobile Sentry Totem with 100 health at your feet for 5 min that allows vision of nearby area and warns of enemies that attack it. Right-Click on buff to switch back and forth between totem sight and shaman sight.",
        tags = {C.UTILITY, C.TOTEM, C.TOTEM_AIR},
        cooldown = 0,
        duration = 300,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 25908,  -- Tranquil Air Totem
        name = "Tranquil Air Totem",
        description = "Summons a Tranquil Air Totem with 5 health at the feet of the caster. The totem reduces the threat caused by all party members within 20 yards by 20%. Lasts 2 min.",
        tags = {C.BUFF, C.UTILITY, C.TOTEM, C.TOTEM_AIR},
        cooldown = 0,
        duration = 120,
        appliesBuff = {25909},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 10595,  -- Nature Resistance Totem
        name = "Nature Resistance Totem",
        description = "Summons a Nature Resistance Totem with 5 health at the feet of the caster for 2 min. The totem increases party members' nature resistance by 30, if within 20 yards.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_AIR},
        cooldown = 0,
        duration = 120,
        ranks = {10595, 10600, 10601, 25574},
        appliesBuff = {10596, 10598, 10599, 25573},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 3738,  -- Wrath of Air Totem (TBC+)
        name = "Wrath of Air Totem",
        description = "Summons a Wrath of Air Totem with 5 health at the feet of the caster. The totem increases spell damage and healing of party members within 20 yards by 101. Lasts 2 min.",
        tags = {C.BUFF, C.DPS, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_AIR},
        cooldown = 0,
        duration = 120,
        appliesBuff = {2895},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Totems (Water)
    -------------------------------------------------------------------------------
    {
        spellID = 5394,  -- Healing Stream Totem
        name = "Healing Stream Totem",
        description = "Summons a Healing Stream Totem with 5 health at the feet of the caster for 2 min that heals group members within 20 yards for 6 every 2 seconds.",
        tags = {C.HEAL_AOE, C.UTILITY, C.TOTEM, C.TOTEM_WATER},
        cooldown = 0,
        duration = 120,
        ranks = {5394, 6375, 6377, 10462, 10463, 25567},
        appliesBuff = {5672, 6371, 6372, 10460, 10461, 25566},
        auraTarget = AT.NONE,  -- Totem placed at caster location
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 5675,  -- Mana Spring Totem
        name = "Mana Spring Totem",
        description = "Summons a Mana Spring Totem with 5 health at the feet of the caster for 2 min that restores 6 mana every 2 seconds to group members within 20 yards.",
        tags = {C.RESOURCE, C.UTILITY, C.TOTEM, C.TOTEM_WATER},
        cooldown = 0,
        duration = 120,
        ranks = {5675, 10495, 10496, 10497, 25569, 25570},
        appliesBuff = {5677, 10491, 10493, 10494, 25569},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    {
        spellID = 8184,  -- Fire Resistance Totem
        name = "Fire Resistance Totem",
        description = "Summons a Fire Resistance Totem with 5 health at the feet of the caster for 2 min. The totem increases party members' fire resistance by 30, if within 20 yards.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_WATER},
        cooldown = 0,
        duration = 120,
        ranks = {8184, 10537, 10538, 25563},
        appliesBuff = {8185, 10534, 10535, 25562},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Totems (Earth)
    -------------------------------------------------------------------------------
    {
        spellID = 5730,  -- Stoneclaw Totem
        name = "Stoneclaw Totem",
        description = "Summons a Stoneclaw Totem with 50 health at the feet of the caster for 15 sec that taunts creatures within 8 yards to attack it. Enemies attacking the Stoneclaw Totem have a 50% chance to be stunned for 3 sec.",
        tags = {C.UTILITY, C.TAUNT, C.TOTEM, C.TOTEM_EARTH},
        cooldown = 30,
        duration = 15,
        ranks = {5730, 6390, 6391, 6392, 10427, 10428, 25525},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8071,  -- Stoneskin Totem
        name = "Stoneskin Totem",
        description = "Summons a Stoneskin Totem with 5 health at the feet of the caster. The totem protects party members within 20 yards, reducing melee damage taken by 4. Lasts 2 min.",
        tags = {C.BUFF, C.RAID_DEFENSIVE, C.TOTEM, C.TOTEM_EARTH},
        cooldown = 0,
        duration = 120,
        ranks = {8071, 8154, 8155, 10406, 10407, 10408, 25508, 25509},
        appliesBuff = {8072, 8156, 8157, 10403, 10404, 10405, 25506, 25507},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 8075,  -- Strength of Earth Totem
        name = "Strength of Earth Totem",
        description = "Summons a Strength of Earth Totem with 5 health at the feet of the caster. The totem increases the strength of party members within 20 yards by 10. Lasts 2 min.",
        tags = {C.BUFF, C.UTILITY, C.TOTEM, C.TOTEM_EARTH},
        cooldown = 0,
        duration = 120,
        ranks = {8075, 8160, 8161, 10442, 25361, 25528},
        appliesBuff = {8076, 8162, 8163, 10441, 25362, 25527},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

    -------------------------------------------------------------------------------
    -- Long-Duration Buffs (Buff Reminders)
    -------------------------------------------------------------------------------
    {
        spellID = 324,  -- Lightning Shield
        name = "Lightning Shield",
        description = "The caster is surrounded by 3 balls of lightning. When a spell, melee or ranged attack hits the caster, the attacker will be struck for 13 Nature damage. This expends one lightning ball. Only one ball will fire every few seconds. Lasts 10 min. Only one Elemental Shield can be active on the Shaman at any one time.",
        tags = {C.DPS, C.BUFF, C.LONG_BUFF, C.HAS_BUFF},
        cooldown = 0,
        duration = 600,
        dispelType = nil,  -- Self-only shield, not purgeable
        ranks = {324, 325, 905, 945, 8134, 10431, 10432, 25469, 25472},
        auraTarget = AT.SELF,
        specs = {S.ELEMENTAL, S.ENHANCEMENT},
        buffGroup = "SHAMAN_SHIELD",
    },

    -------------------------------------------------------------------------------
    -- Weapon Enchants
    -------------------------------------------------------------------------------
    {
        spellID = 8024,  -- Flametongue Weapon
        name = "Flametongue Weapon",
        description = "Imbue the Shaman's weapon with fire. Each hit causes 6 to 18 additional Fire damage, based on the speed of the weapon. Slower weapons cause more fire damage per swing. Lasts 30 minutes.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8024, 8027, 8030, 16339, 16341, 16342, 25489},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
        buffGroup = "SHAMAN_WEAPON_IMBUES",
        weaponEnchant = true,
    },
    {
        spellID = 8232,  -- Windfury Weapon
        name = "Windfury Weapon",
        description = "Imbue the Shaman's weapon with wind. Each hit has a 20% chance of dealing additional damage equal to two extra attacks with 104 extra attack power. Lasts 30 minutes.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8232, 8235, 10486, 16362, 25505},
        specs = {S.ENHANCEMENT},
        buffGroup = "SHAMAN_WEAPON_IMBUES",
        weaponEnchant = true,
    },
    {
        spellID = 8033,  -- Frostbrand Weapon
        name = "Frostbrand Weapon",
        description = "Imbue the Shaman's weapon with frost. Each hit has a chance of causing 48 additional Frost damage and slowing the target's movement speed by 25% for 8 sec. Lasts 30 minutes.",
        tags = {C.BUFF, C.UTILITY, C.CC_SOFT, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8033, 8038, 10456, 16355, 16356, 25500},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
        buffGroup = "SHAMAN_WEAPON_IMBUES",
        weaponEnchant = true,
    },
    {
        spellID = 8017,  -- Rockbiter Weapon
        name = "Rockbiter Weapon",
        description = "Imbue the Shaman's weapon, increasing its damage per second by 2. Lasts 30 minutes.",
        tags = {C.BUFF, C.UTILITY, C.LONG_BUFF},
        cooldown = 0,
        duration = 1800,
        ranks = {8017, 8018, 8019, 10399, 16314, 16315, 16316, 25479},
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
        buffGroup = "SHAMAN_WEAPON_IMBUES",
        weaponEnchant = true,
    },

    -------------------------------------------------------------------------------
    -- Utility
    -------------------------------------------------------------------------------
    {
        spellID = 20608,  -- Reincarnation
        name = "Reincarnation",
        description = "Allows you to resurrect yourself upon death with 20% health and mana.",
        tags = {C.RESURRECT, C.UTILITY},
        cooldown = 3600,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 546,  -- Water Walking
        name = "Water Walking",
        description = "Allows the friendly target to walk across water for 10 min. Any damage will cancel the effect.",
        tags = {C.UTILITY, C.MOVEMENT, C.OUT_OF_COMBAT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 131,  -- Water Breathing
        name = "Water Breathing",
        description = "Allows the target to breathe underwater for 10 min.",
        tags = {C.UTILITY, C.OUT_OF_COMBAT, C.LONG_BUFF, C.SITUATIONAL},
        cooldown = 0,
        duration = 600,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 2645,  -- Ghost Wolf
        name = "Ghost Wolf",
        description = "Turns the Shaman into a Ghost Wolf, increasing speed by 40%. Only useable outdoors.",
        tags = {C.MOVEMENT, C.MOVEMENT_SPEED, C.SHAPESHIFT},
        cooldown = 0,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },
    {
        spellID = 556,  -- Astral Recall
        name = "Astral Recall",
        description = "Yanks the caster through the twisting nether back to Hearthstone Location. Speak to an Innkeeper in a different place to change your home location.",
        tags = {C.UTILITY},
        cooldown = 900,
        specs = {S.ELEMENTAL, S.ENHANCEMENT, S.RESTORATION},
    },

}, "SHAMAN")
