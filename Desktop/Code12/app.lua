-----------------------------------------------------------------------------------------
--
-- app.lua
--
-- Application global data and functions for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- Global data
local app =  {
	-- Gray shades for the UI
	toolbarShade = 0.8,
	extraShade = 0.9,
	borderShade = 0.5,

	-- Fonts
	consoleFont = "Consolas",
	consoleFontSize = 16,

	-- Measured metrics
	consoleFontHeight = 0,       -- pixel height of console text line
	consoleFontCharWidth = 0,    -- pixel width of console text (fixed width font) 
	width = 0,                   -- app window width
	height = 0,                  -- app window height
	outputWidth = 0,             -- width for the output area
	outputHeight = 0,            -- height for the output area
}


--- Utility Functions ------------------------------------------------

-- Pin a value within a range
function app.pinValue( value, min, max )
	if value < min then
		return min
	elseif value > max then
		return max
	end
	return value
end

-- Create and return a display group in parent, optionally located at x, y
function app.makeGroup( parent, x, y )
	local g = display.newGroup()
	if parent then
		parent:insert( g )
	end
	g.x = x or 0
	g.y = y or 0
	return g
end

-- Change the given display object to be top-left anchored 
-- with the given grayscale shades for the fill (default black) 
-- and stroke (default none)
function app.uiItem( obj, fillShade, lineShade )
	if obj then
		obj.anchorX = 0
		obj.anchorY = 0
		obj:setFillColor( fillShade or 0 ) 
		if lineShade then
			obj.strokeWidth = 1
			obj:setStrokeColor( lineShade )
		end
	end
	return obj
end

-- Change the given display object to be top-left anchored and white
function app.uiWhite( obj )
	return app.uiItem( obj, 1 )
end

-- Change the given display object to be top-left anchored and black
function app.uiBlack( obj )
	return app.uiItem( obj, 0 )
end


------------------------------------------------------------------------------
return app