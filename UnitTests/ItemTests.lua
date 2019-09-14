--------------------------------------------------------------------------------------
-- ItemTests.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 7 June 2019
--------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.ItemTests = {}
slotTests = MTP.ItemTests

local L = MTP.L
local E = errors

local testName = string.format("%s\n\n", "**** BEGIN ITEM TESTS ****")
mf:postMsg( testName )

local result = SUCCESSFUL_RESULT

------------------------------ MISSING INPUT PARAMETER ----------------
mf:postMsg("TEST 1: Missing input parameter - ")
local item = Item()
result = item:getResult()
if result[1] == STATUS_FAILURE then
	mf:postMsg( string.format("Succeeded!\n"))
else
	mf:postMsg( string.format("Failed!\n"))
	return
end
---------------------- ARG INVALID TYPE -------------------------------
mf:postMsg("TEST 2: Invalid input type - ")
local emptyTable = {}
item = Item( emptyTable )
result = item:getResult()
if result[1] == STATUS_FAILURE then
	mf:postMsg( string.format("   Succeeded\n"))
else
	mf:postMsg( string.format("   Failed\n"))
	return
end
----------------------------- INVALID ITEM NAME -------------------------
mf:postMsg("TEST 3: Invalid item name - ")
local itemName = "foobar"
item = Item( itemName )
result = item:getResult()
if result[1] == STATUS_FAILURE then
	mf:postMsg( string.format("   Succeeded\n"))
else
	mf:postMsg( string.format("   Failed\n"))
	return
end
--------------------------- INVALID NUMERIC ID -------------------------------
mf:postMsg("TEST 4: invalid numeric Id - ")
local badNumber = 1988389393
item = Item( badNumber )
result = item:getResult()
if result[1] == STATUS_FAILURE then
	mf:postMsg( string.format("   Succeeded!\n"))
else
	mf:postMsg( string.format("   Failed!"))
	return
end
------------------------- TEST 5 VALID ITEM NAMES -----------------------------------------------
mf:postMsg( string.format("\nTEST 5: valid item names:\n"))
local itemNames = {
	"Boarhide Leggings",
	"Stormwind Guard Leggings",
	"Bloodsoaked Skullforge Reaver",
	"Small Pumpkin",
	"Refreshing Spring Water",
	"Rabbit's Foot",
	"Rich Illusion Dust",
	"Major Healing Potion"
}
for i = 1, 8 do
	print( itemNames[i])
	item = Item( itemNames[i] )
	result = item:getResult()
	if result[1] ~= STATUS_SUCCESS then
		E:postResult( result )
		return
	else
		local name, link = item:getNameAndLink()
		itemCount = item:getStackCount()
		msg = string.format("   Item Name and Link - %s %s: value %d\n", name, link )
		mf:postMsg( msg )
	end
end
----------------------------- TEST 6 VALID NUMERIC IDS ------------------------------------------------
mf:postMsg( string.format("\nTEST 6: valid numeric Ids:\n"))

BagId = 0 -- change to Bag 1 (an uninstalled bag)
local totalSlots = GetContainerNumSlots( BagId )
if totalSlots > 0 then
	for slot = 1, totalSlots do
		local itemId = GetContainerItemID( BagId, slot )
		if itemId ~= nil then
			item = Item( itemId )
			result = item:getResult()
			if result[1] ~= STATUS_SUCCESS then
				E:postResult( result )
				return
			end
			local name, link = item:getNameAndLink()
			msg = string.format("  Item Link - %s in slot %d of Bag %d\n", link, slot, BagId )
			mf:postMsg( msg )
		end
	end
else
	mf:postMsg(string.format("  Bag %d is not installed\n", BagId ))
end

local endTestMsg = string.format("\n%s\n", "**** END ITEM TESTS ****")
mf:postMsg( endTestMsg )
