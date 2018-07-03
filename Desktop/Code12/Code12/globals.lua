-----------------------------------------------------------------------------------------
--
-- globals.lua
--
-- The global state for the Code 12 Lua Runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- The global state table
local g = {
	-- The runtime version number
	version = 0.1,

	-- Platform info
	platform = nil,        -- e.g. "android", "macos"
	isMobile = false,      -- true if iOS or Android
	isSimulator = false,   -- true if running on Corona Simulator

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
	screens = {},       -- Table of screens indexed by: name = { name = n, group = g }
	screen = nil,       -- current screen in screens table

	-- Input state
	clicked = false,       -- true if something was clicked during this update frame
	gameObjClicked = nil,  -- Object clicked during this update frame, nil if none
	clickX = 0,            -- Last click x location 
	clickY = 0,            -- Last click x location 
	charTyped = nil,       -- char typed during this update frame (string), nil if none

	-- Run state
	startTime = nil,       -- System time in ms when start function began, or nil before
	blocked = false,       -- true if user code is blocked on user input
	stopped = false,       -- true if run was stopped or failed
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


------------------------------------------------------------------------------

return g
