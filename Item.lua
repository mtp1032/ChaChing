--------------------------------------------------------------------------------------
-- Item.lua 
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 14 June, 2019
--------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.Item = {}
item = ChaChing.Item

local L = ChaChing.L
local sprintf = _G.string.format

local SUCCESS 			= core.SUCCESS
local FAILURE 			= core.FAILURE
local EMPTY_STR 		= core.EMPTY_STR

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

local chachingListFrame = mf:createListFrame("Excluded Items")
local bagIsChecked = {}
local sellGrey = true
local sellWhite = false

-- default state for bagIsChecked
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
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("All bags not checked."), 0, 1, 0)
end
function item:setBagChecked( bagSlot )
	bagIsChecked[bagSlot+1] = true
	local bagName = C_Container.GetBagName( bagSlot )
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s has been checked.", bagName, 0, 1, 0))
	end
end
function item:setBagUnchecked( bagSlot )
	bagIsChecked[bagSlot+1] = false
	local bagName = C_Container.GetBagName( bagSlot )

	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s has been unchecked", bagName ), 0, 1, 0)
	end
end
local function isBagChecked( bagSlot )
	local index = bagSlot + 1
	return bagIsChecked[index]
end
function item:setGreyChecked( isChecked )
	sellGrey = isChecked
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("Sell Grey Items is %s.", tostring( isChecked )), 0, 1, 0)
	end
end
function item:setWhiteChecked( isChecked )
	sellWhite = isChecked
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("Sell White Items is %s.", tostring( isChecked )), 0, 1, 0)
	end
end
function item:addExcludedItem( itemName )
	table.insert( ChaChing_ExcludedItemsList, itemName )

	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s is now excluded.", itemName), 0, 1, 0)
	end
end
function item:clearExcludedItems()
	wipe( ChaChing_ExcludedItemsList )

end
function item:showExcludedItems()
		if #ChaChing_ExcludedItemsList == 0 then


		chachingListFrame.Text:EnableMouse( false )    
		chachingListFrame.Text:EnableKeyboard( false )   
		chachingListFrame.Text:SetText(EMPTY_STR) 
		chachingListFrame.Text:ClearFocus()
		local str = "No Items Have Been Excluded.\n"
		chachingListFrame.Text:Insert(str ) 
		chachingListFrame:Show()
		return
	end

	chachingListFrame.Text:EnableMouse( false )    
	chachingListFrame.Text:EnableKeyboard( false )   
	chachingListFrame.Text:SetText(EMPTY_STR) 
	chachingListFrame.Text:ClearFocus()

	local n = #ChaChing_ExcludedItemsList

	local str = sprintf("The Following items will not be sold.\n", n )
	chachingListFrame.Text:Insert(str )
	for i = 1, n do
		local entry = sprintf("%d: %s\n", i, ChaChing_ExcludedItemsList[i])

		chachingListFrame.Text:Insert( entry  )
	end
	chachingListFrame:Show()
end
local function itemIsExcluded( itemName )
	local n = #ChaChing_ExcludedItemsList
	if n == 0 then return false end

	for i = 1, n do
			if itemName == ChaChing_ExcludedItemsList[i] then
			dbg:print()
			return true
		end
	end
	dbg:print()
	return false
end
local function getSalesAttributes( bagSlot, slot )

	local itemInfo = GetContainerItemInfo( bagSlot, slot )
	if itemInfo == nil then return 0, 0, 0, 0 end

	local itemQuality, itemCount = itemInfo.quality, itemInfo.stackCount

	local itemLink = GetContainerItemLink( bagSlot, slot )
	local itemName, _, _, _, _, itemType, _, _, _, _, unitSalesPrice = GetItemInfo( itemLink )
	assert( type(itemName ) == "string", "ASSERT_FAILURE: Unexpected data type")

	return itemName, itemQuality, itemCount, itemType, unitSalesPrice
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
				local itemName, itemQuality, itemCount, itemType, unitSalesPrice = getSalesAttributes( bagSlot, slot )
				if itemName ~= nil and itemQuality ~= nil and itemCount ~= nil and itemType ~= nil and unitSalesPrice ~= nil then
					if itemQuality == QUALITY_POOR and unitSalesPrice > 0 then
						UseContainerItem( bagSlot, slot )
						totalEarnings = totalEarnings + (unitSalesPrice * itemCount)
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
				local itemName, itemQuality, itemCount, itemType, unitSalesPrice = getSalesAttributes( bagSlot, slot )
				if itemName ~= nil and itemQuality ~= nil and itemCount ~= nil and itemType ~= nil and unitSalesPrice ~= nil then
					if not itemIsExcluded( itemName ) then
						dbg:print( itemName )
						if unitSalesPrice > 0 then
							if itemQuality == QUALITY_COMMON then
								if itemType == "Weapon" then
									UseContainerItem( bagSlot, slot )
									totalEarnings = totalEarnings + (unitSalesPrice * itemCount)
									totalItemsSold = totalItemsSold + itemCount  
								end
								if itemType == "Armor" then
									UseContainerItem( bagSlot, slot )
									totalEarnings = totalEarnings + (unitSalesPrice * itemCount)
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
local function sellAllItemsInBag( bagSlot )
	if not bagIsChecked[bagSlot + 1] then return 0, 0 end

    local totalEarnings = 0
    local totalItemsSold = 0

	local bagName = GetBagName( bagSlot )
	if bagName == nil then return end

	local numSlots = GetContainerNumSlots( bagSlot )
	for slot = 1, numSlots do
		local itemName, itemQuality, itemCount, itemType, unitSalesPrice = getSalesAttributes( bagSlot, slot )
		dbg:print( itemName )
		if unitSalesPrice > 0 then
			UseContainerItem( bagSlot, slot )
			totalEarnings = totalEarnings + (unitSalesPrice * itemCount)
			totalItemsSold = totalItemsSold + itemCount  
		end      
	end
	return totalEarnings, totalItemsSold
end
local function sellItems()
	local totalEarnings = 0
	local totalItemsSold = 0

	if sellGrey then 
		local earnings, itemsSold = sellGreyItems() 
		totalEarnings = totalEarnings + earnings
		totalItemsSold = totalItemsSold + itemsSold
	end
	if sellWhite then 
		local earnings, itemsSold = sellWhiteItems() 
		totalEarnings = totalEarnings + earnings
		totalItemsSold = totalItemsSold + itemsSold
	end
	for i = 0, 4 do
		if isBagChecked( i ) then
			local earnings, itemsSold = sellAllItemsInBag( i )
			totalEarnings = totalEarnings + earnings
			totalItemsSold = totalItemsSold + itemsSold	
		end
	end

	local msg = nil
	if totalItemsSold > 1 then
		msg = sprintf("Sold %d items earning %s\n", totalItemsSold, GetCoinTextureString( totalEarnings ))
	elseif totalItemsSold == 1 then
		msg = sprintf("Sold %d item earning %s\n", totalItemsSold, GetCoinTextureString( totalEarnings ))
	else
		msg = sprintf("No items sold")	
	end
	UIErrorsFrame:SetTimeVisible(20)
	UIErrorsFrame:AddMessage( msg, 0.0, 1.0, 1.0 ) 
end

-- Creates a button  and places it within the Merchant frame.
local ButtonChaChing = CreateFrame( "Button" , "ChaChingBtn" , MerchantFrame, "UIPanelButtonTemplate" )
ButtonChaChing:SetText( "ChaChing" )
ButtonChaChing:SetWidth(90)
ButtonChaChing:SetHeight(21)
ButtonChaChing:SetPoint("TopRight", -180, -30 )
ButtonChaChing:RegisterForClicks("AnyUp")		
ButtonChaChing:SetScript("Onclick", sellItems )
