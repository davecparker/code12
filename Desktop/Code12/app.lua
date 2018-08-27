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
		timeLoaded = 0,          -- time this file was loaded or 0 if not loaded
		timeModLast = 0,         -- last modification time or 0 if unknown
		updated = false,         -- set to true when file update is detected
		strLines = {},           -- array of source code lines when read
	},

	-- User settings
	syntaxLevel = nil,           -- current syntax level
	tabWidth = 4,                -- current tab width

	-- Runtime state
	startTime = 0,               -- system time when app started
}


--- Global App Functions ----------------------------------------------------------------

-- Get device metrics and store them in the global table
function app.getWindowSize()
	app.width = display.actualContentWidth
	app.height = display.actualContentHeight
end

-- Print str to file if file is not nil, else to the console
function app.printDebugStr( str, file )
	if file then
		file:write( str )
		file:write( "\n" )
	else 
		print( str )
	end
end

-- Return a detabbed version of string strLine
function app.detabLine( strLine )
	local chars = { string.byte( strLine, 1, string.len(strLine) ) }
	local numChars = #chars
	local charsDetabbed = {}
	local tabWidth = app.tabWidth
	local col = 1
	for i = 1, numChars do
		local ch = chars[i]
		if ch == 9 then -- Tab
			-- Insert spaces to replace the tab
			local numSpaces = tabWidth - (col - 1) % tabWidth
			for j = 1, numSpaces do
				charsDetabbed[col] = 32 -- Space
				col = col + 1
			end	
		else
			-- Copy the non-tab character
			charsDetabbed[col] = ch
			col = col + 1
		end
	end
	return string.char( unpack( charsDetabbed ) )
end

-- Return corresponding column indices iColStart and iColEndFor the given string
-- strLine and character indices iCharStart and iCharEnd (if iCharEnd is not
-- given, iColEnd will correspond to the end of strLine)
function app.iCharToICol( strLine, iCharStart, iCharEnd )
	local chars = { string.byte( strLine, 1, string.len(strLine) ) }
	local numChars = #chars
	local iColStart = iCharStart
	local iColEnd
	if iCharEnd then
		iColEnd = iCharEnd
	else
		iColEnd = numChars
	end
	local tabWidth = app.tabWidth
	local col = 1
	for i = 1, numChars do
		local ch = chars[i]
		if ch == 9 then -- Tab
			local numSpaces = tabWidth - (col - 1) % tabWidth
			-- if needed, increment iColStart and iColEnd
			if col < iColStart then
				iColStart = iColStart + numSpaces - 1
				iColEnd = iColEnd + numSpaces - 1
			elseif col <= iColEnd then
				iColEnd = iColEnd + numSpaces - 1
			end
			col = col + numSpaces
		else
			col = col + 1
		end
	end
	return iColStart, iColEnd
end
------------------------------------------------------------------------------
return app
