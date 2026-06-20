--------------------------------------------------------------------------------------
-- enUS.lua
-- COMMENTS: https://www.curseforge.com/members/mtpeterson1948
-- ORIGINAL DATE: 16 June, 2026
--
ChaChing = ChaChing or {}
ChaChing.enUS = {}

if not ChaChing.Core.loaded then
	DEFAULT_CHAT_FRAME:AddMessage("Core.lua failed to load", 1, 0, 0)
    return
end


local core = ChaChing.Core

local ADDON_NAME, _, addonExpansion = core:GetAddonInfo()

local MAJOR = C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-MAJOR")
local MINOR = C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-MINOR")
local PATCH = C_AddOns.GetAddOnMetadata(ADDON_NAME, "X-PATCH")

local addonVersion = string.format("%s.%s.%s", MAJOR, MINOR, PATCH)

local L = setmetatable({}, {
	__index = function(t, k)
		local v = tostring(k)
		rawset(t, k, v)
		return v
	end
})
ChaChing.L = L

local LOCALE = GetLocale() -- BLIZZ
if LOCALE == "enUS" then
L["ADDON_NAME_AND_VERSION"] = string.format("%s V%s (%s) loaded.", ADDON_NAME, addonVersion, addonExpansion)
end

local fileName = "enUS.lua"
if core:debuggingIsEnabled() then
	DEFAULT_CHAT_FRAME:AddMessage(string.format("%s is loaded", fileName), 0, 1, 0)
end
ChaChing.enUS.loaded = true
return ChaChing.enUS.loaded

