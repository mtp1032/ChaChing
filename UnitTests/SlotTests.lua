--------------------------------------------------------------------------------------
-- SlotTests.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 19 June 2019
--------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.SlotTests = {}
slotTests = MTP.SlotTests

local L = MTP.L
local E = errors

local RARITY_GREY 		= 0
local RARITY_COMMON 	= 1
local RARITY_UNCOMMON	= 2
local RARITY__RARE 		= 3
local RARITY__EPIC 		= 4
local RARITY_LEGENDARY 	= 5
local RARITY_ARTIFACT 	= 6
local RARITY_HEIRLOOM 	= 7

local function getRarityColor( rarityIndex )
	local rarity = nil
	if rarityIndex < 0 then 
		return nil
	end
	if rarityIndex == 0 then 
		 rarity = "Grey" 
	end 
	if rarityIndex == 1 then 
		rarity = "Common"
	end
	if rarityIndex == 2 then 
		rarity = "Uncommon"
	end 
	if rarityIndex == 3 then 
		rarity = "Rare"
	end 
	if rarityIndex == 4 then 
		rarity = "Epic"
	end
	if rarityIndex == 5 then 
		rarity = "Legendary"
	end
	if rarityIndex == 6 then
		 rarity = "Artifact"
	end
	if rarityIndex == 7 then 
		rarity = "Heirloom"
	end

	return rarity
end

local testName = string.format("%s\n\n", "**** BEGIN SLOT TESTS ****")
mf:postMsg( testName )

-----------------------------------------------------------------------------------------
--                      SLOT CLASS TESTS
--
--	NOTE:	The Slot constructor is always and only called by valid Bag object. This means
--			that we do not have to check the validity of the bagId in the slot
--			constructor.
-----------------------------------------------------------------------------------------
-- Check that the correct error message is returned when an invalide bag Id is supplied.

local result = nil
local slotId = 1
local invalidSlotId = 52
local invalidBagId = 5
local slot = nil
local msg = nil
local bagId = 0

-- Bag is always installed in slot 1
slot = Slot( bagId, slotId )
result = slot:getResult()
if result[1] ~= STATUS_SUCCESS then	
	mf:postMsg(string.format("TEST 1: FAILED - %s\n", result[2]))
	return
end
msg = string.format("TEST 1: SUCCESS - Single Slot object created\n")
mf:postMsg( msg )

-- create all the slots of the player's backpack
local bag = Bag(0)

local totalSlots = bag:getTotalSlots()
for slotId = 1, totalSlots do
	slot = Slot(bagId, slotId )
	result = slot:getResult()
	if result[1] ~= STATUS_SUCCESS then
		E:postResult( result )
		return
	end
end
msg = string.format("TEST 2: SUCCESS - Created %d slots\n", totalSlots )
mf:postMsg(msg)

slot = Slot(5, Id )
result = slot:getResult()
if result[1] ~= STATUS_SUCCESS then
	msg = string.format("TEST 3: SUCCESS - Slot creation failed - bagId out of range\n")
	mf:postMsg(msg)
else
	E:postResult( result )
	return
end

slot = Slot(bagId, 57 )
result = slot:getResult()
if result[1] ~= STATUS_SUCCESS then
	msg = string.format("TEST 4: SUCCESS - Slot creation failed - slotId out of range\n")
	mf:postMsg(msg)
else
	E:postResult( result )
	return
end




--------------------------------------------------------------------
-- Test the slot query services
--------------------------------------------------------------------
mf:postMsg( string.format("\n-- Testing slot query methods\n\n"))

--	Create the slot objects for bagId = 4
bagId = 0
local bag = Bag(0)
totalSlots = bag:getTotalSlots()
for slotId = 1, totalSlots do
	local slot = Slot(bagId, slotId)
	if slot:getItemCount() > 0  then
		mf:postMsg(string.format("%s in slot %d\n", slot:getItemLink(), slotId ))
	end	
end

local endTestMsg = string.format("\n%s\n", "**** END SLOT TESTS ****")
mf:postMsg( endTestMsg )


