--------------------------------------------------------------------------------------
-- MsgFrame.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 12 January, 2019
----------------------------------------------------------------------------------------
local AddonName, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.MsgFrame = {}

local core      = ChaChing.Core
local dbg       = ChaChing.DebugTools
local item      = ChaChing.Item
local msgFrame  = ChaChing.MsgFrame

local L = ChaChing.L

local FRAME_WIDTH_DEFAULT = 900
local FRAME_HEIGHT_DEFAULT = 600

local DEFAULT_XPOS = 0
local DEFAULT_YPOS = 200

local DEFAULT_FRAME_WIDTH = 600
local DEFAULT_FRAME_HEIGHT = 500

local messageFrame = nil
local errorMsgFrame = nil

 ---------------------------------------------------------------------------------------------------
 --                     Create the MAIN FRAME
 ---------------------------------------------------------------------------------------------------
 local function createTopFrame( frameTitle, width, height )
    local topFrame = CreateFrame("Frame", "EXCLUDED_ITEMS", UIParent, BackdropTemplateMixin and "BackdropTemplate" )
    topFrame:SetSize(width, height)
    topFrame:SetPoint("CENTER", 0, 200)
    topFrame:SetFrameStrata("BACKGROUND")
	topFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 26,
        insets = {left = 9, right = 9, top = 9, bottom = 9},
    })
    topFrame:SetBackdropColor(0, 0, 0)
    topFrame:EnableMouse(true)
    topFrame:EnableMouseWheel(true)
    topFrame:SetMovable(true)
    topFrame:Hide()
    topFrame:RegisterForDrag("LeftButton")
    topFrame:SetScript("OnDragStart", topFrame.StartMoving)
    topFrame:SetScript("OnDragStop", topFrame.StopMovingOrSizing)
    
    -- Create the title bar
    local titleBar = CreateFrame("Frame", nil, topFrame, BackdropTemplateMixin and "BackdropTemplate")
    titleBar:SetPoint("TOPLEFT", topFrame, "TOPLEFT", 10, -10)
    titleBar:SetPoint("TOPRIGHT", topFrame, "TOPRIGHT", -30, -10)
    titleBar:SetHeight(30)
    titleBar:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 14,
    })
    titleBar:SetBackdropColor(0.1, 0.1, 0.1, 1)
    
    -- Add the title to the title bar
    local titleText = titleBar:CreateFontString(nil, "OVERLAY")
    titleText:SetFontObject("GameFontHighlight")
    titleText:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
    titleText:SetText(frameTitle)

    topFrame.titleBar = titleBar
    topFrame.titleText = titleText

    return topFrame
 end

----------------------------------------------------------------------------------------------------
--                      Create the Buttons
----------------------------------------------------------------------------------------------------

local function createResizeButton( f )
    f:SetResizable(true)
	local resizeButton = CreateFrame("Button", nil, f)
	resizeButton:SetSize(16, 16)
	resizeButton:SetPoint("BOTTOMRIGHT")
	resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	resizeButton:SetScript("OnMouseDown", function(self, button)
    	f:StartSizing("BOTTOMRIGHT")
    	f:SetUserPlaced(true)
	end)
 
	resizeButton:SetScript("OnMouseUp", function(self, button)
		f:StopMovingOrSizing()
        FRAME_WIDTH, FRAME_HEIGHT = f:GetSize()
	end)
end
local function createReloadButton( f )
    local reloadButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    reloadButton:SetPoint("BOTTOM", -200, 10)
    reloadButton:SetHeight(25)
    reloadButton:SetWidth(70)
    reloadButton:SetText("Reload")
    reloadButton:SetScript("OnClick", 
        function(self)
            ReloadUI()
        end)
    f.reloadButton = reloadButton
end
local function createSelectButton(f)
    local selectButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    selectButton:SetPoint("BOTTOMRIGHT", -10, 10)
    selectButton:SetHeight(25)
    selectButton:SetWidth(70)
    selectButton:SetText("Select")
    selectButton:SetScript("OnClick", 
        function(self)
            local editBox = self:GetParent().Text
            editBox:SetFocus() -- Set focus to the edit box
            editBox:HighlightText() -- Highlight all the text
            editBox:EnableKeyboard(true) -- Ensure the EditBox can receive keyboard input
            editBox:EnableMouse(true) -- Ensure the EditBox can receive mouse input
            -- You may also force the user to press "Enter" to finalize the selection
            -- and then notify them to press Ctrl+C to copy
            print("Text selected! Press Ctrl+C to copy.")
        end)
    f.selectButton = selectButton
end
local function createRemoveButton( f )
    local removeButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")

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
        wipe( ChaChing_ExcludedItemsList )
        f:Hide()
    end)
    f.removeButton = removeButton
end
local function createDismissButton( f )
    local dismissButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    dismissButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -10)
    dismissButton:SetHeight(25)
    dismissButton:SetWidth(25)
    dismissButton:SetText("X")
    dismissButton:SetNormalFontObject("GameFontNormalSmall")
    dismissButton:SetScript("OnClick", 
        function(self)
            f:Hide()
        end)
    f.dismissButton = dismissButton
end
local function createClearButton( f )
    local clearButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    clearButton:SetPoint("BOTTOMLEFT", 10, 10)
    clearButton:SetHeight(25)
    clearButton:SetWidth(70)
    clearButton:SetText("Clear")
    clearButton:SetScript("OnClick", 
        function(self)
            self:GetParent().Text:SetText("") 
            self:GetParent().Text:ClearFocus()
        end)
    f.clearButton = clearButton
end

----------------------------------------------------------------------------------------------------
--                      Create the Scrollbar and the EditBox frames
----------------------------------------------------------------------------------------------------
local function createTextDisplay(f)
    f.SF = CreateFrame("ScrollFrame", "$parent_DF", f, "UIPanelScrollFrameTemplate")
    f.SF:SetPoint("TOPLEFT", f, 12, -40)
    f.SF:SetPoint("BOTTOMRIGHT", f, -30, 50)

    --                  Now create the EditBox
    f.Text = CreateFrame("EditBox", nil, f)
    f.Text:SetMultiLine(true)
    f.Text:SetSize(FRAME_WIDTH_DEFAULT - 20, FRAME_HEIGHT_DEFAULT)
    f.Text:SetPoint("TOPLEFT", f.SF)
    f.Text:SetPoint("BOTTOMRIGHT", f.SF)
    f.Text:SetMaxLetters(99999)
    f.Text:SetFontObject(GameFontNormalLarge)
    f.Text:SetHyperlinksEnabled(true)
    f.Text:SetTextInsets(5, 5, 5, 5)
    f.Text:SetAutoFocus(false)
    f.Text:EnableMouse(true)
    f.Text:EnableKeyboard(true)
    f.Text:SetScript("OnEscapePressed", 
        function(self) 
            self:ClearFocus() 
        end) 
    f.SF:SetScrollChild(f.Text)
end

local function createPostMsgFrame( title, width, height )
    local f = createTopFrame( title, DEFAULT_FRAME_WIDTH, DEFAULT_FRAME_HEIGHT )
    f:SetPoint("CENTER", DEFAULT_XPOS, DEFAULT_YPOS - 200 )
    f:SetFrameStrata("BACKGROUND")
    f:EnableMouse(true)
    f:EnableMouseWheel(true)
    f:SetMovable(true)
    f:Hide()
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    createTextDisplay(f)
    createResizeButton(f)
    -- createReloadButton(f)
    createSelectButton(f)
    createClearButton(f)
    createDismissButton(f)

    return f
end

function msgFrame:post( msg )
    if messageFrame == nil then
        messageFrame = createPostMsgFrame( "ChaChing Messages", 600, 400 )
    end
    messageFrame:Show()
    messageFrame.Text:SetText( msg )
end

function msgFrame:createListFrame( frameTitle )
    local f = createTopFrame( frameTitle, 500, 300 )
    createRemoveButton(f)
    createDismissButton(f)
    createTextDisplay(f)
    return f
end

local function createErrorMsgFrame(title)
    local f = createTopFrame( "ErrorMsgFrame", 700, 400 )
    f:SetPoint("CENTER", DEFAULT_XPOS, DEFAULT_YPOS)
    f:SetFrameStrata("BACKGROUND")
    f:EnableMouse(true)
    f:EnableMouseWheel(true)
    f:SetMovable(true)
    f:Hide()
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    createTextDisplay(f)
    createResizeButton(f)
    createReloadButton(f)
    createSelectButton(f)
    createClearButton(f)
    createDismissButton(f)

    return f
end

function msgFrame:postResult(result)
    if coreL:debuggingIsEnabled() then 
        assert(result ~= nil, L["INPUT_PARAM_NIL"])
        assert(type(result) == "table", L["INVALID_TYPE"])
        assert(#result == 3, L["PARAM_ILL_FORMED"])
    end

    if errorMsgFrame == nil then
        errorMsgFrame = createErrorMsgFrame("ChaChing Error Message(s)")
    end
    
    local str = nil
    if result[3] ~= nil then
        str = string.format("%s\nSTACK TRACE:\n%s\n", result[2], result[3])
    else
        str = string.format("%s", result[2])
    end

    -- Append text to the EditBox
    local existingText = errorMsgFrame.Text:GetText() or ""
    errorMsgFrame.Text:SetText(existingText .. "\n" .. str)

    errorMsgFrame:Show()
end

local fileName = "MsgFrame.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s loaded", fileName), 1.0, 1.0, 0.0 )
end
