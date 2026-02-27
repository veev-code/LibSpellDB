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

-------------------------------------------------------------------------------
-- Leatherworking Drums
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Drums of Battle — Increases melee and spell haste by 80 for all party members. Lasts 30 sec.
    {
        spellID = 35476,
        name = "Drums of Battle",
        description = "The leatherworker plays drums, increasing melee and spell haste rating by 80 for all party members. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL},
        cooldown = 120,
        duration = 30,
    },
    -- Drums of War — Increases attack power by 60 and spell power by 30 for all party members. Lasts 30 sec.
    {
        spellID = 35475,
        name = "Drums of War",
        description = "The leatherworker plays drums, increasing attack power by 60 and spell damage and healing by 30 for all party members. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL},
        cooldown = 120,
        duration = 30,
    },
    -- Drums of Speed — Increases movement speed by 15% for all party members. Lasts 30 sec.
    {
        spellID = 35477,
        name = "Drums of Speed",
        description = "The leatherworker plays drums, increasing movement speed by 15% for all party members. Lasts 30 sec.",
        tags = {C.MOVEMENT_SPEED, C.HAS_BUFF, C.MINOR_EXTERNAL},
        cooldown = 120,
        duration = 30,
    },
    -- Greater Drums of Battle
    {
        spellID = 351355,
        name = "Greater Drums of Battle",
        description = "The leatherworker plays drums, increasing melee and spell haste rating by 80 for all party and raid members within 40 yards. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL},
        cooldown = 120,
        duration = 30,
    },
    -- Greater Drums of War
    {
        spellID = 351360,
        name = "Greater Drums of War",
        description = "The leatherworker plays drums, increasing attack power by 60 and spell damage and healing by 30 for all party and raid members within 40 yards. Lasts 30 sec.",
        tags = {C.DPS, C.HAS_BUFF, C.MINOR_EXTERNAL},
        cooldown = 120,
        duration = 30,
    },
    -- Greater Drums of Speed
    {
        spellID = 351359,
        name = "Greater Drums of Speed",
        description = "The leatherworker plays drums, increasing movement speed by 15% for all party and raid members within 40 yards. Lasts 30 sec.",
        tags = {C.MOVEMENT_SPEED, C.HAS_BUFF, C.MINOR_EXTERNAL},
        cooldown = 120,
        duration = 30,
    },
}, "SHARED")
