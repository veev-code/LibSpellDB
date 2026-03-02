--[[
    LibSpellDB - Trinket Data

    Trinket proc buff metadata for equipped trinkets.

    =========================================================================
    INCLUSION CRITERIA — What goes in this file:
    =========================================================================
    A trinket needs an entry here ONLY if it has a PASSIVE (equip) proc that
    creates a VISIBLE BUFF on the player (or on a target, via onTarget=true).

    Specifically, a trinket qualifies when ALL of these are true:
      1. It has an "Equip:" proc (not "Use:") — on-use trinkets are
         auto-detected by consumers via GetItemSpell() and need no entry.
      2. The proc creates a visible UnitBuff() / UnitDebuff() aura that can
         be scanned — not just a damage event or mana energize.
      3. The buff provides meaningful tracking value (stat buffs, haste,
         armor, etc. — not damage-only procs with no player buff).

    =========================================================================
    EXCLUSION CRITERIA — What does NOT go in this file:
    =========================================================================
    - On-use-only trinkets (auto-detected via GetItemSpell)
    - Stat-stick trinkets (flat stats, no proc, no on-use)
    - Direct damage procs with no player buff (Romulo's Poison Vial, etc.)
    - Mana energize procs with no visible buff (Mark of Defiance, etc.)
    - Kill-triggered procs (Darkmoon Card: Madness — near-useless on bosses)
    - Death-triggered effects (Darkmoon Card: Twisting Nether)
    - Damage reflect procs with no player buff (Darkmoon Card: Vengeance)

    =========================================================================
    SCHEMA
    =========================================================================
    Per entry:
        itemID      (number, required)  Item ID
        procBuffID  (number, required)  Buff spell ID applied by the proc
                                        IMPORTANT: This is the BUFF that appears
                                        in UnitBuff(), NOT the trigger/hidden spell.
                                        Wowhead item tooltips link to the trigger;
                                        follow the trigger spell page to find the
                                        actual buff spell it applies.
        icd         (number, optional)  Internal cooldown in seconds (0 = no ICD)
        onUseBuffID (number, optional)  Override buff ID for on-use effect
                                        (only needed if GetItemSpell name differs
                                        from the buff name)
        onTarget    (boolean, optional) true if proc buff lands on the heal/attack
                                        target, not on the player (e.g., Fel Reaver's
                                        Piston HoT, Ashtongue Talisman of Zeal)

    =========================================================================
    NOTES
    =========================================================================
    - Anniversary Edition buff spell IDs may differ from TBC Classic.
      Consumers should use name-based fallback via GetCachedBuff().
    - Trigger vs Buff spell IDs: Wowhead item tooltips link to trigger spells
      (hidden passives). The actual buff shown in UnitBuff() has a different ID.
      Always verify by checking the trigger spell's "Effect: Trigger Spell" link.
    - ICD values sourced from Wowhead tooltip "(Xsec cooldown)" and community
      testing. An ICD of 0 means no internal cooldown.
    - Multi-proc trinkets (e.g., Ashtongue Talismans with spec-dependent procs)
      track the primary/most-used buff; alternate buffs noted in comments.
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

lib:RegisterTrinkets({

    -------------------------------------------------------------------------------
    -- Karazhan
    -------------------------------------------------------------------------------

    -- Dragonspine Trophy (Netherspite)
    -- Equip: Your melee and ranged attacks have a chance to increase your haste rating by 325 for 10 sec.
    -- Trigger=34774, Buff=34775 "Haste"
    { itemID = 28830, procBuffID = 34775, icd = 20 },

    -- Eye of Magtheridon (Magtheridon's Lair)
    -- Equip: When one of your spells is resisted, gain +170 spell power for 10 sec.
    -- Trigger=34749, Buff=34747 "Spell Power"
    { itemID = 28789, procBuffID = 34747, icd = 0 },

    -- The Lightning Capacitor (The Curator)
    -- Equip: You gain an Electrical Charge each time you cause a damaging spell critical strike.
    -- At 3 charges, fires a lightning bolt at the target.
    -- Note: Charges-based. procBuffID tracks the charge-stacking buff.
    -- Trigger=37657, Buff=37658 "Lightning Capacitor"
    { itemID = 28785, procBuffID = 37658, icd = 0 },

    -------------------------------------------------------------------------------
    -- Gruul's Lair
    -------------------------------------------------------------------------------

    -- Eye of Gruul (Gruul the Dragonkiller)
    -- Equip: Each healing spell you cast has a 2% chance to make your next heal cost 450 less mana.
    -- Consumed-on-cast proc. Low proc rate serves as effective ICD.
    -- Trigger=37705 "Healing Discount", Buff=37706 "Healing Trance"
    { itemID = 28823, procBuffID = 37706, icd = 0 },

    -------------------------------------------------------------------------------
    -- Heroic Dungeons
    -------------------------------------------------------------------------------

    -- Quagmirran's Eye (Heroic Slave Pens - Quagmirran)
    -- Equip: Your harmful spells have a chance to increase your spell haste rating by 320 for 6 sec.
    -- Trigger=33369, Buff=33370 "Spell Haste"
    { itemID = 27683, procBuffID = 33370, icd = 45 },

    -- Scarab of the Infinite Cycle (Heroic Black Morass - Aeonus)
    -- Equip: Your healing spells have a chance to increase your spell haste rating by 320 for 6 sec.
    -- Same "Spell Haste" buff as Quagmirran's Eye (33370)
    -- Trigger=33953, Buff=33370 "Spell Haste"
    { itemID = 28190, procBuffID = 33370, icd = 45 },

    -- Hourglass of the Unraveller (Black Morass - Temporus)
    -- Equip: Your melee attacks have a chance to increase your attack power by 300 for 10 sec.
    -- Trigger=33648, Buff=33649 "Rage of the Unraveller"
    { itemID = 28034, procBuffID = 33649, icd = 45 },

    -- Shiffar's Nexus-Horn (Arcatraz - Harbinger Skyriss)
    -- Equip: Chance on spell critical hit to increase spell damage and healing by 225 for 10 sec.
    -- Trigger=34320, Buff=34321 "Call of the Nexus"
    { itemID = 28418, procBuffID = 34321, icd = 45 },

    -------------------------------------------------------------------------------
    -- The Botanica
    -------------------------------------------------------------------------------

    -- Bangle of Endless Blessings (Warp Splinter)
    -- Equip: Chance on spell cast to gain 15% mana regeneration while casting for 15 sec.
    -- Note: This trinket ALSO has an on-use effect (+130 Spirit for 20s). The on-use is auto-detected.
    -- Trigger=38334, Buff=38346 "Meditation"
    { itemID = 28370, procBuffID = 38346, icd = 45 },

    -------------------------------------------------------------------------------
    -- Tier 5 (SSC / TK)
    -------------------------------------------------------------------------------

    -- Sextant of Unstable Currents (SSC - Lady Vashj)
    -- Equip: Your spell critical strikes have a chance to increase your spell damage by 190 for 15 sec.
    -- Trigger=38347, Buff=38348 "Unstable Currents"
    { itemID = 30626, procBuffID = 38348, icd = 45 },

    -- Tsunami Talisman (SSC - Leotheras the Blind)
    -- Equip: Chance on melee critical hit to increase your attack power by 340 for 10 sec.
    -- Trigger=42083, Buff=42084 "Fury of the Crashing Waves"
    { itemID = 30627, procBuffID = 42084, icd = 45 },

    -- Fel Reaver's Piston (TK - Void Reaver)
    -- Equip: Your direct healing spells have a chance to place a HoT on your target, healing 500 over 12 sec.
    -- Trigger=38299, Buff=38324 "Regeneration" (applied to heal target, not player)
    { itemID = 30619, procBuffID = 38324, icd = 15, onTarget = true },

    -- Warp-Spring Coil (TK - Void Reaver)
    -- Equip: Special attacks have a chance to give 1000 armor penetration for 15 sec.
    -- Trigger=37173, Buff=37174 "Perceived Weakness"
    { itemID = 30450, procBuffID = 37174, icd = 30 },

    -- Tome of Fiery Redemption (TK - Al'ar, Paladin only)
    -- Equip: Each time you cast a spell, 15% chance to gain 290 spell damage and healing for 15 sec.
    -- Trigger=37197 "Spell Damage", Buff=37198 "Blessing of Righteousness"
    { itemID = 30447, procBuffID = 37198, icd = 45 },

    -- Talon of Al'ar (TK - Al'ar, Hunter only)
    -- Equip: Your Arcane Shot increases damage dealt by all other damaging shots by 40 for 6 sec.
    -- Trigger=37507 "Improved Shots", Buff=37508 "Shot Power"
    { itemID = 30448, procBuffID = 37508, icd = 0 },

    -- Living Root of the Wildheart (SSC - Hydross the Unstable, Druid only)
    -- Equip: Your spells and attacks in each form have a 3% chance to grant a blessing for 15 sec.
    -- Form-specific buffs: Bear=37340 Ursine, Cat=37341 Feline, Tree=37342 Sylvan,
    --   Moonkin=37343 Lunar, Caster=37344 Cenarion. We track caster form (most generic);
    --   all form buffs share the same name pattern and will match via name fallback.
    -- Trigger=37336
    { itemID = 30664, procBuffID = 37344, icd = 0 },

    -------------------------------------------------------------------------------
    -- Tier 6 (Hyjal / Black Temple)
    -------------------------------------------------------------------------------

    -- Madness of the Betrayer (BT - High Nethermancer Zerevor)
    -- Equip: Your melee and ranged attacks have a chance to ignore 300 of your target's armor for 10 sec.
    -- Trigger=40475, Buff=40477 "Forceful Strike"
    { itemID = 32505, procBuffID = 40477, icd = 0 },

    -- Memento of Tyrande (BT - Illidan Stormrage)
    -- Equip: Each time you cast a spell, you have a chance to gain up to 76 mana per 5 for 15 sec.
    -- Trigger=37655, Buff=37656 "Meditation"
    { itemID = 32496, procBuffID = 37656, icd = 50 },

    -------------------------------------------------------------------------------
    -- Sunwell Plateau
    -------------------------------------------------------------------------------

    -- Blackened Naaru Sliver (Felmyst)
    -- Equip: Chance on hit to enter a Battle Trance, granting +44 AP per stack, up to 10 stacks for 20 sec.
    -- Trigger=45355, Buff=45040 "Battle Trance"
    { itemID = 34427, procBuffID = 45040, icd = 45 },

    -------------------------------------------------------------------------------
    -- Magisters' Terrace (Patch 2.4)
    -------------------------------------------------------------------------------

    -- Shard of Contempt (Priestess Delrissa)
    -- Equip: Chance on hit to increase your attack power by 230 for 20 sec.
    -- Trigger=45354, Buff=45053 "Disdain"
    { itemID = 34472, procBuffID = 45053, icd = 45 },

    -- Timbal's Focusing Crystal (Priestess Delrissa)
    -- Equip: Your periodic damage spells have a 10% chance to deal shadow damage to the target.
    -- Note: Damage proc, not a stat buff. procBuffID tracks the triggered damage spell for ICD display.
    -- Trigger=45054, Buff=45055 "Timbal's Focusing Crystal"
    { itemID = 34470, procBuffID = 45055, icd = 15 },

    -- Commendation of Kael'thas (Kael'thas Sunstrider)
    -- Equip: Melee attacks which reduce you below 35% health grant 152 dodge rating for 10 sec.
    -- Trigger=45057, Buff=45058 "Evasive Maneuvers"
    { itemID = 34473, procBuffID = 45058, icd = 30 },

    -------------------------------------------------------------------------------
    -- Darkmoon Faire
    -------------------------------------------------------------------------------

    -- Darkmoon Card: Crusade
    -- Equip: Each melee/ranged attack grants +6 AP (stacking x20) or each spell grants
    -- +8 spell damage (stacking x10) for 10 sec.
    -- Note: Two separate proc buffs. We track the AP version; spell damage version is 39441.
    -- Trigger=39438, Buff=39439 "Aura of the Crusader"
    { itemID = 31856, procBuffID = 39439, icd = 0 },

    -- Darkmoon Card: Wrath (Darkmoon Storms Deck)
    -- Equip: Each non-crit direct damage attack grants +17 crit rating (stacking x20) for 10 sec.
    -- All stacks consumed when you crit. Self-limiting, no ICD.
    -- Trigger=39442, Buff=39443 "Aura of Wrath"
    { itemID = 31857, procBuffID = 39443, icd = 0 },

    -- Darkmoon Card: Blue Dragon (Darkmoon Beasts Deck)
    -- Equip: 2% chance on spellcast to allow 100% mana regen while casting for 15 sec.
    -- Classic-era item but widely used in TBC by healers.
    -- Trigger=23688, Buff=23684 "Aura of the Blue Dragon"
    { itemID = 19288, procBuffID = 23684, icd = 0 },

    -------------------------------------------------------------------------------
    -- Ashtongue Talismans (Black Temple - Ashtongue Deathsworn Exalted)
    -- Class-specific trinkets with ability-triggered procs. Multi-proc trinkets
    -- track the primary buff; spec-dependent procs noted in comments.
    -------------------------------------------------------------------------------

    -- Ashtongue Talisman of Valor (Warrior)
    -- Equip: Mortal Strike, Bloodthirst, Shield Slam have 25% chance to heal 330 and grant +55 STR for 12 sec.
    -- Trigger=40458, Buff=40459 "Fire Blood"
    { itemID = 32485, procBuffID = 40459, icd = 0 },

    -- Ashtongue Talisman of Equilibrium (Druid)
    -- Equip: Mangle=40% +140 STR (40452), Starfire=25% +150 spell dmg (40445), Rejuv=25% +210 healing (40446).
    -- Tracking Feral buff (Blessing of Cenarius); Balance/Resto buffs are 40445/40446.
    -- Trigger=40442, Buff=40452 "Blessing of Cenarius"
    { itemID = 32486, procBuffID = 40452, icd = 0 },

    -- Ashtongue Talisman of Swiftness (Hunter)
    -- Equip: Steady Shot has 15% chance to grant +275 AP for 8 sec.
    -- Trigger=40485, Buff=40487 "Deadly Aim"
    { itemID = 32487, procBuffID = 40487, icd = 0 },

    -- Ashtongue Talisman of Insight (Mage)
    -- Equip: Spell critical strikes have 50% chance to grant +145 spell haste rating for 5 sec.
    -- Trigger=40482, Buff=40483 "Insight of the Ashtongue"
    { itemID = 32488, procBuffID = 40483, icd = 0 },

    -- Ashtongue Talisman of Zeal (Paladin)
    -- Equip: FoL/HL=15% HoT 760/12s on target (40471), Judgements=50% DoT 480/8s on target (40472).
    -- Both procs land on targets, not the player. Tracking healing HoT (Enduring Light).
    -- Trigger=40470, Buff=40471 "Enduring Light" (on heal target)
    { itemID = 32489, procBuffID = 40471, icd = 0, onTarget = true },

    -- Ashtongue Talisman of Acumen (Priest)
    -- Equip: SW:P ticks=10% +220 spell dmg for 10s (40441), Renew ticks=10% +220 healing for 5s (40440).
    -- Tracking Shadow buff (Divine Wrath); Holy buff is 40440 (Divine Blessing).
    -- Trigger=40438, Buff=40441 "Divine Wrath"
    { itemID = 32490, procBuffID = 40441, icd = 0 },

    -- Ashtongue Talisman of Vision (Shaman)
    -- Equip: LHW/LB=mana energize (instant, no buff), Stormstrike=50% +275 AP for 10s.
    -- Only the Enhancement proc (Power Surge) leaves a trackable buff.
    -- Trigger=40463, Buff=40466 "Power Surge"
    { itemID = 32491, procBuffID = 40466, icd = 0 },

    -- Ashtongue Talisman of Lethality (Rogue)
    -- Equip: Finishing moves have 20% chance per combo point to grant +145 crit rating for 10 sec.
    -- Trigger=40460, Buff=40461 "Exploit Weakness"
    { itemID = 32492, procBuffID = 40461, icd = 0 },

    -- Ashtongue Talisman of Shadows (Warlock)
    -- Equip: Corruption ticks have 20% chance to grant +220 spell damage for 5 sec.
    -- Trigger=40478, Buff=40480 "Power of the Ashtongue"
    { itemID = 32493, procBuffID = 40480, icd = 0 },
})
