-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Test driver for Code12's Java line-level parsing
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


package.path = package.path .. ';../Code12/?.lua'
local source = require( "source" )
local parseJava = require( "parseJava" )
local parseProgram = require( "parseProgram" )
local err = require( "err" )


-- Input and output files
local javaFilename = "TestCode.java"
local treeFilename = "../ParseTestOutput.txt"   -- in parent so Corona won't trigger re-run
local outFile

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

-- Trim whitespace from a string (http://lua-users.org/wiki/StringTrim)
local function trim1(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end


-- Parse the test file and write the parse tree to the output
local function parseTestCode()
	-- Read the input file
	if not source.readFile( javaFilename ) then
		error( "Cannot open input file " .. javaFilename )
	end

	-- Open the output file
	outFile = io.open( treeFilename, "w" )
	if not outFile then
		error( "Cannot open output file " .. treeFilename )
	end

	-- Init error state for bulk error mode and parse the source
	local startTime = system.getTimer()
	err.initProgram()
	err.bulkTestMode = true
	parseProgram.parseLines( 12 )   -- max syntax level 12

	-- Parse input and write output
	output( "======= Test Started ==========================================" )
	local errorSection = false    -- true when we get to the expected errors section
	local numUnexpectedErrors = 0
	local numExpectedErrors = 0
	local numUncaughtErrors = 0
	for lineNum = 1, #source.strLines do
		local lineRec = source.lines[lineNum]
		local strCode = lineRec.str

		-- Check for the indicator for the expected errors section
		if strCode == "// ERRORS" then
			errorSection = true
			output( "*** Beginning of Expected Errors Section ***" )
		end

		-- Output source for this line
		outFile:write( "\n" .. lineNum .. ". " .. trim1( strCode ) .. "\n" )

		-- Print the parse tree for this line, if any
		local tree = lineRec.parseTree
		if tree == false then
			output( "-- Incomplete line carried forward" )
		elseif tree and tree.p ~= "blank" then
			parseJava.printParseTree( tree, 0, outFile )
		end

		-- Does this line have an error?
		local errRec = lineRec.errRec
		if errRec then
			-- This line has an error on it. Output it and count the error
			output( err.getErrString( errRec ) or "**** Missing error state!" )
			if errorSection then
				numExpectedErrors = numExpectedErrors + 1
			else
				numUnexpectedErrors = numUnexpectedErrors + 1
			end
		else
			-- No error on this line. Did we expect one?
			if errorSection and tree and tree.p ~= "blank" and tree.p ~= "comment" 
					and lineRec.iLineStart == lineNum then
				numUncaughtErrors = numUncaughtErrors + 1
				outFile:write( "**** Uncaught Error " .. numUncaughtErrors .. "\n" )
			end
		end
	end
	local endTime = math.round( system.getTimer() - startTime )  -- to nearest ms
	output( "======= Test Complete =========================================" )
	output( "" )

	-- Output and display results
	outputAndDisplay( string.format( "%d lines processed in %d ms", #source.strLines, endTime ) )
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



