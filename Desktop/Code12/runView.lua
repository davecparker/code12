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

-- Code12 runtime modules
local g = require( "Code12.globals" )
local runtime = require("Code12.runtime")

-- Code12 app modules
local app = require( "app" )
local err = require( "err" )
local console = require( "console" )
local varWatch = require( "varWatch" )


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

-- Program state
local minConsoleHeight         -- min height of the console window (from pane split)
local paneDragOffset           -- when dragging the pane split


--- Internal Functions ------------------------------------------------

-- Return the available height for the output area
local function outputAreaHeight()
	return app.height - app.dyToolbar - app.dyStatusBar - minConsoleHeight - dyPaneSplit
end

-- Return the available width and height for the variable watch window
local function varWatchWidthAndHeight()
	return app.width - rightBar.x, app.outputHeight - 1
end

-- Position the display panes
local function layoutPanes()
	-- Determine size of the top area (game or error output)
	local width = app.outputWidth
	local height = app.outputHeight

	-- Position the right bar and variable watch group
	rightBar.x = width + 1
	rightBar.width = app.width    -- more than enough
	rightBar.height = app.height  -- more than enough
	varWatch.group.x = rightBar.x
	if app.showVarWatch then
		varWatch.resize( varWatchWidthAndHeight() )
	end

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
	runtime.appContext.widthP = math.max( app.width, 1 )
	runtime.appContext.heightP = math.max( outputAreaHeight(), 1 )
	if runtime.onResize then
		runtime.onResize()
	end
end

-- Handle touch events on the pane split area.
-- Moving the split pane changes the minimum console height
local function onTouchPaneSplit( event )
	local phase = event.phase
	if phase == "began" then
		g.setFocusObj( paneSplit )
		paneDragOffset = event.y - lowerGroup.y
	elseif g.focusObj == paneSplit and phase ~= "cancelled" then
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
						0.95, app.borderShade )
	paneSplit = g.uiItem( display.newRect( sceneGroup, 0, 0, 0, dyPaneSplit ), 
						app.toolbarShade, app.borderShade )
	paneSplit:addEventListener( "touch", onTouchPaneSplit )
	lowerGroup = g.makeGroup( sceneGroup )
	console.create( lowerGroup, 0, 0, 0, 0 )
	varWatch.create( sceneGroup, rightBar.x, rightBar.y, 0, 0 )

	-- Layout the display areas
	minConsoleHeight = app.consoleFontHeight * defaultConsoleLines
	app.outputWidth = app.width
	app.outputHeight = outputAreaHeight()
	layoutPanes()

	-- Install resize handler
	Runtime:addEventListener( "resize", onResize )

	-- Set appContext data related to the view
	local appContext = runtime.appContext
	appContext.outputGroup = outputGroup
	appContext.widthP = app.outputWidth
	appContext.heightP = app.outputHeight
	appContext.setClipSize = setClipSize
	appContext.clearConsole = console.clear
	appContext.print = console.print
	appContext.println = console.println
	appContext.runtimeErr = showRuntimeError
	appContext.arrayAssigned = varWatch.arrayAssigned
end

-- Prepare to show the runView scene
function runView:show( event )
	if event.phase == "did" then
		-- Automatically run a new program
		if g.runState == nil then
			runtime.run()
			if app.showVarWatch then
				varWatch.startNewRun( varWatchWidthAndHeight() )
			end
		end
	end
end

-- Prepare to hide the runView scene
function runView:hide( event )
	if event.phase == "will" then
		-- Hide the varWatch table
		if app.showVarWatch then
			varWatch.hide()
		end
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
runView:addEventListener( "create", runView )
runView:addEventListener( "show", runView )
runView:addEventListener( "hide", runView )
return runView


