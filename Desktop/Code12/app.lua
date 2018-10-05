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
	maxNumRecentPaths = 5,       -- maximum number of recent source file paths to keep

	-- List of most recent source file paths opened, with duplicates removed
	recentSourceFilePaths = {},

	-- User settings
	syntaxLevel = nil,           -- current syntax level
	tabWidth = 4,                -- current tab width
	oneErrOnly = true,           -- true to display only the first error
	editorPath = nil,            -- current text editor
	useDefaultEditor = false,    -- when true, use the OS default for opening user program files
	openFilesInEditor = true,    -- when true, opened programs will also open in text editor

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
			for _ = 1, numSpaces do
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

-- Return the lower-case version of the given ASCII code
local function lowerASCII( code )
	if code >= 65 and code <= 90 then  -- A to Z
		return code + 32
	end
	return code
end

-- Return the string with the first letter changed to uppercase if lowercase.
function app.startWithCapital( str )
	return string.upper( string.sub( str, 1, 1 ) ) .. (string.sub( str, 2 ) or "")
end

-- Return a number from 0 to 1 representing a partial match of 
-- str1 to str2 (1.0 if they match exactly).
function app.partialMatchString( str1, str2 )
	-- Simple method for now: Count number of chars matching from front
	-- and again from back and return weighted average.
	local len1 = string.len( str1 )
	local len2 = string.len( str2 )
	local shorterLen, longerLen
	if len1 > len2 then
		shorterLen, longerLen = len2, len1
	else
		shorterLen, longerLen = len1, len2
	end
	local front = 0
	local matchVal = 1
	for i = 1, shorterLen do
		if lowerASCII( string.byte( str1, i ) )
				 == lowerASCII( string.byte( str2, i ) ) then
			front = front + matchVal
			matchVal = 1
		else
			matchVal = 0.5  -- half match when streak was broken
		end
	end
	local back = 0
	matchVal = 1
	for i = 1, shorterLen do
		if lowerASCII( string.byte( str1, len1 + 1 - i ) )
				== lowerASCII( string.byte( str2, len2 + 1 - i ) ) then
			back = back + matchVal
			matchVal = 1
		else
			matchVal = 0.5  -- half match when streak was broken
		end
	end
	return (front + back) / (2 * longerLen)
end

-- Add given path to the end of app.recentSourceFilePaths and remove any other
-- occurance of it in the list.
-- Then trim app.recentSourceFilePaths so its size doen't exceed app.maxNumRecentPaths
function app.addRecentSourceFilePath( path )
	local recentPaths = app.recentSourceFilePaths
	table.insert( recentPaths, 1, path )
	for i = #recentPaths, 2, -1 do
		if recentPaths[i] == path then
			table.remove( recentPaths, i )
			break
		end
	end
	if #recentPaths > app.maxNumRecentPaths then
		table.remove( recentPaths )
	end
end

------------------------------------------------------------------------------
return app
