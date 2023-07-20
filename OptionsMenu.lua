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

local GreyQualityButton = nil
local WhiteQualityButton = nil

local LINE_SEGMENT_LENGTH = 575
local X_START_POINT = 10
local Y_START_POINT = 10

------------------------------ FRAME DIMENSIONS ------------
local FRAME_WIDTH = 600
local FRAME_HEIGHT = 700
local WIDTH_TITLE_BAR = 500
local HEIGHT_TITLE_BAR = 45

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
local function createBagIcon( f, bagName, iconFileId, bagSlot )
	local BUTTON_WIDTH  = 48
	local BUTTON_HEIGHT = 48

	local bagIcon = CreateFrame("Button","CHACHING_BagButton", f,"TooltipBackdropTemplate")

	bagIcon.BagName = bagName
	bagIcon.BagSlot = bagSlot
	bagIcon.BagIndex = bagSlot + 1

	bagIcon.tooltip = L["BAG_TOOLTIP"]
	local freeSlots = C_Container.GetContainerNumFreeSlots( bagSlot)
	bagIcon.Lable = sprintf("%s: %d free slots.", bagName, freeSlots )

	bagIcon:SetSize( BUTTON_WIDTH, BUTTON_HEIGHT )

		-- Position bag buttons icons vertically
	bagIcon.xPos = 60
	bagIcon.yPos = 150 - (BUTTON_HEIGHT + 10) * ( bagIcon.BagIndex )
	bagIcon:SetPoint( "LEFT", bagIcon.xPos, bagIcon.yPos )


	local message = f:CreateFontString(nil, "ARTWORK","GameFontNormal")
	message:SetJustifyH("LEFT")
	message:SetPoint("LEFT", bagIcon.xPos + (BUTTON_WIDTH + 20), bagIcon.yPos )
	message:SetText( bagIcon.Lable )

	bagIcon.Texture = bagIcon:CreateTexture(nil,"ARTWORK")
	bagIcon.Texture:SetPoint("TOPLEFT",3,-3)
	bagIcon.Texture:SetPoint("BOTTOMRIGHT",-3,3)
	bagIcon.Texture:SetTexCoord(0.075,0.925,0.075,0.925) -- trim off icon's edges

	bagIcon:SetNormalTexture(iconFileId)
	bagIcon:SetHighlightTexture(iconFileId )
	bagIcon:GetHighlightTexture():SetAlpha(0.8)

	bagIcon.Mask = bagIcon:CreateMaskTexture(nil,"ARTWORK")
	bagIcon.Mask:SetPoint("TOPLEFT",bagIcon.Texture,"TOPLEFT")
	bagIcon.Mask:SetPoint("BOTTOMRIGHT",bagIcon.Texture,"BOTTOMRIGHT")
	bagIcon.Mask:SetTexture("Interface\\Common\\common-iconmask.blp")
	bagIcon.Texture:AddMaskTexture(bagIcon.Mask)

	bagIcon:RegisterForClicks("AnyDown")
	bagIcon:SetScript("OnClick", 
	function ( self )
		item:setBagChecked( bagIcon.BagSlot )
	end)
	return bagIcon
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
local function createOptionsPanel()
	if optionsPanel ~= nil then
		return optionsPanel
	end
		
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

    -------------------- WARNING DESCRIPTION ---------------------------------------

	showGreyWhiteCheckBoxes( frame, -80 )
	-- drawLine( 150, frame )

	frame.BagIcons = {}
	local bagIndex = 1
	-- bag-main = MainMenuBarBackpackButton:GetSlotAtlases()
	frame.BagIcons[bagIndex] = createBagIcon( frame, "Player's Backpack", "bag-main", 0  )

	for bagIndex = 2, 5 do
		local bagSlot = bagIndex - 1
		local bagName = C_Container.GetBagName( bagSlot )
		if bagName ~= nil then
			local iconFileId = GetItemIcon( bagName )
			frame.BagIcons[bagIndex] = createBagIcon( frame, bagName, iconFileId, bagSlot  )
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
			item:initBagTable()
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
			for bagSlot = 0, 4 do
				local bagName = C_Container.GetBagName( bagSlot )
				if bagName ~= nil then
					local freeSlots = C_Container.GetContainerNumFreeSlots( bagSlot )
					frame.BagIcons[bagSlot+1].Lable = sprintf("%s has %d free slots.", bagName, freeSlots )
		 			-- print( dbg:prefix(), frame.BagIcons[bagSlot+1].Lable )
				end
			end
			frame:Hide()
		end)

    -- Create the Exclusion List Input Edit Box
	local DescrSubHeader = frame:CreateFontString(nil, "ARTWORK","GameFontNormalLarge")
    DescrSubHeader:SetPoint("CENTER", 0, -275 )
	DescrSubHeader:SetText("Excluded Item List" )
	local f = CreateFrame("EditBox", "InputEditBox", frame, "InputBoxTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetSize(200,75)
	f:SetAutoFocus(false)
	f:SetPoint("CENTER", 0, -250) 
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
local optionsPanel = createOptionsPanel()

function options:showOptionsPanel()
	sellGrey = CHACHING_SAVED_OPTIONS.sellGrey
	sellWhite = CHACHING_SAVED_OPTIONS.sellWhite
	optionsPanel:Show()
end
function options:hideOptionsPanel()
	optionsPanel:Hide()
end

local eventFrame = CreateFrame("Frame" )
eventFrame:RegisterEvent("BAG_UPDATE")				-- bagID

eventFrame:SetScript("OnEvent", 
function( self, event, ... )
	local arg1 = ...
	-- Fires once per bag. Moving an item causes it to fire twice. Once when picked up
	-- and once when dropped.
	if event == "BAG_UPDATE" then
		local bagSlot = ...
		local bagName = C_Container.GetBagName( bagSlot )
		local freeSlots = C_Container.GetContainerNumFreeSlots( bagSlot )
		optionsPanel.BagIcons[bagSlot +1].Lable = sprintf("[%s] %s updated - has %d free slots.", event, bagName, freeSlots) 
		-- print( dbg:prefix(), optionsPanel.BagIcons[bagSlot +1].Lable)
		DEFAULT_CHAT_FRAME:AddMessage( sprintf("[%s] %s updated - has %d free slots.", event, bagName, freeSlots), 0, 1, 0)
	end
end)

local fileName = "OptionsMenu.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s loaded", fileName), 1.0, 1.0, 0.0 )
end
