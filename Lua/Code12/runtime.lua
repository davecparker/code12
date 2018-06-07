-----------------------------------------------------------------------------------------
--
-- runtime.lua
--
-- Implementation of the main runtime object (ct) for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")


-- The main Code 12 global runtime object, where the "global" APIs live
ct = {}


---------------- Internal Functions ------------------------------------------


-- The enterFrame listener for each frame update after the first
local function onNewFrame(event)
	-- Call the client's update function if any
	if type(update) == "function" then
		update()
	end

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
	-- Call client's start method if any
	if type(start) == "function" then
		start()
	end

	-- Sync the drawing objects for the first draw
	local objs = g.screen.objs
	for i = 1, objs.numChildren do
		objs[i].code12GameObj:sync()
	end

	-- Start the game timer
	g.startTime = system.getTimer()

	-- Switch to the normal frame update handler for subsequent frames
	Runtime:removeEventListener("enterFrame", onFirstFrame)
	Runtime:addEventListener("enterFrame", onNewFrame)
end

-- Get the device metrics in native units (in portrait configuration if mobile)
local function getDeviceMetrics()
	-- Get device metrics 
	g.device.horz.origin = display.screenOriginX
	g.device.horz.size = display.actualContentWidth
	g.device.vert.origin = display.screenOriginY
	g.device.vert.size = display.actualContentHeight
end

-- Handle a window resize event (desktop only)
local function onResize(event)
	local oldHeight = g.height
	
	-- Get new device metrics
	getDeviceMetrics()

	-- Adjust main origin
	g.mainGroup.x = g.device.horz.origin
	g.mainGroup.y = g.device.vert.origin

	-- Set new logical height
	ct.setHeight(g.WIDTH * g.device.vert.size / g.device.horz.size)

	-- Adjust objects as necessary
	local objs = g.screen.objs
	for i = 1, objs.numChildren do
		objs[i].code12GameObj:adjustForWindowResize(oldHeight, g.height)
	end
end


-- Init the Code 12 system
function ct.initRuntime()
	-- Get platform and determine if we are on a desktop vs. mobile device
	g.platform = system.getInfo("platform")
	g.isMobile = (g.platform == "android" or g.platform == "ios")
	g.isSimulator = (system.getInfo("environment") == "simulator")

	-- Get the initial device metrics, and set to portrait for now
	getDeviceMetrics()
	g.window.horz = g.device.horz
	g.window.vert = g.device.vert

	-- Calculate height and scale in logical coordinates
	g.height = g.WIDTH * g.window.vert.size / g.window.horz.size
	g.scale = g.window.horz.size / g.WIDTH

	-- Create a main outer display group so that we can rotate and place it 
	-- to change orientation (portrait to landscape). Also, the origin of this group
	-- corrects for Corona's origin not being at the device upper left.
	g.mainGroup = display.newGroup()
	g.mainGroup.x = g.device.horz.origin
	g.mainGroup.y = g.device.vert.origin

	-- Runtime parameter check option: defaults to true, can be changed by client
	ct.checkParams = true

	-- Make the first screen with default empty name
	ct.setScreen("")

	-- Get the Corona runtime ready to run
	display.setStatusBar(display.HiddenStatusBar)   -- hide device status bar
	Runtime:addEventListener("enterFrame", onFirstFrame)
	Runtime:addEventListener("touch", g.onTouchRuntime)
	Runtime:addEventListener("key", g.onKey)
	if not g.isMobile then
		Runtime:addEventListener("resize", onResize)
	end
end

