----------------------------------------------------------------------------------------
-- BaseClass.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 5 January, 2019
----------------------------------------------------------------------------------------

local ADDON_C_NAME, MTP = ...
MTP.BaseClass = {}	
Base = MTP.BaseClass

local L = MTP.L
local E = errors

-- ************************************************************************************
--                      BASE CLASS
-- ************************************************************************************
Base.__index = Base

setmetatable(Base, {
  __call = function (cls, ...)
    			local self = setmetatable({}, cls)
    			self:_init(...)
    			return self
  			end,
})

-- sb:getGameVersion(), 
-- sb:getGameBuildNumber(), 
-- sb:getBuildDate(), 
-- sb:getAddonName(),
-- sb:getAddonTOC())

function Base:_init(...)
	self.is_a = "AbstractObject"
	self.result = DEFAULT_RESULT
	self.creationTimestamp = debugprofilestop()
	self.gameVersion 		= sb:getGameVersion()
	self.clientBuildNumber 	= sb:getGameBuildNumber()
	self.clientBuildDate 	= sb:getBuildDate()
	self.addonName 			= sb:getAddonName()
	self.addonTOC	 		= sb:getAddonTOC()
end

--**********************************************************************
--                      		BASE METHODS
--**********************************************************************
function Base:type()
    return self.is_a
end

--**********************************************************************
--								DURATION IN MS
--**********************************************************************
function Base:getLifetime()
	return debugprofilestop() - self.creationTimestamp
end
--**********************************************************************
--								INFO SERVICES
--**********************************************************************
function Base:getResult()
    return self.result
end
function Base:getDescr()
    return string.format("Instance of a %s class, created: %d", self.is_a, self.creationTimestamp )
end
function Base:getGameVersion()
	return self.gameVersion
end
function Base:getClientBuildNumber()
	return self.clientBuildNumber
end
function Base:getClientBuildDate()
	return self.clientBuildDate
end
function Base:getAddonTOC()
	return self.addonTOC
end
function Base:getAddonName()
	return self.addonName
end
