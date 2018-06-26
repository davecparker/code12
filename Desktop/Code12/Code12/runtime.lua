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

--             -- These field are added by the runtime for use by the app
--             initRun = fnInitRun,      -- init and start a new run
--             stopRun = fnStopRun,      -- stop a run
--             onResize = fnOnResize,    -- notify runtime that app window has resized
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


---------------- Internal Functions ------------------------------------------

-- The enterFrame listener for each frame update after the first
local function onNewFrame(event)
	-- Call the client's update function if any
	g.callUserFunction( _fn.update )

	-- Clear the polled input state for this frame
	g.clicked = false
	g.gameObjClicked = nil
	g.charTyped = nil

	-- Update the background object if the screen resized since last time
	if g.window.resized then
		g.screen.backObj:updateBackObj()
	end

	-- Update then sync the drawing objects.
    -- Note that objects may be deleted during the loop. 
	local objs = g.screen.objs
	local i = 1
	while i <= objs.numChildren do
		-- Check for autoDelete first
		local gameObj = objs[i].code12GameObj
		if gameObj:shouldAutoDelete() then
			gameObj:removeAndDelete()
		else
			gameObj:update()
			gameObj:sync()
			i = i + 1
		end
	end

	-- We have now adapted to any window resize
	g.window.resized = false
end

-- The enterFrame listener for the first update only
local function onFirstFrame(event)
	-- Start the game timer
	g.startTime = system.getTimer()

	-- Call client's start method if any
	g.callUserFunction( _fn.start )

	-- Sync the drawing objects for the first draw
	local objs = g.screen.objs
	for i = 1, objs.numChildren do
		objs[i].code12GameObj:sync()
	end

	-- Switch to the normal frame update handler for subsequent frames
	Runtime:removeEventListener("enterFrame", onFirstFrame)
	Runtime:addEventListener("enterFrame", onNewFrame)
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
local function onResize()
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

	-- Send user event if necessary
	g.callUserFunction( _fn.onResize )
	g.window.resized = true
end

-- Stop a run
local function stopRun()
	-- Remove the event listeners (only some may be installed)
	Runtime:removeEventListener("enterFrame", onFirstFrame)
	Runtime:removeEventListener("enterFrame", onNewFrame)
	Runtime:removeEventListener("touch", g.onTouchRuntime)
	Runtime:removeEventListener("key", g.onKey)
	Runtime:removeEventListener("resize", onResize)

	-- Destroy the main display group, screens, and display objects
	if g.mainGroup then
		g.mainGroup:removeSelf()  -- deletes contained screen and object groups
		g.mainGroup = nil
	end
	g.screens = {}
	g.screen = nil

	-- Clear misc global game state
	g.startTime = nil
	g.clicked = false
	g.gameObjClicked = nil
	g.clickX = 0
	g.clickY = 0
	g.charTyped = nil
end	

-- Init for a new run of the user program after the user's code has been loaded
local function initRun()
	-- Stop any existing run in case it wasn't ended explicitly
	stopRun()

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
	Runtime:addEventListener("touch", g.onTouchRuntime)
	Runtime:addEventListener("key", g.onKey)
	if appContext == nil and not g.isMobile then
		Runtime:addEventListener("resize", onResize)  -- for standalone window resize
	end
end


---------------- Public Functions --------------------------------------------

-- Call the given user-defined function if it exists.
-- Run the function in a coroutine so it can yield to wait for console input
-- if necessary.
function g.callUserFunction( func, ... )
	if type(func) == "function" then
		assert( not coroutine.running() )
		if not coroutine.running() then
			local co = coroutine.create( func )
			if co then
				local success, result = coroutine.resume(co, ...)
				if success then
					if coroutine.status(co) == "dead" then
						return result   -- User function completed normally
					end
				else
					-- TODO: Handle runtime error
					print("*** Runtime Error: " .. result)
					ct.print("*** Runtime Error: ")
					ct.println(result)
				end
			end
		end
	end
end

-- Init the Code 12 runtime system.
-- If running standalone then also start the run, otherwise wait for app to start it.
function ct.initRuntime()
	-- Get platform and determine if we are on a desktop vs. mobile device
	g.platform = system.getInfo("platform")
	g.isMobile = (g.platform == "android" or g.platform == "ios")
	g.isSimulator = (system.getInfo("environment") == "simulator")	

	-- Install app callbacks if in app context, otherwise start a standalone run
	if appContext then
		appContext.initRun = initRun
		appContext.stopRun = stopRun
		appContext.onResize = onResize
	else
		initRun()
	end
end

