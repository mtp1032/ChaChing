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
local sellGrey 			= CHACHING_SAVED_VARS[1]
local sellWhite 		= CHACHING_SAVED_VARS[2]
local exclusionTable 	= CHACHING_SAVED_VARS[3]

local isBagChecked = {false, false, false, false, false}
local listFrame = mf:getListFrame()
----------------------------------------------------------
--						EXCLUSION TABLE OPERATIONS
----------------------------------------------------------
local function insertIntoExclusionTable( itemLink )
	if itemLink == nil or itemLink == "" then
		return
	end
	local itemName = GetItemInfo( itemLink )
	table.insert( CHACHING_SAVED_VARS[3], itemName )
end
local function itemIsOnExclusionTable( itemLink )
	local itemName = GetItemInfo( itemLink )
	for key, value in pairs( CHACHING_SAVED_VARS[3] ) do
		if value == itemName then
			return true
		end
	end
	return false
end
function si:clearExclusionTable()
	if listFrame:IsVisible() == true then
		listFrame:Hide()
	end

	if CHACHING_SAVED_VARS[3][1] == nil then
		listFrame.Text:EnableMouse( false )    
		listFrame.Text:EnableKeyboard( false )   
		listFrame.Text:SetText("") 
		listFrame.Text:ClearFocus()
	else
			-- Clear all items from the table
		local items = #CHACHING_SAVED_VARS[3]
		for i = 1, items do
			CHACHING_SAVED_VARS[3][i] = nil
		end

		listFrame.Text:EnableMouse( false )    
		listFrame.Text:EnableKeyboard( false )   
		listFrame.Text:SetText("") 
		listFrame.Text:ClearFocus()
	end
	ReloadUI()
end
function si:showExclusionTable()
	if listFrame:IsVisible() == true then
		listFrame:Hide()
	end

	if CHACHING_SAVED_VARS[3][1] == nil then
		listFrame.Text:EnableMouse( false )    
		listFrame.Text:EnableKeyboard( false )   
		listFrame.Text:SetText("") 
		listFrame.Text:ClearFocus()
		local str = sprintf("The Exclusion Item Table Is Empty.\n")
		listFrame.Text:Insert(str )
	else
		listFrame.Text:EnableMouse( false )    
		listFrame.Text:EnableKeyboard( false )   
		listFrame.Text:SetText("") 
		listFrame.Text:ClearFocus()

		for key, value in pairs( CHACHING_SAVED_VARS[3] ) do
			local s = sprintf("%d : %s\n", key, value )
			listFrame.Text:Insert( s )
		end
		listFrame.Text:Insert( sprintf("\n"))
	end

	listFrame:Show()
end
local function displayMsg( msg )
	UIErrorsFrame:SetTimeVisible(DISPLAY_TIME)
	UIErrorsFrame:AddMessage( msg, RED, GREEN, BLUE, DISPLAY_TIME ) 
end
local LINE_SEGMENT_LENGTH = 615
local X_START_POINT = 10
local Y_START_POINT = 10

local function drawLine( yPos, f)
	local lineFrame = CreateFrame("FRAME", nil, f )
	lineFrame:SetPoint("CENTER", -10, yPos )
	lineFrame:SetSize(LINE_SEGMENT_LENGTH, LINE_SEGMENT_LENGTH)
	
	local line = lineFrame:CreateLine(1)
	line:SetColorTexture(.5, .5, .5, 1) -- Grey per https://wow.gamepedia.com/Power_colors
	line:SetThickness(1)
	line:SetStartPoint("LEFT",X_START_POINT, Y_START_POINT)
	line:SetEndPoint("RIGHT", X_START_POINT, Y_START_POINT)
	lineFrame:Show() 
end
function si:CHACHING_InitializeOptions()
 
    local ConfigurationPanel = CreateFrame("FRAME","CHACHING_MainFrame")
	ConfigurationPanel.name = L["ADDON_NAME"]

	-- drawLine( 130, ConfigurationPanel )

    InterfaceOptions_AddCategory(ConfigurationPanel)    -- Register the Configuration panel with LibUIDropDownMenu

    -- Print a header at the top of the panel
    local IntroMessageHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    IntroMessageHeader:SetPoint("TOPLEFT", 10, -10)
    IntroMessageHeader:SetText(L["ADDON_NAME_AND_VERSION"])
 
    local DescrSubHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    DescrSubHeader:SetPoint("TOPLEFT", 20, -50)
	DescrSubHeader:SetText(L["DESCR_SUBHEADER"])

    -- Create check button to sell grey items
    local GreyQualityButton = CreateFrame("CheckButton", "CHACHING_GreyQualityButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate")
    GreyQualityButton:SetPoint("TOPLEFT", 20, -80)
    GreyQualityButton.tooltip = L["TOOLTIP_CHECK_GREY_BTN"]
	_G[GreyQualityButton:GetName().."Text"]:SetText(L["LABEL_GREY_CHECKBTN"])
	GreyQualityButton:SetChecked( sellGrey )
	GreyQualityButton:SetScript("OnClick", 
		function(self)
			sellGrey = self:GetChecked() and true or false
			CHACHING_SAVED_VARS[1] = sellGrey
    	end)
		
    -- Create check button to sell white items
    local WhiteQualityButton = CreateFrame("CheckButton", "CHACHING_WhiteQualityButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate")
    WhiteQualityButton:SetPoint("TOPLEFT", 200, -80)
    WhiteQualityButton.tooltip = L["TOOLTIP_CHECK_WHITE_BTN"] 
	_G[WhiteQualityButton:GetName().."Text"]:SetText(L["LABEL_WHITE_CHECKBTN"])
	WhiteQualityButton:SetChecked( CHACHING_SAVED_VARS[2] )
	WhiteQualityButton:SetScript("OnClick", function(self)
		CHACHING_SAVED_VARS[2] = self:GetChecked() and true or false
    end)
 
	-- Create the Exclusion List Input Edit Box
	local DescrSubHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormal")
    DescrSubHeader:SetPoint("LEFT", 20, -150)
	DescrSubHeader:SetText(L["LABEL_EXCLUDED_ITEM_LIST"])
	local f = CreateFrame("EditBox", "InputEditBox", ConfigurationPanel, "InputBoxTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetSize(200,50)
	f:SetAutoFocus(false)
	f:SetPoint("LEFT", 20, -180)
	f:SetScript("OnMouseUp", 
		function(self,button)
			cursorInfo, _, itemLink = GetCursorInfo()
			if cursorInfo == "item" then
				-- inset the name of the item, not the item link
				insertIntoExclusionTable( itemLink )
				local s = sprintf("   %s will be excluded", itemLink )
				f:SetText( s )	-- prints the item link to the chat dialog box
			else
				f:SetText("")
			end
			ClearCursor()
	end)

    -- Create bag select buttons
    local bagsText = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    bagsText:SetPoint("TOPLEFT", 20, -180)
    bagsText:SetText(L["SELECT_BAG_PROMPT"])

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
	
	-- drawLine( -130, ConfigurationPanel )

	local str1 = sprintf("\n%s","                                 *** WARNING ***")
	local str2 = sprintf("%s", "  The merchant buyback window only has 12 slots. However, the merchant")
	local str3 = sprintf("%s", "  will buy as many items as Cha-Ching is configured to sell. Thus, if")
	local str4 = sprintf("%s", "  more than 12 items were sold, you will only be able to buyback the")
	local str5 = sprintf("%s", "  last 12.")

	local messageText = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormal")
	messageText:SetJustifyH("LEFT")
    messageText:SetPoint("TOPLEFT", 10, -320)
	messageText:SetText(sprintf("%s\n%s\n%s\n%s\n%s", str1, str2, str3, str4, str5 ))
end
local function itemCanBeSold( itemLink )
	local canBeSold = false
	if itemIsOnExclusionTable( itemLink ) then
		return canBeSold
	end

	-- Setup the logic for selling/not selling POOR items
	item = Item( itemLink )
	local quality = item:getQualityName()

	-- the item is grey and sellGrey is true
	if quality == "QUALITY_POOR" and CHACHING_SAVED_VARS[1] then
		canBeSold = true
		return canBeSold
	end

	-- the item is whithe and sellWhite is true
	if quality == "QUALITY_COMMON" and CHACHING_SAVED_VARS[2] then		
		-- At this point the item is white (COMMON) AND the user has set the sellWhite flag to true.
		-- Now, make sure that it is either an armor piece or a weapon.
		local itemType = item:getType()
		if itemType == "Armor" or itemType == "Weapon" then
			canBeSold = true
		end
	end
	return canBeSold
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
			-- if CHACHING_IS_BAG_CHECKED[bagSlot+1] then
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

-- Creates a button  and places it within the Merchant frame.

local ButtonChaChing = CreateFrame( "Button" , "ChaChingBtn" , MerchantFrame, "UIPanelButtonTemplate" )
ButtonChaChing:SetText("ChaChing")
ButtonChaChing:SetWidth(90)
ButtonChaChing:SetHeight(21)
ButtonChaChing:SetPoint("TopRight", -180, -30 )
ButtonChaChing:RegisterForClicks("AnyUp")		
ButtonChaChing:SetScript("Onclick", sellItems )

function si:showOptionsMenu()
	if listFrame:IsVisible() == true then
		listFrame:Hide()
	end
	InterfaceOptionsFrame_OpenToCategory("ChaChing")
	InterfaceOptionsFrame_OpenToCategory("ChaChing")
end
-----------------------------------------------------------------------------------------------------
--					COMMAND LINE OPTIONS
----------------------------------------------------------------------------------------------------

local helpStr 	= sprintf("/cc help - This message.")
local configStr = sprintf("  /cc config - Display the ChaChing Interface Options Menu.")
local showStr 	= sprintf("  /cc showItems - List the items in the Exclusion Table.")
local clearStr	= sprintf("  /cc clearItems - Clear all items from the Exclusion Table.")

-- System color - Yellow
local RED = 1.00
local GREEN = 1.00
local BLUE = 0.00

local CR = sprintf("\n")
SLASH_CHACHING_HELP1 = "/chaching"
SLASH_CHACHING_HELP2 = "/cc"
SlashCmdList["CHACHING_HELP"] = function( msg )

	-- message("This is a message.")
	inputStr = string.lower(msg)

	if inputStr == nil or inputStr == "" or inputStr == "help" then
		DEFAULT_CHAT_FRAME:AddMessage(CR)
		DEFAULT_CHAT_FRAME:AddMessage("COMMAND LINE OPTIONS:")
		DEFAULT_CHAT_FRAME:AddMessage(helpStr, RED, GREEN, BLUE )
		DEFAULT_CHAT_FRAME:AddMessage(configStr, RED, GREEN, BLUE)
		DEFAULT_CHAT_FRAME:AddMessage(showStr, RED, GREEN, BLUE)
		DEFAULT_CHAT_FRAME:AddMessage(clearStr, RED, GREEN, BLUE)
		DEFAULT_CHAT_FRAME:AddMessage(CR)

	elseif inputStr == "config" then
		si:showOptionsMenu()
	elseif inputStr == "showitems" then
		si:showExclusionTable()
	elseif inputStr == "clearitems" then
		si:clearExclusionTable()
	else
		local errStr = sprintf("[INVALID SLASH COMMAND OPTION]\n\n\'%s\'", msg )
		UIErrorsFrame:AddMessage( errStr, RED, GREEN, BLUE, 1, DISPLAY_TIME )
		errStr = sprintf("[INVALID SLASH COMMAND OPTION] \'%s\'", msg )
		DEFAULT_CHAT_FRAME:AddMessage( errStr, RED,GREEN,BLUE )
	end
end
