-----------------------------------------------------------------------------------------
--
-- parseProgram.lua
--
-- High-level parsing for a Code 12 Java program
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules
local app = require( "app" )
local parseJava = require( "parseJava" )
local err = require( "err" )

-- The parseProgram module
local parseProgram = {}


-- A structure tree is a language-independent representation of a Code12 program.
-- It is made up of the following structure nodes, tokens, nested structures, 
-- and arrays (plural names), with the following named fields:
--
-- program: { s = "program", nameID, vars, funcs }
--
-- var:  { s = "var", typeID, nameID, isArray, isConst, isLocal, initExpr }
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
local programTree       -- structure tree for the prgoram (see above)

-- Parsing state
local numSourceLines    -- number of source code lines
local numParseTrees     -- number of trees in parseTrees
local iTree             -- current tree index in parseTrees being analyzed


--- Internal Functions -------------------------------------------------------

-- Forward declarations
local makeExpr
local getBlockStmts


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

-- Check for a correct main function body and move iTree past it.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function checkMain()
	if not checkBlockBegin() then
		return false
	end
	local tree = parseTrees[iTree]
	local nodes = tree.nodes
	if tree.isError or tree.p ~= "Code12Run" or 
			nodes[1].str ~= "Code12" or nodes[3].str ~= "run" then
		err.overrideErrLineParseTree( tree,
				"Incorrect code in main function" )
		return false
	end
	local className = programTree.nameID.str
	if nodes[6].str ~= className then
		err.setErrNodeAndRef( nodes[6], programTree.nameID,
				[[This name must match the program's class name "%s"]],
				className )
		return false
	end
	iTree = iTree + 1
	tree = parseTrees[iTree]
	if tree.p ~= "end" then
		err.overrideErrLineParseTree( tree,
				"Expected }" )
		return false
	end	
	iTree = iTree + 1
	return true
end

-- Make and return a var given the parsed fields.
-- If there is an error then set the error state and return nil.
local function makeVar( isLocal, typeID, nameID, initExpr, isArray, isConst )
	return {
		s = "var",
		typeID = typeID,
		nameID = nameID,
		isArray = isArray,
		isConst = isConst,
		isLocal = isLocal,
		initExpr = makeExpr( initExpr )
	}
end

-- Check for a variable declaration or initialization for line pattern p and 
-- the parse nodes, and add variable(s) to the structure array structs.
-- The variable(s) are local if isLocal is included and true.
-- Return true if the pattern was a variable pattern, else false.
local function getVar( p, nodes, structs, isLocal )
	if p == "varInit" then
		-- e.g. int x = 10;
		structs[#structs + 1] = makeVar( isLocal, nodes[1], nodes[2], nodes[4] )
	elseif p == "varDecl" then
		-- e.g. int x, y;
		for _, nameID in ipairs( nodes[2].nodes ) do
			structs[#structs + 1] = makeVar( isLocal, nodes[1], nameID )
		end
	elseif p == "constInit" then
		-- e.g. final int LIMIT = 100;
		structs[#structs + 1] = makeVar( isLocal, nodes[2], nodes[3], nodes[5], nil, true )			
	elseif p == "arrayInit" then
		-- e.g. int[] a = { 1, 2, 3 };   or   int[] a = new int[10];
		structs[#structs + 1] = makeVar( isLocal, nodes[1], nodes[4], nodes[6], true )						
	elseif p == "arrayDecl" then
		-- e.g. GameObj[] coins, walls;
		for _, nameID in ipairs( nodes[4].nodes ) do
			structs[#structs + 1] = makeVar( isLocal, nodes[1], nameID, nil, true )
		end	
	else
		return false   -- not a variable pattern
	end
	return true
end	

-- Make and return an lValue structure from an ID token, lValue parse node, 
-- or fnValue parse node
local function makeLValue( node )
	if node.tt == "ID" then
		return { s = "lValue", nameID = node }
	end
	local nodes = node.nodes
	local indexExpr = nil
	local indexNode = nodes[2]
	if indexNode.p == "index" then
		indexExpr = makeExpr( indexNode.nodes[2] )
	end
	local fieldID = nil
	local fieldNode = nodes[3]
	if fieldNode.p == "field" then
		fieldID = fieldNode.nodes[2]
	end
	return { s = "lValue", nameID = nodes[1], 
			indexExpr = indexExpr, fieldID = fieldID }
end

-- Make and return a call structure from a call parse tree's nodes array
local function makeCall( nodes )
	local exprs = nil
	local exprNodes = nodes[3].nodes
	if #exprNodes > 0 then
		exprs = {}
		for i = 1, #exprNodes do
			exprs[#exprs + 1] = makeExpr( exprNodes[i] )
		end
	end
	return { s = "call", lValue = makeLValue( nodes[1] ), exprs = exprs }
end

-- Get and make stmt structure(s) from the given parse tree,
-- which is not a "begin" or "end" pattern,
-- and add them to the stmts array. Return true if successful.
-- If there is an error then set the error state and return nil.
local function getStmt( tree, stmts )
	-- Fail on syntax errors
	if tree.isError then
		return false
	end

	-- Look for var decls
	local p = tree.p
	local nodes = tree.nodes
	if getVar( p, nodes, stmts, true ) then
		return true
	end

	-- Handle stmt patterns
	local stmt = nil
	if p == "stmt" then
		local node = nodes[1]
		p = node.p
		nodes = node.nodes

		if p == "call" then
			stmt = makeCall( nodes )
		elseif p == "varAssign" or p == "assign" then  -- TODO: remove this distinction?
			stmt = { s = "assign", lValue = makeLValue( nodes[1] ), op = "=", 
					expr = makeExpr( nodes[3] ) }
		elseif p == "opAssign" then
			stmt = { s = "assign", lValue = makeLValue( nodes[1] ),  op = nodes[2].p, 
					expr = makeExpr( nodes[3] ) }
		elseif p == "preInc" or p == "preDec" then
			stmt = { s = "assign", lValue = makeLValue( nodes[2] ), op = nodes[1].tt }
		elseif p == "postInc" or p == "postDec" then
			stmt = { s = "assign", lValue = makeLValue( nodes[1] ), op = nodes[2].tt }
		elseif p == "break" then
			stmt = { s = "break" }
		else
			error( "Unexpected stmt pattern " .. p )
		end
	-- Handle other valid line patterns
	elseif p == "if" then
		-- TODO
	elseif p == "elseif" then
		-- TODO
	elseif p == "else" then
		-- TODO
	elseif p == "return" then
		stmt = { s = "return", expr = makeExpr( nodes[2] ) }
	elseif p == "do" then
		-- TODO
	elseif p == "while" then
		-- TODO
	elseif p == "for" then
		-- TODO
	else
		-- Handle invalid line patterns
		if p == "func" or p == "main" then
			err.setErrNode( tree, "Function definitions cannot occur inside a statement block")
		else
			err.setErrNode( tree, "Unexpected statement" )
		end
		return false
	end

	-- Add the stmt
	stmts[#stmts + 1] = stmt or { s = "stmt" }
	return true
end

-- Process a block of statements beginning with { and ending with }
-- and return an array of stmt.
-- If there is an error then set the error state and return nil.
function getBlockStmts()
	-- Block must start with a {
	local iLineStart = parseTrees[iTree].iLine
	if not checkBlockBegin() then
		return false
	end
	local braceLevel = 1

	-- Get all lines until we get a matching end for the block begin
	local stmts = {}
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		iTree = iTree + 1

		if p == "begin" then
			braceLevel = braceLevel + 1
		elseif p == "end" then
			braceLevel = braceLevel - 1
			if braceLevel == 0 then
				return stmts
			end
		else
			getStmt( tree, stmts )
		end
	end

	-- Got to EOF before finding matching }
	err.setErrLineNum( numSourceLines + 1, 
		"Missing } to end block starting at line %d", iLineStart )
	return nil
end

-- Make and return an expr structure from an expr or arrayInit parse node
function makeExpr( node )
	-- No expr makes nil (e.g. an optional expr field)
	if node == nil then
		return nil
	end

	-- Handle arrayInit nodes
	if node.t == "arrayInit" then
		if node.p == "list" then
			local exprs = {}
			for _, exprNode in ipairs( node.nodes[2].nodes ) do
				exprs[#exprs + 1] = makeExpr( exprNode )
			end	
			return { s = "arrayInit", exprs = exprs }
		else
			node = node.nodes[1]
		end
	end

	-- Handle the different primaryExpr types plus binary operators
	assert( node.t == "expr" )
	local p = node.p
	local nodes = node.nodes
	if p == "NUM" or p == "BOOL" or p == "NULL" or p == "STR" then
		return { s = "literal", token = nodes[1] }
	elseif p == "call" then
		return makeCall( nodes )
	elseif p == "lValue" then
		return makeLValue( nodes[1] )
	elseif p == "exprParens" then
		return { s = "parens", expr = makeExpr( nodes[2] ) }
	elseif p == "neg" or p == "!" then
		return { s = "unaryOp", op = nodes[1].str, expr = makeExpr( nodes[2] ) }
	elseif p == "newArray" then
		return { s = "newArray", typeID = nodes[2], lengthExpr = makeExpr( nodes[4] ) }
	else
		-- Binary op
		return { s = "binOp", op = nodes[2].str, leftExpr = makeExpr( nodes[1] ),
				rightExpr = makeExpr( nodes[3] ) }
	end
end

-- Make and return a function member given the parsed fields,
-- including the contained statements, and move iTree past it.
-- If there is an error then set the error state and return nil.
local function getFunc( typeID, isArray, nameID, isPublic, paramList )
	-- Build the param array
	local params = {}
	for _, node in ipairs( paramList.nodes ) do
		local nodes = node.nodes
		local param = { s = "param", typeID = nodes[1] }
		if node.p == "array" then
			param.nameID = nodes[4]
			param.isArray = true
		else
			param.nameID = nodes[2]
		end
		params[#params + 1] = param
	end

	-- Get the stmts array
	local stmts = getBlockStmts()
	if stmts == nil then
		return nil
	end

	-- Make the func
	return { 
		s = "func", 
		typeID = typeID,
		nameID = nameID,
		isArray = isArray,
		isPublic = isPublic,
		params = params, 
		stmts = stmts,
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
		local ok = not tree.isError
		iTree = iTree + 1

		if ok and getVar( p, nodes, vars ) then
			-- Added instance variable(s)
		elseif p == "func" then
			if ok then
				local typeID = nil
				local isArray = nil
				local retType = nodes[2]
				if retType.p ~= "void" then
					typeID = retType.nodes[1]
					isArray = (retType.p == "array") or nil
				end
				local isPublic = (nodes[1].p == "public") or nil
				funcs[#funcs + 1] = getFunc( typeID, isArray, nodes[3], isPublic, nodes[5] )
			else
				getBlockStmts()  -- skip body of invalid function defintion
			end
		elseif p == "main" then
			if not checkMain() then
				return false
			end
		elseif p == "end" then
			return true  -- end of class
		else
			-- Unexpected line in the class block
			-- Try to give a decent error message.
			if ok then
				local strErr
				if p == "end" then
					strErr = [[Extra "}" without a matching "{"]]
				elseif p == "begin" then
					strErr = [[Unexpected or extra "{"]]
				elseif p == "importAll" or p == "import" then
					strErr = "Imports must be at the very beginning of the program"
				elseif p == "class" or p == "classUser" then
					strErr = "Code12 does not support nested or additional classes"
				elseif p == "main" then
					strErr = [[Misplaced main function -- mismatched { } brackets?]]
				else
					strErr = [[Statement must be inside a function body -- mismatched { } brackets?]]
				end
				err.overrideErrLineParseTree( tree, strErr )
			end
			return false
		end
	end

	-- Reached EOF before finding the end of the class
	err.setErrLineNum( numSourceLines + 1, "Missing } to end the program class" )
	return false
end

-- Print a structure tree node recursively for debugging, labelled with name if included
local function printStructureTree( node, indentLevel, file, label )
	-- Make a label for this node
	assert( type(node) == "table" and node.s )
	local str = string.rep( "    ", indentLevel )
	if label then
		str = str .. label .. ": "
	end
	str = str .. node.s
	if node.nameID and node.nameID.str then
		str = str .. " " .. node.nameID.str
	end

	-- Add field names, and values if simple 
	str = str .. " { "
	for field, value in pairs( node ) do
		if field ~= "s" and field ~= "nameID" then
			if type(value) == "table" then
				if value.tt then  
					-- A token
					str = str .. field .. " = " .. value.str  
				elseif value.s then
					-- A child structure node
					str = str .. field
				else
					-- An array
					str = str .. "#" .. field .. " = " .. #value
				end
			elseif type(value) == "string" then
				str = str .. field .. " = " .. "\"" .. value .. "\""
			else  -- number or boolean
				str = str .. field .. " = " .. tostring( value )
			end
			str = str .. ", "
		end
	end
	str = str .. "}"

	-- Output description
	app.printDebugStr( str, file )

	-- Recursively print children at next indent level, if any
	for field, value in pairs( node ) do
		if type(value) == "table" then
			if value.s then
				-- Child structure node
				printStructureTree( value, indentLevel + 1, file, field )
			elseif #value > 0 then
				-- Array node
				str = string.rep( "    ", indentLevel + 1 ) .. field .. ":"
				app.printDebugStr( str, file )
				for i = 1, #value do
					printStructureTree( value[i], indentLevel + 2, file )
				end
			end
		end
	end
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
	numSourceLines = #sourceLines
	for lineNum = 1, numSourceLines do
		local tree, tokens = parseJava.parseLine( sourceLines[lineNum], 
									lineNum, startTokens, syntaxLevel )
		if tree == false then
			-- Line is incomplete, carry tokens forward to next line
			assert( type(tokens) == "table" )
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
			{ t = "line", p = "EOF", nodes = {}, iLine = numSourceLines + 1 }
	numParseTrees = #parseTrees

	-- Check for the required program header then get the member vars and funcs
	iTree = 1
	if checkImport() and checkClassHeader() and checkBlockBegin() then
		if getMembers() then
			-- We should be at the EOF now
			if parseTrees[iTree].p ~= "EOF" then
				err.overrideErrLineParseTree( parseTrees[iTree],
						"Unexpected line after end of class -- mismatched { } brackets?" )
				return nil
			end
		end
	end

	-- Print programTree for debugging
	printStructureTree( programTree, 0 )

	-- Return parse trees for now
	if err.shouldStop() then
		return nil
	end
	return parseTrees
end


------------------------------------------------------------------------------

return parseProgram
