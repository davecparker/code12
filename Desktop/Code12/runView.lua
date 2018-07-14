-----------------------------------------------------------------------------------------
--
-- runView.lua
--
-- The view for a running program for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local err = require( "err" )
local console = require( "console" )


-- The runView module
local runView = {}


-- UI metrics
local margin = app.margin
local dyPaneSplit = 10
local defaultConsoleLines = 10

-- Display objects and groups
local outputGroup              -- display group for program output area
local rightBar                 -- clipping bar to the right of the output area
local paneSplit                -- pane split area
local lowerGroup               -- display area below the pane split
local gameGroup                -- display group for game output
local errGroup                 -- display group for error display

-- Program state
local minConsoleHeight         -- min height of the console window (from pane split)
local paneDragOffset           -- when dragging the pane split
local appContext               -- app context for the running program


--- Internal Functions ------------------------------------------------

-- Return the available height for the output area
local function outputAreaHeight()
	return app.height - app.dyToolbar - app.dyStatusBar - minConsoleHeight - dyPaneSplit
end

-- Make and return a highlight rectangle, in the reference color if ref
local function makeHilightRect( x, y, width, height, ref )
	local r = g.uiItem( display.newRect( errGroup.highlightGroup, x, y, width, height ) )
	if ref then
		r:setFillColor( 1, 1, 0.6 )
	else
		r:setFillColor( 1, 1, 0 )
	end
	return r
end

-- Position the display panes
local function layoutPanes()
	-- Determine size of the top area (game or error output)
	local width = app.outputWidth
	local height = app.outputHeight
	if err.hasErr() then
		width = app.width
		height = app.consoleFontHeight * 12   -- TODO
	end

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

	-- Hide console if there is an error display.
	console.group.isVisible = not err.hasErr()
end

-- Remove the error display if it exists
local function removeErrorDisplay()
	if errGroup then
		errGroup:removeSelf()
		errGroup = nil
	end
	layoutPanes()
end

-- Make the error display, or destroy and remake it if it exists
local function makeErrDisplay()
	-- Make group to hold all err display items
	removeErrorDisplay()
	errGroup = g.makeGroup( outputGroup )
	local numSourceLines = 7

	-- Layout metrics
	local dxChar = app.consoleFontCharWidth
	local dxLineNum = math.round( dxChar * 6 )
	local xText = math.round( dxLineNum + dxChar )
	local dyLine = app.consoleFontHeight
	local dySource = numSourceLines * dyLine

	-- Make background rect for the source display
	g.uiItem( display.newRect( errGroup, 0, 0, app.width, dySource + margin ), 1, app.borderShade )

	-- Make the highlight rectangles
	local highlightGroup = g.makeGroup( errGroup, xText, margin )
	errGroup.highlightGroup = highlightGroup
	local y = ((numSourceLines - 1) / 2) * dyLine
	errGroup.lineNumRect = makeHilightRect( -xText, y, dxLineNum, dyLine )
	errGroup.refRect = makeHilightRect( dxChar * 5, y, 
							dxChar * 6, dyLine, true )
	errGroup.sourceRect = makeHilightRect( 0, y, dxChar * 4, dyLine )

	-- Make the lines numbers
	local lineNumGroup = g.makeGroup( errGroup, 0, margin )
	errGroup.lineNumGroup = lineNumGroup
	for i = 1, numSourceLines do
		local t = display.newText{
			parent = lineNumGroup,
			text = "", 
			x = dxLineNum, 
			y = (i - 1) * dyLine,
			font = app.consoleFont, 
			fontSize = app.consoleFontSize,
			align = "right",
		}
		t.anchorX = 1
		t.anchorY = 0
		t:setFillColor( 0.3 )
	end

	-- Make the source lines
	local sourceGroup = g.makeGroup( errGroup, xText, margin )
	errGroup.sourceGroup = sourceGroup
	for i = 1, numSourceLines do
		g.uiBlack( display.newText{
			parent = sourceGroup,
			text = "", 
			x = 0, 
			y = (i - 1) * dyLine,
			font = app.consoleFont, 
			fontSize = app.consoleFontSize,
			align = "left",
		} )
	end

	-- Make the error text
	errGroup.errText = g.uiBlack( display.newText{
		parent = errGroup,
		text = "", 
		x = margin * 2, 
		y = dySource + margin * 2,
		width = app.width - xText - 20,   -- wrap near end of window
		font = native.systemFontBold, 
		fontSize = app.consoleFontSize + 2,
		align = "left",
	} )
end



-- Show a runtime error with the given line number and message
local function showRuntimeError( lineNum, message )
	err.setErrLineNum( lineNum, "Runtime error: " .. message )
	runView.showError()
end

-- Runtime callback to set the output size being used
local function setClipSize( widthP, heightP )
	app.outputWidth = math.floor( widthP )
	app.outputHeight = math.floor( heightP )
	layoutPanes()
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
		runView.resize()
	end
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end
	return true
end


--- Module Functions ------------------------------------------------

-- Show the error state
function runView.showError()
	-- Make sure there is an error to show
	if not err.hasErr() then
		print( "*** Missing error state for failed parse")
		return
	end

	-- Make the error display elements
	makeErrDisplay()
	layoutPanes()

	-- Set the error text
	local errRecord = err.getErrRecord()
	print( "\n" .. errRecord.strErr )
	errGroup.errText.text = errRecord.strErr

	-- Load the source lines around the error
	local iLine = errRecord.loc.first.iLine   -- main error location
	local sourceGroup = errGroup.sourceGroup
	local lineNumGroup = errGroup.lineNumGroup
	local numLines = lineNumGroup.numChildren
	local before = (numLines - 1) / 2
	local lineNumFirst = iLine - before
	local lineNumLast = lineNumFirst + numLines
	local lineNum = lineNumFirst
	local sourceLines = app.sourceFile.strLines
	for i = 1, numLines do 
		if lineNum < 1 or lineNum > #sourceLines then
			lineNumGroup[i].text = ""
			sourceGroup[i].text = ""
		else
			lineNumGroup[i].text = tostring( lineNum )
			sourceGroup[i].text = sourceLines[lineNum]
		end
		lineNum = lineNum + 1
	end

	-- Position the main highlight
	local dxChar = app.consoleFontCharWidth
	local dxExtra = 2   -- extra pixels of highlight horizontally
	local r = errGroup.sourceRect
	local loc = errRecord.loc
	r.x = (loc.first.iChar - 1) * dxChar - dxExtra
	r.height = app.consoleFontHeight
	local numChars = string.len( sourceLines[loc.first.iLine] or "" )
	if loc.last ~= nil then  -- otherwise whole line as set above
		if loc.first.iLine == loc.last.iLine then
			-- Portion of a single line
			numChars = loc.last.iChar - loc.first.iChar + 1
		else
			-- Multi-line. Make a rectangle bounding it all. 
			-- TODO: Is this good enough or do we need multiple rects?
			r.x = 0
			for iLineNext = loc.first.iLine + 1, loc.last.iLine do
				local numCharsNext = string.len( sourceLines[iLineNext] or "" )
				if numCharsNext > numChars then
					numChars = numCharsNext
				end
				r.height = r.height + app.consoleFontHeight
			end
		end
	end
	r.width = numChars * dxChar + dxExtra * 2

	-- Position the ref highlight if it's showing  TODO: two line groups if necc
	r = errGroup.refRect
	r.isVisible = false
	if errRecord.refLoc then
		local iLineRef = errRecord.refLoc.first.iLine
		if iLineRef >= lineNumFirst and iLineRef <= lineNumLast then
			r.y = (iLineRef - lineNumFirst) * app.consoleFontHeight
			r.x = (errRecord.refLoc.first.iChar - 1) * dxChar - dxExtra
			numChars = errRecord.refLoc.last.iChar - errRecord.refLoc.first.iChar + 1
			r.width = numChars * dxChar + dxExtra * 2
			r.isVisible = true
		end
	end
end

-- Show the game output
function runView.showOutput()
	gameGroup.isVisible = true
end

-- Prepare for a new run of the user program
function runView.initNewProgram()
	console.clear()
	if gameGroup then
		gameGroup:removeSelf()
	end
	gameGroup = g.makeGroup( outputGroup )
	gameGroup.isVisible = false
	removeErrorDisplay()
end

-- Resize the run view
function runView.resize()
	-- Remake the error display, if any
	if err.hasErr() then
		runView.showError()
	end

	-- Calculate the output space and tell the runtime we resized. 
	-- This will result in a call to ct.setHeight() internally, 
	-- which will then call us back at setClipSize().
	appContext.widthP = math.max( app.width, 1 )
	appContext.heightP = math.max( outputAreaHeight(), 1 )
	if g.onResize then
		g.onResize()
	end
end

-- Create the run view scene
function runView.create()
	-- Init and measure the console area
	console.init()
	minConsoleHeight = app.consoleFontHeight * defaultConsoleLines
	app.outputWidth = app.width
	app.outputHeight = outputAreaHeight()

	-- Make the main output group
	outputGroup = g.makeGroup(nil, 0, app.dyToolbar)

	-- Main display areas
	rightBar = g.uiItem( display.newRect( 0, app.dyToolbar, 0, 0 ), 
						app.extraShade, app.borderShade )
	paneSplit = g.uiItem( display.newRect( 0, 0, 0, dyPaneSplit ), 
						app.toolbarShade, app.borderShade )
	paneSplit:addEventListener( "touch", onTouchPaneSplit )
	lowerGroup = g.makeGroup()
	console.create( lowerGroup, 0, 0, 0, 0 )
	layoutPanes()

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

------------------------------------------------------------------------------

return runView


