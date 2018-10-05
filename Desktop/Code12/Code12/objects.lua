-----------------------------------------------------------------------------------------
--
-- objects.lua
--
-- Implementation of the GameObj creation APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local ct = require("Code12.ct")
local g = require("Code12.globals")
local GameObj = require("Code12.GameObjAPI")


---------------- GameObj Creation API ----------------------------------------

-- API
function ct.circle(x, y, diameter, color, ...)
	-- Check parameters
	if g.checkAPIParams("ct.circle") then
		g.checkTypes({"number", "number", "number"}, x, y, diameter)
		if color then
			g.checkType(4, "string", color)
		end
		g.checkNoMoreParams(...)
		diameter = g.checkParamNotNegative("diameter", diameter)
	end 

	-- Make the circle
	return GameObj:newCircle(g.screen.objs, x, y, diameter, color)
end

-- API
function ct.rect(x, y, width, height, color, ...)
	-- Check parameters
	if g.checkAPIParams("ct.rect") then
		g.checkTypes({"number", "number", "number", "number"}, x, y, width, height)
		if color then
			g.checkType(5, "string", color)
		end
		g.checkNoMoreParams(...)
		width = g.checkParamNotNegative("width", width)
		height = g.checkParamNotNegative("height", height)
	end 

	-- Make the rect
	return GameObj:newRect(g.screen.objs, x, y, width, height, color)
end

-- API
function ct.line(x1, y1, x2, y2, color, ...)
	-- Check parameters
	if g.checkAPIParams("ct.line") then
		g.checkTypes({"number", "number", "number", "number"}, x1, y1, x2, y2)
		if color then
			g.checkType(5, "string", color)
		end
		g.checkNoMoreParams(...)
	end 

	-- Make the line
	return GameObj:newLine(g.screen.objs, x1, y1, x2, y2, color)
end

-- API
function ct.text(text, x, y, height, color, ...)
	-- Check parameters
	text = text or ""
	if g.checkAPIParams("ct.text") then
		g.checkTypes({"string", "number", "number", "number"}, text, x, y, height)
		if color then
			g.checkType(5, "string", color)
		end
		g.checkNoMoreParams(...)
		height = g.checkParamNotNegative("height", height)
	end 

	-- Make the text
	return GameObj:newText(g.screen.objs, text, x, y, height, color)
end

-- API
function ct.image(filename, x, y, width, ...)
	-- Check parameters
	if g.checkAPIParams("ct.image") then
		g.checkTypes({"string", "number", "number", "number"}, filename or "", x, y, width, ...)
		filename = g.checkParamNotEmpty("filename", filename)
		width = g.checkParamNotNegative("width", width)
	end
	
	-- Make the text
	return GameObj:newImage(g.screen.objs, filename, x, y, width)
end

