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

-- Local modules
local parseJava = require( "parseJava" )
local codeGenJava = require( "codeGenJava" )


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

-- Force the initial file (for faster repeated testing)
-- Home:
sourceFile.path = "/Users/davecparker/Documents/Git Projects/code12/Desktop/UserCode.java"
-- Shop:
-- sourceFile.path = "/Users/daveparker/Documents/GitHub/code12/Desktop/UserCode.java"
sourceFile.timeLoaded = os.time()


-- The global state tables that the generated Lua code can access
ct = {}                    -- API functions
_ctAppGlobalState = {
	isMac = false,         -- true if running on Mac OS (else Windows, for now)
	width = 0,             -- window width
	height = 0,            -- window height
	background = nil,      -- white background rect
	statusBar = nil,       -- status bar rect
	statusBarText = nil,   -- text object in the status bar
	chooseFileBtn = nil,   -- Choose File button in status bar
	openFileBtn = nil,     -- Open button in status bar
	group = nil,           -- display group for all drawing objects
	vars = {},             -- namespace for user Java instance variables
	functions = {},        -- namespace for user Java functions
}
this = _ctAppGlobalState.vars       -- generated code uses this.var
_fn = _ctAppGlobalState.functions   -- generated code uses _fn.foo()
local g = _ctAppGlobalState         -- for use in this file


--- API Functions ------------------------------------------------

-- Temp
function ct.circle( x, y, d )
	local c = display.newCircle( g.group, x, y, d / 2 )
	c:setFillColor( 1, 0, 0 )
	return c 
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
		g.statusBarText.text = fileAndExt .. " -- Updated: " .. updateStr
		g.openFileBtn.isVisible = true
	else
		g.openFileBtn.isVisible = false
	end
end

-- Run the given lua code string dynamically, and then call the contained start function.
local function runLuaCode( luaCode )
	-- Init new runtime state for this run
	if g.group then
		g.group:removeSelf()
	end
	g.group = display.newGroup()
	g.vars = {}
	g.functions = {}
	this = g.vars
	_fn = g.functions

	-- Load the code dynamically and execute it
	local codeFunction = loadstring( luaCode )
 	if type(codeFunction) == "function" then
 		codeFunction()

 		-- Run the embedded start function
 		if type(g.functions.start) == "function" then
 			g.functions.start()
 		end
 	else
 	 	print( "*** Lua code failed to load" )
 	end
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
			sourceFile.strLines[lineNum] = s
			lineNum = lineNum + 1
		until false -- breaks internally
		io.close( file )
		return true
	end
	return false
end

-- Function to check user file for changes and (re)parse it if modified
local function checkUserFile()
	if sourceFile.path then
		local timeMod = lfs.attributes( sourceFile.path, "modification" )
		if timeMod and timeMod > sourceFile.timeModLast then
			if readSourceFile() then
				sourceFile.timeModLast = timeMod

				-- Create parse tree array
				local startTime = system.getTimer()
				local parseTrees = {}
				local startTokens = nil
				parseJava.init()
				for lineNum = 1, #sourceFile.strLines do
					local strUserCode = sourceFile.strLines[lineNum]
					local tree, errRecord = parseJava.parseLine( strUserCode, lineNum, startTokens )
					if tree == false then
						-- Line is incomplete, carry tokens forward to next line
						startTokens = errRecord
					else
						startTokens = nil

						if tree == nil then
							-- Error
							local strErr
							if errRecord == nil then
								strErr = "*** Missing errRecord!"
							else
								strErr = string.format( "Line %d: %s (chars %d through %d)", 
												errRecord.iLine, errRecord.strErr, 
												errRecord.iCharFirst, errRecord.iCharLast );
							end
							strErr = string.gsub( strErr, "\"", "\\\"")   -- escape any double quotes
							print("***ERROR***", strErr)
							return
						end
						parseTrees[#parseTrees + 1] = tree
					end
				end
				print( string.format( "\nFile parsed in %.3f ms\n", system.getTimer() - startTime ) )

				-- Make and run the Lua code
				local codeStr = codeGenJava.getLuaCode( parseTrees )
				print( codeStr )
				runLuaCode( codeStr )
			end
		end
		updateStatusBar()
	end
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
		if g.isMac then
			os.execute( "open \"" .. sourceFile.path .. "\"" )
		else
			os.execute( "start \"" .. sourceFile.path .. "\"" )
		end
	end
end

-- Get device metrics and store them in the global table
local function getDeviceMetrics()
	g.width = display.actualContentWidth
	g.height = display.actualContentHeight
end

-- Handle resize event for the window
local function onResizeWindow( event )
	-- Get new window size and relayout UI to match
	getDeviceMetrics()
	g.background.width = g.width
	g.background.height = g.height
	g.statusBar.y = g.height - dyStatusBar / 2
	g.statusBar.width = g.width
	g.chooseFileBtn.y = g.statusBar.y
	g.statusBarText.x = g.width / 2
	g.statusBarText.y = g.statusBar.y
	g.openFileBtn.x = g.width
	g.openFileBtn.y = g.statusBar.y
end

-- Handle new frame update
local function onEnterFrame( event )
	-- Run the user's update function, if defined
	if type(g.functions.update) == "function" then
		g.functions.update()
	end
end

-- Init the app
function initApp()
	-- Get initial device info
	g.isMac = (system.getInfo( "platform" ) == "macos")
	getDeviceMetrics()

	-- White background
	g.background = display.newRect( 0, 0, g.width, g.height )
	g.background.anchorX = 0
	g.background.anchorY = 0
	g.background:setFillColor( 1 )

	-- Make a default window title
	native.setProperty("windowTitleText", "Code12")
	display.setStatusBar( display.HiddenStatusBar )

	-- Make the status bar UI
	g.statusBar = display.newRect( 0, g.height - dyStatusBar / 2, g.width, dyStatusBar )
	g.statusBar.anchorX = 0
	g.statusBar:setFillColor( 0.8 )
	g.statusBar.strokeWidth = 1
	g.statusBar:setStrokeColor( 0 )
	g.chooseFileBtn = widget.newButton{
		x = 10, 
		y = g.statusBar.y,
		onRelease = chooseFile,
		label = "Choose File",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	g.chooseFileBtn.anchorX = 0
	g.statusBarText = display.newText( "", g.width / 2, g.statusBar.y, native.systemFont, fontSizeUI )
	g.statusBarText:setFillColor( 0 )
	g.openFileBtn = widget.newButton{
		x = g.width,
		y = g.statusBar.y,
		onRelease = openFileInEditor,
		label = "Open in Editor",
		labelAlign = "right",
		labelXOffset = -10,
		font = native.systemFontBold,
		fontSize = fontSizeUI,
	}
	g.openFileBtn.anchorX = 1
	updateStatusBar()

	-- Install listeners
	Runtime:addEventListener( "enterFrame", onEnterFrame )
	Runtime:addEventListener( "resize", onResizeWindow )

	-- Install timer to check file 4x/sec
	timer.performWithDelay( 250, checkUserFile, 0 )
end


-- Start the app
initApp()

