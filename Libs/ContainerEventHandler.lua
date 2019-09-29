--------------------------------------------------------------------------------------
-- ContainerEventHandler.lua
-- AUTHOR: Michael Peterson
-- ORIGINAL DATE: 8 June, 2019
--------------------------------------------------------------------------------------

local _, MTP = ...

local L = MTP.L
local E = errors

--[[ 1. Saved variables are loaded after the addon code is executed 
	They cannot be accessed immediately, and will overwrite any "defaults" the addon may 
	place in the global environment during its loading process.
2. Only some variable types may be saved 
	Strings, booleans, numbers and tables are the only variable types that will be saved 
	(functions, userdata and coroutines will not). Circular references in tables may not 
	be preserved.
3. Saving tables 
	Tables are a great way to avoid having to use a large number of names in the global 
	namespace. However, they may be more difficult to initialize to default values when 
	your addon is updated and you add or remove a key. Multiple saved variables that 
	reference the same table will each create a separate (but identical) instance of the 
	table, and as such will no longer point to the same table when they are loaded again.
4. Variables are saved and loaded in the global environment 
	If you want to save a local value, you have to first read it from the global environment 
	(_G table) on ADDON_LOADED, then return it into the global environment before the 
		player logs out.

		_G[globalKey] = newValue
		value = _G[globalKey]


 ]]--********************************************************************************
--						CREATES THE EVENT HANDLING FRAME AND CALLS
--						THE HANDLER FOR THE BAG_UPDATE EVENT
-- ********************************************************************************

ADDON_HAS_BEEN_LOADED = false
sellGrey = true
sellWhite = false
isBagChecked = { false, false, false, false, false }

local function resetInitialConditions()
	ADDON_HAS_BEEN_LOADED = false
	sellGrey = true
	sellWhite = false
	isBagChecked = { false, false, false, false, false }
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
	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:RegisterEvent("ITEM_UNLOCKED")
	eventFrame:RegisterEvent("ITEM_PUSH") 
	eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")

	eventFrame:SetScript("OnEvent", 
	function( self, event, ... )
		local arg1 = ...

		bg:initializeBagTable()

		-- The saved variable, "isBagChecked" (a table), is read from the disk and initialized
		--     just before the ADDON_LOADED event is fired.
		if event == "ADDON_LOADED" and arg1 == "ChaChing" then


			-- if ADDON_HAS_BEEN_LOADED is false, then this is
			--    the first time ChaChing has been loaded
			if ADDON_HAS_BEEN_LOADED == false then
				-- E:where()

				-- print(" ")
				-- print("***************************************")
				-- print("***      UPON ADDON LOADING         ***")
				-- print("***************************************")
				-- print("ADDON_HAS_BEEN_LOADED = "..tostring(ADDON_HAS_BEEN_LOADED ))
				-- print( isBagChecked[1] )
				-- print( isBagChecked[2] )
				-- print( isBagChecked[3] )
				-- print( isBagChecked[4] )
				-- print( isBagChecked[5] )
				-- print("sellGrey = "..tostring(sellGrey) )
				-- print("sellWhite = "..tostring(sellWhite) )
				-- print(" ")
	
				ADDON_HAS_BEEN_LOADED = true
			end
		end

		-- This event is called when the player first logs in, enters or leaves an instance, respawns at a graveyard,
		-- and when the player's screen is reloaded.
		if event == "PLAYER_ENTERING_WORLD" then
			-- E:where()
			-- print(" ")
			-- print("***************************************")
			-- print("***   UPON PLAYER_ENTERING_WORLD    ***")
			-- print("***************************************")
			-- print("ADDON_HAS_BEEN_LOADED = "..tostring(ADDON_HAS_BEEN_LOADED ))
			-- print( isBagChecked[1] )
			-- print( isBagChecked[2] )
			-- print( isBagChecked[3] )
			-- print( isBagChecked[4] )
			-- print( isBagChecked[5] )
			-- print("sellGrey = "..tostring(sellGrey) )
			-- print("sellWhite = "..tostring(sellWhite) )
			-- print(" ")
			cha:CHACHING_InitializeOptions()
		end

		if event == "PLAYER_LOGOUT" then -- restore the defaults
			ADDON_HAS_BEEN_LOADED = false
			isBagChecked( false, false, false, false, false )
		end
	end)
