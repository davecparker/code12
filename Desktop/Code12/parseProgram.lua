-----------------------------------------------------------------------------------------
--
-- parseProgram.lua
--
-- High-level parsing for a Code 12 Java program
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules
local parseJava = require( "parseJava" )
local err = require( "err" )

-- The parseProgram module
local parseProgram = {}


-- Parsing state
local syntaxLevel       -- syntax level we are parsing at
local sourceLines       -- array of source code strings for each line
local numLines          -- number of source code lines
local lineParseTrees    -- array of parse trees for each source line
local lineNum           -- current line number
local programTree       -- program parse tree we are building
local outerItems        -- array of OuterItems in the parse tree


--- Internal Functions -------------------------------------------------------

-- Check for the correct Code12 import then class header, store the classID, 
-- and parse past the class header.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function parseClassHeader()
	local foundCode12Import = false
	while lineNum <= numLines do
		-- Try to parse the line
		local tree = parseJava.parseLine( sourceLines[lineNum], 
							lineNum, nil, syntaxLevel )
		if not tree then
			if err.getErrPattern() == "import" then
				return false   -- invalid import set the err state already
			end
			err.clearErr()  -- other parse error, use better error below
			break    
		end

		-- Look for imports and class, keep comments, and skip blank lines
		local p = tree.p
		if p == "importCode12" then
			if tree.nodes[2].str ~= "Code12" then
				err.setErrLineNum( lineNum, "Code12 programs should import only Code12.*" )	
				return false
			end
			foundCode12Import = true
		elseif p == "classUser" then
			if not foundCode12Import or tree.nodes[5].str ~= "Code12Program" then
				break    -- missing import or wrong superclass
			end
			lineNum = lineNum + 1
			programTree.classID = tree.nodes[3]  -- class name
			return true   -- found both the import and class header we needed
		elseif p == "comment" then
			outerItems[#outerItems + 1] = tree    -- keep comments
		elseif p ~= "blank" then
			break  -- unexpected line
		end
		lineNum = lineNum + 1
	end

	-- Report the error
	local strErr
	if foundCode12Import then
		strErr = "Code12 programs must start with:\nclass YourName extends Code12Program"
	else
		strErr = "Code12 programs must start with:\nimport Code12.*;"
	end
	err.setErrLineNum( lineNum, strErr )	
	return false
end

-- Check for block begin and parse past it.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function parseBlockBegin()
	while lineNum <= numLines do
		-- Try to parse the line
		local tree = parseJava.parseLine( sourceLines[lineNum], 
							lineNum, nil, syntaxLevel )
		if not tree then
			err.clearErr()  -- parse error, use better error below
			break    
		end

		-- Look for block begin, keep comments, and skip blank lines
		local p = tree.p
		if p == "begin" then
			lineNum = lineNum + 1
			return true
		elseif p == "comment" then
			outerItems[#outerItems + 1] = tree    -- keep comments
		elseif p ~= "blank" then
			break  -- unexpected line
		end
		lineNum = lineNum + 1
	end

	-- Report the error
	err.setErrLineNum( lineNum, "Class header must be followed by a {" )	
	return false
end


--- Module Functions ---------------------------------------------------------

-- Parse a program made of up strLines at the given syntax level 
-- and return the programTree (see above).
-- If there is an error then set the error state and return nil.
function parseProgram.getProgramTree( strLines, level )
	-- Init the parse state
	syntaxLevel = level
	sourceLines = strLines
	numLines = #sourceLines
	lineParseTrees = {}
	lineNum = 1
	programTree = { items = {} }
	outerItems = programTree.items

	-- Parse the import and the class header and get the class name
	parseJava.init()
	if not parseClassHeader() or not parseBlockBegin() then
		return nil
	end

	-- Parse the rest of the lines
	local startTokens = nil
	while lineNum <= #sourceLines do
		local tree, tokens = parseJava.parseLine( sourceLines[lineNum], 
									lineNum, startTokens, syntaxLevel )
		if tree == false then
			-- Line is incomplete, carry tokens forward to next line
			startTokens = tokens
		else
			startTokens = nil
			if tree == nil then
				return nil   -- parse error
			end
			lineParseTrees[#lineParseTrees + 1] = tree
		end
		lineNum = lineNum + 1
	end
	return lineParseTrees
end


------------------------------------------------------------------------------

return parseProgram
