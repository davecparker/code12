-----------------------------------------------------------------------------------------
--
-- misc.lua
--
-- Implementation of the Math and Misc. APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")


---------------- Math API ---------------------------------------------

-- API
function ct.random(min, max, ...)
	-- Check parameters
	if g.checkAPIParams("ct.random") then
		g.checkTypes({"number", "number"}, min, max, ...)
	end

	-- Calculate random
	return math.random(min, max)
end

-- API
function ct.round(x, numPlaces, ...)
	-- Check parameters
	if g.checkAPIParams("ct.round") then
		g.checkType(1, "number", x)
		if numPlaces then
			g.checkType(2, "number", numPlaces)
		end
		g.checkNoMoreParams(...)
	end

	-- Calculate round as necessary
	if numPlaces then
		local f = 10 ^ numPlaces
		return math.round(x * f) / f
	end
	return math.round(x)
end

-- API
function ct.intDiv( n, d, ... )
	-- Check parameters
	if g.checkAPIParams("ct.intDiv") then
		g.checkTypes({"number", "number"}, n, d, ...)
	end

	return math.floor( n / d )
end

-- API
function ct.isError(x, ...)
	-- Check parameters
	if g.checkAPIParams("ct.isError") then
		g.check1Param("number", x, ...)
	end

	-- Return true iff x is Nan
	return x ~= x   -- NaN is not equal to itself but everything else is
end

-- API
function ct.distance(x1, y1, x2, y2, ...)
	-- Check parameters
	if g.checkAPIParams("ct.distance") then
		g.checkTypes({"number", "number", "number", "number"}, x1, y1, x2, y2, ...)
	end

	-- Calculate distance
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end


---------------- Misc API ---------------------------------------------

-- API
function ct.getTimer(...)
	-- Check parameters
	if g.checkAPIParams("ct.getTimer") then
		g.checkNoParams(...)
	end

	-- Return difference between current time and start time
	if g.startTime then
		return system.getTimer() - g.startTime
	end
	return 0   -- called before first update, just return 0
end

-- API
function ct.getVersion(...)
	-- Check parameters
	if g.checkAPIParams("ct.getVersion") then
		g.checkNoParams(...)
	end

	-- Return the Code 12 runtime version
	return g.version 
end

