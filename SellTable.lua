-- SellTable.lua
ChaChing = ChaChing or {}
ChaChing.SellTable = ChaChing.SellTable or {}

local SellTable = ChaChing.SellTable
local dbg = ChaChing.DebugTools
local core = ChaChing.Core

SellTable.Items = SellTable.Items or {}      -- array of sellable items
SellTable.Lookup = SellTable.Lookup or {}    -- "bag-slot" -> true

-- Add item to sell table (called from scanner)
function SellTable:Add(bag, slot, reason)
    local key = bag .. "-" .. slot
    if SellTable.Lookup[key] then return false end

    local link = C_Container.GetContainerItemLink(bag, slot)
    if not link then return false end

    local _, _, _, _, _, _, _, stackCount, _, _, sellPrice = C_Item.GetItemInfo(link)
    if not sellPrice or sellPrice == 0 then return false end

    local entry = {
        bagId = bag,
        slot = slot,
        link = link,
        itemSalesPrice = sellPrice,
        itemCount = stackCount or 1,
        reason = reason or "unknown"
    }

    table.insert(SellTable.Items, entry)
    SellTable.Lookup[key] = true
    return true
end

function SellTable:Remove(bag, slot)
    local key = bag .. "-" .. slot
    if not SellTable.Lookup[key] then return end

    for i = #SellTable.Items, 1, -1 do
        local item = SellTable.Items[i]
        if item.bagId == bag and item.slot == slot then
            table.remove(SellTable.Items, i)
            break
        end
    end

    SellTable.Lookup[key] = nil
end

-- Full scan (call from your thread / events)
function SellTable:ScanAndQueue()
    local added = 0

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local sell, reason = ChaChing.Decision:GetSellDecision(bag, slot)

            if sell then
                if SellTable:Add(bag, slot, reason) then
                    added = added + 1
                end
            else
                SellTable:Remove(bag, slot)
            end
        end
    end

    if added > 0 and ChaChing.Core:debuggingIsEnabled() then
        dbg.print(string.format("ScanAndQueue: +%d new items | Total queued: %d", added, #SellTable.Items))
    end

    return #SellTable.Items
end

function SellTable:Clear()
    wipe(SellTable.Items)
    wipe(SellTable.Lookup)
end

function SellTable:GetCount()
    return #SellTable.Items
end

if core:debuggingIsEnabled() then
    local fileName = "SellTable.lua"
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 0, 1, 0)
end
