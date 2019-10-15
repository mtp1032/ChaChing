----------------------------------------------------------------------------------------
-- BagManager.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 15 October, 2019
----------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.BagManager = {}
bmgr = ChaChing.BagManager

local L = ChaChing.L
local E = errors
local sprintf = _G.string.format

-- A table of Bag objects. This needs to be updated whenever any of the events in the file
-- ContainerEventHandler
local bagTable = {
	nil, -- Always the Player's backpack
	nil, 
	nil, 
	nil, 
	nil
}

function bmgr:getBagNameFromTable( tableIndex )
	local bag = bagTable[tableIndex]
	return( bag:getName() )
end

function bmgr:getBag( tableIndex )
	return bagTable[tableIndex]
end

function bmgr:initializeBagTable()
	for installationSlot = 0, NUM_BAG_SLOTS do
		local containerNumSlots = GetContainerNumSlots( installationSlot )
		if containerNumSlots > 0 then
			bagTable[installationSlot + 1] = Bag(installationSlot )
		else
			bagTable[installationSlot + 1] = nil
		end
	end
end

function bmgr:dumpBagTable( msg )
	mf:postMsg( msg )

	for bagSlot = 1, 5 do
		numBagSlots = GetContainerNumSlots(bagSlot - 1)
		if numBagSlots > 0 then
			local bag = bagTable[bagSlot]
			if bag ~= nil then
				mf:postMsg(sprintf("    %s installed at %d has %d slots\n", bag:getName(), bag:getInstallationSlot(), bag:getTotalSlots() ))
			else
				mf:postMsg(sprintf("    No bag installed at %d\n", bagSlot ))
			end
		end
	end
	mf:postMsg( sprintf("\n"))
end

