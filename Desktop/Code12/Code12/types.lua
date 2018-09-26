-----------------------------------------------------------------------------------------
--
-- types.lua
--
-- Implementation of the type conversion APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local ct = require("Code12.ct")
local g = require("Code12.globals")


---------------- Type Conversion API -----------------------------------------

-- API
function ct.toInt(x, ...)
	-- Check parameters
	if g.checkAPIParams("ct.toInt") then
		g.check1Param("number", x, ...)
	end

	-- Truncate to int
	return math.floor(x)
end

-- API
function ct.parseInt(s, ...)
	if s ~= nil then
		-- Check parameters
		if g.checkAPIParams("ct.parseInt") then
			g.check1Param("string", s, ...)
		end

		-- Try to convert string to integer
		local i = tonumber(s)
		if i and i == math.round(i) then
			return i
		end
	end
	return 0   -- failure
end

-- API
function ct.canParseInt(s, ...)
	if s ~= nil then
		-- Check parameters
		if g.checkAPIParams("ct.canParseInt") then
			g.check1Param("string", s, ...)
		end

		-- See if we can convert string to number
		local i = tonumber(s)
		if i and i == math.round(i) then
			return true
		end
	end
	return false
end

-- API
function ct.parseNumber(s, ...)
	if s ~= nil then
		-- Check parameters
		if g.checkAPIParams("ct.parseNumber") then
			g.check1Param("string", s, ...)
		end

		-- Try to convert string to number
		local x = tonumber(s)
		if x then
			return x
		end
	end
	return (0 / 0)   -- NaN indicates failure
end

-- API
function ct.canParseNumber(s, ...)
	if s ~= nil then
		-- Check parameters
		if g.checkAPIParams("ct.canParseNumber") then
			g.check1Param("string", s, ...)
		end

		-- See if we can convert string to number
		local x = tonumber(s)
		if x then
			return true
		end
	end
	return false
end

-- API
function ct.formatDecimal(x, numPlaces, ...)
	-- Check parameters
	if g.checkAPIParams("ct.formatDecimal") then
		g.checkType(1, "number", x)
		if numPlaces then
			g.checkType(2, "number", numPlaces)
		end
		g.checkNoMoreParams(...)
	end

	-- Format decimal, with fixed decimal places if requested
	if numPlaces then
		return string.format("%." .. numPlaces .. "f", x)
	end
	return tostring(x)
end

-- API
function ct.formatInt(i, numPlaces, ...)
	-- Check parameters
	if g.checkAPIParams("ct.formatInt") then
		g.checkType(1, "number", i)
		if numPlaces then
			g.checkType(2, "number", numPlaces)
		end
		g.checkNoMoreParams(...)
	end

	-- Round to integer if not already
	i = math.round(i)

	-- Format the integer with leading zeros if requested
	if numPlaces then
		return string.format("%0" .. numPlaces .. "d", i)
	end
	return tostring(i)
end

