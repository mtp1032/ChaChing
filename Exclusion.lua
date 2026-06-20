--------------------------------------------------------------------------------------
-- Exclusion.lua
-- AUTHOR: mtpeterson1948 at gmail dot com
-- ORIGINAL DATE: 16 July, 2023

-- implements the item exclusion list
ChaChing = ChaChing or {}
if not ChaChing.DebugTools.loaded then
	DEFAULT_CHAT_FRAME:AddMessage("DebugTools.lua failed to load", 0, 1, 0)
    return
end

ChaChing.Exclusion = {}

local core = ChaChing.Core
local L = ChaChing.Localizationlocal dbg = ChaChing.DebugTools
local utils = ChaChing.Utilities
local excluded = ChaChing.Exclusion


local excludedItems = {}

function excluded:addItem(itemID)
    if not itemID then return end
    excludedItems[itemID] = true
end
function excluded:removeItem(itemID)
    if not itemID then return end
    excludedItems[itemID] = nil
end
function excluded:isExcluded(itemID)
    if not itemID then return false end
    return excludedItems[itemID] == true
end
function excluded:getExcludedItems()
    return utils:copyTable(excludedItems)
end
function excluded:clearExcludedItems()
    excludedItems = {}
end
function excluded:getExcludedItemCount()
    local count = 0
    for _ in pairs(excludedItems) do
        count = count + 1
    end
    return count
end
-- Display the entire list of excluded items
function excluded:displayExcludedItems()
    dbg:print("Excluded Items:")
    for itemID in pairs(excludedItems) do
        local itemName = GetItemInfo(itemID) or "Unknown Item"
        dbg:print(string.format("- %s (ID: %d)", itemName, itemID))
    end
end

if core:debuggingIsEnabled() then
    DEFAULT_CHAT_FRAME:AddMessage("Exclusion.lua loaded", 0, 1, 0 )
end
ChaChing.Exclusion.loaded = true
return ChaChing.Exclusion.loaded