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
local AT = lib.AuraTarget

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
        name = "Escape Artist",
        description = "Escape the effects of any immobilization or movement speed reduction effect.",
        tags = {C.CC_BREAK, C.MOVEMENT},
        cooldown = 105,
        race = GNOME,
    },

    -- Undead - Will of the Forsaken (breaks fear/charm/sleep)
    {
        spellID = 7744,
        name = "Will of the Forsaken",
        description = "Provides immunity to Charm, Fear and Sleep while active. May also be used while already afflicted by Charm, Fear or Sleep. Lasts 5 sec.",
        tags = {C.CC_BREAK, C.CC_IMMUNITY},
        cooldown = 120,
        duration = 5,
        race = UNDEAD,
    },

    -- Dwarf - Stoneform (removes poison/disease/bleed + armor bonus)
    {
        spellID = 20594,
        name = "Stoneform",
        description = "While active, grants immunity to Bleed, Poison, and Disease effects. In addition, Armor increased by 10%. Lasts 8 sec.",
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
        name = "Blood Fury",
        description = "Increases attack power by 6, but reduces healing effects on you by 50%. Lasts 15 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        auraTarget = AT.SELF,
        race = ORC,
    },
    
    -- Orc - Blood Fury (Attack Power + Spell Power version)
    -- Used by: Shamans (Enhancement and Elemental benefit from both)
    {
        spellID = 33697,
        name = "Blood Fury",
        description = "Increases melee attack power by 6 and your damage and healing from spells and effects by up to 5, but reduces healing effects on you by 50%. Lasts 15 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        auraTarget = AT.SELF,
        race = ORC,
    },
    
    -- Orc - Blood Fury (Spell Power version)
    -- Used by: Warlocks, Mages
    {
        spellID = 33702,
        name = "Blood Fury",
        description = "Increases your damage and healing from spells and effects by up to 5, but reduces healing effects on you by 50%. Lasts 15 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 120,
        duration = 15,
        auraTarget = AT.SELF,
        race = ORC,
    },

    -- Troll - Berserking (attack/cast speed)
    {
        spellID = 26297,
        name = "Berserking",
        description = "Increases your attack speed by 10% to 30%. At full health the speed increase is 10% with a greater effect up to 30% if you are badly hurt when you activate Berserking. Lasts 10 sec.",
        tags = {C.DPS, C.MAJOR, C.HAS_BUFF},
        cooldown = 180,
        duration = 10,
        auraTarget = AT.SELF,
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
        name = "War Stomp",
        description = "Stuns up to 5 enemies within 8 yds for 2 sec.",
        tags = {C.CC_HARD},
        cooldown = 120,
        duration = 2,
        race = TAUREN,
    },

    -- Blood Elf - Arcane Torrent (AoE silence + resource restore)
    -- Different spellIDs per class, but all share same base functionality
    {
        spellID = 28730,  -- Mage/Warlock/Priest/Paladin version (restores mana)
        name = "Arcane Torrent",
        description = "Silence all enemies within 8 yards for 2 sec. In addition, you gain 10 Mana for each Mana Tap charge currently affecting you.",
        tags = {C.SILENCE, C.INTERRUPT, C.RESOURCE},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
    {
        spellID = 25046,  -- Rogue version (restores energy)
        name = "Arcane Torrent",
        description = "Silence all enemies within 8 yards for 2 sec. In addition, you gain 10 Energy for each Mana Tap charge currently affecting you.",
        tags = {C.SILENCE, C.INTERRUPT, C.RESOURCE},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
    {
        spellID = 28734,  -- Mana Tap (drains target mana, charges Arcane Torrent)
        name = "Mana Tap",
        description = "Reduces target's mana by 50 and charges you with Arcane energy for 10 min. This effect stacks up to 3 times.",
        tags = {C.UTILITY, C.RESOURCE},
        cooldown = 30,
        duration = 600,
        race = BLOODELF,
    },
    {
        spellID = 28733,  -- Hunter version
        name = "Arcane Torrent",
        tags = {C.SILENCE, C.INTERRUPT, C.RESOURCE},
        cooldown = 120,
        duration = 2,
        race = BLOODELF,
    },
    -- Paladin Arcane Torrent shares spellID 28730 (mana version) above
})

-------------------------------------------------------------------------------
-- Healing Abilities
-------------------------------------------------------------------------------

lib:RegisterSpells({
    -- Draenei - Gift of the Naaru (HoT on self or ally)
    {
        spellID = 28880,
        name = "Gift of the Naaru",
        description = "Heals the target of 50 damage over 15 sec.",
        tags = {C.HEAL, C.HEAL_SINGLE, C.HOT, C.EXTERNAL_DEFENSIVE},
        cooldown = 180,
        duration = 15,
        auraTarget = AT.ALLY,  -- Can target other players
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
        name = "Shadowmeld",
        description = "Activate to slip into the shadows, reducing the chance for enemies to detect your presence. Lasts until cancelled or upon moving. Night Elf Rogues and Druids with Shadowmeld are more difficult to detect while stealthed or prowling.",
        tags = {C.UTILITY, C.STEALTH},
        cooldown = 10,
        race = NIGHTELF,
    },

    -- Human - Perception (stealth detection)
    {
        spellID = 20600,
        name = "Perception",
        description = "Dramatically increases stealth detection for 20 sec.",
        tags = {C.UTILITY},
        cooldown = 180,
        duration = 20,
        race = HUMAN,
    },

    -- Undead - Cannibalize (self heal out of combat)
    {
        spellID = 20577,
        name = "Cannibalize",
        description = "When activated, regenerates 7% of total health every 2 sec for 10 sec. Only works on Humanoid or Undead corpses within 5 yds. Any movement, action, or damage taken while Cannibalizing will cancel the effect.",
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
        name = "PvP Trinket",
        description = "Removes all movement impairing effects and all effects which cause loss of control of your character.",
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
        name = "Immune Fear/Polymorph/Stun",
        description = "Dispels all Fear, Polymorph and Stun effects.",
        tags = {C.CC_BREAK},
        cooldown = 300,
    },
})
