-----------------------------------------------------------------------------------------
--
-- optionsView.lua
--
-- The view for displaying user options for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )
local toolbar = require( "toolbar" )
local buttons = require( "buttons" )


-- The optionsView module and scene
local optionsView = composer.newScene()


-- UI Metrics
local sectionMargin = 15                    -- Space between sections
local topMargin = app.margin                -- Top margin of the scene
local titleFontSize = 30                    -- Font size for the title
local optionsFont = app.optionsFont         -- Font for switch labels
local optionsFontBold = app.optionsFontBold -- Font for title and switch headers
local fontSize = app.optionsFontSize        -- Font size of switch headers and labels
local switchSize = 16                       -- Size of radio buttons, checkboxes, and fillboxes
local yEditorPicker                         -- Y-coordinate for the top of editorPicker

-- Display objects and groups
local title               -- Title text
local closeBtn            -- Close view button
local levelPicker         -- Syntax level picker
local tabWidthPicker      -- Tab width picker
local editorPicker        -- Text editor picker
local varWatchPicker      -- Variable watch window mode picker
local gridlineColorPicker -- Gridline color picker
local addEditorBtn        -- Add a Text Editor button
local openInEditorBtn     -- Open current source file in editor button
local optionsGroup        -- Display group containing the options objects

-- State variables
local forceReprocess      -- true to reprocess source file after changes


--- Internal Functions ------------------------------------------------

-- Turn on all the checkboxes in given display group boxesGroup whose value is less than or
-- equal to given maxValue, and turn off all the other boxes
local function fillBoxes( boxesGroup, maxValue )
	for i = 1, boxesGroup.numChildren do
		local box = boxesGroup[i]
		if box.value <= maxValue then
			box:setState{ isOn = true }
		else
			box:setState{ isOn = false }
		end
	end
end

-- Set the checked boxes for the user's settings
local function setSelectedOptions()
	-- Set the filled boxes of the levelPicker
	fillBoxes( levelPicker.switches, app.syntaxLevel )

	-- Set the active segment of the tabWidthPicker
	tabWidthPicker:setActiveSegment( app.tabWidth - 1 )

	-- Set the selected radio button of the editorPicker
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

	-- Set the checked box of the varWatchPicker
	if app.showVarWatch then
		varWatchPicker.switches[1]:setState{ isOn = true }
	else
		varWatchPicker.switches[1]:setState{ isOn = false }
	end

	-- Set the selected radio button of the gridlineColorPicker
	local gridColorSwitches = gridlineColorPicker.switches
	local shade = app.gridlineShade or app.defaultGridlineShade
	for i = 1, gridColorSwitches.numChildren do
		if gridColorSwitches[i].value == shade then
			gridColorSwitches[i]:setState{ isOn = true }
			break
		end
	end
end

local function makeEditorPicker( parent )
	if editorPicker then
		editorPicker:removeSelf()
		editorPicker = nil
	end
	local editorNames = {}
	for i = 1, #env.installedEditors do
		editorNames[i] = env.installedEditors[i].name
	end
	editorPicker = buttons.newSettingPicker{
		parent = parent,
		header = "Text Editor",
		headerFont = optionsFontBold,
		headerFontSize = fontSize,
		labels = editorNames,
		labelsFont = optionsFont,
		labelsFontSize = fontSize,
		style = "radio",
		switchSize = switchSize,
		x = 0,
		y = yEditorPicker,
		onPress = 
			function ( event )
				app.editorPath = env.installedEditors[event.target.value].path
				app.useDefaultEditor = app.editorPath == nil
			end
	}
end

local function makeOpenInEditorBtn( filename )
	if openInEditorBtn then
		openInEditorBtn:removeSelf()
		openInEditorBtn = nil
	end
	openInEditorBtn = buttons.newOptionButton{
		parent = optionsGroup,
		left = 0,
		top = addEditorBtn.y + addEditorBtn.height + app.margin,
		label = "Open " .. filename .. " in Editor",
		font = optionsFont,
		fontSize = fontSize,
		onRelease = 
			function ()
				env.openFileInEditor( app.recentSourceFilePaths[1] )
			end
	}
end

local function setEditorButtons( repositionAddEditorBtn )
	if repositionAddEditorBtn then
		addEditorBtn.y = editorPicker.y + editorPicker.height + app.margin * 0.5
	end
	if #app.recentSourceFilePaths > 0 then
		local _, filename = env.dirAndFilenameOfPath( app.recentSourceFilePaths[1] )
		makeOpenInEditorBtn( filename )
	elseif openInEditorBtn then
		openInEditorBtn.isVisible = false
	end
end


--- Event Handlers ------------------------------------------------

-- Close Button handler
-- Save settings and re-process the user file if necessary 
-- or go back to the view we came from.
local function onClose()
	app.saveSettings()
	if g.runState ~= nil and forceReprocess then
		app.processUserFile()   -- will go to runView or errView
	else
		composer.gotoScene( composer.getSceneName( "previous" ) )
	end
end

-- Syntax Level Switch handler
-- Set app.syntax level to selected level.
-- Fill all syntax level boxes for levels up to and including the 
-- selected level and clear the remaining boxes.
local function onSyntaxLevelPress( event )
	local syntaxLevel = event.target.value
	if syntaxLevel ~= app.syntaxLevel then
		app.syntaxLevel = syntaxLevel
		forceReprocess = true
	end
	fillBoxes( levelPicker.switches, syntaxLevel )
end

-- Handle press of the varWatch checkbox
local function onVarWatchPress( event )
	local show = event.target.isOn
	if show ~= app.showVarWatch then
		app.showVarWatch = show
		if show then
			forceReprocess = true
		end
	end
end

-- Gridline Color Switch handler
local function onGridlineColorPress( event )
	app.gridlineShade = event.target.value
end

-- Show dialog to choose the editor and add the path to installed editors
-- and user's settings
local function addEditor()
	-- Ask user to find an editor application with an Open dialog
	local editorPath
	while true do  -- breaks internally
		if env.isWindows then
			editorPath = env.pathFromOpenFileDialog( "Choose a Text Editor", 
								"*.exe", "Executables (*.exe)", [[C:\Program Files\]] )
			if editorPath and string.sub( editorPath, -4, -1 ) ~= ".exe" then
				env.showErrAlert( "Invalid File Extension", "Please choose a .exe file" )
			else
				break
			end
		else
			editorPath = env.pathFromOpenFileDialog( "Choose a Text Editor", 
								nil, nil, "/Applications/" )
			if editorPath and string.sub( editorPath, -4, -1 ) ~= ".app" then
				env.showErrAlert( "Invalid Application", "Please choose a .app file" )
			else
				break
			end
		end
	end
	native.setActivityIndicator( false )

	-- Add the application chosen, if any
	if editorPath then
		local _, filename = env.dirAndFilenameOfPath( editorPath )
		local editorName, _ = env.basenameAndExtFromFilename( filename )
		local newEditor = { name = editorName, path = editorPath }
		env.installedEditors[#env.installedEditors + 1] = newEditor
		app.customEditors[#app.customEditors + 1] = newEditor
		app.editorPath = editorPath
		app.saveSettings()
		makeEditorPicker( optionsGroup )
		setEditorButtons( true )
		setSelectedOptions()
		-- TODO: resize scroll bar
	end
end

-- Event handler for the Add Editor button
local function onAddEditor()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, addEditor )
end


--- Scene Methods ------------------------------------------------

-- Create the optionsView scene
function optionsView:create()
	local sceneGroup = self.view

	-- Background
	g.uiItem( display.newRect( sceneGroup, 0, 0, 10000, 10000 ), 0.9 ) 
	
	-- Title
	title = g.uiItem( display.newText{
		parent = sceneGroup,
		text = "Code12 Options",
		x = 0,
		y = topMargin,
		font = optionsFontBold,
		fontSize = titleFontSize,
	} )
	title.x = math.round( app.width / 2 - title.width / 2)

	-- Close button
	closeBtn = buttons.newIconAndTextButton{
		parent = sceneGroup,
		left = 0,
		top = app.margin,
		text = "Close",
		colorText = true,
		imageFile = "close.png",
		iconSize = 12,
		defaultFillShade = 1,
		overFillShade = 0.8,
		onRelease = onClose,
	}
	closeBtn.x = math.round( app.width - app.margin - closeBtn.width )

	-- Options display group
	optionsGroup = display.newGroup()
	optionsGroup.anchorX = 0
	optionsGroup.anchorY = 0
	optionsGroup.y = math.round( title.y + title.height + app.margin )

	-- Syntax level picker
	local syntaxLevels = {
		"1. Function Calls",
		"2. Comments",
		"3. Variables",
		"4. Expressions",
		"5. Function Return Values",
		"6. Object Data Fields",
		"7. Object Method Calls",
		"8. If-else",
		"9. Function Definitions",
		"10. Function Parameters",
		"11. Loops",
		"12. Arrays",
	}
	levelPicker = buttons.newSettingPicker{
		parent = optionsGroup,
		header = "Java Language Syntax Level",
		headerFont = optionsFontBold,
		headerFontSize = fontSize,	
		labels = syntaxLevels,
		labelsFont = optionsFont,
		labelsFontSize = fontSize,
		style = "fillbox",
		switchSize = switchSize,
		x = 0,
		y = 0,
		onPress = onSyntaxLevelPress,
	}
	local lastPicker = levelPicker

	-- Tab width header
	local tabWidthHeader  = display.newText{
		parent = optionsGroup,
		text = "Tab Width for Source Code Display",
		x = 0,
		y = math.round( lastPicker.y + lastPicker.height + sectionMargin ),
		font = optionsFontBold,
		fontSize = fontSize,
	}
	g.uiItem( tabWidthHeader )
	local tabWidths = {}
	for i = 2, 8 do
		tabWidths[i - 1] = tostring( i )
	end
	-- Tab width picker
	tabWidthPicker = widget.newSegmentedControl{
		x = 0,
		y = math.round( tabWidthHeader.y + tabWidthHeader.height + app.margin * 0.5 ),
		segments = tabWidths,
		segmentWidth = 30,
		defaultSegment = app.tabWidth - 1,
		labelSize = fontSize,
		labelColor = { default = { 0 }, over = { 0 } },
		onPress =
			function ( event )
				app.tabWidth = event.target.segmentNumber + 1
				forceReprocess = true
			end
	}
	tabWidthPicker.anchorX = 0
	tabWidthPicker.anchorY = 0
	optionsGroup:insert( tabWidthPicker )
	lastPicker = tabWidthPicker

	-- Variable Watch Window picker
	varWatchPicker = buttons.newSettingPicker{
		parent = optionsGroup,
		header = "Program View",
		headerFont = optionsFontBold,
		headerFontSize = fontSize,
		labels = { "Show the Variable Watch Window" },
		labelsFont = optionsFont,
		labelsFontSize = fontSize,
		style = "checkbox",
		switchSize = switchSize,
		x = 0,
		y = math.round( lastPicker.y + lastPicker.height + sectionMargin ),
		onPress = onVarWatchPress,
	}
	lastPicker = varWatchPicker

	-- Gridline Color Picker
	gridlineColorPicker = buttons.newSettingPicker{
		parent = optionsGroup,
		header = "Gridline Color",
		headerFont = optionsFontBold,
		headerFontSize = fontSize,
		labels = { "Black", "White", "Gray (default)" },
		values = { 0, 1, app.defaultGridlineShade },
		labelsFont = optionsFont,
		labelsFontSize = fontSize,
		style = "radio",
		switchSize = switchSize,
		x = 0,
		y = math.round( lastPicker.y + lastPicker.height + sectionMargin ),
		onPress = onGridlineColorPress,
	}
	lastPicker = gridlineColorPicker

	-- Editor picker
	yEditorPicker = math.round( lastPicker.y + lastPicker.height + sectionMargin )
	makeEditorPicker( optionsGroup )

	-- Add Text Editor button
	addEditorBtn = buttons.newOptionButton{
		parent = optionsGroup,
		left = editorPicker.x + switchSize + app.margin * 0.5,
		top = editorPicker.y + editorPicker.height + app.margin * 0.5,
		onRelease = onAddEditor,
		label = "Add a Text Editor",
		font = optionsFont,
		fontSize = fontSize,
	}

	-- Center options group
	if app.width > optionsGroup.width then
		optionsGroup.x = math.round( app.width / 2 - optionsGroup.width / 2 )
	end

	-- TODO: Make scrollbar
	sceneGroup:insert( optionsGroup )

	-- Install resize handler
	Runtime:addEventListener( "resize", self )
end

-- Prepare to show the optionsView scene
function optionsView:show( event )
	if event.phase == "will" then
		setSelectedOptions()
		forceReprocess = false
		toolbar.show( false )
		setEditorButtons()
	end
	if event.phase == "did" then
		self:resize()
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
-- TODO: Fix Corona runtime error or replace scrollView with scrollbar.lua
function optionsView:resize()
	if composer.getSceneName( "current" ) == "optionsView" then
		-- TODO: resize scroll bar
		-- reposition objects
		closeBtn.x = math.round( app.width - app.margin - closeBtn.width )
		title.x = math.round( app.width / 2 - title.width / 2)
		if app.width > optionsGroup.width then
			optionsGroup.x = math.round( app.width / 2 - optionsGroup.width / 2 )
		else
			optionsGroup.x = 0
		end
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
optionsView:addEventListener( "create", optionsView )
optionsView:addEventListener( "show", optionsView )
optionsView:addEventListener( "hide", optionsView )
return optionsView


