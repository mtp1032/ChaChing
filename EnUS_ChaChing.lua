--------------------------------------------------------------------------------------
-- EnUS_ChaChing.lua.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 16 July, 2023
--
local _, ChaChing = ...
ChaChing.EnUS_ChaChing = {}
enus = ChaChing.EnUS_ChaChing 
local sprintf = _G.string.format 

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })
ChaChing.L = L

local addonName, addonVersion, addonExpansionName = core:getAddonInfo()
local LOCALE = GetLocale()      -- BLIZZ
if LOCALE == "enUS" then

	L["ADDON_NAME"]				= addonName
	L["VERSION"]				= addonVersion
	L["EXPANSION_NAME"]			= addonExpansionName
	L["ADDON_NAME_AND_VERSION"] = sprintf("%s V %s %s", L["ADDON_NAME"], L["VERSION"], L["EXPANSION_NAME"] )
	L["OPTIONS_MENU_TITLE"]     = sprintf("%s (%s -Options", L["ADDON_NAME"], L["EXPANSION_NAME"])

	L["LEFT_CLICK_FOR_OPTIONS_MENU"] 				= ""
	L["RIGHT_CLICK_SHOW_EXCLUSION_TABLE"] 			= ""
	L["SHIFT_RIGHT_CLICK_DELETE_EXCLUSION_TABLE"]	= ""
	L["AVAILABLE_SLOTS"] 	= "available slots. "
	L["EXCLUDED"]			= "will be excluded. "


	L["DESCR_SUBHEADER"] 							= "Enables the bulk selling of selected items in player's inventory."
	L["LEFT_CLICK_FOR_OPTIONS_MENU"] 				= "Left click to display options menu." 
	L["RIGHT_CLICK_SHOW_EXCLUSION_TABLE"]			= "Right click to display list of excluded items."
	L["SHIFT_RIGHT_CLICK_DELETE_EXCLUSION_TABLE"]	= "Shift-Right click to remove all excluded items."
	L["ADDON_LOADED_MESSAGE"]						= L["ADDON_NAME_AND_VERSION"].." loaded (/cc for help)."
    L["GREY_TOOLTIP"]                               = "Check if Grey (poor) Quality Items Are To be Sold."
    
    local s1 = sprintf("Checking this box will cause %s to sell your profession tools like", L["ADDON_NAME"] )
    local s2 = s1 .. sprintf(" mining picks,\nskinning knives, fishing poles, and the like. To prevent")
    local s3 = s2 .. sprintf(" this, put these items on the exclusion list.")
    L["WHITE_TOOLTIP"]	= s3
	L["BAG_TOOLTIP"] = sprintf("Checking this icon will cause %s to sell EVERY item in this bag!", addonName )

    L["TOOLTIP_CHECK_WHITE_BTN"] 	= "Sell only common (white) quality weapon and armor items in your inventory."
	L["LABEL_WHITE_CHECKBTN"] 		= "Sell White (Weapons and Armor items only)."
	
	L["TOOLTIP_CHECK_GREY_BTN"] 	= "Sell all poor (grey) quality items in your inventory."
    L["LABEL_GREY_CHECKBTN"] 		= "Sell Gray."
	L["LABEL_EXCLUDED_ITEM_LIST"] 	= "Drag and drop the items to be excluded into input box."
	L["SELECT_BAG_PROMPT"] 			= "Select one or more bags. All items in the selected bags will be sold!"
    --          Errors arising from function arguments
    L["ARG_MISSING"] 				= "Input arg missing or nil!"
    L["ARG_WRONG_TYPE"] 		    = "Input arg wrong type. Expected %s, got %s!"
    L["ARG_OUTOFRANGE"]         	= "Input arg out of range!"
end

local fileName = "EnUS_ChaChing.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage( sprintf("%s is loaded", fileName ), 0, 1, 0)
end