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

-- cc:getGameVersion(), 
-- cc:getGameBuildNumber(), 
-- cc:getBuildDate(), 
-- cc:getAddonName(),
-- cc:getAddonTOC())

function Base:_init(...)
	self.is_a = "AbstractObject"
	self.result = DEFAULT_RESULT
	self.creationTimestamp = debugprofilestop()
	self.gameVersion 		= cc:getGameVersion()
	self.clientBuildNumber 	= cc:getGameBuildNumber()
	self.clientBuildDate 	= cc:getBuildDate()
	self.addonName 			= cc:getAddonName()
	self.addonTOC	 		= cc:getAddonTOC()
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
