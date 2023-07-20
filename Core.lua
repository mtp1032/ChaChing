--------------------------------------------------------------------------------------
-- Core.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 6 October, 2019`(Formerly, Sandbox.lua)

local _, ChaChing = ...
ChaChing.Core = {}
core = ChaChing.Core
local sprintf = _G.string.format

core.SUCCESS 	        = true
core.FAILURE 	        = false
core.EMPTY_STR 	        = ""

local isDebuggingEnabled = true

local addonName = nil
local addonVersion  = nil
local expansionName = nil
local function getAddonName()
	local stackTrace = debugstack(2)
	local dirNames = nil
	local addonName = nil

	if 	EXPANSION_LEVEL == LE_EXPANSION_DRAGONFLIGHT then
		dirNames = {strsplittable( "\/", stackTrace, 5 )}	end
	if EXPANSION_LEVEL == LE_EXPANSION_WRATH_OF_THE_LICH_KING then
		dirNames = {strsplittable( "\/", stackTrace, 5 )}
	end
	if EXPANSION_LEVEL == LE_EXPANSION_CLASSIC then
		dirNames = {strsplittable( "\/", stackTrace, 5 )}
	end

	addonName = dirNames[1][3]
	return addonName
end
local function getExpansionName()

	local expansionLevel = max(GetAccountExpansionLevel(), GetServerExpansionLevel())
	local expansionName = nil

	if expansionLevel == LE_EXPANSION_CLASSIC then
		expansionName = "Classic (Vanilla)"
	end
	if expansionLevel == LE_EXPANSION_WRATH_OF_THE_LICH_KING then
		expansionName = "Classic (WotLK)"
	end
	if expansionLevel == LE_EXPANSION_DRAGONFLIGHT then
		expansionName = "(Dragon Flight)"
	end
	return expansionName
end
local addonName = getAddonName()
local addonExpansion = getExpansionName()
local addonVersion = GetAddOnMetadata( addonName, "Version")

function core:getAddonInfo()
	return addonName, addonVersion, addonExpansion
end
function core:debuggingIsEnabled()
    return isDebuggingEnabled
end
function core:enableDebugging()
   isDebuggingEnabled = true
   DEFAULT_CHAT_FRAME:AddMessage( "OptionsFrame Debugging Is Now ENABLED.", 1.0, 1.0, 0.0 )
end
function disableDebugging() 
   isDebuggingEnabled = false
   DEFAULT_CHAT_FRAME:AddMessage( "OptionsFrame Debugging Is Now DISABLED.", 1.0, 1.0, 0.0 )
end
local fileName = "Core.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s is loaded", fileName ), 0, 1, 0)
end