-----------------------------------------------------------------------------------------
--
-- errors.lua
--
-- Error checking and reporting functions for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local ct = require("Code12.ct")
local g = require("Code12.globals")
local runtime = require("Code12.runtime")
local GameObj = require("Code12.GameObjAPI")


-- File local state for error reporting
local currentFunctionName = ""     -- string name of current API or method being executed
local errorStackLevel = 0          -- error reporting stack level relative to 0 for normal
local rgbWarningText = { 0.9, 0, 0.1 }   -- warnings in red


---------------- Error Reporting  --------------------------------------------

-- Print a warning message with optional quoted name
function g.warning(message, name)
	-- Look back on the stack trace to find the user's code (string)
	-- so we can get the line number.
	local info
	local level = 1
	repeat
		info = debug.getinfo(level, "Sl")
		level = level + 1
	until info == nil or info.short_src == '[string "..."]'
	
	-- Build and print the error	
	local s
	if info and info.currentline then
		s = "WARNING (line " .. info.currentline .. "): " .. message
	else
		s = "WARNING: " .. message
	end
	if name then
		s = s .. " \"" .. name .. "\""
	end
	runtime.printTextLine(s, rgbWarningText)
end

-- Generate a runtime error for the current function and stack level, with the given message.
local function apiError(message)
	-- Report at stack level relative to 4 to report the error at the client's API call.
	error("Function " .. currentFunctionName .. " " .. message, 4 + errorStackLevel)
end


---------------- Parameter Checking  -----------------------------------------

-- If parameter checking is enabled then set the function API name and stack reporting level 
-- relative to normal (default 0), and return true. Return false if checking is disabled.
function g.checkAPIParams(apiName, level)
	if ct.checkParams then
		currentFunctionName = apiName
		errorStackLevel = level or 0
		return true
	end
	return false
end

-- If parameter checking is enabled then check to make sure gameObj is a GameObj (generate
-- a runtime error if not), set the method name and stack reporting level relative
-- to normal (default 0), and return true. Return false if checking is disabled.
function g.checkGameObjMethodParams(gameObj, methodName, level)
	if ct.checkParams then
		currentFunctionName = methodName
		errorStackLevel = level or 0
		if not GameObj.isGameObj(gameObj) then
			apiError("must be called as a method on a GameObj, typically as obj:" .. methodName .. "(...)")
		end
		return true
	end
	return false
end

-- Return the type name of a value, substituting class names for known table types.
local function typeOrClass(value)
	local t = type(value)
	if t == "table" then
		if GameObj.isGameObj(value) then
			t = "GameObj"
		end
	end
	return t
end

-- Check to make sure the parameter list is empty for an api expecting no params.
-- Generate a runtime error if not.
function g.checkNoParams(...)
	if #{...} > 0 then
		apiError("does not take any parameters")
	end
end

-- Check to make sure the remaining parameter list is empty for an api expecting one param.
-- Generate a runtime error if not.
function g.checkOnly1Param(...)
	if #{...} > 0 then
		apiError("only takes one parameter")
	end
end

-- Check to make sure the remaining parameter list is empty.
-- Generate a runtime error if not.
function g.checkNoMoreParams(...)
	if #{...} > 0 then
		apiError("- too many parameters passed")
	end
end

-- Check the parameter type of an API expecting a single parameter, 
-- and make sure there are no extra parameters.
-- Generate a runtime error if there is a mismatch.
function g.check1Param(typeName, param, ...)
	if #{...} > 0 then
		apiError("only takes one parameter (a " .. typeName .. ")")
	elseif not param then
		apiError("- missing or null parameter (expected " .. typeName .. ")")
	else
		local t = typeOrClass(param)
		if t ~= typeName then
			apiError("requires a " .. typeName .. " parameter, not a " .. t)
		end
	end
end

-- Check the type of a parameter at the given position in a parameter list.
-- Generate a runtime error if there is a mismatch.
function g.checkType(position, tExpected, param)
	local tParam = typeOrClass(param)
	if tParam ~= tExpected then
		local strErr = "- parameter #" .. position
		if tParam == "nil" then
			strErr = strErr .. " is missing or null"
		else
		    strErr = strErr .. " should be a " .. tExpected .. " not a " .. tParam
		end
		apiError(strErr)
	end
end

-- Check the types of a parameter list to see if they match the types (string array). 
-- Generate a runtime error if there is a mismatch.
function g.checkTypes(types, ...)
	local args = {...}
	if #args > #types then
		apiError("- too many parameters passed")
	else   -- note that we can't really detect not enough params (looks same as nils)
		for i = 1, #types do
			local tExpected = types[i]
			local tGot = typeOrClass(args[i])
			if tGot ~= tExpected then
				local strErr = "- parameter #" .. i
				if tGot == "nil" then
					strErr = strErr .. " is missing or null (expected " .. tExpected .. ")"
				else
				    strErr = strErr .. " should be a " .. tExpected .. " not a " .. tGot
				end
				apiError(strErr)
			end
		end
	end
end 

-- Check the value of a numeric parameter for the current API name (as set by
-- g.checkAPIParams) to make sure it's not negative, and print a warning 
-- if it is. Return 0 if negative otherwise the original value.
function g.checkParamNotNegative(paramName, num)
	if num < 0 then
		g.warning(string.format("%s parameter to %s is negative (%d)",
						paramName, currentFunctionName, num))
		return 0
	end
	return num
end

-- Check the value of a string parameter for the current API name (as set by
-- g.checkAPIParams) to make sure it's not nil or empty, and print a warning 
-- if it is. Return nil if empty otherwise the original value.
function g.checkParamNotEmpty(paramName, str)
	if str == nil then
		g.warning(string.format("%s parameter to %s is null",
						paramName, currentFunctionName))
	elseif str == "" then
		g.warning(string.format("%s parameter to %s is empty string",
						paramName, currentFunctionName))
		return nil
	end
	return str
end

