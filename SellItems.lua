--------------------------------------------------------------------------------------
-- SellItems.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 14 June, 2019
--------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.SellItems = {}
si = ChaChing.SellItems

local L = ChaChing.L
local E = errors
local sprintf = _G.string.format

local RED = 1.00
local GREEN = 1.00
local BLUE = 0.00

local DISPLAY_TIME = 10

------------------------------------------------------------
--						SAVED GLOBALS
------------------------------------------------------------
sellGrey = true
sellWhite = false
isBagChecked = { false, false, false, false, false }
exclusionTable = {}

----------------------------------------------------------
--						EXCLUSION TABLE OPERATIONS
----------------------------------------------------------
local listFrame = mf:getListFrame()

local function displayMsg( msg )
	UIErrorsFrame:SetTimeVisible(DISPLAY_TIME)
	UIErrorsFrame:AddMessage( msg, RED, GREEN, BLUE, DISPLAY_TIME ) 
end
local function insertIntoExclusionTable( itemLink )
	if itemLink == nil or itemLink == "" then
		return
	end
	table.insert( exclusionTable, itemLink )
end
local function removeFromExclusionTable( itemLink )
	for key, value in pairs( exclusionTable ) do
		if value == itemLink then
			table.remove(exclusionTable, key )
		end
	end 
end
local function isItemOnExclusionTable( itemLink )
	for key, value in pairs( exclusionTable ) do
		if value == itemLink then
			return true
		end
	end 
	return false
end
local function showExclusionTable()
	if listFrame:IsVisible() == true then
		listFrame:Hide()
	end

	if exclusionTable[1] == nil then
		E.where()
		listFrame.Text:EnableMouse( false )    
		listFrame.Text:EnableKeyboard( false )   
		listFrame.Text:SetText("") 
		listFrame.Text:ClearFocus()
		local str = sprintf("The Excluded Item Table is Empty.\n")
		listFrame.Text:Insert(str )
	else
		listFrame.Text:EnableMouse( false )    
		listFrame.Text:EnableKeyboard( false )   
		listFrame.Text:SetText("") 
		listFrame.Text:ClearFocus()

		E.where()
		for key, value in pairs( exclusionTable ) do
			local s = sprintf("%d : %s\n", key, value )
			listFrame.Text:Insert( s )
		end
		listFrame.Text:Insert( sprintf("\n"))
	end

	listFrame:Show()
end
local function resetExclusionTable()
	exclusionTable = {}
	showExclusionTable()
end
local function postMsg( msg )
	if msgFrame:IsVisible() == false then
		msgFrame:Show()
	end
	msgFrame.Text:Insert( msg )
end

function si:CHACHING_InitializeOptions()
 
    local ConfigurationPanel = CreateFrame("FRAME","CHACHING_MainFrame")
    ConfigurationPanel.name = L["ADDON_NAME"]
    InterfaceOptions_AddCategory(ConfigurationPanel)    -- Register the Configuration panel with LibUIDropDownMenu

    -- Print a header at the top of the panel
    local IntroMessageHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    IntroMessageHeader:SetPoint("TOPLEFT", 10, -10)
    IntroMessageHeader:SetText(L["ADDON_NAME_AND_VERSION"])
 
    local DescrSubHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    DescrSubHeader:SetPoint("TOPLEFT", 20, -50)
	DescrSubHeader:SetText("Enables the bulk selling of selected items in player's inventory.")

    -- Create check button to sell grey items
    local GreyQualityButton = CreateFrame("CheckButton", "CHACHING_GreyQualityButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate")
    GreyQualityButton:SetPoint("TOPLEFT", 20, -80)
    GreyQualityButton.tooltip = "Sell all poor quality (i.e., grey) items in your bags."
	_G[GreyQualityButton:GetName().."Text"]:SetText("Sell Grey Items?")
	GreyQualityButton:SetChecked( sellGrey )
	GreyQualityButton:SetScript("OnClick", 
		function(self)
			sellGrey = self:GetChecked() and true or false
    	end)
 
    -- Create check button to sell white items
    local WhiteQualityButton = CreateFrame("CheckButton", "CHACHING_WhiteQualityButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate")
    WhiteQualityButton:SetPoint("TOPLEFT", 200, -80)
    WhiteQualityButton.tooltip = "Sell all common quality (i.e., white) armor and weapon items in your bags."
	_G[WhiteQualityButton:GetName().."Text"]:SetText("Sell White Items?")
	WhiteQualityButton:SetChecked( sellWhite )
	WhiteQualityButton:SetScript("OnClick", function(self)
		sellWhite = self:GetChecked() and true or false
    end)
 
	-- Create the Exclusion List Input Edit Box
	local DescrSubHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormal")
    DescrSubHeader:SetPoint("LEFT", 20, -150)
	DescrSubHeader:SetText("Exclusion List: Drag item from inventory and drop into input box.")
	local f = CreateFrame("EditBox", "InputEditBox", ConfigurationPanel, "InputBoxTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetSize(200,50)
	f:SetAutoFocus(false)
	f:SetPoint("LEFT", 20, -180)
	f:SetScript("OnMouseUp", 
		function(self,button)
			cursorInfo, _, itemLink = GetCursorInfo()
			insertIntoExclusionTable( itemLink )
			f:SetText( itemLink )	-- prints the item link to the chat dialog box
			ClearCursor()
	end)

    -- Create bag select buttons
    local bagsText = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    bagsText:SetPoint("TOPLEFT", 20, -200)
    bagsText:SetText("Select a bag. All items in the selected bag will be sold!")

    local xpos = 20
    local ypos = -215
    local delta_y = -20

    local function BagSelectButtonOnClick(self)
        isBagChecked[self.bagIndex] = self:GetChecked() and true or false
    end

    local bagSelectButtons = { } 
    for id = 0, 4 do
        local bagIndex = id + 1
        local button = CreateFrame("CheckButton", "CHACHING_BagButton" .. bagIndex, ConfigurationPanel, "ChatConfigCheckButtonTemplate")
        button:SetPoint("TOPLEFT", xpos, ypos + (delta_y * id))
        button.label = _G[button:GetName() .. "Text"]
        button.bagIndex = bagIndex
        button:SetScript("OnClick", BagSelectButtonOnClick)
        bagSelectButtons[bagIndex] = button
    end

	local function UpdateBagSelectButtons()
		for id = 0, 4 do
			local labelStr = nil
			local button = bagSelectButtons[id + 1]
			local numBagSlots = GetContainerNumSlots( id )
			if numBagSlots > 0 then
				-- local bag = bmgr:getBag(id + 1)
				labelStr = sprintf("Bag[%d] - %d free slots", id+1, GetContainerNumFreeSlots(id) )
				button.label:SetText(labelStr)
				button:SetEnabled(true)
			else
				local labelStr = sprintf("Bag[%d] - Slot empty", id+1)
				button.label:SetText(labelStr)
				button:SetEnabled(false)
			end
        end
	end
	UpdateBagSelectButtons()

    ConfigurationPanel:SetScript("OnEvent", UpdateBagSelectButtons)

    ConfigurationPanel:SetScript("OnHide", function(self)
        self:UnregisterEvent("BAG_UPDATE")
    end)

    ConfigurationPanel:SetScript("OnShow", function(self)
        self:RegisterEvent("BAG_UPDATE")
        UpdateBagSelectButtons()
	end)
	
	local str1 = sprintf("\n%s","                                 *** WARNING ***")
	local str2 = sprintf("%s", "  The merchant buyback window only has 12 slots. However, the merchant")
	local str3 = sprintf("%s", "  will buy as many items as Cha-Ching is configured to sell. Thus, if")
	local str4 = sprintf("%s", "  more than 12 items were sold, you will only be able to buyback the")
	local str5 = sprintf("%s", "  last 12.")

	local messageText = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormal")
	messageText:SetJustifyH("LEFT")
    messageText:SetPoint("TOPLEFT", 10, -320)
	messageText:SetText(sprintf("%s\n%s\n%s\n%s\n%s",
											str1, str2, str3, str4, str5 ))
end
--------------------------------------------------------------------------------------
--						QUALITY (i.e., RARITY) values
--						are defined in SlotClass.lua
--------------------------------------------------------------------------------------
local function itemCanBeSold( itemLink )
	local itemIsSaleable = false
	if isItemOnExclusionTable( itemLink ) then
		return istemIsSaleable
	end

	-- Setup the logic for selling/not selling POOR items
	item = Item( itemLink )
	local quality = item:getQualityName()

	if quality == "QUALITY_POOR" and sellGrey then
		itemIsSaleable = true
	end

	if quality == "QUALITY_COMMON" and sellWhite then		
		-- At this point the item is white (COMMON) AND the user has set the sellAllWhiteItems flag to true.
		-- Now, make sure that it is either an armor piece or a weapon.
		local itemType = item:getType()
		if itemType == "Armor" or itemType == "Weapon" then
			itemIsSaleable = true
		end
	end
	return itemIsSaleable
end

-- called when the player clicks on the [Sell Items] button
local function sellItems()
	local totalEarnings = 0
	local totalItemsSold = 0

	for bagSlot = 0, 4 do
		local totalSlots = GetContainerNumSlots( bagSlot )
		if totalSlots > 0 then
			-- Bet the total number of slots for this bag, but also 
			-- check that there is a valid bag installed at this slot. If
			-- the bag slot is empty then GetContainerNumSlots() returns 0
			local bag = bmgr:getBag(bagSlot+1)
			-- did the player select this bag?
			if isBagChecked[bagSlot+1] then
				local itemsSold, earnings
				itemsSold, earnings = bag:sellAllItemsInBag()
				totalItemsSold = totalItemsSold + itemsSold
				totalEarnings = totalEarnings + earnings
			else
				-- the bag is not checked. So, check for grays and whites
				for slotId = 1, totalSlots do
					local slot = Slot(bag:getInstallationSlot(), slotId )	
					local itemCount = slot:getItemCount()
					if itemCount > 0 then				
						local itemLink = slot:getItemLink()
						if itemCanBeSold( itemLink ) then
							local unitSalesPrice = item:getUnitSalesPrice()
							UseContainerItem( bagSlot, slotId )
							bag:updateSlots()
							totalEarnings = totalEarnings + unitSalesPrice * itemCount
							totalItemsSold = totalItemsSold + itemCount
						end -- if itemCanBeSold
					end -- if count
				end -- for slot = 1 ...
			end -- else
		end -- if totalSlots
	end -- for bagSlot

	local msg = nil
	if totalItemsSold > 1 then
		msg = sprintf("Sold %d items earning %s\n", totalItemsSold, GetCoinTextureString( totalEarnings ))
	elseif totalItemsSold == 1 then
		msg = sprintf("Sold %d items earning %s\n", totalItemsSold, GetCoinTextureString( totalEarnings ))
	else
		msg = sprintf("No items sold")	
	end

	displayMsg( msg )
end

-- Creates a button frame within the Merchant frame.

local ButtonChaChing = CreateFrame( "Button" , "ChaChingBtn" , MerchantFrame, "UIPanelButtonTemplate" )
ButtonChaChing:SetText("ChaChing")
ButtonChaChing:SetWidth(90)
ButtonChaChing:SetHeight(21)
ButtonChaChing:SetPoint("TopRight", -180, -30 )
ButtonChaChing:RegisterForClicks("AnyUp")		
ButtonChaChing:SetScript("Onclick", sellItems )

-----------------------------------------------------------------------------------------------------
--					COMMAND LINE OPTIONS
----------------------------------------------------------------------------------------------------

local helpStr =   sprintf("/cc help - This message.")
local configStr = sprintf("  /cc config - Display the ChaChing Interface Options Menu.")
local showStr =   sprintf("  /cc showtable - List the items in the Exclusion Table.")

local CR = sprintf("\n")
SLASH_CHACHING_HELP1 = "/chaching"
SLASH_CHACHING_HELP2 = "/cha"
SLASH_CHACHING_HELP3 = "/cc"
SlashCmdList["CHACHING_HELP"] = function( msg )

	-- message("This is a message.")
	inputStr = string.lower(msg)

	if inputStr == nil or inputStr == "" or inputStr == "help" then
		DEFAULT_CHAT_FRAME:AddMessage(CR)
		DEFAULT_CHAT_FRAME:AddMessage("COMMAND LINE OPTIONS:")
		DEFAULT_CHAT_FRAME:AddMessage(helpStr)
		DEFAULT_CHAT_FRAME:AddMessage(configStr)
		DEFAULT_CHAT_FRAME:AddMessage(showStr)
		DEFAULT_CHAT_FRAME:AddMessage(CR)

	elseif inputStr == "config" then
		InterfaceOptionsFrame_OpenToCategory("ChaChing")
		InterfaceOptionsFrame_OpenToCategory("ChaChing")
		InterfaceOptionsFrame_OpenToCategory("ChaChing")

	elseif inputStr == "showtable" then
		showExclusionTable()
	else
		-- System message color - Yellow

		local errStr = sprintf("[INVALID SLASH COMMAND OPTION]\n\n\'%s\'", msg )
		UIErrorsFrame:AddMessage( errStr, RED, GREEN, BLUE, 1, DISPLAY_TIME )
		errStr = sprintf("[INVALID SLASH COMMAND OPTION] \'%s\'", msg )
		DEFAULT_CHAT_FRAME:AddMessage( errStr, RED,GREEN,BLUE )
	end
end
