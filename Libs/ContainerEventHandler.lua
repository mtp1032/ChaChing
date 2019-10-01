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

				-- 						UNCOMMENT FOR DEBUGGING
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

				-- 						UNCOMMENT FOR DEBUGGING
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

		-- Restore the saved variables (see ChaChing.toc) to their default states
		if event == "PLAYER_LOGOUT" then
			ADDON_HAS_BEEN_LOADED = false
			isBagChecked( false, false, false, false, false )
		end
	end)

--[[ 
https://wow.gamepedia.com/API_PickupItem

Example: Picks up the hearthstone

PickupItem(6948)
PickupItem("item:6948")
PickupItem("Hearthstone")
PickupItem(GetContainerItemLink(0, 1))

https://wow.gamepedia.com/API_PickupContainerItem

The function behaves differently depending on what is currently on the cursor:

If the cursor currently has nothing, calling this will pick up an item from your backpack.
If the cursor currently contains an item (check with CursorHasItem()), calling this will place 
the item currently on the cursor into the specified bag slot. If there is already an item in 
that bag slot, the two items will be exchanged.

If the cursor is set to a spell (typically enchanting and poisons, check with SpellIsTargeting()), 
calling this specifies that you want to cast the spell on the item in that bag slot.

Trying to pickup the same item twice in the same "time tick" does not work (client seems 
to flag the item as "locked" and waits for the server to sync). This is only a problem if 
you might move a single item multiple times (i.e., if you are changing your character's 
equipped armor, you are not likely to move a single piece of armor more than once). If 
you might move an object multiple times in rapid succession, you can check the item's 
'locked' flag by calling GetContainerItemInfo. If you want to do this, you should leverage 
OnUpdate to help you. Avoid constantly checking the lock status inside a tight loop. If you 
do, you risk getting into a race condition. Once the repeat loop starts running, the client 
will not get any communication from the server until it finishes. However, it will not 
finish until the server tells it that the item is unlocked. Here is some sample code that 
illustrates the problem.

https://wow.gamepedia.com/API_GetCursorInfo

Example: Print information about the item currently held by the cursor

local infoType, itemID, itemLink = GetCursorInfo()
if infoType == "item" then
 print("You have " .. GetItemCount(itemLink) .. "x" .. itemLink .. " in your bags.")
else
 print("You're not holding an item on your cursor.")
end

https://wow.gamepedia.com/API_DropItemOnUnit


 ]]