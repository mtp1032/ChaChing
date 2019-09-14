----------------------------------------------------------------------------------------
-- BlizzWrappers.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 24 June, 2019
----------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.BlizzWrapper = {}
bw = MTP.BlizzWrapper	

local L = MTP.L
local E = errors

local isClassic = false

function bw:unitGUID( unit)
	if isClassic then
	end
	return UnitGUID( unit)
end
function bw:getPlayerInfoByGUID( guif )
	if isClassic then
	end
	return GetPlayerInfoByGUID( guid )
end
function bw:getBagName( bagSlot )
	if  isClassic then
	end

	return GetBagName( bagSlot )
end
-- Container Services
function bw:getContainerItemID( bagSlot, slotId )
	if isClassic then
	end
  	return GetContainerItemID( bagSlot, slotId )
end
function bw:getContainerItemInfo( bagSlot, slotId )
	if isClassic then
	end
	return GetContainerItemInfo( bagSlot, slotId )
end
function bw.getContainerItemLink( bagSlot, slotId )
	if isClassic then
	end
	return GetContainerItemLink( bagSlot, slotId )
end
function bw:getContainerNumSlots( bagSlot )
	E:where()
	return GetContainerNumSlots( bagSlot )
end
function bw:getContainerNumFreeSlots( bagSlot )
	if isClassic then
	end
	return GetContainerNumFreeSlots( bagSlot )
end
function bw:useContainerItem( bagSlot, slotId )
	if isClassic then
	end
	return UseContainerItem(bagSlot, slotId )
end
function bw:getInventoryItemLink( unit, inventoryId )
	if isClassic then
	end
	return GetInventoryItemLink( unit, inventoryId )
end
function bw:containerIDToInventoryID( containerId )
	if isClassic then
	end
	return ContainerIDToInventoryID( containerId )
end
