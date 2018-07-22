-----------------------------------------------------------------------------------------
--
-- runtime.lua
--
-- Implementation of the main runtime object (ct) for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")


-- The global "ct" table is the main Code 12 global runtime object, 
-- where the "global" APIs live. If we are running in the context of the
-- Code12 Desktop App, then ct has already been created by the app and
-- should contain fields as follows:
--     ct = {
--         _appContext = {
--             sourceDir = string,       -- dir where user code is (absolute)
--             sourceFilename = string,  -- user code filename (in sourceDir)
--             mediaBaseDir = (const),   -- Corona baseDir to use for media files  
--             mediaDir = string,        -- media dir relative to mediaBaseDir
--             outputGroup = group,      -- display group where output should go
--             widthP = number,          -- pixel width of output area
--             heightP = number,         -- pixel height of output area
--             setClipSize = function,   -- called by runtime to specify output size
--             print = function,         -- called by runtime for console output
--             println = function,       -- called by runtime for console output
--             inputString = function,   -- called by runtime for console input
--             runtimeErr = function,    -- called by runtime on runtime error
--         },
--         ct.checkParams = true,        -- true to check API params at runtime
--     }
-- If running standalone (e.g. for a Corona SDK build), then ct starts out nil
-- and we create it here, with no _appContext field.
local appContext
if ct then
	appContext = ct._appContext
else
	-- Standalone
	ct = {
		checkParams = true,
	}
	appContext= nil
end

-- File local state
local coRoutineUser = nil    -- coroutine running an event or nil if none


---------------- Runtime Functions ------------------------------------------

-- The enterFrame listener for each frame update after the first
local function onNewFrame()
	-- Call or resume the client's update function if any
	local yielded = g.eventFunctionYielded(_fn.update)
	if g.stopped then
		return
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
			if not yielded then
				gameObj:update()
			end
			gameObj:sync()
			i = i + 1
		end
	end

	-- We have now adapted to any window resize
	g.window.resized = false
end

-- The enterFrame listener for the first update only
local function onFirstFrame()
	-- Call or resume the client's start method if any
	local yielded = g.eventFunctionYielded(_fn.start)
	if g.stopped then
		return
	end

	-- Flush the output file if any, to make sure at least 
	-- output done in start() gets written, in case we abort later.
	if g.outputFile then
		g.outputFile:flush()
	end

	-- Sync the drawing objects for the draw
	local objs = g.screen.objs
	for i = 1, objs.numChildren do
		objs[i].code12GameObj:sync()
	end

	-- If start() finished then switch to the normal frame update 
	-- handler for subsequent frames
	if not yielded then
		Runtime:removeEventListener("enterFrame", onFirstFrame)
		Runtime:addEventListener("enterFrame", onNewFrame)
	end
end

-- Get the device/output metrics in native units
local function getDeviceMetrics()
	-- If running with an appContext then get the metrics from the app.
	-- Otherwise get the physical device metrics for a standalone run.
	if appContext then
		g.device.width = appContext.widthP
		g.device.height = appContext.heightP
	else
		g.device.width = display.actualContentWidth
		g.device.height = display.actualContentHeight
	end
end

-- Handle a window resize for a standalone resizeable app
function g.onResize()
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
	g.eventFunctionYielded(_fn.onResize)
end

-- Stop a run
function g.stopRun()
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
	Runtime:removeEventListener("resize", g.onResize)

	-- Destroy the main display group, screens, and display objects
	if g.mainGroup then
		g.mainGroup:removeSelf()  -- deletes contained screen and object groups
		g.mainGroup = nil
	end
	g.screens = {}
	g.screen = nil

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

	-- Set game state for a stopped run
	g.startTime = nil
	g.modalDialog = false
	g.stopped = true
	g.blocked = false
end	

-- Handle the result of the two return values from a coroutine.resume call,
-- and check the status of the coroutine to adjust the running state,
-- and return true if the coroutine yielded or false if it completed.
local function coroutineYielded(success, strErr)
	if success then
		if coroutine.status(coRoutineUser) == "dead" then
			-- The user code finished
			coRoutineUser = nil
			g.blocked = false
			return false
		end
		-- The user code blocked and yielded
		g.blocked = true
		return true
	else
		-- Runtime error
		g.stopRun()
		print("\n*** Runtime Error: " .. strErr)
		-- Did the error occur in user code or Code12?
		local strLineNum, strMessage = string.match( strErr, "%[string[^:]+:(%d+):(.*)" )
		if strLineNum then
			-- Error was in user code, report to the appContext if any 
			local lineNum = tonumber( strLineNum ) 
			if lineNum and appContext.runtimeErr then
				-- Recognize Lua's equivalent of a null pointer exception
				if string.find( strErr, "attempt to index" ) 
						and string.find( strErr, "a nil value") then
					strMessage = "object is null, cannot access fields or methods"
				end
				appContext.runtimeErr(lineNum, strMessage)
				return
			end
			strErr = "Line " .. strLineNum .. ": " .. strMessage  -- for standalone runs
		end
		-- Looks like a runtime error in Code12. Report the full message in an alert.
		-- TODO: For production, report "unknown runtime error" or something.
		native.showAlert( "Runtime Error", strErr, { "OK" } )
		return false
	end
end

-- If a user event function coroutine is already running then give it another 
-- time slice and return true if it yielded again or false it if completed. 
-- If no coroutine is already running, then start a coroutine to run the
-- given function (if not nil), passing the additional parameters given, 
-- and return true if the coroutine yielded or false if it completed.
function g.eventFunctionYielded( func, ... )
	-- Is a coroutine already running?
	if coRoutineUser then
		local success, strErr = coroutine.resume(coRoutineUser)
		return coroutineYielded(success, strErr)
	end

	-- Is there a valid function to start?
	if type(func) == "function" then
		coRoutineUser = coroutine.create(func)
		if coRoutineUser then
			-- Start the user function, passing its parameters
			local success, strErr = coroutine.resume(coRoutineUser, ...)
			return coroutineYielded(success, strErr)
		end
	end
	return false
end

-- Block and yield the user's code, then return any message from the
-- main thread, in particular it might be "abort".
function g.blockAndYield()
	if coRoutineUser then
		return coroutine.yield()
	end
end

-- Init for a new run of the user program after the user's code has been loaded
function g.initRun()
	-- Stop any existing run in case it wasn't ended explicitly
	g.stopRun()

	-- Create a main outer display group so that we can rotate and place it 
	-- to change orientation (portrait to landscape). Also, the origin of this group
	-- corrects for Corona's origin possibly not being at the device upper left.
	g.mainGroup = display.newGroup()
	g.mainGroup.finalize = function () g.mainGroup = nil end   -- in case parent kills it

	-- If in an app context then put the main display group inside the app's output group,
	-- otherwise prepare to use the entire device screen.
	if appContext then
		appContext.outputGroup:insert( g.mainGroup )
	else
		display.setStatusBar(display.HiddenStatusBar)   -- hide device status bar
	end

	-- Get the device metrics and set the default height
	getDeviceMetrics()
	ct.setHeight( g.WIDTH )

	-- Make the first screen with default empty name
	ct.setScreen("")

	-- Install the event listeners
	Runtime:addEventListener("enterFrame", onFirstFrame)  -- will call user's start()
	Runtime:addEventListener("key", g.onKey)
	if appContext == nil and not g.isMobile then
		Runtime:addEventListener("resize", g.onResize)  -- for standalone window resize
	end

	-- Start the game and the game timer
	g.stopped = false
	g.startTime = system.getTimer()
end


---------------- Special Runtime Init Function -------------------------------

-- Init the Code12 runtime system.
-- If running standalone then also start the run, otherwise wait for app to start it.
function ct.initRuntime()
	-- Get platform and determine if we are on a desktop vs. mobile device
	g.platform = system.getInfo("platform")
	g.isMac = (g.platform == "macos")
	g.isMobile = (g.platform == "android" or g.platform == "ios")
	g.isSimulator = (system.getInfo("environment") == "simulator")	

	-- Start the run if running standalone
	if not appContext then
		g.initRun()
	end
end

