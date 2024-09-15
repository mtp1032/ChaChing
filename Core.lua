--------------------------------------------------------------------------------------
-- Core.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 6 October, 2019`(Formerly, Sandbox.lua)

local ADDON_NAME, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.Core = {}

local core = ChaChing.Core

local DEBUGGING_ENABLED = true

local function getExpansionName( )
    local expansionLevel = GetExpansionLevel()
    local expansionNames = { -- Use a table to map expansion levels to names
        [LE_EXPANSION_DRAGONFLIGHT] = "Dragon Flight",
        [LE_EXPANSION_SHADOWLANDS] = "Shadowlands",
        [LE_EXPANSION_CATACLYSM] = "Classic (Cataclysm)",
        [LE_EXPANSION_WRATH_OF_THE_LICH_KING] = "Classic (WotLK)",
        [LE_EXPANSION_CLASSIC] = "Classic (Vanilla)",

        [LE_EXPANSION_MISTS_OF_PANDARIA] = "Classic (Mists of Pandaria",
        [LE_EXPANSION_LEGION] = "Classic (Legion)",
        [LE_EXPANSION_BATTLE_FOR_AZEROTH] = "Classic (Battle for Azeroth)",
        [LE_EXPANSION_WAR_WITHIN]   = "Retail (The War Within)"
    }
    return expansionNames[expansionLevel] -- Directly return the mapped name
end

local addonExpansionName = getExpansionName()
local addonVersion = C_AddOns.GetAddOnMetadata( ADDON_NAME, "Version")

function core:getExpansionName()
    local expansionName = getExpansionName()

	return expansionName
end
function core:debuggingIsEnabled()
    return DEBUGGING_ENABLED
end
function core:enableDebugging()
    DEBUGGING_ENABLED = true
end
function core:disableDebugging() 
    DEBUGGING_ENABLED = false
end

local notificationFrame = CreateFrame("Frame", "notificationFrame", UIParent)
    notificationFrame:SetSize(300, 50)  -- Width, Height
    notificationFrame:SetPoint("CENTER", 0, GetScreenHeight() * 0.375)  -- Positioning at X=0 and 3/4 from the bottom to the top
    notificationFrame:Hide()  -- Initially hide the frame

-- Create the text inside the frame
local notificationText = notificationFrame:CreateFontString(nil, "OVERLAY")
    notificationText:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")  -- Set the font, size, and outline
    notificationText:SetPoint("CENTER", notificationFrame, "CENTER")  -- Center the text within the frame
    notificationText:SetTextColor(0.0, 1.0, 0.0)  -- Red color for the text
    notificationText:SetShadowOffset(1, -1)  -- Black shadow to match Blizzard's combat text

-- Function to display the notification
function core:notifyEarnings( message, duration )
    notificationText:SetText(message)
    notificationText:SetTextColor(0.0, 1.0, 0.0)  -- Green color for the text
    notificationText:SetShadowOffset(1, -1)  -- Black shadow to match Blizzard's combat text
    notificationFrame:Show()
    -- Set up a fade-out effect
    -- duration, example, 5 seconds
    -- Ending Alpha. 0 is the visibility.
    UIFrameFadeOut( notificationFrame, duration, 1, 0)
    
end


local fileName = "Core.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s is loaded", fileName ), 0, 1, 0)
end