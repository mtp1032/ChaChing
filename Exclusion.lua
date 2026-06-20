--=========================================================
-- FILE: Exclusion.lua
-- AUTHOR: leave blank for now
-- COMMENTS: https://www.curseforge.com/members/mtpeterson1948
-- ORIGINAL DATE: 16 June, 2026
--=========================================================
ChaChing = ChaChing or {}
ChaChing.Exclusion = {}

local excluded = ChaChing.Exclusion

-- Dependencies
local dbg = ChaChing.DebugTools
local utils = ChaChing.Utilities

-- Private storage
local excludedItems = {}

-- ================================================================
-- Public API
-- ================================================================

function excluded:addItem(itemID)
    if not itemID then return end
    excludedItems[itemID] = true
    dbg:Print("Added to exclusion list:", itemID)
end

function excluded:removeItem(itemID)
    if not itemID then return end
    excludedItems[itemID] = nil
    dbg:Print("Removed from exclusion list:", itemID)
end

function excluded:isExcluded(itemID)
    if not itemID then return false end
    return excludedItems[itemID] == true
end

function excluded:getExcludedItems()
    if utils and utils.copyTable then
        return utils:copyTable(excludedItems)
    end
    return {}
end

function excluded:clearExcludedItems()
    excludedItems = {}
    dbg:Print("Exclusion list cleared")
end

function excluded:getExcludedItemCount()
    local count = 0
    for _ in pairs(excludedItems) do
        count = count + 1
    end
    return count
end

function excluded:displayExcludedItems()
    dbg:Print("=== Excluded Items (" .. excluded:getExcludedItemCount() .. ") ===")
    for itemID in pairs(excludedItems) do
        local itemName = C_Item.GetItemInfo(itemID) or ("Unknown #" .. itemID)
        dbg:Print(string.format("- %s (ID: %d)", itemName, itemID))
    end
end

-- ================================================================
-- Load Confirmation
-- ================================================================
if ChaChing.Core and ChaChing.Core:IsDebuggingEnabled() then
    print("|cFF00FF00[ChaChing]|r Exclusion.lua loaded")
end

ChaChing.Exclusion.loaded = true