-----------------------------------------------------------------------------------------
--
-- errView.lua
--
-- The view for displaying program errors for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------

-- Corona modules
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local source = require( "source" )
local err = require( "err" )


-- The errView module and scene
local errView = composer.newScene()

-- UI metrics
local dxChar = app.consoleFontCharWidth
local dxExtra = 2   -- extra pixels of highlight horizontally
local dyDocsToolbar = 24       -- height of toolbar for the docsWebView
local dyDocsToolbarIcons = 16  -- height of back and forward button icons
local minSourceLines = 7       -- show at least this many source lines
local margin = app.margin
local dyLine = app.consoleFontHeight

-- Display objects and groups
local errGroup                 -- overall display group for error display
local mainCodeGroup            -- display group for main/only code display
local refCodeGroup             -- display group for ref code display if separate (TODO)
local errText                  -- text object for error message
local docsToolbarGroup         -- display group for the docs toolbar
local errCountText             -- text object for error count
local backBtn                  -- Back button on docs toolbar
local forwardBtn               -- Forward button on docs toolbar
local docsWebView              -- web view for the documentation pane

-- Error state
local errLineNumbers           -- array of line numbers with errors
local iError                   -- index of current error in errLineNumbers
local errRec                   -- error record for current error being shown


--- Internal Functions ------------------------------------------------

-- Make and return a highlight rectangle in group, in the reference color if ref
local function makeHilightRect( group, x, y, width, height, ref )
	local r = g.uiItem( display.newRect( group, x, y + 1, width, height + 1 ) )
	if ref then
		r:setFillColor( 1, 1, 0.6 )
	else
		r:setFillColor( 1, 1, 0 )
	end
	return r
end

-- Enable or disable the given toolbar button
local function enableBtn( btn, enable )
	if enable then
		btn:setFillColor( unpack( app.buttonColor ) )
	else
		btn:setFillColor( app.disabledShade )
	end
end

-- Update the docs toolbar
local function updateDocsToolbar()
	if docsWebView and docsWebView.isVisible then
		backBtn.isVisible = true
		forwardBtn.isVisible = true
		enableBtn( backBtn, docsWebView.canGoBack )
		enableBtn( forwardBtn, docsWebView.canGoForward )
	else
		backBtn.isVisible = false
		forwardBtn.isVisible = false
	end
end

-- Make and return a display group inside errGroup for a code display 
-- of numSourceLines lines, containing the following sub-fields:
--    highlightGroup:  display group for highlight rects
--    lineNumRect:     line number highlight
--    refRect:         second reference highlight rect if any
--    sourceRect:      main source highlight rect
--    lineNumGroup:    display group for line numbers
--    sourceGroup:     display group for source lines
--    totalHeight:     total height of the code display
local function makeCodeGroup( numSourceLines )
	-- Make the overall code group to return
	local cg = g.makeGroup( errGroup )

	-- Layout metrics
	local dxLineNum = math.round( dxChar * 6 )
	local xText = math.round( dxLineNum + dxChar )

	-- Compute total height and make framed background rect
	cg.totalHeight = numSourceLines * dyLine + margin * 2
	g.uiItem( display.newRect( cg, 0, 0, app.width, cg.totalHeight ), 1, app.borderShade )

	-- Make the highlight rectangles
	cg.highlightGroup = g.makeGroup( cg, xText, margin - app.consoleFontYOffset )
	local y = ((numSourceLines - 1) / 2) * dyLine
	cg.lineNumRect = makeHilightRect( cg.highlightGroup, -dxChar, y, dxLineNum, dyLine )
	cg.lineNumRect.anchorX = 1
	cg.refRect = makeHilightRect( cg.highlightGroup, dxChar * 5, y, 
							dxChar * 6, dyLine, true )
	cg.sourceRect = makeHilightRect( cg.highlightGroup, 0, y, dxChar * 4, dyLine )

	-- Make the line numbers
	cg.lineNumGroup = g.makeGroup( cg, 0, margin )
	for i = 1, numSourceLines do
		local t = display.newText{
			parent = cg.lineNumGroup,
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
	cg.sourceGroup = g.makeGroup( cg, xText, margin )
	for i = 1, numSourceLines do
		g.uiBlack( display.newText{
			parent = cg.sourceGroup,
			text = "", 
			x = 0, 
			y = math.round( (i - 1) * dyLine ),
			font = app.consoleFont, 
			fontSize = app.consoleFontSize,
			align = "left",
		} )
	end

	-- Return the code group
	return cg
end

-- Listener function for the docs native web view
local function webViewListener()
	-- Update Back and Forward buttons after link is fully resolved
	timer.performWithDelay( 100, updateDocsToolbar )
end

-- Make the error display, or destroy and remake it if it exists
local function makeErrDisplay( sceneGroup )
	-- (Re)make group to hold all err display items
	if errGroup then
		errGroup:removeSelf()
	end
	errGroup = g.makeGroup( sceneGroup, 0, app.dyToolbar )
	local y

	-- Make two code groups if there is a refLoc and it's not close enough
	-- to the main loc to show in the same code group.
	local loc = errRec.loc
	local refLoc = errRec.refLoc
	if refLoc == nil or math.abs( refLoc.iLine - loc.iLine ) <= minSourceLines then
		-- Make just one group, but big enough to show the refLoc if any
		local numLines = minSourceLines
		if refLoc then
			local dLines = math.abs( refLoc.iLine - loc.iLine )
			numLines = math.max( minSourceLines, dLines * 2 + 1 )
		end
		mainCodeGroup = makeCodeGroup( numLines )
		y = mainCodeGroup.y + mainCodeGroup.totalHeight
		refCodeGroup = nil
	else
		-- Make two code groups
		mainCodeGroup = makeCodeGroup( minSourceLines )
		refCodeGroup = makeCodeGroup( minSourceLines )
		-- Position them in the right order for their line numbers
		if refLoc.iLine < loc.iLine then
			mainCodeGroup.y = refCodeGroup.y + refCodeGroup.totalHeight
			y = mainCodeGroup.y + mainCodeGroup.totalHeight
		else
			refCodeGroup.y = mainCodeGroup.y + mainCodeGroup.totalHeight
			y = refCodeGroup.y + refCodeGroup.totalHeight
		end
	end

	-- Make the error text
	errText = g.uiItem( display.newText{
		parent = errGroup,
		text = "", 
		x = margin, 
		y = y + margin,
		width = app.width - margin * 4,
		height = 0,
		font = native.systemFontBold, 
		fontSize = app.consoleFontSize + 2,
		align = "left",
	} )
	errText:setFillColor( 0.9, 0, 0.1 )   -- slightly darkened red

	-- Position the docs toolbar
	-- Can't use errText.height: doesn't work when it wraps :(
	docsToolbarGroup.y = errGroup.y + errText.y + dyLine * 2 + margin

	-- Create and/or position the docs web view
	if docsWebView == nil then
		docsWebView = native.newWebView( 0, 0, app.width, app.height )
		docsWebView.anchorX = 0
		docsWebView.anchorY = 0
		docsWebView.isVisible = false
		docsWebView:addEventListener( "urlRequest", webViewListener )
	end
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
	local numCols = 0
	if loc.iLineEnd and loc.iLineEnd > iLine then
		-- Multi-line. Make a rectangle bounding all the lines.
		r.height = 0
		for i = iLine, loc.iLineEnd do
			local _, cols = app.iCharToICol( source.lines[i].str, 1 )
			numCols = math.max( numCols, cols )
			r.height = r.height + app.consoleFontHeight
		end
	elseif loc.iCharStart then
		-- Partial line
		local iColStart, iColEnd = app.iCharToICol(
				source.lines[iLine].str, loc.iCharStart, loc.iCharEnd )
		r.x = (iColStart - 1) * dxChar - dxExtra
		numCols = iColEnd - iColStart + 1
	else
		-- Whole line
		local _, cols = app.iCharToICol( source.lines[iLine].str, 1 )
		numCols = cols
	end
	r.width = math.max( numCols, 1 ) * dxChar + dxExtra * 2
end

-- Load source content around loc.iLine into the code group cg,
-- set the main highlight using loc, and if refLoc then set the ref
-- highlight using refLoc.
local function loadCodeGroup( cg, loc, refLoc )
	-- Load the source lines
	local iLine = loc.iLine
	local numLines = cg.lineNumGroup.numChildren
	local before = (numLines - 1) / 2
	local lineNumFirst = iLine - before
	local lineNumLast = lineNumFirst + numLines
	local lineNum = lineNumFirst
	for i = 1, numLines do 
		if lineNum < 1 or lineNum > source.numLines + 1 then
			cg.lineNumGroup[i].text = ""
			cg.sourceGroup[i].text = ""
		else
			cg.lineNumGroup[i].text = tostring( lineNum )
			cg.sourceGroup[i].text = app.detabLine( source.lines[lineNum].str )
		end
		lineNum = lineNum + 1
	end

	-- Size the line number highlight
	cg.lineNumRect.width = (string.len( tostring( loc.iLine ) ) + 1) * dxChar + dxExtra

	-- Position the main highlight.
	setHighlightRectFromLoc( cg.sourceRect, loc )

	-- Position the ref highlight if given  
	local refRect = cg.refRect
	if refLoc then
		local iLineRef = refLoc.iLine
		if iLineRef >= lineNumFirst and iLineRef <= lineNumLast then
			setHighlightRectFromLoc( refRect, refLoc )
			refRect.y = (iLineRef - lineNumFirst) * app.consoleFontHeight
			refRect.isVisible = true
		end
	else
		refRect.isVisible = false
	end
end

-- Display or re-display the current error
local function displayError( sceneGroup )
	-- Re-make the error display 
	makeErrDisplay( sceneGroup )

	-- Set the error text
	print( string.format( "Line %d: %s", errRec.loc.iLine, errRec.strErr ) )
	local text = errRec.strErr
	if errRec.strNote then
		if text == "" then
			text = errRec.strNote
		else
			text = text .. "\n(" .. errRec.strNote .. ")"
		end
	end
	errText.text = text

	-- Show the error index and count if multi
	if app.oneErrOnly or #errLineNumbers < 2 then
		errCountText.text = ""
	else
		errCountText.text = iError .. " of " .. #errLineNumbers
	end

	-- Are we using two code groups or just one?
	if refCodeGroup then
		loadCodeGroup( mainCodeGroup, errRec.loc )
		loadCodeGroup( refCodeGroup, errRec.refLoc )
	else
		loadCodeGroup( mainCodeGroup, errRec.loc, errRec.refLoc )
	end

	-- Show documentation link if any
	if errRec.docLink then
		docsWebView.isVisible = true
		docsWebView:request( app.webHelpDir .. errRec.docLink )
	else
		docsWebView:stop()
		docsWebView.isVisible = false
	end
	updateDocsToolbar()
end

-- Make the toolbar for the docs view
local function makeDocsToolbar( parent )
	-- Make the group
	docsToolbarGroup = g.makeGroup( parent )

	-- Background rect
	g.uiItem( display.newRect( docsToolbarGroup, 0, 0, 10000, dyDocsToolbar ),
			app.toolbarShade, app.borderShade )
	local yCenter = dyDocsToolbar / 2

	-- Error count text
	errCountText = display.newText( docsToolbarGroup, "",
			app.width / 2, yCenter, native.systemFont, app.fontSizeUI )
	errCountText:setFillColor( 0 )

	-- Back and forward buttons
	local size = dyDocsToolbarIcons
	backBtn = display.newImageRect( docsToolbarGroup, "images/back.png", size, size )
	backBtn.x = margin + size / 2
	backBtn.y = yCenter
	backBtn.isVisible = false
	backBtn:addEventListener( "tap", 
		function() 
			docsWebView:back()
			updateDocsToolbar()
		end )
	forwardBtn = display.newImageRect( docsToolbarGroup, "images/back.png", size, size )
	forwardBtn.rotation = 180
	forwardBtn.x = backBtn.x + size + margin
	forwardBtn.y = yCenter
	forwardBtn.isVisible = false
	forwardBtn:addEventListener( "tap", 
		function() 
			docsWebView:forward()
			updateDocsToolbar()
		end )

	-- Set the initial state
	updateDocsToolbar()
end

-- Handle key events in the view
local function onKeyEvent( event )
	-- Keys change the error number if multi-error
	if app.oneErrOnly then
		return false
	end 
	if event.phase == "down" then
		local keyName = event.keyName
		local iErrorNew
		if keyName == "pageUp" then
			iErrorNew = iError - 1
		elseif keyName == "pageDown" then
			iErrorNew = iError + 1
		elseif keyName == "home" then
			iErrorNew = 1
		elseif keyName == "end" then
			iErrorNew = #errLineNumbers
		end

		if iErrorNew and iErrorNew >= 1 and iErrorNew <= #errLineNumbers then
			iError = iErrorNew
			errRec = err.errRecForLine( errLineNumbers[iError] )
			displayError( errView.view )
			return true
		end
	end
	return false
end


--- Scene Methods ------------------------------------------------

-- Create the errView scene
function errView:create()
	local sceneGroup = self.view

	-- Background rect
	g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 

	-- Make the toolbar for the docs view
	makeDocsToolbar( sceneGroup )
end

-- Prepare to show the errView scene
function errView:show( event )
	if event.phase == "will" then
		-- Get the error record for the (first) error
		assert( err.hasErr() )
		errLineNumbers = err.lineNumbersWithErrors()
		assert( #errLineNumbers > 0 )
		local iLineErr = errLineNumbers[1]
		print( string.format( "\n%d error(s) starting at line %d", 
					#errLineNumbers, iLineErr ) )
		iError = 1
		errRec = err.errRecForLine( iLineErr )

		-- Display the error
		displayError( self.view )
	elseif event.phase == "did" then
		-- Install event listeners
		Runtime:addEventListener( "key", onKeyEvent )
		Runtime:addEventListener( "resize", self )
	end
end

-- Prepare to hide the errView scene
function errView:hide( event )
	if event.phase == "will" then
		-- Remove event listeners
		Runtime:removeEventListener( "key", onKeyEvent )
		Runtime:removeEventListener( "resize", self )
	elseif event.phase == "did" then
		-- Remove the docsWebView because it's a floating native view
		if docsWebView then
			docsWebView:stop()
			docsWebView:removeSelf()
			docsWebView = nil
		end
	end
end

-- Window resize handler
function errView:resize()
	-- Remake the error display, if any
	if err.hasErr() then
		displayError( self.view )
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
errView:addEventListener( "create", errView )
errView:addEventListener( "show", errView )
errView:addEventListener( "hide", errView )
return errView


