-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Main program for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )
local parseJava = require( "parseJava" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )
local err = require( "err" )
local statusBar = require( "statusBar" )
local toolbar = require( "toolbar" )
local runView = require( "runView" )


-- The global state tables that the generated Lua code can access (Lua globals)
ct = {
	_appContext = {},      -- contents set in initApp
	checkParams = true,    -- set to false to disable runtime API parameter checks
	-- The ct.xxx API functions are added here by the Lua runtime when loaded
}
_G.this = {}      -- generated code uses this.varName for class/global variables
_G._fn = {}       -- generated code uses _fn.start(), _fn.update(), _fn.userFn(), etc.


-- File local state
local appBg                    -- white background rect

-- Cached state
local sourceFile = app.sourceFile     -- info about the user's source code file
local appContext = ct._appContext


-- Force the initial file to the standard test file for faster dev testing
if env.isSimulator then
	sourceFile.path = "/Users/davecparker/Documents/Git Projects/code12/Desktop/Default Test/UserCode.java"
--	sourceFile.path = "/Users/daveparker/Documents/GitHub/code12/Desktop/Default Test/UserCode.java"
	sourceFile.timeLoaded = os.time()
end


--- Functions ----------------------------------------------------------------

-- Run the given lua code string dynamically, and then call the contained start function.
local function runLuaCode( luaCode )
	-- Load the code dynamically and execute it
	local codeFunction = loadstring( luaCode )
	if type(codeFunction) == "function" then
		-- Run user code main chunk, which defines the functions
		codeFunction()

		-- Tell the runtime to init and start a new run
		g.initRun()

		-- Show the program output
		runView.showOutput()
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
	outFile = io.open( outPath, "w" )
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

	-- Print user code for debugging
	--print( "--- Lua Code: ---\n" ); 
	--print( codeStr )
end

-- Prepare for a new run of the user program
local function initNewProgram()
	-- Stop existing run if any
	g.stopRun()

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
	_G.this = {}
	_G._fn = {}

	-- Clear the error state and re-init the run view state
	err.initProgram()
	runView.initNewProgram()
end

-- Process the user file (parse then run or show error)
function app.processUserFile()
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
									lineNum, startTokens, app.syntaxLevel )
		if tree == false then
			-- Line is incomplete, carry tokens forward to next line
			startTokens = tokens
		else
			startTokens = nil
			if tree == nil then
				runView.showError()
				return
			end
			parseTrees[#parseTrees + 1] = tree
		end
	end
	print( string.format( "\nFile parsed in %.3f ms\n", system.getTimer() - startTime ) )

	-- Do Semantic Analysis on the parse trees
	if not checkJava.initProgram( parseTrees, app.syntaxLevel ) then
		runView.showError()
	else
		-- Make and run the Lua code
		local codeStr = codeGenJava.getLuaCode( parseTrees )
		if err.hasErr() then
			runView.showError()
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
			app.processUserFile()
			statusBar.update()
		end
	end
end

-- Get device metrics and store them in the global table
local function getDeviceMetrics()
	app.width = display.actualContentWidth
	app.height = display.actualContentHeight
end


-- Handle resize event for the window
local function onResizeWindow()
	-- Get new window size
	getDeviceMetrics()

	-- App background rect
	appBg.width = app.width
	appBg.height = app.height

	-- Resize the component windows
	toolbar.resize()
	statusBar.resize()
	runView.resize()
end

-- Init the app
local function initApp()
	-- Make a default window title
	display.setStatusBar( display.HiddenStatusBar )
	native.setProperty("windowTitleText", "Code12")

	-- Get initial device info and metrics
	getDeviceMetrics()

	-- White background for the whole app
	appBg = g.uiWhite( display.newRect( 0, 0, app.width, app.height ) )

	-- Create the component views
	runView.create()
	statusBar.create()
	toolbar.create()

	-- Init user settings
	app.syntaxLevel = app.numSyntaxLevels    -- TODO: load/save

	-- Install listeners for the app
	Runtime:addEventListener( "resize", onResizeWindow )

	-- Install update timers
	timer.performWithDelay( 250, checkUserFile, 0 )       -- 4x/sec
	timer.performWithDelay( 10000, statusBar.update, 0 )  -- every 10 sec
end

-- Start the app
initApp()

