-----------------------------------------------------------------------------------------
--
-- optionsView.lua
--
-- The view for displaying user options for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )
local toolbar = require( "toolbar" )

-- The optionsView module and scene
local optionsView = composer.newScene()

-- UI Metrics
local margin = app.margin -- Space between most UI elements
local topMargin = margin  -- Top margin of the scene
local xSwitches = 200     -- x-Value to align left side of switches
local switchSize = 20     -- Size of radio buttons, checkboxes, and fillboxes
local fontSize = 20       -- Font size of switch headers and labels

-- Display objects and groups
local title               -- Title text
local closeBtn            -- Close view button
local levelPicker         -- Syntax level picker
local tabWidthPicker      -- Tab width picker
local editorPicker        -- Text editor picker
local multiErrorPicker    -- Multi-error mode picker
local openInEditorBtn     -- Open current source file in editor


--- Internal Functions ------------------------------------------------

-- Create and return a new button widget with standard color and font
-- and which has been inserted into optionsView.view
-- options = {
--     x = x-value to position the button at (with anchorX = 0),
--     y = y-value to position the button at (with anchorY = 0),
--     onRelease = listener function for the button,
--     label = string for the button's label,
--     width = width for the button,
-- }
local function newOptionButton( options )
	local button = widget.newButton{
		x = options.x,
		y = options.y,
		onRelease = options.onRelease,
		label = options.label,
		labelColor = { default = { 0 }, over = { 0 } },
		fillColor = { default = { 1 }, over = { 0.8 } },
		strokeColor = { default = { 0.1 }, over = { 0.1 } },
		strokeWidth = 1,
		font = native.systemFont,
		fontSize = fontSize,
		shape = "roundedRect",
		width = options.width,
		height = 30,
	}
	button.anchorX = 0
	button.anchorY = 0
	optionsView.view:insert( button )
	return button
end

-- Create and return a new display group containing a header and set of setting switches,
-- which has been inserted into optionsView.view
-- options = {
--     header = string for the setting header text
--     labels = table of strings for the labeling the switches
--     values = optional table of values to associate with each switch, in field switch.val
--              if values is not provided switch.val will be a number equal to its order displayed,
--              from top to bottom/left to right
--     style = "radio", "checkbox", "fillbox"
--     orientation = "vertical", "horizontal"
--     y = y-value to position the group at (with anchorY = 0)
--     onPress = listener function for switches
-- }
-- Fields in return value:
-- switches = display group of switches for the setting
-- each switch also has a "number" field equal to it's order displayed from bottom to top
local function newSettingPicker( options )
	local newSettingPickerGroup = display.newGroup() -- group to be returned
	optionsView.view:insert( newSettingPickerGroup )
	newSettingPickerGroup.anchorY = 0
	newSettingPickerGroup.y = options.y
	local switchStyle, switchSheet
	if options.style == "radio" then
		switchStyle = "radio"
		switchSheet = app.radioBtnSheet
	elseif options.style == "checkbox" then
		switchStyle = "checkbox"
		switchSheet = app.checkboxSheet
	else
		switchStyle = "checkbox"
		switchSheet = app.fillboxSheet
	end
	-- Make header
	local header = display.newText{
		parent = newSettingPickerGroup,
		text = options.header,
		x = xSwitches - margin,
		y = 0,
		font = native.systemFontBold,
		fontSize = fontSize,
		align = "right",
	}
	header.anchorX = 1
	header.anchorY = 0
	header:setFillColor( 0 )
	-- Make swiches and labels
	local switchesGroup = display.newGroup()
	newSettingPickerGroup:insert( switchesGroup )
	newSettingPickerGroup.switches = switchesGroup
	switchesGroup.anchorX = 0
	switchesGroup.anchorY = 0
	local labels = options.labels
	local offset = 0
	for i = 1, #labels do
		-- Make a switch
		local switch = widget.newSwitch{
			style = switchStyle,
			width = switchSize,
			height = switchSize,
			onPress = options.onPress,
			sheet = switchSheet,
			frameOn = 1,
			frameOff = 2,
		}
		switch.anchorX = 0
		switch.anchorY = 0
		switchesGroup:insert( switch )
		-- Make the switch's label
		local switchLabel = display.newText{
			parent = newSettingPickerGroup,
			text = labels[i],
			font = native.systemFont,
			fontSize = fontSize,
		}
		g.uiItem( switchLabel )
		-- Set x, y values according to orientation
		if options.orientation == "vertical" then
			switch.x = xSwitches
			switch.y = offset
			switchLabel.x = switch.x + switchSize + margin * 0.5
			switchLabel.y = switchesGroup.y + switch.y
			offset = offset + math.max( switch.height, switchLabel.height )
		else
			switch.x = xSwitches + offset
			switch.y = 0
			switchLabel.x = switch.x + switchSize + margin * 0.5
			switchLabel.y = switchesGroup.y
			offset = offset + switch.width + switchLabel.width + margin * 1.5
		end
	end
	-- Attach values to switches
	local numSwitches = switchesGroup.numChildren
	if options.values then
		local values = options.values
		local numValues = #values
		assert( numSwitches == numValues )
		for i = 1, numSwitches do
			switchesGroup[i].val = values[i]
		end
	else
		for i = 1, numSwitches do
			switchesGroup[i].val = i
		end
	end
	return newSettingPickerGroup
end

-- Turn on all the checkboxes in given display group boxesGroup whose value is less than or
-- equal to given maxVal, and turn off all the other boxes
local function fillBoxes( boxesGroup, maxVal )
	for i = 1, boxesGroup.numChildren do
		local box = boxesGroup[i]
		if box.val <= maxVal then
			box:setState{ isOn = true }
		else
			box:setState{ isOn = false }
		end
	end
end

-- Set the checked boxes for the user's settings
local function setSelectedOptions()
	-- Set the filled boxes of the levelPicker
	app.syntaxLevel = app.syntaxLevel or 1
	fillBoxes( levelPicker.switches, app.syntaxLevel )

	-- Set the checked box of the tabWidthPicker
	tabWidthPicker.switches[app.tabWidth - 1]:setState{ isOn = true }

	-- Set the checked box of the editorPicker
	if app.useDefaultEditor or #env.installedEditors == 1 then
		-- Check on "System Default"
		editorPicker.switches[1]:setState{ isOn = true }
	elseif app.editorPath == nil then
		-- Check on first non system default editor
		editorPicker.switches[2]:setState{ isOn = true }
		app.editorPath = env.installedEditors[2].path
	else
		-- Check on the user's preferred editor if it is installed
		local preferredEditorInstalled
		for i = 2, #env.installedEditors do
			if env.installedEditors[i].path == app.editorPath then
				editorPicker.switches[i]:setState{ isOn = true }
				preferredEditorInstalled = true
				break
			end
		end
		if not preferredEditorInstalled then
			editorPicker.switches[2]:setState{ isOn = true }
			app.editorPath = env.installedEditors[2].path
		end
	end

	-- Set the checked box of the multiErrorPicker
	if app.oneErrOnly then
		multiErrorPicker.switches[1]:setState{ isOn = true }
	else
		multiErrorPicker.switches[1]:setState{ isOn = false }
	end
end


--- Event Handlers ------------------------------------------------

-- Close Button handler
-- Save settings and process user file or go back to getFile view
local function onClose()
	app.saveSettings()
	local prevScene = composer.getSceneName( "previous" )
	if prevScene == "getFile" then
		composer.gotoScene( prevScene )
	else
		app.processUserFile()
	end
end

-- Syntax Level Switch handler
-- Set app.syntax level to selected level.
-- Fill all syntax level boxes for levels up to and including the 
-- selected level and clear the remaining boxes.
local function onSyntaxLevelPress( event )
	local syntaxLevel = event.target.val
	app.syntaxLevel = syntaxLevel
	fillBoxes( levelPicker.switches, syntaxLevel )
end

-- Open In Editor Button handler
-- Open most recent program file in text editor
local function onOpenInEditor()
	env.openFileInEditor( app.recentSourceFilePaths[1] )
end

--- Scene Methods ------------------------------------------------

-- Create the optionsView scene
function optionsView:create()
	local sceneGroup = self.view

	-- Background
	g.uiItem( display.newRect( sceneGroup, 0, 0, 10000, 10000 ), 0.9 ) 
	
	-- Title
	title = display.newText{
		parent = sceneGroup,
		text = "Code12 Options",
		x = app.width / 2,
		y = topMargin,
		font = native.systemFontBold,
		fontSize = fontSize * 2,
	}
	title:setFillColor( 0 )
	title.anchorY = 0

	-- Close button
	closeBtn = widget.newButton{
		defaultFile = "images/close.png",
		x = app.width - margin,
		y = margin,
		width = 15,
		height = 15,
		onRelease = onClose,
	}
	sceneGroup:insert( closeBtn )
	closeBtn.anchorX = 1
	closeBtn.anchorY = 0

	-- Syntax level picker
	local syntaxLevels = {
		"1. Procedure Calls",
		"2. Comments",
		"3. Variables",
		"4. Expressions",
		"5. Function Calls",
		"6. Object Data Fields",
		"7. Object Method Calls",
		"8. If-else",
		"9. Function Definitions",
		"10. Parameters",
		"11. Loops",
		"12. Arrays",
	}
	levelPicker = newSettingPicker{
		header = "Syntax Level:",
		labels = syntaxLevels,
		style = "fillbox",
		orientation = "vertical",
		y = title.y + title.height + margin,
		onPress = onSyntaxLevelPress,
	}

	-- Tab width picker
	local tabLabels = {}
	local tabValues = {}
	for i = 2, 8 do
		tabLabels[i - 1] = tostring( i )
		tabValues[i - 1] = i
	end
	tabWidthPicker = newSettingPicker{
		header = "Tab Width:",
		labels = tabLabels,
		values = tabValues,
		style = "radio",
		orientation = "horizontal",
		y = levelPicker.y + levelPicker.height + margin,
		onPress = 
			function ( event )
				app.tabWidth = event.target.val
			end
	}

	-- Editor picker
	local editorNames = {}
	for i = 1, #env.installedEditors do
		editorNames[i] = env.installedEditors[i].name
	end
	editorPicker = newSettingPicker{
		header = "Text Editor:",
		labels = editorNames,
		style = "radio",
		orientation = "vertical",
		y = tabWidthPicker.y + tabWidthPicker.height + margin,
		onPress = 
			function ( event )
				app.editorPath = env.installedEditors[event.target.val].path
				app.useDefaultEditor = app.editorPath == nil
			end
	}

	-- Open In Editor button
	openInEditorBtn = newOptionButton{
		x = xSwitches,
		y = editorPicker.y + editorPicker.height + margin * 0.5,
		onRelease = onOpenInEditor,
		label = "Open MyProgram.java in Editor",
		width = 350,
	}

	-- Multi-error picker
	local multiErrorLabels = { "Show only one error at a time" }
	multiErrorPicker = newSettingPicker{
		header = "Multi-Error Mode:",
		labels = multiErrorLabels,
		style = "checkbox",
		orientation = "vertical",
		y = openInEditorBtn.y + openInEditorBtn.height + margin,
		onPress =
			function ( event )
				app.oneErrOnly = event.target.isOn
			end
	}

	-- Install resize handler
	Runtime:addEventListener( "resize", self )
end

-- Prepare to show the optionsView scene
function optionsView:show( event )
	if event.phase == "will" then
		setSelectedOptions()
		toolbar.show( false )
		if #app.recentSourceFilePaths > 0 then
			local _, filename = env.dirAndFilenameOfPath( app.recentSourceFilePaths[1] )
			openInEditorBtn:setLabel( "Open " .. filename .. " in Editor" )
			openInEditorBtn.isVisible = true
		else
			openInEditorBtn.isVisible = false
		end
	end
end

-- Prepare to hide the optionsView scene
function optionsView:hide( event )
	if event.phase == "will" then 
		app.saveSettings()
		toolbar.show( true )
	end
end

-- Window resize handler
function optionsView:resize()
	title.x = app.width / 2
	closeBtn.x = app.width - app.margin
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
optionsView:addEventListener( "create", optionsView )
optionsView:addEventListener( "show", optionsView )
optionsView:addEventListener( "hide", optionsView )
return optionsView


