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
local margin = app.margin
local topMargin = margin
local xSwitches = 200
local switchSize = 20        -- size of radio buttons, checkboxes, etc
local fontSize = 20

-- Display objects and groups
local title               -- Title text
local closeBtn            -- Close view button
local levelPicker         -- Syntax level picker
local tabWidthPicker      -- Tab width picker
local editorPicker        -- Text editor picker
local multiErrorPicker    -- Multi-error mode picker

-- Data tables
local winEditors = {
		{ name = "Sublime Text 3", path = [[C:\Program Files\Sublime Text 3\sublime_text.exe]] },
		{ name = "Sublime Text 3", path = [[C:\Program Files (x86)\Sublime Text 3\sublime_text.exe]] },
		{ name = "Notepad++", path = [[C:\Program Files\Notepad++\notepad++.exe]] },
		{ name = "Notepad++", path = [[C:\Program Files (x86)\Notepad++\notepad++.exe]] },
}
local macEditors = {}
local installedEditors

--- Internal Functions ------------------------------------------------

-- return a table of names of installed text editors found from the editors data table
local function getInstalledEditors()
	local editors
	if env.isWindows then
		editors = winEditors
	else
		editors = macEditors
	end
	local foundEditors = { { name = "System Default", path = nil } }
	for i = 1, #editors do
		local editor = editors[i]
		if editor.name ~= foundEditors[#foundEditors].name then
			local f = io.open( editor.path , "r" )
			if f then
				io.close( f )
				foundEditors[#foundEditors + 1] = editor
			end
		end
	end
	return foundEditors
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
			switch.y = switchSize * (i - 1)
			switchLabel.x = switch.x + switchSize + margin * 0.5
			switchLabel.y = switchesGroup.y + switch.y
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
	if app.useDefaultEditor or #installedEditors == 1 then
		-- Check on "System Default"
		editorPicker.switches[1]:setState{ isOn = true }
	elseif app.editorPath == nil then
		-- Check on first non system default editor
		editorPicker.switches[2]:setState{ isOn = true }
		app.editorPath = installedEditors[2].path
	else
		-- Check on the user's preferred editor if it is installed
		local preferredEditorInstalled
		for i = 2, #installedEditors do
			if installedEditors[i].path == app.editorPath then
				editorPicker.switches[i]:setState{ isOn = true }
				preferredEditorInstalled = true
				break
			end
		end
		if not preferredEditorInstalled then
			editorPicker.switches[2]:setState{ isOn = true }
			app.editorPath = installedEditors[2].path
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

-- Set app.syntax level to selected level.
-- Fill all syntax level boxes for levels up to and including the 
-- selected level and clear the remaining boxes.
local function onSyntaxLevelPress( event )
	local syntaxLevel = event.target.val
	app.syntaxLevel = syntaxLevel
	fillBoxes( levelPicker.switches, syntaxLevel )
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
	installedEditors = getInstalledEditors()
	local editorNames = {}
	for i = 1, #installedEditors do
		editorNames[i] = installedEditors[i].name
	end
	editorPicker = newSettingPicker{
		header = "Text Editor:",
		labels = editorNames,
		style = "radio",
		orientation = "vertical",
		y = tabWidthPicker.y + tabWidthPicker.height + margin,
		onPress = 
			function ( event )
				app.editorPath = installedEditors[event.target.val].path
				app.useDefaultEditor = app.editorPath == nil
			end
	}

	-- Multi-error picker
	local multiErrorLabels = { "Show only one error at a time" }
	multiErrorPicker = newSettingPicker{
		header = "Multi-Error Mode:",
		labels = multiErrorLabels,
		style = "checkbox",
		orientation = "vertical",
		y = editorPicker.y + editorPicker.height + margin,
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


