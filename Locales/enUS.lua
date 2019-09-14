----------------------------------------------------------------------------------------
-- enUS.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 28 December, 2018
----------------------------------------------------------------------------------------

local _, MTP = ...
MTP.enUS = {}
loc = MTP.enus

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

MTP.L = L

-- English translations
local LOCALE = GetLocale()      -- BLIZZ
if LOCALE == "enUS" then

--      EXAMPLE USAGE:

    -- local errMsg = L["STRING_EMPTY"]
    -- local errMsg = string.format(L["ERROR_MESSAGE"], errMsg )
    -- local result = errors.setErrorResult( errMsg, debugstack() )
    -- emf.postErrorMsg( result )

    -- ChaChing Strings
    L["ADDON_NAME"] = "ChaChing"
    L["ADDON_NAME_AND_VERSION"] = "ChaChing (1.0 Beta)"
    L["AUTHOR"] = "Author: Shadowraith@Feathermoon"
    L["DESCR_SUBHDR1"] = "Descr: automatically vendors all poor quality [grey] items."
    L["DESCR_SUBHDR2"] = "Can be configured to automatically sell common [white] weapons and armor items."    
    L["TOOLTIP_CHECK_WHITE_BTN"] = "Sell All Common (White) Weapons and Armor Items."
    L["LABEL_WHITE_CHECKBTN"] = "Sell All Common (White) Weapons and Armor Items."
    L["TOOLTIP_CHECK_REAGENT_BTN"] = "Danger: checking this box will vendor *all* white crafting reagents."
    L["LABEL_CHECK_REAGENT_BTN"] = "Sell All Common (White) Crafting Reagents?"

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

--              User Messages
    L["SUMMARY_ALL_SPELLS"]     = "SUMMARY (All Spells):"
    L["SUMMARY"]                = "\nSUMMARY (%s):\n"
    L["TOTAL_DAMAGE"]           = "Total Damage: %d\n"
    L["TOTAL_CRIT_DAMAGE"]      = "Total Crit Damage: %d\n"
    L["PERCENT_CRIT_DAMAGE"]    = "%% Crit Damage: %.03f\n"
    L["TOTAL_COMBAT_TIME"]      = "Total Combat Time: %.03f\n"
    L["DAMAGE_PER_TICK"]        = "Damage per tick/cast: %.03f\n"
    L["UNIT_DPS"]               = "DPS: %.03f%%\n"
    L["TOTAL_DPS"]              = "Total DPS: %.03f\n"
	L["PERCENT_TOTAL_DPS"]      = "%% of Total DPS: %.03f%%\n"
	L["UNIT_NOT_PLAYER_"]		= "Input unit is not a player!"
	L["UNIT_OUT_OF_RANGE"]		= "Targeted unit is out of range!"

    L["UPTIME_ICY_VEINS"]       = "Uptime %% (%s): %.03f\n"
    L["UPTIME_TIME_WARP"]       = "Uptime %% (%s): %.03f\n"
    L["UPTIME_FROZEN_ORB"]      = "Uptime %% (%s): %.03f\n"
    L["PROCS_BRAIN_FREEZE"]     = "Uptime %% (%s): %.03f\n"
    L["PROCS_FINGERS_OF_FROST"] = "Uptime %% (%s): %.03f\n"

    L["SPELL_DAMAGE"]            = "Hit for %.02f damage!"
    L["SPELL_PERIODIC_DAMAGE"]   = "Hit (periodic) for %.02f damage!"
    L["SPELL_AURA_APPLIED"]      = "Applied %s!"
    L["SPELL_AURA_REMOVED"]      = "Removed %s!"

    L["CRIT"]           = "Crit"
    L["HASTE"]          = "Haste"
    L["MASTERY"]        = "Mastery"
    L["INTELLECT"]      = "Haste"
    L["BUFF"]           = "Buff"
    L["DEBUFF"]         = "Debuff"

    L["GAINED"]         = "gained"
    L["SUCCEEDED"]      = "Succeeded"
    L["FAILED"]         = "Failed"

    -- SPELLS - SHADOW PRIEST
    L["AUSPICIOUS_SPIRITS"] = "Auspicious Spirits"
    L["DARK_ASCENSION"] = "Dark Ascension"
	L["DARK_VOID"] = "Dark Void"

    L["MIND_BENDER"] = "Mindbender"
    L["MIND_BOMB"]  = "Mind Bomb"
    L["MIND_FLAY"] = "Mind Flay"
    L["MIND_SEAR"] = "Mind Sear"
    L["MIND_BLAST"] = "Mind Blast"

    L["SHADOW_MEND"]    = "Shadow Mend"
    L["SHADOW_CRASH"]   = "Shadow Crash"
    L["SHADOW_WORD_DEATH"]  = "Shadow Word: Death"
	L["SHADOW_WORD_PAIN"] = "Shadow Word: Pain"
	L["SHADOW_WORD_VOID"] = "Shadow Word: Void"

    L["SURRENDER_TO_MADNESS"] = "Surrender to Madness"
    L["VAMPIRIC_TOUCH"] = "Vampiric Touch"
    L["VOID_BOLT"] = "Void Bolt"
    L["VOID_ERUPTION"] = "Void Eruption"
    L["VOID_FORM"] = "Voidform"
    L["VOID_TORRENT"] = "Void Torrent"

    return 
end

-- Spanish translations
if LOCALE == "esES" or LOCALE == "esMX" then

    L["PREFIX_ERROR"]            = "ERROR:"
    L["PREFIX_W_TEXT"]           = "ERROR: %s!"

    --          Data type related errors
    L["TYPE_UNEXPECTED_STRING"]     = "Type error, expected string value!"
    L["TYPE_UNEXPECTED_NUMBER"]     = "Type error, expected number value!"
    L["TYPE_UNEXPECTED_TABLE"]      = "Type error, expected table structure!"
    L["STRING_EMPTY"]               = "Empty string!"
    L["STRING_NIL"]                 = "String nil!"

    --          Errors arising from function arguments
    L["ARG_EMPTY_OR_NIL"]           = "Input parameter was nil or empty!"
    L["ARG_MISSING"] 			    = "Input arg missing"
    L["ARG_NIL"] 				    = "Input arg nil"
    L["ARG_INVALID"] 			    = "Input arg invalid or out-of-range"
    L["ARG_UNKNOWN"] 			    = "Input arg unknown"
    L["ARG_UNEXPECTED"]             = "Input arg unexpected"
    L["ARG_WRONGTYPE"] 		        = "Input arg wrong type"
    L["ARG_OUTOFRANGE"]             = "Input arg out of range"

--              Errors encountered when checking function return results
    L["RESULT_NIL"]            = "Return value: missing or nil"
    L["RESULT_INVALID"]        = "Return value: invalid or out-of-range"
    L["RESULT_WRONGTYPE"]      = "Return value: wrong type"
    L["RESULT_NOT_FOUND"]      = "Return value: item not found"
    L["RESULT_BLIZZ_API"]      = "Return value: unexpected"

--              User Messages
    L["SUMMARY"]                = "\nSUMMARY (%s):\n"
    L["TOTAL_DAMAGE"]           = "Total Damage: %d\n"
    L["TOTAL_CRIT_DAMAGE"]      = "Total Crit Damage: %d\n"
    L["PERCENT_CRIT_DAMAGE"]    = "%% Crit Damage: %.03f\n"
    L["TOTAL_COMBAT_TIME"]      = "Total Combat Time: %.03f\n"
    L["DAMAGE_PER_TICK"]        = "Damage per tick/cast: %.03f\n"
    L["UNIT_DPS"]               = "DPS: %.03f%%\n"
    L["TOTAL_DPS"]              = "Total DPS: %.03f\n"
    L["PERCENT_TOTAL_DPS"]      = "%% of Total DPS: %.03f%%\n"

    L["UPTIME_ICY_VEINS"]       = "Uptime %% (%s): %.03f\n"
    L["UPTIME_TIME_WARP"]       = "Uptime %% (%s): %.03f\n"
    L["UPTIME_FROZEN_ORB"]      = "Uptime %% (%s): %.03f\n"
    L["PROCS_BRAIN_FREEZE"]     = "Uptime %% (%s): %.03f\n"
    L["PROCS_FINGERS_OF_FROST"] = "Uptime %% (%s): %.03f\n"

    -- STAT_DPS_SHORT = "DPS";
    -- CRIT_ABBR = "Crit";


    L["SUCCEEDED"]  = "Succeeded"
    L["FAILED"]     = "Failed"
    return 
end
