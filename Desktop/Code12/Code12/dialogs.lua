-----------------------------------------------------------------------------------------
--
-- dialogs.lua
--
-- Implementation of the alert and input dialog APIs for the Code12 Lua runtime.
--
-- (c)Copyright 2018 by Code12. All Rights Reserved.
-----------------------------------------------------------------------------------------


-- Runtime support modules
local ct = require("Code12.ct")
local g = require("Code12.globals")
local runtime = require("Code12.runtime")

-- Corona modules
local widget = require("widget")


-- Font info
local inputFont = "NotoMono-Regular.ttf"     -- font for text input field
local inputFontSize = 14                     -- font size for text input field

-- Layout metrics
local dyDragBar = 10            -- height of top drag bar for input dialogs
local dragBarShade = 0.7        -- gray shade for dialog drag bar
local dxDialogMin = 250         -- minimum width of input dialogs
local dxDialogMax = 500         -- maximum width of input dialogs
local margin = 10               -- x and y margin to use around dialog items
local margins = margin * 2      -- two margins
local dyButton = 20             -- dialog button height
local dxButton = 40             -- dialog button width

-- File local state
local dialogGroup               -- display group for running dialog or nil if none
local dialogFrame
local dragBar                   -- dialog's drag bar
local dragOffsetX, dragOffsetY  -- offset when dragging a dialog
local inputType                 -- "int", "double", "string" or "boolean"
local inputField                -- active native text field if any
local inputResult               -- result from input dialog
local onKey                     -- key listener for dialogs


---------------- Internal Functions ------------------------------------------

-- Make and return a button on dialogGroup with the given text and listener, 
-- top-left aligned at x, y
local function makeButton(text, x, y, listener)
	local btn = widget.newButton{
		x = x,
		y = y,
		onRelease = listener,
		label = text,
		font = native.systemFontBold,
		fontSize = inputFontSize,
		textOnly = true,
	}
	btn.anchorX = 0
	btn.anchorY = 0
	dialogGroup:insert(btn)
	return btn
end

-- If a text input dialog can be ended now then return the input result value,
-- otherwise return false.
local function textInputResult()
	if inputType == "int" or inputType == "double" then
		local result = tonumber(inputField.text)
		if result == nil or (inputType == "int" and result ~= math.floor(result)) then
			return nil
		end
		return result
	end
	return inputField.text or ""  -- string input type accepts anything
end

-- End the running dialog
local function endDialog()
	-- Destroy the dialog
	if inputField then
		native.setKeyboardFocus(nil)
		inputField:removeSelf()
		inputField = nil
	else
		Runtime:removeEventListener("key", onKey)
	end
	dialogGroup:removeSelf()
	dialogGroup = nil
	dragBar = nil
end

-- Text field input handler
local function onUserInput(event)
	local phase = event.phase
	if phase == "ended" then
		-- User clicked off, which removes the input focus, so put it back
		native.setKeyboardFocus(inputField)
	elseif phase == "submitted" then
		-- User pressed enter. End the dialog if the input is valid.
		inputResult = textInputResult()
		if inputResult then
			endDialog()
		end
	end
end

-- Handle click on the Yes button
local function onYes()
	inputResult = true
	endDialog()
end

-- Handle click on the No button
local function onNo()
	inputResult = false
	endDialog()
end

-- Handle a key event when a dialog is up
function onKey(event)
	if dialogGroup and event.phase == "down" then
		local key = event.keyName
		if inputType == "boolean" then
			if key == "y" or key == "n" then
				inputResult = (key == "y")
				endDialog()
				return true
			end
		elseif inputType == nil then
			-- Simple alert dismisses on Enter key
			if key == "enter" then
				endDialog()
				return true
			end
		end				
	end
end

-- Handle touch events on a dialog's drag bar
local function onTouchDragBar(event)
	local phase = event.phase
	if phase == "began" then
		g.setFocusObj(dragBar)
		dragOffsetX = event.x - dialogGroup.x
		dragOffsetY = event.y - dialogGroup.y
	elseif g.focusObj == dragBar and phase ~= "cancelled" then
		-- Move dialog then make sure it's fully visible in the app window
		local xMax = display.actualContentWidth - dialogFrame.width
		local yMax = display.actualContentHeight - dialogFrame.height
		dialogGroup.x = g.pinValue(event.x - dragOffsetX, 0, xMax)
		dialogGroup.y = g.pinValue(event.y - dragOffsetY, 0, yMax)
	end
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end
	return true
end

-- Show a modal input dialog with the given message and return the value input.
-- The valueType must be "int", "double", "string", "boolean", or nil for a simple alert.
local function inputValue(message, valueType)
	-- Make the message text and determine the dialog width
	local y = dyDragBar + margin
	local wrapWidth = math.min(dxDialogMax, display.actualContentWidth) - margins * 2
	local messageText = g.uiItem(display.newText(message, margin, y, 0, 0,
									native.systemFontBold, inputFontSize), 0)
	local textWrapped = g.uiItem(display.newText(message, margin, y, wrapWidth, 0,
									native.systemFontBold, inputFontSize), 0)
	if textWrapped.height == messageText.height then
		textWrapped:removeSelf()   -- message fit on one line
	else
		messageText:removeSelf()   -- use the wrapped version
		messageText = textWrapped
	end
	local dialogWidth = math.max(math.ceil(messageText.width) + margins, dxDialogMin)
	y = y + math.ceil(messageText.height) + margin

	-- Make the input field if needed and determine the dialog height
	local dialogHeight
	if valueType == "boolean" or valueType == nil then
		-- These types have buttons but no input field
		inputField = nil
		dialogHeight = y + dyButton + margin
	else
		-- All other input types have a text input field
		inputField = native.newTextField(margin, y,
							dialogWidth - margins, messageText.height)
		inputField.anchorX = 0
		inputField.anchorY = 0
		inputField.font = native.newFont(inputFont, inputFontSize)
		inputField:resizeHeightToFitFont()
		dialogHeight = y + math.ceil(inputField.height) + margin * 2

		-- Doesn't work to set the keyboard focus right away
		inputField:addEventListener("userInput", onUserInput)
		timer.performWithDelay( 50, function () native.setKeyboardFocus( inputField ) end )
	end

	-- Make the group for the dialog box, and add the frame, drag bar, and message
	dialogGroup = display.newGroup()
	dialogFrame = g.uiItem(display.newRect(dialogGroup, 0, 0, dialogWidth, dialogHeight), 1, 0)
	dragBar = g.uiItem(display.newRect(dialogGroup, 0, 0, dialogWidth, dyDragBar), dragBarShade, 0)
	dragBar:addEventListener("touch", onTouchDragBar)
	dialogGroup:insert(messageText)

	-- Add the input field or key listener
	if inputField then
		-- Add a framed rect under the input field on Mac so it's always visible
		if g.isMac then
			g.uiItem(display.newRect(dialogGroup, inputField.x, inputField.y, 
							inputField.width, inputField.height), 0, 0.7)
		end
		dialogGroup:insert(inputField)
	else
		Runtime:addEventListener("key", onKey)
	end

	-- Make and add the button(s) if necessary
	local x = dialogWidth - margin - dxButton
	if valueType == "boolean" then
		makeButton("No", x, y, onNo)
		x = x - dxButton - margin
		makeButton("Yes", x, y, onYes)
	elseif valueType == nil then
		makeButton("OK", x, y, onNo)
	end

	-- Position the dialog centered on the output area if room,
	-- otherwise centered on the entire app area.
	local xDialog = math.round(g.window.width / 2 - dialogWidth / 2)
	local yDialog = math.round(g.window.height / 2 - dialogHeight / 2)
	if xDialog < 0 then 
		xDialog = math.round(display.actualContentWidth / 2 - dialogWidth / 2)
		if xDialog < 0 then
			xDialog = 0
		end
	end
	if yDialog < 0 then 
		yDialog = math.round(display.actualContentHeight / 2 - dialogHeight / 2)
		if yDialog < 0 then
			yDialog = 0
		end
	end
	dialogGroup.x = xDialog
	dialogGroup.y = yDialog

	-- Init the input state, then block and yield until the dialog finishes
	inputType = valueType
	g.setFocusObj(nil)   -- a GameObj may have focus if it was just clicked on
	g.runState = "waiting"
	while dialogGroup do
		if runtime.blockAndYield() == "abort" then
			endDialog()
			g.runState = "stopped"
			error("aborted")   -- caught by the runtime
		end
	end
	if g.runState == "waiting" then
		g.runState = "running"
	end

	-- Return the result
	return inputResult
end


---------------- Alert and Input Dialog APIs ---------------------------------

-- API
function ct.showAlert(message)
	inputValue(message or "Alert", nil)
end

-- API
function ct.inputInt(message)
	return inputValue(message or "Enter an integer", "int")
end

-- API
function ct.inputNumber(message)
	return inputValue(message or "Enter a number", "double")
end

-- API
function ct.inputYesNo(message)
	return inputValue(message or "Press Yes or No", "boolean")
end

-- API
function ct.inputString(message)
	return inputValue(message or "Enter a text string", "string")
end

