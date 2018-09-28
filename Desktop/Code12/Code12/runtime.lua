-----------------------------------------------------------------------------------------
--
-- runtime.lua
--
-- Implementation of the main runtime object (ct) for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local ct = require("Code12.ct")
local g = require("Code12.globals")


-- The runtime module and data
local runtime = {
	-- The appContext table is set by main.lua when running the Code12 app,
	-- or left nil when running a generated Lua app standalone.
	-- appContext = {
	--     sourceDir = string,       -- dir where user code is (absolute)
	--     sourceFilename = string,  -- user code filename (in sourceDir)
	--     mediaBaseDir = (const),   -- Corona baseDir to use for media files  
	--     mediaDir = string,        -- media dir relative to mediaBaseDir
	--     outputGroup = group,      -- display group where output should go
	--     widthP = number,          -- pixel width of output area
	--     heightP = number,         -- pixel height of output area
	--     setClipSize = function,   -- called by runtime to specify output size
	--     clearConsole = function,  -- called by runtime to clear console output
	--     print = function,         -- called by runtime for console output
	--     println = function,       -- called by runtime for console output
	--     runtimeErr = function,    -- called by runtime on runtime error
	-- },
}


-- File local state
local codeFunction       -- function for the loaded Lua user program        
local coRoutineUser      -- coroutine running an event or nil if none


---------------- Internal Runtime Functions ------------------------------------------

-- The enterFrame listener for each frame update after the first
local function onNewFrame()
	-- Call or resume the client's update function if not paused
	local status = false
	if g.runState ~= "paused" then
		status = runtime.runEventFunction(ct.userFns.update)
		if status == "aborted" then
			return
		end
	end

	-- Clear the polled input state for this frame
	g.clicked = false
	g.gameObjClicked = nil
	g.charTyped = nil

	-- Update the background object if the screen resized since last time
	if g.window.resized then
		g.screen.backObj:updateBackObj()
	end

	-- Update and sync the drawing objects as necessary.
    -- Note that objects may be deleted during the loop. 
	local objs = g.screen.objs
	local i = 1
	while i <= objs.numChildren do
		-- Check for autoDelete first
		local gameObj = objs[i].code12GameObj
		if gameObj:shouldAutoDelete() then
			gameObj:removeAndDelete()
		else
			-- Update objects if running and update completed
			if g.runState == "running" and status == nil then
				gameObj:updateForNextFrame()
			end
			-- Always sync the objects so the display is correct
			gameObj:sync()
			i = i + 1
		end
	end

	-- We have now adapted to any window resize
	g.window.resized = false
end

-- The enterFrame listener for the first update only
local function onFirstFrame()
	-- Call or resume the client's start function if not paused
	local status = false
	if g.runState ~= "paused" then
		status = runtime.runEventFunction(ct.userFns.start)
		if status == "aborted" then
			return
		end
	end

	-- Flush the output file if any, to make sure at least 
	-- output done in start() gets written, in case we abort later.
	if g.outputFile then
		g.outputFile:flush()
	end

	-- Update the background object if the screen resized since last time
	if g.window.resized then
		g.screen.backObj:updateBackObj()
	end

	-- Sync the drawing objects for the draw
	local objs = g.screen.objs
	for i = 1, objs.numChildren do
		objs[i].code12GameObj:sync()
	end

	-- If start() finished then switch to the normal frame update 
	-- handler for subsequent frames, if any
	if g.runState == "running" and status == nil then
		Runtime:removeEventListener("enterFrame", onFirstFrame)
		if ct.userFns.update then
			Runtime:addEventListener("enterFrame", onNewFrame)
		else
			-- There is no update function, so done after start
			runtime.stop( "ended" )
		end
	end

	-- We have now adapted to any window resize
	g.window.resized = false
end

-- Get the device/output metrics in native units
local function getDeviceMetrics()
	-- If running with an appContext then get the metrics from the app.
	-- Otherwise get the physical device metrics for a standalone run.
	if runtime.appContext then
		g.device.width = runtime.appContext.widthP
		g.device.height = runtime.appContext.heightP
	else
		g.device.width = display.actualContentWidth
		g.device.height = display.actualContentHeight
	end
end

-- Handle the result of the two return values from a coroutine.resume call,
-- check the status of the coroutine to adjust the running state,
-- and return the status as "yielded", "aborted", nil if completed.
local function coroutineStatus(success, strErr)
	if success then
		if coroutine.status(coRoutineUser) == "dead" then
			-- The user code finished
			coRoutineUser = nil
			return nil
		elseif strErr == "stop" then
			-- User code requests a stop via ct.stop()
			runtime.stop()
			return "aborted"
		elseif strErr == "restart" then
			-- User code requests a stop via ct.restart()
			runtime.restart()
			return "aborted"
		end
		-- The user code yielded (e.g. input dialog, or ct.pause())
		return "yielded"
	end

	-- Runtime error
	local strLineNum, strMessage = string.match( strErr, "%[string[^:]+:(%d+):(.*)" )
	if strLineNum then
		-- Runtime error in user code, report to the appContext if any 
		coRoutineUser = nil
		runtime.stop()
		print("\n*** Runtime Error: " .. strErr)
		local lineNum = tonumber( strLineNum ) 
		if lineNum and runtime.appContext and runtime.appContext.runtimeErr then
			-- Recognize Lua's equivalent of a null pointer exception
			if string.find( strErr, "attempt to index" ) 
					and string.find( strErr, "a nil value") then
				strMessage = "object is null, cannot access fields or methods"
			end
			runtime.appContext.runtimeErr(lineNum, strMessage)
			return "aborted"
		end
		-- For standalone runs, let app abort below but improve the message
		strErr = "Line " .. strLineNum .. ": " .. strMessage
	end

	-- Looks like a runtime error in Code12. Report the full message in an alert.
	-- TODO: For production, report "unknown runtime error" or something.
	native.showAlert( "Runtime Error", strErr, { "OK" } )
	return "aborted"
end

-- Init the user program data state and run the codeFunction main chunk
-- to init the class-level variables and define the user functions.
local function initUserProgram()
	if codeFunction then
		ct.userVars = {}
		ct.userFns = {}
		codeFunction()
	end
end


---------------- Module Functions ------------------------------------------

-- Load the given string of Lua code as the user program and init the program.
-- Return an error string if the program failed to load, or nil for success.
function runtime.strErrLoadLuaCode( luaCode )
	-- Load the code and execute the main chunk if successful
	local strErr
	codeFunction, strErr = loadstring( luaCode )
	if codeFunction then
		initUserProgram()
	end
	return strErr
end

-- If a user event function coroutine is already running then resume it, 
-- otherwise start a coroutine to run the given function if not nil, 
-- passing the additional parameters given.
-- Return the coroutine's status as "yielded", "aborted", nil if completed, or
-- false if not run because func was nil or could not be run.
function runtime.runEventFunction( func, ... )
	-- Is a coroutine already running?
	if coRoutineUser then
		local success, strErr = coroutine.resume(coRoutineUser)
		return coroutineStatus(success, strErr)
	end

	-- Is there a valid function to start?
	if type(func) == "function" then
		coRoutineUser = coroutine.create(func)
		if coRoutineUser then
			-- Start the user function, passing its parameters
			local success, strErr = coroutine.resume(coRoutineUser, ...)
			return coroutineStatus(success, strErr)
		end
	end
	return false
end

-- Block and yield the user's code then return any message from the
-- main thread, in particular it might be "abort".
function runtime.blockAndYield(...)
	if coRoutineUser then
		return coroutine.yield(...)
	end
end

-- Handle a window resize for a standalone resizeable app
function runtime.onResize()
	local oldHeight = g.height    -- remember old height if any
	getDeviceMetrics()            -- get new device metrics

	-- Set new logical height (sets g.height and g.scale)
	ct.setHeight(g.WIDTH * g.window.height / g.window.width)

	-- Adjust objects on the current screen as necessary
	if oldHeight and g.screen then
		local objs = g.screen.objs
		for i = 1, objs.numChildren do
			objs[i].code12GameObj:adjustForWindowResize(oldHeight, g.height)
		end
	end
	g.window.resized = true

	-- Send user event if necessary
	runtime.runEventFunction(ct.userFns.onResize)
end

-- Pause a run
function runtime.pause()
	if g.runState == "running" then
		g.runState = "paused"
	end
end

-- Resume a paused run
function runtime.resume()
	if g.runState == "paused" then
		g.runState = "running"
	end
end

-- Stop a run and set the runState to endState (default "stopped")
function runtime.stop( endState )
	-- Abort the user coRoutine if necessary
	if coRoutineUser then
		if coroutine.status(coRoutineUser) ~= "dead" then
			coroutine.resume(coRoutineUser, "abort")
		end
		coRoutineUser = nil
	end

	-- Remove the event listeners (only some may be installed)
	Runtime:removeEventListener("enterFrame", onFirstFrame)
	Runtime:removeEventListener("enterFrame", onNewFrame)
	Runtime:removeEventListener("key", g.onKey)
	Runtime:removeEventListener("resize", runtime.onResize)

	-- Close output file if any
	if g.outputFile then
		g.outputFile:close()
		g.outputFile = nil
	end

	-- Clear global input state
	g.clicked = false
	g.gameObjClicked = nil
	g.clickX = 0
	g.clickY = 0
	g.charTyped = nil

	-- Set the run state and restart if requested
	g.runState = endState or "stopped"
	g.startTime = nil
end	

-- Start a new run of the user program after the user's code has been loaded
function runtime.run()
	-- Stop any existing run in case it wasn't ended explicitly
	runtime.stop()

	-- Create a main outer display group so that we can rotate and place it 
	-- to change orientation (portrait to landscape). Also, the origin of this group
	-- corrects for Corona's origin possibly not being at the device upper left.
	if g.mainGroup then
		g.mainGroup:removeSelf()  -- delete old contained screen and object groups
	end
	g.mainGroup = display.newGroup()
	g.mainGroup.finalize =        -- in case parent group kills it
			function () 
				g.mainGroup = nil 
			end

	-- If in an app context then put the main display group inside the app's output group
	-- and clear the console, otherwise prepare to use the entire device screen.
	if runtime.appContext then
		runtime.appContext.outputGroup:insert( g.mainGroup )
		runtime.appContext.clearConsole()
	else
		display.setStatusBar(display.HiddenStatusBar)   -- hide device status bar
	end

	-- Create empty screens array (destroy any existing ones)
	g.screens = {}
	g.screen = nil

	-- Get the device metrics and set the default height
	getDeviceMetrics()
	ct.setHeight( g.WIDTH )

	-- Make the first screen with default empty name
	ct.setScreen("")

	-- Install the event listeners
	Runtime:addEventListener("enterFrame", onFirstFrame)  -- will call user's start()
	Runtime:addEventListener("key", g.onKey)
	if runtime.appContext == nil and not g.isMobile then
		Runtime:addEventListener("resize", runtime.onResize)  -- for standalone window resize
	end

	-- Start the game and the game timer
	g.runState = "running"
	g.startTime = system.getTimer()
	-- Now onFirstFrame called by enterFrame listener will start the action
end

-- Restart the current user program if any
function runtime.restart()
	if codeFunction then
		-- Stop current run, re-init program data state, then start again
		runtime.stop()
		initUserProgram()
		runtime.run()
	end
end

-- Stop and clear the current user program if any
function runtime:clearProgram()
	runtime.stop()
	ct.userVars = nil
	ct.userFns = nil
	codeFunction = nil
	g.runState = nil
end


----------------------------------------------------------------------------

return runtime

