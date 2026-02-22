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
local lib, _ = LibStub:NewLibrary(MAJOR, MINOR)
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

-- Aura mappings: auraSpellID -> {sourceSpellID, tags, type, onTarget, ...}
lib.auraToSource = lib.auraToSource or {}

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

    -- Handle triggered auras - build reverse index
    if spellData.triggersAuras then
        for _, auraInfo in ipairs(spellData.triggersAuras) do
            if auraInfo.spellID then
                self.auraToSource[auraInfo.spellID] = {
                    sourceSpellID = spellID,
                    tags = auraInfo.tags or {},
                    type = auraInfo.type or "DEBUFF",
                    onTarget = auraInfo.onTarget,
                    duration = auraInfo.duration,
                }
            end
        end
    end

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
    Get the display icon for a spell.
    Returns the icon override if set, or the auto-resolved icon from GetSpellInfo.

    @param spellIDOrData (number|table) - Spell ID or spell data table
    @return (number or nil) - Icon texture ID
]]
function lib:GetSpellIcon(spellIDOrData)
    local spellData
    if type(spellIDOrData) == "table" then
        spellData = spellIDOrData
    else
        spellData = self:GetSpellInfo(spellIDOrData)
    end
    if not spellData then return nil end
    return spellData.icon
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
        local spellTags = self.spellIDToTags[spellID]
        if spellTags then
            for i = 2, #tags do
                if not spellTags[tags[i]] then
                    hasAllTags = false
                    break
                end
            end
        else
            hasAllTags = false
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
    Determine if a spell can only target self (vs. targeting other friendly players)
    
    Used for buff tracking to determine whether to check self or the current friendly target.
    
    Priority:
    1. Explicit selfOnly field in spell data (highest priority)
    2. triggersAuras[1].onTarget == false (explicit self-only aura)
    3. Tags indicating spell can target others: HEAL_SINGLE, HOT, HAS_HOT, HEAL_AOE, EXTERNAL_DEFENSIVE
    4. Default: self-only (for buffs like Recklessness, Shadowform, Stealth)
    
    @param spellID (number) - Spell ID (or spell data table)
    @return (boolean) - true if spell can ONLY target self, false if it can target others
]]
function lib:IsSelfOnly(spellID)
    local auraTarget = self:GetAuraTarget(spellID)
    -- "self" and "none" are both considered "self-only" for backwards compatibility
    -- "ally" and "pet" can target others
    return auraTarget == "self" or auraTarget == "none"
end

--[[
    Get the aura target type for a spell
    
    Returns where the buff/effect appears for tracking purposes:
    - "self": Buff appears on caster only (Barkskin, Evasion, Ice Block)
    - "ally": Can target other friendly players (Renew, BoP, PWS)
    - "pet": Targets pet (Mend Pet)
    - "none": No unit to track - AoE around caster, totems, placed objects
    
    Priority:
    1. Explicit auraTarget field
    2. Legacy selfOnly field (converted to "self"/"ally")
    3. triggersAuras onTarget = false -> "self"
    4. Tags indicating spell can target others -> "ally"
    5. Default: "self"
    
    @param spellID (number) - Spell ID (or spell data table)
    @return (string) - "self", "ally", "pet", or "none"
]]
function lib:GetAuraTarget(spellID)
    -- Accept either spell ID or spell data table
    local spellData
    if type(spellID) == "table" then
        spellData = spellID
    else
        spellData = self:GetSpellInfo(spellID)
    end
    
    if not spellData then return "self" end  -- Default to self if no data
    
    -- Explicit auraTarget field takes precedence
    if spellData.auraTarget then
        return spellData.auraTarget
    end
    
    -- Legacy selfOnly field support (convert to auraTarget values)
    if spellData.selfOnly ~= nil then
        return spellData.selfOnly and "self" or "ally"
    end
    
    -- Check triggersAuras for explicit onTarget = false
    if spellData.triggersAuras and spellData.triggersAuras[1] then
        if spellData.triggersAuras[1].onTarget == false then
            return "self"
        end
    end
    
    -- Check tags using hash index for O(1) lookup
    local id = spellData.spellID
    if id then
        local tagSet = self.spellIDToTags[id]
        if tagSet then
            if tagSet["HEAL_SINGLE"] or tagSet["HOT"] or tagSet["HAS_HOT"]
               or tagSet["HEAL_AOE"] or tagSet["EXTERNAL_DEFENSIVE"] then
                return "ally"
            end
        end
    end
    
    -- Default: self
    return "self"
end

--[[
    Get the dispel type for a spell's buff effect.
    Returns "Magic", "Curse", "Disease", "Poison", or nil (physical / not dispellable).
    This determines whether the buff can be removed by enemy dispel/purge abilities.
]]
function lib:GetDispelType(spellID)
    local spellData
    if type(spellID) == "table" then
        spellData = spellID
    else
        spellData = self:GetSpellInfo(spellID)
    end
    if not spellData then return nil end
    return spellData.dispelType
end

--[[
    Check if a spell is rotational (core rotation, used frequently)
    
    Used by VeevHUD to determine buff tracking behavior:
    - ROTATIONAL spells follow target context (check ally if targeting ally)
    - Non-ROTATIONAL spells always track the buff regardless of current target
    
    @param spellID (number) - Spell ID (or spell data table)
    @return (boolean) - true if spell has ROTATIONAL tag
]]
function lib:IsRotational(spellID)
    -- Accept either spell ID or spell data table
    local id
    if type(spellID) == "table" then
        id = spellID.spellID
    else
        id = self.rankToCanonical[spellID] or spellID
    end
    if not id then return false end
    local tags = self.spellIDToTags[id]
    return tags and tags["ROTATIONAL"] or false
end

--[[
    Check if a spell can only be active on one target at a time

    Covers spells with explicit single-target limitations (e.g. "Only one target can
    be polymorphed at a time") and spells whose effect is implicitly exclusive to one
    target (e.g. duration < cooldown).

    @param spellID (number) - Spell ID (or spell data table)
    @return (boolean) - true if only one instance can be active at a time
]]
function lib:IsSingleTarget(spellID)
    local spellData
    if type(spellID) == "table" then
        spellData = spellID
    else
        spellData = self:GetSpellInfo(spellID)
    end

    if not spellData then return false end

    return spellData.singleTarget == true
end

--[[
    Get item IDs associated with a spell's cooldown.
    For spells that create usable items (e.g., Soulstone), the cooldown
    is tracked on the item rather than the spell itself.

    @param spellID (number|table) - Spell ID or spell data table
    @return (table or nil) - Array of item IDs, or nil if none
]]
function lib:GetCooldownItemIDs(spellID)
    local spellData
    if type(spellID) == "table" then
        spellData = spellID
    else
        spellData = self:GetSpellInfo(spellID)
    end

    if not spellData then return nil end

    return spellData.cooldownItemIDs
end

--[[
    Get required equipped item IDs for a spell.
    Some spells (e.g., weapon procs) are only relevant when specific items are equipped.

    @param spellIDOrData (number|table) - Spell ID or spell data table
    @return (table or nil) - Array of item IDs, or nil if no requirement
]]
function lib:GetRequiredItemIDs(spellIDOrData)
    local spellData
    if type(spellIDOrData) == "table" then
        spellData = spellIDOrData
    else
        spellData = self:GetSpellInfo(spellIDOrData)
    end

    if not spellData then return nil end

    return spellData.requiredItemIDs
end

--[[
    Get the active item cooldown for a spell that tracks cooldowns via items.
    Iterates through the spell's cooldownItemIDs and returns the first active cooldown.

    @param spellID (number|table) - Spell ID or spell data table
    @return remaining (number or nil), duration (number), startTime (number)
]]
function lib:GetItemCooldown(spellID)
    local itemIDs = self:GetCooldownItemIDs(spellID)
    if not itemIDs then return nil end

    local GetItemCooldown = _G.GetItemCooldown
    if not GetItemCooldown then return nil end

    local now = GetTime()
    for _, itemID in ipairs(itemIDs) do
        local start, dur, enable = GetItemCooldown(itemID)
        if start and start > 0 and dur > 0 then
            local remaining = (start + dur) - now
            if remaining > 0 then
                return remaining, dur, start
            end
        end
    end

    return nil
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
-- Aura Query API
-------------------------------------------------------------------------------

--[[
    Get aura info for a triggered aura spell ID
    
    This is used when a spell applies an aura with a different spell ID.
    For example, Charge (100) triggers Charge Stun (7922).
    
    @param auraSpellID (number) - The aura/buff/debuff spell ID
    @return (table or nil) - Aura info: {sourceSpellID, tags, type, onTarget, duration}
]]
function lib:GetAuraInfo(auraSpellID)
    return self.auraToSource[auraSpellID]
end

--[[
    Get the source spell ID for a triggered aura
    
    @param auraSpellID (number) - The aura/buff/debuff spell ID
    @return (number or nil) - The spell ID that triggers this aura
]]
function lib:GetAuraSourceSpellID(auraSpellID)
    local auraInfo = self.auraToSource[auraSpellID]
    return auraInfo and auraInfo.sourceSpellID
end

--[[
    Get tags for a triggered aura
    
    @param auraSpellID (number) - The aura/buff/debuff spell ID
    @return (table) - Array of tags, or empty table if not found
]]
function lib:GetAuraTags(auraSpellID)
    local auraInfo = self.auraToSource[auraSpellID]
    return auraInfo and auraInfo.tags or {}
end

--[[
    Check if an aura has a specific tag
    
    @param auraSpellID (number) - The aura/buff/debuff spell ID
    @param tag (string) - The tag to check for
    @return (boolean) - True if aura has the tag
]]
function lib:AuraHasTag(auraSpellID, tag)
    local auraInfo = self.auraToSource[auraSpellID]
    if auraInfo and auraInfo.tags then
        for _, t in ipairs(auraInfo.tags) do
            if t == tag then
                return true
            end
        end
    end
    return false
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
    -- Pre-compute priority for each spell to avoid O(n^2) tag iteration in comparator
    local priorityCache = {}
    for spellID, spellData in pairs(spells) do
        table.insert(sorted, spellData)
        if priorityFn then
            priorityCache[spellID] = priorityFn(spellData)
        else
            local maxPriority = 0
            for tag in pairs(self.spellIDToTags[spellID] or {}) do
                local tagPriority = self:GetCategoryPriority(tag)
                if tagPriority > maxPriority then maxPriority = tagPriority end
            end
            priorityCache[spellID] = maxPriority
        end
    end

    table.sort(sorted, function(a, b)
        return (priorityCache[a.spellID] or 0) > (priorityCache[b.spellID] or 0)
    end)

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

    -- Include shared/equipment procs (weapon procs like Deep Thunder / Stormherald)
    local sharedSpells = self:GetSpellsByClassAndTag("SHARED", "PROC")
    if sharedSpells then
        for spellID, spellData in pairs(sharedSpells) do
            table.insert(procs, spellData)
        end
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

--[[
    Get the reactive window duration for a spell.

    Reactive window spells (e.g., Victory Rush) become usable for a limited
    time when a condition is met (e.g., killing an enemy). This returns the
    duration of that usability window, or nil if the spell has no reactive window.

    @param spellID (number or table) - Spell ID or spell data table
    @return (number or nil) - Window duration in seconds, or nil
]]
function lib:GetReactiveWindow(spellID)
    local spellData
    if type(spellID) == "table" then
        spellData = spellID
    else
        spellData = self:GetSpellInfo(spellID)
    end
    if not spellData then return nil end
    return spellData.reactiveWindow
end

--[[
    Get dodge-reactive window duration for a spell

    For spells like Overpower that become usable when the target dodges,
    this returns the duration (in seconds) of the dodge window.
    Used by consumers to show ready-glow even when stance prevents IsUsableSpell.

    @param spellIDOrData (number or table) - Spell ID or spell data table
    @return (number or nil) - Dodge-reactive window duration in seconds, or nil
]]
function lib:GetDodgeReactive(spellIDOrData)
    local spellData
    if type(spellIDOrData) == "table" then
        spellData = spellIDOrData
    else
        spellData = self:GetSpellInfo(spellIDOrData)
    end
    if not spellData then return nil end
    return spellData.dodgeReactive
end

-------------------------------------------------------------------------------
-- Duration API
-------------------------------------------------------------------------------

--[[
    Get the duration for a specific spell rank.

    If the spell defines rankDurations (a map of spellID -> duration), returns the
    rank-specific duration. Otherwise falls back to the base duration field.

    @param spellID (number) - Spell ID (any rank)
    @return (number or nil) - Duration in seconds, or nil if no duration
]]
function lib:GetSpellDuration(spellID)
    local canonicalID = self.rankToCanonical[spellID] or spellID
    local spellData = self.spells[canonicalID]
    if not spellData then return nil end

    -- Check for rank-specific duration (map: spellID -> duration)
    if spellData.rankDurations then
        local rankDuration = spellData.rankDurations[spellID]
        if rankDuration then return rankDuration end
    end

    -- Fall back to base duration
    return spellData.duration
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
