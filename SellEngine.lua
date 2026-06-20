--=========================================================
-- FILE: SellEngine.lua
-- AUTHOR: leave blank for now
-- COMMENTS: https://www.curseforge.com/members/mtpeterson1948
-- ORIGINAL DATE: 16 June, 2026
--=========================================================
ChaChing = ChaChing or {}
ChaChing.SellEngine = ChaChing.SellEngine or {}

local SellEngine = ChaChing.SellEngine
local exclusion = ChaChing.Exclusion
local core = ChaChing.Core
local dbg = ChaChing.DebugTools
local utils = ChaChing.Utilities
local L = ChaChing.Localization

if not ChaChing.SellTable.loaded then
   local str = string.format("SellTable.lua must be loaded before SellEngine.lua")
    DEFAULT_CHAT_FRAME:AddMessage(str, 1, 0, 0)
    return
end

local BATCH_LIMIT = 12
local SELL_DELAY = 0.75
local isSelling = false

function SellEngine:Execute()
    if not MerchantFrame or not MerchantFrame:IsShown() then
        print("|cffffd700ChaChing:|r You must be at a merchant to sell.")
        return
    end

    if #ChaChing.SellTable.Items == 0 then
        print("|cffffd700ChaChing:|r No items queued for sale.")
        return
    end

    if isSelling then
        dbg.print("Sell operation already in progress")
        return
    end

    isSelling = true

    local totalEarnings = 0
    local totalItemsSold = 0

    local function processBatch(startIdx)
        local batchCount = 0
        local i = startIdx

        while i <= #ChaChing.SellTable.Items and batchCount < BATCH_LIMIT do
            local item = ChaChing.SellTable.Items[i]
            if item then
                local currentLink = C_Container.GetContainerItemLink(item.bagId, item.slot)

                if currentLink and currentLink == item.link then
                    C_Container.UseContainerItem(item.bagId, item.slot)

                    totalEarnings = totalEarnings + (item.itemSalesPrice * item.itemCount)
                    totalItemsSold = totalItemsSold + item.itemCount
                    batchCount = batchCount + 1

                    i = i + 1   -- normal increment
                else
                    -- Item disappeared → remove safely
                    ChaChing.SellTable:Remove(item.bagId, item.slot)
                    -- Do NOT increment i because the table shifted
                end
            else
                i = i + 1
            end
        end

        -- More items left?
        if i <= #ChaChing.SellTable.Items then
            C_Timer.After(SELL_DELAY, function()
                processBatch(i)
            end)
        else
            -- All done
            isSelling = false

            if totalItemsSold > 0 then
                print(string.format("|cffffd700ChaChing:|r Sold %d items for %s",
                    totalItemsSold, GetCoinText(totalEarnings)))
            end

            ChaChing.SellTable:Clear()
        end
    end

    processBatch(1)
end

function SellEngine:Cancel()
    isSelling = false
end

if core:debuggingIsEnabled() then
    local fileName = "SellEngine.lua"
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 0, 1, 0)
end

ChaChing.SellEngine.loaded = true
return ChaChing.SellEngine.loaded
