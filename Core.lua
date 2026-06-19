-- Core.lua
-- AUTHOR: mtpeterson1948@gmail.com
-- ORIGINAL DATE: 6 October, 2019 (Formerly, Sandbox.lua)

-- ================================================================
-- Core Initialization
-- ================================================================
ChaChing = ChaChing or {}
ChaChing.Core = {}
local ADDON_NAME = "ChaChing"

local DEBUGGING_ENABLED = true

-- ================================================================
-- Local Helper Functions
-- ================================================================
local function getExpansionName()
    local expansionLevel = GetExpansionLevel()

    local expansionNames = {
        [LE_EXPANSION_CLASSIC]                  = "Classic (Vanilla)",
        [LE_EXPANSION_BURNING_CRUSADE]          = "Classic (Burning Crusade)",
        [LE_EXPANSION_WRATH_OF_THE_LICH_KING]   = "Classic (Wrath of the Lich King)",
        [LE_EXPANSION_CATACLYSM]                = "Classic (Cataclysm)",
        [LE_EXPANSION_MISTS_OF_PANDARIA]        = "Classic (Mists of Pandaria)",
        [LE_EXPANSION_WARLORDS_OF_DRAENOR]      = "Warlords of Draenor",
        [LE_EXPANSION_LEGION]                   = "Legion",
        [LE_EXPANSION_BATTLE_FOR_AZEROTH]       = "Battle for Azeroth",
        [LE_EXPANSION_SHADOWLANDS]              = "Shadowlands",
        [LE_EXPANSION_DRAGONFLIGHT]             = "Dragonflight",
        [LE_EXPANSION_WAR_WITHIN]               = "The War Within",
        [LE_EXPANSION_MIDNIGHT]                 = "Midnight"
    }

    return expansionNames[expansionLevel] or "Unknown Expansion"
end

-- ================================================================
-- Core API
-- ================================================================
function ChaChing.Core:getAddonInfo()
    local addonVersion = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")
    local addonExpansion = getExpansionName()
    return ADDON_NAME, addonVersion, addonExpansion
end

function ChaChing.Core:debuggingIsEnabled()
    return DEBUGGING_ENABLED
end

function ChaChing.Core:enableDebugging()
    DEBUGGING_ENABLED = true
    ChaChing.DEBUGGING = true
end

function ChaChing.Core:disableDebugging()
    DEBUGGING_ENABLED = false
    ChaChing.DEBUGGING = false
end

-- ================================================================
-- MARK AS LOADED (MUST BE THE VERY LAST LINES)
-- ================================================================
ChaChing.Core.loaded = true
ChaChing.DEBUGGING   = DEBUGGING_ENABLED   -- Make it easily accessible to other files

-- Optional: Print load confirmation when debugging is on
if ChaChing.DEBUGGING then
    local name, version, expansion = ChaChing.Core:getAddonInfo()
    print(string.format("|cFF00FF00[ChaChing]|r %s v%s loaded successfully (%s)", 
          name, version or "dev", expansion))
end