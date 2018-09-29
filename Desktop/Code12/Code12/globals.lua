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

	-- The run state
	runState = nil,    -- "running", "waiting", "paused", "stopped", "ended", "error", or nil
	startTime = nil,   -- System time in ms when start function began, or nil before
}


---------------- Color Names --------------------------------------------

-- Map color names to a 3 element array with 255-based r, g, b values.
local colors = {
    ["black"] =          { 0, 0, 0 },
    ["white"] =          {255, 255, 255},
    ["red"] =            {255, 0, 0},
    ["green"] =          {0, 255, 0},
    ["blue"] =           {0, 0, 255},
    ["cyan"] =           {0, 255, 255},
    ["magenta"] =        {255, 0, 255},
    ["yellow"] =         {255, 255, 0},
         
    ["gray"] =           {127, 127, 127},
    ["orange"] =         {255, 127, 0},
    ["pink"] =           {255, 192, 203},
    ["purple"] =         {64, 0, 127},
         
    ["light gray"] =     {191, 191, 191},
    ["light red"] =      {255, 127, 127},
    ["light green"] =    {127, 255, 127},
    ["light blue"] =     {127, 127, 255},
    ["light cyan"] =     {127, 255, 255},
    ["light magenta"] =  {255, 127, 255},
    ["light yellow"] =   {255, 255, 127},

    ["dark gray"] =      {64, 64, 64},
    ["dark red"] =       {127, 0, 0},
    ["dark green"] =     {0, 127, 0},
    ["dark blue"] =      {0, 0, 127},
    ["dark cyan"] =      {0, 127, 127},
    ["dark magenta"] =   {127, 0, 127},
    ["dark yellow"] =    {127, 127, 0},
}

-- Return the color (3-array) for the given color name, or gray if name not known.
-- Return nil if colorName is nil.
function g.colorFromName(colorName)
	if colorName == nil then
		return nil
	end
	local color = colors[string.lower(colorName)]
	if color then
		return color
	end
	g.warning("Unknown color name", colorName)
	return colors["gray"]
end


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
