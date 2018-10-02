-----------------------------------------------------------------------------------------
--
-- text.lua
--
-- Implementation of the text output APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local ct = require("Code12.ct")
local g = require("Code12.globals")
local runtime = require("Code12.runtime")
local GameObj = require("Code12.GameObjAPI")


-- File local data
local rgbLogText = { 0, 0, 1 }    -- ct.log console output is blue


---------------- Internal Functions ------------------------------------------

-- Return the text to print for the given value
local function textForValue(value)
	if value == nil then
		return "null"
	elseif type(value) == "string" then
		return value
	elseif GameObj.isGameObj(value) then
		return value:toString()
	else
		return tostring(value)
	end
end

-- Print a value as it should appear in ct.log output
local function logValue(value)
	if type(value) == "string" then
		runtime.printText("\"")
		runtime.printText(value)
		runtime.printText("\"")
	else
		runtime.printText(textForValue(value))
	end
end


---------------- Text Output API ---------------------------------------------

-- API
function ct.print(value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.print") then
		g.checkOnly1Param(...)
	end

	-- Convert value to text and print it
	runtime.printText(textForValue(value))
end

-- API
-- Note that ct.println() in the API must translate to ct.println("") in Lua,
-- otherwise null will be printed.
function ct.println(value, ...)
	-- Check parameters
	if g.checkAPIParams("ct.println") then
		g.checkOnly1Param(...)
	end

	-- Convert value to text and print it
	runtime.printTextLine(textForValue(value))
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
		runtime.printText(", ")   -- comma after first value
		for i = 1, n - 1 do
			logValue(args[i])
			runtime.printText(", ")
		end
		logValue(args[n])  -- last arg without comma
	end

	-- End with a newline no matter what
	runtime.printTextLine("", rgbLogText )  
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

-- API
function ct.setOutputFile(filename, ...) 
	-- Check parameters
	if filename ~= nil then
		if g.checkAPIParams("ct.setOutputFile") then
			g.check1Param("string", filename, ...)
		end
	end

	-- Close existing output file if any
	if g.outputFile then
		g.outputFile:close()
		g.outputFile = nil
	end

	-- Open the new output file, if any
	if filename then
		local path = filename
		if runtime.appContext and runtime.appContext.sourceDir then
			path = runtime.appContext.sourceDir .. filename
		end
		g.outputFile = io.open(path, "w")
		if g.outputFile == nil then
			g.warning("Could not open output file", filename)
		end
	end
end

