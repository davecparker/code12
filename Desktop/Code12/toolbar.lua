-----------------------------------------------------------------------------------------
--
-- toolbar.lua
--
-- The toolbar for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules and plugins
local widget = require( "widget" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )


-- The toolbar module
local toolbar = {}


-- File local state
local toolbarGroup        -- display group for toolbar
local bgRect              -- background rect
local chooseFileBtn       -- Choose File button
local levelPicker         -- Syntax level picker


--- Internal Functions ------------------------------------------------

-- Show dialog to choose the user source code file
local function chooseFile()
	local path = env.pathFromOpenFileDialog( "Choose Java Source Code File" )
	if path then
		app.sourceFile.path = path
		app.sourceFile.timeLoaded = os.time()
		app.sourceFile.timeModLast = 0
	end
	native.setActivityIndicator( false )
end

-- Event handler for the Choose File button
local function onChooseFile()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, chooseFile )
end


--- Module Functions ------------------------------------------------

-- Make the toolbar UI
function toolbar.create()
	toolbarGroup = g.makeGroup()

	-- Background
	bgRect = g.uiItem( display.newRect( toolbarGroup, 0, 0, app.width, app.dyToolbar ),
							app.toolbarShade, app.borderShade )

	-- Choose File Button
	local yCenter = app.dyToolbar / 2
	chooseFileBtn = widget.newButton{
		x = app.margin, 
		y = yCenter,
		onRelease = onChooseFile,
		label = "Choose File",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	toolbarGroup:insert( chooseFileBtn )
	chooseFileBtn.anchorX = 0

	-- Level picker
	local segmentNames = {}
	for i = 1, app.numSyntaxLevels do
		segmentNames[i] = tostring( i )
	end
	local segWidth = 25
	levelPicker = widget.newSegmentedControl{
		x = app.width - app.margin,
		y = yCenter,
		segmentWidth = segWidth,
		segments = segmentNames,
		defaultSegment = app.numSyntaxLevels,
		onPress = 
			function (event )
				app.syntaxLevel = event.target.segmentNumber
				app.processUserFile()
			end
	}
	levelPicker.anchorX = 1
end

-- Resize the toolbar
function toolbar.resize()
	bgRect.width = app.width
	levelPicker.x = app.width - app.margin
end


------------------------------------------------------------------------------

return toolbar



