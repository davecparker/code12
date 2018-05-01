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

	-- Device metrics, set at init time
	device = {
		horz = { origin = 0, size = 0 },
		vert = { origin = 0, size = 0 },
	},

	-- These are device units with horz and vert swapped if landscape, set at init time.
	window = {
		horz = nil,
		vert = nil,
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

	-- Game state
	startTime = 0,         -- System time in ms when first udpate started
	clicked = false,       -- true if something was clicked during this update frame
	gameObjClicked = nil,  -- Object clicked during this update frame, nil if none
	clickX = 0,            -- Last click x location 
	clickY = 0,            -- Last click x location 
	charTyped = nil,       -- char typed during this update frame (string), nil if none
}


return g
