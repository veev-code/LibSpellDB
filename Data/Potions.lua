--[[
    LibSpellDB - Potion Data

    Combat potion metadata for the potion tracker.

    =========================================================================
    INCLUSION CRITERIA — What goes in this file:
    =========================================================================
    Potions commonly used in raid/dungeon environments. This serves as a
    fallback list for consumers when the potion is not currently in the
    player's bags but may still be worth configuring.

    =========================================================================
    SCHEMA
    =========================================================================
    Per entry:
        itemID      (number, required)  Item ID of the potion
        buffSpellID (number, optional)  Buff spell ID applied by the potion
                                        (the BUFF visible in UnitBuff, not the
                                        "Use:" trigger spell). Nil for instant
                                        effects (healing/mana potions) that
                                        don't leave a buff.

    =========================================================================
    NOTES
    =========================================================================
    - All combat potions share a 2-minute cooldown in Classic/Anniversary.
    - Healing and mana potions are instant effects with no persistent buff.
    - Protection potions apply an absorb buff.
    - Offensive potions (Destruction, Haste) apply a short stat buff.
    - Anniversary Edition buff spell IDs may differ from TBC Classic.
      Consumers should use name-based fallback via GetCachedBuff().
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

lib:RegisterPotions({

    ---------------------------------------------------------------------------
    -- Healing Potions (instant effect, no buff)
    ---------------------------------------------------------------------------

    { itemID = 3928 },    -- Superior Healing Potion
    { itemID = 13446 },   -- Major Healing Potion
    { itemID = 18839 },   -- Combat Healing Potion
    { itemID = 22829 },   -- Super Healing Potion

    ---------------------------------------------------------------------------
    -- Mana Potions (instant effect, no buff)
    ---------------------------------------------------------------------------

    { itemID = 13443 },   -- Superior Mana Potion
    { itemID = 13444 },   -- Major Mana Potion
    { itemID = 18841 },   -- Combat Mana Potion
    { itemID = 22832 },   -- Super Mana Potion

    ---------------------------------------------------------------------------
    -- Rejuvenation (instant health + mana, no buff)
    ---------------------------------------------------------------------------

    { itemID = 18253 },   -- Major Rejuvenation Potion
    { itemID = 22850 },   -- Super Rejuvenation Potion

    ---------------------------------------------------------------------------
    -- Combat / Offensive (apply short stat buff)
    ---------------------------------------------------------------------------

    -- Destruction Potion: +120 spell power, +2% spell crit for 15 sec
    { itemID = 22839, buffSpellID = 28508 },

    -- Haste Potion: +400 haste rating for 15 sec
    { itemID = 22838, buffSpellID = 28507 },

    -- Insane Strength Potion: +120 strength, -75 defense rating for 15 sec
    { itemID = 22828, buffSpellID = 28494 },

    -- Heroic Potion: +70 strength, +700 temporary health for 15 sec
    { itemID = 22837, buffSpellID = 28506 },

    ---------------------------------------------------------------------------
    -- Warrior
    ---------------------------------------------------------------------------

    -- Mighty Rage Potion: +60 rage, +60 strength for 20 sec
    { itemID = 13442, buffSpellID = 17528 },

    ---------------------------------------------------------------------------
    -- Defensive / Utility (apply buff)
    ---------------------------------------------------------------------------

    -- Free Action Potion: immune to stun/movement impairing for 30 sec
    { itemID = 5634,  buffSpellID = 6615 },

    -- Living Action Potion: immune to stun/movement impairing + breaks existing for 5 sec
    { itemID = 20008, buffSpellID = 24364 },

    -- Limited Invulnerability Potion: immune to physical attacks for 6 sec
    { itemID = 3387,  buffSpellID = 3169 },

    -- Purification Potion: removes 1 curse, disease, and poison
    { itemID = 13462 },

    -- Greater Stoneshield Potion: +2000 armor for 2 min
    { itemID = 13455, buffSpellID = 17540 },

    -- Ironshield Potion: +2500 armor for 2 min
    { itemID = 22849, buffSpellID = 28515 },

    -- Flask of Petrification: invulnerable for 1 min (can't act)
    { itemID = 13506, buffSpellID = 17624 },

    ---------------------------------------------------------------------------
    -- Protection Potions (absorb buff)
    ---------------------------------------------------------------------------

    -- Greater Fire Protection Potion
    { itemID = 13457, buffSpellID = 17543 },

    -- Greater Frost Protection Potion
    { itemID = 13456, buffSpellID = 17544 },

    -- Greater Nature Protection Potion
    { itemID = 13458, buffSpellID = 17546 },

    -- Greater Arcane Protection Potion
    { itemID = 13461, buffSpellID = 17549 },

    -- Greater Shadow Protection Potion
    { itemID = 13459, buffSpellID = 17548 },

    -- Greater Holy Protection Potion
    { itemID = 13460, buffSpellID = 17545 },

    ---------------------------------------------------------------------------
    -- Major Protection Potions (TBC)
    ---------------------------------------------------------------------------

    -- Major Fire Protection Potion
    { itemID = 22841, buffSpellID = 28511 },

    -- Major Frost Protection Potion
    { itemID = 22842, buffSpellID = 28512 },

    -- Major Nature Protection Potion
    { itemID = 22844, buffSpellID = 28513 },

    -- Major Arcane Protection Potion
    { itemID = 22845, buffSpellID = 28536 },

    -- Major Shadow Protection Potion
    { itemID = 22846, buffSpellID = 28537 },

    -- Major Holy Protection Potion
    { itemID = 22847, buffSpellID = 28510 },
})
