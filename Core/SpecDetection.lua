--[[
    LibSpellDB - Spec Detection
    Detects player specialization based on talent distribution
    Works for Classic/Anniversary where there's no formal spec API
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

-------------------------------------------------------------------------------
-- Spec Constants (for type safety and autocomplete in data files)
-------------------------------------------------------------------------------

lib.Specs = {
    -- Warrior
    ARMS = "ARMS",
    FURY = "FURY",
    -- Paladin / Warrior share PROTECTION
    PROTECTION = "PROTECTION",
    -- Paladin
    HOLY = "HOLY",  -- Also used by Priest
    RETRIBUTION = "RETRIBUTION",
    -- Hunter
    BEAST_MASTERY = "BEAST_MASTERY",
    MARKSMANSHIP = "MARKSMANSHIP",
    SURVIVAL = "SURVIVAL",
    -- Rogue
    ASSASSINATION = "ASSASSINATION",
    COMBAT = "COMBAT",
    SUBTLETY = "SUBTLETY",
    -- Priest
    DISCIPLINE = "DISCIPLINE",
    SHADOW = "SHADOW",
    -- Shaman / Druid share some
    ELEMENTAL = "ELEMENTAL",
    ENHANCEMENT = "ENHANCEMENT",
    RESTORATION = "RESTORATION",  -- Shaman and Druid
    -- Mage
    ARCANE = "ARCANE",
    FIRE = "FIRE",
    FROST = "FROST",
    -- Warlock
    AFFLICTION = "AFFLICTION",
    DEMONOLOGY = "DEMONOLOGY",
    DESTRUCTION = "DESTRUCTION",
    -- Druid
    BALANCE = "BALANCE",
    FERAL = "FERAL",
}

-------------------------------------------------------------------------------
-- Class-to-Specs mapping (indexed by talent tree 1, 2, 3)
-------------------------------------------------------------------------------

-- Spec names by class (indexed by talent tree 1, 2, 3)
lib.CLASS_SPECS = {
    WARRIOR = {"ARMS", "FURY", "PROTECTION"},
    PALADIN = {"HOLY", "PROTECTION", "RETRIBUTION"},
    HUNTER = {"BEAST_MASTERY", "MARKSMANSHIP", "SURVIVAL"},
    ROGUE = {"ASSASSINATION", "COMBAT", "SUBTLETY"},
    PRIEST = {"DISCIPLINE", "HOLY", "SHADOW"},
    SHAMAN = {"ELEMENTAL", "ENHANCEMENT", "RESTORATION"},
    MAGE = {"ARCANE", "FIRE", "FROST"},
    WARLOCK = {"AFFLICTION", "DEMONOLOGY", "DESTRUCTION"},
    DRUID = {"BALANCE", "FERAL", "RESTORATION"},
}

-- Display names for specs
lib.SPEC_DISPLAY_NAMES = {
    -- Warrior
    ARMS = "Arms",
    FURY = "Fury",
    PROTECTION = "Protection",
    -- Paladin
    HOLY = "Holy",
    RETRIBUTION = "Retribution",
    -- Hunter
    BEAST_MASTERY = "Beast Mastery",
    MARKSMANSHIP = "Marksmanship",
    SURVIVAL = "Survival",
    -- Rogue
    ASSASSINATION = "Assassination",
    COMBAT = "Combat",
    SUBTLETY = "Subtlety",
    -- Priest
    DISCIPLINE = "Discipline",
    SHADOW = "Shadow",
    -- Shaman
    ELEMENTAL = "Elemental",
    ENHANCEMENT = "Enhancement",
    RESTORATION = "Restoration",
    -- Mage
    ARCANE = "Arcane",
    FIRE = "Fire",
    FROST = "Frost",
    -- Warlock
    AFFLICTION = "Affliction",
    DEMONOLOGY = "Demonology",
    DESTRUCTION = "Destruction",
    -- Druid
    BALANCE = "Balance",
    FERAL = "Feral",
}

-- Cached values
lib.playerSpec = nil
lib.talentPoints = {0, 0, 0}

--[[
    Get talent point distribution across all trees
    Uses GetTalentInfo to iterate through each talent (more reliable than GetTalentTabInfo)
    @return table - {tree1Points, tree2Points, tree3Points}
]]
function lib:GetTalentDistribution()
    local points = {0, 0, 0}
    
    -- Method 1: Iterate through each talent using GetTalentInfo (most reliable)
    -- This works even when GetTalentTabInfo returns 0
    if GetNumTalents and GetTalentInfo then
        for tab = 1, 3 do
            local numTalents = GetNumTalents(tab, false, false) or 0
            for talentIndex = 1, numTalents do
                local name, iconTexture, tier, column, rank = GetTalentInfo(tab, talentIndex, false, false)
                if rank and rank > 0 then
                    points[tab] = points[tab] + rank
                end
            end
        end
    end
    
    -- Method 2: Fallback to GetTalentTabInfo if above didn't work
    if points[1] == 0 and points[2] == 0 and points[3] == 0 then
        if GetTalentTabInfo then
            for tab = 1, 3 do
                local name, iconTexture, pointsSpent = GetTalentTabInfo(tab)
                if pointsSpent ~= nil then
                    points[tab] = tonumber(pointsSpent) or 0
                end
            end
        end
    end
    
    self.talentPoints = points
    return points
end

-- Signature spells that indicate a specific spec (deep talents/trained abilities)
lib.SIGNATURE_SPELLS = {
    WARRIOR = {
        -- Mortal Strike (Arms 31-point talent)
        {spellID = 12294, spec = "ARMS"},
        -- Bloodthirst (Fury 31-point talent)
        {spellID = 23881, spec = "FURY"},
        -- Shield Slam (Protection 31-point talent)
        {spellID = 23922, spec = "PROTECTION"},
    },
    PALADIN = {
        {spellID = 20473, spec = "HOLY"},        -- Holy Shock
        {spellID = 20925, spec = "PROTECTION"},  -- Holy Shield
        {spellID = 20066, spec = "RETRIBUTION"}, -- Repentance
    },
    -- Add other classes as needed
}

--[[
    Detect player's current specialization based on talent distribution
    Falls back to checking signature spells if talent data is unavailable
    @return string - Spec identifier (e.g., "ARMS", "FURY", "PROTECTION")
    @throws error if detection fails
]]
function lib:DetectPlayerSpec()
    -- Get player class
    local _, playerClass = UnitClass("player")
    if not playerClass then
        error("LibSpellDB: Could not determine player class")
    end
    
    local specList = self.CLASS_SPECS[playerClass]
    if not specList then
        error("LibSpellDB: No spec data for class: " .. tostring(playerClass))
    end
    
    -- Get talent distribution
    local points = self:GetTalentDistribution()
    
    -- Find tree with most points
    local maxPoints = 0
    local primaryTree = 1
    
    for i = 1, 3 do
        local p = points[i] or 0
        if p > maxPoints then
            maxPoints = p
            primaryTree = i
        end
    end
    
    -- If talent data is 0/0/0, try signature spell detection
    if maxPoints == 0 then
        local sigSpec = self:DetectSpecBySignatureSpells(playerClass)
        if sigSpec then
            self.playerSpec = sigSpec
            return self.playerSpec, points
        end
        -- No talents and no signature spells - can't determine spec
        -- Return nil to indicate "unknown spec" (triggers permissive filtering)
        self.playerSpec = nil
        return nil, points
    end
    
    -- Determine spec from talent tree
    self.playerSpec = specList[primaryTree]
    
    return self.playerSpec, points
end

--[[
    Fallback spec detection using signature spells
    Checks if player knows spec-defining abilities
    @param class string - Player class
    @return string or nil - Detected spec, or nil if unable to determine
]]
function lib:DetectSpecBySignatureSpells(class)
    local signatures = self.SIGNATURE_SPELLS[class]
    if not signatures then return nil end
    
    for _, sigData in ipairs(signatures) do
        -- Check if player knows this spell
        if IsSpellKnown and IsSpellKnown(sigData.spellID) then
            return sigData.spec
        end
        -- Fallback: check spellbook by name
        local spellName = GetSpellInfo(sigData.spellID)
        if spellName then
            local i = 1
            while true do
                local name = GetSpellBookItemName(i, BOOKTYPE_SPELL)
                if not name then break end
                if name == spellName then
                    return sigData.spec
                end
                i = i + 1
            end
        end
    end
    
    return nil
end

--[[
    Get the currently detected player spec
    @return string or nil - Spec identifier, or nil if not yet detected
]]
function lib:GetPlayerSpec()
    return self.playerSpec
end

--[[
    Get talent points distribution
    @return table - {tree1, tree2, tree3}
]]
function lib:GetTalentPoints()
    return self.talentPoints
end

--[[
    Get display name for a spec
    @param specID string - Internal spec ID (e.g., "ARMS")
    @return string - Display name (e.g., "Arms")
]]
function lib:GetSpecDisplayName(specID)
    return self.SPEC_DISPLAY_NAMES[specID] or specID
end

--[[
    Check if a spell is relevant for the current player (spec + race)
    @param spellID number - Spell ID to check
    @return boolean - true if spell is relevant for current player
]]
function lib:IsSpellRelevantForSpec(spellID)
    local spellData = self:GetSpellInfo(spellID)
    if not spellData then
        return false
    end
    
    -- Check race restriction first (race can be a string or table of strings)
    if spellData.race then
        local _, playerRace = UnitRace("player")
        if type(spellData.race) == "table" then
            local raceMatch = false
            for _, race in ipairs(spellData.race) do
                if playerRace == race then
                    raceMatch = true
                    break
                end
            end
            if not raceMatch then
                return false  -- Wrong race
            end
        elseif playerRace ~= spellData.race then
            return false  -- Wrong race
        end
    end
    
    -- If spell has no spec restriction, it's relevant for all specs
    if not spellData.specs then
        return true
    end
    
    -- Check if current spec is in the spell's specs list
    local currentSpec = self.playerSpec
    if not currentSpec then
        -- Spec not detected (e.g., level 1 with no talents)
        -- Be permissive: show all class spells since player could be any spec
        -- The spell is still filtered by IsSpellKnown, so only learnable spells show
        return true
    end
    
    for _, spec in ipairs(spellData.specs) do
        if spec == currentSpec then
            return true
        end
    end
    
    return false
end

--[[
    Get all spells relevant for the current player spec
    @param class string - Player class (e.g., "WARRIOR")
    @return table - Dictionary of spellID -> spellData
]]
function lib:GetSpellsForCurrentSpec(class)
    local result = {}
    local classSpells = self:GetSpellsByClass(class) or {}
    
    for spellID, spellData in pairs(classSpells) do
        if self:IsSpellRelevantForSpec(spellID) then
            result[spellID] = spellData
        end
    end
    
    -- Also include shared spells (racials, trinkets)
    local sharedSpells = self:GetSpellsByClass("SHARED") or {}
    for spellID, spellData in pairs(sharedSpells) do
        if self:IsSpellRelevantForSpec(spellID) then
            result[spellID] = spellData
        end
    end
    
    return result
end
