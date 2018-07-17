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
	enabledShade = 0.3,
	disabledShade = 0.7,

	-- Fonts
	consoleFont = "NotoMono-Regular.ttf",
	consoleFontSize = 14,
	fontSizeUI = 12,

	-- UI metrics
	margin = 10,                 -- generic margin to leave between many UI items
	dyToolbar = 40,              -- toolbar height
	dyStatusBar = 30,            -- status bar height

	-- Measured metrics
	consoleFontHeight = 0,       -- pixel height of console text line
	consoleFontCharWidth = 0,    -- pixel width of console text (fixed width font) 
	width = 0,                   -- app window width
	height = 0,                  -- app window height
	outputWidth = 0,             -- width for the output area
	outputHeight = 0,            -- height for the output area

	-- Misc constants
	numSyntaxLevels = 12,        -- number of different parsing levels

	-- The user source file
	sourceFile = {
		path = nil,              -- full pathname to the file
		timeLoaded = 0,          -- time this file was loaded
		timeModLast = 0,         -- last modification time or 0 if never
		strLines = {},           -- array of source code lines when read
	},

	-- User settings
	syntaxLevel = nil,           -- current syntax level
}


--- Global App Functions ----------------------------------------------------------------

-- Get device metrics and store them in the global table
function app.getWindowSize()
	app.width = display.actualContentWidth
	app.height = display.actualContentHeight
end


------------------------------------------------------------------------------
return app
