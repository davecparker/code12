-----------------------------------------------------------------------------------------
--
-- GameObjAPI.lua
--
-- Implementation of the GameObj public API methods for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")
local GameObj = require("Code12.GameObj")


---------- Public GameObj APIs -----------------------------------------------

-- API
function GameObj:getType(...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "getType") then
		g.checkNoParams(...)
	end

	-- Return the type name
	return self._code12.typeName
end

-- API
function GameObj:getText(...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "getText") then
		g.checkNoParams(...)
	end

	-- Return the text
	return self._code12.text
end

-- API
function GameObj:setText(text, ...)
	-- Check parameters
	if text ~= nil then
		if g.checkGameObjMethodParams(self, "setText") then
			g.check1Param("string", text, ...)
		end
	end

	-- Set the text
	self._code12.text = text
	self._code12.obj.text = text
	-- TODO: Re-measure text
end

-- API
function GameObj:toString(...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "toString") then
		g.checkNoParams(...)
	end

	-- Return string description for use by ct.log, etc.
	local s = "[" .. self._code12.typeName .. " at (" .. 
			math.round(self.x) .. ", " .. math.round(self.y) .. ")"
	if self._code12.text then
		s = s .. " \"" .. self._code12.text .. "\""
	end
	return s .. "]"
end

-- API
function GameObj:setSize(width, height, ...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "setSize") then
		g.checkTypes({"number", "number"}, width, height, ...)
	end

	-- This is just a convenience method to set the public fields
	self.width = width
	self.height = height
end

-- API
function GameObj:align(alignment, adjustY, ...)
	-- Check parameters
	alignment = alignment or "center"
	if g.checkGameObjMethodParams(self, "align") then
		g.checkType(1, "string", alignment)
		if adjustY then
			g.checkType(2, "boolean", adjustY)
		end
		g.checkNoMoreParams(...)
	end

	-- Set object alignment and remember adjustY
	self:setAlignmentFromName(alignment)
	self._code12.adjustY = adjustY
end

-- API
function GameObj:setFillColor(colorName, ...)
	-- Check parameters
	if colorName ~= nil then
		if g.checkGameObjMethodParams(self, "setFillColor") then
			g.check1Param("string", colorName, ...)
		end
	end

	-- Set the color
	self:setFillColorFromName(colorName)
end

-- API
function GameObj:setFillColorRGB(red, green, blue, ...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "setFillColorRGB") then
		g.checkTypes({"number", "number", "number"}, red, green, blue, ...)
	end

	-- Set the color
	self:setFillColorFromColor({red, green, blue})
end

-- API
function GameObj:setLineColor(colorName, ...)
	-- Check parameters
	if colorName ~= nil then
		if g.checkGameObjMethodParams(self, "setLineColor") then
			g.check1Param("string", colorName, ...)
		end
	end

	-- Set the color
	self:setLineColorFromName(colorName)
end

-- API
function GameObj:setLineColorRGB(red, green, blue, ...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "setLineColorRGB") then
		g.checkTypes({"number", "number", "number"}, red, green, blue, ...)
	end

	-- Set the color
	self:setLineColorFromColor({red, green, blue})
end

-- API
function GameObj:getLayer(...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "getLayer") then
		g.checkNoParams(...)
	end

	-- Return the layer number
	return self._code12.layer;
end

-- API
function GameObj:setLayer(layer, ...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "setLayer") then
		g.check1Param("number", layer, ...)
	end

	-- Change the stored layer number
	self._code12.layer = layer

	-- Re-insert the display object at the top the layer
	local obj = self._code12.obj
	local objs = obj.parent
	local i = objs.numChildren
	while i > 0 do
		local gameObj = objs[i].code12GameObj
		if gameObj and gameObj ~= self and gameObj._code12.layer <= layer then
			break
		end
		i = i - 1
	end
	objs:insert(i + 1, obj)
end

-- API
function GameObj:delete(...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "delete") then
		g.checkNoParams(...)
	end

	-- Delete it
	self:removeAndDelete()
end

-- API
function GameObj:clicked(...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "clicked") then
		g.checkNoParams(...)
	end

	-- Return true this is the clicked object
	return (g.gameObjClicked == self)
end

-- API
function GameObj:containsPoint(x, y, ...)
	-- Check parameters
	if g.checkGameObjMethodParams(self, "containsPoint") then
		g.checkTypes({"number", "number"}, x, y, ...)
	end

	-- Run the appropriate hit test method
	return self:objContainsPoint(x, y)
end

-- API
function GameObj:hit(gameObj, ...)
	if gameObj == nil or gameObj._code12.deleted or self._code12.deleted then
		return false
	end

	-- Check parameters
	-- Note: If called as obj.hit, not detected due to gameObj (bummer)
	if g.checkGameObjMethodParams(self, "hit") then
		g.check1Param("GameObj", gameObj, ...)
	end

	-- Do hit test
	return self:hitObj(gameObj)
end


------------------------------------------------------------------------------
------------------------------------------------------------------------------

return GameObj
