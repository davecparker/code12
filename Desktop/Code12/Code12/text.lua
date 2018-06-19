-----------------------------------------------------------------------------------------
--
-- text.lua
--
-- Implementation of the text input and output APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")
local GameObj = require("Code12.GameObjAPI")


---------------- Text Output API ---------------------------------------------

-- API
function ct.print(value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.print") then
		g.checkOnly1Param(...)
	end

	-- Print the value
	io.write(tostring(value))
	io.flush()
end

-- API
-- Note that ct.println() in the API must translate to ct.println("") in Lua
function ct.println(value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.println") then
		g.checkOnly1Param(...)
	end

	-- Print the value and a newline
	io.write(tostring(value))
	io.write("\n")
	io.flush()
end

-- Print a value as it should appear in ct.log output
local function logValue(value)
	if type(value) == "string" then
		io.write("\"")
		io.write(value)
		io.write("\"")
	elseif GameObj.isGameObj(value) then
		io.write(value:toString())
	else
		io.write(tostring(value))
	end
end

-- API
function ct.log(value, ...)
	-- Parameters can be any types or count, and the first value can be nil,
	-- so there's no parameter checking we can do.

	-- Treat the first value specially, so at least we can get "nil" output
	-- if the client calls with an undefined variable.
	-- Unfortunately, this can't work with multiple nils passed.
	logValue(value)

	-- Log remaining values passed, if any, separated by commas
	local args = {...}
	local n = #args
	if n > 0 then
		io.write(", ")   -- comma after first value
		for i = 1, n - 1 do
			logValue(args[i])
			io.write(", ")
		end
		logValue(args[n])  -- last arg without comma
	end

	-- End with a newline no matter what
	io.write("\n")  
	io.flush()
end

-- API
function ct.logm(message, value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.logm") then
		g.checkType(1, "string", message)
	end

	-- Print the message and log the values
	io.write(message)
	io.write(" ")
	ct.log(value, ...)
end


---------------- Text Input API ---------------------------------------------

-- Check API params for the API as set by a previous call to g.checkAPIParams, then
-- output message if not nil, then input a string up to the end of line and return it. 
local function inputLine(message, ...)
	-- Check parameters
	if g.checkParams then
		-- The message must be a string or nil
		if message then
			g.check1Param("string", message, ...)
		end
		g.checkNoMoreParams(...)
	end

	-- Print the message followed by a space
	if message then
		io.write(message)
		io.write(" ")
		io.flush()
	end

	-- Input a string and return it
	return io.read() or ""    -- read to end of line
end

-- API
function ct.inputInt(message, ...)
	-- Set API so inputString can check the params
	g.checkAPIParams("ct.inputInt", 1)

	-- Input a string and try to convert to an int
	local n = tonumber(inputLine(message, ...))
	if n and (math.round(n) == n) then
		return n
	end
	return 0   -- 0 if error
end

-- API
function ct.inputNumber(message, ...)
	-- Set API so inputString can check the params
	g.checkAPIParams("ct.inputNumber", 1)

	-- Input a string and try to convert to a number
	return tonumber(inputLine(message, ...)) or (0 / 0)   -- NaN if error
end

-- API
function ct.inputBoolean(message, ...)
	-- Set API so inputString can check the params
	g.checkAPIParams("ct.inputBoolean", 1)

	-- Input a string and check the first non-black char to determine value
	local s = ct.inputLine(message)
	for i = 1, string.len(s) do    -- look for first non-whitespace char
		local ch = string.lower(string.sub(s, i, i))
		if ch == "y" or ch == "t" or ch == "1" then    -- yes, true, 1, etc.
			return true
		elseif ch ~= " " and ch ~= "\t" then
			return false
		end
	end
	return false
end

-- API
function ct.inputString(message, ...)
	-- Set API so inputString can check the params
	g.checkAPIParams("ct.inputString", 1)

	-- Input the string
	return inputLine(message, ...)
end