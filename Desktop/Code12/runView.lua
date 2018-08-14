-----------------------------------------------------------------------------------------
--
-- runView.lua
--
-- The view for a running program for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local err = require( "err" )
local console = require( "console" )

-- The runView module and scene
local runView = composer.newScene()

-- UI metrics
local dyPaneSplit = 10
local defaultConsoleLines = 10

-- Display objects and groups
local outputGroup              -- display group for program output area
local rightBar                 -- clipping bar to the right of the output area
local paneSplit                -- pane split area
local lowerGroup               -- display area below the pane split
local gameGroup                -- display group for game output

-- Program state
local minConsoleHeight         -- min height of the console window (from pane split)
local paneDragOffset           -- when dragging the pane split
local appContext               -- app context for the running program


--- Internal Functions ------------------------------------------------

-- Return the available height for the output area
local function outputAreaHeight()
	return app.height - app.dyToolbar - app.dyStatusBar - minConsoleHeight - dyPaneSplit
end

-- Position the display panes
local function layoutPanes()
	-- Determine size of the top area (game or error output)
	local width = app.outputWidth
	local height = app.outputHeight

	-- Position the right bar
	rightBar.x = width + 1
	rightBar.width = app.width    -- more than enough
	rightBar.height = app.height  -- more than enough

	-- Position the pane split and lower group
	paneSplit.y = app.dyToolbar + height
	paneSplit.width = app.width
	lowerGroup.y = paneSplit.y + dyPaneSplit + 1
	local consoleHeight = app.height - lowerGroup.y - app.dyStatusBar
	console.resize( app.width, consoleHeight )
end

-- Runtime callback to set the output size being used
local function setClipSize( widthP, heightP )
	app.outputWidth = math.floor( widthP )
	app.outputHeight = math.floor( heightP )
	layoutPanes()
end

-- Window resize handler
local function onResize()
	-- Calculate the output space and tell the runtime we resized. 
	-- This will result in a call to ct.setHeight() internally, 
	-- which will then call us back at setClipSize().
	app.getWindowSize()
	appContext.widthP = math.max( app.width, 1 )
	appContext.heightP = math.max( outputAreaHeight(), 1 )
	if g.onResize then
		g.onResize()
	end
end

-- Handle touch events on the pane split area.
-- Moving the split pane changes the minimum console height
local function onTouchPaneSplit( event )
	local phase = event.phase
	if phase == "began" then
		g.setFocusObj( paneSplit )
		paneDragOffset = event.y - lowerGroup.y
	elseif g.getFocusObj() == paneSplit and phase ~= "cancelled" then
		-- Compute and set new console size below pane split
		local y = event.y - paneDragOffset
		minConsoleHeight = g.pinValue( app.height - y - app.dyStatusBar,
				0, app.height - app.dyStatusBar )
		onResize()
	end
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end
	return true
end

-- Clear any existing program output
local function clearOutput()
	console.clear()
	if gameGroup then
		gameGroup:removeSelf()
	end
	gameGroup = g.makeGroup( outputGroup )
end

-- Show a runtime error with the given line number and message
local function showRuntimeError( lineNum, message )
	err.setErrLineNum( lineNum, "Runtime error: " .. message )
	composer.gotoScene( "errView" )
end


--- Scene Methods ------------------------------------------------

-- Create the runView scene
function runView:create()
	local sceneGroup = self.view

	-- Background rect
	g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 

	-- Make the display areas
	outputGroup = g.makeGroup( sceneGroup, 0, app.dyToolbar )
	rightBar = g.uiItem( display.newRect( sceneGroup, 0, app.dyToolbar, 0, 0 ), 
						app.extraShade, app.borderShade )
	paneSplit = g.uiItem( display.newRect( sceneGroup, 0, 0, 0, dyPaneSplit ), 
						app.toolbarShade, app.borderShade )
	paneSplit:addEventListener( "touch", onTouchPaneSplit )
	lowerGroup = g.makeGroup( sceneGroup )
	console.create( lowerGroup, 0, 0, 0, 0 )

	-- Layout the display areas
	minConsoleHeight = app.consoleFontHeight * defaultConsoleLines
	app.outputWidth = app.width
	app.outputHeight = outputAreaHeight()
	layoutPanes()

	-- Install resize handler
	Runtime:addEventListener( "resize", onResize )

	-- Fill in the appContext for the runtime
	appContext = ct._appContext
	appContext.outputGroup = outputGroup
	appContext.widthP = app.outputWidth
	appContext.heightP = app.outputHeight
	appContext.setClipSize = setClipSize
	appContext.print = console.print
	appContext.println = console.println
	appContext.runtimeErr = showRuntimeError

	-- Load the Code12 API and runtime.
	-- This defines the Code12 APIs in the global ct table
	-- and sets the runtime's fields in ct._appContext.
	require( "Code12.api" )
end

-- Prepare to show the runView scene
function runView:show( event )
	local phase = event.phase
	if phase == "will" then
		clearOutput()
	elseif phase == "did" then
		g.initRun()   -- Tell the runtime to init and start a new run
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
runView:addEventListener( "create", runView )
runView:addEventListener( "show", runView )
return runView

