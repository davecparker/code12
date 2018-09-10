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
local javaTypes = require( "javaTypes" )
local err = require( "err" )
local javalex = require( "javalex" )

-- The parseProgram module
local parseProgram = {}


-- A structure tree is a language-independent representation of a Code12 program.
-- It is made up of the following structure nodes, tokens, nested structures, 
-- and arrays (plural names), with the following named fields:
--
-- In addition, for error hilighting, any structure node may add firstToken 
-- and/or lastToken fields to extend the span of tokens referenced by that strucure,
-- or a entireLine = true field to reference the entire source line.
--
-- program: 
--     { s = "program", nameID, vars, funcs }
--
-- var:  (Semantic analysis adds assigned field)
--     { s = "var", iLine, nameID, vt, isConst, isGlobal, initExpr }
--
-- func:
--     { s = "func", iLine, nameID, vt, isPublic, isStatic, paramVars, stmts }
--
-- stmt:
--     { s = "var", iLine, nameID, vt, isConst, isGlobal, initExpr }
--     { s = "call", iLine, lValue, nameID, exprs }
--     { s = "assign", iLine, lValue, opToken, opType, expr }   -- opType: =, +=, -=, *=, /=, ++, --
--     { s = "if", iLine, expr, stmts, elseStmts }
--     { s = "while", iLine, expr, stmts }
--     { s = "doWhile", iLine, expr, stmts }
--     { s = "for", iLine, initStmt, expr, nextStmt, stmts }
--     { s = "forArray", iLine, var, expr, stmts }
--     { s = "break", iLine }
--     { s = "return", iLine, expr }
--
-- lValue:  (Semantic analysis adds isGlobal and vt fields)
--     { s = "lValue", varID, indexExpr, fieldID }
-- 
-- expr:  (Semantic analysis adds a vt field)
--     { s = "literal", token }       -- token.tt: NUM, BOOL, NULL, STR
--     { s = "call", lValue, nameID, exprs }
--     { s = "lValue", varID, indexExpr, fieldID }
--     { s = "cast", vt, expr }
--     { s = "parens", expr }
--     { s = "unaryOp", opToken, opType, expr }        -- opType: neg, not
--     { s = "binOp", left, opToken, opType, right }   -- opType: *, /, %, +, -, <, <=, >, >=, ==, !=, &&, ||
--     { s = "newArray", vt, lengthExpr }
--     { s = "arrayInit", exprs }
--     { s = "new", nameID, exprs }
--
-- There are several types of calls possible. Examples at increasing syntax level:
--    level                         lValue          nameID
--    -----                         ---------       ------
--    (1)    ct.circle()            ct              circle
--    (1)    System.out.println()   System.out      println
--    (7)    ball.delete()          ball            delete
--    (7)    str.equals()           str             equals
--    (7)    Math.sin()             Math            sin
--    (7)    b.group.equals()       b.group         equals
--    (9)    foo()                                  foo
--    (12)   a[3].delete()          a[3]            delete
--    (12)   s[3].equals()          s[3]            equals
--    (12)   a[3].group.equals()    a[3].group      equals


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
	if p == "func" then
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

-- Parse the required program header directly from sourceLines and return
-- (programTree, lineNum) where programTree is the initial programTree structure 
-- and lineNum is the next line number after the lines processed.
-- Return nil if there is an unrecoverable error.
local function parseHeader( sourceLines )
	-- "import", "ID", ".", "*", ";", "END"     (ID = "Code12")
	local lineNum = 1
	local nameID = nil
	local numSourceLines = #sourceLines
	local iLineImport = nil
	while lineNum < numSourceLines do
		local tokens = javalex.getTokens( sourceLines[lineNum], lineNum )
		if tokens and #tokens > 1 then  -- skip if blank or lexical error
			if tokens[1].tt == "import" then
				if #tokens == 6 and tokens[2].str == "Code12" 
						and tokens[3].tt == "." and tokens[4].tt == "*" 
						and tokens[5].tt == ";" then
					iLineImport = lineNum
				else
					err.setErrLineNum( lineNum, 
							"Code12 programs should import only Code12.*" )
				end
			else
				break
			end
		end
		lineNum = lineNum + 1
	end
	if iLineImport then
		-- print( "Got import" )
	else
		err.setErrLineNum( lineNum, 
			'Code12 programs must start with:\n"import Code12.*;"' )
	end

	-- "class", "ID", "extends", "ID",	"END"    (2nd ID = "Code12Program")
	local iLineClass = nil
	while lineNum < numSourceLines do
		local tokens = javalex.getTokens( sourceLines[lineNum], lineNum )
		if tokens and #tokens > 1 then  -- skip if blank or lexical error
			if tokens[1].tt == "class" then
				if iLineClass then
					err.setErrLineNumAndRefLineNum( lineNum, iLineClass,
							"There should be only one class declaration" )
				else
					iLineClass = lineNum
					if #tokens == 5 and tokens[2].tt == "ID" 
							and tokens[3].tt == "extends" 
							and tokens[4].str == "Code12Program" then
						-- Get the class name
						nameID = tokens[2]
						-- Check that nameID is valid (not a defined class) and for initial upper case letter in name
						local className = nameID.str
						local chFirst = string.byte( className, 1 )
						if javaTypes.isKnownClassName( className ) then
							err.setErrNode( nameID,
									"The class name %s is already defined. Choose another name.", className )
						elseif chFirst < 65 or chFirst > 90 then
							err.setErrNode( nameID, 
									"By convention, class names should start with an upper-case letter" )
						end
						-- Check that the class header is not indented
						if javalex.indentLevelForLine( iLineClass ) ~= 0 then
							err.setErrLineNum( iLineClass, "The class header shouldn't be indented" )
						end
						-- TODO: What about extra code after 5 tokens, e.g. {
					else
						err.setErrLineNum( lineNum,
								'A Code12 class declaration should be:\n"class YourName extends Code12Program"' )
					end
				end
			else
				break
			end
		end
		lineNum = lineNum + 1
	end
	if iLineClass then
		-- print( "Got class" )
	else
		err.setErrLineNum( lineNum,
				'Code12 programs must start with:\n"class YourName extends Code12Program"' )
	end

	-- Beginning { for the class
	local iLineBegin = nil
	while lineNum < numSourceLines do
		local tokens = javalex.getTokens( sourceLines[lineNum], lineNum )
		if tokens and #tokens > 1 then  -- skip if blank or lexical error
			if #tokens == 2 and tokens[1].tt == "{" then
				iLineBegin = lineNum
				-- Check that beginning { is not indented
				if javalex.indentLevelForLine( iLineBegin ) ~= 0 then
					err.setErrLineNum( iLineBegin, "The beginning { for the class shouldn't be indented" )
				end
			end
			break
		end
		lineNum = lineNum + 1
	end
	if iLineBegin then
		-- Success or good enough to continue
		-- print( "Got begin" )
		local program = { s = "program", nameID = nameID, vars = {}, funcs = {} }
		return program, lineNum + 1
	end
	err.setErrLineNum( lineNum, "Your class should start with a { on its own line" )
	return nil   -- probably not good to keep parsing after this
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

-- Make and return a var given the parsed fields.
-- If there is an error then set the error state.
local function makeVar( isGlobal, access, typeID, nameID, initExpr, isArray, isConst )
	-- Access is optional and ignored for instance variables, not allowed otherwise
	if not isGlobal and access and access.p ~= "empty" then
		err.setErrNode( access, "Access specifiers are only allowed on class-level variables" )
	end

	return {
		s = "var",
		iLine = nameID.iLine,
		firstToken = typeID,
		nameID = nameID,
		vt = javaTypes.vtFromVarType( typeID, isArray ),
		isConst = isConst,
		isGlobal = isGlobal,
		initExpr = makeExpr( initExpr )
	}
end

-- Check for a variable declaration or initialization for line pattern p and 
-- the parse nodes, and add variable(s) to the structure array structs.
-- The variable(s) are global if isGlobal is included and true.
-- Return true if the pattern was a variable pattern, else false.
local function getVar( p, nodes, structs, isGlobal )
	if p == "varInit" then
		-- e.g. int x = 10;
		structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[2], 
									nodes[3], nodes[5] )
	elseif p == "varDecl" then
		-- e.g. int x, y;
		for _, nameID in ipairs( nodes[3].nodes ) do
			structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[2], nameID )
		end
	elseif p == "constInit" then
		-- e.g. final int LIMIT = 100;
		structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[3], 
									nodes[4], nodes[6], nil, true )			
	elseif p == "arrayInit" then
		-- e.g. int[] a = { 1, 2, 3 };   or   int[] a = new int[10];
		structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[2], 
									nodes[5], nodes[7], true )						
	elseif p == "arrayDecl" then
		-- e.g. GameObj[] coins, walls;
		for _, nameID in ipairs( nodes[5].nodes ) do
			structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[2], 
										nameID, nil, true )
		end	
	else
		return false   -- not a variable pattern
	end
	return true
end	

-- Make and return an lValue structure from the parse node parts.
-- The indexd and field can be nil 
local function makeLValueFromNodes( varID, index, field )
	local indexExpr = nil
	local lastToken = nil
	if index and index.p == "index" then
		indexExpr = makeExpr( index.nodes[2] )
		lastToken = index.nodes[3]
	end
	local fieldID = nil
	if field and field.p ~= "empty" then
		fieldID = field.nodes[2]
		lastToken = nil   -- don't need this anymore
	end
	return { s = "lValue", varID = varID, 
			indexExpr = indexExpr, fieldID = fieldID, lastToken = lastToken }
end

-- Make and return an lValue structure from an ID token or lValue parse node 
local function makeLValue( node )
	if node.tt == "ID" then
		return { s = "lValue", varID = node }
	end
	assert( node.t == "lValue" )
	local nodes = node.nodes
	return makeLValueFromNodes( nodes[1], nodes[2], nodes[3] )
end

-- Make and return an exprs array from an exprList parse tree
local function makeExprs( exprList )
	assert( exprList.t == "exprList" )
	local exprNodes = exprList.nodes
	if #exprNodes == 0 then
		return nil
	end
	local exprs = {}
	for i = 1, #exprNodes do
		exprs[i] = makeExpr( exprNodes[i] )
	end
	return exprs
end

-- Make and return a call structure from a call parse tree's nodes array.
-- Return nil if there was an error.
local function makeCall( nodes )
	-- Determine the lValue and nameID
	local lValue, nameID
	local fnValue = nodes[1]
	local ns = fnValue.nodes  -- ID, index, member, member
	local firstID = ns[1]
	local index = ns[2]
	local member1 = ns[3]
	local member2 = ns[4]
	if member2.p == "member" then
		-- e.g. System.out.println(), b.group.equals(), a[3].group.equals()
		lValue = makeLValueFromNodes( firstID, index, member1 )
		nameID = member2.nodes[2]
	elseif member1.p == "member" then
		-- e.g.  ct.circle(), ball.delete(), str.equals(), Math.sin(), 
		-- a[3].delete(), s[3].equals()
		lValue = makeLValueFromNodes( firstID, index )
		nameID = member1.nodes[2]
	else
		-- e.g. foo()
		if index.p == "index" then
			-- ERROR e.g. foo[3]()
			err.setErrNodeSpan( firstID, index, "Invalid function name" )
		end
		lValue = nil
		nameID = firstID
	end

	-- Make the call structure
	return { s = "call", lValue = lValue, nameID = nameID, 
			exprs = makeExprs( nodes[3] ), lastToken = nodes[4] }
end

-- Make and return a cast structure given the parse tree nodes. 
-- The only supported type cast is currently (int). 
-- In other cases, set the error state.
-- Note this means that some parses involving (varName) are not allowed.
local function makeCast( nodes )
	local typeID = nodes[2]
	if typeID.str ~= "int" then
		err.setErrNode( typeID, "The only type cast supported by Code12 is (int)" )
	end
	return { s = "cast", vt = 0, expr = makeExpr( nodes[4] ), firstToken = nodes[1] }
end

-- Get the single controlled stmt or block of controlled stmts for an 
-- if, else, or loop, and return an array of stmt structures. 
-- If the next item to process is a begin block then get an entire block 
-- of stmts until the matching block end, otherwise get a single stmt. 
-- Return nil if there was an error.
local function getControlledStmts()
	local ctrlTree = parseTrees[iTree - 1] -- tree for the controlling statement
	local ctrlIndent = javalex.indentLevelForLine( ctrlTree.iLineStart )
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
		local stmtIndent = javalex.indentLevelForLine( tree.iLineStart )
		if stmtIndent <= ctrlIndent then
			err.setErrLineNumAndRefLineNum( tree.iLineStart, ctrlTree.iLineStart, 
					"This line should be indented more than its controlling \"%s\"", ctrlTree.p )
		end
		iTree = iTree + 1  -- pass the controlled stmt as expected by getLineStmts
		local stmts = {}
		if getLineStmts( tree, stmts ) then
			-- Check if indentation implies missing { or stray } after controlling stmt
			if iTree <= numParseTrees then
				local nextTree = parseTrees[iTree]
				local nextP = nextTree.p
				local nextIndent = javalex.indentLevelForLine( nextTree.iLineStart )
				if nextP == "end" then
					if nextIndent >= ctrlIndent then
						err.setErrLineNum( nextTree.iLineStart, "Unexpected indentation. Stray closing } bracket?" )
					end
				elseif nextIndent == stmtIndent and nextIndent ~= ctrlIndent
						and not (ctrlTree.p == "do" and nextTree.p == "while" and nextTree.nodes[4].p == "doWhile") then
					err.setErrLineNumAndRefLineNum( nextTree.iLineStart, ctrlTree.iLineStart,
							'This line is not controlled by the "%s" above it. Missing { } bracket(s) or improperly indented?', 
							ctrlTree.p )
				end
			end
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
		checkMultiLineIndent( tree );
		-- Controlled stmts is a single stmt, which is the following if
		iTree = iTree + 1
		return { { s = "if", expr = makeExpr( tree.nodes[4] ), 
				stmts = getControlledStmts(), 
				elseStmts = getElseStmts( ifTree ),
				entireLine = true } }
	end
	return nil	
end

-- Get and return a stmt structure for the given stmt parse tree.
-- The iLine field must be assigned by the caller.
-- Return nil if there is an error.
local function getStmt( node )
	local p = node.p
	local nodes = node.nodes

	if p == "call" then
		return makeCall( nodes )
	elseif p == "assign" then
		return { s = "assign", lValue = makeLValue( nodes[1] ), opToken = nodes[2], 
				opType = "=", expr = makeExpr( nodes[3] ) }
	elseif p == "opAssign" then
		local opAssignOp = nodes[2]
		return { s = "assign", lValue = makeLValue( nodes[1] ),  
				opToken = opAssignOp.nodes[1], opType = opAssignOp.p, 
				expr = makeExpr( nodes[3] ) }
	elseif p == "preInc" or p == "preDec" then
		local opToken = nodes[1]
		return { s = "assign", lValue = makeLValue( nodes[2] ), opToken = opToken,
				opType = opToken.str }
	elseif p == "postInc" or p == "postDec" then
		local opToken = nodes[2]
		return { s = "assign", lValue = makeLValue( nodes[1] ), opToken = opToken,
				opType = opToken.str }
	end
	error( "Unexpected stmt pattern " .. p )
end

-- Get and return a for or forArray structure given the line parse tree nodes.
-- Return nil if there is an error.
local function getForStmt( nodes )
	local iLine = nodes[1].iLine
	local forControl = nodes[3]
	nodes = forControl.nodes
	if forControl.p == "array" then
		-- for (typeID nameID : arrayID) controlledStmts
		return { 
			s = "forArray", 
			var = makeVar( false, nil, nodes[1], nodes[2] ),
			expr = makeExpr( nodes[4] ), 
			stmts = getControlledStmts(),
			entireLine = true, 
		}
	else
		-- for (init; expr; next) controlledStmts
		local stmt = { 
			s = "for", 
			stmts = getControlledStmts(), 
			entireLine = true 
		}

		-- Add the initStmt if any
		local forInit = nodes[1]
		if forInit.p == "var" then
			local ns = forInit.nodes
			stmt.initStmt = makeVar( false, nil, ns[1], ns[2], ns[4] )
		elseif forInit.p == "stmt" then
			stmt.initStmt = getStmt( forInit.nodes[1] )
			stmt.initStmt.iLine = iLine
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
			stmt.nextStmt.iLine = iLine
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
	if getVar( p, nodes, stmts ) then
		checkMultiLineIndent( tree )
		return true
	end

	-- Handle the line patterns
	local stmt
	if p == "stmt" then
		-- stmt ;
		checkMultiLineIndent( tree )
		stmt = getStmt( nodes[1] )
	elseif p == "if" then
		-- if (expr) controlledStmts [else controlledStmts]
		checkMultiLineIndent( tree )
		stmt = { s = "if", expr = makeExpr( nodes[3] ), 
				stmts = getControlledStmts(), 
				elseStmts = getElseStmts( tree ), entireLine = true }
	elseif p == "elseif" or p == "else" then
		-- Handling of an if above should also consume the else if any,
		-- so an else here is without a matching if.
		err.setErrNode( tree, "else without matching if (misplaced { } brackets?)")
		return false
	elseif p == "returnVal" then
		-- return expr ;
		-- TODO: Check for return being only at end of a block
		checkMultiLineIndent( tree )
		stmt = { s = "return", expr = makeExpr( nodes[2] ), firstToken = nodes[1] }
	elseif p == "return" then
		-- return ;
		stmt = { s = "return", firstToken = nodes[1] }
	elseif p == "do" then
		-- do controlledStmts while (expr);
		stmt = { s = "doWhile", stmts = getControlledStmts(), entireLine = true }
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
		if whileEnd.p ~= "doWhile" then
			err.setErrNodeAndRef( whileEnd, tree, 
					"while statement at end of do-while loop must end with a semicolon" )
			return nil
		end
		if javalex.indentLevelForLine( endTree.iLineStart ) ~= javalex.indentLevelForLine( tree.iLineStart ) then
			err.setErrNodeAndRef( endTree, tree, "This while statement should have the same indentation as its \"do\"" )
		end
		checkMultiLineIndent( endTree )
		stmt.expr = makeExpr( endTree.nodes[3] )
	elseif p == "while" then
		-- while (expr) controlledStmts
		local whileEnd = nodes[4]
		if whileEnd.p ~= "while" then
			err.setErrNode( whileEnd, "while loop header should not end with a semicolon" )
			return nil
		end
		checkMultiLineIndent( tree )
		stmt = { s = "while", expr = makeExpr( nodes[3] ), stmts = getControlledStmts(),
				entireLine = true }
	elseif p == "for" then
		-- for loop variants
		checkMultiLineIndent( tree )
		stmt = getForStmt( nodes )
	elseif p == "break" then
		-- break ;
		stmt = { s = "break", firstToken = nodes[1] }
	else
		-- Invalid line pattern
		if p == "func" then
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
						"Unexpected change in indentation (Missing/misplaced { } brackets?)" )
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
		local nodes = node.nodes
		if node.p == "list" then
			local exprs = {}
			for _, exprNode in ipairs( nodes[2].nodes ) do
				exprs[#exprs + 1] = makeExpr( exprNode )
			end	
			return { s = "arrayInit", exprs = exprs, 
					firstToken = nodes[1], lastToken = nodes[3] }
		else
			node = nodes[1]
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
	elseif p == "cast" then
		return makeCast( nodes )
	elseif p == "exprParens" then
		return { s = "parens", expr = makeExpr( nodes[2] ) }
	elseif p == "neg" or p == "not" then
		return { s = "unaryOp", opToken = nodes[1], opType = p, 
				expr = makeExpr( nodes[2] ) }
	elseif p == "newArray" then
		return { s = "newArray", vt = javaTypes.vtFromVarType( nodes[2] ), 
				lengthExpr = makeExpr( nodes[4] ), firstToken = nodes[1],
				lastToken = nodes[5] }
	elseif p == "new" then
		return { s = "new", nameID = nodes[2], exprs = makeExprs( nodes[4] ),
				firstToken = nodes[1], lastToken = nodes[5] }
	else  -- binary operator
		local opToken = nodes[2]
		return { s = "binOp", opToken = opToken, opType = opToken.str,
				left = makeExpr( nodes[1] ), right = makeExpr( nodes[3] ) }
	end
end

-- Make and return a function member given the parsed fields,
-- including the contained statements, and move iTree past it.
-- If there is an error then set the error state and return nil.
local function getFunc( nodes )
	local accessP = nodes[1].p
	local retType = nodes[2]
	local typeID = retType.nodes[1]
	local isArray = (retType.p == "array") or nil
	local nameID = nodes[3]
	local paramList = nodes[5]

	-- Build the paramVars array
	local paramVars = {}
	for _, node in ipairs( paramList.nodes ) do
		local ns = node.nodes
		if node.p == "array" then
			paramVars[#paramVars + 1] = makeVar( false, nil, ns[1], ns[4], nil, true )
		else
			paramVars[#paramVars + 1] = makeVar( false, nil, ns[1], ns[2] )
		end
	end

	-- Get the stmts array
	local stmts = getBlockStmts()
	if stmts == nil then
		return nil
	end

	-- Make the func
	local func = { 
		s = "func",
		iLine = nameID.iLine,
		nameID = nameID,
		vt = javaTypes.vtFromType( typeID, isArray ),
		paramVars = paramVars, 
		stmts = stmts,
		entireLine = true, 
	}

	-- Add the access flags and return it
	if accessP == "publicStatic" then
		func.isPublic = true
		func.isStatic = true
	elseif accessP == "public" then
		func.isPublic = true
	end
	return func
end

-- Check and build the members, ending with and including the } at 
-- the end of the program class.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function getMembers()
	local vars = programTree.vars
	local funcs = programTree.funcs
	local gotFunc = false     -- set to true when the first func was seen

	-- Save indentation level and line number of first member
	local firstMemberLineNum, firstMemberIndentLevel
	if iTree <= numParseTrees then
		firstMemberLineNum = parseTrees[iTree].iLineStart
		firstMemberIndentLevel = javalex.indentLevelForLine( firstMemberLineNum )
		if firstMemberIndentLevel == 0 then
			err.setErrLineNum( parseTrees[iTree].iLineStart,
					"Class-level variable and function definitions should be indented" )
		end
	end

	-- Look for instance variables and functions
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		local nodes = tree.nodes
		local ok = not tree.isError
		iTree = iTree + 1

		-- Check for consistent indentation of the members
		if p ~= "end" then
			if javalex.indentLevelForLine( tree.iLineStart ) ~= firstMemberIndentLevel then
				err.setErrLineNumAndRefLineNum( tree.iLineStart, firstMemberLineNum,
						"Class-level variable and function definitions should all have the same indentation" )
			end
		end

		if ok and getVar( p, nodes, vars, true ) then
			-- Added instance variable(s)
			-- Code12 does not allow instance variables to follow member functions,
			-- because it greatly complicates keeping Java and Lua line numbers in sync.
			if gotFunc then
				err.setErrNode( tree, "Class-level variables must be defined at the beginning of the class" )
			end 
			checkMultiLineIndent( tree )
		elseif p == "func" then
			-- User function or event definition
			if ok then
				funcs[#funcs + 1] = getFunc( nodes )
				checkMultiLineIndent( tree )
			else
				getBlockStmts()  -- skip body of invalid function defintion
			end
			gotFunc = true
		elseif p == "end" then
			-- The end of the class
			if javalex.indentLevelForLine( tree.iLine ) ~= 0 then
				err.setErrLineNum( tree.iLine, "The ending } of the program class should not be indented" )
			end
			return true
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
		str = str .. "(" .. node.opType .. ")"
	else
		str = str .. node.s
		if node.opType then
			str = str .. " (" .. node.opType .. ")"
		end
	end
	if node.nameID and node.nameID.str then
		str = str .. " " .. node.nameID.str
	end

	-- Add misc fields if any 
	local miscFieldsStr = ""
	local first = true
	for field, value in pairs( node ) do
		local fieldStr = nil
		if field == "vt" then
			fieldStr = field .. " = " .. javaTypes.typeNameFromVt( value )
		elseif field ~= "s" and field ~= "iLine" and field ~= "nameID" 
				and field ~= "opToken" and field ~= "opType" 
				and field ~= "firstToken" and field ~= "lastToken" 
				and field ~= "entireLine" then
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
	-- Init the parse state
	parseJava.initProgram()
	parseTrees = {}

	-- Parse the required program header
	local lineNum
	programTree, lineNum = parseHeader( sourceLines )
	if programTree == nil then
		return nil
	end

	-- Parse the remaining lines and build the parseTrees array
	local startTokens = nil
	local iLineStart = nil
	numSourceLines = #sourceLines
	print(lineNum, numSourceLines)
	while lineNum <= numSourceLines do
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
		lineNum = lineNum + 1
	end

	-- Check for unclosed block comment
	local iLineComment = javalex.iLineStartOfUnclosedBlockComment()
	if iLineComment then
		err.setErrLineNum( iLineComment, "Comment started with /* was not closed with */" )
		return nil
	end

	-- Add sentinel parse tree at the end
	numParseTrees = #parseTrees
	parseTrees[#parseTrees + 1] = 
			{ t = "line", p = "EOF", nodes = {}, 
				iLine = numSourceLines + 1, iLineStart = numSourceLines + 1 }

	-- Get the member vars and funcs
	iTree = 1
	if getMembers() then
		-- We should be at the EOF now
		if parseTrees[iTree].p ~= "EOF" then
			err.overrideErrLineParseTree( parseTrees[iTree],
					"Unexpected line after end of class -- mismatched { } brackets?" )
			return nil
		end
	end

	-- Return result
	if err.shouldStop() then
		return nil
	end
	return programTree
end

-- Print a program structure tree to the given output file or to the console
-- if file is not included.
function parseProgram.printProgramTree( tree, file )
	printStructureTree( tree, 0, file )
end


------------------------------------------------------------------------------

return parseProgram
