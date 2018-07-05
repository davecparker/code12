-----------------------------------------------------------------------------------------
--
-- text.lua
--
-- Implementation of the text output APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")
local GameObj = require("Code12.GameObjAPI")
local appContext = ct._appContext


---------------- Text Output API ---------------------------------------------

-- API
function ct.print(value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.print") then
		g.checkOnly1Param(...)
	end

	-- Print the value
	local text
	if value == nil then
		text = "null"
	else
		text = tostring(value)
	end
	if appContext then
		appContext.print(text)
	else
		io.write(text)
		io.flush()
	end
end

-- API
-- Note that ct.println() in the API must translate to ct.println("") in Lua,
-- otherwise null will be printed.
function ct.println(value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.println") then
		g.checkOnly1Param(...)
	end

	-- Print the value and a newline
	local text
	if value == nil then
		text = "null"
	else
		text = tostring(value)
	end
	if appContext then
		appContext.println(text)
	else
		io.write(text)
		io.write("\n")
		io.flush()
	end
end

-- Print a value as it should appear in ct.log output
local function logValue(value)
	if value == nil then
		ct.print("null")
	elseif type(value) == "string" then
		ct.print("\"")
		ct.print(value)
		ct.print("\"")
	elseif GameObj.isGameObj(value) then
		ct.print(value:toString())
	else
		ct.print(tostring(value))
	end
end

-- API
function ct.log(value, ...)
	-- Parameters can be any types or count, and the first value can be nil,
	-- so there's no parameter checking we can do.

	-- Treat the first value specially, so at least we can get "null" output
	-- if the client calls with an uninitialized object.
	-- Unfortunately, this can't work with multiple nils passed.
	logValue(value)

	-- Log remaining values passed, if any, separated by commas
	local args = {...}
	local n = #args
	if n > 0 then
		ct.print(", ")   -- comma after first value
		for i = 1, n - 1 do
			logValue(args[i])
			ct.print(", ")
		end
		logValue(args[n])  -- last arg without comma
	end

	-- End with a newline no matter what
	ct.print("\n")  
end

-- API
function ct.logm(message, value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.logm") then
		g.checkType(1, "string", message)
	end

	-- Print the message and log the values
	ct.print(message)
	ct.print(" ")
	ct.log(value, ...)
end
