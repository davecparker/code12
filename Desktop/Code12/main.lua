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
local dyStatusBar = 30
local fontSizeUI = 12


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
	statusBar = nil,       -- status bar rect
	statusBarText = nil,   -- text object in the status bar
	chooseFileBtn = nil,   -- Choose File button in status bar
	openFileBtn = nil,     -- Open button in status bar
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

function ct.toDouble( x )
	return x
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
		ui.statusBarText.text = fileAndExt .. " -- Updated: " .. updateStr
		ui.openFileBtn.isVisible = true
	else
		ui.openFileBtn.isVisible = false
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
	ui.statusBar = display.newRect( 0, ui.height - dyStatusBar / 2, ui.width, dyStatusBar )
	ui.statusBar.anchorX = 0
	ui.statusBar:setFillColor( 0.8 )
	ui.statusBar.strokeWidth = 1
	ui.statusBar:setStrokeColor( 0 )
	ui.chooseFileBtn = widget.newButton{
		x = 10, 
		y = ui.statusBar.y,
		onRelease = chooseFile,
		label = "Choose File",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	ui.chooseFileBtn.anchorX = 0
	ui.statusBarText = display.newText( "", ui.width / 2, ui.statusBar.y, native.systemFont, fontSizeUI )
	ui.statusBarText:setFillColor( 0 )
	ui.openFileBtn = widget.newButton{
		x = ui.width,
		y = ui.statusBar.y,
		onRelease = openFileInEditor,
		label = "Open in Editor",
		labelAlign = "right",
		labelXOffset = -10,
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	ui.openFileBtn.anchorX = 1
end

-- Make and return a highlight rectangle, in the reference color if ref
local function makeHilightRect( x, y, width, height, ref )
	local r = display.newRect( ui.errGroup.highlightGroup, x, y, width, height )
	r.anchorX = 0
	r.anchorY = 0
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
	local group = display.newGroup()
	ui.errGroup = group
	group.y = 30
	local numSourceLines = 7

	-- Get font metrics
	local fontName = ((ui.isMac and "Consolas") or "Courier")
	local fontSize = 16
	local fontMetrics = graphics.getFontMetrics( fontName, fontSize )
	local dyLine = fontMetrics.height + fontMetrics.leading
	local temp = display.newText( "1234567890", 0, 0, fontName, fontSize )
	ui.dyErrLine = dyLine
	ui.dxErrChar = temp.contentWidth / 10
	temp:removeSelf()

	-- Layout metrics
	local dxLineNum = math.round( ui.dxErrChar * 6 )
	local xText = math.round( dxLineNum + ui.dxErrChar )

	-- Make the highlight rectangles
	local highlightGroup = display.newGroup()
	highlightGroup.x = xText
	group:insert( highlightGroup )
	group.highlightGroup = highlightGroup
	local y = ((numSourceLines - 1) / 2) * dyLine
	group.lineNumRect = makeHilightRect( -xText, y, dxLineNum, dyLine )
	group.sourceRect = makeHilightRect( 0, y, ui.dxErrChar * 4, dyLine )
	group.refRect = makeHilightRect( ui.dxErrChar * 5, y, 
							ui.dxErrChar * 6, dyLine, true )

	-- Make the lines numbers
	local lineNumGroup = display.newGroup()
	group:insert( lineNumGroup )
	group.lineNumGroup = lineNumGroup
	for i = 1, numSourceLines do
		local t = display.newText{
			parent = lineNumGroup,
			text = "123", 
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
	local sourceGroup = display.newGroup()
	sourceGroup.x = xText
	group:insert( sourceGroup )
	group.sourceGroup = sourceGroup
	for i = 1, numSourceLines do
		local t = display.newText{
			parent = sourceGroup,
			text = "Test Source Code", 
			x = 0, 
			y = (i - 1) * dyLine,
			font = fontName, 
			fontSize = fontSize,
			align = "left",
		}
		t.anchorX = 0
		t.anchorY = 0
		t:setFillColor( 0 )
	end

	-- Make the error text
	local t = display.newText{
		parent = group,
		text = "This is sample error text telling you what you did wrong", 
		x = xText, 
		y = dyLine * (numSourceLines + 1),
		width = ui.width - xText - 20,   -- wrap near end of window
		font = native.systemFontBold, 
		fontSize = fontSize,
		align = "left",
	}
	t.anchorX = 0
	t.anchorY = 0
	t:setFillColor( 0 )
	group.errText = t
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
	print( err.getErrString() )
	local errRecord = err.getErrRecord()
	ui.errGroup.errText.text = errRecord.strErr

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

	-- Status bar
	ui.background.width = ui.width
	ui.background.height = ui.height
	ui.statusBar.y = ui.height - dyStatusBar / 2
	ui.statusBar.width = ui.width
	ui.chooseFileBtn.y = ui.statusBar.y
	ui.statusBarText.x = ui.width / 2
	ui.statusBarText.y = ui.statusBar.y
	ui.openFileBtn.x = ui.width
	ui.openFileBtn.y = ui.statusBar.y

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
	ui.gameGroup = display.newGroup()
	ui.gameGroup.isVisible = false
	removeErrorDisplay()
end

-- Function to check user file for changes and (re)parse it if modified
local function checkUserFile()
	if sourceFile.path then
		local timeMod = lfs.attributes( sourceFile.path, "modification" )
		if timeMod and timeMod > sourceFile.timeModLast then
			if readSourceFile() then
				sourceFile.timeModLast = timeMod

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
					local tree, tokens = parseJava.parseLine( strUserCode, lineNum, startTokens )
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
					print( codeStr )
					if err.hasErr() then
						showError()
					else
						runLuaCode( codeStr )
					end
				end
			end
		end
		updateStatusBar()
	end
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
	ui.background = display.newRect( 0, 0, ui.width, ui.height )
	ui.background.anchorX = 0
	ui.background.anchorY = 0
	ui.background:setFillColor( 1 )

	-- UI and display elements
	makeStatusBar()
	updateStatusBar()

	-- Install listeners
	Runtime:addEventListener( "enterFrame", onEnterFrame )
	Runtime:addEventListener( "resize", onResizeWindow )

	-- Install timer to check file 4x/sec
	timer.performWithDelay( 250, checkUserFile, 0 )
end


-- Start the app
initApp()

