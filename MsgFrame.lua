--------------------------------------------------------------------------------------
-- MsgFrame.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 12 January, 2019
----------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.MsgFrame = {}
mf = select(2, ... )

L = ChaChing.L
local sprintf = _G.string.format
local EMPTY_STR = core.EMPTY_STR

local FRAME_WIDTH_DEFAULT = 900
local FRAME_HEIGHT_DEFAULT = 600

local DEFAULT_XPOS = 0
local DEFAULT_YPOS = 200

local DEFAULT_FRAME_WIDTH = 600
local DEFAULT_FRAME_HEIGHT = 500

 ---------------------------------------------------------------------------------------------------
 --                     Create the MAIN FRAME
 ---------------------------------------------------------------------------------------------------
 local function createTopFrame( frameTitle, width, height )
    local topFrame = CreateFrame("Frame", "EXCLUDED_ITEMS", UIParent, BackdropTemplateMixin and "BackdropTemplate" )
    topFrame:SetSize(width, height)
    -- topFrame:SetPoint("CENTER")     -- ORIGINAL
    topFrame:SetPoint("CENTER", 0, 200)
    topFrame:SetFrameStrata("BACKGROUND")
	topFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 26,
        insets = {left = 9, right = 9, top = 9, bottom = 9},
    })
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
local function createResizeButton( f )
    f:SetResizable( true )
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
            self:GetParent().Text:EnableMouse( false )    
            self:GetParent().Text:EnableKeyboard( false )   
            self:GetParent().Text:SetText("") 
            self:GetParent().Text:ClearFocus()
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
        item:clearExcludedItems()
        f:Hide()
    end)
    f.removeButton = removeButton
end
local function createDismissButton( f )
    local dismissButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    dismissButton:SetPoint("BOTTOM", -190, 10)
    dismissButton:SetHeight(25)
    dismissButton:SetWidth(75)
    dismissButton:SetText("Dismiss")
    dismissButton:SetScript("OnClick", 
    function(self)
        f.Text:EnableMouse( false )    
        f.Text:EnableKeyboard( false )   
        f.Text:SetText(EMPTY_STR) 
        f.Text:ClearFocus()
        f:Hide()
    end)
    f.dismissButton = dismissButton
end
local function createClearButton( f )
    local clearButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
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
			self:GetParent():Hide()
        end)
    f.clearButton = clearButton
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
local function createPostMsgFrame( title, width, height )
    local f = createTopFrame( "Messages", DEFAULT_FRAME_WIDTH, DEFAULT_FRAME_HEIGHT )
    f:SetPoint("CENTER", DEFAULT_XPOS, DEFAULT_YPOS - 200 )
    f:SetFrameStrata("BACKGROUND")
    f:EnableMouse(true)
    f:EnableMouseWheel(true)
    f:SetMovable(true)
    f:Hide()
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    f.title = f:CreateFontString(nil, "OVERLAY")
    f.title:SetFontObject("GameFontHighlightLarge")
    f.title:SetPoint("CENTER", f.TitleBg, "CENTER", 5, 0)
    f.title:SetText( title)
    
    createTextDisplay(f)

    createResizeButton(f)
    createReloadButton(f, "BOTTOMLEFT",f, 5, 5)
    createSelectButton(f, "BOTTOMRIGHT",f, 5, -10)
    createClearButton(f, "BOTTOM",f, 5, 5)
    return f
end
function mf:postMsg( msg )
    if msgFrame == nil then
        msgFrame = createPostMsgFrame( INFO_MSG_TITLE, 600, 400 )
    end
    msgFrame:Show()
    msgFrame.Text:Insert( msg )
end

function mf:createListFrame( frameTitle )
    local f = createTopFrame( frameTitle, 500, 300 )
    createRemoveButton(f)
    createDismissButton(f)
    createTextDisplay(f)
    return f
end
local function createErrorMsgFrame(title)
    local f = createTopFrame( "ErrorMsgFrame",700, 400 )
    f:SetPoint("CENTER", DEFAULT_XPOS, DEFAULT_YPOS)
    f:SetFrameStrata("BACKGROUND")
    f:EnableMouse(true)
    f:EnableMouseWheel(true)
    f:SetMovable(true)
    f:Hide()
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    f.title = f:CreateFontString(nil, "OVERLAY")
    f.title:SetFontObject("GameFontHighlightLarge")
    f.title:SetPoint("CENTER", f.TitleBg, "CENTER", 5, 0)
    f.title:SetText( title )
    
    createTextDisplay(f)
    createResizeButton(f)
    createReloadButton(f, "BOTTOMLEFT",f, 5, 5)
    createSelectButton(f, "BOTTOMRIGHT",f, 5, -10)
    createClearButton(f, "BOTTOM",f, 5, 5)
    return f
end
function mf:postResult( result )

    if E:debuggingIsEnabled() then 
        assert( result ~= nil, L["INPUT_PARAM_NIL"] )
        assert( type(result) == "table", L["INVALID_TYPE"])
        assert( #result == 3, L["PARAM_ILL_FORMED"] )

    end

    if errorFrame == nil then
        errorFrame = createErrorMsgFrame("Error Message(s)")
    end
    local str = nil
    if result[3] ~= nil then
        str = sprintf("%s\nSTACK TRACE:\n%s\n", result[2], result[3])
    else
        str = sprintf("%s", result[2] )
    end

    errorFrame.Text:Insert( str )
    errorFrame:Show()
end

local fileName = "MsgFrame.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s loaded", fileName), 1.0, 1.0, 0.0 )
end
