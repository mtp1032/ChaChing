--------------------------------------------------------------------------------------
-- ContainerEventHandler.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 8 June, 2019
--------------------------------------------------------------------------------------
local _, ChaChing = ...
ChaChing.ContainerEventHandler = {}
cev = ChaChing.ContainerEventHandler

local L = ChaChing.L
local E = errors
local sprintf = _G.string.format

-- ********************************************************************************
--						CREATES THE EVENT HANDLING FRAME AND CALLS
--						THE HANDLER FOR VARIOUS BAG-RELATED EVENTS
-- ********************************************************************************

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
	eventFrame:RegisterEvent("PLAYER_LOGOUT")
	eventFrame:RegisterEvent("PLAYER_LOGIN")
	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:RegisterEvent("ITEM_UNLOCKED")
	eventFrame:RegisterEvent("ITEM_PUSH") 
	eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")

	eventFrame:SetScript("OnEvent", 
	function( self, event, ... )
		local arg1 = ...

		bmgr:initializeBagTable()

		if event == "ADDON_LOADED" and arg1 == "ChaChing" then
			-- If this is the first time the addon is loaded then
			-- initialize the table's values to their defaults.
			-- if CHACHING_SAVED_VARS[5] == false then
			-- 	CHACHING_SAVED_VARS[5] = true
			-- end
			if CHACHING_SAVED_VARS[4] == false then
				CHACHING_SAVED_VARS[4] = true
			end
			DEFAULT_CHAT_FRAME:AddMessage( L["ADDON_LOADED_MESSAGE"], 1.0, 1.0, 0)
		end
		
		if event == "PLAYER_LOGIN" then
			si:CHACHING_InitializeOptions()
		end

		if event == "PLAYER_ENTERING_WORLD" then
		end

		if event == "PLAYER_LOGOUT" then
		end
	end)
