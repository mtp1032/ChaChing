--------------------------------------------------------------------------------------
-- EnUS_ChaChing.lua.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 16 July, 2023
--
ChaChing = ChaChing or {}
ChaChing.EnUS_ChaChing = {}

local enus = ChaChing.EnUS_ChaChing 
local core = ChaChing.Core

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })
ChaChing.L = L

-- Form a string representing the library's version number (see WoWThreads.lua).
local MAJOR = C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-MAJOR")
local MINOR = C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-MINOR")
local PATCH = C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-PATCH")

local addonName, addonVersion, addonExpansion = core:getAddonInfo()
local addonVersion = string.format("v%s.%s.%s", MAJOR, MINOR, PATCH )
local addonExpansion = core:getExpansionName()
L["ADDON_NAME_AND_VERSION"] = string.format("%s - %s (%s)", addonName, addonVersion, addonExpansion )

local LOCALE = GetLocale()      -- BLIZZ
if LOCALE == "enUS" then

	L["ADDON_LOADED_MESSAGE"]	= string.format("%s loaded - /cc for help.", L["ADDON_NAME_AND_VERSION"])

	L["OPTIONS_MENU_TITLE"]     = string.format("%s (%s - Options", ADDON_NAME, expansionName )
	L["LEFT_CLICK_FOR_OPTIONS_MENU"] 				= ""
	L["RIGHT_CLICK_SHOW_EXCLUSION_TABLE"] 			= ""
	L["AVAILABLE_SLOTS"] 							= "available slots. "
	L["EXCLUDED"]									= "will be excluded. "


	L["DESCR_SUBHEADER"] 							= "Enables the bulk selling of selected items in player's inventory."
	L["LEFT_CLICK_FOR_OPTIONS_MENU"] 				= "Left click to display options menu." 
	L["RIGHT_CLICK_SHOW_EXCLUSION_TABLE"]			= "Right click to display list of excluded items."
    L["GREY_TOOLTIP"]                               = "Check if Grey (poor) Quality Items Are To be Sold."
	L["HELP_MESSAGE"]								= "Help not yet implemented. "
    
    local s1 = string.format("Checking this box will cause ChaChing to sell your profession tools such as")
    local s2 = s1 .. string.format(" mining picks,\nskinning knives, fishing poles, and the like. To prevent")
    local s3 = s2 .. string.format(" this, put these items on the exclusion list.")
    L["WHITE_TOOLTIP"]	= s3
	L["BAG_TOOLTIP"] = string.format("Checking this icon will cause ChaChing to sell EVERY item in this bag!" )

    L["TOOLTIP_CHECK_WHITE_BTN"] 	= "Sell only common (white) quality weapon and armor items in your inventory."
	L["LABEL_WHITE_CHECKBTN"] 		= "Sell White (Weapons and Armor items only)."
	
	L["TOOLTIP_CHECK_GREY_BTN"] 	= "Sell all poor (grey) quality items in your inventory."
    L["LABEL_GREY_CHECKBTN"] 		= "Sell Gray."
	L["LABEL_EXCLUDED_ITEM_LIST"] 	= "Drag and drop the items to be excluded into input box."
	L["SELECT_BAG_PROMPT"] 			= "Select one or more bags. All items in the selected bags will be sold!"
end

local fileName = "EnUS_ChaChing.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( string.format("%s is loaded", fileName ), 0, 1, 0)
end