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
local dxyPaneSplit = 10
local gridLabelsFontSize = 11
local gridLineShade = 0.6

-- Display objects and groups
local outputGroup              -- display group for program output area
local rightBar                 -- clipping bar to the right of the output area
local paneSplitConsole         -- pane split between output and console
local paneSplitRight           -- pane split between output and varWatch window
local lowerGroup               -- display area below the pane split
local gridGroup                -- display group for the coordinate grideLines

-- UI state
local paneDragOffset           -- when dragging the pane split
local outputRatio              -- fraction of app height taken by output area
local showVarWatchLast         -- last known value of app.showVarWatch
local layoutNeeded             -- true when the layout has changed


--- Internal Functions ------------------------------------------------

-- Return the available width for the output area
local function maxOutputWidth()
	if app.showVarWatch then
		return app.width - dxyPaneSplit
	end
	return app.width
end

-- Return the available height for the output area
local function maxOutputHeight()
	return app.height - app.dyToolbar - app.dyStatusBar - dxyPaneSplit
end

-- Return the available width and height for the variable watch window
local function varWatchWidthAndHeight()
	return app.width - rightBar.x, app.outputHeight - 1
end

-- Return a new text object at x, y which has been inserted into the gridGroup and has
-- fill color set to gridLineShade
local function newGridLabel( text, x, y )
	local label = display.newText( gridGroup, text, x, y, native.systemFont, gridLabelsFontSize )
	label:setFillColor( gridLineShade )
	return label
end

-- Return an new line from x1, y1 to x2, y2 which has been inserted into the gridGroup and has
-- stroke color set to grideLineShade
local function newGridLine( x1, y1, x2, y2 )
	local line = display.newLine( gridGroup, x1, y1, x2, y2 )
	line:setStrokeColor( gridLineShade )
	return line
end

-- Make the coordinate grideLines
local function makeGrid( width, height )
	local sceneGroup = runView.view
	if sceneGroup then
		-- Remove existing gridGroup, if any
		if gridGroup then
			gridGroup:removeSelf()
			gridGroup = nil
		end
		-- Make gridGroup
		gridGroup = g.makeGroup( sceneGroup, outputGroup.x, outputGroup.y )
		-- Make vertical gride lines and labels
		local dx = width / 10
		for i = 1, 9 do
			local label = newGridLabel( i .. "0", dx * i, 0 )
			label.anchorY = 0
			local x = dx * i
			local y = label.height + 1
			newGridLine( x, y, x, height )
		end
		-- Make horizontal grideLines and labels
		local rowNum = 1
		local y = dx
		while y < height do
			local label = newGridLabel( rowNum .. "0", 0, y )
			label.anchorX = 0
			local x = label.width + 1
			newGridLine( x, y, width, y )
			rowNum = rowNum + 1
			y = y + dx
		end
		paneSplitConsole:toFront() -- In case last label extends below top of pane split
	end
end

-- Position the display panes
local function layoutPanes()
	-- Get the size of the program's graphics output area
	local width = app.outputWidth
	local height = app.outputHeight

	-- Position the right pane split, right bar, and variable watch group
	-- The right pane spit is hidden if the varWatch window is off.
	if app.showVarWatch then
		paneSplitRight.isVisible = true
		paneSplitRight.x = width + 1
		paneSplitRight.height = app.height  -- more than enough
		rightBar.x = paneSplitRight.x + dxyPaneSplit + 1
	else
		paneSplitRight.isVisible = false
		rightBar.x = width + 1
	end
	rightBar.width = app.width    -- more than enough
	rightBar.height = app.height  -- more than enough
	varWatch.group.x = rightBar.x
	varWatch.resize( varWatchWidthAndHeight() )

	-- Position the console pane split and lower group
	paneSplitConsole.y = outputGroup.y + height
	paneSplitConsole.width = app.width
	lowerGroup.y = paneSplitConsole.y + dxyPaneSplit + 1
	local consoleHeight = app.height - lowerGroup.y - app.dyStatusBar
	console.resize( app.width, consoleHeight )

	-- Remake the coordinate grideLines if they are on
	if app.gridOn then
		makeGrid( width, height )
	end
end

-- Runtime callback to set the output pixel size being used
local function setOutputSize( widthP, heightP )
	app.outputWidth = math.floor( widthP )
	app.outputHeight = math.floor( heightP )
	layoutNeeded = true
end

-- Resize the output area using width and height as the available space,
-- or the max available size for either if nil.
-- If keep then remember the vertical split ratio to use for window resizes.
local function resizeOutputArea( width, height, keep )
	-- Get maximum available area
	local maxWidth = maxOutputWidth()
	local maxHeight = maxOutputHeight()

	-- Set the desired output size and tell the runtime it resized. 
	-- This will result in a call to ct.setHeight() internally, 
	-- which will then call us back at setOutputSize() with the 
	-- resulting size as constrained by the program's aspect ratio.
	runtime.appContext.widthP = g.pinValue( width or maxWidth, 1, maxWidth )
	runtime.appContext.heightP = g.pinValue( height or maxHeight, 1, maxHeight )
	runtime.onResize()

	-- Remember the user's desired output to console proportion if asked for
	if keep then
		outputRatio = app.outputHeight / maxHeight
	end
end

-- Set a default layout for the output areas
local function setDefaultLayout()
	-- Get available size
	local width = maxOutputWidth()
	local maxHeight = maxOutputHeight()
	local height = maxHeight

	-- If the varWatch window is enabled then make at least some room for it
	if app.showVarWatch then
		width = math.max( width * 0.5, width - 200 )
	end

	-- Make sure at least some console is showing
	height = math.max( height * 0.75, height - 200 )

	-- Set the layout
	resizeOutputArea( width, height, true )
end

-- Handle touch events on the console pane split.
local function onTouchPaneSplitConsole( event )
	local phase = event.phase
	if phase == "began" then
		g.setFocusObj( paneSplitConsole )
		paneDragOffset = event.y - paneSplitConsole.y
	elseif g.focusObj == paneSplitConsole and phase ~= "cancelled" then
		-- The console split affects the available output area height.
		local y = event.y - paneDragOffset
		resizeOutputArea( nil, y - outputGroup.y, true )
	end
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end
	return true
end

-- Handle touch events on the right pane split.
local function onTouchPaneSplitRight( event )
	local phase = event.phase
	if phase == "began" then
		g.setFocusObj( paneSplitRight )
		paneDragOffset = event.x - paneSplitRight.x
	elseif g.focusObj == paneSplitRight and phase ~= "cancelled" then
		-- The right split affects the available output area width.
		local x = event.x - paneDragOffset
		resizeOutputArea( x, nil, true )
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

-- Handle new frame events by calling layoutPanes if needed
local function onNewFrame()
	if layoutNeeded then
		layoutPanes()
		layoutNeeded = false
	end
end


--- Scene Methods ------------------------------------------------

-- Create the runView scene
function runView:create()
	local sceneGroup = self.view

	-- Background rect
	g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 

	-- Make the display items
	outputGroup = g.makeGroup( sceneGroup, 0, app.dyToolbar )
	rightBar = g.uiItem( display.newRect( sceneGroup, 0, outputGroup.y, 0, 0 ), 
						app.extraShade, app.borderShade )
	paneSplitRight = g.uiItem( display.newRect( sceneGroup, 0, rightBar.y, 
							dxyPaneSplit, 0 ), 
						app.toolbarShade, app.borderShade )
	paneSplitRight:addEventListener( "touch", onTouchPaneSplitRight )
	paneSplitConsole = g.uiItem( display.newRect( sceneGroup, 0, 0, 0, dxyPaneSplit ), 
						app.toolbarShade, app.borderShade )
	paneSplitConsole:addEventListener( "touch", onTouchPaneSplitConsole )
	lowerGroup = g.makeGroup( sceneGroup )
	console.create( lowerGroup, 0, 0, 0, 0 )
	varWatch.create( sceneGroup, 0, rightBar.y, 0, 0 )
	setOutputSize( maxOutputWidth(), maxOutputHeight() )

	-- Set appContext data related to the view
	local appContext = runtime.appContext
	appContext.outputGroup = outputGroup
	appContext.widthP = app.outputWidth
	appContext.heightP = app.outputHeight
	appContext.setClipSize = setOutputSize
	appContext.clearConsole = console.clear
	appContext.print = console.print
	appContext.println = console.println
	appContext.runtimeErr = showRuntimeError
	appContext.arrayAssigned = varWatch.arrayAssigned

	-- Install window resize handler
	Runtime:addEventListener( "resize", self )
	Runtime:addEventListener( "enterFrame", onNewFrame )
end

-- Prepare to show the runView scene
function runView:show( event )
	if event.phase == "did" then
		if g.runState == nil then
			-- Automatically run a new program
			runtime.run()
			setDefaultLayout()
			if app.showVarWatch then
				varWatch.startNewRun( varWatchWidthAndHeight() )
			end
		elseif app.showVarWatch ~= showVarWatchLast then
			-- Reset layout when app.showVarWatch changes
			if app.showVarWatch then
				setDefaultLayout()
			else
				layoutPanes()
			end
		end
		showVarWatchLast = app.showVarWatch
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

-- Window resize handler
function runView:resize()
	-- Get the new window size and calculate a new output height,
	-- trying to keep the outputRatio about the same.
	app.getWindowSize()
	resizeOutputArea( nil, maxOutputHeight() * outputRatio )
end

-- Toggle the coordinate grideLines on/off
function runView.toggleGrid()
	local gridOn = app.gridOn
	if gridOn then
		gridGroup.isVisible = false
	else
		makeGrid( app.outputWidth, app.outputHeight )
	end
	app.gridOn = not gridOn
end

-- Hide the coordinate grideLines
function runView.hideGrid()
	gridGroup.isVisible = false
	app.gridOn = false
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
runView:addEventListener( "create", runView )
runView:addEventListener( "show", runView )
runView:addEventListener( "hide", runView )
return runView


