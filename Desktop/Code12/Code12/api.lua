-----------------------------------------------------------------------------------------
--
-- api.lua
--
-- The top-level module for the Lua implementation of the Code12 API.
-- See the definition of the Code12 API functions in API.html.
-- The Lua implementation uses the Corona SDK.
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------


-- Support modules
local ct = require("Code12.ct")              -- public APIs
local g = require("Code12.globals")          -- internal global data
local runtime = require("Code12.runtime")    -- runtime control

-- The GameObj class
local GameObj = require("Code12.GameObj")

-- These API groups are implemented in sub-modules
require("Code12.text")          -- Text Output
require("Code12.dialogs")       -- Alerts and Input Dialogs
require("Code12.screens")       -- Screen Management
require("Code12.input")         -- Mouse and Keyboard Input
require("Code12.audio")         -- Audio


---------------- Graphic Object Creation -------------------------------------

-- API
function ct.circle(x, y, diameter, color)
	return GameObj:newCircle(g.screen.objs, x, y, diameter, color)
end

-- API
function ct.rect(x, y, width, height, color)
	return GameObj:newRect(g.screen.objs, x, y, width, height, color)
end

-- API
function ct.line(x1, y1, x2, y2, color)
	return GameObj:newLine(g.screen.objs, x1, y1, x2, y2, color)
end

-- API
function ct.text(text, x, y, height, color)
	return GameObj:newText(g.screen.objs, text, x, y, height, color)
end

-- API
function ct.image(filename, x, y, width)
	return GameObj:newImage(g.screen.objs, filename, x, y, width)
end


---------------- Math Utilities API -----------------------------------

-- API
function ct.random(min, max)
	if max < min then
		runtime.warning( "ct.random has max < min" )
		max = min
	end
	return math.random(min, max)
end

-- API
function ct.round(x)
	return math.round(x)
end

-- API
function ct.roundDecimal(x, numPlaces)
	local f = 10 ^ g.forceNotNegative(numPlaces)
	return math.round(x * f) / f
end

-- API
function ct.distance(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end

-- API
function ct.intDiv(n, d)
	return math.floor( n / d )
end

-- API
function ct.isError(x)
	return x ~= x   -- NaN is not equal to itself but everything else is
end


---------------- Type Conversion API -----------------------------------------

-- API
function ct.parseInt(s)
	if s ~= nil then
		-- Try to convert string to integer
		local i = tonumber(s)
		if i and i == math.round(i) then
			return i
		end
	end
	return 0   -- failure
end

-- API
function ct.parseNumber(s)
	if s ~= nil then
		-- Try to convert string to number
		local x = tonumber(s)
		if x then
			return x
		end
	end
	return (0 / 0)   -- NaN indicates failure
end

-- API
function ct.canParseInt(s)
	if s ~= nil then
		-- See if we can convert string to number
		local i = tonumber(s)
		if i and i == math.round(i) then
			return true
		end
	end
	return false
end

-- API
function ct.canParseNumber(s)
	if s ~= nil then
		-- See if we can convert string to number
		local x = tonumber(s)
		if x then
			return true
		end
	end
	return false
end

-- API
function ct.formatInt(i, numPlaces)
	i = math.round(i)
	if numPlaces then
		numPlaces = g.forceNotNegative(numPlaces)
		return string.format("%0" .. numPlaces .. "d", i)
	end
	return tostring(i)
end

-- API
function ct.formatDecimal(x, numPlaces)
	if numPlaces then
		numPlaces = g.forceNotNegative(numPlaces)
		return string.format("%." .. numPlaces .. "f", x)
	end
	return tostring(x)
end


---------------- Program Control API ----------------------------------

-- API
function ct.getTimer()
	-- Return difference between current time and start time
	if g.startTime then
		return system.getTimer() - g.startTime
	end
	return 0   -- called before start
end

-- API
function ct.getVersion()
	return g.version 
end

-- API
function ct.pause()
	-- This API is ignored if not running in the Code12 app
	if runtime.appContext then 
		--Gets the line number and assembles the paused message
		local message = "Program paused by ct.paused()"; --In case lineNum unknown
		local lineNum = runtime.userLineNumber()
		if lineNum then
			message = "Paused by ct.pause() at line " .. lineNum 
		end
		ct.showAlert(message);

		-- Change run state to paused then block and yield
		g.runState = "paused"
		runtime.getUserLocals( 2 )   -- get snapshot of locals for varWatch
		repeat
			if runtime.blockAndYield() == "abort" then
				g.runState = "stopped"
				error("aborted")   -- caught by the runtime
			end
		until g.runState ~= "paused"
	end
end

-- API
function ct.stop()
	-- This API is ignored if not running in the Code12 app
	if runtime.appContext then 
		-- Block, signal the main thread to stop, and wait for the
		-- main thread to kill the user coroutine.
		runtime.message("Program stopped by ct.stop()")
		repeat
			if runtime.blockAndYield("stop") == "abort" then
				error("stopped")   -- caught by the runtime
			end
		until false
	end
end

-- API
function ct.restart()
	-- Block, signal the main thread to restart, and wait for the
	-- main thread to kill the user coroutine.
	repeat
		if runtime.blockAndYield("restart") == "abort" then
			error("restarted")   -- caught by the runtime
		end
	until false
end


-------------- Internal APIs for code gen (not documented) ----------------

-- Return x truncated to an integer for an (int) type cast
function ct.toInt(x)
	return math.floor(x)
end


-------------- String API Support Functions (not documented) --------------

-- Compare strings s1 and s2 as per Java's s1.compareTo( s2 )
function ct.stringCompare(s1, s2)
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
function ct.indexOfString(s1, s2)
	return ((s1 and s2 and string.find( s1, s2, 1, true )) or 0) - 1
end

-- Return a substring per Java's s:substring( iBegin, iEnd )
-- iEnd is optional, the indexes are 0-based, and the substring ends before iEnd.
function ct.substring(s, iBegin, iEnd)
	if s == nil then
		return nil
	end
	return string.sub( s, iBegin + 1, iEnd )
end

-- Return string with leading and trailing whitespace removed,
-- as per Java's s:trim()
function ct.trimString(s)
	if s == nil then
		return nil
	end
	-- This is trim6 from http://lua-users.org/wiki/StringTrim
	return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end


-------------- Array Support Functions (not documented) --------------

-- Notify the app context (if any) that an array was assigned.
function ct.arrayAssigned()
	if runtime.appContext then
		runtime.appContext.arrayAssigned()
	end
end

-- Check the index of the array and generate a runtime error if invalid.
-- Use errLevel (or default 2) for the Lua stack error level. 
function ct.checkArrayIndex(array, index, errLevel)
	if array == nil then
		error( "Array is null", errLevel or 2)
	elseif index < 0 or index >= array.length then 
		error( "Array index [" .. index .. "] is out of bounds", errLevel or 2)
	end
end

-- Return the array element at the given index, generating a runtime error
-- if the index is invalid.
function ct.indexArray(array, index)
	ct.checkArrayIndex( array, index, 3 )
	return array[index + 1] or array.default   -- Lua arrays are 1-based
end


