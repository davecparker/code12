-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Test driver for Code12's High-level parsing and Semantic Error Checking
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- Code12 modules
package.path = package.path .. ';../Code12/?.lua'
local err = require( "err" )
local parseProgram = require( "parseProgram" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )


-- Input and output files
local javaFilename = "ErrorTestCode.java"
local structureFilename = "../ErrorTestStructure.txt"   -- in parent so Corona won't trigger re-run
local outputFilename = "../ErrorTestOutput.txt"   -- in parent so Corona won't trigger re-run
local outFile

-- The user source file
local sourceFile = {
	path = nil,              -- full pathname to the file
	strLines = {},           -- array of source code lines when read
}
local syntaxLevel = 12       -- test at max syntax level

-- Error data
local numUnexpectedErrors = 0
local numExpectedErrors = 0
local numUncaughtErrors = 0
local errLast                      -- the last error reported

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

-- Return the expected error text for the given lineNum,
-- or "" if unspecified, or nil if none.
local function strErrExpected( lineNum )
	local strCodePrev = sourceFile.strLines[lineNum - 1]
	if strCodePrev then
		if string.find( strCodePrev, "ERROR", 1, true) then
			-- An error was expected, look for a snippet in quotes
			local iCharStart = string.find( strCodePrev, "\"", 1, true)
			if iCharStart then
				local iCharEnd = string.find( strCodePrev, "\"", iCharStart + 1, true)
				if iCharEnd then
					return string.sub( strCodePrev, iCharStart + 1, iCharEnd - 1 )
				end
			end
			return ""  -- unspecified error
		end
	end
	return nil  -- no error expected
end

-- Check the error results for correctness
local function checkErrorResults()
	for lineNum = 1, #sourceFile.strLines do
		local strCode = sourceFile.strLines[lineNum]
		local errRec = err.errRecForLine( lineNum )
		local strExpected = strErrExpected( lineNum )

		-- Did we get an error on this line?
		if errRec then
			-- We got an error. Was it what we expected? 
			local strErr = errRec.strErr
			if strExpected then
				if strExpected == "" then
					-- Unspecified error (fine)
					numExpectedErrors = numExpectedErrors + 1
				elseif string.find( strErr, strExpected, 1, true ) then
					-- We got the expected error
					numExpectedErrors = numExpectedErrors + 1
				else
					-- Error text was not what we expected
					output( lineNum .. ". " .. trim1( strCode ) )
					output( "*** Unexpected error text: ".. strErr .. "\n" )
					numUnexpectedErrors = numUnexpectedErrors + 1
				end
			else
				-- We got an error but didn't expect one
				output( lineNum .. ". " .. trim1( strCode ) )
				output( "*** Unexpected error: ".. strErr .. "\n" )
				numUnexpectedErrors = numUnexpectedErrors + 1
			end
		elseif strExpected then
			-- We didn't get an error but expected one
			output( lineNum .. ". " .. trim1( strCode ) )
			output( "*** Uncaught error, expected: ".. strExpected .. "\n" )
			numUncaughtErrors = numUncaughtErrors + 1
		end
	end
end

-- Parse the test file and write the parse tree to the output
local function checkTestCode()
	-- Read the input file
	sourceFile.path = javaFilename    -- name is relative to project folder
	if not readSourceFile() then
		error( "Cannot open input file " .. javaFilename )
	end

	-- Open the output file
	outFile = io.open( outputFilename, "w" )
	if not outFile then
		error( "Cannot open output file " .. outputFilename )
	end

	-- Prepare the start of the test
	output( "======= Test Started ==========================================" )
	numUnexpectedErrors = 0
	numExpectedErrors = 0
	numUncaughtErrors = 0
	local startTime = system.getTimer()

	-- Init error state for bulk error mode
	err.initProgram()
	err.bulkTestMode = true

	-- Get the program structure tree and parse tree array
	local startTime = system.getTimer()
	local programTree = parseProgram.getProgramTree( 
								sourceFile.strLines, syntaxLevel )
	local parseTime = system.getTimer() - startTime

	-- Output the structure tree
	local structureFile = io.open( structureFilename, "w" )
	if structureFile then
		parseProgram.printProgramTree( programTree, structureFile )
		io.close( structureFile )
	end

	-- Do Semantic Analysis
	startTime = system.getTimer()
	checkJava.checkProgram( programTree, syntaxLevel )
	local semCheckTime = system.getTimer() - startTime

	-- Do Code Generation
	startTime = system.getTimer()
	codeGenJava.getLuaCode( programTree )
	local codeGenTime = system.getTimer() - startTime

	-- Check the results
	checkErrorResults()

	-- Output and display results
	output( "======= Test Complete =========================================" )
	output( "" )
	outputAndDisplay( "Semantic Error Test:" )
	outputAndDisplay( "" )
	outputAndDisplay( string.format( "    %d lines processed", #sourceFile.strLines ) )
	outputAndDisplay( string.format( "    %d ms Parse time", parseTime ) )
	outputAndDisplay( string.format( "    %d ms Semantic check time", semCheckTime ) )
	outputAndDisplay( string.format( "    %d ms Code Generation time", codeGenTime ) )
	outputAndDisplay( string.format( "    %d ms Total time",  parseTime + semCheckTime + codeGenTime) )
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
	checkTestCode()
	print("")
end

-- Run the app
runApp()



