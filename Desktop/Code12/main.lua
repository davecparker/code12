-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Main program for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local composer = require( "composer" )
local json = require( "json" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )
local parseProgram = require( "parseProgram" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )
local err = require( "err" )
local statusBar = require( "statusBar" )
local toolbar = require( "toolbar" )
local console = require( "console" )


-- The global state tables that the generated Lua code can access (Lua globals)
ct = {
	_appContext = {},      -- contents set in initApp
	checkParams = true,    -- set to false to disable runtime API parameter checks
	-- The ct.xxx API functions are added here by the Lua runtime when loaded
}
_G.this = {}      -- generated code uses this.varName for class/global variables
_G._fn = {}       -- generated code uses _fn.start(), _fn.update(), _fn.userFn(), etc.


-- User settings to load/save
local userSettings = {
	recentPath = nil,                       -- path to last source file used
	syntaxLevel = app.numSyntaxLevels,      -- user's syntax level setting
}

-- Cached state
local sourceFile = app.sourceFile     -- info about the user's source code file
local appContext = ct._appContext


--- Functions ----------------------------------------------------------------

-- Run the given lua code string dynamically, and then call the contained start function.
local function runLuaCode( luaCode )
	-- Load the code dynamically and execute it
	local codeFunction, strErr = loadstring( luaCode )
	if type(codeFunction) == "function" then
		-- Run user code main chunk, which defines the functions
		codeFunction()

		-- Run and show the program output
		composer.gotoScene( "runView" )
	else
		-- Lua code failed to load (unexpected code generation error?)
		-- Try to get the line number and report an error.
		print( "*** Lua code failed to load: " .. strErr )
		local strLineNum = string.match( strErr, "%[string[^:]+:(%d+):(.*)" )
		local iLine = nil
		if strLineNum then
			local lineNum = tonumber( strLineNum )
			if lineNum then
				iLine = lineNum
			end
		end
		if iLine then
			err.setErrLineNum( iLine, "This line caused an unexpected code generation error" )
		else
			err.setErrLineNum( 1, "Sorry, your program caused an unexpected code generation error" )
		end
		composer.gotoScene( "errView" )
	end
end

-- Read the sourceFile and store all of its source lines.
-- Return true if success.
local function readSourceFile()
	if sourceFile.path then
		local file = io.open( sourceFile.path, "r" )
		if file then
			sourceFile.timeLoaded = os.time()
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
end

-- Process the sourceFile (parse then run or show error), which has already been read. 
function app.processUserFile()
	-- Get ready to run a new program
	initNewProgram()

	-- Create parse tree array
	local startTime = system.getTimer()
	local programTree, parseTrees = parseProgram.getProgramTree( 
								sourceFile.strLines, app.syntaxLevel )
	if parseTrees == nil then
		composer.gotoScene( "errView" )
		return true
	end
	print( string.format( "\nFile parsed in %.3f ms\n", system.getTimer() - startTime ) )

	-- Do Semantic Analysis on the parse trees
	checkJava.checkProgram( programTree, app.syntaxLevel )
	if err.rec then
		composer.gotoScene( "errView" )
	else
		-- Make and run the Lua code
		-- local codeStr = codeGenJava.getLuaCode( parseTrees )
		-- if err.rec then
		-- 	composer.gotoScene( "errView" )
		-- else
		-- 	writeLuaCode( codeStr )
		-- 	runLuaCode( codeStr )
		-- end
	end
	return true
end

-- Check user file for changes and (re)run it if modified or never loaded
local function checkUserFile()
	if sourceFile.path then
		-- Check the file modification time
		local timeMod = env.fileModTimeFromPath( sourceFile.path )
		if sourceFile.timeModLast == 0 then
			sourceFile.timeModLast = timeMod or os.time()
		end

		-- Consider the file updated if timeMod changed or if never loaded
		if sourceFile.timeLoaded == 0 
				or (timeMod and timeMod > sourceFile.timeModLast) then
			sourceFile.timeModLast = timeMod
			sourceFile.updated = true
		end

		-- (Re)Load and process the file if updated 
		if sourceFile.updated and readSourceFile() then
			sourceFile.updated = false    -- until next time the file updates
			app.processUserFile()
			statusBar.update()
		end
	end
end

-- Handle resize event for the window
local function onResizeWindow()
	app.getWindowSize()
	toolbar.resize()
	statusBar.resize()
end

-- Return the path name for the user settings file
local function settingsFilePath()
	return system.pathForFile( "userSettings.txt", system.DocumentsDirectory )
end

-- Save the user settings
local function saveSettings()
	-- Update the userSettings
	userSettings.recentPath = sourceFile.path
	userSettings.syntaxLevel = app.syntaxLevel 

	-- Write the settings file
	local file = io.open( settingsFilePath(), "w" )
	if file then
		file:write( json.encode( userSettings ) )
		io.close( file )
	end
end

-- Load the user settings
local function loadSettings()
	-- Read the settings file
	local file = io.open( settingsFilePath(), "r" )
	if file then
		local str = file:read( "*a" )	-- Read entire file as a string (JSON encoded)
		io.close( file )
		if str then
			local t = json.decode( str )
			if t then
				-- Restore last used source file by default
				if t.recentPath then
					-- Use the recentPath only if the file still exists
					file = io.open( t.recentPath, "r" )
					if file then
						io.close( file )
						userSettings.recentPath = t.recentPath
						sourceFile.path = userSettings.recentPath
					end
				end

				-- Use the saved syntaxLevel if valid
				local level = t.syntaxLevel
				if type(level) == "number" and level >= 1 and level <= app.numSyntaxLevels then 
					userSettings.syntaxLevel = level
					app.syntaxLevel = userSettings.syntaxLevel
				end
			end
		end
	end
end

-- Handle system events for the app
local function onSystemEvent( event )
	-- Save the user settings if the user switches out of or quits the app
	if event.type == "applicationSuspend" or event.type == "applicationExit" then
		saveSettings()
	end
end

-- Init the app
local function initApp()
	-- Make a default window title
	display.setStatusBar( display.HiddenStatusBar )
	native.setProperty("windowTitleText", "Code12")

	-- Load saved user settings if any
	app.startTime = os.time()
	loadSettings()

	-- Get initial window size and metrics
	app.getWindowSize()
	console.init()      -- gets and stores console font metrics

	-- Create the UI bars that live in the global group
	statusBar.create()
	toolbar.create()

	-- Install listeners and update timers
	Runtime:addEventListener( "system", onSystemEvent )
	Runtime:addEventListener( "resize", onResizeWindow )
	timer.performWithDelay( 250, checkUserFile, 0 )       -- 4x/sec
	timer.performWithDelay( 10000, statusBar.update, 0 )  -- every 10 sec

	-- Start in the runView, which inits the runtime
	timer.performWithDelay( 10, checkUserFile, 0 )       -- first check soon
	composer.gotoScene( "runView" )
end


-- Start the app
initApp()

