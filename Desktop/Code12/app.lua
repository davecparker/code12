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
	consoleFont = "NotoMono-Regular.ttf",
	consoleFontSize = 14,

	-- Measured metrics
	consoleFontHeight = 0,       -- pixel height of console text line
	consoleFontCharWidth = 0,    -- pixel width of console text (fixed width font) 
	width = 0,                   -- app window width
	height = 0,                  -- app window height
	outputWidth = 0,             -- width for the output area
	outputHeight = 0,            -- height for the output area
}


------------------------------------------------------------------------------
return app
