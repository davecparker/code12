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
local javalex = require( "javalex" )

-- The parseProgram module
local parseProgram = {}


-- A structure tree is a language-independent representation of a Code12 program.
-- It is made up of the following structure nodes, tokens, nested structures, 
-- and arrays (plural names), with the following named fields:
--
-- program: { s = "program", nameID, vars, funcs }
--
-- var:  { s = "var", iLine, typeID, nameID, isArray, isConst, isLocal, initExpr }
-- func: { s = "func", iLine, typeID, nameID, isArray, isPublic, params, stmts }
-- 
-- param: { s = "param", typeID, nameID, isArray }
--
-- stmt:
--     { s = "var", iLine, typeID, nameID, isArray, isConst, isLocal, initExpr }
--     { s = "call", iLine, lValue, exprs }
--     { s = "assign", iLine, lValue, op, expr }     -- op.tt: =, +=, -=, *=, /=, ++, --
--     { s = "if", iLine, expr, stmts, elseStmts }
--     { s = "while", iLine, expr, stmts }
--     { s = "doWhile", iLine, expr, stmts }
--     { s = "for", iLine, initStmt, expr, nextStmt, stmts }
--     { s = "forArray", iLine, typeID, varID, arrayID, stmts }
--     { s = "break", iLine }
--     { s = "return", iLine, expr }
--
-- lValue: { s = "lValue", varID, indexExpr, fieldID }
-- 
-- expr:
--     { s = "literal", token }       -- token.tt: NUM, BOOL, NULL, STR
--     { s = "call", lValue, exprs }
--     { s = "lValue", lValue }
--     { s = "parens", expr }
--     { s = "unaryOp", op, expr }         -- op.tt: -, !
--     { s = "binOp", left, op, right }    -- op.tt: *, /, %, +, -, <, <=, >, >=, ==, !=, &&, ||
--     { s = "newArray", typeID, lengthExpr }
--     { s = "arrayInit", exprs }


-- Parsing structures
local parseTrees        -- array of parse trees for each source line
local programTree       -- structure tree for the program (see above)

-- Parsing state
local numSourceLines    -- number of source code lines
local numParseTrees     -- number of trees in parseTrees
local iTree             -- current tree index in parseTrees being analyzed


--- Internal Functions -------------------------------------------------------

-- Forward declarations
local makeExpr
local getBlockStmts
local getLineStmts

-- Set an error when a block's begining { does not have the same indentation as its function header
-- or control statement
local function indentErrBlockBegin( tree, prevTree )
	local p = prevTree.p
	local strErr
	if p == "func" or p == "main" then
		strErr = "The { after a function header should have the same indentation as the function header"
	elseif p == "if" then
		strErr = "The { after an if statement should have the same indentation as the \"if\""
	elseif p == "elseif" then
		strErr = "The { after an else if statement should have the same indentation as the \"else if\""
	elseif p == "else" then
		strErr = "The { after an \"else\" should have the same indentation as the \"else\""
	elseif p == "do" then
		strErr = "The { after a \"do\" should have the same indentation as the \"do\""
	elseif p == "while" then
		strErr = "The { after a while loop header should have the same indentation as the \"while\""
	elseif p == "for" then
		strErr = "The { after a for loop header should have the same indentation as the \"for\""
	else
		strErr = "The { beginning a block should have the same indentation as the line before it"
	end
	err.setErrLineNumAndRefLineNum( tree.iLine, prevTree.iLineStart, strErr )
end

-- Check indentation for multi-line var decls, function defs, and calls
local function checkMultiLineIndent( tree )
	if tree.iLineStart ~= tree.iLine then
		local startIndent = javalex.indentLevelForLine( tree.iLineStart )
		for lineNum = tree.iLineStart + 1, tree.iLine do 
			if javalex.indentLevelForLine( lineNum ) <= startIndent then
				err.setErrLineNumAndRefLineNum( lineNum, tree.iLineStart, 
						"The lines after the first line of a multi-line statement should be indented further than the first line" )
				break
			end
		end
	end
end

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
				if javalex.indentLevelForLine( tree.iLine ) ~= 0 then
					err.setErrLineNum( tree.iLine, "\"import Code12.*;\" shouldn't be indented" )
				end
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
		if javalex.indentLevelForLine( tree.iLine ) ~= 0 then
			err.setErrLineNum( tree.iLine, "The class header shouldn't be indented" )
		end
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
	local prevTree = parseTrees[iTree - 1]
	if tree.p == "begin" then
		if javalex.indentLevelForLine( tree.iLine ) ~= javalex.indentLevelForLine( prevTree.iLineStart ) then
			indentErrBlockBegin( tree, prevTree )
		end
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
	local iLineBlockBegin = parseTrees[iTree].iLineStart
	local beginIndent = javalex.indentLevelForLine( iLineBlockBegin )
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
	local prevTree = parseTrees[iTree - 1]
	if javalex.indentLevelForLine( tree.iLineStart ) <= javalex.indentLevelForLine( prevTree.iLine ) then
		err.setErrLineNumAndRefLineNum( tree.iLineStart, prevTree.iLine, 
				"The body of a function should be indented more than its opening {" )
	end
	iTree = iTree + 1
	tree = parseTrees[iTree]
	if tree.p ~= "end" then
		err.overrideErrLineParseTree( tree,
				"Expected }" )
		return false
	elseif javalex.indentLevelForLine( tree.iLine ) ~= beginIndent then
		err.setErrLineNumAndRefLineNum( tree.iLine, iLineBlockBegin, 
				"main functions's ending } should have the same indentation as its beginning {" )
	end	
	iTree = iTree + 1
	return true
end

-- Make and return a var given the parsed fields.
-- If there is an error then set the error state and return nil.
local function makeVar( isLocal, typeID, nameID, initExpr, isArray, isConst )
	return {
		s = "var",
		iLine = typeID.iLine,
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
		return { s = "lValue", varID = node }
	end
	assert( node.t == "lValue" or node.t == "fnValue" )
	local nodes = node.nodes
	local indexExpr = nil
	local indexNode = nodes[2]
	if indexNode.p == "index" then
		indexExpr = makeExpr( indexNode.nodes[2] )
	end
	local fieldID = nil
	local fieldNode = nodes[3]
	if fieldNode.p ~= "empty" then
		fieldID = fieldNode.nodes[2]
	end
	return { s = "lValue", varID = nodes[1], 
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

-- Get the single controlled stmt or block of controlled stmts for an 
-- if, else, or loop, and return an array of stmt structures. 
-- If the next item to process is a begin block then get an entire block 
-- of stmts until the matching block end, otherwise get a single stmt. 
-- Return nil if there was an error.
local function getControlledStmts()
	local tree = parseTrees[iTree]
	local p = tree.p
	if p == "begin" then
		return getBlockStmts()
	elseif p == "end" then
		err.setErrNode( tree, "} without matching {" )
		return nil
	elseif p == "varInit" or p == "varDecl" or p == "arrayInit" or p == "arrayDecl" then
		-- Var decls are not allowed as a single controlled statement
		err.setErrNode( tree, "Variable declarations are not allowed here" )
		return nil
	else
		-- Single controlled stmt
		if javalex.indentLevelForLine( tree.iLineStart ) <= javalex.indentLevelForLine( parseTrees[iTree - 1].iLineStart ) then
			local prevTree = parseTrees[iTree - 1]
			err.setErrLineNumAndRefLineNum( tree.iLineStart, prevTree.iLineStart, 
					"This line should be indented more than its controlling \"%s\"", prevTree.p )
		end
		iTree = iTree + 1  -- pass the controlled stmt as expected by getLineStmts
		local stmts = {}
		if getLineStmts( tree, stmts ) then
			return stmts
		end
	end
	return nil
end

-- Check to see if the next stmt is an else or else if, and if so then 
-- get the controlled stmts and return an array of stmt structures. 
-- Return nil if there is no else or an error.
local function getElseStmts( ifTree )
	local tree = parseTrees[iTree]
	local p = tree.p
	if p == "else" then
		if javalex.indentLevelForLine( tree.iLine ) ~= javalex.indentLevelForLine( ifTree.iLineStart ) then
			err.setErrLineNumAndRefLineNum( tree.iLine, ifTree.iLineStart, 
					"This \"else\" should have the same indentation as the highlighted \"if\" above it" )
		end
		iTree = iTree + 1
		return getControlledStmts()
	elseif p == "elseif" then
		if javalex.indentLevelForLine( tree.iLineStart ) ~= javalex.indentLevelForLine( ifTree.iLineStart ) then
			err.setErrLineNumAndRefLineNum( tree.iLineStart, ifTree.iLineStart, 
					"This \"else if\" should have the same indentation as the highlighted \"if\" above it" )
		end
		-- Controlled stmts is a single stmt, which is the following if
		iTree = iTree + 1
		return { { s = "if", expr = makeExpr( tree.nodes[4] ), 
				stmts = getControlledStmts(), 
				elseStmts = getElseStmts( ifTree ) } }
	end
	return nil	
end

-- Get and return a stmt structure for the given stmt parse tree.
-- Return nil if there is an error.
local function getStmt( node )
	local p = node.p
	local nodes = node.nodes

	if p == "call" then
		return makeCall( nodes )
	elseif p == "varAssign" or p == "assign" then  -- TODO: remove this distinction?
		return { s = "assign", lValue = makeLValue( nodes[1] ), op = "=", 
				expr = makeExpr( nodes[3] ) }
	elseif p == "opAssign" then
		return { s = "assign", lValue = makeLValue( nodes[1] ),  op = nodes[2].p, 
				expr = makeExpr( nodes[3] ) }
	elseif p == "preInc" or p == "preDec" then
		return { s = "assign", lValue = makeLValue( nodes[2] ), op = nodes[1].tt }
	elseif p == "postInc" or p == "postDec" then
		return { s = "assign", lValue = makeLValue( nodes[1] ), op = nodes[2].tt }
	elseif p == "break" then
		return { s = "break" }
	end
	error( "Unexpected stmt pattern " .. p )
end

-- Get and return a for or forArray structure given the forControl parse tree node.
-- Return nil if there is an error.
local function getForStmt( forControl )
	local nodes = forControl.nodes
	if forControl.p == "array" then
		-- for (typeID nameID : arrayID) controlledStmts
		return { s = "forArray", typeID = nodes[1], varID = nodes[2], 
				arrayID = nodes[4], stmts = getControlledStmts() }
	else
		-- for (init; expr; next) controlledStmts
		local stmt = { s = "for", stmts = getControlledStmts() }

		-- Add the initStmt if any
		local forInit = nodes[1]
		if forInit.p == "varInit" then
			local ns = forInit.nodes
			stmt.initStmt = makeVar( true, ns[1], ns[2], ns[4] )
		elseif forInit.p == "stmt" then
			stmt.initStmt = getStmt( forInit.nodes[1] )
		end

		-- Add the expr if any
		local forExpr = nodes[3]
		if forExpr.p == "expr" then
			stmt.expr = makeExpr( forExpr.nodes[1] )
		end

		-- Add the nextStmt if any
		local forNext = nodes[5]
		if forNext.p == "stmt" then
			stmt.nextStmt = getStmt( forNext.nodes[1] )
		end
		return stmt
	end
end

-- Get and make stmt structure(s) from the given line parse tree,
-- which is not a "begin" or "end" pattern, and has already been passed.
-- Add the stmts to the stmts array. Return true if successful.
-- If there is an error then set the error state and return false.
function getLineStmts( tree, stmts )	
	-- Fail on syntax errors
	if tree.isError then
		return false
	end
	assert( tree.t == "line" )
	local p = tree.p
	local nodes = tree.nodes

	-- Look for var decls
	if getVar( p, nodes, stmts, true ) then
		checkMultiLineIndent( tree )
		return true
	end

	-- Handle the line patterns
	local stmt = nil
	if p == "stmt" then
		-- stmt ;
		checkMultiLineIndent( tree )
		stmt = getStmt( nodes[1] )
	elseif p == "if" then
		-- if (expr) controlledStmts [else controlledStmts]
		stmt = { s = "if", expr = makeExpr( nodes[3] ), 
				stmts = getControlledStmts(), 
				elseStmts = getElseStmts( tree ) }
	elseif p == "elseif" or p == "else" then
		-- Handling of an if above should also consume the else if any,
		-- so an else here is without a matching if.
		err.setErrNode( tree, "else without matching if (misplaced { } brackets?)")
		return false
	elseif p == "return" then
		-- TODO: Remember to check for return being only at end of a block
		stmt = { s = "return", expr = makeExpr( nodes[2] ) }
	elseif p == "do" then
		-- do controlledStmts while (expr);
		stmt = { s = "doWhile", stmts = getControlledStmts() }
		if stmt.stmts == nil then
			return nil
		end
		local endTree = parseTrees[iTree]
		iTree = iTree + 1
		if endTree.p ~= "while" then
			err.setErrNodeAndRef( endTree, tree, 
					"Expected while statement to end do-while loop" )
			return nil
		end
		local whileEnd = endTree.nodes[4]
		if whileEnd.p ~= "do-while" then
			err.setErrNodeAndRef( whileEnd, tree, 
					"while statement at end of do-while loop must end with a semicolon" )
			return nil
		end
		if javalex.indentLevelForLine( endTree.iLineStart ) ~= javalex.indentLevelForLine( tree.iLineStart ) then
			err.setErrNodeAndRef( endTree, tree, "This while statement should have the same indentation as its \"do\"" )
		end
		stmt.expr = makeExpr( endTree.nodes[3] )
	elseif p == "while" then
		-- while (expr) controlledStmts
		local whileEnd = nodes[4]
		if whileEnd.p ~= "while" then
			err.setErrNode( whileEnd, "while loop header should not end with a semicolon" )
			return nil
		end
		stmt = { s = "while", expr = makeExpr( nodes[3] ), stmts = getControlledStmts() }
	elseif p == "for" then
		-- for loop variants
		stmt = getForStmt( nodes[3] )
	else
		-- Invalid line pattern
		if p == "func" or p == "main" then
			err.setErrNode( tree, "Function definitions cannot occur inside a statement block")
		else
			err.setErrNode( tree, "Unexpected statement" )
		end
		return false
	end

	-- Add the stmt if successful
	if stmt then
		stmt.iLine = tree.iLine
		stmts[#stmts + 1] = stmt
		return true
	end
	return false
end

-- Process a block of statements beginning with { and ending with }
-- and return an array of stmt.
-- If there is an error then set the error state and return nil.
function getBlockStmts()
	-- Block must start with a {
	local iLineStart = parseTrees[iTree].iLine
	local beginIndent = javalex.indentLevelForLine( iLineStart )
	if not checkBlockBegin() then
		return false
	end

	-- Check block is indented from beginning {
	local prevTree, blockIndent
	if iTree <= numParseTrees then
		prevTree = parseTrees[iTree]
		blockIndent = javalex.indentLevelForLine( prevTree.iLineStart )
		if prevTree.p ~= "end" and blockIndent <= javalex.indentLevelForLine( iLineStart ) then
			err.setErrLineNumAndRefLineNum( prevTree.iLineStart, iLineStart,
					"Lines within { } brackets should be indented" )
		end
	end

	-- Get all lines until we get a matching end for the block begin
	local stmts = {}
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		local currIndent = javalex.indentLevelForLine( tree.iLineStart )
		iTree = iTree + 1    -- pass this line

		if p == "begin" then
			-- Ad-hoc blocks are not supported
			err.setErrLineNum( tree.iLine, "Unexpected {" )
			return nil
		elseif p == "end" then
			if currIndent ~= beginIndent then
				err.setErrLineNumAndRefLineNum( tree.iLineStart, iLineStart, 
						"A block's ending } should have the same indentation as its beginning {" )
			end
			return stmts   -- this ends our block
		else
			if currIndent ~= blockIndent then
				err.setErrLineNumAndRefLineNum( tree.iLineStart, prevTree.iLineStart, 
						"Unexpected change in indentation (Missing/misplaced curly brackets?)" )
			else
				prevTree = tree
			end
			getLineStmts( tree, stmts )
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
		return { s = "binOp", op = nodes[2].str, left = makeExpr( nodes[1] ),
				right = makeExpr( nodes[3] ) }
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
		iLine = nameID.iLine, 
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

	-- Save indentation level and line number of first member
	local firstMemberLineNum, firstMemberIndentLevel
	if iTree <= numParseTrees then
		firstMemberLineNum = parseTrees[iTree].iLineStart
		firstMemberIndentLevel = javalex.indentLevelForLine( firstMemberLineNum )
		if firstMemberIndentLevel == 0 then
			err.setErrLineNum( parseTrees[iTree].iLineStart,
					"Class member variable declarations and function definitions should be indented" )
		end
	end

	-- Look for instance variables and functions
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		local nodes = tree.nodes
		local ok = not tree.isError
		iTree = iTree + 1

		-- Check indentation
		if p ~= "end" then
			if javalex.indentLevelForLine( tree.iLineStart ) ~= firstMemberIndentLevel then
				err.setErrLineNumAndRefLineNum( tree.iLineStart, firstMemberLineNum,
						"Class member variable declarations and function definitions should all have the same indentation" )
			end
		else
			if javalex.indentLevelForLine( tree.iLine ) ~= 0 then
				err.setErrLineNum( tree.iLine, "The ending } of the program class should not be indented" )
			end
		end

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
				checkMultiLineIndent( tree )
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
	local str
	if node.iLine then
		str = string.format( "%3d.%s", node.iLine, string.rep( "    ", indentLevel ) )
	else
		str = string.rep( "    ", indentLevel + 1 )  -- empty line number takes one indent
	end
	if label then
		str = str .. label .. ": "
	end
	if node.s == "binOp" then
		str = str .. "(" .. node.op .. ")"
	else
		str = str .. node.s
		if node.op then
			str = str .. " (" .. node.op .. ")"
		end
	end
	if node.nameID and node.nameID.str then
		str = str .. " " .. node.nameID.str
	end

	-- Add misc fields if any 
	local miscFieldsStr = ""
	local first = true
	for field, value in pairs( node ) do
		if field ~= "s" and field ~= "iLine" and field ~= "nameID" and field ~= "op" then
			local fieldStr = nil
			if type(value) == "table" then
				if value.tt then  
					-- A token
					fieldStr = field .. " = " .. value.str  
				elseif value.s == nil then
					-- An array
					fieldStr = "#" .. field .. " = " .. #value
				end
			elseif type(value) == "string" then
				fieldStr = field .. " = " .. "\"" .. value .. "\""
			else  -- number or boolean
				fieldStr = field .. " = " .. tostring( value )
			end

			if fieldStr then
				if first then
					miscFieldsStr = miscFieldsStr .. fieldStr
					first = false
				else
					miscFieldsStr = miscFieldsStr .. ", " .. fieldStr
				end
			end
		end
	end
	if miscFieldsStr ~= "" then
		str = str .. " { " .. miscFieldsStr .. " }"
	end

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
				str = string.rep( "    ", indentLevel + 2 ) .. field .. ":"
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
-- and return the program structure tree (see above).
-- If there is an error then set the error state and return nil.
function parseProgram.getProgramTree( sourceLines, syntaxLevel )
	-- Init the parse structures
	parseTrees = {}
	programTree = { s = "program", vars = {}, funcs = {} }

	-- Parse the lines and build the parseTrees array
	parseJava.initProgram()
	local startTokens = nil
	local iLineStart = nil
	numSourceLines = #sourceLines
	for lineNum = 1, numSourceLines do
		local tree, tokens = parseJava.parseLine( sourceLines[lineNum], 
									lineNum, startTokens, syntaxLevel )
		if tree == false then
			-- Line is incomplete, carry tokens forward to next line
			assert( type(tokens) == "table" )
			startTokens = tokens
			if iLineStart == nil then
				iLineStart = lineNum  -- remember what line this multi-line parse stated on
			end
		else
			startTokens = nil
			if tree == nil then
				-- Syntax error: Use stub error tree
				tree = { isError = true, iLine = lineNum }
			end 
			if tree.p ~= "blank" then
				tree.iLineStart = iLineStart or lineNum
				parseTrees[#parseTrees + 1] = tree
			end
			iLineStart = nil
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
	-- printStructureTree( programTree, 0 )

	-- Return parse trees also for now (TODO: temp)
	if err.shouldStop() then
		return nil
	end
	return programTree, parseTrees
end

-- Print a program structure tree to the given output file or to the console
-- if file is not included.
function parseProgram.printProgramTree( programTree, file )
	printStructureTree( programTree, 0, file )
end


------------------------------------------------------------------------------

return parseProgram
