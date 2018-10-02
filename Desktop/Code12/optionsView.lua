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
local leftMargin = 125    -- Left margin of the options
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
	local syntaxLevel = event.target.value
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
	levelPicker = buttons.newSettingPicker{
		parent = sceneGroup,
		header = "Syntax Level:",
		headerFont = native.systemFontBold,
		headerFontSize = fontSize,	
		labels = syntaxLevels,
		labelsFont = native.systemFont,
		labelsFontSize = fontSize,
		style = "fillbox",
		switchSize = switchSize,
		x = leftMargin,
		y = title.y + title.height + margin,
		onPress = onSyntaxLevelPress,
	}

	-- Tab width header
	local tabWidthHeader  = display.newText{
		parent = sceneGroup,
		text = "Tab Width:",
		x = leftMargin,
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
		x = leftMargin,
		y = tabWidthHeader.y + tabWidthHeader.height + margin * 0.5,
		segments = tabWidths,
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
	sceneGroup:insert( tabWidthPicker )

	-- Editor picker
	local editorNames = {}
	for i = 1, #env.installedEditors do
		editorNames[i] = env.installedEditors[i].name
	end
	editorPicker = buttons.newSettingPicker{
		parent = sceneGroup,
		header = "Text Editor:",
		headerFont = native.systemFontBold,
		headerFontSize = fontSize,
		labels = editorNames,
		labelsFont = native.systemFont,
		labelsFontSize = fontSize,
		style = "radio",
		switchSize = switchSize,
		x = leftMargin,
		y = tabWidthPicker.y + tabWidthPicker.height + margin,
		onPress = 
			function ( event )
				app.editorPath = env.installedEditors[event.target.value].path
				app.useDefaultEditor = app.editorPath == nil
			end
	}

	-- Open In Editor button
	openInEditorBtn = buttons.newOptionButton{
		parent = sceneGroup,
		x = leftMargin,
		y = editorPicker.y + editorPicker.height + margin * 0.5,
		onRelease = onOpenInEditor,
		label = "Open MyProgram.java in Editor",
		font = native.systemFont,
		fontSize = fontSize,
		width = 350,
		height = 35,
	}

	-- Multi-error picker
	multiErrorPicker = buttons.newSettingPicker{
		parent = sceneGroup,
		header = "Multi-Error Mode:",
		headerFont = native.systemFontBold,
		headerFontSize = fontSize,
		labels = { "Show only one error at a time" },
		labelsFont = native.systemFont,
		labelsFontSize = fontSize,
		style = "checkbox",
		switchSize = switchSize,
		x = leftMargin,
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


