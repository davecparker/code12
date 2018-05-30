-----------------------------------------------------------------------------------------
--
-- codeGenJava.lua
--
-- Generates Lua code from Java Parse trees for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- The codeGen module
local codeGenJava = {}


-- Constants
local varTable = "this."      -- table name for user instance variables
local fnTable = "_fn."        -- table name for user functions
 

-- The Java parse trees and processing state
local javaParseTrees	      -- array of parse trees (for each line of Java)
local iTree            	      -- index of next parse tree to process
local blockLevel = 0          -- indent level (begin/end block level) for Lua code

-- Indentation for the Lua code
local enableIndent = true     -- set to false to disable indnetation
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

-- Return Lua code for a function call, e.g. ct.circle( x, y, d ), or myFoo()
function fnCallCode( tree )
	local exprs = tree.nodes[2].nodes
	local fnName = tree.nodes[1].str
	local parts = {}
	if string.starts( fnName, "ct." ) then
		parts = { fnName, "(" }
	else
		parts = { fnTable, fnName, "(" }
	end
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
	if p == "NUM" or p == "STR" or p == "BOOL" then
		return expr.nodes[1].str
	elseif p == "NULL" then
		return "nil"
	elseif p == "lValue" then
		return lValueCode( expr.nodes[1] )
	elseif p == "call" then
		return fnCallCode( expr )
	elseif p == "neg" then
		return "-" .. exprCode( expr.nodes[1] )
	elseif p == "!" then
		return "not " .. exprCode( expr.nodes[1] )
	elseif p == "exprParens" then
		return "(" .. exprCode( expr.nodes[1] ) .. ")"
	end

	-- Is this a Binary operator?
	local luaOp = luaOpFromJavaOp[p]
	if luaOp then
		return table.concat{ exprCode( expr.nodes[1] ),
			" ", luaOp, " ", exprCode( expr.nodes[2] ) } 
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
		if isInstanceVar then
			isClassVar[varName] = true   -- remember class vars
			beginLuaLine( varTable )     -- use this.name
		else
			beginLuaLine( "local " )
		end
		addLua( varName )
		addLua( " = " )
		addLua( exprCode( tree.nodes[3] ) )
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
	elseif p == "assign" then
		-- lValue rightSide
		local lValue = lValueCode( tree.nodes[1] )
		beginLuaLine( lValue )
		addLua( " = " )
		p = tree.nodes[2].p
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
		print("*** Unknown stmt pattern " .. p )
	end	
end

-- Generate code for the block line in tree
local function generateBlockLine( tree )
	local p = tree.p
	if p == "stmt" then
		-- stmt ;
		generateStmt( tree.nodes[1] )
	elseif p == "blank" then
		-- blank
		beginLuaLine( "" )
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
		local tree = javaParseTrees[iTree]
		local p = tree.p
		if generateVarDecl( tree, true ) then
			-- Processed a varInit, constInit, or varDecl
		elseif p == "begin" then
			blockLevel = blockLevel + 1
		elseif p == "end" then
			blockLevel = blockLevel - 1
		elseif p == "eventFn" then
			-- Code12 event func (e.g. setup, update)
			beginLuaLine()
			beginLuaLine( "function " )
			addLua( fnTable )
			addLua( tree.nodes[1].str )
			addLua( "()" )
			iTree = iTree + 1 
			generateBlock()
		end
		iTree = iTree + 1 
	end

	-- Bulk concat and return all the Lua code
	return table.concat( luaCodeStrs )
end


------------------------------------------------------------------------------

return codeGenJava
