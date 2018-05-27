-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Test driver for Code12's Java parsing
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- The parsing module
package.path = package.path .. ';../Code12/?.lua'
local parseJava = require( "parseJava" )


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

-- Parse the test file and write the parse tree to the output
local function parseTestCode()
	-- Open the input file
	local inFile = io.open( javaFilename, "r" )
	if not inFile then
		error( "Cannot open input file " .. treeFilename )
	end

	-- Open the output file
	outFile = io.open( treeFilename, "w" )
	if not outFile then
		error( "Cannot open output file " .. treeFilename )
	end

	-- Parse input and write output
	output( "======= Test Started ==========================================" )
	local lineNum = 0
	local errorSection = false    -- true when we get to the expected errors section
	local numUnexpectedErrors = 0
	local numExpectedErrors = 0
	local numUncaughtErrors = 0
	local startTime = system.getTimer()
	parseJava.init()
	repeat
		-- Read a line from the input
		local strCode = inFile:read( "*l" )
		if not strCode then 
			break  -- end of file
		end
		lineNum = lineNum + 1

		-- Output header for this line
		outFile:write( "(" .. lineNum .. ") -----------------------------------------------------\n" )

		-- Check for the indicator for the expected errors section
		if strCode == "ERRORS" then
			errorSection = true
			output( "************** Beginning of Expected Errors Section **************" )
		else
			-- Parse this line
			local tree, strErr, iChar = parseJava.parseLine( strCode )
			if tree == nil then
				-- This line has an error on it, output it.
				if strErr and iChar then
					output( string.format( "Line %d: Lexical Error: %s (index %d)", lineNum, strErr, iChar ) );
				else
					output( string.format( "Line %d: Syntax Error: %s", lineNum, strCode ) );
				end

				-- Count the error
				if errorSection then
					numExpectedErrors = numExpectedErrors + 1
				else
					numUnexpectedErrors = numUnexpectedErrors + 1
				end
			else
				-- Output parse tree to output file only
				parseJava.printParseTree( tree, 0, outFile )

				-- Did we expect an error on this line?
				if errorSection then
					-- Ignore blank lines
					if tree.p ~= "blank" then
						numUncaughtErrors = numUncaughtErrors + 1
					end
				end
			end
		end
	until false  -- breaks or returns internally
	local endTime = math.round( system.getTimer() - startTime )  -- to nearest ms
	output( "======= Test Complete =========================================" )
	output( "" )

	-- Output and display results
	outputAndDisplay( string.format( "%d lines processed in %d ms", lineNum, endTime ) )
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

	-- Close the files
	io.close( outFile )
	io.close( inFile )
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



