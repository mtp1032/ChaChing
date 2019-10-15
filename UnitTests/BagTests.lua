--------------------------------------------------------------------------------------
-- BagTests.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 29 December, 2018
--------------------------------------------------------------------------------------

local _, MTP = ...
MTP.BagTests = {}
bagTests = MTP.BagTests

local L = MTP.L
local E = errors
local sprintf = _G.string.format


local testName = sprintf("%s\n", "**** BEGIN BAG TESTS ****")
mf:postMsg( testName )

-------------------------- ERROR TEST 1 --------------------------------
mf:postMsg( "TEST 1: Have player's bags have been instantiated:\n\n")

local bag = nil

----for bagSlot = 1, 5 do
for bagSlot = 0, 4 do
	bag = Bag(bagSlot)
	local totalSlots = bag:getTotalSlots()
	if totalSlots > 0 then
		local msg = sprintf("%s Installed in bag slot %d: total slots %d, free slots %d\n", 
										bag:getName(),
										bag:getInstallationSlot(),
										bag:getTotalSlots(), 
										bag:getNumFreeSlots())

		for slot = 1, totalSlots do
			
		end
		mf:postMsg( msg )
	else
		mf:postMsg(sprintf("No bag installed in slot %d\n", bagSlot))
	end
end
local endTestMsg = sprintf("\n%s\n", "**** END BAG TESTS ****")
mf:postMsg( endTestMsg )
