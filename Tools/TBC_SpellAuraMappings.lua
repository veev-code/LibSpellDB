--[[
    TBC Spell -> Aura Mappings
    
    This file contains known cases where the cast spell ID differs from
    the applied aura spell ID for TBC Classic (build 2.5.5 / 2.4.3).
    
    Sources:
    - LibClassicDurations (https://github.com/rgd87/LibClassicDurations)
    - wago.tools SpellEffect database
    - cmangos/mangos-tbc spell system
    - Manual testing and verification
    
    Format: [castSpellID] = { auraSpellID, "BUFF"/"DEBUFF", "aura name" }
    
    Use this as a reference when adding appliesAura to LibSpellDB.
]]

local TBC_SPELL_AURA_MAPPINGS = {
    
    -- ============================================================
    -- WARRIOR
    -- ============================================================
    
    -- Charge (all ranks) -> Charge Stun
    [100]   = { 7922, "DEBUFF", "Charge Stun" },        -- Charge Rank 1
    [6178]  = { 7922, "DEBUFF", "Charge Stun" },        -- Charge Rank 2
    [11578] = { 7922, "DEBUFF", "Charge Stun" },        -- Charge Rank 3
    
    -- Intercept (all ranks) -> Intercept Stun
    [20252] = { 20615, "DEBUFF", "Intercept Stun" },    -- Intercept Rank 1
    [20616] = { 20615, "DEBUFF", "Intercept Stun" },    -- Intercept Rank 2 (uses same stun)
    [20617] = { 20615, "DEBUFF", "Intercept Stun" },    -- Intercept Rank 3 (uses same stun)
    -- Note: Some sources show 20253/20614/20615 as the stun spell IDs per rank
    
    -- Intimidating Shout -> Fear effect (secondary targets) + Cower (main target)
    [5246] = { 20511, "DEBUFF", "Intimidating Shout (Cower)" }, -- Main target cowers
    -- The fear on secondary targets uses same spell ID 5246
    
    -- Bloodrage -> Bloodrage buff
    [2687] = { 29131, "BUFF", "Bloodrage" },
    
    -- Improved Revenge -> Stun
    -- (proc from Revenge, not the Revenge spell itself)
    -- 12798 is the stun proc
    
    -- Mace Specialization -> Stun
    [5530] = { 5530, "DEBUFF", "Mace Stun" },           -- Same ID, included for completeness
    
    -- ============================================================
    -- DRUID
    -- ============================================================
    
    -- Feral Charge -> Feral Charge Effect (immobilize)
    [16979] = { 45334, "DEBUFF", "Feral Charge Effect" }, -- TBC: uses 45334
    -- Note: Classic uses 19675 for the root effect
    
    -- Nature's Grasp -> Nature's Grasp Root
    -- Cast spell applies a buff on self, which then triggers root on attackers
    [16689] = { 19975, "DEBUFF", "Nature's Grasp (Root)" }, -- Rank 1
    [16810] = { 19975, "DEBUFF", "Nature's Grasp (Root)" }, -- Rank 2
    [16811] = { 19975, "DEBUFF", "Nature's Grasp (Root)" }, -- Rank 3
    [16812] = { 19975, "DEBUFF", "Nature's Grasp (Root)" }, -- Rank 4
    [16813] = { 19975, "DEBUFF", "Nature's Grasp (Root)" }, -- Rank 5
    [17329] = { 19975, "DEBUFF", "Nature's Grasp (Root)" }, -- Rank 6
    
    -- Pounce -> Pounce Bleed (the bleed component has different ID)
    -- Pounce stun uses same ID as cast
    [9005]  = { 9007, "DEBUFF", "Pounce Bleed" },       -- Rank 1
    [9823]  = { 9824, "DEBUFF", "Pounce Bleed" },       -- Rank 2
    [9827]  = { 9826, "DEBUFF", "Pounce Bleed" },       -- Rank 3
    
    -- Improved Starfire -> Stun proc
    -- 16922 is the stun proc from the talent
    
    -- ============================================================
    -- HUNTER
    -- ============================================================
    
    -- Wyvern Sting -> Wyvern Sting DoT (after sleep ends)
    [19386] = { 24131, "DEBUFF", "Wyvern Sting (DoT)" }, -- Rank 1
    [24132] = { 24134, "DEBUFF", "Wyvern Sting (DoT)" }, -- Rank 2
    [24133] = { 24135, "DEBUFF", "Wyvern Sting (DoT)" }, -- Rank 3
    
    -- Intimidation (Beast Mastery talent) -> Intimidation Stun
    [19577] = { 24394, "DEBUFF", "Intimidation" },
    
    -- Scatter Shot -> same ID (included for reference)
    -- [19503] = { 19503, "DEBUFF", "Scatter Shot" },
    
    -- Improved Wing Clip -> Wing Clip Root proc
    -- 19229 is the root proc
    
    -- Entrapment (talent) -> Entrapment Root
    -- 19185 is the root proc from traps
    
    -- Concussive Shot -> Concussive Stun (from Improved Concussive Shot)
    -- 19410 is the stun proc
    
    -- Boar Charge (pet) -> Boar Charge Immobilize
    -- 25999 is the immobilize effect
    
    -- ============================================================
    -- ROGUE
    -- ============================================================
    
    -- Most Rogue abilities use the same spell ID for cast and aura
    -- Exceptions:
    
    -- Improved Kick -> Silence
    -- 18425 is the silence proc from Improved Kick talent
    
    -- ============================================================
    -- MAGE
    -- ============================================================
    
    -- Improved Counterspell -> Silence
    -- 18469 is the silence effect from Improved Counterspell
    
    -- Impact (Fire talent) -> Impact Stun
    -- 12355 is the stun proc
    
    -- Frostbite (Frost talent) -> Frostbite Root
    -- 12494 is the root proc
    
    -- Winter's Chill (talent debuff on target)
    -- 12579 is applied by Frostbolt/Cone of Cold/Frost Nova
    
    -- Fire Vulnerability (from Improved Scorch)
    -- 22959 is the debuff stacking effect
    
    -- Ignite (Fire talent DoT)
    -- 12654 is the DoT proc from crits
    
    -- Improved Blizzard -> Chilled
    [10] = { 12486, "DEBUFF", "Chilled (Imp Blizzard)" }, -- Blizzard -> Imp Blizzard Chilled
    
    -- ============================================================
    -- WARLOCK
    -- ============================================================
    
    -- Shadow Vulnerability (Improved Shadow Bolt)
    -- 17794, 17798, 17797, 17799, 17800 are the debuff ranks
    
    -- Spell Lock (Felhunter) -> Silence
    -- 24259 is the silence effect
    
    -- ============================================================
    -- PRIEST
    -- ============================================================
    
    -- Power Word: Shield -> Weakened Soul
    -- Cast: Various PW:S ranks (17, 592, 600, etc.)
    -- Debuff: 6788 Weakened Soul
    -- Note: Use targetLockoutDebuff in LibSpellDB, not appliesAura
    
    -- Blackout (Shadow talent) -> Blackout Stun
    -- 15269 is the stun proc
    
    -- Shadow Weaving (talent debuff)
    -- 15258 is the debuff applied by shadow spells
    
    -- Touch of Weakness -> Touch of Weakness Effect
    -- Cast triggers a different effect spell
    [2652]  = { 2943, "DEBUFF", "Touch of Weakness" },  -- Rank 1
    [19261] = { 19249, "DEBUFF", "Touch of Weakness" }, -- Rank 2
    [19262] = { 19251, "DEBUFF", "Touch of Weakness" }, -- Rank 3
    [19264] = { 19252, "DEBUFF", "Touch of Weakness" }, -- Rank 4
    [19265] = { 19253, "DEBUFF", "Touch of Weakness" }, -- Rank 5
    [19266] = { 19254, "DEBUFF", "Touch of Weakness" }, -- Rank 6
    [25461] = { 25460, "DEBUFF", "Touch of Weakness" }, -- Rank 7
    
    -- ============================================================
    -- PALADIN
    -- ============================================================
    
    -- Seal of Justice -> Seal of Justice Stun proc
    -- 20170 is the stun proc
    
    -- Vindication (Retribution talent) -> Vindication debuff
    -- 67, 26017, 26018 are the debuff ranks
    
    -- ============================================================
    -- SHAMAN
    -- ============================================================
    
    -- Earthbind Totem -> Earthbind (slow effect)
    [2484] = { 3600, "DEBUFF", "Earthbind" },
    
    -- Grounding Totem -> Grounding Totem Effect (absorb)
    -- 8178 is both the totem summon and the absorb effect
    
}

-- Reverse lookup: auraSpellID -> castSpellID
local AURA_TO_CAST = {}
for castID, data in pairs(TBC_SPELL_AURA_MAPPINGS) do
    local auraID = data[1]
    if not AURA_TO_CAST[auraID] then
        AURA_TO_CAST[auraID] = {}
    end
    table.insert(AURA_TO_CAST[auraID], castID)
end

return {
    SPELL_TO_AURA = TBC_SPELL_AURA_MAPPINGS,
    AURA_TO_SPELL = AURA_TO_CAST,
}
