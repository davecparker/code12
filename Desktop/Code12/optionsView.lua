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
local checkboxSize = 14
local checkboxSheet = graphics.newImageSheet( "images/checkbox.png", { width = 256, height = 256, numFrames = 2 } )

-- Display objects and groups
local title               -- Title text
local closeBtn            -- Close view button
local levelPicker         -- Syntax level picker
local tabWidthPicker      -- Tab width picker
local editorPicker        -- Text editor picker

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

-- Create and return a new display group containing a label and set of option checkboxes
-- options = {
--     parentGroup = group to insert the checkboxes group in
--     optionLabel = string for the option label text
--     checkboxLabels = table of strings for the labeling the checkboxes (one checkbox will be )
--     x = x-value to position the group at (with anchorX = 0)
--     y = y-value to position the group at (with anchorY = 0)
--     onPress = listener function for checkboxes
-- }
local function newCheckboxOption( options )
	local checkboxOptionGroup = display.newGroup() -- group to be returned
	options.parentGroup:insert( checkboxOptionGroup )
	checkboxOptionGroup.anchorX = 0
	checkboxOptionGroup.anchorY = 0
	checkboxOptionGroup.x = options.x
	checkboxOptionGroup.y = options.y
	-- option main label
	local optionLabel = display.newText{
		parent = checkboxOptionGroup,
		text = options.optionLabel,
		x = 0,
		y = 0,
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	g.uiBlack( optionLabel )
	-- option swiches and labels
	local checkboxesGroup = display.newGroup()
	checkboxOptionGroup:insert( checkboxesGroup )
	checkboxOptionGroup.checkboxes = checkboxesGroup
	checkboxesGroup.anchorX = 0
	checkboxesGroup.anchorY = 0
	checkboxesGroup.x = 0
	checkboxesGroup.y = optionLabel.y + optionLabel.height
	local checkboxLabels = options.checkboxLabels
	for i = 1, #checkboxLabels do
		local checkbox = widget.newSwitch{
			x = 0,
			y = checkboxSize * (i - 1),
			style = "radio",
			width = checkboxSize,
			height = checkboxSize,
			onPress = options.onPress,
			sheet = checkboxSheet,
			frameOn = 1,
			frameOff = 2,
			id = options.optionLabel .. "checkbox" .. i,
		}
		checkbox.number = i
		checkbox.anchorX = 0
		checkbox.anchorY = 0
		checkboxesGroup:insert( checkbox )
		local checkboxLabel = display.newText{
			parent = checkboxOptionGroup,
			text = checkboxLabels[i],
			x = checkbox.x + checkboxSize + margin * 0.5,
			y = checkboxesGroup.y + checkbox.y,
			font = native.systemFont,
			fontSize = app.fontSizeUI,
		}
		g.uiItem( checkboxLabel )
	end
	return checkboxOptionGroup
end

-- Set the active segment of the editorPicker to saved editor
local function setCheckedEditor()
	if app.useDefaultEditor or #installedEditors == 1 then
		-- Check on "System Default"
		editorPicker.checkboxes[1]:setState{ isOn = true }
	elseif app.editorPath == nil then
		-- Check on first non system default editor
		editorPicker.checkboxes[2]:setState{ isOn = true }
		app.editorPath = installedEditors[2].path
	else
		-- Check on the user's preferred editor if it is installed
		local preferredEditorInstalled
		for i = 2, #installedEditors do
			if installedEditors[i].path == app.editorPath then
				editorPicker.checkboxes[i]:setState{ isOn = true }
				preferredEditorInstalled = true
				break
			end
		end
		if not preferredEditorInstalled then
			editorPicker.checkboxes[2]:setState{ isOn = true }
			app.editorPath = installedEditors[2].path
		end
	end
end


--- Event Handlers ------------------------------------------------

-- Event handler for the Close button
local function onClose()
	app.saveSettings()
	local prevScene = composer.getSceneName( "previous" )
	composer.gotoScene( prevScene )
end

-- Event handler for the Editor picker checkboxes
local function onEditorPicked( event )
	local checkbox = event.target
	app.editorPath = installedEditors[checkbox.number].path
	app.useDefaultEditor = app.editorPath == nil
end


--- Scene Methods ------------------------------------------------

-- Create the errView scene
function optionsView:create()
	local sceneGroup = self.view

	-- Background
	 g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 
	
	-- Title
	title = display.newText{
		parent = sceneGroup,
		text = "Code12 Options",
		x = app.width / 2,
		y = app.margin,
		font = native.systemFontBold,
		fontSize = app.fontSizeUI * 1.5,
	}
	title:setFillColor( 0 )
	title.anchorY = 0

	-- Close button
	closeBtn = widget.newButton{
		defaultFile = "images/close.png",
		x = app.width - margin,
		y = margin,
		onRelease = onClose,
		width = 15,
		height = 15,
	}
	sceneGroup:insert( closeBtn )
	closeBtn.anchorX = 1
	closeBtn.anchorY = 0

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

	-- Editor picker
	installedEditors = getInstalledEditors()
	local editorNames = {}
	for i = 1, #installedEditors do
		editorNames[i] = installedEditors[i].name
	end
	editorPicker = newCheckboxOption{
		parentGroup = sceneGroup,
		optionLabel = "Text Editor:",
		checkboxLabels = editorNames,
		x = leftMargin,
		y = tabWidthPicker.y + tabWidthPicker.height + margin,
		onPress = onEditorPicked,
	}
end

-- Prepare to show the errView scene
function optionsView:show( event )
	if event.phase == "will" then
		setCheckedEditor()
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


