--------------------------------------------------------------------------------------
-- BaseTests.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 7 June 2019
--------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.UnitTestsBASE = {}
base = MTP.UnitTestsBASE

local testName = string.format("%s\n\n", "**** BEGIN BASE CLASS TESTS ****")
mf:postMsg( testName )

local b = Base()
local result = b:getResult()
if result[1] ~= STATUS_SUCCESS then
	errors:postResult( result )
else
	local s = string.format("Game Version = %s, Build Number = %s, Date = %s,\n AddOn Name and Version = %s, TOC = %d\n",
																b:getGameVersion(),
																b:getClientBuildNumber(),
																b:getClientBuildDate(),
																b:getAddonName(),
																b:getAddonTOC() ) 
mf:postMsg( s )
end

local endTestMsg = string.format("\n**** END BASE CLASS TESTS ***\n")
mf:postMsg( endTestMsg )


