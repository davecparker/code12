-----------------------------------------------------------------------------------------
--
-- misc.lua
--
-- Implementation of the Math and Misc. APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local ct = require("Code12.ct")
local g = require("Code12.globals")


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
function ct.round(x, ...)
	-- Check parameters
	if g.checkAPIParams("ct.round") then
		g.check1Param("number", x, ...)
	end

	-- Do the round
	return math.round(x)
end

-- API
function ct.roundDecimal(x, numPlaces, ...)
	-- Check parameters
	if g.checkAPIParams("ct.roundDecimal") then
		g.checkTypes({"number", "number"}, x, numPlaces, ...)
	end

	-- Calculate the round
	local f = 10 ^ numPlaces
	return math.round(x * f) / f
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
	return 0   -- called before start
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


-------------- String API Support Functions (not published) --------------

-- Compare strings s1 and s2 as per Java's s1.compareTo( s2 )
function ct.stringCompare( s1, s2 )
	if s1 == s2 then
		return 0
	elseif s1 == nil then
		return -1
	elseif s2 == nil then
		return 1
	elseif s1 < s2 then
		return -1
	else
		return 1
	end
end

-- Return the 0-based index for substring search or -1 if not found,
-- as per Java's s1.indexOf( s2 )
function ct.indexOfString( s1, s2 )
	return ((s1 and s2 and string.find( s1, s2, 1, true )) or 0) - 1
end

-- Return a substring per Java's s:substring( iBegin, iEnd )
-- iEnd is optional, the indexes are 0-based, and the substring ends before iEnd.
function ct.substring( s, iBegin, iEnd )
	if s == nil then
		return nil
	end
	return string.sub( s, iBegin + 1, iEnd )
end

-- Return string with leading and trailing whitespace removed,
-- as per Java's s:trim()
function ct.trimString( s )
	if s == nil then
		return nil
	end
	-- This is trim6 from http://lua-users.org/wiki/StringTrim
	return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end


-------------- Array Support Functions (not published) --------------

-- Check the index of the array and generate a runtime error if invalid.
-- Use errLevel (or default 2) for the Lua stack error level. 
function ct.checkArrayIndex( array, index, errLevel )
	if array == nil then
		error( "Array is null", errLevel or 2)
	elseif index < 0 or index >= array.length then 
		error( "Array index [" .. index .. "] is out of bounds", errLevel or 2)
	end
end

-- Return the array element at the given index, generating a runtime error
-- if the index is invalid.
function ct.indexArray( array, index )
	ct.checkArrayIndex( array, index, 3 )
	return array[index + 1] or array.default
end

