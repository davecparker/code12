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
	--     print = function,         -- called by runtime for console output
	--     println = function,       -- called by runtime for console output
	--     inputString = function,   -- called by runtime for console input
	--     runtimeErr = function,    -- called by runtime on runtime error
	-- },
}


-- File local state
local coRoutineUser = nil    -- coroutine running an event or nil if none


---------------- Internal Runtime Functions ------------------------------------------

-- The enterFrame listener for each frame update after the first
local function onNewFrame()
	-- Call or resume the client's update function if any
	local yielded = runtime.eventFunctionYielded(ct.userFns.update)
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
	local yielded = runtime.eventFunctionYielded(ct.userFns.start)
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
	if runtime.appContext then
		g.device.width = runtime.appContext.widthP
		g.device.height = runtime.appContext.heightP
	else
		g.device.width = display.actualContentWidth
		g.device.height = display.actualContentHeight
	end
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
		runtime.stopRun()
		print("\n*** Runtime Error: " .. strErr)
		-- Did the error occur in user code or Code12?
		local strLineNum, strMessage = string.match( strErr, "%[string[^:]+:(%d+):(.*)" )
		if strLineNum then
			-- Error was in user code, report to the appContext if any 
			local lineNum = tonumber( strLineNum ) 
			if lineNum and runtime.appContext and runtime.appContext.runtimeErr then
				-- Recognize Lua's equivalent of a null pointer exception
				if string.find( strErr, "attempt to index" ) 
						and string.find( strErr, "a nil value") then
					strMessage = "object is null, cannot access fields or methods"
				end
				runtime.appContext.runtimeErr(lineNum, strMessage)
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


---------------- Module Functions ------------------------------------------

-- If a user event function coroutine is already running then give it another 
-- time slice and return true if it yielded again or false it if completed. 
-- If no coroutine is already running, then start a coroutine to run the
-- given function (if not nil), passing the additional parameters given, 
-- and return true if the coroutine yielded or false if it completed.
function runtime.eventFunctionYielded( func, ... )
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
function runtime.blockAndYield()
	if coRoutineUser then
		return coroutine.yield()
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
	runtime.eventFunctionYielded(ct.userFns.onResize)
end

-- Stop a run
function runtime.stopRun()
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

-- Start a new run of the user program after the user's code has been loaded
function runtime.run()
	-- Stop any existing run in case it wasn't ended explicitly
	runtime.stopRun()

	-- Create a main outer display group so that we can rotate and place it 
	-- to change orientation (portrait to landscape). Also, the origin of this group
	-- corrects for Corona's origin possibly not being at the device upper left.
	g.mainGroup = display.newGroup()
	g.mainGroup.finalize = function () g.mainGroup = nil end   -- in case parent kills it

	-- If in an app context then put the main display group inside the app's output group,
	-- otherwise prepare to use the entire device screen.
	if runtime.appContext then
		runtime.appContext.outputGroup:insert( g.mainGroup )
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
	if runtime.appContext == nil and not g.isMobile then
		Runtime:addEventListener("resize", runtime.onResize)  -- for standalone window resize
	end

	-- Start the game and the game timer
	g.stopped = false
	g.startTime = system.getTimer()
	-- Now onFirstFrame called by enterFrame listener will start the action
end


----------------------------------------------------------------------------

return runtime

