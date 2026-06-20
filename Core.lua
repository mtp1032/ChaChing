--=========================================================
-- FILE: Core.lua
-- AUTHOR: leave blank for now
-- COMMENTS: https://www.curseforge.com/members/mtpeterson1948
-- ORIGINAL DATE: 16 June, 2026
--=========================================================

ChaChing = ChaChing or {}
ChaChing.Core = {}
local core = ChaChing.Core

local ADDON_NAME = "ChaChing"
local addonVersion = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version") or "dev"

-- ================================================================
-- Debug System
-- ================================================================
local DEBUGGING_ENABLED = true

function core:debuggingIsEnabled()
    return DEBUGGING_ENABLED or (ChaChing.DEBUGGING == true)
end

function core:enableDebugging()
    DEBUGGING_ENABLED = true
    print("|cFF00FF00[ChaChing]|r Debug mode enabled")
end

function core:disableDebugging()
    DEBUGGING_ENABLED = false
    print("|cFF00FF00[ChaChing]|r Debug mode disabled")
end

-- ================================================================
-- Addon Information
-- ================================================================
local function getExpansionName()
    local expansionLevel = GetExpansionLevel()

    local expansionNames = {
        [LE_EXPANSION_CLASSIC]                = "Classic",
        [LE_EXPANSION_BURNING_CRUSADE]        = "Burning Crusade",
        [LE_EXPANSION_WRATH_OF_THE_LICH_KING] = "Wrath of the Lich King",
        [LE_EXPANSION_CATACLYSM]              = "Cataclysm",
        [LE_EXPANSION_MISTS_OF_PANDARIA]      = "Mists of Pandaria",
        [LE_EXPANSION_WARLORDS_OF_DRAENOR]    = "Warlords of Draenor",
        [LE_EXPANSION_LEGION]                 = "Legion",
        [LE_EXPANSION_BATTLE_FOR_AZEROTH]     = "Battle for Azeroth",
        [LE_EXPANSION_SHADOWLANDS]            = "Shadowlands",
        [LE_EXPANSION_DRAGONFLIGHT]           = "Dragonflight",
        [LE_EXPANSION_WAR_WITHIN]             = "The War Within",
    }

    -- Safe handling for future expansions
    if expansionLevel == LE_EXPANSION_MIDNIGHT then
        return "Midnight"
    end

    return expansionNames[expansionLevel] or "Unknown Expansion"
end

function core:GetAddonInfo()
    local expansion = getExpansionName()
    return ADDON_NAME, addonVersion, expansion
end

-- ================================================================
-- Initialization
-- ================================================================
function ChaChing.Core:Initialize()
    if core:debuggingIsEnabled() then
        local name, version, expansion = self:GetAddonInfo()
    end
end

-- Mark as loaded
ChaChing.Core.loaded = true

-- Auto-initialize
ChaChing.Core:Initialize()
-- Load message
if ChaChing.Core and ChaChing.Core:debuggingIsEnabled() then
    DEFAULT_CHAT_FRAME:AddMessage("Core.lua loaded", 0, 1, 0)
end
