-----------------------------------------------------------------------------------------
--
-- dialogs.lua
--
-- Implementation of the alert and input dialog APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")
local appContext = ct._appContext

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
local dialogRunning = false     -- true when the dialog is running
local inputType                 -- "int", "double", "string" or "boolean"
local inputField                -- active native text field if any
local inputResult               -- result from input dialog


---------------- Internal Functions ------------------------------------------

-- Set obj's anchor to (0, 0) and return it
local function uiItem(obj)
	obj.anchorX = 0
	obj.anchorY = 0
	return obj
end

-- Make and return a button on the dialog with the given text and listener, 
-- top-left aligned at x, y
local function makeButton(dialog, text, x, y, listener)
	local btn = uiItem( widget.newButton{
		x = x,
		y = y,
		onRelease = listener,
		label = text,
		font = native.systemFontBold,
		fontSize = inputFontSize,
		textOnly = true,
	} )
	dialog:insert(btn)
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
			dialogRunning = false
		end
	end
end

-- Handle click on the Yes button
local function onYes()
	inputResult = true
	dialogRunning = false
end

-- Handle click on the No button
local function onNo()
	inputResult = false
	dialogRunning = false
end

-- Handle click on the OK button of a simple alert
local function onAlertOK()
	dialogRunning = false
end

-- Handle a key event when a dialog is up
local function onKey(event)
	if dialogRunning and event.phase == "down" then
		local key = event.keyName
		if inputType == "boolean" then
			if key == "y" then
				inputResult = true
				dialogRunning = false
				return true
			elseif key == "n" then
				inputResult = false
				dialogRunning = false
				return true
			end
		elseif inputType == nil then
			-- Simple alert dismisses on Enter key
			if key == "enter" then
				dialogRunning = false
			end
		end				
	end
end

-- Show a modal input dialog with the given message and return the value input.
-- The valueType must be "int", "double", "string", "boolean", or nil for a simple alert.
local function inputValue(message, valueType)
	-- Make the message text and determine the dialog width
	local y = dyDragBar + margin
	local wrapWidth = math.min(dxDialogMax, display.actualContentWidth) - margins * 2
	local messageText = uiItem(display.newText(message, margin, y, 0, 0,
									native.systemFontBold, inputFontSize))
	local textWrapped = uiItem(display.newText(message, margin, y, wrapWidth, 0,
									native.systemFontBold, inputFontSize))
	if textWrapped.height == messageText.height then
		textWrapped:removeSelf()   -- message fit on one line
	else
		messageText:removeSelf()   -- use the wrapped version
		messageText = textWrapped
	end
	messageText:setFillColor(0)
	local dialogWidth = math.max(messageText.width + margins, dxDialogMin)
	y = y + messageText.height + margin

	-- Make the input field if needed and determine the dialog height
	local dialogHeight
	if valueType == "boolean" or valueType == nil then
		-- These types have buttons but no input field
		inputField = nil
		dialogHeight = y + dyButton + margin
	else
		-- All other input types have a text input field
		inputField = uiItem(native.newTextField( margin, y,
									dialogWidth - margins, messageText.height))
		inputField.font = native.newFont(inputFont, inputFontSize)
		inputField:resizeHeightToFitFont()
		dialogHeight = y + inputField.height + margin * 2

		-- Doesn't work to set the keyboard focus right away
		inputField:addEventListener("userInput", onUserInput)
		timer.performWithDelay( 50, function () native.setKeyboardFocus( inputField ) end )
	end

	-- Make a group for the dialog box, and add the frame, drag bar, and message
	local dialog = display.newGroup()
	local frame = uiItem( display.newRect(dialog, 0, 0, dialogWidth, dialogHeight))
	frame:setFillColor(1)
	frame:setStrokeColor(0)
	frame.strokeWidth = 1
	local dragBar = uiItem(display.newRect(dialog, 0, 0, dialogWidth, dyDragBar))
	dragBar:setFillColor(dragBarShade)
	dragBar:setStrokeColor(0)
	dragBar.strokeWidth = 1
	dialog:insert(messageText)

	-- Add the input field or key listener
	if inputField then
		dialog:insert(inputField)
	else
		Runtime:addEventListener("key", onKey)
	end

	-- Make and add the button(s) if necessary
	local x = dialogWidth - margin - dxButton
	if valueType == "boolean" then
		local noBtn = makeButton(dialog, "No", x, y, onNo)
		x = x - dxButton - margin
		makeButton(dialog, "Yes", x, y, onYes)
	elseif valueType == nil then
		makeButton(dialog, "OK", x, y, onAlertOK)
	end

	-- Position the dialog centered on the output area if room,
	-- otherwise centered on the entire app area.  TODO
	local width = g.window.width
	local height = g.window.height
	dialog.x = width / 2 - dialogWidth / 2
	dialog.y = height / 2 - dialogHeight / 2

	-- Init the input state, then block and yield until the dialog finishes
	inputType = valueType
	dialogRunning = true
	g.blocked = true
	while dialogRunning do
		coroutine.yield()
	end
	g.blocked = false

	-- Destroy the dialog
	if inputField then
		native.setKeyboardFocus(nil)
		inputField:removeSelf()
	else
		Runtime:removeEventListener("key", onKey)
	end
	dialog:removeSelf()

	-- Return the result
	return inputResult
end


---------------- Alert and Input Dialog APIs ---------------------------------

-- API
function ct.showAlert(message, ...)
	-- Check parameters
	message = message or ""
	if g.checkAPIParams("ct.inputInt") then
		g.check1Param("string", message, ...)
	end

	-- Show an alert
	inputValue(message, nil)
end

-- API
function ct.inputInt(message, ...)
	-- Check parameters
	message = message or "Enter an integer"
	if g.checkAPIParams("ct.inputInt") then
		g.check1Param("string", message, ...)
	end

	-- Input the value from a dialog
	return inputValue(message, "int")
end

-- API
function ct.inputNumber(message, ...)
	-- Check parameters
	message = message or "Enter a number"
	if g.checkAPIParams("ct.inputNumber") then
		g.check1Param("string", message, ...)
	end

	-- Input the value from a dialog
	return inputValue(message, "double")
end

-- API
function ct.inputYesNo(message, ...)
	-- Check parameters
	message = message or "Press Yes or No"
	if g.checkAPIParams("ct.inputYesNo") then
		g.check1Param("string", message, ...)
	end

	-- Input the value from a dialog
	return inputValue(message, "boolean")
end

-- API
function ct.inputString(message, ...)
	-- Check parameters
	message = message or "Enter a text string"
	if g.checkAPIParams("ct.inputString") then
		g.check1Param("string", message, ...)
	end

	-- Input the value from a dialog
	return inputValue(message, "string")
end

