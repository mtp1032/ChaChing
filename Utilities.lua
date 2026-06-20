-- Utilities.lua
-- Shared helper functions for ChaChing

ChaChing = ChaChing or {}

if not ChaChing.DebugTools.loaded then
    local str = string.format("DebugTools failed to load.\n")
    DEFAULT_CHAT_FRAME:AddMessage( str, 0,1,0)
    return
end
local core = ChaChing.Core
local L = ChaChing.Localization
local dbg = ChaChing.DebugTools
local utils = ChaChing.Utilities
local exclusion = ChaChing.Exclusion
local SellTable = ChaChing.SellTable

-- ================================================================
-- Tooltip Scanning (Safe for Retail + Classic)
-- ================================================================

local tooltip = CreateFrame("GameTooltip", "ChaChingTooltipScanner", nil, "GameTooltipTemplate")
tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

-- Returns true if the tooltip for an item contains the given text (case-insensitive)
function ChaChing:TooltipContains(link, searchText)
    if not link or not searchText then return false end

    tooltip:ClearLines()
    tooltip:SetHyperlink(link)

    local search = strlower(searchText)

    for i = 1, tooltip:NumLines() do
        local line = _G["ChaChingTooltipScannerTextLeft" .. i]
        if line and line:GetText() then
            if strlower(line:GetText()):find(search) then
                return true
            end
        end
    end

    -- Fallback: Try C_TooltipInfo (more modern Retail)
    if C_TooltipInfo and C_TooltipInfo.GetHyperlink then
        local data = C_TooltipInfo.GetHyperlink(link)
        if data and data.lines then
            for _, line in ipairs(data.lines) do
                if line.leftText and strlower(line.leftText):find(search) then
                    return true
                end
            end
        end
    end

    return false
end

-- Returns true if tooltip contains ANY of the texts in the table
function ChaChing:TooltipContainsAny(link, textTable)
    if not link or not textTable then return false end

    tooltip:ClearLines()
    tooltip:SetHyperlink(link)

    for _, searchText in ipairs(textTable) do
        local search = strlower(searchText)
        for i = 1, tooltip:NumLines() do
            local line = _G["ChaChingTooltipScannerTextLeft" .. i]
            if line and line:GetText() and strlower(line:GetText()):find(search) then
                return true
            end
        end
    end

    -- C_TooltipInfo fallback
    if C_TooltipInfo and C_TooltipInfo.GetHyperlink then
        local data = C_TooltipInfo.GetHyperlink(link)
        if data and data.lines then
            for _, line in ipairs(data.lines) do
                if line.leftText then
                    local txt = strlower(line.leftText)
                    for _, searchText in ipairs(textTable) do
                        if txt:find(strlower(searchText)) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

-- ================================================================
-- Item Usability / Equipability Helpers
-- ================================================================

-- More complete CanPlayerUseItem (expand as needed)
function ChaChing:CanPlayerUseItem(link, minLevel, equipLoc, classID, subclassID)
    if not link then return false end

    -- Level requirement
    if minLevel and minLevel > UnitLevel("player") then
        return false  -- future upgrade - don't sell yet
    end

    -- Basic equip check
    if not C_Item.IsEquippableItem(link) then
        return false
    end

    -- TODO: Add class armor/weapon proficiency tables here later
    -- Example:
    -- local playerClass = select(2, UnitClass("player"))
    -- if classID == 4 then -- Armor
    --     if subclassID == 3 and playerClass == "PRIEST" then return false end  -- Mail on Priest, etc.
    -- end

    return true
end

-- ================================================================
-- Other Useful Helpers
-- ================================================================

-- Safe way to check if item is soulbound (preferred over tooltip)
function ChaChing:IsSoulbound(bag, slot)
    local loc = ItemLocation:CreateFromBagAndSlot(bag, slot)
    if loc and loc:IsValid() then
        return C_Item.IsBound(loc)
    end
    return false
end

-- Quick check for quest items
function ChaChing:IsQuestItem(itemID)
    if not itemID then return false end
    return C_Item.GetItemQuestID and C_Item.GetItemQuestID(itemID) ~= 0
end

-- Print item summary (useful for debug)
function ChaChing:DumpItemInfo(bag, slot)
    local link = C_Container.GetContainerItemLink(bag, slot)
    if not link then return end

    local itemID, classID, subclassID, equipLoc = C_Item.GetItemInfoInstant(link)
    local name, _, quality, _, minLevel = C_Item.GetItemInfo(link)

    dbg.print(string.format("Item: %s | ID:%d | Quality:%d | Class:%d/%d",
        link or "nil", itemID or 0, quality or -1, classID or -1, subclassID or -1))
end

-- Load message
if ChaChing.Core and ChaChing.Core:debuggingIsEnabled() then
    DEFAULT_CHAT_FRAME:AddMessage("Utilities.lua loaded", 0, 1, 0)
end