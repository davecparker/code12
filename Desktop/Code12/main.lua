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

-- Code12 Runtime modules
local ct = require("Code12.ct")
local runtime = require("Code12.runtime")
require( "Code12.api" )

-- Code12 App modules
local app = require( "app" )
local source = require( "source" )
local env = require( "env" )
local parseProgram = require( "parseProgram" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )
local err = require( "err" )
local statusBar = require( "statusBar" )
local toolbar = require( "toolbar" )
local console = require( "console" )


-- User settings to load/save
local userSettings = {
	recentPath = nil,                       -- path to last source file used
	syntaxLevel = app.numSyntaxLevels,      -- user's syntax level setting
}


--- Functions ----------------------------------------------------------------

-- Run the given lua code string dynamically, showing the runView if 
-- successful or the errView if there is an error.
local function runLuaCode( luaCode )
	-- Clear user variable and functions tables from last run if any
	ct.userVars = {}
	ct.userFns = {}

	-- Load the Lua code dynamically and execute it
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

-- Write a Lua source code output file to save the generated code.
-- Put it next to the Java source file.
local function writeLuaCode( codeStr )
	-- Put the output file in the same location as the source but named "main.lua"
	local dir = env.dirAndFilenameOfPath( source.path )
	local outPath = dir .. "main.lua"

	-- If the file already exists, then only overwrite it if it looks like we created it
	local outFile = io.open( outPath, "r" )
	if outFile then
		local line2Marker = "local ct, this, _fn ="     -- our generated line 2 starts with this
		local oldLine1Marker = "this = {}; _fn = {}"    -- old version of generated line 1
		local line1 = outFile:read( "*l" )
		if not string.starts( line1, oldLine1Marker ) then
			local line2 = outFile:read( "*l" )
			io.close( outFile )
			if not string.starts( line2, line2Marker ) then
				print( "*** Can't generate main.lua because one already exists" )
				return
			end
		end
	end

	-- Write the Lua file
	outFile = io.open( outPath, "w" )
	if outFile then
		-- Start the main.lua with a package.path to enable standalone runs with the
		-- Lua runtime from test app folders in the Lua folder or one subfolder lower.
		outFile:write( "package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'" )
		
		-- Write the generated code
		outFile:write( codeStr )
		outFile:write( "\n" )

		-- Write the standalone init code
		outFile:write( "\nrequire('Code12.api')\nrequire('Code12.runtime').run()\n" )
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

-- Process the source (parse then run or show error), which has already been read. 
function app.processUserFile()
	print( "\n--- New Run ----------------------" )
	print( "source.path: " .. source.path )

	-- Stop existing run if any
	runtime.stopRun()

	-- Set the source dir and filename
	local appContext = runtime.appContext
	appContext.sourceDir, appContext.sourceFilename = 
			env.dirAndFilenameOfPath( source.path )

	-- Set the mediaBaseDir and the mediaDir.
	-- Good grief, Corona requires the path to images and sounds to be
	-- a relative path, not absolute, and the only reliable dir to be
	-- relative to seems to be the system.DocumentsDirectory.
	appContext.mediaBaseDir = env.baseDirDocs
	appContext.mediaDir = env.relativePath( env.docsDir, appContext.sourceDir )

	-- Clear the error state
	err.initProgram()

	-- Parse the user code then do further processing
	local startTime = system.getTimer()
	local programTree = parseProgram.getProgramTree( app.syntaxLevel )
	if programTree and not (err.hasErr() and app.oneErrOnly) then
		-- Do Semantic Analysis on the parse trees
		-- parseProgram.printProgramTree( programTree )
		checkJava.checkProgram( programTree, app.syntaxLevel )
		-- parseProgram.printProgramTree( programTree )
		if not err.hasErr() then
			-- Do code generation then run the Lua code
			local codeStr = codeGenJava.getLuaCode( programTree )
			print( string.format( "\nFile processed in %.3f ms\n", 
						system.getTimer() - startTime ) )
			writeLuaCode( codeStr )
			runLuaCode( codeStr )
			return
		end
	end

	-- Error in processing
	composer.gotoScene( "errView" )
end

-- Check user file for changes and (re)run it if modified or never loaded
local function checkUserFile()
	if source.path then
		-- Check the file modification time
		local timeMod = env.fileModTimeFromPath( source.path )
		if source.timeModLast == 0 then
			source.timeModLast = timeMod or os.time()
		end

		-- Consider the file updated if timeMod changed or if never loaded
		if source.timeLoaded == 0 
				or (timeMod and timeMod > source.timeModLast) then
			source.timeModLast = timeMod
			source.updated = true
		end

		-- (Re)Load and process the file if updated 
		if source.updated and source.readFile() then
			source.updated = false    -- until next time the file updates
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
	userSettings.recentPath = source.path
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
						source.path = userSettings.recentPath
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
	-- Make the app context for the Code12 runtime to use
	runtime.appContext = {}

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

