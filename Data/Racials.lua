--[[
    LibSpellDB - Racial Abilities & PvP Trinkets (Anniversary Edition / Classic)
    
    Racials are categorized by FUNCTION, not by being racials.
    Each racial has a 'race' field to filter by player's race.
    
    Race IDs: 1=Human, 2=Orc, 3=Dwarf, 4=NightElf, 5=Undead, 6=Tauren, 7=Gnome, 8=Troll
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

local C = lib.Categories

-- Race constants for clarity
local HUMAN = "Human"
local ORC = "Orc"
local DWARF = "Dwarf"
local NIGHTELF = "NightElf"
local UNDEAD = "Scourge"  -- Internal name for Undead
local TAUREN = "Tauren"
local GNOME = "Gnome"
local TROLL = "Troll"

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
        tags = {C.CC_BREAK, C.PERSONAL_DEFENSIVE, C.DISPEL_POISON, C.DISPEL_DISEASE},
        cooldown = 180,
        duration = 8,
        race = DWARF,
    },
})

-------------------------------------------------------------------------------
-- Offensive Cooldowns (will appear in "Major Cooldowns" row)
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Orc - Blood Fury (+AP, healing debuff on self)
    {
        spellID = 20572,
        tags = {C.OFFENSIVE_CD, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        race = ORC,
    },

    -- Troll - Berserking (attack/cast speed)
    {
        spellID = 26297,
        tags = {C.OFFENSIVE_CD, C.HAS_BUFF},
        cooldown = 180,
        duration = 10,
        race = TROLL,
    },
})

-------------------------------------------------------------------------------
-- CC Abilities (will appear in "CC & Interrupts" row)
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
