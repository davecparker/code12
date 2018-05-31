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
local isClassVar = {}         -- maps variable name to true if class variable

-- Map supported Java binary operators to Lua operators
local luaOpFromJavaOp = {
	["*"]	= "*",
	["/"]	= "/",
	["%"]	= "%",
	["+"]	= "+",
	["-"]	= "-",
	["<"]	= "<",
	["<="]	= "<=",
	[">"]	= ">",
	[">="]	= ">=",
	["=="]	= "==",
	["!="]	= "~=",
	["&&"]	= "and",
	["||"]	= "or",
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


-- Return Lua code for an lValue, which might be a class or local reference.
function lValueCode( v )
	local p = v.p
	local name = v.nodes[1].str

	if p == "this" then
		return "this." .. name    -- explicit reference to a class variable
	end

	-- For other references, the name could be either a local var or a class var.
	-- Look in the table of known class variables to determine which
	-- (works because Code12 does not allow local vars to hide class vars).
	if isClassVar[name] then
		name = varTable .. name    -- class var, so turn name into this.name
	end
	if p == "var" then
		return name
	elseif p == "field" then
		local field = v.nodes[2].str
		return name .. "." .. field    --  obj.field reference
	elseif p == "index" then
		local indexExpr = exprCode( v.nodes[2] )
		return name .. "[" .. indexExpr .. "]"
	end
	error( "Unknown lValue pattern " .. p )
end

-- Return Lua code for a function or method call, e.g:
--     ct.circle( x, y, d )
--     bird.setFillColor( "red" )
--	   foo()
function fnCallCode( tree )
	-- There could be several parts, so prepare for a table.concat
	local parts

	-- Function name/value
	local fnValue = tree.nodes[1]
	if fnValue.p == "method" then
		parts = { fnValue.nodes[1].str, ":", fnValue.nodes[2].str, "(" }
	else
		local fnName = tree.nodes[1].str
		if string.starts( fnName, "ct." ) then
			parts = { fnName, "(" }
		else
			parts = { fnTable, fnName, "(" }
		end
	end

	-- Parameter list
	local exprs = tree.nodes[2].nodes
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
		return "-" .. exprCode( nodes[1] )
	elseif p == "!" then
		return "not " .. exprCode( nodes[1] )
	elseif p == "exprParens" then
		return "(" .. exprCode( nodes[1] ) .. ")"
	end

	-- Is this a Binary operator?
	local luaOp = luaOpFromJavaOp[p]
	if luaOp then
		local leftExpr = nodes[1]
		local rightExpr = nodes[2]
		-- Check if the + operator is concatenating strings
		if luaOp == "+" and expr.vt == "String" then
			luaOp = ".."  -- TODO: Lua objects will not do a toString automatically
		end
		return table.concat{ exprCode( leftExpr ), " ",
						luaOp, " ", exprCode( rightExpr ) } 
	else
		error( "Unknown expr type " .. p )
	end
end

-- Look for and generate code for a varInit, constInit, or varDecl line.
-- in tree. Return true if one was found and generated, else return false.
-- If isInstanceVar then the line is outside all functions (else local).
local function generateVarDecl( tree, isInstanceVar )
	local p = tree.p
	if p == "varInit" or p == "constInit" then
		-- e.g. int x = y + 10;
		local varName = tree.nodes[2].str
		local expr = tree.nodes[3]
		checkJava.doTypeAnalysis( expr )
		if isInstanceVar then
			isClassVar[varName] = true   -- remember class vars
			beginLuaLine( varTable )     -- use this.name
		else
			beginLuaLine( "local " )
		end
		addLua( varName )
		addLua( " = " )
		addLua( exprCode( expr ) )
		return true
	elseif p == "varDecl" then
		-- varType idList ;
		local varType = tree.nodes[1].str
		local idList = tree.nodes[2].nodes
		beginLuaLine( "" )   -- we may have multiple statements on this line
		for i = 1, #idList do
			local varName = idList[i].str
			if isInstanceVar then
				isClassVar[varName] = true    -- remember class vars
				addLua( varTable )            -- use this.name
			else
				addLua( "local " )
			end
			addLua( varName )
			addLua( " = " )
			-- Need to init primitives so they don't start as nil.
			-- We will go ahead and init all types for completeness.
			local value = "nil; "
			if varType == "int" or varType == "double" then
				value = "0; "
			elseif varType == "boolean" then
				value = "false; "
			end
			addLua( value )
		end
		return true
	end
	return false
end

-- Generate code for the single stmt in tree
local function generateStmt( tree )
	local p = tree.p
	if p == "call" then
		-- fnValue ( exprList )
		beginLuaLine( fnCallCode( tree ) )
		return
	elseif p == "++" or p == "--" then
		-- Transform to assign (post-inc or post-dec) for handling below. 
		-- Note that these are treated as stmts not exprs, so pre is same as post.
		tree.nodes[2] = { t = "rightSide", p = p }
		p = "assign"
	end

	if p == "assign" then
		-- lValue rightSide
		local lValue = lValueCode( tree.nodes[1] )
		beginLuaLine( lValue )
		addLua( " = " )
		p = tree.nodes[2].p  -- rightSide
		local expr
		if p == "++" then
			addLua( lValue )
			addLua( " + " )
			expr = "1"
		elseif p == "--" then
			addLua( lValue )
			addLua( " - " )
			expr = "1"
		else
			if p ~= "=" then
				-- +=, -=, *=, /=
				addLua( lValue )
				addLua( string.char( 32, string.byte(p), 32 ) )  -- e.g. " + "
			end
			expr = exprCode( tree.nodes[2].nodes[1] )
		end
		addLua( expr )
	else
		error("*** Unknown stmt pattern " .. p )
	end	
end

-- Generate code for the block line in tree
local function generateBlockLine( tree )
	checkJava.doTypeAnalysis( tree )
	local p = tree.p
	if p == "stmt" then
		-- stmt ;
		generateStmt( tree.nodes[1] )
	elseif p == "blank" then
		-- blank
		beginLuaLine( "" )
	elseif enableComments and p == "comment" then
		-- Full line comment
		beginLuaLine( "--" )
		addLua( tree.nodes[1].str )
	elseif generateVarDecl( tree, false ) then
		-- Processed a local varInit, constInit, or varDecl
	elseif p == "if" then
		-- if (expr)
		beginLuaLine( "if " )
		addLua( exprCode( tree.nodes[1] ) )
		addLua( " then")
		-- Process the controlled statement or block too
		iTree = iTree + 1
		generateControlledStmt()
	elseif p == "elseif" then
		-- else if (expr)
		removeLastLuaLine()   -- remove the end we made for the if
		beginLuaLine( "elseif " )
		addLua( exprCode( tree.nodes[1] ) )
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
		addLua( exprCode( tree.nodes[1] ) )		
	else
		print("*** Unknown line pattern " .. p )
	end
end

-- Generate Lua code for a { } block of code.
-- Start with iTree at the { and return with iTree at the }.
local function generateBlock()
	local startBlockLevel = blockLevel
	repeat
		local tree = javaParseTrees[iTree]
		local p = tree.p

		if p == "begin" then
			-- {
			blockLevel = blockLevel + 1
		elseif p == "end" then
			-- }
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
		addLua( param.nodes[2].str )
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
	isClassVar = {}

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
		elseif p == "begin" then
			blockLevel = blockLevel + 1
		elseif p == "end" then
			blockLevel = blockLevel - 1
		elseif p == "eventFn" then
			-- Code12 event func (e.g. setup, update)
			local paramList = tree.nodes[2].nodes
			generateFnHeader( tree.nodes[1].str, paramList )
			iTree = iTree + 1 
			checkJava.initLocalVars( paramList )
			generateBlock()
		elseif p == "func" then
			-- User-defined function
			local paramList = tree.nodes[3].nodes
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
