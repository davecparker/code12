-----------------------------------------------------------------------------------------
--
-- codeGenJava.lua
--
-- Generates Lua code from Java Parse trees for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- Code12 modules
local checkJava = require( "checkJava" )
local javaTypes = require( "javaTypes" )
local err = require( "err" )


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
local enableComments = true   -- generate Lua comments for full-line Java comments
local enableIndent = true     -- indent the Lua code per the code structure

-- Indentation for the Lua code
local strIndents = {}
if enableIndent then
	for i = 0, 20 do
		strIndents[i] = string.rep( "    ", i )
	end
end

-- The generated Lua code
local luaCodeStrs = {}        -- array of strings for bulk concat

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


--- Utility Functions --------------------------------------------------------

-- Add strCode as the start of a new Lua line, or blank line if strCode is nil
local function beginLuaLine( strCode )
	luaCodeStrs[#luaCodeStrs + 1] = "\n"
	if enableIndent then
		luaCodeStrs[#luaCodeStrs + 1] = strIndents[blockLevel] or ""
	end
	if strCode then
		luaCodeStrs[#luaCodeStrs + 1] = strCode
	end
end

-- Add strCode as Lua code
local function addLua( strCode )
	luaCodeStrs[#luaCodeStrs + 1] = strCode
end

-- Remove the last line of Lua code
local function removeLastLuaLine()
	repeat
		local code = luaCodeStrs[#luaCodeStrs]
		luaCodeStrs[#luaCodeStrs] = nil
	until string.find(code, "\n") or #luaCodeStrs == 0 
end


--- Code Generation Functions ------------------------------------------------

-- Mutually recursive code gen functions
local lValueCode
local fnCallCode
local exprCode
local generateControlledStmt


-- Return Lua code for a variable name
local function varNameCode( varName )
	if checkJava.isInstanceVarName( varName ) then
		return thisPrefix .. varName    -- instance var, so use this.name
	end
	return varName
end

-- Return Lua code for an lValue node, which might be a class or local reference.
function lValueCode( v )
	local p = v.p
	if p == "this" then
		return varNameCode( v.nodes[3].str ) 
	end

	local nameNode = v.nodes[1]
	assert( nameNode.tt == "ID" )
	local name = nameNode.str
	if checkJava.isInstanceVarName( name ) then
		name = thisPrefix .. name    -- class var, so turn name into this.name
	end
	if p == "var" then
		return name
	elseif p == "field" then
		return name .. "." .. v.nodes[3].str    --  obj.field reference
	elseif p == "index" then
		return name .. "[" .. exprCode( v.nodes[3] ) .. "]"
	end
	error( "Unknown lValue pattern " .. p )
end

-- Return Lua code for a function or method call, e.g:
--     ct.circle( x, y, d )
--     bird.setFillColor( "red" )
--	   foo()
function fnCallCode( tree )
	local nodes = tree.nodes
	local parts   -- There could be several parts, so prepare for a table.concat

	-- Function name/value
	local fnValue = nodes[1]
	if fnValue.p == "method" then
		local nameNode = fnValue.nodes[1]
		local varName = nameNode.str
		if checkJava.isInstanceVarName( varName ) then
			parts = { "this.", varName, ":", fnValue.nodes[2].str, "(" }  -- e.g. this.ball:delete(
		else
			parts = { varName, ":", fnValue.nodes[2].str, "(" }  -- e.g. obj:delete(
		end
	else
		local fnName = fnValue.str
		if string.starts( fnName, ctPrefix ) then
			if not ctDefined then
				err.setErrNode( fnValue, "Code12 API functions cannot be called before start()" )
				return nil
			end
			parts = { fnName, "(" }            -- e.g. ct.circle(
		else
			parts = { fnPrefix, fnName, "(" }   -- e.g. _fn.updateScore(
		end
	end

	-- Parameter list
	local exprs = nodes[3].nodes
	for i = 1, #exprs do
		parts[#parts + 1] = exprCode( exprs[i] )
		if i < #exprs then
			parts[#parts + 1] = ", "
		end
	end
	parts[#parts + 1] = ")"
	return table.concat( parts )
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
	end

	-- Is this a Binary operator?
	local luaOp = luaOpFromJavaOp[p]
	if luaOp then
		local left = nodes[1]
		local right = nodes[3]

		-- Look for special cases of binary operators
		if p == "+" and expr.info.vt == "String" then
			-- The + operator is concatenating strings, not adding
			luaOp = " .. "  -- TODO: Lua tables (GameObj) will not do a toString automatically
		end
		-- TODO: Verify that we don't need parentheses (Lua precedence is same as Java)
		return exprCode( left ) .. luaOp .. exprCode( right )
	else
		error( "Unknown expr type " .. p )
	end
end

-- Look for and generate code for a varInit, constInit, or varDecl line.
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
			beginLuaLine( thisPrefix )     -- use this.name
		else
			checkJava.defineLocalVar( nameNode, vt, false, true )
			beginLuaLine( "local " )
		end
		checkJava.canAssignToVarNode( nameNode, expr, true )
		addLua( varName )
		addLua( " = " )
		addLua( exprCode( expr ) )
		return true
	elseif p == "varDecl" then
		-- varType idList ;
		local vt = javaTypes.vtFromVarType( tree.nodes[1] )
		local idList = tree.nodes[2].nodes
		beginLuaLine( "" )   -- we may have multiple statements on this line
		for i = 1, #idList do
			local nameNode = idList[i]
			if isInstanceVar then
				checkJava.defineInstanceVar( nameNode, vt, false )
				addLua( thisPrefix )            -- use this.name
			else
				checkJava.defineLocalVar( nameNode, vt, false )
				addLua( "local " )
			end
			addLua( nameNode.str )
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
	end
	return false
end

-- Generate code for an increment or decrement (++ or --) stmt
-- given the lValue node and opToken is either a "++" or "--" token.
local function generateIncOrDecStmt( lValue, opToken )
	local vt = lValue.info.vt 
	local tt = opToken.tt
	assert( tt == "++" or tt == "--" )
	if type(vt) ~= "number" then
		err.setErrNodeAndRef( opToken, lValue, "Can only apply \"%s\" to numeric types", tt )
		return
	end
	local lValueStr = lValueCode( lValue )
	beginLuaLine( lValueStr )
	addLua( " = " )
	addLua( lValueStr )
	if tt == "++" then
		addLua( " + 1" )
	else
		addLua( " - 1" )
	end
end

-- Generate code for the single stmt in tree
local function generateStmt( tree )
	local p = tree.p
	local nodes = tree.nodes
	if p == "call" then
		-- fnValue ( exprList )
		if checkJava.vtCheckCall( nodes[1], nodes[3] ) == nil then
			return
		end
		beginLuaLine( fnCallCode( tree ) )
	elseif p == "assign" then
		-- ID = expr
		local varNode = nodes[1]
		local expr = nodes[3]
		if checkJava.canAssignToVarNode( varNode, expr ) then
			assert( varNode.tt == "ID" )
			beginLuaLine( varNameCode( varNode.str ) )
			addLua( " = " )
			addLua( exprCode( expr ) )
		end
	elseif p == "lValueAssign" then
		-- lValue = expr
		local lValue = nodes[1]
		local expr = nodes[3]
		if checkJava.canAssignToLValue( lValue, expr ) then
			beginLuaLine( lValueCode( lValue ) )
			addLua( " = " )
			addLua( exprCode( expr ) )
		end
	elseif p == "opAssign" then
		-- lValue op= expr
		local lValue = nodes[1]
		local expr = nodes[3]
		-- TODO: Better type checking, this is not correct
		if checkJava.canAssignToLValue( lValue, expr ) then
			local lValueStr = lValueCode( lValue )
			beginLuaLine( lValueStr )
			addLua( " = " )
			addLua( lValueStr )
			addLua( luaOpFromJavaOp[nodes[2].nodes[1].str] )
			addLua( "(" )
			addLua( exprCode( expr ) )
			addLua( ")" )
		end
	elseif p == "preInc" or p == "preDec" then
		generateIncOrDecStmt( nodes[2], nodes[1] )
	elseif p == "postInc" or p == "postDec" then
		generateIncOrDecStmt( nodes[1], nodes[2] )
	else
		error("*** Unknown stmt pattern " .. p )
	end	
end

-- Generate code for the block line in tree
local function generateBlockLine( tree )
	if not checkJava.doTypeChecks( tree ) then
		return
	end
	local p = tree.p
	local nodes = tree.nodes
	if p == "stmt" then
		-- stmt ;
		generateStmt( nodes[1] )
	elseif p == "blank" then
		-- blank
		beginLuaLine( "" )
	elseif enableComments and p == "comment" then
		-- Full line comment
		beginLuaLine( "--" )
		addLua( nodes[1].str )
	elseif generateVarDecl( tree, false ) then
		-- Processed a local varInit, constInit, or varDecl
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
		-- Process the controlled statement or block too
		iTree = iTree + 1
		generateControlledStmt()
	elseif p == "elseif" then
		-- else if (expr)
		local expr = nodes[4]
		if expr.info.vt ~= true then
			err.setErrNode( expr, "Conditional test must be boolean (true or false)" )
			return
		end
		removeLastLuaLine()   -- remove the end we made for the if
		beginLuaLine( "elseif " )
		addLua( exprCode( expr ) )
		addLua( " then")
		-- Process the controlled statement or block too
		iTree = iTree + 1
		generateControlledStmt()
	elseif p == "else" then
		-- else
		removeLastLuaLine()   -- remove the end we made for the if/elseif
		beginLuaLine( "else " )
		-- Process the controlled statement or block too
		iTree = iTree + 1
		generateControlledStmt()
	elseif p == "return" then
		-- return expr ;
		local expr = nodes[2]
		local vt = expr.info.vt
		-- TDOO: Check correct return type
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
		local tree = javaParseTrees[iTree]
		local p = tree.p
		if p == "begin" then              -- {
			checkJava.beginLocalBlock()
			blockLevel = blockLevel + 1
		elseif p == "end" then            -- }
			checkJava.endLocalBlock()
			blockLevel = blockLevel - 1
			beginLuaLine( "end")
			if blockLevel == startBlockLevel then
				return true
			end
		else
			generateBlockLine( tree )
		end
		iTree = iTree + 1	
	until false
end

-- Generate code for a controlled statment after an if/else or loop,
-- which is a single block line, or a block nested with { } 
-- if iTree is at a {.  End with iTree still at the stmt or at the ending }
function generateControlledStmt()
	local tree = javaParseTrees[iTree]
	if tree.p == "begin" then
		generateBlock()
	else
		-- Single controlled statement
		blockLevel = blockLevel + 1
		generateBlockLine( tree )
		blockLevel = blockLevel - 1
		beginLuaLine( "end" )
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
-- The function is a Code12 event function if isEvent, otherwise user-defined.
-- starting with the name of the function, then generate its code block afterwards.
-- Return true if successful.
local function generateFunction( isEvent, fnName, paramList )
	beginLuaLine( "function " )
	if not isEvent then
		addLua( fnPrefix )
	end
	addLua( fnName )
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
function codeGenJava.getLuaCode( parseTrees )
	-- Set up the working state
	javaParseTrees = parseTrees
	iTree = 1
	blockLevel = 0
	luaCodeStrs = {}

	-- Scan the parse trees for instance variables and functions
	while iTree <= #parseTrees and not err.hasErr() do
		local tree = javaParseTrees[iTree]
		-- print( "getLuaCode line " .. iTree )
		if not checkJava.doTypeChecks( tree ) then
			break
		end
		local p = tree.p
		local nodes = tree.nodes

		if generateVarDecl( tree, true ) then
			-- Processed a varInit, constInit, or varDecl
		elseif enableComments and p == "comment" then
			-- Full line comment
			beginLuaLine( "--" )
			addLua( nodes[1].str )
		elseif p == "blank" then
			beginLuaLine( "" )
		elseif p == "begin" then          -- {  in boilerplate code
			blockLevel = blockLevel + 1
		elseif p == "end" then            -- }  in boilerplate code
			blockLevel = blockLevel - 1
		elseif p == "eventFn" then
			-- Code12 event func (e.g. setup, update)
			generateFunction( true, nodes[3].str, nodes[5].nodes)
		elseif p == "func" then
			-- User-defined function
			generateFunction( false, nodes[2].str, nodes[4].nodes)
		end			
		iTree = iTree + 1
	end

	-- Bulk concat and return all the Lua code
	return table.concat( luaCodeStrs )
end


------------------------------------------------------------------------------

return codeGenJava
