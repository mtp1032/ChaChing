--------------------------------------------------------------------------------------
-- ContainerEventHandler.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 8 June, 2019
--------------------------------------------------------------------------------------

local _, MTP = ...

local L = MTP.L
local E = errors


--********************************************************************************
--						CREATES THE EVENT HANDLING FRAME AND CALLS
--						THE HANDLER FOR THE BAG_UPDATE EVENT
--********************************************************************************

local eventFrame = CreateFrame("Frame" )
	-- if arg2 ~= nil, arg1 is bagSlot, arg2 is slotId
	-- if arg2 is nil, arg1 is equipment slot of item
	-- 	Usually fires in pairs when an item is swapping with another.
	-- Empty slots do not lock.
	eventFrame:RegisterEvent("BAG_OPEN") 
	eventFrame:RegisterEvent("BAG_CLOSED")
	eventFrame:RegisterEvent("BAG_UPDATE")
	eventFrame:RegisterEvent("ITEM_LOCKED") -- arg1 bagSlot, arg2 slotId of item
	eventFrame:RegisterEvent("ITEM_LOCK_CHANGED")
	eventFrame:RegisterEvent("MERCHANT_SHOW")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("ITEM_UNLOCKED")
	eventFrame:RegisterEvent("ITEM_PUSH") 
	eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")


	eventFrame:SetScript("OnEvent", 
	function( self, event, ... )
		local bagId, slotId = ...

		bg:initializeBagTable()
	
		-- This event is called last (after multiple BAG_UPDATE events.)
		if event == "PLAYER_ENTERING_WORLD" then
			cha:CHACHING_InitializeOptions()
		end
	end)
