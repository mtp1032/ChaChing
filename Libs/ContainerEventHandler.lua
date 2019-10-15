--------------------------------------------------------------------------------------
-- ContainerEventHandler.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 8 June, 2019
--------------------------------------------------------------------------------------
local ADDON_C_NAME, MTP = ...
MTP.ContainerEventHandler = {}
cev = MTP.ContainerEventHandler

local L = MTP.L
local E = errors
local sprintf = _G.string.format


-- ********************************************************************************
--						CREATES THE EVENT HANDLING FRAME AND CALLS
--						THE HANDLER FOR VARIOUS BAG-RELATED EVENTS
-- ********************************************************************************
local CHACHING_INITIALIZED = false
local function initChaChing()
	if CHACHING_INITIALIZED == false then
		CHACHING_INITIALIZE = true
		si:CHACHING_InitializeOptions()
		CHACHING_INITIALIZED = true
	end
end

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

		bg:initializeBagTable()

		-- The saved variables, see above, are read from the disk and initialized
		--     just before the ADDON_LOADED event is fired.
		if event == "ADDON_LOADED" and arg1 == "ChaChing" then
			
			-- initialize the saved variables to their default values.
			sellGrey = true
			sellWhite = false
			isBagChecked = { false, false, false, false, false }
		end
		
		if event == "PLAYER_LOGIN" then
		end

		-- This event is called when the player first logs in, enters or leaves an instance, respawns at a graveyard,
		-- and when the player's screen is reloaded.
		if event == "PLAYER_ENTERING_WORLD" then
			initChaChing()
		end

		-- Restore the saved variables (see ChaChing.toc) to their default states
		if event == "PLAYER_LOGOUT" then
			sellGrey = true
		end
	end)
