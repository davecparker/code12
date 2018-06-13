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
local env = require( "env" )
local parseJava = require( "parseJava" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )
local apiTables = require( "apiTables" )
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

-- Force the initial file to the standard test file for faster dev testing
if env.isSimulator then
--	sourceFile.path = "/Users/davecparker/Documents/Git Projects/code12/Desktop/Default Test/UserCode.java"
	sourceFile.path = "/Users/daveparker/Documents/GitHub/code12/Desktop/Default Test/UserCode.java"
	sourceFile.timeLoaded = os.time()
end

-- UI elements and state
local ui = {
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
ct = {
	_appContext = nil,     -- created in initApp
	checkParams = true,    -- set to false to disable runtime API parameter checks
	-- The ct.xxx API functions are added here by the Lua runtime when loaded
}
this = {}      -- generated code uses this.varName for class/global variables
_fn = {}       -- generated code uses _fn.setup(), _fn.update(), _fn.userFn(), etc.


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
		ui.statusBarGroup.message.text = filename .. " -- Updated: " .. updateStr
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
 		-- Run user code main chunk, which defines the functions
 		codeFunction()

 		-- Tell the runtime to init and start a new run
 		ct._appContext.initRun()

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

-- Write a Lua source code output file to save the generated code.
-- Put it next to the Java source file.
local function writeLuaCode( codeStr )
	-- Put the output file in the same location as the source but named "main.lua"
	local dir, filename = env.dirAndFilenameOfPath( sourceFile.path )
	local outPath = dir .. "main.lua"

	-- If the file already exists, then only overwrite it if we created it
	local firstLine = "-- Generated by Code12 from Java code"
	local outFile = io.open( outPath, "r" )
	if outFile then
		local line = outFile:read( "*l" )
		io.close( outFile )
		if line ~= firstLine then
			print( "*** Can't generate main.lua because one already exists" )
			return
		end
	end

	-- Write the Lua file
	local outFile = io.open( outPath, "w" )
	if outFile then
		-- Start with our marker then code to enable standalone runs with the Lua runtime
		-- from test app folders in the Lua folder or one subfolder lower.
		outFile:write( firstLine )
		outFile:write( "\n-- Source file was: " .. filename .. "\n\n" )
		outFile:write( "package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'\n" )

		package.path = package.path .. ';../../Desktop/Code12/?.lua'

		outFile:write( "require('Code12.api')\n\n" )
		outFile:write( "this = {}; _fn = {}\n" )
		-- Write the user code
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
	print( "--- Lua Code: ---\n" ); print( codeStr )
end

-- Show dialog to choose the user source code file
local function chooseFile()
	local path = env.pathFromOpenFileDialog( "Choose Java Source Code File" )
	if path then
		sourceFile.path = path
		sourceFile.timeLoaded = os.time()
		sourceFile.timeModLast = 0
	end
end

-- Open the source file in the system default text editor for its file type
local function openFileInEditor()
	if sourceFile.path then
		env.openFileInEditor( sourceFile.path )
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
	local fontName = "Consolas"
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


-- Prepare for a new run of the user program
local function initNewProgram()
	-- Stop existing run if any
	local appContext = ct._appContext
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

	-- Clear class variables, user functions, and global event functions
	this = {}
	_fn = {}
	for eventName, fnRecord in pairs( apiTables.Code12Program.methods ) do
		if type(fnRecord) == "table" then
			_G[eventName] = nil
		end
	end

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

	-- Load the Code12 API and runtime.
	-- This defines the Code12 APIs in the global ct table
	-- and sets the runtime's fields in ct._appContext.
	ct._appContext = {
		outputGroup = ui.outputGroup,
		widthP = ui.width,
		heightP = ui.height,
		-- setTitle =     -- TODO
		-- setHeight =    -- TODO
	}
	require( "Code12.api" )

	-- Install listeners for the app
	Runtime:addEventListener( "resize", onResizeWindow )

	-- Install timer to check file 4x/sec
	timer.performWithDelay( 250, checkUserFile, 0 )
end


-- Start the app
initApp()

