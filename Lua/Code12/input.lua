-----------------------------------------------------------------------------------------
--
-- input.lua
--
-- Implementation of the touch and key input handling for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
----------------------------------------------------------------------------------------

local g = require("Code12.globals")
local ct = require("Code12.runtime")
local GameObj = require("Code12.GameObjAPI")


---------------- Touch Tracking ----------------------------------------------

-- Set the last click state, then call the client event function (if any) 
-- for the given touch event and gameObj.
local function clickEvent(event, gameObj)
	-- Get logical click location 
	local x = event.x / g.scale
	local y = event.y / g.scale

	if event.phase == "began" then
		-- Set last click state
		g.clicked = true
		g.gameObjClicked = gameObj
		g.clickX = x
		g.clickY = y

		-- Call client event
		if type(onMousePress) == "function" then
			onMousePress(gameObj, x, y)
		end

		-- Automatically take the touch focus on an object.
		if gameObj then
			display.getCurrentStage():setFocus(event.target)
		end
	elseif event.phase == "moved" then
		-- Call client event
		if type(onMouseDrag) == "function" then
			onMouseDrag(gameObj, x, y)
		end
	else  -- (ended or cancelled)
		-- Call client event
		if type(onMouseRelease) == "function" then
			onMouseRelease(gameObj, x, y)
		end

		-- Release touch focus if any
		display.getCurrentStage():setFocus(nil)
	end
end

-- Handle a Corona touch event on the Runtime
function g.onTouchRuntime(event)
	clickEvent(event, nil)
	return true
end

-- Handle a Corona touch event on a GameObj
function g.onTouchGameObj(event)
	local gameObj = event.target.code12GameObj
	if gameObj.clickable then
		clickEvent(event, event.target.code12GameObj)
		return true
	end
	return false
end


---------------- Key Tracking ------------------------------------------------

-- Set of keys currently down, indexed by key name (true if down, nil if not)
local keysDown = {}

-- Some key ASCII values
local ASCII_a = string.byte("a")
local ASCII_z = string.byte("z")

-- Table of shifted non-alpha key characters (US standard keyboard layout)
local shiftedKeys = {
	["`"] = "~", ["1"] = "!", ["2"] = "@", ["3"] = "#", ["4"] = "$", ["5"] = "%", 
	["6"] = "^", ["7"] = "&", ["8"] = "*", ["9"] = "(", ["0"] = ")", ["-"] = "_", ["="] = "+", 
	["["] = "{", ["]"] = "}", ["\\"] = "|", 
	[";"] = ":", ["'"] = "\"", 
	[","] = "<", ["."] = ">", ["/"] = "?", 
}


-- Return char typed given a key down event or nil if none.
-- TODO: Corona doesn't provide this info, so we supply a simple mapping for
-- common keys here. Unfortunately it will only apply to standard US keyboards.
local function charTypedFromKeyEvent(event)
	-- Shift is the only modifier that can generate a typed char
	if event.isAltDown or event.isCommandDown or event.isCtrlDown then
		return nil
	end

	-- Handle special key names we know about
	local keyName = event.keyName
	if keyName == "space" then
		return " "
	elseif keyName == "enter" then
		return "\n"
	elseif keyName == "tab" then
		return "\t"
	end

	-- Ignore other special keys with keyName longer than one char
	if string.len(keyName) ~= 1 then
		return nil
	end

	-- Handle a-z and A-Z
	local ascii = string.byte(keyName)
	if ascii >= ASCII_a and ascii <= ASCII_z then
		if event.isShiftDown then
			return string.upper(keyName)
		end
		return keyName
	end

	-- Handle shifted keys we know about
	if event.isShiftDown then
		return shiftedKeys[keyName]   -- nil if shifted key not known
	end

	-- Simple single-char unshifted key
	return keyName 
end

-- Handle a Corona key event.
-- Track which keys are down and typed, and call client event handler(s).
function g.onKey(event)
	local returnValue = false
	local keyName = event.keyName
	if event.phase == "down" then
		-- keyPress
		keysDown[keyName] = true
		if type(onKeyPress) == "function" then
			onKeyPress(keyName)
			returnValue = true    -- Always? Means client has to handle all keys
		end

		-- Check for charTyped
		local ch = charTypedFromKeyEvent(event)
		if ch then
			g.charTyped = ch    -- remember for ct.charTyped()
			if type(onCharTyped) == "function" then
				onCharTyped(ch)
			end
		end
	elseif event.phase == "up" then
		-- keyRelease
		keysDown[event.keyName] = nil
		if type(onKeyRelease) == "function" then
			onKeyRelease(keyName)
		end
	end
	return returnValue
end


---------------- Mouse and Keyboard API --------------------------------------

function ct.clicked(...)
	-- Check params
	if g.checkAPIParams("ct.clicked") then
		g.checkNoParams(...)
	end

	-- Return polled clicked state
	return g.clicked
end

function ct.clickX(...)
	-- Check params
	if g.checkAPIParams("ct.clickX") then
		g.checkNoParams(...)
	end

	-- Return last click x
	return g.clickX
end

function ct.clickY(...)
	-- Check params
	if g.checkAPIParams("ct.clickY") then
		g.checkNoParams(...)
	end

	-- Return last click y
	return g.clickY
end

function ct.keyPressed(keyName, ...)
	-- Check parameters
	if g.checkAPIParams("ct.keyPressed") then
		g.check1Param("string", keyName, ...)
	end

	-- Return true if this key is currently pressed, false if not
	return keysDown[keyName] ~= nil
end

function ct.charTyped(ch, ...)
	-- Check parameters
	if g.checkAPIParams("ct.charTyped") then
		g.check1Param("string", ch, ...)
	end

	-- Return true if this char was typed during this frame
	return g.charTyped == ch
end

