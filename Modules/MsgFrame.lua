--------------------------------------------------------------------------------------
-- MsgFrame.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 12 January, 2019
----------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.MsgFrame = {}
mf = ChaChing.MsgFrame
L = ChaChing.L
local E = errors
local sprintf = _G.string.format
local exclusionTable = CHACHING_SAVED_VARS[3]

local FRAME_WIDTH_DEFAULT = 900
local FRAME_HEIGHT_DEFAULT = 600
-- local FRAME_MAX_LINES = 2000 

-- local TRUE = 1
-- local FALSE = 0

local backdrop = {
	bgFile      = "Interface/BUTTONS/WHITE8X8",
	edgeFile    = "Interface/GLUES/Common/Glue-Tooltip-Border",
	tile        = true,
	edgeSize    = 8,
	tileSize    = 8,
	insets      = {
		    left = 5,
		    right = 5,
		    top = 5,
		    bottom = 5,
	        },
}

 ---------------------------------------------------------------------------------------------------
 --                     Create the MAIN FRAME
 ---------------------------------------------------------------------------------------------------
 local function createTopFrame( frameTitle, width, height )
    local topFrame = CreateFrame("Frame", "MsgFrame", UIParent, "BasicFrameTemplateWithInset")
    topFrame:SetSize(width, height)
    -- topFrame:SetPoint("CENTER")     -- ORIGINAL
    topFrame:SetPoint("CENTER", 0, 200)
    topFrame:SetFrameStrata("BACKGROUND")
    topFrame:SetBackdrop(backdrop)
    topFrame:SetBackdropColor(0, 0, 0) -- https://www.sessions.edu/color-calculator-results/?colors=37630e,630e37
    topFrame:EnableMouse(true)
    topFrame:EnableMouseWheel(true)
    topFrame:SetMovable(true)
    topFrame:Hide()
    topFrame:RegisterForDrag("LeftButton")
    topFrame:SetScript("OnDragStart", topFrame.StartMoving)
    topFrame:SetScript("OnDragStop", topFrame.StopMovingOrSizing)
    
    topFrame.title = topFrame:CreateFontString(nil, "OVERLAY");
    topFrame.title:SetFontObject("GameFontHighlight");
    topFrame.title:SetPoint("CENTER", topFrame.TitleBg, "CENTER", 5, 0);
    topFrame.title:SetText(frameTitle);

    return topFrame
 end
----------------------------------------------------------------------------------------------------
--                      Create the Buttons
----------------------------------------------------------------------------------------------------
local function createReloadButton( f )
    local reloadButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    reloadButton:SetPoint("BOTTOM", -200, 10) -- was -175, 10
    reloadButton:SetHeight(25)
    reloadButton:SetWidth(70)
    reloadButton:SetText("Reload")
    reloadButton:SetScript("OnClick", 
        function(self)
            ReloadUI()
        end)
    f.reloadButton = reloadButton
end

local function createSelectButton( f )
    local selectButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    selectButton:SetPoint("BOTTOM", 185, 10)

    selectButton:SetHeight(25)
    selectButton:SetWidth(70)
    selectButton:SetText("Select")
    selectButton:SetScript("OnClick", 
        function(self)
            self:GetParent().Text:EnableMouse( true )    
            self:GetParent().Text:EnableKeyboard( true )   
            self:GetParent().Text:HighlightText() -- parameters (start, end) or default all
            self:GetParent().Text:SetFocus()
        end)
    f.selectButton = selectButton
end

local function createRemoveButton( parentFrame )
    local removeButton = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    removeButton:SetPoint("BOTTOM", 160, 10)
    removeButton:SetHeight(25)
    removeButton:SetWidth(120)
    removeButton:SetText("Remove Entries")
    removeButton:SetScript("OnClick", 
        function(self)
            self:GetParent().Text:EnableMouse( false )    
            self:GetParent().Text:EnableKeyboard( false )   
            self:GetParent().Text:SetText("") 
			self:GetParent().Text:ClearFocus()
			si:clearExclusionTable()
           end)
    parentFrame.removeButton = removeButton
end

local function createDismissButton( parentFrame )
    local dismissButton = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    dismissButton:SetPoint("BOTTOM", -190, 10)
    dismissButton:SetHeight(25)
    dismissButton:SetWidth(75)
    dismissButton:SetText("Dismiss")
    dismissButton:SetScript("OnClick", 
        function(self)
            self:GetParent().Text:EnableMouse( false )    
            self:GetParent().Text:EnableKeyboard( false )   
            self:GetParent().Text:SetText("") 
			self:GetParent().Text:ClearFocus()
			parentFrame:Hide()
        end)
    parentFrame.dismissButton = dismissButton
end

local function createClearButton( parentFrame )
    local clearButton = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
    clearButton:SetPoint("BOTTOM", -190, 10)
    clearButton:SetHeight(25)
    clearButton:SetWidth(75)
    clearButton:SetText("Dismiss")
    clearButton:SetScript("OnClick", 
        function(self)
            self:GetParent().Text:EnableMouse( false )    
            self:GetParent().Text:EnableKeyboard( false )   
            self:GetParent().Text:SetText("") 
			self:GetParent().Text:ClearFocus()
			parentFrame:Hide()
        end)
    parentFrame.clearButton = clearButton
end

----------------------------------------------------------------------------------------------------
--                      Create the Scrollbar and the EditBox frames
----------------------------------------------------------------------------------------------------
local function createTextDisplay(f)
    f.SF = CreateFrame("ScrollFrame", "$parent_DF", f, "UIPanelScrollFrameTemplate")
    f.SF:SetPoint("TOPLEFT", f, 12, -30)
    f.SF:SetPoint("BOTTOMRIGHT", f, -30, 40)

    --                  Now create the EditBox
    f.Text = CreateFrame("EditBox", nil, f)
    f.Text:SetMultiLine(true)
    f.Text:SetSize(FRAME_WIDTH_DEFAULT - 20, FRAME_HEIGHT_DEFAULT )
    f.Text:SetPoint("TOPLEFT", f.SF)    -- ORIGINALLY TOPLEFT
    f.Text:SetPoint("BOTTOMRIGHT", f.SF) -- ORIGINALLY BOTTOMRIGHT
    f.Text:SetMaxLetters(99999)
    f.Text:SetFontObject(GameFontNormalLarge) -- https://wowwiki.fandom.com/wiki/API_Button_SetTextFontObject
    f.Text:SetHyperlinksEnabled( true )
    f.Text:SetTextInsets(5, 5, 5, 5, 5)
    f.Text:SetAutoFocus(false)
    f.Text:EnableMouse( false )
    f.Text:EnableKeyboard( false )
    f.Text:SetScript("OnEscapePressed", 
        function(self) 
            self:ClearFocus() 
        end) 
    f.SF:SetScrollChild(f.Text)
end

local function createMsgFrame()
    local f = createTopFrame("Messages", FRAME_WIDTH_DEFAULT, FRAME_HEIGHT_DEFAULT )
    createReloadButton(f)
    createSelectButton(f)
    createClearButton(f)
    createTextDisplay(f)
    return f
end

local function createListFrame()
    local f = createTopFrame("ChaChing Excluded Items", 500, 300 )
    createRemoveButton(f)
    createDismissButton(f)
    createTextDisplay(f)
    return f
end

local msgFrame = createMsgFrame()
local listFrame = createListFrame()

function mf:getListFrame()
    if msgFrame == nil then
        msgFrame = createMsgFrame()
        listFrame = createListFrame
    end
    return listFrame
end
