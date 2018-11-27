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
local source = require( "source" )
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
-- block:
--     { s = "block", iLineBegin, stmts, iLineEnd }
--
-- func:
--     { s = "func", iLine, nameID, vt, isPublic, isStatic, isError, paramVars, block }
--
-- stmt:
--     { s = "var", iLine, nameID, vt, isConst, isGlobal, initExpr }
--     { s = "call", iLine, class, lValue, nameID, exprs }
--     { s = "assign", iLine, lValue, opToken, opType, expr }   -- opType: =, +=, -=, *=, /=, ++, --
--     { s = "if", iLine, expr, block, elseBlock }
--     { s = "while", iLine, expr, block }
--     { s = "doWhile", iLine, expr, block, iLineWhile }
--     { s = "for", iLine, initStmt, expr, nextStmt, block }
--     { s = "forArray", iLine, var, expr, block }
--     { s = "break", iLine }
--     { s = "return", iLine, expr }
--
-- lValue:  (Semantic analysis adds isGlobal and vt fields)
--     { s = "lValue", varID, indexExpr, fieldID }
-- 
-- expr:  (Semantic analysis adds a vt field)
--     (expr nodes can also be a single literal token (INT, NUM, BOOL, NULL, or STR) node)
--     { s = "call", class, lValue, nameID, exprs }
--     { s = "lValue", varID, indexExpr, fieldID }
--     { s = "staticField", class, fieldID }
--     { s = "cast", vtCast, expr }
--     { s = "parens", expr }
--     { s = "unaryOp", opToken, opType, expr }        -- opType: neg, not
--     { s = "binOp", left, opToken, opType, right }   -- opType: *, /, %, +, -, <, <=, >, >=, ==, !=, &&, ||
--     { s = "newArray", vtElement, lengthExpr }
--     { s = "arrayInit", exprs }
--     { s = "new", nameID, exprs }
--
-- There are several types of calls possible. Examples at increasing syntax level:
--    level                         class       lValue          nameID
--    -----                         -----       ---------       ------
--    (1)    ct.circle()            ct                          circle
--    (1)    System.out.println()   System      out             println
--    (5)    Math.sin()             Math                        sin
--    (7)    ball.delete()                      ball            delete
--    (7)    str.equals()                       str             equals
--    (7)    b.group.equals()                   b.group         equals
--    (9)    foo()                                              foo
--    (12)   a[3].delete()                      a[3]            delete
--    (12)   s[3].equals()                      s[3]            equals
--    (12)   a[3].group.equals()                a[3].group      equals


-- Parsing state
local parseTrees        -- array of parse trees for each source line
local numParseTrees     -- number of trees in parseTrees not counting the sentinel
local iTree             -- current tree index in parseTrees being analyzed

-- Forward declarations
local makeExpr
local getBlock
local getLineStmts


--- Internal Functions -------------------------------------------------------

-- Check for inconsistent tabs/spaces between the given line and previous line
local function checkIndentTabsAndSpaces( lineRec, lineRecPrev )
	local indLvl = lineRec.indentLevel
	local prevIndLvl = lineRecPrev.indentLevel
	if indLvl > 0 and prevIndLvl > 0 then
		-- Both lines have indent: Check for inconsistent tabs
		local indentStr = lineRec.indentStr
		local prevIndentStr = lineRecPrev.indentStr
		if indLvl == prevIndLvl and indentStr ~= prevIndentStr
				or indLvl > prevIndLvl and string.sub( indentStr, 1, prevIndLvl ) ~= prevIndentStr
				or indLvl < prevIndLvl and string.sub( prevIndentStr, 1, indLvl ) ~= indentStr then
			err.setErrLineNumAndRefLineNum( lineRec.iLine, lineRecPrev.iLine,
					"Mix of tabs and spaces used for indentation is not consistent with the previous line of code" )
		end
	end
end

-- Set an error when a block's begining { does not have the same indentation as its function header
-- or control statement
local function indentErrBlockBegin( tree, prevTree )
	local p = prevTree.p
	local strErr
	if p == "func" then
		strErr = "The {  after a function header should have the same indentation as the function header"
	elseif p == "if" then
		strErr = "The {  after an if statement should have the same indentation as the \"if\""
	elseif p == "elseif" then
		strErr = "The {  after an else if statement should have the same indentation as the \"else if\""
	elseif p == "else" then
		strErr = "The {  after an \"else\" should have the same indentation as the \"else\""
	elseif p == "do" then
		strErr = "The {  after a \"do\" should have the same indentation as the \"do\""
	elseif p == "while" then
		strErr = "The {  after a while loop header should have the same indentation as the \"while\""
	elseif p == "for" then
		strErr = "The {  after a for loop header should have the same indentation as the \"for\""
	elseif p == "class" then
		strErr = "The {  that begins a class should not be indented"
	else
		strErr = "The {  beginning a block should have the same indentation as the line before it"
	end
	err.setErrLineNumAndRefLineNum( tree.iLine, prevTree.iLineStart, strErr )
end

-- Check indentation for multi-line var decls, function defs, and calls
local function checkMultiLineIndent( tree )
	if tree.iLineStart ~= tree.iLine then
		local startIndent = tree.indentLevel
		for lineNum = tree.iLineStart + 1, tree.iLine do
			local lineRec = source.lines[lineNum]
			if lineRec.hasCode and lineRec.indentLevel <= startIndent then
				err.setErrLineNumAndRefLineNum( lineNum, tree.iLineStart, 
						"The lines after the first line of a multi-line statement should be indented further than the first line" )
				break
			end
		end
	end
end

-- Check for a block begin and move iTree past it.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function checkBlockBegin()
	local tree = parseTrees[iTree]
	if tree.p == "begin" then
		local prevTree = parseTrees[iTree - 1]
		if prevTree and tree.indentLevel ~= prevTree.indentLevel then
			indentErrBlockBegin( tree, prevTree )
		end
		iTree = iTree + 1
		return true
	end
	err.overrideErrLineParseTree( tree, "Expected {" )	
	return false
end

-- Parse the required program header and return the root program structure.
-- Return nil if the there is an unrecoverable error.
local function getProgramHeader()
	-- Since we're at the very beginning of the program and there may be
	-- who knows what syntax errors and whatnot, try to find the class header 
	-- parse tree in the source lines directly.
	local iLine = 1
	local tree = nil
	-- Find the first line of code, skipping blanks/comments and imports
	while iLine <= source.numLines do
		tree = source.lines[iLine].parseTree
		if tree == nil then
			break  -- a line with a syntax error
		elseif tree.p == "import" then
			-- Silently allow import of Code12 package
			if tree.nodes[2].str == "Code12" then
				err.clearErr( iLine )   -- was reported as common parse error
			end
		elseif tree.p ~= "blank" then
			break
		end
		iLine = iLine + 1
	end

	-- Check for the class header
	if tree == nil or tree.p ~= "class" then
		err.clearErr( iLine )
		err.setErrLineNum( iLine, 
				"Code12 programs must start with:\nclass YourProgramName" )
		return nil
	end

	-- Move iTree past the class header we found
	iTree = 1
	while parseTrees[iTree] ~= tree do
		iTree = iTree + 1   -- skipping items before it
	end
	iTree = iTree + 1  -- pass the class header

	-- Check for valid class access specifier
	local nodes = tree.nodes
	local access = nodes[1]
	if access and access.p ~= "public" then
		err.setErrNode( access, 
				'A Code12 class should be declared "public" or nothing/default' )
	end

	-- Check that class name is valid (not a defined class) and starts with upper case letter
	local nameID = nodes[3]
	local className = nameID.str
	local chFirst = string.byte( className, 1 )
	local tt, strCorrectCase, _ = javalex.knownName( className ) 
	if tt and strCorrectCase == className then
		err.setErrNode( nameID,
				"The name %s is already defined. Choose another name for your class.", className )
	elseif chFirst < 65 or chFirst > 90 then
		err.setErrNode( nameID, 
				"By convention, class names should start with an upper-case letter" )
	end

	-- Check that the class header is not indented
	if tree.indentLevel ~= 0 then
		err.setErrLineNum( tree.iLineStart, "The class header shouldn't be indented" )
	end

	-- Check for the { to start the class block
	if not checkBlockBegin() then
		-- Report this error on the line right after the class even if blank or comment
		err.clearErr( tree.iLine + 1 )
		err.setErrLineNum( tree.iLine + 1, "Expected {  to start the class body" )
	end

	-- Return the root program structure node
	return { s = "program", nameID = nameID, vars = {}, funcs = {} }
end

-- Make and return a var given the parsed fields and optional initExpr structure.
-- If there is an error then set the error state.
local function makeVar( isGlobal, access, typeNode, nameID, initExpr, isArray, isConst )
	-- Access is optional and ignored for instance variables, not allowed otherwise
	if not isGlobal and access then
		err.setErrNode( access, "Access specifiers are only allowed on class-level variables" )
	end

	return {
		s = "var",
		iLine = nameID.iLine,
		firstToken = typeNode,
		nameID = nameID,
		vt = javaTypes.vtFromVarType( typeNode, isArray ),
		isConst = isConst,
		isGlobal = isGlobal,
		initExpr = initExpr,
	}
end

-- Make and return an exprs array from an exprList parse tree
local function makeExprs( exprList )
	if not exprList then
		return nil
	end 
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

-- Make an arrayInit structure from the nodes of an arrayInit list pattern
local function makeArrayInit( nodes )
	return { s = "arrayInit", exprs = makeExprs( nodes[2] ), 
			firstToken = nodes[1], lastToken = nodes[3] }
end 

-- Check for a variable declaration or initialization for line pattern p and 
-- the parse nodes, and add variable(s) to the structure array structs.
-- The variable(s) are global if isGlobal is included and true.
-- Return true if the pattern was a variable pattern, else false.
local function getVar( p, nodes, structs, isGlobal )
	if p == "varInit" then
		-- e.g. int x = 10;
		structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[2], 
									nodes[3], makeExpr( nodes[5] ) )
	elseif p == "varDecl" then
		-- e.g. int x, y;
		for _, nameID in ipairs( nodes[3].nodes ) do
			structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[2], nameID )
		end
	elseif p == "constInit" then
		-- e.g. final int LIMIT = 100;
		structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[3], 
									nodes[4], makeExpr( nodes[6] ), nil, true )			
	elseif p == "arrayInit" then
		-- e.g. int[] a = { 1, 2, 3 };   or   int[] a = new int[10];
		local initExpr
		local arrayInit = nodes[7]
		if arrayInit.p == "list" then
			initExpr = makeArrayInit( arrayInit.nodes )
		else
			initExpr = makeExpr( arrayInit.nodes[1] )
		end
		structs[#structs + 1] = makeVar( isGlobal, nodes[1], nodes[2], 
									nodes[5], initExpr, true )						
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
-- The index and field can be nil 
local function makeLValueFromNodes( varID, index, field )
	local indexExpr = nil
	local lastToken = nil
	if index then
		indexExpr = makeExpr( index.nodes[2] )
		lastToken = index.nodes[3]
	end
	local fieldID = nil
	if field then
		fieldID = field.nodes[2]
		lastToken = nil   -- don't need this anymore
	end
	return { s = "lValue", varID = varID, 
			indexExpr = indexExpr, fieldID = fieldID, lastToken = lastToken }
end

-- Make and return an lValue structure from an ID token or lValue parse node 
local function makeLValue( node )
	if node.tt == "ID" then
		return { s = "lValue", varID = node }   -- a simple variable
	end
	assert( node.t == "lValue" )
	local nodes = node.nodes
	return makeLValueFromNodes( nodes[1], nodes[2], nodes[3] )
end

-- Make and return a call structure from a call parse tree's nodes array.
-- Return nil if there was an error.
local function makeCall( nodes )
	-- Determine the class, lValue, and nameID
	local class, lValue, nameID
	local callHead = nodes[1]
	local ns = callHead.nodes
	local p = callHead.p
	if p == "ct" or p == "Math" then
		class = ns[1]
		nameID = ns[3]
	elseif p == "System" then
		class = ns[1]     -- "System"
		lValue = ns[3]    -- e.g. "out"
		nameID = ns[5]    -- e.g. "println"
	elseif p == "user" then
		nameID = ns[1]
	else
		assert( p == "method" )
		local field = ns[5]
		if field then
			lValue = makeLValueFromNodes( ns[1], ns[2], ns[4] )
			nameID = field.nodes[2]
		else
			lValue = makeLValueFromNodes( ns[1], ns[2] )
			nameID = ns[4]
		end
	end

	-- Make the call structure
	return { s = "call", class = class, lValue = lValue, nameID = nameID, 
			exprs = makeExprs( nodes[2] ), lastToken = nodes[3] }
end

-- Make and return a cast structure given the parse tree nodes. 
-- The only supported type cast is currently (int). 
-- In other cases, set the error state.
local function makeCast( nodes )
	local typeNode = nodes[2]
	if typeNode.str ~= "int" then
		err.setErrNode( typeNode, "The only type cast supported by Code12 is (int)" )
	end
	return { s = "cast", vtCast = 0, expr = makeExpr( nodes[4] ), firstToken = nodes[1] }
end

-- Get the single controlled stmt or block of controlled stmts for an 
-- if, else, or loop, and return a block structure. 
-- If the next item to process is a begin block then get an entire block 
-- of stmts until the matching block end, otherwise get a single stmt. 
-- Return nil if there was an error.
local function getControlledBlock()
	local ctrlTree = parseTrees[iTree - 1] -- tree for the controlling statement
	local ctrlIndent = ctrlTree.indentLevel
	local tree = parseTrees[iTree]
	local p = tree.p
	if p == "begin" then
		return getBlock()
	elseif p == "end" then
		err.setErrNode( tree, "} without matching {" )
		return nil
	elseif p == "varInit" or p == "varDecl" or p == "arrayInit" or p == "arrayDecl" then
		-- Var decls are not allowed as a single controlled statement
		err.setErrNode( tree, "Variable declarations are not allowed here" )
		return nil
	else
		-- Single controlled stmt
		local stmtIndent = tree.indentLevel
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
				local nextIndent = nextTree.indentLevel
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
			return { s = "block", stmts = stmts }
		end
	end
	return nil
end

-- Check to see if the next stmt is an else or else if, and if so then 
-- get the controlled stmts and return a block structure. 
-- Return nil if there is no else or an error.
local function getElseBlock( ifTree )
	local tree = parseTrees[iTree]
	local p = tree.p
	if p == "else" then
		if tree.indentLevel ~= ifTree.indentLevel then
			err.setErrLineNumAndRefLineNum( tree.iLine, ifTree.iLineStart, 
					'An "else" should have the same indentation as its "if"' )
		end
		iTree = iTree + 1
		return getControlledBlock()
	elseif p == "elseif" then
		if tree.indentLevel ~= ifTree.indentLevel then
			err.setErrLineNumAndRefLineNum( tree.iLineStart, ifTree.iLineStart, 
					'An "else if" should have the same indentation as the first "if"' )
		end
		checkMultiLineIndent( tree )
		-- Controlled stmts is a single stmt, which is the following if
		iTree = iTree + 1
		local stmt = { s = "if", expr = makeExpr( tree.nodes[4] ), 
						block = getControlledBlock(), 
						elseBlock = getElseBlock( ifTree ),
						entireLine = true }
		return { s = "block", stmts = { stmt } }
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
		-- for (typeNode nameID : arrayID) controlledStmts
		return { 
			s = "forArray", 
			var = makeVar( false, nil, nodes[1], nodes[2] ),
			expr = makeExpr( nodes[4] ), 
			block = getControlledBlock(),
			entireLine = true, 
		}
	else
		-- for (init; expr; next) controlledStmts
		local stmt = { 
			s = "for", 
			block = getControlledBlock(), 
			entireLine = true 
		}

		-- Add the initStmt if any
		local forInit = nodes[1]
		if forInit then
			if forInit.p == "var" then
				local ns = forInit.nodes
				stmt.initStmt = makeVar( false, nil, ns[1], ns[2], makeExpr( ns[4] ) )
			else
				assert( forInit.p == "stmt" )
				stmt.initStmt = getStmt( forInit.nodes[1] )
				stmt.initStmt.iLine = iLine
			end
		end

		-- Add the expr if any
		local forExpr = nodes[3]
		if forExpr then
			stmt.expr = makeExpr( forExpr.nodes[1] )
		end

		-- Add the nextStmt if any
		local forNext = nodes[5]
		if forNext then
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
		stmt = getStmt( nodes[1] )
	elseif p == "if" then
		-- if (expr) controlledStmts [else controlledStmts]
		stmt = { s = "if", expr = makeExpr( nodes[3] ), 
				block = getControlledBlock(), 
				elseBlock = getElseBlock( tree ), entireLine = true }
	elseif p == "elseif" or p == "else" then
		-- Handling of an if above should also consume the else if any,
		-- so an else here is without a matching if.
		err.setErrNode( tree, "else without matching if (misplaced { } brackets?)")
		return false
	elseif p == "returnVal" then
		-- return expr ;
		stmt = { s = "return", expr = makeExpr( nodes[2] ), firstToken = nodes[1] }
	elseif p == "return" then
		-- return ;
		stmt = { s = "return", firstToken = nodes[1] }
	elseif p == "do" then
		-- do controlledStmts while (expr);
		stmt = { s = "doWhile", block = getControlledBlock(), entireLine = true }
		if stmt.block == nil then
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
		if endTree.indentLevel ~= tree.indentLevel then
			err.setErrNodeAndRef( endTree, tree, "This while statement should have the same indentation as its \"do\"" )
		end
		stmt.expr = makeExpr( endTree.nodes[3] )
		stmt.iLineWhile = endTree.iLine
		checkMultiLineIndent( endTree )
	elseif p == "while" then
		-- while (expr) controlledStmts
		local whileEnd = nodes[4]
		if whileEnd.p ~= "while" then
			err.setErrNode( whileEnd, "while loop header should not end with a semicolon" )
			return nil
		end
		stmt = { s = "while", expr = makeExpr( nodes[3] ), block = getControlledBlock(),
				entireLine = true }
	elseif p == "for" then
		-- for loop variants
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
		stmt.iLine = tree.iLineStart or tree.iLine
		stmts[#stmts + 1] = stmt
		checkMultiLineIndent( tree )
		return true
	end
	return false
end

-- Get a block of statements beginning with { and ending with }
-- and return a block structure.
-- If there is an error then set the error state and return nil.
function getBlock()
	-- Block must start with a {
	local treeStart = parseTrees[iTree]
	local iLineStart = treeStart.iLine
	local beginIndent = treeStart.indentLevel
	if not checkBlockBegin() then
		return nil
	end

	-- Check block is indented from beginning {
	local prevTree, blockIndent
	if iTree <= numParseTrees then
		prevTree = parseTrees[iTree]
		blockIndent = prevTree.indentLevel
		if prevTree.p ~= "end" and blockIndent <= beginIndent then
			err.setErrLineNumAndRefLineNum( prevTree.iLineStart, iLineStart,
					"Lines within { } brackets should be indented" )
		end
	end

	-- Get all lines until we get a matching end for the block begin
	local stmts = {}
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		local currIndent = tree.indentLevel
		iTree = iTree + 1    -- pass this line

		if p == "begin" then
			-- Ad-hoc blocks are not supported
			err.setErrLineNum( tree.iLine, "Unexpected {" )
		elseif p == "end" then
			-- This ends our block
			if currIndent ~= beginIndent then
				err.setErrLineNumAndRefLineNum( tree.iLineStart, iLineStart, 
						"A block's ending } should have the same indentation as its beginning {" )
			end
			return { s = "block", iLineBegin = iLineStart, stmts = stmts, iLineEnd = tree.iLine }
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
	err.setErrLineNumAndRefLineNum( source.numLines + 1, iLineStart,
		"Missing } to end block starting at line %d", iLineStart )
	return nil
end

-- Make and return an expr structure from an expr parse node
function makeExpr( node )
	-- No expr or parse error makes nil (e.g. an optional expr field)
	if node == nil or node.isError then
		return nil
	end

	-- Is node a token? (variable ID, or literal INT, NUM, BOOL, STR, or NULL)
	if node.tt == "ID" then
		return makeLValue( node )   -- a simple variable
	elseif node.tt then
		return node     -- expr node can be a literal token node directly
	end

	-- Handle the different primaryExpr types plus binary operators
	assert( node.t == "expr" )
	local p = node.p
	local nodes = node.nodes
	if p == "call" then
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
	elseif p == "Math" then
		return { s = "staticField", class = nodes[1], fieldID = nodes[3] }
	elseif p == "newArray" then
		return { s = "newArray", vtElement = javaTypes.vtFromVarType( nodes[2] ), 
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

-- Make and return a function member given the parsed nodes,
-- including the contained statements, and move iTree past it.
-- This function will get called even if the func has isError true
-- and will try to process the func as much as possible but
-- will set isError in the func if there is an error.
-- If there is an error then set the error state and return nil.
local function getFunc( nodes )
	-- Any part of the nodes may have errors, so be careful and check
	-- everything before using it, and set isError if an error is found.
	local isError = nil

	-- Determine the return type
	local vt
	local retType = nodes[2]
	if retType.t ~= "retType" or retType.isError then
		vt = nil 
		isError = true
	elseif retType.p == "void" then
		vt = false
	else
		vt = javaTypes.vtFromType( retType.nodes[1], retType.p == "array" )
	end

	-- Build the paramVars array
	local paramVars = {}
	local paramList = nodes[5]
	if paramList and paramList.nodes then
		for _, node in ipairs( paramList.nodes ) do
			if node.isError then
				isError = true
			else
				local ns = node.nodes
				if not ns or ns.isError then
					isError = true
				else
					if node.p == "array" then
						paramVars[#paramVars + 1] = makeVar( false, nil, ns[1], ns[4], nil, true )
					else
						paramVars[#paramVars + 1] = makeVar( false, nil, ns[1], ns[2] )
					end
				end
			end
		end
	end

	-- Get the block
	local block = getBlock()
	if block == nil then
		return nil   -- probably too malformed to even define it with isError
	end

	-- Make the func
	local nameID = nodes[3]
	if not nameID or nameID.tt ~= "ID" then
		return nil   -- can't define it without a name
	end
	local func = { s = "func", iLine = nameID.iLine, nameID = nameID,
					vt = vt, paramVars = paramVars, block = block, 
					isError = isError, entireLine = true }

	-- Add the access flags and return it
	local access = nodes[1]
	if access then
		local p = access.p
		if p == "publicStatic" then
			func.isPublic = true
			func.isStatic = true
		elseif p == "public" then
			func.isPublic = true
		end
	end
	return func
end

-- Skip a block starting with { until the matching } without checking it
local function skipBlock()
	-- Block must start with a {
	local iLineStart = parseTrees[iTree].iLine
	if not checkBlockBegin() then
		return false
	end

	-- Get all lines until we get a matching end for the block begin
	local blockLevel = 1
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		iTree = iTree + 1    -- pass this line

		if p == "begin" then
			blockLevel = blockLevel + 1
		elseif p == "end" then
			blockLevel = blockLevel - 1
			if blockLevel == 0 then
				return
			end
		end
	end

	-- Got to EOF before finding matching }
	err.setErrLineNum( source.numLines + 1, 
		"Missing } to end block starting at line %d", iLineStart )
	return nil
end

-- Check and build the members for the programTree, ending with and including 
-- the } at the end of the program class.
-- If there is an error then set the error state and return false.
-- Return true if succesful.
local function getMembers( programTree )
	local vars = programTree.vars
	local funcs = programTree.funcs
	local gotFunc = false     -- set to true when the first func was seen
	local firstMemberLineNum, firstMemberIndentLevel

	-- Look for instance variables and functions
	while iTree <= numParseTrees do
		local tree = parseTrees[iTree]
		local p = tree.p
		local nodes = tree.nodes
		iTree = iTree + 1

		if p == "func" then
			-- Handle a func definition as best as possible even if tree.isError,
			-- to try to maintain the structure and define known functions. 
			if nodes[3] and nodes[3].str == "main" then
				skipBlock()    -- skip body of main without checking it
			else
				funcs[#funcs + 1] = getFunc( nodes )
			end
			gotFunc = true
		elseif tree.isError then
			-- Skip misc. lines with syntax errors
		elseif getVar( p, nodes, vars, true ) then
			-- Added instance variable(s)
			-- Code12 does not allow instance variables to follow member functions,
			-- because it greatly complicates keeping Java and Lua line numbers in sync.
			if gotFunc then
				err.setErrNode( tree, "Class-level variables must be defined at the beginning of the class" )
			end
		elseif p == "end" then
			-- The end of the class
			if tree.indentLevel ~= 0 then
				err.setErrLineNum( tree.iLine, "The ending } of the program class should not be indented" )
			end
			return true
		elseif p == "begin" then
			-- Ad-hoc blocks are unexpected, but try to process the block anyway
			err.setErrNode( tree, "Unexpected or extra {" )
			iTree = iTree - 1   -- back to the { line
			getBlock()
		elseif p == "class" then
			err.setErrNode( tree, "Code12 does not support additional class definitions" )
			getBlock()
		else
			-- Unexpected line in the class block
			err.overrideErrLineParseTree( tree, 
					"Statement must be inside a function body -- mismatched { } brackets?" )
		end

		-- Check indentation of members
		if firstMemberLineNum == nil then
			-- Save indentation level and line number of first member
			firstMemberLineNum = tree.iLineStart
			firstMemberIndentLevel = tree.indentLevel
			if firstMemberIndentLevel == 0 then
				err.setErrLineNum( firstMemberLineNum,
						"Class-level variable and function definitions should be indented" )
			end
		elseif tree.indentLevel ~= firstMemberIndentLevel then
			err.setErrLineNumAndRefLineNum( tree.iLineStart, firstMemberLineNum,
					"Class-level variable and function definitions should all have the same indentation" )
		end
		checkMultiLineIndent( tree )
	end

	-- Reached EOF before finding the end of the class
	err.setErrLineNum( source.numLines + 1, "Missing } to end the program class" )
	return false
end

-- Print a structure tree node recursively for debugging, labelled with name if included
local function printStructureTree( node, indentLevel, file, label )
	-- Make a label for this node
	assert( type(node) == "table" and (node.s or node.tt) )
	local str
	if node.iLine then
		str = string.format( "%3d.%s", node.iLine, string.rep( "    ", indentLevel ) )
	else
		str = string.rep( "    ", indentLevel + 1 )  -- empty line number takes one indent
	end
	if label then
		str = str .. label .. ": "
	end
	if node.tt then
		-- Leaf token
		str = str .. "(" .. node.str .. ")"
		app.printDebugStr( str, file )
		return
	elseif node.s == "binOp" then
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

-- Parse source.strLines at the given syntaxLevel and store the results
-- in source.lines, source.numLines, and source.syntaxLevel.
function parseProgram.parseLines( syntaxLevel )
	-- Set the syntax level and purge the parse cache if it changed
	if syntaxLevel ~= source.syntaxLevel then
		source.purgeParseCache()
	end
	source.syntaxLevel = syntaxLevel

	-- Process source.strLines
	local iLineCommentStart = nil   -- set when inside a block comment
	local iLineStart = nil          -- starting iLine for multi-line parse
	local startTokens = nil         -- tokens from unfinished multi-line parse
	local lineRecCodePrev = nil     -- the last line so far with code on it
	local strLines = source.strLines
	local lines = source.lines
	local numCachedLines = 0
	for lineNum = 1, #strLines do
		-- If we've seen this line before, we may be able to reuse its
		-- cached parse results, but only if we are not in the middle of a 
		-- block comment or incomplete line.
		local strLine = strLines[lineNum]
		local lineRecCached = (iLineCommentStart == nil and startTokens == nil) 
								and source.lineCacheForStrLine[strLine]
		local lineRec
		if lineRecCached then
			-- Make a copy of the cached results found for this line
			lineRec = {
				iLine = lineNum,
				str = strLine,
				commentStr = lineRecCached.commentStr,
				hasCode = lineRecCached.hasCode,
				indentLevel = lineRecCached.indentLevel,
				indentStr = lineRecCached.indentStr,
				parseTree = parseJava.copyLineParseTree( lineRecCached.parseTree, lineNum )
			}
			lines[lineNum] = lineRec
			source.lineCacheForStrLine[strLine] = lineRec  -- update cache to newer one
			numCachedLines = numCachedLines + 1
		else
			-- We need to parse this line
			lineRec = { iLine= lineNum, str = strLine }  
			lines[lineNum] = lineRec
			local tree, tokens = parseJava.parseLine( lineRec, iLineCommentStart,
									startTokens, iLineStart, syntaxLevel )
			if tree == false then
				-- Line is incomplete, carry tokens forward to next line
				startTokens = tokens
				if iLineStart == nil then
					iLineStart = lineNum  -- remember where this multi-line parse started
				end
			else
				-- Completed parse
				startTokens = nil
				iLineStart = nil

				-- We can cache this parse for possible reuse if it was successful
				-- and not involved in a multi-line parse or block comment
				if tree and not tree.isError and lineRec.errRec == nil
						and lineRec.iLineStart == lineRec.iLine and iLineCommentStart == nil
						and not lineRec.openComment then
					source.lineCacheForStrLine[strLine] = lineRec  -- cache it
				end

				-- Keep track of open block comments
				if lineRec.openComment then
					iLineCommentStart = lineRec.iLineCommentStart
				else
					iLineCommentStart = nil
				end
			end
		end

		-- Check for inconsistent tab/space indent on all non-blank lines
		if lineRec.hasCode then
			if lineRecCodePrev then
				checkIndentTabsAndSpaces( lineRec, lineRecCodePrev )
			end
			lineRecCodePrev = lineRec
		end
	end -- end of loop
	source.numLines = #strLines

	-- Add sentinel line at end of source.lines
	local lineNum = #strLines + 1
	lines[lineNum] = { iLine = lineNum, str = "" }

	-- Check for unclosed block comment
	if iLineCommentStart then
		err.setErrLineNum( iLineCommentStart, "Comment started with /* was not closed with */" )
	end

	-- Print cache stats
	print( string.format( "%d lines copied from cache (%d%%)", 
				numCachedLines, numCachedLines * 100 / source.numLines ) )
	local numParsed = source.numLines - numCachedLines
	print( string.format( "%d lines parsed (%d%%)", 
				numParsed, numParsed * 100 / source.numLines ) )
end

-- Make the parseTrees array from the parsed source.lines and set numParseTrees
local function getParseTrees()
	-- Get all non-blank parse trees from source.lines
	parseTrees = {}
	for i = 1, source.numLines do
		local tree = source.lines[i].parseTree
		if tree and tree.p ~= "blank" then
			parseTrees[#parseTrees + 1] = tree
		end
	end
	numParseTrees = #parseTrees

	-- Add sentinel parse tree at the end of parseTrees
	local lineNum = source.numLines + 1   -- will report at source line sentinel
	parseTrees[numParseTrees + 1] = 
			{ t = "line", p = "EOF", nodes = {}, 
				iLine = lineNum, iLineStart = lineNum, indentLevel = 0 }
end

-- Parse the source at the given syntaxLevel and return the program structure.
-- If there is an error then set the error state, and return nil if the error 
-- is unrecoverable.
function parseProgram.getProgramTree( syntaxLevel )
	-- Get the parse trees and init the strucure parse state
	parseProgram.parseLines( syntaxLevel )
	getParseTrees()
	iTree = 1

	-- Make the root of the program tree and check the program header
	local programTree = getProgramHeader()
	if programTree == nil then
		return nil    -- probably not useful to keep parsing
	end

	-- Get the member vars and funcs and return the completed program structure
	if getMembers( programTree ) then
		-- We should be at the EOF now
		local tree = parseTrees[iTree]
		if tree and tree.p ~= "EOF" then
			if tree.p == "class" then
				err.overrideErrLineParseTree( tree,
						"Code12 does not allow defining additional classes" )
			else
				err.overrideErrLineParseTree( tree,
						"Unexpected line after end of class -- mismatched { } brackets?" )
			end
		end
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
