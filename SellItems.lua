--------------------------------------------------------------------------------------
-- SellItems.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 14 June, 2019
--------------------------------------------------------------------------------------
local ADDON_C_NAME, MTP = ...
MTP.SellItems = {}
cha = MTP.SellItems

local L = MTP.L
local E = errors

-- System message color - Yellow
local RED = 1.00
local GREEN = 1.00
local BLUE = 0.00
local DISPLAY_TIME = UIErrorsFrame:SetTimeVisible(8)	-- display for 8 seconds

local function displayMsg( msg )
	UIErrorsFrame:AddMessage( msg, RED, GREEN, BLUE, 1, DISPLAY_TIME ) 
end

local function insertIntoExclusionTable( itemLink )
	if itemLink == nil or itemLink == "" then
		return
	end
	table.insert( exclusionTable, itemLink )
end

local function isItemExcluded( itemLink )
	for key, value in pairs( exclusionTable ) do
		if value == itemLink then
			return true
		end
	end 
	return false
end

local function removeFromExclusionTable( itemLink )
	for key, value in pairs( exclusionTable ) do
		if value == itemLink then
			table.remove(exclusionTable, key )
		end
	end 
end

local function resetExclusionTable()
	exclusionTable = {}
end

local function showExclusionTable()
	mf:printList( exclusionTable )
end

function cha:CHACHING_InitializeOptions()
 
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
				local b = bg:getBag(id + 1)
				labelStr = string.format("Bag[%d] - %d free slots", id+1, GetContainerNumFreeSlots(id) )
				button.label:SetText(labelStr)
				button:SetEnabled(true)
			else
				local labelStr = string.format("Bag[%d] - Slot empty", id+1)
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
	
	local str1 = string.format("\n%s","                                 *** WARNING ***")
	local str2 = string.format("%s", "  The merchant buyback window only has 12 slots. However, the merchant")
	local str3 = string.format("%s", "  will buy as many items as Cha-Ching is configured to sell. Thus, if")
	local str4 = string.format("%s", "  more than 12 items were sold, you will only be able to buyback the")
	local str5 = string.format("%s", "  last 12.")

	local messageText = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormal")
	messageText:SetJustifyH("LEFT")
    messageText:SetPoint("TOPLEFT", 10, -320)
	messageText:SetText(string.format("%s\n%s\n%s\n%s\n%s",
											str1, str2, str3, str4, str5 ))
end
--------------------------------------------------------------------------------------
--						QUALITY (i.e., RARITY) values
--						are defined in SlotClass.lua
--------------------------------------------------------------------------------------
local function itemCanBeSold( itemLink )
	local itemIsSaleable = false
	if isItemExcluded( itemLink ) then
		return istemIsSaleable
	end

	-- Setup the logic for selling/not selling POOR items
	item = Item( itemLink )
	local quality = item:getQuality()

	if quality == QUALITY_POOR and sellGrey then
		itemIsSaleable = true
	end

	if quality == QUALITY_COMMON and sellWhite then		
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
			local b = bg:getBag(bagSlot+1)
			-- did the player select this bag?
			if isBagChecked[bagSlot+1] then
				local itemsSold, earnings
				itemsSold, earnings = b:sellAllItemsInBag()
				totalItemsSold = totalItemsSold + itemsSold
				totalEarnings = totalEarnings + earnings
			else
				-- the bag is not checked. So, check for grays and whites
				for slotId = 1, totalSlots do
					local slot = Slot(b:getInstallationSlot(), slotId )	
					local itemCount = slot:getItemCount()
					if itemCount > 0 then				
						local itemLink = slot:getItemLink()
						if itemCanBeSold( itemLink ) then
							local unitSalesPrice = item:getUnitSalesPrice()
							UseContainerItem( bagSlot, slotId )
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
		msg = string.format("Sold %d items earning %s\n", totalItemsSold, GetCoinTextureString( totalEarnings ))
	elseif totalItemsSold == 1 then
		msg = string.format("Sold %d items earning %s\n", totalItemsSold, GetCoinTextureString( totalEarnings ))
	else
		msg = string.format("No items sold")	
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

local helpStr = string.format("  /chaching help - This message.")
local optionsStr = string.format("  /chaching options - Display the ChaChing Interface Options Menu.")
local showStr = string.format("  /chaching showlist - List the items in the Exclusion Table.")
local clearStr = string.format("  /chaching clearlist - Remove all entries from the Exclusion Table.")

local CR = string.format("\n")
SLASH_CHACHING_HELP1 = "/chaching"
SLASH_CHACHING_HELP2 = "/cha"
SlashCmdList["CHACHING_HELP"] = function( msg )

	-- message("This is a message.")
	inputStr = string.lower(msg)

	if inputStr == nil or inputStr == "" or inputStr == "help" then
		DEFAULT_CHAT_FRAME:AddMessage(CR)
		DEFAULT_CHAT_FRAME:AddMessage("COMMAND LINE OPTIONS:")
		DEFAULT_CHAT_FRAME:AddMessage(helpStr)
		DEFAULT_CHAT_FRAME:AddMessage(optionsStr)
		DEFAULT_CHAT_FRAME:AddMessage(showStr)
		DEFAULT_CHAT_FRAME:AddMessage(clearStr)
		DEFAULT_CHAT_FRAME:AddMessage(CR)

	elseif inputStr == "options" then
		InterfaceOptionsFrame_OpenToCategory("ChaChing")
		InterfaceOptionsFrame_OpenToCategory("ChaChing")
		InterfaceOptionsFrame_OpenToCategory("ChaChing")

	elseif inputStr == "showlist" then
		showExclusionTable()
	elseif inputStr == "resetlist" then
		resetExclusionTable()
		displayMsg("Exclusion Table Cleared.")
	else
		local errStr = string.format("[INVALID SLASH COMMAND OPTION]\n\n\'%s\'", msg )
		UIErrorsFrame:AddMessage( errStr, RED, GREEN, BLUE, 1, DISPLAY_TIME )
		errStr = string.format("[INVALID SLASH COMMAND OPTION] \'%s\'", msg )
		DEFAULT_CHAT_FRAME:AddMessage( errStr, 1.0, 1.0, 0.0 )
	end
end
