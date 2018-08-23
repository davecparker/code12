-----------------------------------------------------------------------------------------
--
-- errView.lua
--
-- The view for displaying program errors for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local err = require( "err" )

-- The runView module and scene
local errView = composer.newScene()

-- UI metrics
local dxChar = app.consoleFontCharWidth
local dxExtra = 2   -- extra pixels of highlight horizontally
local dyDocsToolbar = 24       -- height of toolbar for the docsWebView

-- Display objects and groups
local errGroup                 -- display group for error display
local highlightGroup           -- display group for highlight rects
local lineNumRect              -- line number highlight
local refRect                  -- reference highlight
local sourceRect               -- main source highlight
local lineNumGroup             -- display group for line numbers
local sourceGroup              -- display group for source lines
local errText                  -- text object for error message
local docsToolbarGroup         -- display group for the docs toolbar
local moreInfoBtn              -- More Info button on docs toolbar
local backBtn                  -- Back button on docs toolbar
local forwardBtn               -- Forward button on docs toolbar
local docsWebView              -- web view for the documentation pane


--- Internal Functions ------------------------------------------------

-- Make and return a highlight rectangle, in the reference color if ref
local function makeHilightRect( x, y, width, height, ref )
	local r = g.uiItem( display.newRect( highlightGroup, x, y + 1, width, height + 1 ) )
	if ref then
		r:setFillColor( 1, 1, 0.6 )
	else
		r:setFillColor( 1, 1, 0 )
	end
	return r
end

-- Make the error display, or destroy and remake it if it exists
local function makeErrDisplay( sceneGroup )
	-- (Re)make group to hold all err display items
	if errGroup then
		errGroup:removeSelf()
	end
	errGroup = g.makeGroup( sceneGroup, 0, app.dyToolbar )
	local numSourceLines = 7

	-- Layout metrics
	local margin = app.margin
	local dxLineNum = math.round( dxChar * 6 )
	local xText = math.round( dxLineNum + dxChar )
	local dyLine = app.consoleFontHeight
	local dySource = numSourceLines * dyLine

	-- Make background rect for the source display
	g.uiItem( display.newRect( errGroup, 0, 0, app.width, dySource + margin * 2 ), 
			1, app.borderShade )

	-- Make the highlight rectangles
	highlightGroup = g.makeGroup( errGroup, xText, margin )
	local y = ((numSourceLines - 1) / 2) * dyLine
	lineNumRect = makeHilightRect( -dxChar, y, dxLineNum, dyLine )
	lineNumRect.anchorX = 1
	refRect = makeHilightRect( dxChar * 5, y, 
							dxChar * 6, dyLine, true )
	sourceRect = makeHilightRect( 0, y, dxChar * 4, dyLine )

	-- Make the lines numbers
	lineNumGroup = g.makeGroup( errGroup, 0, margin )
	for i = 1, numSourceLines do
		local t = display.newText{
			parent = lineNumGroup,
			text = "", 
			x = dxLineNum, 
			y = math.round( (i - 1) * dyLine ),
			font = app.consoleFont, 
			fontSize = app.consoleFontSize,
			align = "right",
		}
		t.anchorX = 1
		t.anchorY = 0
		t:setFillColor( 0.3 )
	end

	-- Make the source lines
	sourceGroup = g.makeGroup( errGroup, xText, margin )
	for i = 1, numSourceLines do
		g.uiBlack( display.newText{
			parent = sourceGroup,
			text = "", 
			x = 0, 
			y = math.round( (i - 1) * dyLine ),
			font = app.consoleFont, 
			fontSize = app.consoleFontSize,
			align = "left",
		} )
	end

	-- Make the error text
	errText = g.uiBlack( display.newText{
		parent = errGroup,
		text = "", 
		x = margin * 2, 
		y = sourceGroup.y + dySource + margin * 2,
		width = app.width - margin * 4,
		height = 0,
		font = native.systemFontBold, 
		fontSize = app.consoleFontSize + 2,
		align = "left",
	} )

	-- Position the docs toolbar
	-- Can't use errText.height: doesn't work when it wraps :(
	docsToolbarGroup.y = errGroup.y + errText.y + dyLine * 2 + margin
	moreInfoBtn.x = app.width - app.margin

	-- Position the docs web view
	docsWebView.y = docsToolbarGroup.y + dyDocsToolbar + 1
	docsWebView.width = app.width
	docsWebView.height = app.height - docsWebView.y - app.dyStatusBar - 1
end

-- Set the x, width, and height of a highlight rect given an err loc
local function setHighlightRectFromLoc( r, loc )
	-- There are 3 cases: multi-line, whole line, or partial line
	r.x = -dxExtra   -- default for whole and multi-line cases
	r.height = app.consoleFontHeight  -- default for single line cases
	local iLine = loc.iLine
	local sourceLines = app.sourceFile.strLines
	local numCols = 0
	if loc.iLineEnd and loc.iLineEnd > iLine then
		-- Multi-line. Make a rectangle bounding all the lines.
		r.height = 0
		for i = iLine, loc.iLineEnd do
			local _, cols = app.iCharToICol( sourceLines[i] or "", 1 )
			numCols = math.max( numCols, cols )
			r.height = r.height + app.consoleFontHeight
		end
	elseif loc.iCharStart then
		-- Partial line
		local iColStart, iColEnd = app.iCharToICol(
				sourceLines[iLine] or "", loc.iCharStart, loc.iCharEnd )
		r.x = (iColStart - 1) * dxChar - dxExtra
		numCols = iColEnd - iColStart + 1
	else
		-- Whole line
		local _, cols = app.iCharToICol( sourceLines[iLine] or "", 1 )
		numCols = cols
	end
	r.width = math.max( numCols, 1 ) * dxChar + dxExtra * 2
end

-- Show the error state
local function showError()
	-- Set the error text
	assert( err.rec )
	local errRecord = err.rec
	print( "\n" .. errRecord.strErr )
	errText.text = errRecord.strErr

	-- Load the source lines around the error
	local loc = errRecord.loc
	local iLine = loc.iLine   -- main error location
	local numLines = lineNumGroup.numChildren
	local before = (numLines - 1) / 2
	local lineNumFirst = iLine - before
	local lineNumLast = lineNumFirst + numLines
	local lineNum = lineNumFirst
	local sourceLines = app.sourceFile.strLines
	for i = 1, numLines do 
		if lineNum < 1 or lineNum > #sourceLines + 1 then
			lineNumGroup[i].text = ""
		else
			lineNumGroup[i].text = tostring( lineNum )
		end
		sourceGroup[i].text = app.detabLine( sourceLines[lineNum] or "" )
		lineNum = lineNum + 1
	end

	-- Size the line number highlight
	lineNumRect.width = (string.len( tostring( iLine ) ) + 1) * dxChar + dxExtra

	-- Position the main highlight.
	setHighlightRectFromLoc( sourceRect, loc )

	-- Position the ref highlight if it's showing  
	-- TODO: Make two line groups if necc
	refRect.isVisible = false
	local refLoc = errRecord.refLoc
	if refLoc then
		local iLineRef = refLoc.iLine
		if iLineRef >= lineNumFirst and iLineRef <= lineNumLast then
			setHighlightRectFromLoc( refRect, refLoc )
			refRect.y = (iLineRef - lineNumFirst) * app.consoleFontHeight
			refRect.isVisible = true
		end
	end
end

-- Display or re-display the current error
local function displayError( sceneGroup )
	makeErrDisplay( sceneGroup )
	showError()
end

-- Enable or disable the given toolbar button
local function enableBtn( btn, enable )
	if enable then
		btn:setFillColor( app.enabledShade )
	else
		btn:setFillColor( app.disabledShade )
	end
end

-- Update the docs toolbar
local function updateToolbar()
	if docsWebView.isVisible then
		moreInfoBtn:setLabel( "Close" )
		backBtn.isVisible = true
		forwardBtn.isVisible = true
		enableBtn( backBtn, docsWebView.canGoBack )
		enableBtn( forwardBtn, docsWebView.canGoForward )
	else
		moreInfoBtn:setLabel( "More Info." )
		backBtn.isVisible = false
		forwardBtn.isVisible = false
	end
end

-- Show the docs if show else hide them, and update the toolbar
local function showDocs( show )
	if show then
		docsWebView.isVisible = true

		-- TODO: Link to specific section if possible
		docsWebView:request( "API.html", system.ResourceDirectory )
	else
		docsWebView:stop()
		docsWebView.isVisible = false
	end
	updateToolbar()
end

-- Make the toolbar for the docs view
local function makeDocsToolbar( parent )
	-- Make the group
	docsToolbarGroup = g.makeGroup( parent )

	-- Background rect
	g.uiItem( display.newRect( docsToolbarGroup, 0, 0, 10000, dyDocsToolbar ),
			app.toolbarShade, app.borderShade )
	local yCenter = dyDocsToolbar / 2

	-- More Info button 
	moreInfoBtn = widget.newButton{
		x = app.width - app.margin, 
		y = yCenter,
		label = "More Info.",
		labelAlign = "right",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
		onRelease = function ()
						showDocs( not docsWebView.isVisible )  -- toggle visibility
					end
	}
	docsToolbarGroup:insert( moreInfoBtn )
	moreInfoBtn.anchorX = 1

	-- Back and forward buttons
	local size = dyDocsToolbar
	backBtn = display.newImageRect( docsToolbarGroup, "images/back.png", size, size )
	backBtn.x = app.margin + size / 2
	backBtn.y = yCenter
	backBtn.isVisible = false
	backBtn:addEventListener( "tap", 
		function() 
			docsWebView:back()
			updateToolbar()
		end )
	forwardBtn = display.newImageRect( docsToolbarGroup, "images/back.png", size, size )
	forwardBtn.rotation = 180
	forwardBtn.x = backBtn.x + size + app.margin
	forwardBtn.y = yCenter
	forwardBtn.isVisible = false
	forwardBtn:addEventListener( "tap", 
		function() 
			docsWebView:forward()
			updateToolbar()
		end )

	-- Set the initial state
	updateToolbar()
end


--- Scene Methods ------------------------------------------------

-- Create the errView scene
function errView:create()
	local sceneGroup = self.view

	-- Background rect
	g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 

	-- Web view for the docs (shown and positioned later) 
	docsWebView = native.newWebView( 0, 0, app.width, app.height )
	docsWebView.anchorX = 0
	docsWebView.anchorY = 0
	docsWebView.isVisible = false
	docsWebView:addEventListener( "urlRequest",
		function ()
			timer.performWithDelay( 100, updateToolbar )
		end )

	-- Make the toolbar for the docs view
	makeDocsToolbar( sceneGroup )

	-- Install resize handler
	Runtime:addEventListener( "resize", self )
end

-- Prepare to show the errView scene
function errView:show( event )
	if event.phase == "will" then
		displayError( self.view )
	end
end

-- Prepare to hide the errView scene
function errView:hide( event )
	if event.phase == "will" then
		showDocs( false )
	end
end

-- Destroy the errView scene
function errView:destroy()
	if docsWebView then
		docsWebView:removeSelf()
		docsWebView = nil
	end
end

-- Window resize handler
function errView:resize()
	-- Remake the error display, if any
	if err.rec then
		displayError( self.view )
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
errView:addEventListener( "create", errView )
errView:addEventListener( "show", errView )
errView:addEventListener( "hide", errView )
errView:addEventListener( "destroy", errView )
return errView


