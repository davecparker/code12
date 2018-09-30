-----------------------------------------------------------------------------------------
--
-- buttons.lua
--
-- The buttons module for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )


-- The buttons module
local buttons = {}


-- UI Metrics
local margin = app.margin -- Space between most UI elements

-- Image sheets
local radioBtnSheet = graphics.newImageSheet( "images/radiobutton.png", { width = 1024, height = 1024, numFrames = 2 } )
local fillboxSheet = graphics.newImageSheet( "images/fillbox.png", { width = 256, height = 256, numFrames = 2 } )
local checkboxSheet = graphics.newImageSheet( "images/checkbox.png", { width = 256, height = 256, numFrames = 2 } )


--- Module Functions ------------------------------------------------

-- Create and return a new button widget with standard color and shape
-- options = {
--     parent = (optional) display group to insert the widget into
--     x = x-value to position the button at (with anchorX = 0),
--     y = y-value to position the button at (with anchorY = 0),
--     onRelease = listener function for the button,
--     label = string for the button's label,
--     font = font for the button's label,
--     fontSize = font size for the button's label,
--     width = width for the button,
--     height = height for the button,
-- }
function buttons.newOptionButton( options )
	local button = widget.newButton{
		x = options.x,
		y = options.y,
		onRelease = options.onRelease,
		label = options.label,
		fontSize = options.fontSize,
		width = options.width,
		height = options.height,
		labelColor = { default = { 0 }, over = { 0 } },
		fillColor = { default = { 1 }, over = { 0.8 } },
		strokeColor = { default = { 0.1 }, over = { 0.1 } },
		strokeWidth = 1,
		shape = "roundedRect",
	}
	button.anchorX = 0
	button.anchorY = 0
	if options.parent then
		options.parent:insert( button )
	end
	return button
end

-- Create and return a new display group containing a header and set of setting switches,
-- options = {
--     parent = (optional) display group to insert the widget into,
--     header = string for the setting header text,
--     headerFont = font for the header,
--     headerFontSize, font size for the header,
--     labels = table of strings for the labeling the switches,
--     labelsFont = font for the labels,
--     labelsFontSize = font size for the labels,
--     values = optional table of values to associate with each switch, in field switch.value
--              if values is not provided switch.value will be a number equal to its order displayed,
--              from top to bottom/left to right,
--     style = "radio", "checkbox" or "fillbox",
--     switchSize = height and width of the switches,
--     x = x-value to position the left of the group at (with anchorX = 0),
--     y = y-value to position the top of the group at (with anchorY = 0),
--     onPress = listener function for switches,
-- }
-- Fields in return value:
-- switches = display group of switches for the setting
function buttons.newSettingPicker( options )
	local newSettingPickerGroup = display.newGroup() -- group to be returned
	newSettingPickerGroup.anchorX = 0
	newSettingPickerGroup.anchorY = 0
	newSettingPickerGroup.x = options.x
	newSettingPickerGroup.y = options.y
	local switchStyle, switchSheet
	if options.style == "radio" then
		switchStyle = "radio"
		switchSheet = radioBtnSheet
	elseif options.style == "checkbox" then
		switchStyle = "checkbox"
		switchSheet = checkboxSheet
	else
		switchStyle = "checkbox"
		switchSheet = fillboxSheet
	end
	-- Make header
	local header
	if options.header then
		header = display.newText{
			parent = newSettingPickerGroup,
			text = options.header,
			x = 0,
			y = 0,
			font = options.headerFont,
			fontSize = options.headerFontSize,
			align = "left",
		}
		g.uiItem( header )
	end
	-- Make swiches and labels
	local switchesGroup = display.newGroup()
	newSettingPickerGroup:insert( switchesGroup )
	newSettingPickerGroup.switches = switchesGroup
	switchesGroup.anchorX = 0
	switchesGroup.anchorY = 0
	if header then
		switchesGroup.y = header.height + margin * 0.5
	end
	local labels = options.labels
	local offset = 0
	for i = 1, #labels do
		-- Make a switch
		local switch = widget.newSwitch{
			style = switchStyle,
			width = options.switchSize,
			height = options.switchSize,
			onPress = options.onPress,
			sheet = switchSheet,
			frameOn = 1,
			frameOff = 2,
			x = 0,
			y = offset,
		}
		switch.anchorX = 0
		switch.anchorY = 0
		switchesGroup:insert( switch )
		-- Make the switch's label
		local switchLabel = display.newText{
			parent = newSettingPickerGroup,
			text = labels[i],
			font = options.labelsFont,
			fontSize = options.labelsFontSize,
			x = switch.x + options.switchSize + margin * 0.5,
			y = switchesGroup.y + switch.y,
		}
		g.uiItem( switchLabel )
		offset = offset + math.max( switch.height, switchLabel.height )
	end
	-- Attach values to switches
	local numSwitches = switchesGroup.numChildren
	if options.values then
		local values = options.values
		local numValues = #values
		assert( numSwitches == numValues )
		for i = 1, numSwitches do
			switchesGroup[i].value = values[i]
		end
	else
		for i = 1, numSwitches do
			switchesGroup[i].value = i
		end
	end
	if options.parent then
		options.parent:insert( newSettingPickerGroup )
	end
	return newSettingPickerGroup
end


------------------------------------------------------------------------------

return buttons
