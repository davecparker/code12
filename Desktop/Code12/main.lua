-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Main program for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules and plugins
local lfs = require( "lfs" )
local fileDialogs = require( "plugin.tinyfiledialogs" )

-- Local modules
local javalex = require("javalex")


-- Lexer test strings
--local s = [[  { foo2_1(x, "ack", true,/*hey*/ch == 'a', _y, $z);  for a = 3.14;break;  if (a[23] == null)  } // this is a comment]]
--local s = " a>b  a>=b  a>>b a>>=b a>>>b a>>>=b "
--local s = "foo /*hey*/ bar /*this/*is*/nested*/ @bas // this is a comment"


-- The user source file
local sourceFile = {
	path = nil,              -- full pathname to the file
	timeLoaded = 0,          -- time this file was loaded
	timeModLast = 0,         -- last modification time or 0 if never
	tokens = nil,            -- token array scanned from strContents
}

-- UI objects
local dyStatusBar = 30
local statusBarText          -- text object in the status bar 


-- The global state table that the generated Lua code can access
appGlobalState = {}


-- Update status bar based on data in sourceFile
local function updateStatusBar()
	if sourceFile.path then
		-- Get just the filename with extension from the path
		local dir, fileAndExt, ext = string.match( sourceFile.path, "(.-)([^\\/]-%.?([^%.\\/]*))$" )

		-- Get the update time to display
		local updateStr = "Never"
		if sourceFile.timeModLast > sourceFile.timeLoaded then
			local secs = os.time() - sourceFile.timeModLast
			if secs < 5 then
				updateStr = "Just now"
			elseif secs < 60 then
				updateStr = "Less than a minute ago"
			elseif secs < 120 then
				updateStr = "About a minute ago"
			else
				local min = math.floor(secs / 60)
				if min > 60 then
					updateStr = "Over an hour ago"
				else
					updateStr = min .. " minutes ago"
				end
			end
		end
		statusBarText.text = fileAndExt .. "      Updated: " .. updateStr
	end
end

-- Generate and return the Lua code string corresponding to the sourceFile.
-- If there is an error, return 
-- (This is currently just a Proof of Concept)
local function generateLuaCode()
	-- Fake parse of the tokens, just look for apparent ct.circle calls,
	-- get params as following 3 numbers, then generate corresponding Lua code.
	local luaCode = "\nlocal g = appGlobalState\nfunction g.start" .. "()\n"
	local i = 1
	while i <= #sourceFile.tokens do
		local token = sourceFile.tokens[i]
		i = i + 1

		-- See if we have an apparent ct.something call
		if token[1] == "ID" and token[2] == "ct" then
			token = sourceFile.tokens[i]
			if token[1] == "." then
				i = i + 1
				token = sourceFile.tokens[i]
				if token[1] == "ID" then

					-- Check if ct.circle or unknown function
					if token[2] ~= "circle" then
						return nil, "Unknown function \\\"ct." .. token[2] .. "\\\""
					end

					-- Scan for the next 3 numbers as the parameters
					local params = {}
					repeat 
						i = i + 1
						token = sourceFile.tokens[i]
						if token[1] == "NUM" then
							params[#params + 1] = token[2]
						end
					until #params == 3

					-- Generate Lua code for this ct.circle call
					local s = "   local c = display.newCircle(g.group, " 
						.. params[1] .. ", " 
						.. params[2] .. ", " 
						.. params[3] .. " / 2)\n"
						.. "   c:setFillColor(1, 0, 0)\n"

					luaCode = luaCode .. s
				end
			end
		end
	end
	luaCode = luaCode .. "end\n"
	return luaCode
end

-- Run the given lua code string dynamically, and then call the contained start function.
local function runLuaCode(luaCode)
	-- Destroy old object group if any, then make new group
	if appGlobalState.group then
		appGlobalState.group:removeSelf()
	end
	appGlobalState.group = display.newGroup()

	-- Load the code dynamically and execute it
	print(luaCode)
	local codeFunction = loadstring(luaCode)
 	if type(codeFunction) == "function" then
 		codeFunction()

 		-- Run the embedded start function
 		if type(appGlobalState.start) == "function" then
 			appGlobalState.start()
 		end
 	end
end

-- Generate Lua code to display the errorStr
local function makeErrorCode( errorStr )
	return [[
		local g = appGlobalState
		function g.start()
			local t = display.newText(g.group, "]] .. errorStr ..[[", 
					50, 100, native.systemFont, 24)
			t.anchorX = 0
			t:setFillColor(0)
		end
	]]
end

-- Function to check user file for changes and (re)scan it if modified
local function checkUserFile()
	if sourceFile.path then
		local timeMod = lfs.attributes( sourceFile.path, "modification" )
		if timeMod and timeMod > sourceFile.timeModLast then
			local file = io.open( sourceFile.path, "r" )
			if file then
				local strUserCode = file:read( "*a" )
				io.close( file )
				if strUserCode then
					sourceFile.timeModLast = timeMod
					sourceFile.tokens = javalex.getTokens( strUserCode )
					local codeStr, errorStr = generateLuaCode()
					if not codeStr then
						codeStr = makeErrorCode( errorStr )
					end
					runLuaCode( codeStr )
				end
			end
		end
		updateStatusBar()
	end
end

-- Show dialog to choose the user source code file
local function chooseFile()
	local result = fileDialogs.openFileDialog{
		title = "Choose Java Source Code File",
		-- filter_patterns = { "*.java" },
		-- filter_description = "Java Source Code",
		allow_multiple_selects = false,
	}
	if type(result) == "string" then   -- returns false if cancelled
		sourceFile.path = result
		sourceFile.timeLoaded = os.time()
	end
end

-- Init the app
function initApp()
	-- White background
	local W = display.actualContentWidth
	local H = display.actualContentHeight
	display.newRect( W / 2, H / 2, W, H )

	-- Make a default window title
	native.setProperty("windowTitleText", "Code12")
	display.setStatusBar( display.HiddenStatusBar )

	-- Status bar
	local r = display.newRect( W / 2, H - dyStatusBar/ 2, W, dyStatusBar )
	r:setFillColor( 0.8 )
	r.strokeWidth = 1
	r:setStrokeColor( 0 )
	statusBarText = display.newText( "", 10, r.y, native.systemFont, 12 )
	statusBarText.anchorX = 0
	statusBarText:setFillColor( 0 )

	-- Choose the initial file
	-- sourceFile.path = "/Users/davecparker/Documents/Git Projects/code12/Desktop/UserCode.java"
	-- sourceFile.timeLoaded = os.time()
	chooseFile()
	updateStatusBar()

	-- Install timer to check file 4x/sec
	timer.performWithDelay( 250, checkUserFile, 0 )
end


-- Start the app
initApp()

