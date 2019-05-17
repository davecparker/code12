-----------------------------------------------------------------------------------------
--
-- app.lua
--
-- Application global data and functions for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------


-- Global data
local app =  {
	-- Gray shades for the UI
	toolbarShade = 0.8,
	extraShade = 0.95,
	borderShade = 0.5,
	enabledShade = 0.3,
	disabledShade = 0.7,
	defaultGridlineShade = 0.6,

	-- Fonts
	consoleFont = "NotoMono-Regular.ttf",
	consoleFontSize = 14, -- default, can be changed by app.preferredFontSize
	fontSizeUI = 12,
	optionsFont = native.systemFont,
	optionsFontBold = native.systemFontBold,
	optionsFontSize = 14,

	-- Web folders
	webHelpDir = "http://www.code12.org/docs/2/",
	-- webHelpDir = "file:///Users/davecparker/Documents/Git%20Projects/code12/Doc/Website/docs/2/",

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
	customEditors = {},          -- table of custom editors, e.g. { name = "Atom", path = "C:\...\atom.exe" }
	showVarWatch = true,         -- when true, show the variable watch window
	gridOn = false,              -- when true, the coordinate gridlines are visible over the program output
	gridlineShade = nil,         -- current gridline shade
	preferredFontSize = nil,     -- when set, use for app.consoleFontSize on load of user settings

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

-- Return the string with the first letter changed to uppercase if lowercase.
function app.startWithCapital( str )
	return string.upper( string.sub( str, 1, 1 ) ) .. (string.sub( str, 2 ) or "")
end

-- Return the Levenshtein distance of two strings (number of chars different)
function app.partialMatchString( str1, str2 )
	str1 = string.lower(str1)
	str2 = string.lower(str2)
	local len1, len2 = #str1, #str2
	local char1, char2, distance = {}, {}, {}
	str1:gsub('.', function (c) table.insert(char1, c) end)
	str2:gsub('.', function (c) table.insert(char2, c) end)
	for i = 0, len1 do distance[i] = {} end
	for i = 0, len1 do distance[i][0] = i end
	for i = 0, len2 do distance[0][i] = i end
	for i = 1, len1 do
		for j = 1, len2 do
			distance[i][j] = math.min( 
				distance[i-1][j  ] + 1, 
				distance[i  ][j-1] + 1,
				distance[i-1][j-1] + (char1[i] == char2[j] and 0 or 1) )
		end
	end
	return distance[len1][len2]
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

-- Show the reference docs in a new browser window
function app.showHelp()
	system.openURL( app.webHelpDir .. "API.html" )   -- TODO: use starting index page
end


------------------------------------------------------------------------------
return app
