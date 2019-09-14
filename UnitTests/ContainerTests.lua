--------------------------------------------------------------------------------------
-- ContainerTests.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 29 June 2018
--------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.UnitTestsCONTAINER = {}
unit = MTP.UnitTestsCONTAINER

---------------------------------------------------------------------------------------
--                      CONTAINER CLASS TESTS
---------------------------------------------------------------------------------------

local errorMsgFrame = emf:createErrorMsgFrame()
if errorMsgFrame:IsVisible() == false then
	errorMsgFrame:Show()
end

local testName = string.format("%s\n", "**** CONTAINER CLASS TESTS ****\n")
errorMsgFrame.Text:Insert( testName )

local c = Container()
local result = c:getResult()
if result[1] ~= STATUS_SUCCESS then
	errors:postResult( result )
else
	local successMsg = string.format("Container class creation successful!\n")
	errorMsgFrame.Text:Insert( successMsg )
end

c:print()
local endTestMsg = string.format("\n**** END CONTAINER CLASS TESTS ***\n")
errorMsgFrame.Text:Insert( endTestMsg )
