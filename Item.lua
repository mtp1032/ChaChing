--------------------------------------------------------------------------------------
-- Item.lua 
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 14 June, 2019
--------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.Item = {}

local item  	= ChaChing.Item
local L 		= ChaChing.L
local core 		= ChaChing.Core
local dbg  		= ChaChing.DebugTools
local msgFrame	= ChaChing.MsgFrame

local GetBagName 				= _G.C_Container.GetBagName 
local GetContainerItemID 		= _G.C_Container.GetContainerItemID
local GetContainerItemInfo 		= _G.C_Container.GetContainerItemInfo
local GetContainerItemLink 		= _G.C_Container.GetContainerItemLink
local GetContainerNumSlots 		= _G.C_Container.GetContainerNumSlots
local GetContainerNumFreeSlots	= _G.C_Container.GetContainerNumFreeSlots
local UseContainerItem 			= _G.C_Container.UseContainerItem
local ContainerIDToInventoryID	= _G.C_Container.ContainerIDToInventoryID

local QUALITY_POOR 		= 0
local QUALITY_COMMON 	= 1
------------------------------------------------------------
--						SAVED VARS
------------------------------------------------------------
CHACHING_SAVED_OPTIONS		= nil
ChaChing_ExcludedItemsList 	= nil

local chachingListFrame = msgFrame:createListFrame("Excluded Items")
local bagIsChecked 		= {}
local sellGrey 			= true
local sellWhite 		= false

-- default state for bagIsChecked. This executed
-- when the addon is loaded.
for i = 0, 4 do
	local bagName = GetBagName( i )
	if bagName ~= nil then
		bagIsChecked[i+1] = false
	end
end
function item:uncheckAllBags()
	for i = 0, 4 do
		local bagName = GetBagName( i )
		if bagName ~= nil then
			bagIsChecked[i+1] = false
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage( string.format("All bags not checked."), 0, 1, 0)
end
function item:setBagChecked( bagSlot )
	bagIsChecked[bagSlot+1] = true
	local bagName = C_Container.GetBagName( bagSlot )
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( string.format("%s has been checked.", bagName, 0, 1, 0))
	end
end
function item:setBagUnchecked( bagSlot )
	bagIsChecked[bagSlot+1] = false
	local bagName = C_Container.GetBagName( bagSlot )

	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( string.format("%s has been unchecked", bagName ), 0, 1, 0)
	end
end
local function isBagChecked( bagSlot )
	local index = bagSlot + 1
	return bagIsChecked[index]
end
function item:setGreyChecked( isChecked )
	sellGrey = isChecked
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( string.format("Sell Grey Items is %s.", tostring( isChecked )), 0, 1, 0)
	end
end
function item:setWhiteChecked( isChecked )
	sellWhite = isChecked
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( string.format("Sell White Items is %s.", tostring( isChecked )), 0, 1, 0)
	end
end
------- Should be defined in MsgFrame ---------------
function item:addExcludedItem( itemName )
	table.insert( ChaChing_ExcludedItemsList, itemName )

	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( string.format("%s is now excluded.", itemName), 0, 1, 0)
	end
end
-- function item:clearExcludedItems()
-- 	wipe( ChaChing_ExcludedItemsList )
-- end
function item:showExcludedItems()
		if #ChaChing_ExcludedItemsList == 0 then


		chachingListFrame.Text:EnableMouse( false )    
		chachingListFrame.Text:EnableKeyboard( false )   
		chachingListFrame.Text:SetText("") 
		chachingListFrame.Text:ClearFocus()
		local str = "No Items Have Been Excluded.\n"
		chachingListFrame.Text:Insert(str ) 
		chachingListFrame:Show()
		return
	end

	chachingListFrame.Text:EnableMouse( false )    
	chachingListFrame.Text:EnableKeyboard( false )   
	chachingListFrame.Text:SetText("") 
	chachingListFrame.Text:ClearFocus()

	local n = #ChaChing_ExcludedItemsList

	local str = string.format("The Following %d items will not be sold.\n", n )
	chachingListFrame.Text:Insert(str )
	for i = 1, n do
		local entry = string.format("%d: %s\n", i, ChaChing_ExcludedItemsList[i])
		chachingListFrame.Text:Insert( entry  )
	end
	chachingListFrame:Show()
end
local function itemIsExcluded( itemName )
	local n = #ChaChing_ExcludedItemsList
	if n == 0 then return false end

	for i = 1, n do
			if itemName == ChaChing_ExcludedItemsList[i] then
			return true
		end
	end
	return false
end
-------------------------------------------------------

local function getSalesAttributes( bagSlot, slot )

	local itemInfo = C_Container.GetContainerItemInfo(bagSlot, slot )
	if itemInfo == nil then return nil end
	if itemInfo.hasNoValue then return nil end

	local itemLink = GetContainerItemLink( bagSlot, slot )
	if itemLink == nil then return nil end

	local itemCount = itemInfo.stackCount

	local itemName, _, itemQuality, _, _, itemType, _, _, _, _, sellPrice = C_Item.GetItemInfo( itemLink )
	if sellPrice == 0 then return nil end

	-- dbg:print( "Bag ", bagSlot, ": itemName", itemName, ", sellPrice", sellPrice, ", itemCount", itemCount )

	return itemName, itemQuality, itemType, itemCount, sellPrice
end
local function sellGreyItems()
	if not sellGrey then return 0, 0 end

    local totalEarnings = 0
    local totalItemsSold = 0
	
    for bagSlot = 0, 4 do
        local bagName = GetBagName( bagSlot )
        if bagName ~= nil then 
            local numSlots = GetContainerNumSlots( bagSlot )
            for slot = 1, numSlots do
				-- itemName, itemQuality, itemType, itemCount, sellPrice
				local itemName, itemQuality, itemType, itemCount, itemSalesPrice = getSalesAttributes( bagSlot, slot )
				if itemName ~= nil and itemQuality ~= nil and itemCount ~= nil and itemType ~= nil and itemSalesPrice ~= nil then
					if itemQuality == QUALITY_POOR and itemSalesPrice > 0 then
						UseContainerItem( bagSlot, slot )
						totalEarnings = totalEarnings + (itemSalesPrice * itemCount)
						totalItemsSold = totalItemsSold + itemCount        
					end
				end
            end
        end
    end
	return totalEarnings, totalItemsSold
end
local function sellWhiteItems()
	if not sellWhite then return 0, 0 end

	local totalEarnings = 0
    local totalItemsSold = 0

    for bagSlot = 0, 4 do
        local bagName = GetBagName( bagSlot )
        if bagName ~= nil then 
            local numSlots = GetContainerNumSlots( bagSlot )
            for slot = 1, numSlots do
				-- itemName, itemQuality, itemType, itemCount, sellPrice
				local itemName, itemQuality, itemType, itemCount, itemSalesPrice = getSalesAttributes( bagSlot, slot )
				if itemName ~= nil and itemQuality ~= nil and itemCount ~= nil and itemType ~= nil and itemSalesPrice ~= nil then
					if not itemIsExcluded( itemName ) then
						if itemSalesPrice > 0 then
							if itemQuality == QUALITY_COMMON then
								if itemType == "Weapon" then
									UseContainerItem( bagSlot, slot )
									totalEarnings = totalEarnings + (itemSalesPrice * itemCount)
									totalItemsSold = totalItemsSold + itemCount  
								end
								if itemType == "Armor" then
									UseContainerItem( bagSlot, slot )
									totalEarnings = totalEarnings + (itemSalesPrice * itemCount)
									totalItemsSold = totalItemsSold + itemCount  
								end
							end
						end
					end 
				end     
            end
        end
    end
	return totalEarnings, totalItemsSold
end
--------------------------------------------------------------------------------------
local BATCH_LIMIT = 6 -- Number of items to sell in each batch
local SELL_DELAY = 1.0 -- Delay in seconds between batches

-- Function to create a table of sellable items in the specified bag
local function createSellableItemsTable(bagId)
    local sellableItems = {}

    -- Get the number of slots in the specified bag
    local numSlots = GetContainerNumSlots(bagId)

    for slot = 1, numSlots do
        -- Get the sales attributes of the item in the specified bag and slot
		--    itemName, itemQuality, itemType, itemCount, sellPrice
        local itemName, _, _, itemCount, itemSalesPrice = getSalesAttributes(bagId, slot )
        if itemName ~= nil then
		        table.insert(sellableItems, {
				bagId, bagId,
                slot = slot,
                itemName = itemName,
                itemCount = itemCount,
                itemSalesPrice = itemSalesPrice
            } )
		end
    end
	-- for _, entry in ipairs( sellableItems ) do
	-- 	dbg:print( "Bag: ", entry.bagId, ", name", entry.itemName, "count", entry.itemCount, "price", entry.itemSalesPrice )
	-- end

    return sellableItems
end

-- Function to sell all items in the sellableItems table
local function sellItemsFromTable(bagId, sellableItems, index, totalEarnings, totalItemsSold)
    -- Initialize variables if they are not provided
    totalEarnings = totalEarnings or 0
    totalItemsSold = totalItemsSold or 0
    index = index or 1
    local itemsSoldInBatch = 0

    for i = index, #sellableItems do
        local item = sellableItems[i]

        if item then
            -- Sell the item and update total earnings and items sold
            C_Container.UseContainerItem(bagId, item.slot)
            totalEarnings = totalEarnings + (item.itemSalesPrice * item.itemCount)
            totalItemsSold = totalItemsSold + item.itemCount
            itemsSoldInBatch = itemsSoldInBatch + 1

            -- Check if we've reached the batch limit
            if itemsSoldInBatch >= BATCH_LIMIT then
                -- Schedule the next batch after a delay
                C_Timer.After(SELL_DELAY, function()
                    sellItemsFromTable(bagId, sellableItems, i + 1, totalEarnings, totalItemsSold)
                end)
                -- Return here to prevent further processing in the current loop
                -- return totalEarnings, totalItemsSold
            end
        end
    end

    -- Final return after processing all items
    return totalEarnings, totalItemsSold
end

-- Function to verify that all sellable items were sold
local function verifyItemsSold(bagId, sellableItems)
    local unsoldItems = {}

    for _, item in ipairs(sellableItems) do
        local _, _, _, itemCount = GetContainerItemInfo(bagId, item.slot)
		if itemCount == nil then itemCount = 0 end
        if itemCount > 0 then
            table.insert(unsoldItems, item)
            -- dbg:print(string.format("Item %s in slot %d was not sold. Remaining count: %d.\n", item.itemName, item.slot, itemCount))
        end
    end

    return unsoldItems
end

-- Wrapper function to sell all items in the specified bag with verification
local function sellItemsInBag(bagId)
    -- 1. Create a table of sellable items
    local sellableItems = createSellableItemsTable(bagId)
    -- 2. Sell the items from the sellableItems table
    local totalEarnings, totalItemsSold = sellItemsFromTable(bagId, sellableItems)
    -- 3. Verify that all items were sold
    local unsoldItems = verifyItemsSold(bagId, sellableItems)

    if #unsoldItems > 0 then
        -- Retry selling the unsold items or log a warning
        -- dbg:print("Retrying unsold items...")
        sellItemsFromTable(bagId, unsoldItems)
    end

    return totalEarnings, totalItemsSold
end

-----------------------------------------------------------------------------------------------

-- Main loop to process each bag
local function sellItems()
	local totalEarnings = 0
	local totalItemsSold = 0

	for bagId = 0, 4 do
		if isBagChecked(bagId) then
			
			-- Initialize earnings and itemsSold for this bag
			local earnings, itemsSold = sellItemsInBag( bagId )
			-- Accumulate the results
			totalEarnings = totalEarnings + earnings
			totalItemsSold = totalItemsSold + itemsSold
		end
	end

	local greyEarnings, numGrayItemsSold = sellGreyItems()
	local whiteEarnings, numWhiteItemsSold = sellWhiteItems()
	totalEarnings = totalEarnings + greyEarnings + whiteEarnings
	totalItemsSold = totalItemsSold + numGrayItemsSold + numWhiteItemsSold

	dbg:print( "totalEarnings", totalEarnings, "totalItemsSold", totalItemsSold )
	if totalItemsSold == 0 then 
		core:notifyEarnings( "No Items Sold.", 10 )
		return
	end
	
	-- Print final totals after all bags are processed
	local totalEarningsStr = GetCoinTextureString( totalEarnings )
	-- dbg:print( totalEarningsStr )
	
	local msg = nil
	if totalItemsSold > 1 then
		msg = string.format("Total Earnings: %s for %d items.\n", totalEarningsStr, totalItemsSold  )
		-- dbg:print(msg)
	end
	if totalItemsSold == 1 then
		msg = string.format("Total Earnings: %s on 1 item.\n", totalEarningsStr )
		-- dbg:print(msg)
	end
	
	-- dbg:print( msg )
	core:notifyEarnings( msg, 10 )
	-- UIErrorsFrame:AddMessage( msg, 1.0, 1.0, 0.0 ) 

	dbg:print()
	msgFrame:post( msg )
	DEFAULT_CHAT_FRAME:AddMessage( msg, 0.0, 1.0, 0.0 )
end

-- Creates a button  and places it within the Merchant frame.
local ButtonChaChing = CreateFrame( "Button" , "ChaChingBtn" , MerchantFrame, "UIPanelButtonTemplate" )
ButtonChaChing:SetText( "ChaChing" )
ButtonChaChing:SetWidth(90)
ButtonChaChing:SetHeight(21)
ButtonChaChing:SetPoint("TopRight", -180, -30 )
ButtonChaChing:RegisterForClicks("AnyUp")		
ButtonChaChing:SetScript("Onclick", sellItems )

local fileName = "Item.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 1.0, 1.0, 0.0 )
end
