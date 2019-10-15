--------------------------------------------------------------------------------------
-- BaseTests.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 7 June 2019
--------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.UnitTestsBASE = {}
base = MTP.UnitTestsBASE

local L = MTP.L
local E = errors
local sprintf = _G.string.format


local testName = sprintf("%s\n\n", "**** BEGIN BASE CLASS TESTS ****")
mf:postMsg( testName )

local b = Base()
local result = b:getResult()
if result[1] ~= STATUS_SUCCESS then
	errors:postResult( result )
else
	local s = sprintf("Game Version = %s, Build Number = %s, Date = %s,\n AddOn Name and Version = %s, TOC = %d\n",
																b:getGameVersion(),
																b:getClientBuildNumber(),
																b:getClientBuildDate(),
																b:getAddonName(),
																b:getAddonTOC() ) 
	mf:postMsg( s )
end

local endTestMsg = sprintf("\n**** END BASE CLASS TESTS ***\n")
mf:postMsg( endTestMsg )


