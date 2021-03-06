--------------------------------------------------------------------------------------
-- ChaChing.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 6 October, 2019`(Formerly, Sandbox.lua)
--
-- DESCRIPTION:
-- ChaChing is another AddOn that permits a player to sell items in bulk. Chaching, 
-- by default, will sell all poor (grey) quality items. Chaching can be configured 
-- to sell all common (white) quality armor and weapon items. This is particularly 
-- useful at lower levels when many drops and quest rewards are of common quality.
--  *********************************************************************************
local _, ChaChing = ...
ChaChing.Core = {}
cc = ChaChing.Core

local L = ChaChing.L
local E = errors
local sprintf = _G.string.format

-----------------------------------------------------------------------------------------------------------
--                      ADDON INFO AND METHODS
-----------------------------------------------------------------------------------------------------------
CHACHING_SAVED_VARS = { 
	true,									-- [1] sellGrey
	false,									-- [2] sellWhite
	{},										-- [3] exclusionTable
	false									-- [4] isInitialized
}

--						The infoTable and its indices
local infoTable 	= { GetBuildInfo() }

local VERSION 		= 1
local BUILD_NUMBER 	= 2
local BUILD_DATE 	= 3
local TOC_VERSION 	= 4

function cc:getGameVersion()           -- e.g., 8.1.0
    return infoTable[VERSION]
end
function cc:getGameBuildNumber()       -- eg., 28833
    return infoTable[BUILD_NUMBER]
end
function cc:getBuildDate()             -- e.g., Dec 19 2018
    return infoTable[BUILD_DATE]
end
function cc:getAddonTOC()          		-- e.g., 11302
    return infoTable[TOC_VERSION]
end

------------------------------------------------------------------------------------------
--					BLIZZARD API METHODS CC'D INTO CHACHING'S NAMESPACE
------------------------------------------------------------------------------------------
local GetBagName 				= _G.GetBagName
local GetContainerItemID 		= _G.GetContainerItemID
local GetContainerItemInfo 		= _G.GetContainerItemInfo
local GetContainerItemLink 		= _G.GetContainerItemLink
local GetContainerNumSlots 		= _G.GetContainerNumSlots
local GetContainerNumFreeSlots 	= _G.GetContainerNumFreeSlots
local UseContainerItem 			= _G.UseContainerItem
local GetInventoryItemLink 		= _G.GetInventoryItemLink
local ContainerIDToInventoryID 	= _G.ContainerIDToInventoryID
