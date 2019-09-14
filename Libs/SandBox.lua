--------------------------------------------------------------------------------------
-- SandBox.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 18 December, 2018
--------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.SandBox = {}
sb = MTP.SandBox

-----------------------------------------------------------------------------------------------------------
--                      The infoTable
-----------------------------------------------------------------------------------------------------------
--                      Indices into the infoTable table
local VERSION = 1
local BUILD_NUMBER = 2
local BUILD_DATE = 3
local TOC_VERSION = 4
local infoTable = { GetBuildInfo() }

------------------------------------------------------------------------------------------------------------
--                      Game/Build/AddOn Info (from Blizzard's GetBuildInfo()) - see above
------------------------------------------------------------------------------------------------------------
function sb:getAddonName()
    return ADDON_C_NAME
end
function sb:getGameVersion()           -- e.g., 8.1.0
    return infoTable[VERSION]
end
function sb:getGameBuildNumber()       -- eg., 28833
    return infoTable[BUILD_NUMBER]
end
function sb:getBuildDate()             -- e.g., Dec 19 2018
    return infoTable[BUILD_DATE]
end
function sb:getAddonTOC()          -- e.g., 80100
    return infoTable[TOC_VERSION]
end

function sb:isFileLoaded()
    return true
end

function sb:isClassic()
	local isClassic = false
    if infoTable[TOC_VERSION] ~= 80200 then
        isClassic = true
    end

    return isClassic
end

--****************************************************************************************
--                          GET INFORMATION ABOUT THE PLAYER
--                          EXECUTING THIS INSTANCE
--****************************************************************************************
local PLAYER_NAME 		= 1
local PLAYER_CLASS 		= 2
local PLAYER_GUID 		= 3
local PLAYER_PET_GUID	= 4
-- local PLAYER_PET_GUID 	= 5

local playerName = nil
local playerClass = nil
local playerGuid = nil
local playerPetGuid = nil

function sb:getPlayerInfo( unit )

    if unit == nil then
        unit = "Player"
    end
    playerGuid = bw:unitGuid( unit )
    playerClass, _, _, _, _, playerName  = bw:getPlayerInfoByGUID( playerGuid ) -- BLIZZ

    return  playerName, playerClass, playerGuid, playerPetGuid
end
function sb:setPlayerPetGuid( guid )
    playerPetGuid = guid
end
function sb:getPlayerPetGuid()
    return playerPetGuid
end

------------------------------------------------------------------------------------------
--                      Tests
------------------------------------------------------------------------------------------
-- local s = string.format("Game Version = %s, Build Number = %s, Date = %s,\n AddOn Name and Version = %s, TOC = %d", 
--                         sb:getGameVersion(), 
--                         sb:getGameBuildNumber(), 
-- 						sb:getBuildDate(), 
-- 						sb:getAddonName(),
--                         sb:getAddonTOC())
-- DEFAULT_CHAT_FRAME:AddMessage( s )
-- DEFAULT_CHAT_FRAME:AddMessage( "Sandbox.lua loaded" )
