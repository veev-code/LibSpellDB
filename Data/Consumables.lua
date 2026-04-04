--[[
    LibSpellDB - Consumable Data

    Non-potion combat consumables commonly used in raid/dungeon environments.
    These items have varied item classes (Trade Goods, etc.) and can't be
    reliably discovered via bag scanning with a single filter.

    =========================================================================
    SCOPE
    =========================================================================
    Only SHORT-DURATION or INSTANT combat consumables belong here — items
    you actively use mid-fight and want to track cooldowns/counts for.

    Long-duration pre-pull buffs (elixirs, Zanza, Juju, food buffs, etc.)
    are better handled by buff-tracking addons like NovaConsumesHelper and
    do NOT belong in this file.

    =========================================================================
    SCHEMA
    =========================================================================
    Per entry:
        itemID      (number, required)  Item ID of the consumable
        buffSpellID (number, optional)  Buff spell ID applied by the item
                                        (the BUFF visible in UnitBuff).
                                        Nil for instant effects.

    =========================================================================
    NOTES
    =========================================================================
    - These are NOT potions — they don't share the 2-minute potion cooldown.
    - Each item has its own independent cooldown (if any).
    - Anniversary Edition item IDs may differ from TBC Classic.
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

lib:RegisterConsumables({

    ---------------------------------------------------------------------------
    -- Mana / Health Recovery
    ---------------------------------------------------------------------------

    -- Dark Rune: drains 600-1000 HP, restores 900-1500 mana (no potion CD)
    { itemID = 20520 },

    -- Demonic Rune: drains 600-1000 HP, restores 900-1500 mana (no potion CD)
    { itemID = 12662 },

    -- Thistle Tea: restores 100 energy (Rogue only)
    { itemID = 7676 },

    -- Whipper Root Tuber: restores 700-900 HP
    { itemID = 11951 },

    -- Night Dragon's Breath: restores 394-456 HP and 394-456 mana
    { itemID = 11952 },

    ---------------------------------------------------------------------------
    -- Engineering
    ---------------------------------------------------------------------------

    -- Goblin Sapper Charge: AoE damage (engineering only)
    { itemID = 10646 },

    -- Dense Dynamite
    { itemID = 18641 },

    ---------------------------------------------------------------------------
    -- Short-Duration Combat Buffs
    ---------------------------------------------------------------------------

    -- Juju Flurry: +3% attack speed for 20 sec
    { itemID = 12450, buffSpellID = 16322 },
})
