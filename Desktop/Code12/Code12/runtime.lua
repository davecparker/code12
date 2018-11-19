-----------------------------------------------------------------------------------------
--
-- runtime.lua
--
-- Implementation of the main runtime for the Code12 Lua runtime.
--
-- (c)Copyright 2018 by Code12. All Rights Reserved.
-----------------------------------------------------------------------------------------


-- Runtime support modules
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
	--     arrayAssigned = function, -- called by runtime when an array var is assigned
	-- },
}


-- File local state
local codeFunction       -- function for the loaded Lua user program        
local coRoutineUser      -- coroutine running an event or nil if none
local rgbWarningText = { 0.9, 0, 0.1 }   -- warning text displays in red



---------------- Internal Runtime Functions ------------------------------------------

-- Apply xSpeed and ySpeed to all the objects in the screen
-- and delete any that went out of bounds.
local function applyObjectSpeeds(screen)
	-- Objects using xSpeed and ySpeed automatically get deleted if they
	-- go more than 100 units off-screen. 
	local xMin = screen.originX - 100
	local xMax = xMin + g.WIDTH + 200
	local yMin = screen.originY - 100
	local yMax = yMin + g.height + 200

	-- Look for objects with hasSpeed set
	local objs = screen.objs
	for i = objs.numChildren, 1, -1 do
		local gameObj = objs[i].code12GameObj
		if gameObj.hasSpeed then
			-- Apply the speed
			local x = gameObj.x + gameObj.xSpeed
			local y = gameObj.y + gameObj.ySpeed
			gameObj.x = x
			gameObj.y = y

			-- Delete object if it went out of bounds
			if x < xMin or x > xMax or y < yMin or y > yMax then
				gameObj:removeAndDelete()
			end
		end
	end
end

-- Update the display objects in group from their GameObj positions and visibility
-- at the scale. If setSize then update the object size as well for the new scale.
local function syncObjects(group, scale, setSize)
	for i = 1, group.numChildren do
		local obj = group[i]
		local gameObj = obj.code12GameObj
		obj.isVisible = gameObj.visible
		obj.x = gameObj.x * scale
		obj.y = gameObj.y * scale
		if setSize then
			gameObj:updateSize(gameObj.width, gameObj.height, scale)
		end
	end
end

-- The enterFrame listener for each frame update
local function onNewFrame()
	-- Call or resume the current user function if not paused (start or update)
	local status = false
	local runState = g.runState
	local userFn = g.userFn
	if userFn and runState ~= "paused" then
		status = runtime.runEventFunction(userFn)
		if status == nil then   -- userFn finished
			if userFn == ct.userFns.start then
				-- User's start function finished
				if g.outputFile then
					g.outputFile:flush()   -- flush any print output
				end
				g.userFn = ct.userFns.update  -- now start calling update if defined
			end
		elseif status == "aborted" then
			return
		end
	end

	-- Clear the polled input state for this frame
	g.clicked = false
	g.gameObjClicked = nil
	g.charTyped = nil

	-- Update drawing objects as necessary
	local screen = g.screen
    if screen then
		local objs = screen.objs

		-- Apply speed to objects if screen has any and the program is running 
		-- and userFn didn't yield (which interrupts the update cycle).
		if screen.hasSpeed and runState == "running" and status ~= "yielded" then
			applyObjectSpeeds(screen)
		end

		-- If the window resized then we need to resize all the contents
		local scale = g.scale
		if g.window.resized then
			-- Background object
			screen.backObj:updateBackObj()
			-- Screen origin
			objs.x = -screen.originX * scale
			objs.y = -screen.originY * scale
			-- Graphic objects
			syncObjects(objs, scale, true)
			g.window.resized = false
		else
			-- Just sync object positions and visibility
			syncObjects(objs, scale)
		end
	end
end

-- Global key event handler for the runtime
local function onKey(event)
	if g.runState == "running" then
		return g.onKey(event)
	end
	return false
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
			-- User code requests a restart via ct.restart()
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

-- Init the runtime
local function initRuntime()
	-- Install the global event listeners
	Runtime:addEventListener("enterFrame", onNewFrame)
	Runtime:addEventListener("key", onKey)
end


---------------- Module Functions ------------------------------------------

-- Load the given string of Lua code as the user program and init the program.
-- Return an error string if the program failed to load, or nil for success.
function runtime.strErrLoadLuaCode(luaCode)
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
function runtime.runEventFunction(func, ...)
	-- Is a coroutine already running?
	if coRoutineUser then
		if coroutine.status(coRoutineUser) == "dead" then
			coRoutineUser = nil
		else
			local success, strErr = coroutine.resume(coRoutineUser)
			return coroutineStatus(success, strErr)
		end
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

-- Sync drawing objects on the current screen after possible changes
function runtime.syncScreenObjects()
	local screen = g.screen
	if screen then
		syncObjects(screen.objs, g.scale)
	end
end

-- Run the user input (mouse or keyboard) event func if any.
-- Return result per runtime.runEventFunction().
function runtime.runInputEvent(func, ...)
	if func then
		local result = runtime.runEventFunction(func, ...)
		runtime.syncScreenObjects()  -- in case screen redraws before next enterFrame
		return result
	end
	return false
end

-- Handle a resize of the available output area
-- TODO: max once per frame?
function runtime.onResize()
	-- Get new metrics
	getDeviceMetrics()

	-- Set new logical height (sets g.height and g.scale)
	ct.setHeight(g.WIDTH * g.window.height / g.window.width)

	-- Mark window as resized
	g.window.resized = true

	-- Send user event if necessary
	if g.runState == "running" then
		runtime.runEventFunction(ct.userFns.onResize)
	end
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

-- When the run state is paused, advance one frame then pause again.
function runtime.stepOneFrame()
	if g.runState == "paused" then
		g.runState = "running"
		onNewFrame()
		g.runState = "paused"
	end
end

-- Return true if the stepOneFrame operation can currently be performed.
function runtime.canStepOneFrame()
	-- Can step if we are between frames, not pause in user code
	return coRoutineUser == nil
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
	g.userFn = nil
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

	-- Start the game and the game timer
	g.runState = "running"
	g.userFn = ct.userFns.start
	g.startTime = system.getTimer()
	-- Now onNewFrame called by enterFrame listener will start the action
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

-- Output the given text to where console output should go
function runtime.printText(text)
	if runtime.appContext then
		runtime.appContext.print(text)     -- Code12 app console
	elseif g.isSimulator then
		io.write(text)             -- Corona simulator console
		io.flush()
	end
	if g.outputFile then
		g.outputFile:write(text)   -- echo to text file
	end
end

-- Output the given text plus a newline to where console output should go.
-- if rgb is included then it is an array {r, g, b} (each 0-1) for the 
-- color to assign to the line if possible.
function runtime.printTextLine(text, rgb)
	if runtime.appContext then
		runtime.appContext.println(text, rgb)   -- Code12 app console
	elseif g.isSimulator then
		io.write(text)             -- Corona simulator console
		io.write("\n")
		io.flush()
	end
	if g.outputFile then
		g.outputFile:write(text)   -- echo to text file
		g.outputFile:write("\n")
	end
end

-- Return the current line number in the user's code or nil if unknown
local function userLineNumber()
	-- Look back on the stack trace to find the user's code (string)
	-- so we can get the line number.
	local info
	local level = 1
	repeat
		info = debug.getinfo(level, "Sl")
		level = level + 1
	until info == nil or info.short_src == '[string "..."]'
	if info then
		return info.currentline
	end
	return nil
end

-- Print a runtime message to the console, followed by "at line #"
-- if the user's code line number can be determined.
function runtime.message(message)
	local lineNum = userLineNumber()
	if lineNum then
		message = message .. " at line " .. lineNum
	end
	runtime.printTextLine(message, rgbWarningText)
end

-- Print a warning message to the console with optional quoted name
function runtime.warning(message, name)
	local s
	local lineNum = userLineNumber()
	if lineNum then
		s = "WARNING (line " .. lineNum .. "): " .. message
	else
		s = "WARNING: " .. message
	end
	if name then
		s = s .. " \"" .. name .. "\""
	end
	runtime.printTextLine(s, rgbWarningText)
end


----------------------------------------------------------------------------

-- Init and return the runtime module
initRuntime()
return runtime

