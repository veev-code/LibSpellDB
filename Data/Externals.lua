--[[
    LibSpellDB - External Buff Data

    Cross-class item-based effects that any player can receive.
    These are important buffs from consumables and crafted items
    worth tracking during combat.

    Note: Drum buff IDs may not match the casting spell ID.
    Use name-based fallback via GetCachedBuff(unit, spellID, spellName).
]]

local MAJOR, MINOR = "LibSpellDB-1.0", 1
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories
local AT = lib.AuraTarget

-------------------------------------------------------------------------------
-- Leatherworking Drums
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Drums of Battle — Increases melee and spell haste by 80 for all party members. Lasts 30 sec.
    {
        spellID = 35476,
        name = "Drums of Battle",
        description = "The leatherworker plays drums, increasing melee and spell haste rating by 80 for all party members. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL, C.DRUMS},
        cooldown = 120,
        duration = 30,
        auraTarget = AT.SELF,
    },
    -- Drums of War — Increases attack power by 60 and spell power by 30 for all party members. Lasts 30 sec.
    {
        spellID = 35475,
        name = "Drums of War",
        description = "The leatherworker plays drums, increasing attack power by 60 and spell damage and healing by 30 for all party members. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL, C.DRUMS},
        cooldown = 120,
        duration = 30,
        auraTarget = AT.SELF,
    },
    -- Drums of Speed — Increases movement speed by 15% for all party members. Lasts 30 sec.
    {
        spellID = 35477,
        name = "Drums of Speed",
        description = "The leatherworker plays drums, increasing movement speed by 15% for all party members. Lasts 30 sec.",
        tags = {C.MOVEMENT_SPEED, C.HAS_BUFF, C.MINOR_EXTERNAL, C.DRUMS},
        cooldown = 120,
        duration = 30,
        auraTarget = AT.SELF,
    },
    -- Greater Drums of Battle
    {
        spellID = 351355,
        name = "Greater Drums of Battle",
        description = "The leatherworker plays drums, increasing melee and spell haste rating by 80 for all party and raid members within 40 yards. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL, C.DRUMS},
        cooldown = 120,
        duration = 30,
        auraTarget = AT.SELF,
    },
    -- Greater Drums of War
    {
        spellID = 351360,
        name = "Greater Drums of War",
        description = "The leatherworker plays drums, increasing attack power by 60 and spell damage and healing by 30 for all party and raid members within 40 yards. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL, C.DRUMS},
        cooldown = 120,
        duration = 30,
        auraTarget = AT.SELF,
    },
    -- Greater Drums of Speed
    {
        spellID = 351359,
        name = "Greater Drums of Speed",
        description = "The leatherworker plays drums, increasing movement speed by 15% for all party and raid members within 40 yards. Lasts 30 sec.",
        tags = {C.MOVEMENT_SPEED, C.HAS_BUFF, C.MINOR_EXTERNAL, C.DRUMS},
        cooldown = 120,
        duration = 30,
        auraTarget = AT.SELF,
    },
}, "SHARED")

-------------------------------------------------------------------------------
-- PvP Powerups (Battleground / Arena pickups)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Berserking — Battleground berserking powerup (increases damage dealt, reduces armor)
    {
        spellID = 24378,
        name = "Berserking",
        description = "Increases damage dealt by 30%, but increases damage taken by 10%. Obtained from battleground powerup.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL, C.PVP_POWERUP},
        duration = 30,
        auraTarget = AT.SELF,
    },
    -- Restoration — Battleground restoration powerup (restores health, mana, and energy)
    {
        spellID = 24379,
        name = "Restoration",
        description = "Restores health, mana, and energy over time. Obtained from battleground powerup.",
        tags = {C.HEAL, C.HAS_BUFF, C.MINOR_EXTERNAL, C.PVP_POWERUP},
        duration = 10,
        auraTarget = AT.SELF,
    },
    -- Speed — Battleground speed powerup (increases movement speed)
    {
        spellID = 23978,
        name = "Speed",
        description = "Increases movement speed by 100%. Obtained from battleground powerup.",
        tags = {C.MOVEMENT_SPEED, C.HAS_BUFF, C.MINOR_EXTERNAL, C.PVP_POWERUP},
        duration = 10,
        auraTarget = AT.SELF,
    },
    -- Shadow Sight — Arena shadow sight powerup (reveals stealthed and invisible enemies)
    {
        spellID = 34709,
        name = "Shadow Sight",
        description = "Reveals stealthed and invisible enemies within range, but increases damage taken by 5%. Obtained from arena powerup.",
        tags = {C.UTILITY, C.HAS_BUFF, C.MINOR_EXTERNAL, C.PVP_POWERUP},
        duration = 15,
        auraTarget = AT.SELF,
    },
}, "SHARED")
