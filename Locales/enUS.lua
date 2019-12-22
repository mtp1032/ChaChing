----------------------------------------------------------------------------------------
-- enUS.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 28 December, 2018
----------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.enUS = {}
us = ChaChing.enUS

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

ChaChing.L = L
local sprintf = _G.string.format

-- English translations
local LOCALE = GetLocale()      -- BLIZZ
if LOCALE == "enUS" then

--      EXAMPLE USAGE:

    -- ChaChing Strings
    L["ADDON_NAME"]                                 = "ChaChing"
    L["VERSION"]                                    =  "V3.2"
	L["ADDON_NAME_AND_VERSION"] 					= sprintf("%s %s", L["ADDON_NAME"], L["VERSION"])
	L["DESCR_SUBHEADER"] 							= "Enables the bulk selling of selected items in player's inventory."
	L["LEFT_CLICK_FOR_OPTIONS_MENU"] 				= "Left click to display options menu." 
	L["RIGHT_CLICK_SHOW_EXCLUSION_TABLE"]			= "Right click to display list of excluded items."
	L["SHIFT_RIGHT_CLICK_DELETE_EXCLUSION_TABLE"]	= "Shift-Right click to remove all excluded items."
	L["ADDON_LOADED_MESSAGE"]						= L["ADDON_NAME_AND_VERSION"].." loaded (/cc for help)."

    L["TOOLTIP_CHECK_WHITE_BTN"] = "Sell only common (white) quality weapon and armor items in your inventory."
	L["LABEL_WHITE_CHECKBTN"] = "Sell White."
	
	L["TOOLTIP_CHECK_GREY_BTN"] = "Sell all poor (grey) quality items in your inventory."
    L["LABEL_GREY_CHECKBTN"] = "Sell Gray."
	L["LABEL_EXCLUDED_ITEM_LIST"] = "Drag and drop the items to be excluded into input box."
	L["SELECT_BAG_PROMPT"] = "Select one or more bags. All items in the selected bags will be sold!"

    L["PREFIX_ERROR"]            = "ERROR:"
    L["PREFIX_W_TEXT"]           = "ERROR: %s!"

    --          Data type related errors
    L["TYPE_UNEXPECTED_STRING"]     = "Type error, expected string value!"
    L["TYPE_UNEXPECTED_NUMBER"]     = "Type error, expected number value!"
    L["TYPE_UNEXPECTED_TABLE"]      = "Type error, expected table structure!"
    
    L["STRING_EMPTY"]               = "Empty string!"
	L["STRING_NIL"]                 = "String nil!"
	L["BAG_SLOT_UNOCCUPIED"]		= "Specified bag slot is empty!"

    --          Errors arising from function arguments
    L["ARG_EMPTY_OR_NIL"]       = "Input arg nil or empty!"
    L["ARG_NIL"] 				= "Input arg nil!"
    L["ARG_EMPTY"]              = "Input arg empty!"
    L["ARG_MISSING"] 			= "Input arg missing!"
    L["ARG_INVALID"] 			= "Input arg invalid or out-of-range!"
    L["ARG_UNKNOWN"] 			= "Input arg unknown!"
    L["ARG_UNEXPECTED"]         = "Input arg unexpected!"
    L["ARG_WRONGTYPE"] 		    = "Input arg wrong type!"
    L["ARG_OUTOFRANGE"]         = "Input arg out of range!"
	L["ARG_NOT_INITIALIZED"]    = "Input arg not initialized!"

    L["ERROR_SPELL_DAMAGE_TABLE"]           = "Spell damage table corrupt!"
    L["ERROR_UNKNOWN_SPELL"]                = "Spell name unknown!"
    L["ERROR_COMPARISON_UNEQUAL"]           = "Comparison produced unequal results!"
    L["ERROR_COMPARISON_UNEQUAL_W_TEXT"]    = "%s not equal to %s!"
	L["ERROR_NO_PLAYER_SPEC"]               = "%s has no primary spec!"
	L["ERROR_INCONSISTEN_STATE"]			= "Two or more values conflict with each other!" 

--              Errors encountered when checking function return results
    L["RESULT_NIL"]            = "Return value: missing or nil!"
    L["RESULT_INVALID"]        = "Return value: invalid or out-of-range!"
    L["RESULT_WRONGTYPE"]      = "Return value: wrong type!"
    L["RESULT_NOT_FOUND"]      = "Return value: item not found!"
    L["RESULT_BLIZZ_API"]      = "Return value: unexpected!"

    return 
end

-- Spanish translations
if LOCALE == "esES" or LOCALE == "esMX" then
    return 
end
