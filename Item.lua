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
CHACHING_SAVED_OPTIONS = nil
CHACHING_EXCLUSION_LIST = nil

local chachingListFrame = mf:createListFrame("Excluded Items")
local excludedItemsList = {}
local freeSlots = {}

function item:uncheckAllBags()
	for i = 0, 4 do
		local bagName = GetBagName( i )
		if bagName ~= nil then
			freeSlots[i+1] = false
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("All bags set to default."), 0, 1, 0)
end
function item:setBagChecked( bagName, bagSlot )
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s has been checked.", bagName), 0, 1, 0)
	end
end
function item:setBagUnchecked( bagName, bagSlot )
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s has been unchecked", bagName), 0, 1, 0)
	end
end

function item:bagIsChecked( bagSlot )
	local index = bagSlot + 1
	return freeSlots[index]
end
function item:setGreyChecked( isChecked )
	CHACHING_SAVED_OPTIONS.sellGrey = isChecked
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("Sell Grey Items is %s.", 
				tostring( isChecked )), 0, 1, 0)
	end
end
function item:setWhiteChecked( isChecked )
	CHACHING_SAVED_OPTIONS.sellWhite = isChecked
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("Sell White Items is %s.", 
				tostring( isChecked )), 0, 1, 0)
	end
end
function item:addExcludedItem( itemName )
	table.insert( CHACHING_EXCLUSION_LIST, itemName )
	if core:debuggingIsEnabled() then
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s is now excluded.", itemName), 0, 1, 0)
	end
end
function item:clearExcludedItems()
	wipe( CHACHING_EXCLUSION_LIST)
end
function item:showExcludedItems()
	if #CHACHING_EXCLUSION_LIST == 0 then

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

	local n = #CHACHING_EXCLUSION_LIST
	local str = sprintf("The Following items will not be sold.\n", n )
	chachingListFrame.Text:Insert(str )
	for i = 1, n do
		local entry = sprintf("%d: %s\n", i, CHACHING_EXCLUSION_LIST[i])
		chachingListFrame.Text:Insert( entry  )
	end
	chachingListFrame:Show()
end
function item:itemIsExcluded( itemName )
	local n = #CHACHING_EXCLUSION_LIST
	if n == 0 then return false end

	for i = 1, n do
		if itemName == CHACHING_EXCLUSION_LIST[i] then
			return true
		end
	end
	return false
end
local function getSalesAttributes( bagSlot, slot )

	local itemInfo = GetContainerItemInfo( bagSlot, slot )
	if itemInfo == nil then return 0, 0, 0, 0 end

	local itemQuality, itemCount = itemInfo.quality, itemInfo.stackCount

	local itemLink = GetContainerItemLink( bagSlot, slot )
	local _, _, _, _, _, itemType, _, _, _, _, unitSalesPrice = GetItemInfo( itemLink )

	return itemQuality, itemCount, itemType, unitSalesPrice
end
local function sellGreyItems()
	if not CHACHING_SAVED_OPTIONS.sellGrey then return 0, 0 end

    local totalEarnings = 0
    local totalItemsSold = 0

    for bagSlot = 0, 4 do
        local bagName = GetBagName( bagSlot )
        if bagName ~= nil then 
            local numSlots = GetContainerNumSlots( bagSlot )
            for slot = 1, numSlots do
				local itemQuality, itemCount, itemType, unitSalesPrice = getSalesAttributes( bagSlot, slot )
				if itemQuality == QUALITY_POOR and unitSalesPrice > 0 then
					UseContainerItem( bagSlot, slot )
					totalEarnings = totalEarnings + (unitSalesPrice * itemCount)
					totalItemsSold = totalItemsSold + itemCount        
				end
            end
        end
    end
	return totalEarnings, totalItemsSold
end
local function sellWhiteItems()
	if not CHACHING_SAVED_OPTIONS.sellWhite then return 0, 0 end

	local totalEarnings = 0
    local totalItemsSold = 0

    for bagSlot = 0, 4 do
        local bagName = GetBagName( bagSlot )
        if bagName ~= nil then 
            local numSlots = GetContainerNumSlots( bagSlot )
            for slot = 1, numSlots do
				local itemQuality, itemCount, itemType, unitSalesPrice = getSalesAttributes( bagSlot, slot )
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
	return totalEarnings, totalItemsSold
end
local function sellAllItemsInBag( bagSlot )
	print( dbg:prefix(), freeSlots[bagSlot + 1])
	if not freeSlots[bagSlot + 1] then return 0, 0 end
	print( dbg:prefix(), freeSlots[bagSlot + 1])

    local totalEarnings = 0
    local totalItemsSold = 0

	local bagName = GetBagName( bagSlot )
	if bagName == nil then return end

	local numSlots = GetContainerNumSlots( bagSlot )
	for slot = 1, numSlots do
		local itemQuality, itemCount, itemType, unitSalesPrice = getSalesAttributes( bagSlot, slot )
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

	if CHACHING_SAVED_OPTIONS.sellGrey then 
		local earnings, itemsSold = sellGreyItems() 
		totalEarnings = totalEarnings + earnings
		totalItemsSold = totalItemsSold + itemsSold
	end
	if CHACHING_SAVED_OPTIONS.sellWhite then 
		local earnings, itemsSold = sellWhiteItems() 
		totalEarnings = totalEarnings + earnings
		totalItemsSold = totalItemsSold + itemsSold
	end
	for i = 0, 4 do
		if item:bagIsChecked( i ) then
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

local eventFrame = CreateFrame("Frame" )
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", 
function( self, event, ... )
	local arg1 = ...

	if event == "ADDON_LOADED" and arg1 == L["ADDON_NAME"] then

		if CHACHING_SAVED_OPTIONS == nil then
			CHACHING_SAVED_OPTIONS = {}

			-- default options
			CHACHING_SAVED_OPTIONS.sellGrey = true
			CHACHING_SAVED_OPTIONS.sellWhite = false
		end

		if CHACHING_EXCLUSION_LIST == nil then
			CHACHING_EXCLUSION_LIST = {}
			print( dbg:prefix(), type(CHACHING_EXCLUSION_LIST) )
		end

		DEFAULT_CHAT_FRAME:AddMessage( L["ADDON_NAME_AND_VERSION"],  1.0, 1.0, 0.0 )
		eventFrame:UnregisterEvent( "ADDON_LOADED")
	end
end)

-- 	btn.lable = sprintf("%s: %d free slots.", bagName, freeSlots )

