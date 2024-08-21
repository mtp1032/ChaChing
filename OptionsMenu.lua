-- OptionsMenu.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 11 January, 2023
--------------------------------------------------------------------------------------
local ADDON_NAME, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.OptionsMenu = {}
local options = ChaChing.OptionsMenu

local L = ChaChing.L
local core = ChaChing.Core
local item = ChaChing.Item

local SUCCESS 	= core.SUCCESS
local FAILURE 	= core.FAILURE 
local EMPTY_STR	= core.EMPTY_STR
local EMPTY		= "EMPTY"
local OCCUPIED	= "OCCUPIED"

local sellAll = false

local GreyQualityButton = nil
local WhiteQualityButton = nil

local optionsPanel = nil
local inventorySlot = { EMPTY, EMPTY, EMPTY, EMPTY, EMPTY}

local LINE_SEGMENT_LENGTH = 575
local X_START_POINT = 10
local Y_START_POINT = 10

------------------------------ FRAME DIMENSIONS ------------
local FRAME_WIDTH = 600
local FRAME_HEIGHT = 700
local WIDTH_TITLE_BAR = 500
local HEIGHT_TITLE_BAR = 45

local BUTTON_WIDTH  = 48
local BUTTON_HEIGHT = 48

local function drawLine( yPos, f)
	local lineFrame = CreateFrame("FRAME", nil, f )
	lineFrame:SetPoint("CENTER", -10, yPos )
	lineFrame:SetSize(LINE_SEGMENT_LENGTH, LINE_SEGMENT_LENGTH)
	
	local line = lineFrame:CreateLine(1)
	line:SetColorTexture(.5, .5, .5, 1) -- Grey per https://wow.gamepedia.com/Power_colors
	line:SetThickness(2)
	line:SetStartPoint("LEFT",X_START_POINT, Y_START_POINT)
	line:SetEndPoint("RIGHT", X_START_POINT, Y_START_POINT)
	lineFrame:Show() 
end
local function showGreyWhiteCheckBoxes( frame, yPos )

    -- Create check button to sell grey items
    GreyQualityButton = CreateFrame("CheckButton", "CHACHING_GreyQualityButton", frame, "ChatConfigCheckButtonTemplate")
	GreyQualityButton:SetPoint("TOPLEFT", 20, yPos )
    GreyQualityButton.tooltip = L["GREY_TOOLTIP"]
	_G[GreyQualityButton:GetName().."Text"]:SetText("Sell Grey Items?" )
	GreyQualityButton:SetChecked( CHACHING_SAVED_OPTIONS.sellGrey )
	GreyQualityButton:SetScript("OnClick", 
		function(self)
			-- GetChecked() returns true if button is checked, false other wise
			CHACHING_SAVED_OPTIONS.sellGrey = self:GetChecked() and true or false
			item:setGreyChecked( CHACHING_SAVED_OPTIONS.sellGrey )
		end)

    -- Create check button to sell white quality items
    WhiteQualityButton = CreateFrame("CheckButton", "CHACHING_WhiteQualityButton", frame, "ChatConfigCheckButtonTemplate")
    WhiteQualityButton:SetPoint("TOPLEFT", 200, yPos)
    WhiteQualityButton.tooltip = L["WHITE_TOOLTIP"]
	_G[WhiteQualityButton:GetName().."Text"]:SetText("Sell White (Common Quality) armor and weapon items?" )
	WhiteQualityButton:SetChecked( CHACHING_SAVED_OPTIONS.sellWhite )
	WhiteQualityButton:SetScript("OnClick", 
		function(self)
			-- GetChecked() returns true if button is checked, false other wise
			CHACHING_SAVED_OPTIONS.sellWhite = self:GetChecked() and true or false
			item:setWhiteChecked( CHACHING_SAVED_OPTIONS.sellWhite )
    	end)
end -- end of OnClick

local function createBagCheckBox( frame, bagSlot, xPos, yPos )
    checkBackpack = CreateFrame("CheckButton", "CHACHING_checkBackpack", frame, "ChatConfigCheckButtonTemplate")
	xPos = xPos - 10
	yPos = (yPos)/50
	checkBackpack:SetPoint("LEFT", xPos, yPos )
	checkBackpack:SetChecked( sellAll )
	checkBackpack:SetScript("OnClick", 
		function(self )
			local bagName = C_Container.GetBagName( bagSlot )
			local sellAll = self:GetChecked() and true or false
			if sellAll then
				item:setBagChecked( bagSlot )
			else
				item:setBagUnchecked( bagSlot )
			end
		end)
end -- end of OnClick

local function createBagIcon( f, bagSlot )
	
	local bagFrame = CreateFrame("Button","CHACHING_BagButton", f,"TooltipBackdropTemplate")
	bagFrame.BagName = C_Container.GetBagName( bagSlot )
	bagFrame.BagSlot 	= bagSlot
	bagFrame.NumFreeSlots	= C_Container.GetContainerNumFreeSlots(bagSlot)

	-- NOTE: the iconFileId is unique to each bag, i.e., can be used as
	-- 		 a unique identifier
	if bagFrame.BagSlot == 0 then
		bagFrame.IconFileId = 133633
	else
		bagFrame.IconFileId = GetItemIcon( bagFrame.BagName )
		if bagFrame.IconFileId == nil then return nil end
	end
	bagFrame:SetSize( BUTTON_WIDTH, BUTTON_HEIGHT )

		-- Position bag buttons icons vertically
	bagFrame.xPos = 60
	bagFrame.yPos = 120 - (BUTTON_HEIGHT + 10) * ( bagSlot + 1 )

	-- This positions the bag icon.
	bagFrame:SetPoint( "LEFT", bagFrame.xPos, bagFrame.yPos )
	createBagCheckBox( bagFrame, bagFrame.BagSlot, bagFrame.xPos, bagFrame.yPos )

	bagFrame.Caption = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	bagFrame.Caption:SetJustifyH("LEFT")
	bagFrame.Caption:SetPoint("LEFT", bagFrame.xPos + (BUTTON_WIDTH + 30), bagFrame.yPos )
	bagFrame.Caption:SetFormattedText("%s: %d %s", bagFrame.BagName, bagFrame.NumFreeSlots, L["AVAILABLE_SLOTS"] )

	bagFrame.Texture = bagFrame:CreateTexture(nil,"ARTWORK")
	bagFrame.Texture:SetPoint("TOPLEFT",3,-3)
	bagFrame.Texture:SetPoint("BOTTOMRIGHT",-3,3)
	bagFrame.Texture:SetTexCoord(0.075,0.925,0.075,0.925) -- trim off icon's edges

	bagFrame:SetNormalTexture(bagFrame.IconFileId)
	bagFrame:SetHighlightTexture(bagFrame.IconFileId )
	bagFrame:GetHighlightTexture():SetAlpha(0.8)

	bagFrame.Mask = bagFrame:CreateMaskTexture(nil,"ARTWORK")
	bagFrame.Mask:SetPoint("TOPLEFT",bagFrame.Texture,"TOPLEFT")
	bagFrame.Mask:SetPoint("BOTTOMRIGHT",bagFrame.Texture,"BOTTOMRIGHT")
	bagFrame.Mask:SetTexture("Interface\\Common\\common-iconmask.blp")
	bagFrame.Texture:AddMaskTexture(bagFrame.Mask)
	return bagFrame
end
local function createOptionsPanel()
		
	local frame = CreateFrame("Frame", L["OPTIONS_MENU_TITLE"], UIParent, BackdropTemplateMixin and "BackdropTemplate")
	frame:SetFrameStrata("HIGH")
	frame:SetToplevel(true)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:EnableMouseWheel(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		edgeSize = 26,
		insets = {left = 9, right = 9, top = 9, bottom = 9},
	})
	frame:SetBackdropColor(0.0, 0.0, 0.0, 0.80)

	-- The Title Bar & Title
	frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBar:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	frame.titleBar:SetPoint("TOP", 0, 12)
	frame.titleBar:SetSize( WIDTH_TITLE_BAR, HEIGHT_TITLE_BAR)

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", 0, 4)
	frame.title:SetFormattedText("%s", "ChaChing Options Menu")

	-- Title text
	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.text:SetPoint("TOPLEFT", 12, -22)
	frame.text:SetWidth(frame:GetWidth() - 20)
	frame.text:SetJustifyH("LEFT")
	frame:SetHeight(frame.text:GetHeight() + 70)
	tinsert( UISpecialFrames, frame:GetName() )
	frame:SetSize( FRAME_WIDTH, FRAME_HEIGHT )

	-------------------- INTRO HEADER -----------------------------------------
	frame.Subtitle = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
	frame.Subtitle:SetPoint("TOP", 0, -20)
	frame.Subtitle:SetFormattedText("%s", L["ADDON_NAME_AND_VERSION"] )

	-------------------- WARNING ---------------------------------------
	frame.messageText = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
	frame.messageText:SetJustifyH("LEFT")
	frame.messageText:SetPoint("CENTER", 0, 150)
	local str1 = string.format("Checking any of these bag icons will cause %s to sell \n", L["ADDON_NAME"]  )
	local str2 = string.format("ALL items in the selected bag the next time you visit a merchant.")
	frame.messageText:SetFormattedText("%s%s\n", str1, str2 )

	showGreyWhiteCheckBoxes( frame, -80 )
	-- drawLine( 150, frame )

	frame.Bags = {}	
	for i = 0, 4 do
		local bagName = C_Container.GetBagName( i )
		if bagName ~= nil then
			local freeSlots = C_Container.GetContainerNumFreeSlots( i )
			frame.Bags[i + 1] = createBagIcon( frame, i )
			inventorySlot[i+1] = OCCUPIED
		else
			inventorySlot[i+1] = EMPTY
		end
	end
	-- [DEFAULTS] buttom, bottom left
	frame.hide = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.hide:SetText("Default")
	frame.hide:SetHeight(20)
	frame.hide:SetWidth(80)
	frame.hide:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 8)
	frame.hide:SetScript("OnClick",         
		function(self)
			frame:Hide()
			CHACHING_SAVED_OPTIONS.sellGrey = true
			CHACHING_SAVED_OPTIONS.sellWhite = false
			item:setGreyChecked( CHACHING_SAVED_OPTIONS.sellGrey )
			item:setWhiteChecked( CHACHING_SAVED_OPTIONS.sellWhite )
	end)

	-- [ACCEPT] buttom, bottom right
	frame.hide = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.hide:SetText("Accept")
	frame.hide:SetHeight(20)
	frame.hide:SetWidth(80)
	frame.hide:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
	frame.hide:SetScript("OnClick",
		function( self )
			frame:Hide()
			item:setGreyChecked( CHACHING_SAVED_OPTIONS.sellGrey )
			item:setWhiteChecked( CHACHING_SAVED_OPTIONS.sellWhite )
		end)

	-- Create the Exclusion List Input Edit Box
	frame.DescrSubHeader = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
	frame.DescrSubHeader:SetPoint("LEFT", 60, -250 )
	frame.DescrSubHeader:SetText("Excluded Item List" )
	frame.EditBox = CreateFrame("EditBox", "InputEditBox", frame, "InputBoxTemplate")
	frame.EditBox:SetFrameStrata("DIALOG")
	frame.EditBox:SetSize(200,75)
	frame.EditBox:SetAutoFocus(false)
	frame.EditBox:SetPoint("CENTER", 25, -250) 
	frame.EditBox:SetScript("OnMouseUp", 
		function(self,button)
			cursorInfo, itemId, itemLink = GetCursorInfo()
			if cursorInfo == "item" then
				local itemName = GetItemInfo( itemId )
				-- insert the name of the item, not the item link
				item:addExcludedItem( itemName )
				local s = string.format("   %s %s", itemName, L["EXCLUDED"] )
				frame.EditBox:SetText( s )	-- prints the item's name into the chat dialog box
			else
				frame.EditBox:SetText(EMPTY_STR)
			end
			ClearCursor()
	end)

	return frame   
end
local function updateOptionsPanel()	
	if not optionsPanel then
		optionsPanel = createOptionsPanel()
		optionsPanel:Hide()
	end

	for i = 0, 4 do
		local bagName = C_Container.GetBagName( i )
		if bagName ~= nil then
			-- ChaChing has marked this slot EMPTY, but Blizz says the slot is OCCUPIED.
			-- We assume Blizz is correct so we need to create a bag Icon for this slot
			-- and then mark it as occupied,
			if optionsPanel.Bags[i+1] == nil then
				optionsPanel.Bags[i+1] = createBagIcon( optionsPanel, i )
				inventorySlot[i+1] = OCCUPIED
			end
			local bag = optionsPanel.Bags[i+1]
			if bag == nil then return end
			-- print( dbg:prefix(), "UpdateOptionsPanel: Bag slot", i, "contains bag ", bagName )

			local freeSlots = C_Container.GetContainerNumFreeSlots(i)

			if bag.NumFreeSlots ~= freeSlots then
				bag.NumFreeSlots = freeSlots
				bag.Caption:SetFormattedText( "%s: %d %s", bag.BagName, freeSlots, L["AVAILABLE_SLOTS"] )
			end
			inventorySlot[i+1] = OCCUPIED		-- probably redundant
		else 
			-- No bag is installed in this slot.
			local bag = optionsPanel.Bags[i+1]
			if bag then 
				bag:Hide() 
			end
			inventorySlot[i+1] = EMPTY
		end
	end
end
function options:showOptionsPanel()
	optionsPanel:Show()
end

local eventFrame = CreateFrame("Frame" )
eventFrame:RegisterEvent("BAG_UPDATE")		-- payload = bagSlot
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("MERCHANT_CLOSED")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", 
function( self, event, ... )
	local arg1 = ...

	if event == "BAG_UPDATE" or event == "BAG_UPDATE_DELAYED" then
		updateOptionsPanel()
	end
	if event == "MERCHANT_CLOSED" then
		optionsPanel:Hide()
	end
	if event == "ADDON_LOADED" and arg1 == ADDON_NAME then

		if not CHACHING_SAVED_OPTIONS then
			CHACHING_SAVED_OPTIONS = {}

			-- default options
			CHACHING_SAVED_OPTIONS.sellGrey = true
			CHACHING_SAVED_OPTIONS.sellWhite = false
		end

		if not ChaChing_ExcludedItemsList then
			ChaChing_ExcludedItemsList = {}
		end

		item:setGreyChecked( CHACHING_SAVED_OPTIONS.sellGrey )
		item:setWhiteChecked( CHACHING_SAVED_OPTIONS.sellWhite )

		DEFAULT_CHAT_FRAME:AddMessage( L["ADDON_LOADED_MESSAGE"] )
		eventFrame:UnregisterEvent( "ADDON_LOADED")
	end
end)

local fileName = "OptionsMenu.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 1.0, 1.0, 0.0 )
end
