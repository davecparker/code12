-----------------------------------------------------------------------------------------
--
-- codeGenJava.lua
--
-- Generates Lua code from Java Parse trees for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- Code12 modules
local err = require( "err" )
local javalex = require( "javalex" )
local javaTypes = require( "javaTypes" )
local checkJava = require( "checkJava" )


-- The codeGen module
local codeGenJava = {}


-- Constants
local ctPrefix = "ct."        -- prefix for API functions
local thisPrefix = "this."    -- prefix for user instance variables
local fnPrefix = "_fn."       -- prefix for user function names
 

-- The Java parse trees and processing state
local javaParseTrees	      -- array of parse trees (for each line of Java)
local iTree            	      -- index of next parse tree to process
local blockLevel = 0          -- indent level (begin/end block level) for Lua code
local ctDefined = false       -- true when ct is defined (within functions)

-- Code generation options
local enableComments = true   -- generate Lua comments for end-of-line Java comments
local enableIndent = true     -- indent the Lua code per the code structure

-- Indentation for the Lua code
local strIndents = {}
if enableIndent then
	for i = 0, 20 do
		strIndents[i] = string.rep( "    ", i )
	end
end

-- The generated Lua code
local luaCodeStrs             -- array of strings for bulk concat (many less than one line)
local luaLineNum              -- Current line number in the Lua code
local luaLineIsBlank          -- true if the current Lua line is blank so far

-- Map supported Java binary operators to Lua operator code (Lua op plus spaces)
local luaOpFromJavaOp = {
	-- Binary ops used in expr nodes
	["*"]	= " * ",
	["/"]	= " / ",
	["%"]	= " % ",
	["+"]	= " + ",
	["-"]	= " - ",
	["<"]	= " < ",
	["<="]	= " <= ",
	[">"]	= " > ",
	[">="]	= " >= ",
	["=="]	= " == ",
	["!="]	= " ~= ",
	["&&"]	= " and ",
	["||"]	= " or ",
	-- Assignment ops used in opAssignOp nodes
	["+="]	= " + ",
	["-="]	= " - ",
	["*="]	= " * ",
	["/="]	= " / ",
}

-- Map Java String methods to corresponding Lua function
local luaFnFromJavaStringMethod = {
    ["compareTo"]    =  "ct.stringCompare",
    ["indexOf"]      =  "ct.indexOfString",
    ["length"]       =  "string.len",
    ["substring"]    =  "ct.substring",
    ["toLowerCase"]  =  "string.lower",
    ["toUpperCase"]  =  "string.upper",
    ["trim"]         =  "ct.trimString",
}

-- Substitutes for Lua reserved words that are not reserved in Java
local nameFromLuaReservedWord = {
	["and"]       = "_and",
	["elseif"]    = "_elseif",
	["end"]       = "_end",
	["function"]  = "_function",
	["in"]        = "_in",
	["local"]     = "_local",
	["nil"]       = "_nil",
	["not"]       = "_not",
	["or"]        = "_or",
	["repeat"]    = "_repeat",
	["then"]      = "_then",
	["until"]     = "_until",
}


--- Utility Functions --------------------------------------------------------

-- Add strCode as the start of a new Lua line, or blank line if strCode is nil
local function beginLuaLine( strCode )
	-- Add comment to end of previous line if any
	if enableComments then
		local strComment = javalex.commentForLine( luaLineNum )
		if strComment then
			if luaLineIsBlank then
				luaCodeStrs[#luaCodeStrs + 1] = "--"
			else
				luaCodeStrs[#luaCodeStrs + 1] = "   --"
			end
			luaCodeStrs[#luaCodeStrs + 1] = strComment
		end
	end

	-- End the previous line
	luaCodeStrs[#luaCodeStrs + 1] = "\n"
	luaLineNum = luaLineNum + 1

	-- Indent for the new line and start with the given code
	if enableIndent then
		luaCodeStrs[#luaCodeStrs + 1] = strIndents[blockLevel] or ""
	end
	if strCode then
		luaCodeStrs[#luaCodeStrs + 1] = strCode
		luaLineIsBlank = false
	else
		luaLineIsBlank = true
	end
end

-- Add strCode as Lua code
local function addLua( strCode )
	luaCodeStrs[#luaCodeStrs + 1] = strCode
	luaLineIsBlank = false
end

-- Remove the last "end" in the Lua code
local function removeLastLuaEnd()
	repeat
		local code = luaCodeStrs[#luaCodeStrs]
		luaCodeStrs[#luaCodeStrs] = nil
	until code == "end" or #luaCodeStrs == 0
end


--- Code Generation Functions ------------------------------------------------

-- Mutually recursive code gen functions
local lValueCode
local fnCallCode
local exprCode
local generateControlledStmt


-- Return Lua code for a variable name
local function varNameCode( varName )
	local luaName = nameFromLuaReservedWord[varName] or varName
	if checkJava.isInstanceVarName( varName ) then
		return thisPrefix .. luaName    -- instance var, so use this.name
	end
	return luaName
end

-- Return Lua code for a variable idNode with an optional array index indexNode. 
-- If assigned then the lValue is being assigned to, otherwise it is being read.  
local function varIndexCode( idNode, indexNode, assigned )
	local varCode = varNameCode( idNode.str )
	if indexNode.p == "empty" then
		return varCode   -- Simple variable
	end

	-- Array and index: Generate code to check array index at runtime
	local indexStr = exprCode( indexNode.nodes[2] )
	if assigned then
		return table.concat{
			"ct.checkArrayIndex(", varCode, ", ", indexStr, "); ",
			varCode, "[1+(", indexStr, ")]"
		}
	end
	return "ct.indexArray(" .. varCode .. ", " .. indexStr .. ")"
end

-- Return Lua code for an lValue. 
-- If assigned then the lValue is being assigned to, otherwise it is being read. 
function lValueCode( lValue, assigned )
	local nodes = lValue.nodes
	local code = varIndexCode( nodes[1], nodes[2], assigned )
	if nodes[3].p == "field" then
		local varName = nodes[1].str
		local fieldName = nodes[3].nodes[2].str
		if varName == "Math" then
			if fieldName == "PI" then
				return "math.pi"
			elseif fieldName == "E" then
				return "math.exp(1)"
			end
		end
		code = code .. "." .. fieldName
	end
	return code
end

-- Return Lua code for a function name
local function fnNameCode( fnName )
	return fnPrefix .. (nameFromLuaReservedWord[fnName] or fnName)
end

-- Return Lua code for a function or method call, e.g:
--     ct.circle( x, y, d )
--     bird.setFillColor( "red" )
--     stars[i].delete()
--	   foo()
function fnCallCode( tree )
	local nodes = tree.nodes
	local parts   -- There could be several parts, so prepare for a table.concat

	-- Function name/value
	local fnValue = nodes[1]
	local idNode = fnValue.nodes[1]
	local indexNode = fnValue.nodes[2]
	local methodNode = fnValue.nodes[3]
	local exprs = nodes[3].nodes

	if methodNode.p == "empty"  then
		-- User-defined function call
		parts = { fnNameCode( idNode.str ), "(" }   -- e.g. _fn.updateScore(
	else
		-- Method call
		local objName = idNode.str
		local methodName = methodNode.nodes[2].str

		if objName == "ct" then
			-- ct API call
			if not ctDefined then
				err.setErrNode( fnValue, "Code12 API functions cannot be called before start()" )
				return nil
			end
			-- Check special case: ct.println() with no params needs to generate ct.println("")
			if methodName == "println" and #exprs == 0 then
				return "ct.println( \"\" )"
			end
			parts = { ctPrefix, methodName, "(" }         -- e.g. ct.circle(
		elseif objName == "Math" then 
			-- Lua math.xxx is the same as Java Math.xxx for all supported methods :)
			parts = { "math.", methodName, "(" }
		else
			-- Check the object type
			local vt = checkJava.vtVar( idNode )
			if type(vt) == "table" and indexNode.p == "index" then
				vt = vt.vt
			end
			if vt == "String" then
				-- Supported String class methods
				if methodName == "equals" then
					-- Lua does string value comparison directly with ==
					return "(" .. varIndexCode( idNode, indexNode ) .. " == " .. exprCode( exprs[1] ) .. ")"
				else
					-- Map to corresponding global Lua function, passing the object.  
					parts = { luaFnFromJavaStringMethod[methodName], "(", varIndexCode( idNode, indexNode ) }
					if #exprs > 0 then
						parts[4] = ", "
					end
				end
			else
				-- GameObj method, e.g. obj:delete(
				parts = { varIndexCode( idNode, indexNode ), ":", methodName, "(" }
			end
		end
	end

	-- Parameter list
	for i = 1, #exprs do
		parts[#parts + 1] = exprCode( exprs[i] )
		if i < #exprs then
			parts[#parts + 1] = ", "
		end
	end
	parts[#parts + 1] = ")"
	return table.concat( parts )
end

-- Return Lua code for expr promoted to a string
local function stringExprCode( expr )
	local vt = expr.info.vt
	if vt == "String" then
		return exprCode( expr )
	elseif vt == "GameObj" then
		return exprCode( expr ) .. ":toString()"
	elseif vt == "null" then
		return "\"null\""
	end  
	-- Lua can promote int, double, and boolean with tostring()
	return "tostring(" .. exprCode( expr ) .. ")"
end

-- Return Lua code for an expr
function exprCode( expr )
	local p = expr.p
	local nodes = expr.nodes
	if p == "NUM" or p == "STR" or p == "BOOL" then
		return nodes[1].str
	elseif p == "NULL" then
		return "nil"
	elseif p == "lValue" then
		return lValueCode( nodes[1] )
	elseif p == "call" then
		return fnCallCode( expr )
	elseif p == "neg" then
		return "-" .. exprCode( nodes[2] )
	elseif p == "!" then
		return "not " .. exprCode( nodes[2] )
	elseif p == "exprParens" then
		return "(" .. exprCode( nodes[2] ) .. ")"
	elseif p == "newArray" then
		local vt = javaTypes.vtFromVarType( nodes[2] )
		return "{ length = " .. exprCode( nodes[4] ) .. ", default = "
				  .. tostring( javaTypes.defaultValueForVt( vt ) ) .. " }"
	end

	-- Is this a Binary operator?
	local luaOp = luaOpFromJavaOp[p]
	if luaOp then
		local left = nodes[1]
		local right = nodes[3]

		-- Look for special cases of binary operators
		if p == "+" and expr.info.vt == "String" then
			-- The + operator is concatenating strings, not adding
			return stringExprCode( left ) .. ".." .. stringExprCode( right )
		end
		-- TODO: Verify that we don't need parentheses (Lua precedence is same as Java)
		return exprCode( left ) .. luaOp .. exprCode( right )
	else
		error( "Unknown expr type " .. p )
	end
end

-- Look for and generate code for a variable declaration or initialization 
-- line (varInit, constInit, varDecl, arrayInit, or arrayDecl)
-- in tree. Return true if one was found and generated, else return false.
-- If isInstanceVar then the line is outside all functions (else local).
local function generateVarDecl( tree, isInstanceVar )
	local p = tree.p
	local nodes = tree.nodes
	if p == "varInit" or p == "constInit" then
		-- e.g. int x = y + 10;
		local vt, nameNode, expr
		if p == "varInit" then
			vt = javaTypes.vtFromVarType( nodes[1] )
			nameNode = nodes[2]
			expr = nodes[4]
		else
			vt = javaTypes.vtFromVarType( nodes[2] )
			nameNode = nodes[3]
			expr = nodes[5]
		end
		local varName = nameNode.str
		if isInstanceVar then
			checkJava.defineInstanceVar( nameNode, vt, false, true )
			beginLuaLine( varNameCode( varName ) )
		else
			checkJava.defineLocalVar( nameNode, vt, false, true )
			beginLuaLine( "local " )
			addLua( varNameCode( varName ) )
		end
		checkJava.canAssignToVarNode( nameNode, expr, true )
		addLua( " = " )
		addLua( exprCode( expr ) )
		return true
	elseif p == "varDecl" then
		-- varType idList ;
		local vt = javaTypes.vtFromVarType( tree.nodes[1] )
		local idList = tree.nodes[2].nodes
		beginLuaLine()   -- we may have multiple statements on this line
		for i = 1, #idList do
			local nameNode = idList[i]
			local varName = nameNode.str
			if isInstanceVar then
				checkJava.defineInstanceVar( nameNode, vt, false )
			else
				checkJava.defineLocalVar( nameNode, vt, false )
				addLua( "local " )
			end
			addLua( varNameCode( varName ) )
			addLua( " = " )
			-- Need to init primitives so they don't start as nil.
			-- We will go ahead and init all types for completeness.
			local valueCode = "nil; "
			if type(vt) == "number" then
				valueCode = "0; "
			elseif vt == true then
				valueCode = "false; "
			end
			addLua( valueCode )
		end
		return true
	elseif p == "arrayInit" then
		-- type [ ] id = arrayInit ;
		local vt = javaTypes.vtFromVarType( nodes[1] )
		local nameNode = nodes[4]
		local varName = nameNode.str
		if isInstanceVar then
			checkJava.defineInstanceVar( nameNode, vt, true, true )
			beginLuaLine( varNameCode( varName ) )
		else
			checkJava.defineLocalVar( nameNode, vt, true, true )
			beginLuaLine( "local " )
			addLua( varNameCode( varName ) )
		end
		addLua( " = " )
		local arrayInit = nodes[6]
		if arrayInit.p == "list" then
			-- type [ ] id = { exprList } ;
			addLua( "{ " )
			local exprs = arrayInit.nodes[2].nodes
			for i = 1, #exprs do
				local expr = exprs[i]
				if not javaTypes.vtCanAcceptVtExpr( vt, expr.info.vt ) then
					err.setErrNodeAndRef( expr, nodes[1], 
							"Array element type does not match the array type" )
				end
				addLua( exprCode( expr ) )
				addLua( ", " )
			end
			addLua( "length = " )
			addLua( #exprs )
			addLua( ", default = " )
			addLua( tostring( javaTypes.defaultValueForVt( vt ) ) )
			addLua( " }" )
		else
			-- type [ ] id = expr
			local expr = arrayInit.nodes[1]
			local vtExpr = expr.info.vt
			if type(vtExpr) ~= "table" or vtExpr.vt ~= vt then
				err.setErrNode( expr, "Cannot initialize array of %s with type %s",
						javaTypes.typeNameFromVt( vt ),
						javaTypes.typeNameFromVt( vtExpr ) )
			end
			addLua( exprCode( expr ) )
		end
		return true
	elseif p == "arrayDecl" then
		-- varType [ ] idList ;
		local vt = javaTypes.vtFromVarType( tree.nodes[1] )
		local idList = tree.nodes[4].nodes
		beginLuaLine()   -- we may have multiple statements on this line
		for i = 1, #idList do
			local nameNode = idList[i]
			local varName = nameNode.str
			if isInstanceVar then
				checkJava.defineInstanceVar( nameNode, vt, true )
			else
				checkJava.defineLocalVar( nameNode, vt, true )
				addLua( "local " )
			end
			addLua( varNameCode( varName ) )
			addLua( " = nil; " )
		end
		return true
	end
	return false
end

-- Generate code for an increment or decrement (++ or --) stmt
-- given the lValue node and opToken is either a "++" or "--" token.
-- The caller should have already called beginLuaLine for this stmt.
local function generateIncOrDecStmt( lValue, opToken )
	local vt = lValue.info.vt 
	local tt = opToken.tt
	assert( tt == "++" or tt == "--" )
	if type(vt) ~= "number" then
		err.setErrNodeAndRef( opToken, lValue, "Can only apply \"%s\" to numeric types", tt )
		return
	end
	addLua( lValueCode( lValue, true ) )
	addLua( " = " )
	addLua( lValueCode( lValue ) )
	if tt == "++" then
		addLua( " + 1" )
	else
		addLua( " - 1" )
	end
end

-- Generate code for the single stmt in tree.
-- The caller should have already called beginLuaLine for this stmt.
local function generateStmt( tree )
	local p = tree.p
	local nodes = tree.nodes
	if p == "call" then
		-- fnValue ( exprList )
		if checkJava.vtCheckCall( nodes[1], nodes[3] ) == nil then
			return
		end
		addLua( fnCallCode( tree ) )
	elseif p == "varAssign" then
		-- ID = expr
		local varNode = nodes[1]
		local expr = nodes[3]
		if checkJava.canAssignToVarNode( varNode, expr ) then
			addLua( varNameCode( varNode.str ) )
			addLua( " = " )
			addLua( exprCode( expr ) )
		end
	elseif p == "assign" then
		-- lValue = expr
		local lValue = nodes[1]
		local expr = nodes[3]
		if checkJava.canAssignToLValue( lValue, expr ) then
			addLua( lValueCode( lValue, true ) )
			addLua( " = " )
			addLua( exprCode( expr ) )
		end
	elseif p == "opAssign" then
		-- lValue op= expr
		local lValue = nodes[1]
		local op = nodes[2]
		local expr = nodes[3]
		if checkJava.canOpAssignToLValue( lValue, op, expr ) then
			addLua( lValueCode( lValue, true ) )
			addLua( " = " )
			addLua( lValueCode( lValue ) )
			addLua( luaOpFromJavaOp[op.p] )
			addLua( "(" )
			addLua( exprCode( expr ) )
			addLua( ")" )
		end
	elseif p == "preInc" or p == "preDec" then
		--  ++ lValue  or  -- lValue
		generateIncOrDecStmt( nodes[2], nodes[1] )
	elseif p == "postInc" or p == "postDec" then
		-- lValue ++  or  lValue -- 
		generateIncOrDecStmt( nodes[1], nodes[2] )
	elseif p == "break" then
		-- break
		addLua( "break" )
	else
		error("*** Unknown stmt pattern " .. p )
	end	
end

-- Do type checks and then generate code for a for loop starting at tree
local function generateForLoop( tree )
	assert( tree.p == "for" )
	local forControl = tree.nodes[3]
	local nodes = forControl.nodes
	if forControl.p == "array"  then
		-- for ( type ID : array )
		local vtVar = javaTypes.vtFromVarType( nodes[1] )
		local vtArray = checkJava.vtVar( nodes[4] )
		if type(vtArray) ~= "table" then
			err.setErrNode( nodes[4], 
					"The source variable in a for-each loop must be an array" );
		elseif vtArray.vt ~= vtVar then
			err.setErrNodeAndRef( nodes[1], nodes[4],
					"Array \"%s\" contains elements of type %s",
					nodes[4].str, javaTypes.typeNameFromVt( vtArray.vt ) );
		else
			checkJava.defineLocalVar( nodes[2], vtVar, false, true )
			beginLuaLine( "for _, " )
			addLua( nodes[2].str )
			addLua( " in ipairs(" )
			addLua( varNameCode( nodes[4].str ) )
			addLua( ") do" )
			generateControlledStmt()
		end
	else
		-- for ( init ; expr ; stmt )
		local forInit = nodes[1]
		local forExpr = nodes[3]
		local forNext = nodes[5]
		beginLuaLine()    -- We will put the loop header on one line
		checkJava.beginLocalBlock()

		-- Do the forInit if any
		checkJava.doTypeChecks( forInit )   -- not done by generateBlockLine 
		if forInit.p == "varInit" then
			local vt = javaTypes.vtFromVarType( forInit.nodes[1] )
			local nameNode = forInit.nodes[2]
			checkJava.defineLocalVar( nameNode, vt, false, true )
			local expr = forInit.nodes[4]
			checkJava.canAssignToVarNode( nameNode, expr, true )
			addLua( "local " )
			addLua( nameNode.str )
			addLua( " = " )
			addLua( exprCode( expr ) )
			addLua( "; " )
		elseif forInit.p == "stmt" then
			generateStmt( forInit.nodes[1] )
			addLua( "; " )
		end

		-- Do the loop with expr as a while loop
		checkJava.doTypeChecks( forExpr )
		addLua( "while " )
		if forExpr.p == "expr" then
			local expr = forExpr.nodes[1]
			if expr.info.vt ~= true then
				err.setErrNode( expr, "Loop test must evaluate to a boolean (true or false)" )
			end
			addLua( exprCode( expr ) )
		else
			addLua( "true" )
		end
		addLua( " do" )
		generateControlledStmt()

		-- Put the forNext stmt before the loop end if any
		checkJava.doTypeChecks( forNext )
		if forNext.p == "stmt" then
			removeLastLuaEnd()
			generateStmt( forNext.nodes[1] )
			addLua( "; end" )
		end

		checkJava.endLocalBlock()
	end
end

-- Generate code for the block line in tree
local function generateBlockLine( tree )
	-- Do type checks on the line first, but not in for loop headers yet
	if tree.isError then
		return
	end
	if tree.p ~= "for" and not checkJava.doTypeChecks( tree ) then
		return
	end
	local p = tree.p
	local nodes = tree.nodes
	if p == "stmt" then
		-- stmt ;
		beginLuaLine()
		generateStmt( nodes[1] )
	elseif generateVarDecl( tree, false ) then
		-- Processed a local varInit, constInit, or varDecl
		return
	elseif p == "if" then
		-- if (expr)
		local expr = nodes[3]
		if expr.info.vt ~= true then
			err.setErrNode( expr, "Conditional test must be boolean (true or false)" )
			return
		end
		beginLuaLine( "if " )
		addLua( exprCode( expr ) )
		addLua( " then")
		generateControlledStmt()
	elseif p == "elseif" then
		-- else if (expr)
		local expr = nodes[4]
		if expr.info.vt ~= true then
			err.setErrNode( expr, "Conditional test must be boolean (true or false)" )
			return
		end
		removeLastLuaEnd()   -- remove the end we made for the if
		beginLuaLine( "elseif " )
		addLua( exprCode( expr ) )
		addLua( " then")
		generateControlledStmt()
	elseif p == "else" then
		-- else
		removeLastLuaEnd()   -- remove the end we made for the if/elseif
		beginLuaLine( "else " )
		generateControlledStmt()
	elseif p == "do" then
		-- do
		beginLuaLine( "repeat" )
		generateControlledStmt()
	elseif p == "while" then
		-- while (expr) starting a while, or while (expr) ; ending a do-while
		local expr = nodes[3]
		if expr.info.vt ~= true then
			err.setErrNode( expr, "Loop test must be boolean (true or false)" )
			return
		end
		local whileEnd = nodes[4]
		if whileEnd.p == "do-while" then
			removeLastLuaEnd()   -- remove the end we made for the loop body
			beginLuaLine( "until not (" )
			addLua( exprCode( expr ) )
			addLua( ")" )
		else
			beginLuaLine( "while " )
			addLua( exprCode( expr ) )
			addLua( " do")
			generateControlledStmt()
		end
	elseif p == "for" then
		-- for
		generateForLoop( tree )
	elseif p == "return" then
		-- return expr ;
		local expr = nodes[2]
		-- TDOO: Check correct return type (expr.info.vt must match function signature)
		beginLuaLine( "return " )
		addLua( exprCode( expr ) )
	else
		error( "*** Unknown line pattern " .. p )
	end
end

-- Generate Lua code for a { } block of code.
-- Start with iTree at the { and return with iTree at the }.
-- Return true if successful.
local function generateBlock()
	local startBlockLevel = blockLevel
	repeat
		-- Add blank Lua lines to catch up to the Java line number if necessary
		local tree = javaParseTrees[iTree]
		assert( tree.iLine ~= nil )
		while luaLineNum < tree.iLine - 1 do
			beginLuaLine()
		end

		local p = tree.p
		if p == "begin" then              -- {
			checkJava.beginLocalBlock()
			blockLevel = blockLevel + 1
		elseif p == "end" then            -- }
			checkJava.endLocalBlock()
			blockLevel = blockLevel - 1
			beginLuaLine( "end" )
			if blockLevel == startBlockLevel then
				return true
			end
		else
			generateBlockLine( tree )
		end
		iTree = iTree + 1	
	until false
end

-- Generate code for the controlled statment of an if or loop,
-- which is a single block line, or a block nested with { }
-- if the next line is a {.  Start with iTree at the if/loop, and
-- end with iTree still at the single controlled stmt or at the ending }.
function generateControlledStmt()
	iTree = iTree + 1   -- pass the if/loop 
	local tree = javaParseTrees[iTree]  -- first line after the if/loop
	if tree.p == "begin" then
		generateBlock()
	else
		-- Single controlled statement
		blockLevel = blockLevel + 1
		generateBlockLine( tree )
		addLua( "; ")
		addLua( "end" )  -- these need to be separate because of removeLastLuaEnd
		blockLevel = blockLevel - 1
	end
end

-- Generate code for the parameter list of a function definition header
local function generateFnParamList( paramList )
	addLua( "(" )
	for i = 1, #paramList do
		local param = paramList[i]
		if param.p == "array" then
			addLua( param.nodes[4].str )
		else
			addLua( param.nodes[2].str )
		end
		if i < #paramList then
			addLua( ", ")
		end
	end
	addLua( ")" )
end

-- Generate code for a function definition with the given name and param list.
-- Start with the name of the function, then generate its code block afterwards.
-- Return true if successful.
local function generateFunction( fnName, paramList )
	beginLuaLine( "function " )
	addLua( fnNameCode( fnName ) )
	generateFnParamList( paramList )
	iTree = iTree + 1 

	checkJava.beginLocalBlock( paramList )
	ctDefined = true   -- user can only call ct methods inside functions
	local result = generateBlock()
	ctDefined = false
	checkJava.endLocalBlock()
	return result
end


--- Module Functions ---------------------------------------------------------


-- Generate and return the Lua code string corresponding to parseTrees,
-- which is an array of parse trees for each line of Java code.
-- Return nil if there is an abortable error
function codeGenJava.getLuaCode( parseTrees )
	-- Set up the working state
	javaParseTrees = parseTrees
	iTree = 1
	blockLevel = 0
	luaCodeStrs = {}
	luaLineNum = 1   

	-- Process each parse tree
	while iTree <= #parseTrees do
		local tree = javaParseTrees[iTree]

		-- Add blank Lua lines to catch up to the Java line number if necessary
		assert( tree.iLine ~= nil )
		while luaLineNum < tree.iLine - 1 do
			beginLuaLine()
		end

		-- print( "getLuaCode line " .. iTree )
		if checkJava.doTypeChecks( tree ) then
			local p = tree.p
			local nodes = tree.nodes

			if not generateVarDecl( tree, true ) then
				if p == "begin" then          -- {  in boilerplate code
					blockLevel = blockLevel + 1
				elseif p == "end" then            -- }  in boilerplate code
					blockLevel = blockLevel - 1
				elseif p == "func" then
					-- User-defined function
					generateFunction( nodes[3].str, nodes[5].nodes )
				end
			end
		end
		if err.shouldStop() then
			return nil
		end
		iTree = iTree + 1
	end

	-- Bulk concat and return all the Lua code
	return table.concat( luaCodeStrs )
end


------------------------------------------------------------------------------

return codeGenJava
