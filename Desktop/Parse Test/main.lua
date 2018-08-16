-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Test driver for Code12's Java line-level parsing
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- The parsing module
package.path = package.path .. ';../Code12/?.lua'
local javalex = require( "javalex" )
local parseJava = require( "parseJava" )
local err = require( "err" )


-- Input and output files
local javaFilename = "TestCode.java"
local treeFilename = "../ParseTestOutput.txt"   -- in parent so Corona won't trigger re-run
local outFile

-- The user source file
local sourceFile = {
	path = nil,              -- full pathname to the file
	strLines = {},           -- array of source code lines when read
}

-- Text objects in the app window
local textObjs = {}
local maxTextObjs = 30
local iTextObj = 1       -- index of next one to display to


-- Print msg and also write it to outFile
local function output( msg )
	print( msg )
	if outFile then
		outFile:write( msg )
		outFile:write( "\n" )
	end
end

-- Print msg, write it to outFile, and also display it in the app window
local function outputAndDisplay( msg )
	output( msg )
	if iTextObj <= maxTextObjs then
		textObjs[iTextObj].text = msg
		iTextObj = iTextObj + 1
	end
end

-- Read the sourceFile and store all of its source lines.
-- Return true if success.
local function readSourceFile()
	local file = io.open( sourceFile.path, "r" )
	if file then
		sourceFile.strLines = {}   -- delete previous contents if any
		local lineNum = 1
		repeat
			local s = file:read( "*l" )  -- read a line
			if s == nil then 
				break  -- end of file
			end
			sourceFile.strLines[lineNum] = s
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


-- Parse the test file and write the parse tree to the output
local function parseTestCode()
	-- Read the input file
	sourceFile.path = javaFilename    -- name is relative to project folder
	if not readSourceFile() then
		error( "Cannot open input file " .. javaFilename )
	end

	-- Open the output file
	outFile = io.open( treeFilename, "w" )
	if not outFile then
		error( "Cannot open output file " .. treeFilename )
	end

	-- Parse input and write output
	output( "======= Test Started ==========================================" )
	local errorSection = false    -- true when we get to the expected errors section
	local numUnexpectedErrors = 0
	local numExpectedErrors = 0
	local numUncaughtErrors = 0
	local startTime = system.getTimer()
	parseJava.initProgram()
	local lineNum = 1
	local startTokens = nil
	while lineNum <= #sourceFile.strLines do
		local strCode = sourceFile.strLines[lineNum]

		-- Output source for this line
		outFile:write( "\n" .. lineNum .. ". " .. trim1( strCode ) .. "\n" )

		-- Check for the indicator for the expected errors section
		if strCode == "ERRORS" then
			errorSection = true
			output( "************** Beginning of Expected Errors Section **************" )
		else
			-- Parse this line
			local tree, tokens = parseJava.parseLine( strCode, lineNum, startTokens ) -- TODO: Set and change syntax level?
			if tree == false then
				-- This line is unfinished, carry the tokens forward to the next line
				startTokens = tokens
				outFile:write( "-- Incomplete line carried forward\n" )
			else
				startTokens = nil
				if tree == nil or tree.isError then
					-- This line has an error on it, output it.
					output( err.getErrString( err.rec ) or "*** Missing error state!" )

					-- Count the error
					if errorSection then
						numExpectedErrors = numExpectedErrors + 1
					else
						numUnexpectedErrors = numUnexpectedErrors + 1
					end
				else
					-- Successful parse. 
					-- Did we expect an error on this line?
					if errorSection then
						-- Ignore blank lines
						if tree.p ~= "blank" and tree.p ~= "comment" then
							numUncaughtErrors = numUncaughtErrors + 1
							outFile:write( "*** Uncaught Error "..numUncaughtErrors.."\n" )
						end
					end
					if tree.p ~= "blank" then
						-- Output parse tree to output file only
						parseJava.printParseTree( tree, 0, outFile )
					end
				end
			end
		end
		err.clearErr( lineNum )
		lineNum = lineNum + 1
	end
	local endTime = math.round( system.getTimer() - startTime )  -- to nearest ms
	output( "======= Test Complete =========================================" )
	output( "" )

	-- Output and display results
	outputAndDisplay( string.format( "%d lines processed in %d ms", lineNum - 1, endTime ) )
	outputAndDisplay( "" )
	outputAndDisplay( string.format( "%d unexpected errors", numUnexpectedErrors ) )
	outputAndDisplay( string.format( "%d uncaught errors (%d expected errors)", 
							numUncaughtErrors, numExpectedErrors ) )
	outputAndDisplay( "" )
	if numUnexpectedErrors + numUncaughtErrors == 0 then
		outputAndDisplay( "SUCCESS" )
	else
		outputAndDisplay( "FAILED" )
	end
	io.close( outFile )
end

-- Make the graphical text objects
local function makeTextObjs()
	for i = 1, maxTextObjs do
		local obj = display.newText( "", 10, 10 + i * 20, native.systemFont, 16 )
		obj.anchorX = 0
		obj.anchorY = 0
		obj:setFillColor( 1 )
		textObjs[i] = obj
	end
end

-- Run the test app
local function runApp()
	-- Get the app window ready
	makeTextObjs()

	-- Process the test file
	print("")   -- Make console output easier to see
	parseTestCode()
	print("")
end

-- Run the app
runApp()



