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


-- Parsing structures
local lineParseTrees    -- array of parse trees for each source line
local programTree       -- program parse tree we are building
local outerItems        -- array of OuterItems in the parse tree

-- Parsing state
local numParseTrees     -- number of trees in lineParseTrees
local iTree             -- current tree index in lineParseTrees being analyzed



--- Internal Functions -------------------------------------------------------

-- Check for the correct Code12 import and parse past it.
-- Return true if succesful, else set the error state and return false.
local function parseImport()
	-- Check all imports that we find
	local foundCode12Import = false
	while iTree <= numParseTrees do
		local tree = lineParseTrees[iTree]
		local p = tree.p
		if p == "importAll" then
			if tree.nodes[2].str == "Code12" then
				foundCode12Import = true
			else   -- a package but not Code12
				err.setErrLineParseTree( tree, 
						"Code12 programs should import only Code12.*" )	
				return false
			end
		elseif tree.isError and p == "import" then
			local node = tree.nodes[2]
			if node and node.str == "Code12" then   -- Code12 but wrong syntax
				err.overrideErrLineParseTree( tree, 
						"Code12 programs must start with:\n\"import Code12.*;\"" )
			else   -- not Code12
				err.overrideErrLineParseTree( tree, 
						"Code12 programs should import only Code12.*" )
			end
			return false
		else   -- Not an import
			if foundCode12Import then
				return true
			end
			err.overrideErrLineParseTree( tree,
					"Code12 programs must start with:\n\"import Code12.*;\"" )
			return false
		end
		iTree = iTree + 1
	end
	return false  -- sentinel should prevent getting here
end

-- Check for the correct class header, store the classID, and parse past it. 
-- Return true if succesful, else set the error state and return false.
local function parseClassHeader()
	local tree = lineParseTrees[iTree]
	if tree.p == "classUser" and tree.nodes[5].str == "Code12Program" then
		programTree.classID = tree.nodes[3]  -- class name
		iTree = iTree + 1
		return true
	end
	err.overrideErrLineParseTree( tree,
			"Code12 programs must start with:\n\"class YourName extends Code12Program\"" )	
	return false
end

-- Check for block begin and parse past it.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function parseBlockBegin()
	local tree = lineParseTrees[iTree]
	if tree.p == "begin" then
		iTree = iTree + 1
		return true
	end
	err.overrideErrLineParseTree( tree, "Expected {" )	
	return false
end


--- Module Functions ---------------------------------------------------------

-- Parse a program made of up sourceLines at the given syntaxLevel 
-- and return the programTree (see above).
-- If there is an error then set the error state and return nil.
function parseProgram.getProgramTree( sourceLines, syntaxLevel )
	-- Init the parse structures
	lineParseTrees = {}
	programTree = { items = {} }
	outerItems = programTree.items

	-- Parse the lines and build the lineParseTrees array
	parseJava.initProgram()
	local startTokens = nil
	for lineNum = 1, #sourceLines do
		local tree, tokens = parseJava.parseLine( sourceLines[lineNum], 
									lineNum, startTokens, syntaxLevel )
		if tree == false then
			-- Line is incomplete, carry tokens forward to next line
			assert( type(extra) == "table" )
			startTokens = tokens
		else
			startTokens = nil
			if tree == nil then
				-- Syntax error: Use stub error tree
				lineParseTrees[#lineParseTrees + 1] = 
						{ isError = true, iLine = lineNum }
			elseif tree.p ~= "blank" then
				lineParseTrees[#lineParseTrees + 1] = tree
			end
		end
	end

	-- Add sentinel parse tree at the end
	lineParseTrees[#lineParseTrees + 1] = 
			{ t = "line", p = "EOF", nodes = {}, iLine = #sourceLines + 1 }
	numParseTrees = #lineParseTrees

	-- Parse the required program header
	iTree = 1
	if parseImport() and parseClassHeader() then
		parseBlockBegin()
	end

	-- Return parse trees for now
	if err.shouldStop() then
		return nil
	end
	return lineParseTrees
end


------------------------------------------------------------------------------

return parseProgram
