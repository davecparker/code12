-----------------------------------------------------------------------------------------
--
-- globals.lua
--
-- The global state and utility functions for the Code 12 Lua Runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- Ask Corona what platform we are running on
local platform = system.getInfo("platform")


-- The global state table
local g = {
	-- The runtime version number
	version = 0.5,

	-- Platform info
	platform = platform,
	isMac = (platform == "macos"),
	isMobile = (platform == "android" or platform == "ios"),
	isSimulator = (system.getInfo("environment") == "simulator"),	

	-- Device pixel metrics, set at init time and when the window resizes
	device = {
		width = 0,
		height = 0,
	},

	-- The pixel size being used for output, set by ct.setHeight()
	window = {
		width = 0,
		height = 0,
		resized = true,   -- true when resized since last update (force first size)
	},

	-- Default game metrics in logical coordinates
	WIDTH = 100,        -- logical width is always 100.0 by definition
	height = 0,         -- logical height, set at runtime
	scale = 0,          -- scale from logical to physical

	-- Display data structures 
	mainGroup = nil,    -- main outer Corona display group
	screens = nil,      -- Table of screens indexed by: name = { name = n, group = g }
	screen = nil,       -- current screen in screens table

	-- UI state shared by the app and the user program
	focusObj = nil,        -- object with the touch focus or nil if none

	-- Text output state
	outputFile = nil,      -- file handle for text output or nil for none

	-- Input state
	clicked = false,       -- true if something was clicked during this update frame
	gameObjClicked = nil,  -- Object clicked during this update frame, nil if none
	clickX = 0,            -- Last click x location 
	clickY = 0,            -- Last click x location 
	charTyped = nil,       -- char typed during this update frame (string), nil if none

	-- Run state
	runState = nil,        -- "running", "blocked", "stopped", or nil if no program
	startTime = nil,       -- System time in ms when start function began, or nil before
}


---------------- Utility Functions--------------------------------------------

-- Return value pinned within the range min to max
function g.pinValue(value, min, max)
	if type(value) ~= "number" or value < min then
		return min
	elseif value > max then
		return max
	end
	return value
end

-- Create and return a display group in parent, optionally located at x, y
function g.makeGroup(parent, x, y)
	local group = display.newGroup()
	if parent then
		parent:insert(group)
	end
	group.x = x or 0
	group.y = y or 0
	return group
end

-- Change the given display object to be top-left anchored 
-- with the given grayscale shades for the fill (default black) 
-- and stroke (default none)
function g.uiItem(obj, fillShade, lineShade)
	if obj then
		obj.anchorX = 0
		obj.anchorY = 0
		obj:setFillColor(fillShade or 0) 
		if lineShade then
			obj.strokeWidth = 1
			obj:setStrokeColor(lineShade)
		end
	end
	return obj
end

-- Change the given display object to be top-left anchored and white
function g.uiWhite(obj)
	return g.uiItem(obj, 1)
end

-- Change the given display object to be top-left anchored and black
function g.uiBlack(obj)
	return g.uiItem(obj, 0)
end

-- Set the touch focus to the given object or nil to release
function g.setFocusObj(obj)
	display.getCurrentStage():setFocus(obj)
	g.focusObj = obj
end


------------------------------------------------------------------------------

return g
