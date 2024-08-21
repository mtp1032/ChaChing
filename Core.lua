--------------------------------------------------------------------------------------
-- Core.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 6 October, 2019`(Formerly, Sandbox.lua)

local ADDON_NAME, ChaChing = ...
ChaChing = ChaChing or {}
ChaChing.Core = {}

local core = ChaChing.Core

local DEBUGGING_ENABLED = true
local isDebuggingEnabled = true

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
        [LE_EXPANSION_BATTLE_FOR_AZEROTH] = "Classic (Battle for Azeroth)"
    }
    return expansionNames[expansionLevel] -- Directly return the mapped name
end

local addonExpansionName = getExpansionName()
local addonVersion = C_AddOns.GetAddOnMetadata( ADDON_NAME, "Version")

function core:getAddonInfo()
    local version = C_AddOns.GetAddOnMetadata( ADDON_NAME, "Version")
    local expansion = getExpansionName()

	return version, expansion
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

local fileName = "Core.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s is loaded", fileName ), 0, 1, 0)
end