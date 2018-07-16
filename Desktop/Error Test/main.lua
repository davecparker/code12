-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Test driver for Code12's Semantic Error Checking and Code Generation Errors
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- Code12 modules
package.path = package.path .. ';../Code12/?.lua'
local g = require( "Code12.globals" )
local err = require( "err" )
local parseJava = require( "parseJava" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )


-- Input and output files
local javaFilename = "ErrorTestCode.java"
local outputFilename = "../ErrorTestOutput.txt"   -- in parent so Corona won't trigger re-run
local outFile

-- The user source file
local sourceFile = {
	path = nil,              -- full pathname to the file
	strLines = {},           -- array of source code lines when read
}

-- Error data
local numUnexpectedErrors = 0
local numExpectedErrors = 0
local numUncaughtErrors = 0
local strErrorFromLineNum = {}     -- err received at each line number
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

-- Handle an error reported by Code12's error checking
local function onLogError( errRecord )
	-- Only log the first error on each line
	if errLast and errLast.loc.first.iLine == errRecord.loc.first.iLine then
		return
	end
	errLast = errRecord

	-- Store the error in our array of errors by line number
	local lineNum = errRecord.loc.first.iLine
	strErrorFromLineNum[lineNum] = errRecord.strErr
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
		local strErr = strErrorFromLineNum[lineNum]
		local strExpected = strErrExpected( lineNum )

		-- Did we get an error on this line?
		if strErr then
			-- We got an error. Was it what we expected? 
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
	strErrorFromLineNum = {}
	local startTime = system.getTimer()

	-- Install special Code12 hook to log errors and continue instead of stopping
	g.fnLogErr = onLogError

	-- Create parse tree array
	local startTime = system.getTimer()
	local parseTrees = {}
	local startTokens = nil
	parseJava.init()
	local lineNum = 1
	while lineNum <= #sourceFile.strLines do
		local strCode = sourceFile.strLines[lineNum]
		local tree, tokens = parseJava.parseLine( strCode, 
									lineNum, startTokens, syntaxLevel )
		if tree == false then
			-- Line is incomplete, carry tokens forward to next line
			startTokens = tokens
		else
			startTokens = nil
			if tree == nil then
				-- We don't expect any parse errors
				output( lineNum .. ". " .. trim1( strCode ) )
				output( "*** Unexpected parse error: " .. err.getErrString() .. "\n" )
				numUnexpectedErrors = numUnexpectedErrors + 1
				err.clearErr()   -- leave this tree nil and continue
			end
			parseTrees[#parseTrees + 1] = tree
		end
		lineNum = lineNum + 1
	end
	local endParseTime = system.getTimer()

	-- Do Semantic Analysis and Code Generation on the parse trees
	err.clearErr()
	checkJava.initProgram( parseTrees, syntaxLevel )
	local endCheckTime = system.getTimer()
	err.clearErr()
	codeGenJava.getLuaCode( parseTrees )
	local endCodeGenTime = system.getTimer()

	-- Check the results
	checkErrorResults()

	-- Output and display results
	output( "======= Test Complete =========================================" )
	output( "" )
	outputAndDisplay( "Semantic Error Test:" )
	outputAndDisplay( "" )
	outputAndDisplay( string.format( "    %d lines processed", lineNum - 1 ) )
	outputAndDisplay( string.format( "    %d ms Parse time", endParseTime - startTime ) )
	outputAndDisplay( string.format( "    %d ms Semantic check time", endCheckTime - endParseTime ) )
	outputAndDisplay( string.format( "    %d ms Code Generation time", endCodeGenTime - endCheckTime ) )
	outputAndDisplay( string.format( "    %d ms Total time", endCodeGenTime - startTime ) )
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



