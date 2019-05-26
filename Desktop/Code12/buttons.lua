-----------------------------------------------------------------------------------------
--
-- buttons.lua
--
-- The buttons module for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )


-- The buttons module
local buttons = {}


-- UI Metrics
local margin = app.margin                  -- Space between most UI elements

-- Image sheets
local radioBtnSheet = graphics.newImageSheet( "images/radiobutton.png", { width = 256, height = 256, numFrames = 2 } )
local fillboxSheet = graphics.newImageSheet( "images/fillbox.png", { width = 256, height = 256, numFrames = 2 } )
local checkboxSheet = graphics.newImageSheet( "images/checkbox.png", { width = 256, height = 256, numFrames = 2 } )
local dropDownSheet = graphics.newImageSheet( "images/drop-down.png", { width = 256, height = 256, numFrames = 2 } )


--- Module Functions ------------------------------------------------

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
	newSettingPickerGroup.x = math.round( options.x )
	newSettingPickerGroup.y = math.round( options.y )
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
		switchesGroup.y = math.round( header.height + margin * 0.5 )
	end
	local labels = options.labels
	local offset = 0
	for i = 1, #labels do
		-- Make a switch's label
		local switchLabel = display.newText{
			parent = newSettingPickerGroup,
			text = labels[i],
			font = options.labelsFont,
			fontSize = options.labelsFontSize,
			x = math.round( switchesGroup.x + options.switchSize + margin * 0.5 ),
			y = math.round( switchesGroup.y + offset ),
		}
		g.uiItem( switchLabel )
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
			y = math.round( switchLabel.y + switchLabel.height / 2 - switchesGroup.y - options.switchSize / 2 ),
		}
		switch.anchorX = 0
		switch.anchorY = 0
		switchesGroup:insert( switch )
		offset = math.ceil( offset + math.max( switch.height, switchLabel.height ) )
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

-- Create and return a display group containing a new button, icon, and text
-- options = {
-- 	parent = (optional) parent display group,
-- 	left = x value for left of the display group (anchorX = 0),
-- 	top = y value for top of the display group (anchorY = 0),
-- 	width = (optional) width for the button (defaults to fit icon and text)
-- 	text = string for label,
-- 	font = (optional) fort for label (defaults to native.systemFontBold)
-- 	fontSize = (optional) font size for label (defaults to app.fontSizeUI)
-- 	colorText = (optional) true to use app.buttonColor for text and icon (defaults to black)
-- 	imageFile = (optional) string for image file name,
-- 	iconSize = (optional) size of the icon (width and height) if imageFile is given (defaults to fontSize),
-- 	defaultFillShade = default shade for the button,
-- 	overFillShade = shade for when the button is pressed,
-- 	onRelease = listener function for button,
-- }
function buttons.newIconAndTextButton( options )
	local btnOutlineMargin = 4 -- space between edge of button and icon/label
	local iconLabelMargin = 4  -- space between icon and label
	-- Make button display group
	local btnGroup = g.makeGroup( options.parent )
	btnGroup.anchorX = 0
	btnGroup.anchorY = 0
	btnGroup.x = math.round( options.left )
	btnGroup.y = math.round( options.top )
	-- Make button icon
	local icon = nil
	local iconSize = nil
	if options.imageFile then
		iconSize = (options.iconSize or options.fontSize) or app.fontSizeUI
		icon = display.newImageRect( btnGroup, "images/" .. options.imageFile, iconSize, iconSize )
		g.uiItem( icon )
		if options.colorText then
			icon:setFillColor( unpack( app.buttonColor ) )
		end
	end
	-- Make button label
	local label = g.uiItem( display.newText{
		parent = btnGroup,
		text = options.text,
		height = 0,
		font = options.font or native.systemFontBold,
		fontSize = options.fontSize or app.fontSizeUI,
	} )
	if options.colorText then
		label:setFillColor( unpack( app.buttonColor ) )
	end
	-- Make button
	local btnHeight = math.max( iconSize or 0, label.height ) + btnOutlineMargin * 2
	local btn = widget.newButton{
		x = 0,
		y = 0,
		onRelease = 
			function ()
				options.onRelease()
			end,
		shape = "roundedRect",
		fillColor = { default = { options.defaultFillShade }, over = { options.overFillShade } },
		strokeColor = { default = { app.borderShade }, over = { app.borderShade } },
		strokeWidth = 1,
		width = options.width or ((options.iconSize or 0) + label.width + btnOutlineMargin * 2 + iconLabelMargin),
		height = btnHeight,
	}
	btn.anchorX = 0
	btn.anchorY = 0
	-- Add btn to btnGroup
	btnGroup:insert( 1, btn )
	btnGroup.btn = btn
	-- Position icon and label in button
	local yBtnCenter = btnHeight / 2
	local xBtnLabel
	if icon then
		icon.x = btnOutlineMargin
		icon.y = math.round( yBtnCenter - icon.height / 2 )
		xBtnLabel = math.round( icon.x + icon.width + iconLabelMargin )
	else
		xBtnLabel = btnOutlineMargin
	end
	label.x = xBtnLabel
	label.y = math.round( yBtnCenter - label.height / 2 )

	return btnGroup
end

-- Create and return a button with standard colors for the options view
-- options = {
--     parent = (optional) display group to insert the widget into
--     x = x-value to position the button at (with anchorX = 0),
--     y = y-value to position the button at (with anchorY = 0),
--     onRelease = listener function for the button,
--     label = string for the button's label,
--     font = font for the button's label,
--     fontSize = fontSize for the button's label,
-- }
function buttons.newOptionButton( options )
	local button = buttons.newIconAndTextButton{
		parent = options.parent,
		left = options.left,
		top = options.top,
		text = options.label,
		font = options.font,
		fontSize = options.fontSize,
		defaultFillShade = 1,
		overFillShade = 0.8,
		onRelease = options.onRelease,
	}
	return button
end

-- Return a display group containing a new button and its icon for the toolbar.
-- Placement can be "left" or "right" to place the button on that side of the toolbar.
-- Width is optional, defaults to fit icon and label 
function buttons.newToolbarButton( parent, label, imageFile, onRelease, placement, adjacentBtn, width )
	-- Make button display group
	local btnGroup = buttons.newIconAndTextButton{
		parent = parent,
		left = 0,
		top = 0,
		width = width,
		text = label,
		colorText = true,
		imageFile = imageFile,
		iconSize = 16,
		defaultFillShade = app.toolbarShade * 1.125,
		overFillShade = 1,
		onRelease = onRelease,
	}
	local btn = btnGroup.btn
	btnGroup.y = math.round( app.dyToolbar / 2 - btn.height / 2 )
	-- Set horizontal position of button group
	if placement == "left" then
		if adjacentBtn then
			btnGroup.x = math.round( adjacentBtn.x + adjacentBtn.btn.width + margin * 0.5 )
		else
			btnGroup.x = math.round( margin * 0.5 )
		end
	else
		if adjacentBtn then
			btnGroup.x = math.round( adjacentBtn.x - btn.width - margin * 0.5 )
		else
			btnGroup.x = math.round( app.width - margin - btn.width )
		end
	end
	btnGroup.placement = placement
	
	return btnGroup
end

-- Return a drop down menu button, inserted into given display group parent
function buttons.newDropDownButton( parent, x, y, width, height, onPress )
	local btn = widget.newSwitch{
			style = "checkbox",
			width = width,
			height = height,
			onPress = onPress,
			sheet = dropDownSheet,
			frameOn = 1,
			frameOff = 2,
			x = x,
			y = y,
		}
	btn.anchorX = 1
	parent:insert( btn )
	return btn
end


------------------------------------------------------------------------------

return buttons
