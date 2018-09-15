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
local topMargin = app.dyToolbar + margin
local leftMargin = margin

-- Display objects and groups
local backBtn             -- Back button
local levelPicker         -- Syntax level picker
local tabWidthPicker      -- Tab width picker
local editorPicker        -- Text editor picker

-- Data tables
local winEditors = {
		{ name = "Sublime Text 3", path = [[C:\Program Files\Sublime Text 3\sublime_text.exe]] },
		{ name = "Sublime Text 3", path = [[C:\Program Files (x86)\Sublime Text 3\sublime_text.exe]] },
		{ name = "Notepad++", path = [[C:\Program Files\Notepad++\notepad++.exe]] },
		{ name = "Notepad++", path = [[C:\Program Files (x86)\Notepad++\notepad++.exe]] }
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
	local installedEds = { { name = "System Default", path = nil } }
	for i = 1, #editors do
		local editor = editors[i]
		if editor.name ~= installedEds[#installedEds].name then
			local f = io.open( editor.path , "r" )
			if f then
				io.close( f )
				installedEds[#installedEds + 1] = editor
			end
		end
	end
	return installedEds
end

-- Set the active segment of the editorPicker to saved editor
local function setActiveEditorSegment()
	for i = 1, #installedEditors do
		if installedEditors[i].path == app.editorPath then
			editorPicker:setActiveSegment( i )
			break
		end
	end
end

-- Event handler for the Back button
local function onBack()
	-- app.saveSettings()
	local prevScene = composer.getSceneName( "previous" )
	print( prevScene )
	composer.gotoScene( prevScene )
end


--- Scene Methods ------------------------------------------------

-- Create the errView scene
function optionsView:create()
	local sceneGroup = self.view

	-- Background
	 g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 
	
	-- Title
	local title = display.newText{
		parent = sceneGroup,
		text = "Code12 Options",
		x = app.width / 2,
		y = app.margin,
		font = native.systemFontBold,
		fontSize = app.fontSizeUI * 1.5,
	}
	title:setFillColor( 0 )
	title.anchorY = 0

	-- Back button
	local btnShade = app.toolbarShade
	backBtn = widget.newButton{
		x = app.width - margin,
		y = margin,
		onRelease = onBack,
		label = "X",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
		shape = "rect",
		width = 15,
		height = 15,
	}
	sceneGroup:insert( backBtn )
	backBtn.anchorX = 1
	backBtn.anchorY = 0

	-- Level picker label
	local levelLabel = display.newText{
		parent = sceneGroup,
		text = "Code12 Level:",
		x = leftMargin,
		y = title.y + title.height + margin,
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	g.uiBlack( levelLabel )

	-- Level picker
	local segmentNames = {}
	for i = 1, app.numSyntaxLevels do
		segmentNames[i] = tostring( i )
	end
	local segWidth = 25
	levelPicker = widget.newSegmentedControl{
		x = leftMargin,
		y = levelLabel.y + levelLabel.height,
		segmentWidth = segWidth,
		segments = segmentNames,
		defaultSegment = app.syntaxLevel,
		onPress = 
			function ( event )
				app.syntaxLevel = event.target.segmentNumber
			end
	}
	sceneGroup:insert( levelPicker )
	levelPicker.anchorX = 0
	levelPicker.anchorY = 0

	-- Tab width picker label
	local tabWidthLabel = display.newText{
		parent = sceneGroup,
		text = "Tab Width:",
		x = leftMargin,
		y = levelPicker.y + levelPicker.height + margin,
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	g.uiBlack( tabWidthLabel )

	-- Tab width picker
	segmentNames = {}
	for i = 2, 8 do
		segmentNames[i - 1] = tostring( i )
	end
	tabWidthPicker = widget.newSegmentedControl{
		x = leftMargin,
		y = tabWidthLabel.y + tabWidthLabel.height,
		segmentWidth = segWidth,
		segments = segmentNames,
		defaultSegment = app.tabWidth - 1,
		onPress =
			function ( event )
				app.tabWidth = event.target.segmentNumber + 1
			end
	}
	tabWidthPicker.anchorX = 0
	tabWidthPicker.anchorY = 0
	sceneGroup:insert( tabWidthPicker )
	
	-- Editor picker label
	local editorLabel = display.newText{
		parent = sceneGroup,
		text = "Text Editor:",
		x = leftMargin,
		y = tabWidthPicker.y + tabWidthPicker.height + margin,
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	g.uiBlack( editorLabel )

	-- Editor picker
	installedEditors = getInstalledEditors()
	segmentNames = {}
	for i = 1, #installedEditors do
		segmentNames[i] = installedEditors[i].name
	end
	editorPicker = widget.newSegmentedControl{
	x = leftMargin,
	y = editorLabel.y + editorLabel.height,
	segmentWidth = 120,
	segments = segmentNames,
	onPress = 
		function ( event )
			app.editorPath = installedEditors[event.target.segmentNumber].path
		end
	}
	editorPicker.anchorX = 0
	editorPicker.anchorY = 0
	sceneGroup:insert( editorPicker )
	setActiveEditorSegment()
end

-- Prepare to show the errView scene
function optionsView:show( event )
	if event.phase == "will" then
		setActiveEditorSegment()
		toolbar.show( false )
	end
end

-- Prepare to hide the errView scene
function optionsView:hide( event )
	if event.phase == "did" then
		toolbar.show( true )
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
optionsView:addEventListener( "create", optionsView )
optionsView:addEventListener( "show", optionsView )
optionsView:addEventListener( "hide", optionsView )
return optionsView


