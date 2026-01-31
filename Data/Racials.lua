--[[
    LibSpellDB - Racial Abilities & PvP Trinkets (TBC Anniversary Edition)
    
    Racials are categorized by FUNCTION, not by being racials.
    Each racial has a 'race' field to filter by player's race.
    
    Race constants (from UnitRace API):
    Alliance: Human, Dwarf, NightElf, Gnome, Draenei
    Horde: Orc, Scourge (Undead), Tauren, Troll, BloodElf
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

-- Race constants for clarity (must match UnitRace("player") return values)
local HUMAN = "Human"
local ORC = "Orc"
local DWARF = "Dwarf"
local NIGHTELF = "NightElf"
local UNDEAD = "Scourge"  -- Internal name for Undead
local TAUREN = "Tauren"
local GNOME = "Gnome"
local TROLL = "Troll"
-- TBC Races
local BLOODELF = "BloodElf"
local DRAENEI = "Draenei"

-------------------------------------------------------------------------------
-- CC Breaks (will appear in "CC Breaks" row)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Gnome - Escape Artist (breaks roots/snares)
    {
        spellID = 20589,
        tags = {C.CC_BREAK, C.MOVEMENT},
        cooldown = 60,
        race = GNOME,
    },

    -- Undead - Will of the Forsaken (breaks fear/charm/sleep)
    {
        spellID = 7744,
        tags = {C.CC_BREAK, C.CC_IMMUNITY},
        cooldown = 120,
        duration = 5,
        race = UNDEAD,
    },

    -- Dwarf - Stoneform (removes poison/disease/bleed + armor bonus)
    {
        spellID = 20594,
        tags = {C.CC_BREAK, C.DEFENSIVE, C.MINOR, C.DISPEL_POISON, C.DISPEL_DISEASE},
        cooldown = 180,
        duration = 8,
        race = DWARF,
    },
})

-------------------------------------------------------------------------------
-- Offensive Cooldowns (Secondary Row - throughput)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Orc - Blood Fury (Attack Power version)
    -- Used by: Warriors, Hunters, Rogues
    {
        spellID = 20572,
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        race = ORC,
    },
    
    -- Orc - Blood Fury (Attack Power + Spell Power version)
    -- Used by: Shamans (Enhancement and Elemental benefit from both)
    {
        spellID = 33697,
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        race = ORC,
    },
    
    -- Orc - Blood Fury (Spell Power version)
    -- Used by: Warlocks, Mages
    {
        spellID = 33702,
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        race = ORC,
    },

    -- Troll - Berserking (attack/cast speed)
    {
        spellID = 26297,
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        duration = 10,
        race = TROLL,
    },
})

-------------------------------------------------------------------------------
-- CC Abilities / Interrupts (will appear in Utility row)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Tauren - War Stomp (AoE stun)
    {
        spellID = 20549,
        tags = {C.CC_HARD},
        cooldown = 120,
        duration = 2,
        race = TAUREN,
    },

    -- Blood Elf - Arcane Torrent (AoE silence + resource restore)
    -- Different spellIDs per class, but all share same base functionality
    {
        spellID = 28730,  -- Mage/Warlock/Priest version (restores mana)
        tags = {C.SILENCE, C.INTERRUPT, C.RESOURCE},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
    {
        spellID = 25046,  -- Rogue version (restores energy)
        tags = {C.SILENCE, C.INTERRUPT, C.RESOURCE},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
    {
        spellID = 28734,  -- Warrior version (restores rage... sort of)
        tags = {C.SILENCE, C.INTERRUPT},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
    {
        spellID = 28733,  -- Hunter version
        tags = {C.SILENCE, C.INTERRUPT, C.RESOURCE},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
    {
        spellID = 28732,  -- Paladin version (restores mana)
        tags = {C.SILENCE, C.INTERRUPT, C.RESOURCE},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
})

-------------------------------------------------------------------------------
-- Healing Abilities
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Draenei - Gift of the Naaru (HoT on self or ally)
    {
        spellID = 28880,
        tags = {C.HEAL, C.HEAL_SINGLE, C.HOT, C.EXTERNAL_DEFENSIVE},
        cooldown = 180,
        duration = 15,
        race = DRAENEI,
    },
})

-------------------------------------------------------------------------------
-- Utility / Situational (not tracked by default)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Night Elf - Shadowmeld (stealth, combat drop)
    {
        spellID = 20580,
        tags = {C.UTILITY, C.STEALTH},
        cooldown = 10,
        race = NIGHTELF,
    },

    -- Human - Perception (stealth detection)
    {
        spellID = 20600,
        tags = {C.UTILITY},
        cooldown = 180,
        duration = 20,
        race = HUMAN,
    },

    -- Undead - Cannibalize (self heal out of combat)
    {
        spellID = 20577,
        tags = {C.UTILITY},
        cooldown = 120,
        duration = 10,
        race = UNDEAD,
    },
})

-------------------------------------------------------------------------------
-- PvP Trinkets (no race restriction)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- PvP Trinket (TBC era)
    {
        spellID = 42292,
        tags = {C.CC_BREAK},
        cooldown = 120,
    },

    -- Classic Insignia trinkets
    {
        spellID = 23273,  -- Insignia of the Alliance
        tags = {C.CC_BREAK},
        cooldown = 300,
    },
    {
        spellID = 23276,  -- Insignia of the Horde
        tags = {C.CC_BREAK},
        cooldown = 300,
    },
})
