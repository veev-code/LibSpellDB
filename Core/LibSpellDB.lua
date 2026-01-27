--[[
    LibSpellDB - Core Library
    A shared spell database for WoW addons with taggable categories

    Usage:
        local LibSpellDB = LibStub("LibSpellDB-1.0")

        -- Get all interrupt spells
        local interrupts = LibSpellDB:GetSpellsByTag("INTERRUPT")

        -- Get all warrior spells
        local warriorSpells = LibSpellDB:GetSpellsByClass("WARRIOR")

        -- Check if a spell has a specific tag
        if LibSpellDB:HasTag(6552, "INTERRUPT") then ... end
]]

local MAJOR, MINOR = "LibSpellDB-1.0", 1
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

-------------------------------------------------------------------------------
-- Library Data Structures
-------------------------------------------------------------------------------

-- Main spell database: spellID -> spellData
lib.spells = lib.spells or {}

-- Index tables for fast lookups
lib.spellsByClass = lib.spellsByClass or {}
lib.spellsByTag = lib.spellsByTag or {}
lib.spellIDToTags = lib.spellIDToTags or {}

-- Rank mappings: any rank spellID -> canonical spellID
lib.rankToCanonical = lib.rankToCanonical or {}

-- Game version detection
lib.gameVersion = lib.gameVersion or "unknown"

-- Debug mode (set to true to see invalid spell warnings)
lib.debugMode = false

-- Track invalid spells to avoid repeat warnings
lib.invalidSpellsLogged = lib.invalidSpellsLogged or {}

-------------------------------------------------------------------------------
-- Version Detection
-------------------------------------------------------------------------------

local function DetectGameVersion()
    local _, _, _, tocVersion = GetBuildInfo()

    if tocVersion >= 110000 then
        return "retail"
    elseif tocVersion >= 40000 and tocVersion < 50000 then
        return "cata"
    elseif tocVersion >= 30000 and tocVersion < 40000 then
        return "wrath"
    elseif tocVersion >= 20000 and tocVersion < 30000 then
        return "tbc"
    elseif tocVersion >= 11500 and tocVersion < 20000 then
        -- Anniversary Edition uses 115xx interface numbers
        return "anniversary"
    elseif tocVersion >= 11400 and tocVersion < 11500 then
        return "vanilla"
    else
        return "unknown"
    end
end

lib.gameVersion = DetectGameVersion()

-------------------------------------------------------------------------------
-- Spell Registration
-------------------------------------------------------------------------------

--[[
    Register a spell in the database

    @param spellData (table) - Spell definition table:
        {
            spellID = 12345,                    -- Required: Primary spell ID
            class = "WARRIOR",                  -- Required: Class token
            tags = {"INTERRUPT", "CC_HARD"},    -- Required: Array of category tags
            name = "Spell Name",                -- Optional: Override name (auto-resolved if nil)
            icon = 12345,                       -- Optional: Override icon (auto-resolved if nil)
            cooldown = 10,                      -- Optional: Base cooldown in seconds
            duration = 5,                       -- Optional: Buff/effect duration
            charges = 2,                        -- Optional: Number of charges
            spec = {1, 2},                      -- Optional: Spec IDs that have this spell
            talent = true,                      -- Optional: Requires talent
            ranks = {100, 101, 102},            -- Optional: All rank spell IDs
            buff = 12345,                       -- Optional: Buff ID to track (if different from spellID)
            debuff = 12345,                     -- Optional: Debuff ID to track
            modifiers = {},                     -- Optional: Talent modifiers
        }
]]
function lib:RegisterSpell(spellData)
    assert(spellData.spellID, "LibSpellDB: spellID is required")
    assert(spellData.tags and #spellData.tags > 0, "LibSpellDB: tags array is required")
    
    -- Default to "SHARED" if no class specified (racials, trinkets, etc.)
    if not spellData.class then
        spellData.class = "SHARED"
    end

    local spellID = spellData.spellID

    -- Validate spell exists in game
    local spellName = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(spellID)
        or GetSpellInfo and GetSpellInfo(spellID)

    if not spellName then
        -- Spell doesn't exist in this game version, log warning and skip
        if not self.invalidSpellsLogged then
            self.invalidSpellsLogged = {}
        end
        if not self.invalidSpellsLogged[spellID] then
            self.invalidSpellsLogged[spellID] = true
            -- Only print in debug mode or first load
            if self.debugMode then
                print("|cffff9900LibSpellDB:|r Invalid spell ID " .. spellID .. " (" .. (spellData.class or "unknown") .. ") - does not exist in this game version")
            end
        end
        return false
    end

    -- Auto-resolve name if not provided
    if not spellData.name then
        spellData.name = spellName
    end

    -- Auto-resolve icon if not provided
    if not spellData.icon then
        if C_Spell and C_Spell.GetSpellTexture then
            spellData.icon = select(2, C_Spell.GetSpellTexture(spellID)) or C_Spell.GetSpellTexture(spellID)
        elseif GetSpellInfo then
            spellData.icon = select(3, GetSpellInfo(spellID))
        end
    end

    -- Store in main database
    self.spells[spellID] = spellData

    -- Index by class
    local class = spellData.class
    self.spellsByClass[class] = self.spellsByClass[class] or {}
    self.spellsByClass[class][spellID] = spellData

    -- Index by tags
    self.spellIDToTags[spellID] = {}
    for _, tag in ipairs(spellData.tags) do
        self.spellsByTag[tag] = self.spellsByTag[tag] or {}
        self.spellsByTag[tag][spellID] = spellData
        self.spellIDToTags[spellID][tag] = true
    end

    -- Handle spell ranks
    if spellData.ranks then
        for _, rankID in ipairs(spellData.ranks) do
            self.rankToCanonical[rankID] = spellID
        end
    end
    self.rankToCanonical[spellID] = spellID

    return true
end

--[[
    Register multiple spells at once

    @param spellList (table) - Array of spell data tables
    @param defaultClass (string) - Optional default class for all spells
]]
function lib:RegisterSpells(spellList, defaultClass)
    local registered = 0
    for _, spellData in ipairs(spellList) do
        if defaultClass and not spellData.class then
            spellData.class = defaultClass
        end
        if self:RegisterSpell(spellData) then
            registered = registered + 1
        end
    end
    return registered
end

-------------------------------------------------------------------------------
-- Query API
-------------------------------------------------------------------------------

--[[
    Get spell data by ID

    @param spellID (number) - Spell ID (any rank)
    @return (table or nil) - Spell data or nil if not found
]]
function lib:GetSpellInfo(spellID)
    -- First try direct lookup
    local spell = self.spells[spellID]
    if spell then return spell end

    -- Try canonical lookup for spell ranks
    local canonicalID = self.rankToCanonical[spellID]
    if canonicalID then
        return self.spells[canonicalID]
    end

    return nil
end

--[[
    Get all spells for a class

    @param class (string) - Class token (e.g., "WARRIOR")
    @return (table) - Dictionary of spellID -> spellData
]]
function lib:GetSpellsByClass(class)
    return self.spellsByClass[class] or {}
end

--[[
    Get all spells with a specific tag

    @param tag (string) - Category tag (e.g., "INTERRUPT")
    @return (table) - Dictionary of spellID -> spellData
]]
function lib:GetSpellsByTag(tag)
    return self.spellsByTag[tag] or {}
end

--[[
    Get all spells matching ANY of the provided tags (union)

    @param tags (table) - Array of tags
    @return (table) - Dictionary of spellID -> spellData
]]
function lib:GetSpellsByTags(tags)
    local result = {}
    for _, tag in ipairs(tags) do
        local spells = self.spellsByTag[tag]
        if spells then
            for spellID, spellData in pairs(spells) do
                result[spellID] = spellData
            end
        end
    end
    return result
end

--[[
    Get all spells matching ALL of the provided tags (intersection)

    @param tags (table) - Array of tags
    @return (table) - Dictionary of spellID -> spellData
]]
function lib:GetSpellsByAllTags(tags)
    if #tags == 0 then return {} end

    local result = {}

    -- Start with first tag's spells
    local firstTagSpells = self.spellsByTag[tags[1]]
    if not firstTagSpells then return {} end

    for spellID, spellData in pairs(firstTagSpells) do
        local hasAllTags = true
        for i = 2, #tags do
            if not self.spellIDToTags[spellID][tags[i]] then
                hasAllTags = false
                break
            end
        end
        if hasAllTags then
            result[spellID] = spellData
        end
    end

    return result
end

--[[
    Get spells by class AND tag

    @param class (string) - Class token
    @param tag (string) - Category tag
    @return (table) - Dictionary of spellID -> spellData
]]
function lib:GetSpellsByClassAndTag(class, tag)
    local result = {}
    local classSpells = self.spellsByClass[class]
    if not classSpells then return result end

    for spellID, spellData in pairs(classSpells) do
        if self.spellIDToTags[spellID] and self.spellIDToTags[spellID][tag] then
            result[spellID] = spellData
        end
    end

    return result
end

--[[
    Check if a spell has a specific tag

    @param spellID (number) - Spell ID
    @param tag (string) - Category tag
    @return (boolean)
]]
function lib:HasTag(spellID, tag)
    local canonicalID = self.rankToCanonical[spellID] or spellID
    local tags = self.spellIDToTags[canonicalID]
    return tags and tags[tag] or false
end

--[[
    Get all tags for a spell

    @param spellID (number) - Spell ID
    @return (table) - Dictionary of tag -> true
]]
function lib:GetTagsForSpell(spellID)
    local canonicalID = self.rankToCanonical[spellID] or spellID
    return self.spellIDToTags[canonicalID] or {}
end

--[[
    Get all registered spells

    @return (table) - Dictionary of spellID -> spellData
]]
function lib:GetAllSpells()
    return self.spells
end

--[[
    Get the canonical spell ID for any rank

    @param spellID (number) - Any rank's spell ID
    @return (number or nil) - Canonical spell ID
]]
function lib:GetCanonicalSpellID(spellID)
    return self.rankToCanonical[spellID]
end

-------------------------------------------------------------------------------
-- Iteration Helpers
-------------------------------------------------------------------------------

--[[
    Iterate over spells with a filter function

    @param filterFn (function) - function(spellID, spellData) returns boolean
    @return (function) - Iterator function
]]
function lib:IterateSpells(filterFn)
    local spells = self.spells
    local spellID, spellData

    return function()
        repeat
            spellID, spellData = next(spells, spellID)
            if spellID and (not filterFn or filterFn(spellID, spellData)) then
                return spellID, spellData
            end
        until not spellID
    end
end

--[[
    Get a sorted array of spells by priority

    @param spells (table) - Dictionary of spellID -> spellData
    @param priorityFn (function) - Optional custom priority function(spellData) returns number
    @return (table) - Array of spellData sorted by priority (highest first)
]]
function lib:GetSortedSpells(spells, priorityFn)
    local sorted = {}
    for spellID, spellData in pairs(spells) do
        table.insert(sorted, spellData)
    end

    if priorityFn then
        table.sort(sorted, function(a, b)
            return priorityFn(a) > priorityFn(b)
        end)
    else
        -- Default: sort by highest priority tag
        table.sort(sorted, function(a, b)
            local aPriority = 0
            local bPriority = 0
            for tag in pairs(self.spellIDToTags[a.spellID] or {}) do
                local tagPriority = self:GetCategoryPriority(tag)
                if tagPriority > aPriority then aPriority = tagPriority end
            end
            for tag in pairs(self.spellIDToTags[b.spellID] or {}) do
                local tagPriority = self:GetCategoryPriority(tag)
                if tagPriority > bPriority then bPriority = tagPriority end
            end
            return aPriority > bPriority
        end)
    end

    return sorted
end

-------------------------------------------------------------------------------
-- Utility
-------------------------------------------------------------------------------

function lib:GetGameVersion()
    return self.gameVersion
end

function lib:GetSpellCount()
    local count = 0
    for _ in pairs(self.spells) do
        count = count + 1
    end
    return count
end

function lib:GetClassSpellCount(class)
    local classSpells = self.spellsByClass[class]
    if not classSpells then return 0 end

    local count = 0
    for _ in pairs(classSpells) do
        count = count + 1
    end
    return count
end

-------------------------------------------------------------------------------
-- Debug
-------------------------------------------------------------------------------

function lib:DumpSpellsByClass(class)
    local spells = self:GetSpellsByClass(class)
    print(("LibSpellDB: %s spells (%d total)"):format(class, self:GetClassSpellCount(class)))
    for spellID, data in pairs(spells) do
        local tags = table.concat(data.tags, ", ")
        print(("  [%d] %s - %s"):format(spellID, data.name or "Unknown", tags))
    end
end

function lib:DumpSpellsByTag(tag)
    local spells = self:GetSpellsByTag(tag)
    local count = 0
    for _ in pairs(spells) do count = count + 1 end

    print(("LibSpellDB: %s spells (%d total)"):format(tag, count))
    for spellID, data in pairs(spells) do
        print(("  [%d] %s (%s)"):format(spellID, data.name or "Unknown", data.class))
    end
end

function lib:SetDebugMode(enabled)
    self.debugMode = enabled
    print("|cff00ff00LibSpellDB:|r Debug mode " .. (enabled and "enabled" or "disabled"))
end

function lib:GetInvalidSpellCount()
    local count = 0
    for _ in pairs(self.invalidSpellsLogged) do
        count = count + 1
    end
    return count
end

function lib:DumpInvalidSpells()
    local count = self:GetInvalidSpellCount()
    if count == 0 then
        print("|cff00ff00LibSpellDB:|r No invalid spells detected")
        return
    end

    print("|cffff9900LibSpellDB:|r " .. count .. " invalid spell IDs detected:")
    for spellID in pairs(self.invalidSpellsLogged) do
        print(("  [%d]"):format(spellID))
    end
end

-------------------------------------------------------------------------------
-- Proc API
-------------------------------------------------------------------------------

--[[
    Get all proc buffs for a class

    @param class (string) - Class token (e.g., "WARRIOR")
    @return (table) - Array of proc spell data
]]
function lib:GetProcs(class)
    local procs = {}
    local classSpells = self:GetSpellsByClassAndTag(class, "PROC")
    
    for spellID, spellData in pairs(classSpells) do
        table.insert(procs, spellData)
    end
    
    return procs
end

--[[
    Get proc info for a specific spell

    @param spellID (number) - Spell/buff ID
    @return (table or nil) - Proc info or nil if not a proc
]]
function lib:GetProcInfo(spellID)
    local spellData = self:GetSpellInfo(spellID)
    if spellData and spellData.procInfo then
        return spellData.procInfo
    end
    return nil
end

-------------------------------------------------------------------------------
-- Spell Rank Utilities
-------------------------------------------------------------------------------

--[[
    Get all spell IDs for a spell (base + all ranks)

    @param spellID (number) - Base spell ID or any rank ID
    @return (table) - Set of spell IDs (keys are IDs, values are true)
]]
function lib:GetAllRankIDs(spellID)
    local canonicalID = self.rankToCanonical[spellID] or spellID
    local spellData = self.spells[canonicalID]
    
    local rankSet = {[canonicalID] = true}
    
    if spellData and spellData.ranks then
        for _, rankID in ipairs(spellData.ranks) do
            rankSet[rankID] = true
        end
    end
    
    return rankSet
end

--[[
    Get the highest known rank of a spell
    
    Note: This is a stateless query that calls IsSpellKnown for each rank.
    Consider caching results at the application level if called frequently.

    @param spellID (number) - Base spell ID or any rank ID
    @return (number) - Spell ID of highest known rank, or input ID if none found
]]
function lib:GetHighestKnownRank(spellID)
    local canonicalID = self.rankToCanonical[spellID] or spellID
    local spellData = self.spells[canonicalID]
    
    if not spellData or not spellData.ranks then
        -- No rank data, check if the spell is known
        if IsSpellKnown and IsSpellKnown(canonicalID) then
            return canonicalID
        end
        return spellID
    end
    
    -- Check ranks from highest to lowest (ranks array is ordered low to high)
    local highestKnown = nil
    for i = #spellData.ranks, 1, -1 do
        local rankID = spellData.ranks[i]
        if IsSpellKnown and IsSpellKnown(rankID) then
            highestKnown = rankID
            break
        end
    end
    
    -- If no ranks known, check if base spell is known
    if not highestKnown then
        if IsSpellKnown and IsSpellKnown(canonicalID) then
            highestKnown = canonicalID
        end
    end
    
    return highestKnown or spellID
end
