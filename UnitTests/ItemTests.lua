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
----------------------------- TEST 6 VALID NUMERIC IDS ------------------------------------------------
mf:postMsg( string.format("\nTEST 5: Item Queries:\n"))

--	Query all the items in the player's backpack
local BACKPACK = 0
local bagId = BACKPACK
local bag = Bag(BACKPACK)

totalSlots = bag:getTotalSlots()
for slotId = 1, totalSlots do
	local slot = Slot(bagId, slotId)
	if slot:getItemCount() > 0  then
		local itemLink = slot:getItemLink()
		local item = Item(itemLink )
		local itemName = item:getName()
		local itemCount = item:getStackCount()
		local unitPrice = item:getUnitSalesPrice()
		local qualityName = item:getQualityName()
		local itemType = item:getType() -- Recipe, Quest, Trade Goods, etc.,
		local itemSubType = item:getSubType()
		local isCraftingReagent = item:isCraftingReagent()
		local itemDescr1 = string.format("%s costs %d per unit for a total price of %d\n", itemName, unitPrice, itemCount*unitPrice )
		local itemDescr2 = string.format("%s is of %s.\n", itemName, qualityName )
		local itemDescr3 = string.format("%s is a %s of type %s\n", itemName, itemSubType, itemType )
		local separator = string.format(".......................\n")
		mf:postMsg( itemDescr1..itemDescr2..itemDescr3..separator )
	end	
end



local endTestMsg = string.format("\n%s\n", "**** END ITEM TESTS ****")
mf:postMsg( endTestMsg )
