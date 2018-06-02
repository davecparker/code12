-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Tool to create Lua tables representing the Code12 API (methods, param types, etc.)
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- The parsing module
package.path = package.path .. ';../Code12/?.lua'
local parseJava = require( "parseJava" )
local err = require( "err" )


-- Input and output files
local apiSummaryFile = "../../API Summary.txt"
local apiTablesFile = "../Code12/apiTables.lua"
local strLines = {}     -- array of source code lines when read
local outFile           -- output Lua file

-- Array of parse trees
local parseTrees = {}


-- Read the input file and store all of its source lines.
-- Return true if success.
local function readSourceFile()
	--local path = system.pathForFile( "API Summary.txt", system.ResourceDirectory )
	--print(path)

	local file = io.open( apiSummaryFile, "r" )
	if file then
		strLines = {}   -- delete previous contents if any
		local lineNum = 1
		repeat
			local s = file:read( "*l" )  -- read a line
			if s == nil then 
				break  -- end of file
			end
			strLines[lineNum] = s
			lineNum = lineNum + 1
		until false -- breaks internally
		io.close( file )
		return true
	end
	return false
end

-- Trim whitespace from a string (http://lua-users.org/wiki/StringTrim)
local function trim1(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Parse the input file and build the parseTrees
local function parseFile()
	parseJava.init()
	for lineNum = 1, #strLines do
		-- Parse this line
		local strCode = strLines[lineNum]
		local tree = parseJava.parseLine( strCode, lineNum )
		if tree == false then
			print( "*** Unexpected incomplete line at line " .. lineNum )
			return false
		end
		if tree == nil then
			print( "*** Syntax error on line " .. lineNum )
			if err.hasErr() then
				print( err.getErrString() )
			else
				print( "Unknown error (no error state)" )
			end
			return false
		end
		parseTrees[lineNum] = tree
	end
	return true
end

-- Make the Lua output file from the parseTrees. Return true if successful.
local function makeLuaFile()
	-- Open the output file
	outFile = io.open( apiTablesFile, "w" )
	if not outFile then
		print( "*** Cannot open output file " .. apiTablesFile )
		return false
	end

	-- TODO
	outFile:write( "-- This is a test\n" )

	-- Close output file
	io.close( outFile )
	return true
end

-- Run the test app
local function runApp()
	-- Process the test file
	print("")   -- Make console output easier to see
	if readSourceFile() then
		if parseFile() then
			makeLuaFile()
			print( "Lua file created successfully" )
		else
			print( "*** Error parsing file" )
		end
	else
		print( "*** Could not read input file")
	end
	print("")
end

-- Run the app then quit
runApp()
native.requestExit()




