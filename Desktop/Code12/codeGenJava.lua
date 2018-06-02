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


-- The codeGen module
local codeGenJava = {}


-- Constants
local varTable = "this."      -- table name for user instance variables
local fnTable = "_fn."        -- table name for user functions
 

-- The Java parse trees and processing state
local javaParseTrees	      -- array of parse trees (for each line of Java)
local iTree            	      -- index of next parse tree to process
local blockLevel = 0          -- indent level (begin/end block level) for Lua code

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
	-- Assignment ops used in rightSide nodes
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

-- NOTE: Code generation assumes that the structure of the program is a valid
-- Code12 structure, valid names, etc. So to be reliable, the program must be 
-- fully validated by semantic analysis first.


-- Mutually recursive code gen functions
local lValueCode
local fnCallCode
local exprCode
local generateControlledStmt


-- Return Lua code for an lValue node, which might be a class or local reference.
function lValueCode( v )
	local p = v.p
	if p == "this" then
		return "this." .. v.nodes[3].str    -- explicit reference to a class variable
	end

	-- For other references, the name could be either a local var or a class var.
	-- Look in the table of known class variables to determine which
	-- (works because Code12 does not allow local vars to hide class vars).
	local name = v.nodes[1].str
	if checkJava.vtClassVar( name ) ~= nil then
		name = varTable .. name    -- class var, so turn name into this.name
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
	local parts   -- There could be several parts, so prepare for a table.concat

	-- Function name/value
	local fnValue = tree.nodes[1]
	if fnValue.p == "method" then
		parts = { fnValue.nodes[1].str, ":", fnValue.nodes[2].str, "(" }  -- e.g. bird:delete(
	else
		local fnName = fnValue.str
		if string.starts( fnName, "ct." ) then
			parts = { fnName, "(" }            -- e.g. ct.circle(
		else
			parts = { fnTable, fnName, "(" }   -- e.g. _fn.updateScore(
		end
	end

	-- Parameter list
	local exprs = tree.nodes[3].nodes
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
		local leftExpr = nodes[1]
		local rightExpr = nodes[3]
		-- Check if the + operator is concatenating strings
		if luaOp == " + " and expr.vt == "String" then
			luaOp = " .. "  -- TODO: Lua tables (GameObj) will not do a toString automatically
		end
		-- TODO: Verify that we don't need parentheses (Lua precedence is same as Java)
		return exprCode( leftExpr ) .. luaOp .. exprCode( rightExpr )
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
			vt = checkJava.vtFromVarType( nodes[1] )
			nameNode = nodes[2]
			expr = nodes[4]
		else
			vt = checkJava.vtFromVarType( nodes[2] )
			nameNode = nodes[3]
			expr = nodes[5]
		end
		checkJava.doTypeAnalysis( expr )
		checkJava.canAssignToVt( nameNode, vt, expr )
		local varName = nameNode.str
		if isInstanceVar then
			checkJava.defineClassVar( nameNode, vt, false )
			beginLuaLine( varTable )     -- use this.name
		else
			checkJava.defineLocalVar( nameNode, vt, false )
			beginLuaLine( "local " )
		end
		addLua( varName )
		addLua( " = " )
		addLua( exprCode( expr ) )
		return true
	elseif p == "varDecl" then
		-- varType idList ;
		local vt = checkJava.vtFromVarType( tree.nodes[1] )
		local idList = tree.nodes[2].nodes
		beginLuaLine( "" )   -- we may have multiple statements on this line
		for i = 1, #idList do
			local nameNode = idList[i]
			if isInstanceVar then
				checkJava.defineClassVar( nameNode, vt, false )
				addLua( varTable )            -- use this.name
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
-- given the lValue node and p either "++" or "--"
local function generateIncOrDecStmt( lValue, p )
	local lValueStr = lValueCode( lValue )
	beginLuaLine( lValueStr )
	addLua( " = " )
	if p == "++" then
		addLua( lValueStr )
		addLua( " + 1" )
	elseif p == "--" then
		addLua( lValueStr )
		addLua( " - 1" )
	end
end

-- Generate code for the single stmt in tree
local function generateStmt( tree )
	local p = tree.p
	local nodes = tree.nodes
	if p == "call" then
		-- fnValue ( exprList )
		beginLuaLine( fnCallCode( tree ) )
	elseif p == "assign" then
		-- lValue rightSide
		local rightSide = nodes[2]
		p = rightSide.p
		if p == "++" or p == "--" then
			generateIncOrDecStmt( nodes[1], p )
		else
			local lValue = nodes[1]
			local expr = rightSide.nodes[2]
			local lValueStr = lValueCode( lValue )
			local exprStr = exprCode( expr )
			beginLuaLine( lValueStr )
			addLua( " = " )
			if p == "=" then
				checkJava.canAssignToLValue( lValue, expr )
				addLua( exprStr )
			else
				-- +=, -=, *=, /=
				addLua( lValueStr )
				addLua( luaOpFromJavaOp[p] )
				addLua( "(" )
				addLua( exprStr )
				addLua( ")" )
			end
		end
	elseif p == "++" or p == "--" then
		-- ++ lValue or -- lValue
		generateIncOrDecStmt( nodes[2], p )
	else
		error("*** Unknown stmt pattern " .. p )
	end	
end

-- Generate code for the block line in tree
local function generateBlockLine( tree )
	checkJava.doTypeAnalysis( tree )
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
		beginLuaLine( "if " )
		addLua( exprCode( nodes[3] ) )
		addLua( " then")
		-- Process the controlled statement or block too
		iTree = iTree + 1
		generateControlledStmt()
	elseif p == "elseif" then
		-- else if (expr)
		removeLastLuaLine()   -- remove the end we made for the if
		beginLuaLine( "elseif " )
		addLua( exprCode( nodes[4] ) )
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
		beginLuaLine( "return " )
		addLua( exprCode( nodes[2] ) )
	else
		error( "*** Unknown line pattern " .. p )
	end
end

-- Generate Lua code for a { } block of code.
-- Start with iTree at the { and return with iTree at the }.
local function generateBlock()
	local startBlockLevel = blockLevel
	repeat
		local tree = javaParseTrees[iTree]
		local p = tree.p

		if p == "begin" then              -- {
			blockLevel = blockLevel + 1
		elseif p == "end" then            -- }
			blockLevel = blockLevel - 1
			beginLuaLine( "end")
			if blockLevel == startBlockLevel then
				return
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

-- Generage code for a function header with the given name and paramList
local function generateFnHeader( name, paramList )
	beginLuaLine( "function " )
	addLua( fnTable )
	addLua( name )
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
	while iTree <= #parseTrees do
		-- Do type analysis on this tree given types currently known
		local tree = javaParseTrees[iTree]
		local p = tree.p

		if generateVarDecl( tree, true ) then
			-- Processed a varInit, constInit, or varDecl
		elseif enableComments and p == "comment" then
			-- Full line comment
			beginLuaLine( "--" )
			addLua( tree.nodes[1].str )
		elseif p == "blank" then
			beginLuaLine( "" )
		elseif p == "begin" then          -- {
			blockLevel = blockLevel + 1
		elseif p == "end" then            -- }
			blockLevel = blockLevel - 1
		elseif p == "eventFn" then
			-- Code12 event func (e.g. setup, update)
			local paramList = tree.nodes[5].nodes
			generateFnHeader( tree.nodes[3].str, paramList )
			iTree = iTree + 1 
			checkJava.initLocalVars( paramList )
			generateBlock()
		elseif p == "func" then
			-- User-defined function
			local paramList = tree.nodes[4].nodes
			generateFnHeader( tree.nodes[2].str, paramList )
			iTree = iTree + 1 
			checkJava.initLocalVars( paramList )
			generateBlock()
		end			
		iTree = iTree + 1
	end

	-- Bulk concat and return all the Lua code
	return table.concat( luaCodeStrs )
end


------------------------------------------------------------------------------

return codeGenJava
