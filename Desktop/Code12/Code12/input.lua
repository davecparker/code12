-----------------------------------------------------------------------------------------
--
-- input.lua
--
-- Implementation of the touch and key input handling for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
----------------------------------------------------------------------------------------

local ct = require("Code12.ct")
local g = require("Code12.globals")
local runtime = require("Code12.runtime")


---------------- Touch Tracking ----------------------------------------------

-- Set the last click state, then call the client event function (if any) 
-- for the given touch event. The gameObj is the corresponding GameObj 
-- or nil if the event was sent to the background object. 
-- Return true if the event was handled.
local function clickEvent(event, gameObj)
	-- No matter what the program or input state is, if the click is ending here 
	-- then make sure the touch focus is released.
	local phase = event.phase
	local focusObj = g.focusObj
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end

	-- Ignore events if the game is not supposed to be getting them now
	if g.runState ~= "running" then
		return false
	end

	-- Get logical click location 
	local xP, yP = g.mainGroup:contentToLocal(event.x, event.y)
	local xOrigin = g.screen.originX
	local yOrigin = g.screen.originY
	local x = xP / g.scale + xOrigin
	local y = yP / g.scale + yOrigin

	if phase == "began" then
		-- Ignore click if not in the game area
		if x < xOrigin or x > g.WIDTH + xOrigin 
				or y < yOrigin or y > g.height + yOrigin then
			return false
		end

		-- If gameObj is nil, check if a line was clicked
		focusObj = event.target
		if gameObj == nil then
			local objs = g.screen.objs
			for i = 1, objs.numChildren do
				local gObj = objs[i].code12GameObj
				if gObj.clickable and gObj._code12.typeName == "line" then
					if gObj:lineContainsPoint(x, y) then
						gameObj = gObj
						focusObj = objs[i]
						break
					end
				end
			end
		end

		-- Ignore click if it is on a non-clickable object
		if gameObj and not gameObj.clickable then
			return false
		end

		-- Set last click state
		g.clicked = true
		g.gameObjClicked = gameObj
		g.clickX = x
		g.clickY = y

		-- Automatically take the touch focus.
		g.setFocusObj(focusObj)

		-- Call client event
		runtime.runEventFunction(ct.userFns.onMousePress, gameObj, x, y)
	elseif event.target ~= focusObj then
		return false    -- click did not begin on this object
	elseif phase == "moved" then
		-- Call client move event
		runtime.runEventFunction(ct.userFns.onMouseDrag, gameObj, x, y)
	else  -- (ended or cancelled)
		-- Call client release event
		runtime.runEventFunction(ct.userFns.onMouseRelease, gameObj, x, y)
	end
	return true
end

-- Handle a Corona touch event on the background object
function g.onTouchBackObj(event)
	local backObj = event.target.code12GameObj
	if backObj then
		return clickEvent(event, nil)
	end
	return false
end

-- Handle a Corona touch event on a GameObj
function g.onTouchGameObj(event)
	local gameObj = event.target.code12GameObj
	if gameObj then
		return clickEvent(event, gameObj)
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
	elseif keyName == "deleteBack" then
		return "\b"
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
	-- Get the key name and change it as necessary to match the Code12 spec
	local keyName = event.keyName
	if keyName == "back"  then
		return false    -- let Android handle this (will back out of the app)
	elseif keyName == "deleteBack" then
		keyName = "backspace"
	end

	-- Process the key
	if event.phase == "down" then
		-- keyPress
		keysDown[keyName] = true
		runtime.runEventFunction(ct.userFns.onKeyPress, keyName)  -- TODO: if yielded

		-- Check for charTyped
		local ch = charTypedFromKeyEvent(event)
		if ch then
			g.charTyped = ch    -- remember for ct.charTyped()
			runtime.runEventFunction(ct.userFns.onCharTyped, ch)
		end
		return true    -- Always? Means client has to handle all keys
	elseif event.phase == "up" then
		-- keyRelease
		keysDown[keyName] = nil
		runtime.runEventFunction(ct.userFns.onKeyRelease, keyName)
	end
	return false
end


---------------- Mouse and Keyboard API --------------------------------------

-- API
function ct.clicked(...)
	-- Check params
	if g.checkAPIParams("ct.clicked") then
		g.checkNoParams(...)
	end

	-- Return polled clicked state
	return g.clicked
end

-- API
function ct.clickX(...)
	-- Check params
	if g.checkAPIParams("ct.clickX") then
		g.checkNoParams(...)
	end

	-- Return last click x
	return g.clickX
end

-- API
function ct.clickY(...)
	-- Check params
	if g.checkAPIParams("ct.clickY") then
		g.checkNoParams(...)
	end

	-- Return last click y
	return g.clickY
end

-- API
function ct.objectClicked(...)
	-- Check params
	if g.checkAPIParams("ct.objectClicked") then
		g.checkNoParams(...)
	end

	-- Return clicked object if any
	return g.gameObjClicked
end

-- API
function ct.keyPressed(keyName, ...)
	-- Check parameters
	if keyName == nil then
		return false
	end
	if g.checkAPIParams("ct.keyPressed") then
		g.check1Param("string", keyName, ...)
	end

	-- Return true if this key is currently pressed, false if not
	return keysDown[keyName] ~= nil
end

-- API
function ct.charTyped(ch, ...)
	-- Check parameters
	if ch == nil  then
		return false
	end
	if g.checkAPIParams("ct.charTyped") then
		g.check1Param("string", ch, ...)
	end

	-- Return true if this char was typed during this frame
	return g.charTyped == ch
end

