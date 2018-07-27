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


-- A program tree is a language-independent representation of a Code12 program.
-- It is made up of the following "structure" nodes, tokens, nested structures, 
-- and arrays (plural names), with the following named fields:
--
-- program: { s = "program", nameID, vars, funcs }
--
-- var:  { s = "var", typeID, nameID, isArray, isConst, initExpr }
-- func: { s = "func", typeID, nameID, isArray, isPublic, params, stmts }
-- 
-- param: { s = "param", typeID, nameID, isArray }
--
-- stmt:
--     { s = "var", typeID, nameID, isArray, isConst, isLocal = true, initExpr }
--     { s = "call", lValue, exprs }
--     { s = "assign", lValue, op, expr }     -- op.tt: =, +=, -=, *=, /=, ++, --
--     { s = "if", expr, stmts, elseStmts }
--     { s = "while", expr, stmts }
--     { s = "doWhile", expr, stmts }
--     { s = "for", initStmt, expr, nextStmt, stmts }
--     { s = "forArray", typeID, nameID, arrayID, stmts }
--     { s = "break" }
--     { s = "return", expr }
--
-- lValue: { s = "lValue", nameID, indexExpr, fieldID }
-- 
-- expr:
--     { s = "literal", token }       -- token.tt: NUM, BOOL, NULL, STR
--     { s = "call", lValue, exprs }
--     { s = "lValue", lValue }
--     { s = "parens", expr }
--     { s = "unaryOp", op, expr }                -- op.tt: -, !
--     { s = "binOp", leftExpr op, rightExpr }    -- op.tt: *, /, %, +, -, <, <=, >, >=, ==, !=, &&, ||
--     { s = "newArray", typeID, lengthExpr }
--     { s = "arrayInit", exprs }


-- Parsing structures
local parseTrees        -- array of parse trees for each source line
local programTree       -- program tree we are building (see above)

-- Parsing state
local numParseTrees     -- number of trees in parseTrees
local iTree             -- current tree index in parseTrees being analyzed


--- Internal Functions -------------------------------------------------------

-- Check for the correct Code12 import and move iTree past all imports.
-- Return true if succesful, else set the error state and return false.
local function checkImport()
	-- Check all imports that we find
	local foundCode12Import = false
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
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

-- Check for the correct class header, store the class name in 
-- programTree.classID, and move iTree past it. 
-- Return true if succesful, else set the error state and return false.
local function checkClassHeader()
	local tree = parseTrees[iTree]
	if tree.p == "classUser" and tree.nodes[5].str == "Code12Program" then
		programTree.nameID = tree.nodes[3]  -- class name
		iTree = iTree + 1
		return true
	end
	err.overrideErrLineParseTree( tree,
			"Code12 programs must start with:\n\"class YourName extends Code12Program\"" )	
	return false
end

-- Check for a block begin and move iTree past it.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function checkBlockBegin()
	local tree = parseTrees[iTree]
	if tree.p == "begin" then
		iTree = iTree + 1
		return true
	end
	err.overrideErrLineParseTree( tree, "Expected {" )	
	return false
end

-- Make and return a var given the parsed fields.
-- If there is an error then set the error state and return nil.
local function makeVar( typeID, nameID, initExpr, isArray, isConst, isLocal )
	print("var", nameID.str)
	return {
		s = "var",
		typeID = typeID,
		nameID = nameID,
		isArray = isArray,
		isConst = isConst,
		isLocal = isLocal,
		initExpr = initExpr
	}
end

-- Make and return a function member given the parsed fields,
-- including the contained statements, and move iTree past it.
-- If there is an error then set the error state and return nil.
local function getFunc( typeID, isArray, nameID, isPublic, paramList )
	print("func", nameID.str)
	return { 
		t = "func", 
		typeID = typeID,
		nameID = nameID,
		isArray = isArray,
		isPublic = isPublic,
		params = paramList, 
		stmts = nil,   -- TODO
	}
end

-- Check and build the members.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function getMembers()
	local vars = programTree.vars
	local funcs = programTree.funcs

	-- Look for instance variables and functions
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		local nodes = tree.nodes
		local member
		if p == "varInit" then
			vars[#vars + 1] = makeVar( nodes[1], nodes[2], nodes[4] );
		elseif p == "varDecl" then
			for _, nameID in ipairs( nodes[2].nodes ) do
				vars[#vars + 1] = makeVar( nodes[1], nameID )
			end
		elseif p == "constInit" then
			vars[#vars + 1] = makeVar( nodes[2], nodes[3], nodes[5], nil, true );			
		elseif p == "arrayInit" then
			vars[#vars + 1] = makeVar( nodes[1], nodes[4], nodes[6], true );						
		elseif p == "arrayDecl" then
			for _, nameID in ipairs( nodes[4].nodes ) do
				vars[#vars + 1] = makeVar( nodes[1], nameID, nil, true )
			end			
		elseif p == "func" then
			local typeID = nil
			local isArray = nil
			local retType = nodes[2]
			if retType.p ~= "void" then
				typeID = retType.nodes[1]
				isArray = (retType.p == "array") or nil
			end
			local isPublic = (nodes[1].p == "public") or nil
			funcs[#funcs + 1] = getFunc( typeID, isArray, nodes[3], isPublic, nodes[5])
		else
			-- Unexpected line in the class block
		end
		iTree = iTree + 1
	end
	return true
end


--- Module Functions ---------------------------------------------------------

-- Parse a program made of up sourceLines at the given syntaxLevel 
-- and return the programTree (see above).
-- If there is an error then set the error state and return nil.
function parseProgram.getProgramTree( sourceLines, syntaxLevel )
	-- Init the parse structures
	parseTrees = {}
	programTree = { s = "program", vars = {}, funcs = {} }

	-- Parse the lines and build the parseTrees array
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
				parseTrees[#parseTrees + 1] = 
						{ isError = true, iLine = lineNum }
			elseif tree.p ~= "blank" then
				parseTrees[#parseTrees + 1] = tree
			end
		end
	end

	-- Add sentinel parse tree at the end
	parseTrees[#parseTrees + 1] = 
			{ t = "line", p = "EOF", nodes = {}, iLine = #sourceLines + 1 }
	numParseTrees = #parseTrees

	-- Check for the required program header then get the members
	iTree = 1
	if checkImport() and checkClassHeader() and checkBlockBegin() then
		getMembers()
	end

	-- Return parse trees for now
	if err.shouldStop() then
		return nil
	end
	return parseTrees
end


------------------------------------------------------------------------------

return parseProgram
