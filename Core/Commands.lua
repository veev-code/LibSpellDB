--[[
    LibSpellDB - Slash Commands for Testing/Debug
]]

local MAJOR = "LibSpellDB-1.0"
local lib = LibStub and LibStub:GetLibrary(MAJOR, true)
if not lib then return end

-------------------------------------------------------------------------------
-- Slash Commands
-------------------------------------------------------------------------------

SLASH_LIBSPELLDB1 = "/spelldb"
SLASH_LIBSPELLDB2 = "/lsdb"

SlashCmdList["LIBSPELLDB"] = function(msg)
    local args = {}
    for word in msg:gmatch("%S+") do
        table.insert(args, word)
    end

    local cmd = args[1] and args[1]:lower() or "help"

    if cmd == "help" then
        print("|cff00ff00LibSpellDB Commands:|r")
        print("  /spelldb stats - Show database statistics")
        print("  /spelldb class <CLASS> - List spells for a class (e.g., WARRIOR)")
        print("  /spelldb tag <TAG> - List spells with a tag (e.g., INTERRUPT)")
        print("  /spelldb spell <ID> - Show info for a spell ID")
        print("  /spelldb categories - List all categories")
        print("  /spelldb invalid - Show invalid spell IDs that were skipped")
        print("  /spelldb debug - Toggle debug mode (shows warnings on load)")
        print("  /spelldb version - Show library version")

    elseif cmd == "stats" then
        print("|cff00ff00LibSpellDB Statistics:|r")
        print(("  Game Version: %s"):format(lib:GetGameVersion()))
        print(("  Total Spells: %d"):format(lib:GetSpellCount()))

        local invalidCount = lib:GetInvalidSpellCount()
        if invalidCount > 0 then
            print(("  |cffff9900Invalid Spells: %d|r (use /spelldb invalid to see list)"):format(invalidCount))
        end

        local classes = {"WARRIOR", "PRIEST", "MAGE", "ROGUE", "DRUID", "HUNTER", "WARLOCK", "SHAMAN", "PALADIN"}
        for _, class in ipairs(classes) do
            local count = lib:GetClassSpellCount(class)
            if count > 0 then
                print(("  %s: %d spells"):format(class, count))
            end
        end

    elseif cmd == "class" then
        local class = args[2] and args[2]:upper()
        if not class then
            print("|cffff0000Usage: /spelldb class <CLASS>|r")
            return
        end
        lib:DumpSpellsByClass(class)

    elseif cmd == "tag" then
        local tag = args[2] and args[2]:upper()
        if not tag then
            print("|cffff0000Usage: /spelldb tag <TAG>|r")
            return
        end
        lib:DumpSpellsByTag(tag)

    elseif cmd == "spell" then
        local spellID = args[2] and tonumber(args[2])
        if not spellID then
            print("|cffff0000Usage: /spelldb spell <ID>|r")
            return
        end

        local info = lib:GetSpellInfo(spellID)
        if info then
            print("|cff00ff00Spell Info:|r")
            print(("  ID: %d"):format(info.spellID))
            print(("  Name: %s"):format(info.name or "Unknown"))
            print(("  Class: %s"):format(info.class))
            print(("  Tags: %s"):format(table.concat(info.tags, ", ")))
            if info.cooldown then print(("  Cooldown: %ds"):format(info.cooldown)) end
            if info.duration then print(("  Duration: %ds"):format(info.duration)) end
            if info.talent then print("  Requires Talent: Yes") end
        else
            print("|cffff0000Spell not found in database|r")
        end

    elseif cmd == "categories" then
        print("|cff00ff00LibSpellDB Categories:|r")
        local categories = lib:GetAllCategories()
        local sorted = {}
        for key, _ in pairs(categories) do
            table.insert(sorted, key)
        end
        table.sort(sorted)
        for _, cat in ipairs(sorted) do
            local info = lib:GetCategoryInfo(cat)
            if info then
                print(("  %s - %s"):format(cat, info.name))
            else
                print(("  %s"):format(cat))
            end
        end

    elseif cmd == "invalid" then
        lib:DumpInvalidSpells()

    elseif cmd == "debug" then
        lib:SetDebugMode(not lib.debugMode)

    elseif cmd == "version" then
        print("|cff00ff00LibSpellDB|r Version: 1.0")
        print(("  Game Version: %s"):format(lib:GetGameVersion()))

    else
        print("|cffff0000Unknown command. Type /spelldb help for usage.|r")
    end
end

-- Print load message
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    print("|cff00ff00LibSpellDB|r loaded. Type |cff88ff88/spelldb help|r for commands.")
end)
