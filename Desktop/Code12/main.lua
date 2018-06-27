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

-- Code12 app modules
local app = require( "app" )
local env = require( "env" )
local parseJava = require( "parseJava" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )
local err = require( "err" )
local console = require( "console" )

-- UI metrics
local margin = 10        -- generic margin to leave between many UI items
local dyToolbar = 40
local dyStatusBar = 30
local dyPaneSplit = 10
local fontSizeUI = 12
local defaultConsoleLines = 10

-- Misc constants
local numSyntaxLevels = 12

-- Display objects and groups
local appBg                    -- white background rect
local toolbarGroup             -- display group for toolbar
local statusBarGroup           -- display group for status bar
local outputGroup              -- display group for program output area
local rightBar                 -- clipping bar to the right of the output area
local paneSplit                -- pane split area
local lowerGroup               -- display area below the pane split
local gameGroup                -- display group for game output
local errGroup                 -- display group for error display

-- Program state
local syntaxLevel = numSyntaxLevels   -- programming syntax level
local minConsoleHeight                -- min height of the console window (from pane split)
local paneDragOffset                  -- when dragging the pane split

-- The user source file
local sourceFile = {
	path = nil,              -- full pathname to the file
	timeLoaded = 0,          -- time this file was loaded
	timeModLast = 0,         -- last modification time or 0 if never
	strLines = {},           -- array of source code lines when read
}

-- Force the initial file to the standard test file for faster dev testing
if env.isSimulator then
--	sourceFile.path = "/Users/davecparker/Documents/Git Projects/code12/Desktop/Default Test/UserCode.java"
	sourceFile.path = "/Users/daveparker/Documents/GitHub/code12/Desktop/Default Test/UserCode.java"
	sourceFile.timeLoaded = os.time()
end


-- The global state tables that the generated Lua code can access (Lua globals)
ct = {
	_appContext = {},      -- contents set in initApp
	checkParams = true,    -- set to false to disable runtime API parameter checks
	-- The ct.xxx API functions are added here by the Lua runtime when loaded
}
this = {}      -- generated code uses this.varName for class/global variables
_fn = {}       -- generated code uses _fn.start(), _fn.update(), _fn.userFn(), etc.

-- Cached state
local appContext = ct._appContext


--- Internal Functions ------------------------------------------------

-- Return the available height for the output area
local function outputAreaHeight()
	return app.height - dyToolbar - dyStatusBar - minConsoleHeight - dyPaneSplit
end

-- Update status bar based on data in sourceFile
local function updateStatusBar()
	if sourceFile.path then
		-- Get just the filename with extension from the path
		local dir, filename = env.dirAndFilenameOfPath( sourceFile.path )

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
		statusBarGroup.message.text = filename .. " -- Updated: " .. updateStr
		statusBarGroup.openFileBtn.isVisible = true
	else
		statusBarGroup.openFileBtn.isVisible = false
	end
end

-- Run the given lua code string dynamically, and then call the contained start function.
local function runLuaCode( luaCode )
	-- Load the code dynamically and execute it
	local codeFunction = loadstring( luaCode )
 	if type(codeFunction) == "function" then
 		-- Run user code main chunk, which defines the functions
 		codeFunction()

 		-- Tell the runtime to init and start a new run
 		appContext.initRun()

 		-- Show the game output
		gameGroup.isVisible = true
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

-- Write a Lua source code output file to save the generated code.
-- Put it next to the Java source file.
local function writeLuaCode( codeStr )
	-- Put the output file in the same location as the source but named "main.lua"
	local dir, filename = env.dirAndFilenameOfPath( sourceFile.path )
	local outPath = dir .. "main.lua"

	-- If the file already exists, then only overwrite it if we created it
	local marker = "this = {}; _fn = {}   -- This file was generated by Code12 from \""
	local outFile = io.open( outPath, "r" )
	if outFile then
		local line = outFile:read( "*l" )
		io.close( outFile )
		if not string.starts( line, marker ) then
			print( "*** Can't generate main.lua because one already exists" )
			return
		end
	end

	-- Write the Lua file
	local outFile = io.open( outPath, "w" )
	if outFile then
		-- Start with our 3-line header to enable standalone runs with the Lua runtime
		-- from test app folders in the Lua folder or one subfolder lower.
		outFile:write( marker .. filename .. "\"\n")
		outFile:write( "package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'\n" )
		outFile:write( "require('Code12.api')\n" )

		-- Remove the first 3 lines from codeStr (which should be blank or comments), 
		-- so that line numbers match after adding our header above.
		codeStr = string.match( codeStr, "[^\n]*\n[^\n]*\n[^\n]*\n(.*)" )
		
		-- Write the code
		outFile:write( codeStr )
		outFile:write( "\n" )
		io.close( outFile )
	end

	-- Also write a config.lua file so that we can get the right fps, etc.
	local configPath = dir .. "config.lua"
	local configFile = io.open( configPath, "w" )
	if configFile then
		configFile:write( "application = { content = { width = 600, height = 900, scale = 'adaptive', fps = 60 } }" )
		io.close( configFile )
	end

	-- Print user code to console for debugging
	--print( "--- Lua Code: ---\n" ); 
	--print( codeStr )
end

-- Show dialog to choose the user source code file
local function chooseFile()
	local path = env.pathFromOpenFileDialog( "Choose Java Source Code File" )
	if path then
		sourceFile.path = path
		sourceFile.timeLoaded = os.time()
		sourceFile.timeModLast = 0
	end
	native.setActivityIndicator( false )
end

-- Event handler for the Choose File button
local function onChooseFile()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, chooseFile )
end

-- Open the source file in the system default text editor for its file type
local function openFileInEditor()
	if sourceFile.path then
		env.openFileInEditor( sourceFile.path )
	end
end

-- Get device metrics and store them in the global table
local function getDeviceMetrics()
	app.width = display.actualContentWidth
	app.height = display.actualContentHeight
end

-- Make the status bar UI
local function makeStatusBar()
	statusBarGroup = app.makeGroup( nil, 0, app.height - dyStatusBar )

	-- Background color
	statusBarGroup.bg = app.uiItem( display.newRect( statusBarGroup, 0, 0, app.width, dyStatusBar ),
							app.toolbarShade, app.borderShade )

	-- Status message
	local yCenter = dyStatusBar / 2
	statusBarGroup.message = display.newText( statusBarGroup, "", app.width / 2, yCenter, 
									native.systemFont, fontSizeUI )
	statusBarGroup.message:setFillColor( 0 )

	-- Open in Editor button
	local btn = widget.newButton{
		x = margin,
		y = yCenter,
		onRelease = openFileInEditor,
		label = "Open in Editor",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	statusBarGroup:insert( btn )
	btn.anchorX = 0
	statusBarGroup.openFileBtn = btn

	updateStatusBar()
end

-- Make and return a highlight rectangle, in the reference color if ref
local function makeHilightRect( x, y, width, height, ref )
	local r = app.uiItem( display.newRect( errGroup.highlightGroup, x, y, width, height ) )
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
	paneSplit.y = dyToolbar + height
	paneSplit.width = app.width
	lowerGroup.y = paneSplit.y + dyPaneSplit + 1
	local consoleHeight = app.height - lowerGroup.y - dyStatusBar
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
	errGroup = app.makeGroup( outputGroup )
	local numSourceLines = 7

	-- Layout metrics
	local dxChar = app.consoleFontCharWidth
	local dxLineNum = math.round( dxChar * 6 )
	local xText = math.round( dxLineNum + dxChar )
	local dyLine = app.consoleFontHeight
	local dySource = numSourceLines * dyLine

	-- Make background rect for the source display
	app.uiItem( display.newRect( errGroup, 0, 0, app.width, dySource + margin ), 1, app.borderShade )

	-- Make the highlight rectangles
	local highlightGroup = app.makeGroup( errGroup, xText, margin )
	errGroup.highlightGroup = highlightGroup
	local y = ((numSourceLines - 1) / 2) * dyLine - 1
	errGroup.lineNumRect = makeHilightRect( -xText, y, dxLineNum, dyLine )
	errGroup.refRect = makeHilightRect( dxChar * 5, y, 
							dxChar * 6, dyLine, true )
	errGroup.sourceRect = makeHilightRect( 0, y, dxChar * 4, dyLine )

	-- Make the lines numbers
	local lineNumGroup = app.makeGroup( errGroup, 0, margin )
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
	local sourceGroup = app.makeGroup( errGroup, xText, margin )
	errGroup.sourceGroup = sourceGroup
	for i = 1, numSourceLines do
		app.uiBlack( display.newText{
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
	errGroup.errText = app.uiBlack( display.newText{
		parent = errGroup,
		text = "", 
		x = margin * 2, 
		y = dySource + margin * 2,
		width = app.width - xText - 20,   -- wrap near end of window
		font = native.systemFontBold, 
		fontSize = app.consoleFontSize,
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
	layoutPanes()

	-- Set the error text
	local errRecord = err.getErrRecord()
	print( "\n" .. errRecord.strErr )
	local strDisplay = errRecord.strErr
	if errRecord.strLevel then
		print( errRecord.strLevel )
		strDisplay = strDisplay .. "\n" .. errRecord.strLevel
	end
	errGroup.errText.text = strDisplay

	-- Load the source lines around the error
	local iLine = errRecord.loc.first.iLine   -- main error location
	local sourceGroup = errGroup.sourceGroup
	local lineNumGroup = errGroup.lineNumGroup
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
	local dxChar = app.consoleFontCharWidth
	local dxExtra = 2   -- extra pixels of highlight horizontally
	local r = errGroup.sourceRect
	r.x = (errRecord.loc.first.iChar - 1) * dxChar - dxExtra
	local numChars = errRecord.loc.last.iChar - errRecord.loc.first.iChar + 1 
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

-- Handle resize event for the window
local function onResizeWindow()
	-- Get new window size
	getDeviceMetrics()

	-- Window background
	appBg.width = app.width
	appBg.height = app.height

	-- Toolbar
	toolbarGroup.bg.width = app.width
	toolbarGroup.levelPicker.x = app.width - margin

	-- Status bar
	statusBarGroup.y = app.height - dyStatusBar
	statusBarGroup.bg.width = app.width
	statusBarGroup.message.x = app.width / 2

	-- Remake the error display, if any
	if err.hasErr() then
		showError()
	end

	-- Calculate the output space and tell the runtime we resized. 
	-- This will result in a call to ct.setHeight() internally, 
	-- which will then call us back at setClipSize().
	appContext.widthP = math.max( app.width, 1 )
	appContext.heightP = math.max( outputAreaHeight(), 1 )
	if appContext.onResize then
		appContext.onResize()
	end
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
	if event.phase == "began" then
		display.getCurrentStage():setFocus( paneSplit )
		paneDragOffset = event.y - lowerGroup.y
	else
		if event.phase ~= "cancelled" then
			-- Compute new console size below pane split
			local y = event.y - paneDragOffset
			minConsoleHeight = app.pinValue( 
					app.height - y - dyStatusBar,
					0, app.height - dyStatusBar )
			onResizeWindow()
		end
		if event.phase ~= "moved" then
			display.getCurrentStage():setFocus( nil )
		end
	end
end

-- Prepare for a new run of the user program
local function initNewProgram()
	-- Stop existing run if any
	appContext.stopRun()

	-- Set the source dir and filename
	appContext.sourceDir, appContext.sourceFilename = 
			env.dirAndFilenameOfPath( sourceFile.path )

	-- Set the mediaBaseDir and the mediaDir.
	-- Good grief, Corona requires the path to images and sounds to be
	-- a relative path, not absolute, and the only reliable dir to be
	-- relative to seems to be the system.DocumentsDirectory.
	appContext.mediaBaseDir = env.baseDirDocs
	appContext.mediaDir = env.relativePath( env.docsDir, appContext.sourceDir )

	print( "\n--- New Run ----------------------" )
	print( "sourceFile.path: " .. sourceFile.path )

	-- Clear class variables and user functions
	this = {}
	_fn = {}

	-- Clear the error state, console, and other state
	err.initProgram()
	console.clear()

	-- Init new runtime display state for this run
	if gameGroup then
		gameGroup:removeSelf()
	end
	gameGroup = app.makeGroup( outputGroup )
	gameGroup.isVisible = false
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
		if err.hasErr() then
			showError()
		else
			writeLuaCode( codeStr )
			runLuaCode( codeStr )
		end
	end
end

-- Function to check user file for changes and (re)parse it if modified
local function checkUserFile()
	if sourceFile.path then
		local timeMod = env.fileModTimeFromPath( sourceFile.path )
		if timeMod and timeMod > sourceFile.timeModLast then
			sourceFile.timeModLast = timeMod
			updateStatusBar()
			processUserFile()
		end
	end
end

-- Make the toolbar UI
local function makeToolbar()
	toolbarGroup = app.makeGroup()

	-- Background
	toolbarGroup.bg = app.uiItem( display.newRect( toolbarGroup, 0, 0, app.width, dyToolbar ),
							app.toolbarShade, app.borderShade )

	-- Choose File Button
	local yCenter = dyToolbar / 2
	local btn = widget.newButton{
		x = margin, 
		y = yCenter,
		onRelease = onChooseFile,
		label = "Choose File",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	toolbarGroup:insert( btn )
	btn.anchorX = 0
	toolbarGroup.chooseFileBtn = btn

		-- Level picker
	local segmentNames = {}
	for i = 1, numSyntaxLevels do
		segmentNames[i] = tostring( i )
	end
	local segWidth = 25
	local controlWidth = segWidth * numSyntaxLevels
	toolbarGroup.levelPicker = widget.newSegmentedControl{
		x = app.width - margin,
		y = yCenter,
		segmentWidth = segWidth,
		segments = segmentNames,
		defaultSegment = numSyntaxLevels,
		onPress = 
			function (event )
				syntaxLevel = event.target.segmentNumber
				processUserFile()
			end
	}
	toolbarGroup.levelPicker.anchorX = 1
end

-- Init the app
local function initApp()
	-- Get initial device info and metrics
	getDeviceMetrics()
	console.init()
	minConsoleHeight = app.consoleFontHeight * defaultConsoleLines
	app.outputWidth = app.width
	app.outputHeight = outputAreaHeight()

	-- Make a default window title
	native.setProperty("windowTitleText", "Code12")
	display.setStatusBar( display.HiddenStatusBar )

	-- White background
	appBg = app.uiWhite( display.newRect( 0, 0, app.width, app.height ) )

	-- Main display areas
	outputGroup = app.makeGroup( nil, 0, dyToolbar )
	rightBar = app.uiItem( display.newRect( 0, dyToolbar, 0, 0 ), 
						app.extraShade, app.borderShade )
	paneSplit = app.uiItem( display.newRect( 0, 0, 0, dyPaneSplit ), 
						app.toolbarShade, app.borderShade )
	paneSplit:addEventListener( "touch", onTouchPaneSplit )
	lowerGroup = app.makeGroup()
	console.create( lowerGroup, 0, 0, 0, 0 )
	layoutPanes()

	-- UI bars
	makeStatusBar()
	makeToolbar()

	-- Fill in the appContext for the runtime
	appContext.outputGroup = outputGroup
	appContext.widthP = app.outputWidth
	appContext.heightP = app.outputHeight
	appContext.setClipSize = setClipSize
	appContext.print = console.print
	appContext.println = console.println
	appContext.inputString = console.inputString

	-- Load the Code12 API and runtime.
	-- This defines the Code12 APIs in the global ct table
	-- and sets the runtime's fields in ct._appContext.
	require( "Code12.api" )

	-- Install listeners for the app
	Runtime:addEventListener( "resize", onResizeWindow )

	-- Install timer to check file 4x/sec
	timer.performWithDelay( 250, checkUserFile, 0 )
end


-- Start the app
initApp()

