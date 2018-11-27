-----------------------------------------------------------------------------------------
--
-- text.lua
--
-- Implementation of the text output APIs for the Code12 Lua runtime.
--
-- (c)Copyright 2018 by Code12. All Rights Reserved.
-----------------------------------------------------------------------------------------


-- Runtime support modules
local ct = require("Code12.ct")
local g = require("Code12.globals")
local runtime = require("Code12.runtime")
local GameObj = require("Code12.GameObj")


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
	elseif type(value) == "table" and value.length then
		return "[array of length " .. value.length .. "]"
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
function ct.print(value)
	-- Convert value to text and print it
	runtime.printText(textForValue(value))
end

-- API
-- Note that ct.println() in the API must translate to ct.println("") in Lua,
-- otherwise null will be printed.
function ct.println(value)
	-- Convert value to text and print it
	runtime.printTextLine(textForValue(value))
end

-- API
function ct.log(value, ...)
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
	-- Print the message and log the values
	ct.print(message)
	ct.print(" ")
	ct.log(value, ...)
end

-- API
function ct.setOutputFile(filename) 
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
			runtime.warning("Could not open output file", filename)
		end
	end
end

