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
local buttons = require( "buttons" )


-- The optionsView module and scene
local optionsView = composer.newScene()


-- UI Metrics
local margin = app.margin -- Space between most UI elements
local topMargin = margin  -- Top margin of the scene
local switchSize = 20     -- Size of radio buttons, checkboxes, and fillboxes
local fontSize = 20       -- Font size of switch headers and labels

-- Display objects and groups
local title               -- Title text
local closeBtn            -- Close view button
local levelPicker         -- Syntax level picker
local tabWidthPicker      -- Tab width picker
local editorPicker        -- Text editor picker
local varWatchPicker      -- Variable watch window mode picker
local addEditorBtn        -- Add a Text Editor button
local openInEditorBtn     -- Open current source file in editor button
local optionsGroup        -- Display group containing the options objects
local scrollView          -- Scroll view widget containing optionsGroup

-- State variables
local lastAppWidth        -- Value of app.width the last time optionsView was shown/resized
local lastAppHeight       -- Value of app.height the last time optionsView was shown/resized


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

	-- Set the checked box of the varWatchPicker
	if app.showVarWatch then
		varWatchPicker.switches[1]:setState{ isOn = true }
	else
		varWatchPicker.switches[1]:setState{ isOn = false }
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
		header = "Text Editor:",
		headerFont = native.systemFontBold,
		headerFontSize = fontSize,
		labels = editorNames,
		labelsFont = native.systemFont,
		labelsFontSize = fontSize,
		style = "radio",
		switchSize = switchSize,
		x = 0,
		y = varWatchPicker.y + varWatchPicker.height + margin,
		onPress = 
			function ( event )
				app.editorPath = env.installedEditors[event.target.value].path
				app.useDefaultEditor = app.editorPath == nil
			end
	}
end

local function setEditorButtons( repositionAddEditorBtn )
	if repositionAddEditorBtn then
		addEditorBtn.y = editorPicker.y + editorPicker.height + margin * 0.5
	end
	if #app.recentSourceFilePaths > 0 then
		local _, filename = env.dirAndFilenameOfPath( app.recentSourceFilePaths[1] )
		openInEditorBtn:setLabel( "Open " .. filename .. " in Editor" )
		openInEditorBtn.y = addEditorBtn.y + addEditorBtn.height + margin * 0.5
		openInEditorBtn.isVisible = true
	else
		openInEditorBtn.isVisible = false
	end
end

-- Make the scroll view, insert it into the scene, and insert optionsGroup into it
local function makeScrollView( parent )
	parent:insert( optionsGroup )
	if scrollView then
		scrollView:removeSelf()
		scrollView = nil
	end
	scrollView = widget.newScrollView{
		top = title.y + title.height + margin,
		left = 0,
		width = app.width,
		height = app.height - title.height - app.dyStatusBar,
		isBounceEnabled = false,
		backgroundColor = { 0.9 },
	}
	parent:insert( scrollView )
	scrollView:insert( optionsGroup )
	scrollView:setScrollWidth( optionsGroup.width )
	scrollView:setScrollHeight( optionsGroup.height + app.dyStatusBar )
	if optionsGroup.width <= app.width then
		scrollView:setIsLocked( true, "horizontal" )
	end
	if scrollView.y + optionsGroup.height <= app.height then
		scrollView:setIsLocked( true, "vertical" )
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
	local syntaxLevel = event.target.value
	app.syntaxLevel = syntaxLevel
	fillBoxes( levelPicker.switches, syntaxLevel )
end

-- Show dialog to choose the editor and add the path to installed editors
-- and user's settings
local function addEditor()
	local editorPath = env.pathFromOpenFileDialog( "Choose a Text Editor", "*.exe", "Executables (*.exe)" )
	if not editorPath then
		native.setActivityIndicator( false )
	elseif env.isWindows and string.sub( editorPath, -4, -1 ) ~= ".exe" then
		env.showErrAlert( "Invalid File Extension", "Please choose a .exe file" )
		addEditor()
	elseif not env.isWindows and string.sub( editorPath, -4, -1 ) ~= ".app" then
		env.showErrAlert( "Invalid File Extension", "Please choose a .app file" )
		addEditor()
	else
		local _, editorName = env.dirAndFilenameOfPath( editorPath )

		local newEditor = { name = editorName, path = editorPath }
		env.installedEditors[#env.installedEditors + 1] = newEditor
		app.customEditors[#app.customEditors + 1] = newEditor
		app.editorPath = editorPath
		app.saveSettings()
		makeEditorPicker( optionsGroup )
		setEditorButtons( true )
		setSelectedOptions()
		makeScrollView( optionsView.view )
		native.setActivityIndicator( false )
	end
end

-- Event handler for the Add Editor button
local function onAddEditor()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, addEditor )
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
		fontSize = fontSize * 1.5,
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

	-- Options display group
	optionsGroup = display.newGroup()

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
	levelPicker = buttons.newSettingPicker{
		parent = optionsGroup,
		header = "Syntax Level:",
		headerFont = native.systemFontBold,
		headerFontSize = fontSize,	
		labels = syntaxLevels,
		labelsFont = native.systemFont,
		labelsFontSize = fontSize,
		style = "fillbox",
		switchSize = switchSize,
		x = 0,
		y = 0,
		onPress = onSyntaxLevelPress,
	}

	-- Tab width header
	local tabWidthHeader  = display.newText{
		parent = optionsGroup,
		text = "Tab Width:",
		x = 0,
		y = levelPicker.y + levelPicker.height + margin,
		font = native.systemFontBold,
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
		y = tabWidthHeader.y + tabWidthHeader.height + margin * 0.5,
		segments = tabWidths,
		segmentWidth = 30,
		defaultSegment = app.tabWidth - 1,
		labelSize = fontSize,
		labelColor = { default = { 0 }, over = { 0 } },
		onPress =
			function ( event )
				app.tabWidth = event.target.segmentNumber + 1
			end
	}
	tabWidthPicker.anchorX = 0
	tabWidthPicker.anchorY = 0
	optionsGroup:insert( tabWidthPicker )

	-- Variable Watch Window picker
	varWatchPicker = buttons.newSettingPicker{
		parent = optionsGroup,
		header = "Variable Watch Mode:",
		headerFont = native.systemFontBold,
		headerFontSize = fontSize,
		labels = { "Show the variable watch window" },
		labelsFont = native.systemFont,
		labelsFontSize = fontSize,
		style = "checkbox",
		switchSize = switchSize,
		x = 0,
		y = tabWidthPicker.y + tabWidthPicker.height + margin,
		onPress =
			function ( event )
				app.showVarWatch = event.target.isOn
			end
	}

	-- Editor picker
	makeEditorPicker( optionsGroup, varWatchPicker )

	-- Add Text Editor button
	addEditorBtn = buttons.newOptionButton{
		parent = optionsGroup,
		x = 0,
		y = editorPicker.y + editorPicker.height + margin * 0.5,
		onRelease = onAddEditor,
		label = "Add a Text Editor",
	}

	-- Open In Editor button
	openInEditorBtn = buttons.newOptionButton{
		parent = optionsGroup,
		x = 0,
		y = addEditorBtn.y + addEditorBtn.height + margin * 0.5,
		onRelease = onOpenInEditor,
		label = "",
	}

	-- Center options group
	if app.width > optionsGroup.width then
		optionsGroup.x = app.width / 2 - optionsGroup.width / 2
	end

	-- Set up scroll view
	makeScrollView( sceneGroup )

	-- Install resize handler
	Runtime:addEventListener( "resize", self )
	
	-- Save app window size
	lastAppWidth, lastAppHeight = app.width, app.height
end

-- Prepare to show the optionsView scene
function optionsView:show( event )
	if event.phase == "will" then
		setSelectedOptions()
		toolbar.show( false )
		setEditorButtons()
		if lastAppWidth ~= app.width or lastAppHeight ~= app.height then
			self:resize()
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
-- TODO: Fix Corona runtime error or replace scrollView with scrollbar.lua
function optionsView:resize()
	if composer.getSceneName( "current" ) == "optionsView" then
		local sceneGroup = self.view
		-- remake scroll view
		makeScrollView( sceneGroup )
		-- reposition objects
		closeBtn.x = app.width - app.margin
		title.x = app.width / 2
		if app.width > optionsGroup.width then
			optionsGroup.x = app.width / 2 - optionsGroup.width / 2
		else
			optionsGroup.x = 0
		end
		lastAppWidth = app.width
		lastAppHeight = app.height
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
optionsView:addEventListener( "create", optionsView )
optionsView:addEventListener( "show", optionsView )
optionsView:addEventListener( "hide", optionsView )
return optionsView

