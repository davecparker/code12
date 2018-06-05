-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Main program for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules and plugins
local widget = require( "widget" )
local lfs = require( "lfs" )
local fileDialogs = require( "plugin.tinyfiledialogs" )

-- Code12 modules
local parseJava = require( "parseJava" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )
local err = require( "err" )


-- UI metrics
local margin = 10        -- generic margin to leave between many UI items
local dyToolbar = 40
local dyStatusBar = 30
local fontSizeUI = 12
local toolbarShade = 0.9
local borderShade = 0.5

-- Misc constants
local numSyntaxLevels = 12

-- Program state
local syntaxLevel = numSyntaxLevels   -- programming syntax level

-- The user source file
local sourceFile = {
	path = nil,              -- full pathname to the file
	timeLoaded = 0,          -- time this file was loaded
	timeModLast = 0,         -- last modification time or 0 if never
	strLines = {},           -- array of source code lines when read
}

-- Force the initial file to the standard test file (for faster repeated testing)
sourceFile.path = "../UserCode.java"
sourceFile.timeLoaded = os.time()

-- UI elements and state
local ui = {
	isMac = false,         -- true if running on Mac OS (else Windows, for now)
	width = 0,             -- window width
	height = 0,            -- window height
	background = nil,      -- white background rect
	toolbarGroup = nil,    -- display group for toolbar
	statusBarGroup = nil,  -- display group for status bar
	outputGroup = nil,     -- display group for program output area
	gameGroup = nil,       -- display group for game output
	errGroup = nil,        -- display group for error display
	dyErrLine = 0,         -- line spacing for error lines
	dxErrChar = 0,         -- char width for text in error displays
}

-- The global state tables that the generated Lua code can access (Lua globals)
ct = {}        -- API functions
this = {}      -- generated code uses this.var
_fn = {}       -- generated code uses _fn.foo()


--- API Functions ------------------------------------------------

-- Temp
function ct.circle( x, y, d )
	local c = display.newCircle( ui.gameGroup, x, y, d / 2 )
	c:setFillColor( 1, 0, 0 )
	return c 
end

function ct.intDiv( n, d )
	return math.floor( n / d )
end


--- Utility Functions ------------------------------------------------

-- Create and return a display group in parent, optionally located at x, y
local function makeGroup( parent, x, y )
	local g = display.newGroup()
	if parent then
		parent:insert( g )
	end
	g.x = x or 0
	g.y = y or 0
	return g
end

-- Change the given display object to be top-left anchored 
-- with the given grayscale shades for the fill (default black) 
-- and stroke (default none)
local function uiItem( obj, fillShade, lineShade )
	if obj then
		obj.anchorX = 0
		obj.anchorY = 0
		obj:setFillColor( fillShade or 0 ) 
		if lineShade then
			obj.strokeWidth = 1
			obj:setStrokeColor( lineShade )
		end
	end
	return obj
end

-- Change the given display object to be top-left anchored and white
local function uiWhite( obj )
	return uiItem( obj, 1 )
end

-- Change the given display object to be top-left anchored and black
local function uiBlack( obj )
	return uiItem( obj, 0 )
end


--- Internal Functions ------------------------------------------------

-- Update status bar based on data in sourceFile
local function updateStatusBar()
	if sourceFile.path then
		-- Get just the filename with extension from the path
		local dir, fileAndExt, ext = string.match( sourceFile.path, "(.-)([^\\/]-%.?([^%.\\/]*))$" )

		-- Get the update time to display
		local updateStr = "Never"
		if sourceFile.timeModLast > sourceFile.timeLoaded then
			local secs = os.time() - sourceFile.timeModLast
			if secs < 5 then
				updateStr = "Just now"
			elseif secs < 60 then
				updateStr = "Less than a minute ago"
			elseif secs < 120 then
				updateStr = "About a minute ago"
			else
				local min = math.floor(secs / 60)
				if min > 60 then
					updateStr = "Over an hour ago"
				else
					updateStr = min .. " minutes ago"
				end
			end
		end

		-- Update the status bar UI
		ui.statusBarGroup.message.text = fileAndExt .. " -- Updated: " .. updateStr
		ui.statusBarGroup.openFileBtn.isVisible = true
	else
		ui.statusBarGroup.openFileBtn.isVisible = false
	end
end

-- Run the given lua code string dynamically, and then call the contained start function.
local function runLuaCode( luaCode )
	-- Load the code dynamically and execute it
	local codeFunction = loadstring( luaCode )
 	if type(codeFunction) == "function" then
 		codeFunction()

 		-- Run the start function if defined
 		if type(_fn.start) == "function" then
 			_fn.start()
 		end

 		-- Show the game output
		ui.gameGroup.isVisible = true
 	else
 	 	print( "*** Lua code failed to load" )
 	end
end

-- Return a detabbed version of str using the given tabWidth
local function detabString( str )
	return string.gsub( str, "\t", "    " )   -- TODO (temp)
end

-- Read the sourceFile and store all of its source lines.
-- Return true if success.
local function readSourceFile()
	local file = io.open( sourceFile.path, "r" )
	if file then
		sourceFile.strLines = {}   -- delete previous contents if any
		local lineNum = 1
		repeat
			local s = file:read( "*l" )  -- read a line
			if s == nil then 
				break  -- end of file
			end
			sourceFile.strLines[lineNum] = detabString(s)
			lineNum = lineNum + 1
		until false -- breaks internally
		io.close( file )
		return true
	end
	return false
end

-- Show dialog to choose the user source code file
local function chooseFile()
	local result = fileDialogs.openFileDialog{
		title = "Choose Java Source Code File",
		-- filter_patterns = { "*.java" },
		-- filter_description = "Java Source Code",
		allow_multiple_selects = false,
	}
	if type(result) == "string" then   -- returns false if cancelled
		sourceFile.path = result
		sourceFile.timeLoaded = os.time()
		sourceFile.timeModLast = 0
	end
end

-- Open the source file in the system default text editor for its file type
local function openFileInEditor()
	if sourceFile.path then
		if ui.isMac then
			os.execute( "open \"" .. sourceFile.path .. "\"" )
		else
			os.execute( "start \"" .. sourceFile.path .. "\"" )
		end
	end
end

-- Get device metrics and store them in the global table
local function getDeviceMetrics()
	ui.width = display.actualContentWidth
	ui.height = display.actualContentHeight
end

-- Make the status bar UI
local function makeStatusBar()
	local group = makeGroup( nil, 0, ui.height - dyStatusBar )
	ui.statusBarGroup = group

	group.background = uiItem( display.newRect( group, 0, 0, ui.width, dyStatusBar ),
							toolbarShade, borderShade )

	local yCenter = dyStatusBar / 2
	local btn = widget.newButton{
		x = margin, 
		y = yCenter,
		onRelease = chooseFile,
		label = "Choose File",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	group:insert( btn )
	btn.anchorX = 0
	group.chooseFileBtn = btn

	group.message = display.newText( group, "", ui.width / 2, yCenter, 
									native.systemFont, fontSizeUI )
	group.message:setFillColor( 0 )

	btn = widget.newButton{
		x = ui.width,
		y = yCenter,
		onRelease = openFileInEditor,
		label = "Open in Editor",
		labelAlign = "right",
		labelXOffset = -margin,
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	group:insert( btn )
	btn.anchorX = 1
	group.openFileBtn = btn

	updateStatusBar()
end

-- Make and return a highlight rectangle, in the reference color if ref
local function makeHilightRect( x, y, width, height, ref )
	local r = uiItem( display.newRect( ui.errGroup.highlightGroup, x, y, width, height ) )
	if ref then
		r:setFillColor( 1, 1, 0.6 )
	else
		r:setFillColor( 1, 1, 0 )
	end
	return r
end

-- Remove the error display if it exists
local function removeErrorDisplay()
	if ui.errGroup then
		ui.errGroup:removeSelf()
		ui.errGroup = nil
	end
end

-- Make the error display, or destroy and remake it if it exists
local function makeErrDisplay()
	-- Make group to hold all err display items
	removeErrorDisplay()
	local group = makeGroup( ui.outputGroup )
	ui.errGroup = group
	local numSourceLines = 7

	-- Get font metrics
	local fontName = ((ui.isMac and "Consolas") or "Courier")
	local fontSize = 16
	local fontMetrics = graphics.getFontMetrics( fontName, fontSize )
	local dyLine = fontMetrics.height + fontMetrics.leading
	local strTest = "1234567890"
	local temp = display.newText( strTest, 0, 0, fontName, fontSize )
	ui.dyErrLine = dyLine
	ui.dxErrChar = temp.contentWidth / string.len( strTest )
	temp:removeSelf()

	-- Layout metrics
	local dxLineNum = math.round( ui.dxErrChar * 6 )
	local xText = math.round( dxLineNum + ui.dxErrChar )
	local dySource = numSourceLines * dyLine

	-- Make background rect for the source display
	uiItem( display.newRect( group, 0, 0, ui.width, dySource + margin ), 1, borderShade )

	-- Make the highlight rectangles
	local highlightGroup = makeGroup( group, xText, margin )
	group.highlightGroup = highlightGroup
	local y = ((numSourceLines - 1) / 2) * dyLine
	group.lineNumRect = makeHilightRect( -xText, y, dxLineNum, dyLine )
	group.sourceRect = makeHilightRect( 0, y, ui.dxErrChar * 4, dyLine )
	group.refRect = makeHilightRect( ui.dxErrChar * 5, y, 
							ui.dxErrChar * 6, dyLine, true )

	-- Make the lines numbers
	local lineNumGroup = makeGroup( group, 0, margin )
	group.lineNumGroup = lineNumGroup
	for i = 1, numSourceLines do
		local t = display.newText{
			parent = lineNumGroup,
			text = "", 
			x = dxLineNum, 
			y = (i - 1) * dyLine,
			font = fontName, 
			fontSize = fontSize,
			align = "right",
		}
		t.anchorX = 1
		t.anchorY = 0
		t:setFillColor( 0.3 )
	end

	-- Make the source lines
	local sourceGroup = makeGroup( group, xText, margin )
	group.sourceGroup = sourceGroup
	for i = 1, numSourceLines do
		uiBlack( display.newText{
			parent = sourceGroup,
			text = "", 
			x = 0, 
			y = (i - 1) * dyLine,
			font = fontName, 
			fontSize = fontSize,
			align = "left",
		} )
	end

	-- Make the error text
	group.errText = uiBlack( display.newText{
		parent = group,
		text = "", 
		x = margin * 2, 
		y = dySource + margin * 2,
		width = ui.width - xText - 20,   -- wrap near end of window
		font = native.systemFontBold, 
		fontSize = fontSize,
		align = "left",
	} )
end

-- Show the error state
local function showError()
	-- Make sure there is an error to show
	if not err.hasErr() then
		print( "*** Missing error state for failed parse")
		return
	end

	-- Make the error display elements
	makeErrDisplay()

	-- Set the error text
	local errRecord = err.getErrRecord()
	print( "\n" .. errRecord.strErr )
	local strDisplay = errRecord.strErr
	if errRecord.strLevel then
		print( errRecord.strLevel )
		strDisplay = strDisplay .. "\n" .. errRecord.strLevel
	end
	ui.errGroup.errText.text = strDisplay

	-- Load the source lines around the error
	local iLine = errRecord.loc.first.iLine   -- main error location
	local sourceGroup = ui.errGroup.sourceGroup
	local lineNumGroup = ui.errGroup.lineNumGroup
	local numLines = lineNumGroup.numChildren
	local before = (numLines - 1) / 2
	local lineNumFirst = iLine - before
	local lineNumLast = lineNumFirst + numLines
	local lineNum = lineNumFirst
	for i = 1, numLines do 
		if lineNum < 1 or lineNum > #sourceFile.strLines then
			lineNumGroup[i].text = ""
			sourceGroup[i].text = ""
		else
			lineNumGroup[i].text = tostring( lineNum )
			sourceGroup[i].text = sourceFile.strLines[lineNum]
		end
		lineNum = lineNum + 1
	end

	-- Position the main highlight  TODO: handle multi-line
	local dxExtra = 2   -- extra pixels of highlight horizontally
	local r = ui.errGroup.sourceRect
	r.x = (errRecord.loc.first.iChar - 1) * ui.dxErrChar - dxExtra
	local numChars = errRecord.loc.last.iChar - errRecord.loc.first.iChar + 1 
	r.width = numChars * ui.dxErrChar + dxExtra * 2

	-- Position the ref highlight if it's showing  TODO: two line groups if necc
	r = ui.errGroup.refRect
	r.isVisible = false
	if errRecord.refLoc then
		local iLineRef = errRecord.refLoc.first.iLine
		if iLineRef >= lineNumFirst and iLineRef <= lineNumLast then
			r.y = (iLineRef - lineNumFirst) * ui.dyErrLine
			r.x = (errRecord.refLoc.first.iChar - 1) * ui.dxErrChar - dxExtra
			numChars = errRecord.refLoc.last.iChar - errRecord.refLoc.first.iChar + 1
			r.width = numChars * ui.dxErrChar + dxExtra * 2
			r.isVisible = true
		end
	end
end

-- Handle resize event for the window
local function onResizeWindow( event )
	-- Get new window size
	getDeviceMetrics()

	-- Window background
	ui.background.width = ui.width
	ui.background.height = ui.height

	-- Toolbar
	local group = ui.toolbarGroup
	group.background.width = ui.width
	group.levelPicker.x = ui.width - margin

	-- Status bar
	group = ui.statusBarGroup
	group.y = ui.height - dyStatusBar
	group.background.width = ui.width
	group.message.x = ui.width / 2
	group.openFileBtn.x = ui.width

	-- Remake the error display
	if err.hasErr() then
		showError()
	end
end

-- Handle new frame update
local function onEnterFrame( event )
	-- Run the user's update function, if defined
	if type(_fn.update) == "function" then
		_fn.update()
	end
end

-- Prepare for a new run of the user program
local function initNewProgram()
	-- Clear user functions and variables tables
	this = {}
	_fn = {}

	-- Init new runtime state for this run
	if ui.gameGroup then
		ui.gameGroup:removeSelf()
	end
	ui.gameGroup = makeGroup( ui.outputGroup )
	ui.gameGroup.isVisible = false
	removeErrorDisplay()
end

-- Function to process the user file (parse then run or show error)
local function processUserFile()
	-- Read the file
	if not readSourceFile() then
		return
	end

	-- Get ready to run a new program
	initNewProgram()

	-- Create parse tree array
	local startTime = system.getTimer()
	local parseTrees = {}
	local startTokens = nil
	err.initProgram()
	parseJava.init()
	for lineNum = 1, #sourceFile.strLines do
		local strUserCode = sourceFile.strLines[lineNum]
		local tree, tokens = parseJava.parseLine( strUserCode, 
									lineNum, startTokens, syntaxLevel )
		if tree == false then
			-- Line is incomplete, carry tokens forward to next line
			startTokens = tokens
		else
			startTokens = nil
			if tree == nil then
				showError()
				return
			end
			parseTrees[#parseTrees + 1] = tree
		end
	end
	print( string.format( "\nFile parsed in %.3f ms\n", system.getTimer() - startTime ) )

	-- Do Semantic Analysis on the parse trees
	if not checkJava.initProgram( parseTrees ) then
		showError()
	else
		-- Make and run the Lua code
		local codeStr = codeGenJava.getLuaCode( parseTrees )
		-- print( codeStr )
		if err.hasErr() then
			showError()
		else
			runLuaCode( codeStr )
		end
	end
end

-- Function to check user file for changes and (re)parse it if modified
local function checkUserFile()
	if sourceFile.path then
		local timeMod = lfs.attributes( sourceFile.path, "modification" )
		if timeMod and timeMod > sourceFile.timeModLast then
			sourceFile.timeModLast = timeMod
			updateStatusBar()
			processUserFile()
		end
	end
end

-- Make the toolbar UI
local function makeToolbar()
	local group = makeGroup()
	ui.toolbarGroup = group

	-- Background
	group.background = uiItem( display.newRect( group, 0, 0, ui.width, dyToolbar ),
							toolbarShade, borderShade )

	-- Level picker
	local segmentNames = {}
	for i = 1, numSyntaxLevels do
		segmentNames[i] = tostring( i )
	end
	local segWidth = 25
	local controlWidth = segWidth * numSyntaxLevels
	group.levelPicker = widget.newSegmentedControl{
		x = ui.width - margin,
		y = dyToolbar / 2,
		segmentWidth = segWidth,
		segments = segmentNames,
		defaultSegment = numSyntaxLevels,
		onPress = 
			function (event )
				syntaxLevel = event.target.segmentNumber
				processUserFile()
			end
	}
	group.levelPicker.anchorX = 1
end

-- Init the app
local function initApp()
	-- Get initial device info
	ui.isMac = (system.getInfo( "platform" ) == "macos")
	getDeviceMetrics()

	-- Make a default window title
	native.setProperty("windowTitleText", "Code12")
	display.setStatusBar( display.HiddenStatusBar )

	-- White background
	ui.background = uiWhite( display.newRect( 0, 0, ui.width, ui.height ) )

	-- UI and display elements
	ui.outputGroup = makeGroup( nil, 0, dyToolbar )
	makeStatusBar()
	makeToolbar()

	-- Install listeners
	Runtime:addEventListener( "enterFrame", onEnterFrame )
	Runtime:addEventListener( "resize", onResizeWindow )

	-- Install timer to check file 4x/sec
	timer.performWithDelay( 250, checkUserFile, 0 )
end


-- Start the app
initApp()

