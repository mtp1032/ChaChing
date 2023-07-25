-- OptionsMenu.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 11 January, 2023
--------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.OptionsMenu = {}
options = ChaChing.OptionsMenu

local L = ChaChing.L
local sprintf = _G.string.format

local SUCCESS 			= core.SUCCESS
local FAILURE 			= core.FAILURE
local EMPTY_STR 		= core.EMPTY_STR

local sellGrey 	= true
local sellWhite = false

local sellAll = false

local GreyQualityButton = nil
local WhiteQualityButton = nil

local optionsPanel = nil

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
	GreyQualityButton:SetChecked( sellGrey )
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
	WhiteQualityButton:SetChecked( sellWhite )
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
				item:setBagChecked( bagName, bagSlot )
			else
				item:setBagUnchecked( bagName, bagSlot )
			end
		end)
end -- end of OnClick

local function createBagIcon( f, bagName, caption, bagSlot )

	local iconFrame = CreateFrame("Button","CHACHING_BagButton", f,"TooltipBackdropTemplate")

	iconFrame.BagName 		= bagName
	iconFrame.BagSlot 		= bagSlot
	iconFrame.BagIndex 		= bagSlot + 1
	iconFrame.NumFreeSlots	= C_Container.GetContainerNumFreeSlots(bagSlot)
	iconFrame.Caption 		= caption

	if bagSlot == 0 then
		iconFrame.IconFileId = "bag-main"
	else
		iconFrame.IconFileId = GetItemIcon( iconFrame.BagName )
	end

	iconFrame.tooltip = L["BAG_TOOLTIP"]
	iconFrame:SetSize( BUTTON_WIDTH, BUTTON_HEIGHT )

		-- Position bag buttons icons vertically
	iconFrame.xPos = 60
	iconFrame.yPos = 120 - (BUTTON_HEIGHT + 10) * ( iconFrame.BagIndex )

	-- This positions the bag icon.
	iconFrame:SetPoint( "LEFT", iconFrame.xPos, iconFrame.yPos )
	createBagCheckBox( iconFrame, iconFrame.BagSlot, iconFrame.xPos, iconFrame.yPos )

	local msg = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	msg:SetJustifyH("LEFT")
	-- This positions the icon text
	msg:SetPoint("LEFT", iconFrame.xPos + (BUTTON_WIDTH + 30), iconFrame.yPos )
	msg:SetText( iconFrame.Caption )
	iconFrame.message = msg

	iconFrame.Texture = iconFrame:CreateTexture(nil,"ARTWORK")
	iconFrame.Texture:SetPoint("TOPLEFT",3,-3)
	iconFrame.Texture:SetPoint("BOTTOMRIGHT",-3,3)
	iconFrame.Texture:SetTexCoord(0.075,0.925,0.075,0.925) -- trim off icon's edges

	iconFrame:SetNormalTexture(iconFrame.IconFileId)
	iconFrame:SetHighlightTexture(iconFrame.IconFileId )
	iconFrame:GetHighlightTexture():SetAlpha(0.8)

	iconFrame.Mask = iconFrame:CreateMaskTexture(nil,"ARTWORK")
	iconFrame.Mask:SetPoint("TOPLEFT",iconFrame.Texture,"TOPLEFT")
	iconFrame.Mask:SetPoint("BOTTOMRIGHT",iconFrame.Texture,"BOTTOMRIGHT")
	iconFrame.Mask:SetTexture("Interface\\Common\\common-iconmask.blp")
	iconFrame.Texture:AddMaskTexture(iconFrame.Mask)

	-- iconFrame:RegisterForClicks("LeftButtonDown", "RightButtonDown" )
	iconFrame:SetScript("OnClick", 
	function ( self, iconFrame )
		if iconFrame == "LeftButton" and not IsShiftKeyDown() then
			item:setBagChecked( bagSlot )
		end
		if iconFrame == "RightButton" and not IsShiftKeyDown() then
			item:clearBagChecked( bagSlot )
		end
		if iconFrame == "LeftButton" and IsShiftKeyDown() then
			item:uncheckAllBags( bagSlot )
		end
		if iconFrame == "RightButton" and IsShiftKeyDown() then
			item:clearBagChecked( bagSlot )
		end
	end)
	return iconFrame
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
	frame.title:SetText("ChaChing Options Menu")

	-- Title text
	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.text:SetPoint("TOPLEFT", 12, -22)
	frame.text:SetWidth(frame:GetWidth() - 20)
	frame.text:SetJustifyH("LEFT")
	frame:SetHeight(frame.text:GetHeight() + 70)
	tinsert( UISpecialFrames, frame:GetName() )
	frame:SetSize( FRAME_WIDTH, FRAME_HEIGHT )

	-------------------- INTRO HEADER -----------------------------------------
	local subTitle = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
	local msgText = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
	local displayString = sprintf("%s", L["ADDON_NAME_AND_VERSION"] )
	msgText:SetPoint("TOP", 0, -20)
	msgText:SetText(displayString)

	-------------------- WARNING ---------------------------------------
	local str1 = sprintf("Checking any of these bag icons will cause %s to sell \n", L["ADDON_NAME"]  )
	local str2 = sprintf("ALL items in the selected bag the next time you visit a merchant.")
	local msgText = sprintf("%s%s\n", str1, str2 )

	local messageText = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
	messageText:SetJustifyH("LEFT")
	messageText:SetPoint("CENTER", 0, 150)
	messageText:SetText( msgText )
	frame.messageText = messageText

	-------------------- WARNING DESCRIPTION ---------------------------------------

	showGreyWhiteCheckBoxes( frame, -80 )
	-- drawLine( 150, frame )

	frame.BagIcons = {}	
	for i = 0, 4 do
		local bagName = C_Container.GetBagName( i )
		if bagName ~= nil then
			local freeSlots = C_Container.GetContainerNumFreeSlots( i )
			local caption = sprintf("%s: %d available slots.", bagName, freeSlots )
			local iconFrame = createBagIcon( frame, bagName, caption, i  )
			frame.BagIcons[i + 1] = iconFrame
		end
	end

	-- Defaults buttom, bottom left
	frame.hide = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.hide:SetText("Default")
	frame.hide:SetHeight(20)
	frame.hide:SetWidth(80)
	frame.hide:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 8)
	frame.hide:SetScript("OnClick",         
		function(self)
			CHACHING_SAVED_OPTIONS.sellGrey = true
			CHACHING_SAVED_OPTIONS.sellWhite = false
			item:setBagDefaults()
			frame:Hide()
	end)

	-- Accept buttom, bottom right
	frame.hide = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.hide:SetText("Accept")
	frame.hide:SetHeight(20)
	frame.hide:SetWidth(80)
	frame.hide:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
	frame.hide:SetScript("OnClick",
		function( self )
			frame:Hide()
		end)

	-- Create the Exclusion List Input Edit Box
	local DescrSubHeader = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
	DescrSubHeader:SetPoint("LEFT", 60, -250 )
	DescrSubHeader:SetText("Excluded Item List" )
	local f = CreateFrame("EditBox", "InputEditBox", frame, "InputBoxTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetSize(200,75)
	f:SetAutoFocus(false)
	-- f.tooltip = sprintf("Drag and drop items to be excluded into the Edit Box.")
	f:SetPoint("CENTER", 25, -250) 
	f:SetScript("OnMouseUp", 
		function(self,button)
			cursorInfo, itemId, itemLink = GetCursorInfo()
			if cursorInfo == "item" then
				local itemName = GetItemInfo( itemId )
				-- insert the name of the item, not the item link
				item:addExcludedItem( itemName )
				local s = sprintf("   %s will be excluded", itemName )
				f:SetText( s )	-- prints the item's name into the chat dialog box
			else
				f:SetText(EMPTY_STR)
			end
			ClearCursor()
	end)

	return frame   
end

function options:showOptionsPanel()
	if not optionsPanel then
		optionsPanel = createOptionsPanel()
	end

	for i = 0, 4 do
		local bagSlot = i
		local bagName = C_Container.GetBagName( i )
		if bagName ~= nil then
			local freeSlots = C_Container.GetContainerNumFreeSlots(i)
			local caption = sprintf("%s: %d available slots.", bagName, freeSlots)
			optionsPanel.BagIcons[i+1].message:Hide()
			optionsPanel.BagIcons[i+1].message:SetText( caption )
			optionsPanel.BagIcons[i+1].message:Show()
			local xPos = optionsPanel.BagIcons[i+1].xPos
			local yPos = optionsPanel.BagIcons[i+1].yPos
		end
	end
	optionsPanel:Show()
end
function options:hideOptionsPanel()
	optionsPanel:Hide()
end

local eventFrame = CreateFrame("Frame" )
eventFrame:RegisterEvent("BAG_UPDATE")				-- bagID
eventFrame:RegisterEvent("MERCHANT_CLOSED")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", 
function( self, event, ... )
	local arg1 = ...
	-- Fires once per bag. Moving an item causes it to fire twice. Once when picked up
	-- and once when dropped.
	if event == "BAG_UPDATE" then
		local bagSlot = ...
		for bagSlot = 0, 4 do
			local bagName = C_Container.GetBagName( bagSlot )
			if bagName ~= nil then
				-- DEFAULT_CHAT_FRAME:AddMessage( sprintf("[%s] %s updated.", event, bagName ), 0, 1, 0)
			end
		end
	end
	if event == "MERCHANT_CLOSED" then
		optionsPanel:Hide()
	end
	if event == "ADDON_LOADED" and arg1 == L["ADDON_NAME"] then

		if not CHACHING_SAVED_OPTIONS then
			CHACHING_SAVED_OPTIONS = {}

			-- default options
			CHACHING_SAVED_OPTIONS = {true, false }
			-- CHACHING_SAVED_OPTIONS.sellGrey = true
			-- CHACHING_SAVED_OPTIONS.sellWhite = false
		end

		if CHACHING_EXCLUSION_LIST == nil then
			CHACHING_EXCLUSION_LIST = {}
		end

		DEFAULT_CHAT_FRAME:AddMessage( L["ADDON_NAME_AND_VERSION"],  1.0, 1.0, 0.0 )
		eventFrame:UnregisterEvent( "ADDON_LOADED")
	end

end)

local fileName = "OptionsMenu.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s loaded", fileName), 1.0, 1.0, 0.0 )
end




