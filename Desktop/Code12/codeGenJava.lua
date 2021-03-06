-----------------------------------------------------------------------------------------
--
-- codeGenJava.lua
--
-- Generates Lua code from a Code12 Program Tree structure for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12 
-----------------------------------------------------------------------------------------

-- Code12 modules
local source = require( "source" )


-- The codeGen module
local codeGenJava = {}


-- Constants
local ctPrefix = "ct."        -- prefix for API functions
local thisPrefix = "this."    -- prefix for user instance variables
local fnPrefix = "_fn."       -- prefix for user function names
 
-- Code generation options
local enableComments = true   -- generate Lua comments for end-of-line Java comments

-- Indentation for the Lua code
local strIndents = {}
for i = 0, 20 do
	strIndents[i] = string.rep( "\t", i )
end

-- The generated Lua code and code generation state
local luaCodeStrs             -- array of strings for bulk concat (many less than one line)
local luaLineNum              -- Current line number in the Lua code
local luaLineIsBlank          -- true if the current Lua line is blank so far
local blockLevel              -- Current indent level (begin/end block level) for Lua code

-- Forward declarations for recursive functions
local exprCode
local generateStmt

-- Map unaryOp, binOp, and assign opType strings to Lua operator code (Lua op plus spaces)
local luaOpFromOpType = {
	-- unaryOp
	["neg"] = " -",
	["not"] = " not ",
	-- binOp
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
	-- assign
	["="]   = " = ",
	["+="]	= " + ",
	["-="]	= " - ",
	["*="]	= " * ",
	["/="]	= " / ",
	["++"]  = " + 1",
	["--"]  = " - 1",
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

-- End the current Lua line, adding the comment if applicable.
-- If indent then the comment needs to be indented.
local function endLuaLine( indent )
	if enableComments then
		local strComment = source.lines[luaLineNum].commentStr
		if strComment then
			if indent then
				luaCodeStrs[#luaCodeStrs + 1] = strIndents[blockLevel] or ""
			end
			luaCodeStrs[#luaCodeStrs + 1] = (luaLineIsBlank and "--") or "   --"
			luaCodeStrs[#luaCodeStrs + 1] = strComment
		end
	end
	luaCodeStrs[#luaCodeStrs + 1] = "\n"
	luaLineNum = luaLineNum + 1
	luaLineIsBlank = true
end

-- End the previous line of Lua code and begin a new line for line number iLine
-- or the next line if iLine is nil. If strCode then start the new line with it.
local function beginLuaLine( iLine, strCode )
	-- If the new line is on the same line number as the previous line 
	-- then separate them with spaces, else end the previous line and add
	-- any extra blank lines to catch up to the new line number as necessary.
	local indent = true
	if iLine == nil then
		endLuaLine()
	elseif iLine <= luaLineNum then
		luaCodeStrs[#luaCodeStrs + 1] = "  "
		indent = false
	else
		endLuaLine()
		while luaLineNum < iLine do
			endLuaLine( true )
		end
	end

	-- Indent the new line and start with the given code as necessary
	if indent then
		luaCodeStrs[#luaCodeStrs + 1] = strIndents[blockLevel] or ""
	end
	if strCode then
		luaCodeStrs[#luaCodeStrs + 1] = strCode
		luaLineIsBlank = false
	end
end

-- Add strCode as Lua code
local function addLua( strCode )
	luaCodeStrs[#luaCodeStrs + 1] = strCode
	luaLineIsBlank = false
end

-- If block then end the block by generating a Lua "end"
local function endBlock( block )
	if block then
		beginLuaLine( block.iLineEnd, "end" )
	end
end


--- Expression Generation Functions ------------------------------------------

-- Return Lua code for a variable name, which is global if isGlobal
local function varNameCode( varName, isGlobal )
	local luaName = codeGenJava.luaName( varName )
	if isGlobal then
		return thisPrefix .. luaName    -- this.name
	end
	return luaName
end

-- Return Lua code for the variable with optional array index part of an lValue. 
-- If assigned then the lValue is being assigned to, otherwise it is being read.  
local function varIndexCode( lValue, assigned )
	-- Get code for the variable
	local varCode = varNameCode( lValue.varID.str, lValue.isGlobal )
	local indexExpr = lValue.indexExpr
	if indexExpr == nil then
		return varCode
	end

	-- Generate calls to special runtime functions that do array index checks
	local indexStr = exprCode( indexExpr )
	if assigned then
		return table.concat{ "ct.checkArrayIndex(", varCode, ", ", indexStr, "); ",
					varCode, "[1+(", indexStr, ")]" }
	else
		return "ct.indexArray(" .. varCode .. ", " .. indexStr .. ")"
	end
end

-- Return Lua code for an lValue. 
-- If assigned then the lValue is being assigned to, otherwise it is being read. 
local function lValueCode( lValue, assigned )
	local code = varIndexCode( lValue, assigned )
	if lValue.fieldID then
		code = code .. "." .. lValue.fieldID.str
	end
	return code
end

-- Return Lua code for a static field
local function staticFieldCode( expr )
	if expr.class.str == "Math" then
		local fieldName = expr.fieldID.str
		if fieldName == "PI" then
			return "math.pi"
		elseif fieldName == "E" then
			return "math.exp(1)"
		end
	end
	return "nil"   -- shouldn't happen
end 

-- Return Lua code for a function name
local function fnNameCode( fnName )
	return fnPrefix .. codeGenJava.luaName( fnName )
end

-- Return Lua code for expr promoted to a string
local function stringExprCode( expr )
	local vt = expr.vt
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

-- Return the code string for the default (unitialized) value for a vt.
local function defaultValueCodeForVt( vt )
	if type(vt) == "number" then
		return "0"
	elseif vt == true then
		return "false"
	else
		return "nil"
	end
end

-- Return the Lua code string for a call structure.
local function callCode( call )
	local class = call.class
	local lValue = call.lValue
	local nameID = call.nameID
	local methodName = nameID.str
	local exprs = call.exprs
	local numExprs = (exprs and #exprs) or 0
	local parts   -- array of strings for a table.concat

	if class then
		local className = class.str
		if className == "ct" or className == "System" then
			-- Note that System.out.xxx maps to ct.xxx
			-- Check special case: ct.println() with no params needs to generate ct.println("")
			if methodName == "println" and numExprs == 0 then
				return 'ct.println( "" )'
			end
			parts = { ctPrefix, methodName, "(" }    -- e.g. ct.circle(
		elseif className == "Math" then 
			-- Lua math.xxx is the same as Java Math.xxx for all supported methods :)
			parts = { "math.", methodName, "(" }
		end
	elseif lValue == nil then
		-- User-defined function call
		parts = { fnNameCode( methodName ), "(" }   -- e.g. _fn.updateScore(
	elseif lValue.vt == "String" then
		-- String methods
		if methodName == "equals" then
			-- Lua can compare strings directly with ==
			return "(" .. lValueCode( lValue ) 
					.. " == " .. exprCode( exprs[1] ) .. ")"
		end
		-- Map to corresponding global Lua function, passing the object.  
		parts = { luaFnFromJavaStringMethod[methodName] or "", "(", 
				lValueCode( lValue ) }
		if numExprs > 0 then
			parts[#parts + 1] = ", "
		end
	else
		-- GameObj method, e.g. obj:delete(
		parts = { lValueCode( lValue ), ":", methodName, "(" }
	end

	-- Add the parameter value exprs
	for i = 1, numExprs do
		parts[#parts + 1] = exprCode( exprs[i] )
		if i < numExprs then
			parts[#parts + 1] = ", "
		end
	end
	parts[#parts + 1] = ")"
	return table.concat( parts )
end

-- Return the Lua code string for a call expr
local function callExprCode( expr )
	return callCode( expr )
end

-- Return the Lua code string for a type cast
local function castCode( expr )
	-- The only supported type casts are ((int) double) and ((double) int)
	if expr.vtCast == 0 then  -- (int)
		return "ct.toInt(" .. exprCode( expr.expr ) .. ")"
	else
		return exprCode( expr.expr )
	end
end

-- Return the Lua code string for a parens expr
local function parensCode( expr )
	return "(" .. exprCode( expr.expr ) .. ")"
end

-- Return the Lua code string for a unaryOp expr
local function unaryOpCode( expr )
	return luaOpFromOpType[expr.opType] .. exprCode( expr.expr )
end

-- Return the Lua code string for a binOp expr
local function binOpCode( expr )
	local luaOp = luaOpFromOpType[expr.opType]
	if luaOp == nil then
		return "nil"   -- unsupported operator (may be continuing on errors)
	elseif expr.opType == "+" and expr.vt == "String" then
		-- String concat, not add. Promote left and right to string as needed.
		return stringExprCode( expr.left ) .. " .. " .. stringExprCode( expr.right )
	end
	return exprCode( expr.left ) .. luaOp .. exprCode( expr.right )
end

-- Return vt in quotes if the lua type of vt is string
-- otherwise return the string representation of vt.
local function vtStr( vt )
	if type( vt ) == "string" then
		return '"' .. vt .. '"'
	end
	return tostring(vt)
end

-- Return the Lua code string for a newArray expr
local function newArrayCode( expr )
	return "{ length = " .. exprCode( expr.lengthExpr )
			.. ", vt = " .. vtStr( expr.vtElement )
			.. ", default = " ..  defaultValueCodeForVt( expr.vtElement ) .. " }"
end

-- Return the Lua code string for an arrayInit expr
local function arrayInitCode( expr )
	local codeStrs = { "{ " }
	local length = 0
	if expr.exprs then
		for _, ex in ipairs( expr.exprs ) do
			codeStrs[#codeStrs + 1] = exprCode( ex )
			codeStrs[#codeStrs + 1] = ", "
			length = length + 1
		end
	end
	codeStrs[#codeStrs + 1] = "length = " .. length
	if expr.vt and expr.vt.vt then
		codeStrs[#codeStrs + 1] = ", vt = " .. vtStr( expr.vt.vt )
	end
	codeStrs[#codeStrs + 1] = " }"
	return table.concat( codeStrs )
end

-- "new Class()" is not allowed outside main, which doesn't generate code
local function newClassCode()
	return ""
end

-- Functions to generate code for the various expr types
local fnGenerateExpr = {
	["call"]         = callExprCode,
	["lValue"]       = lValueCode,
	["staticField"]  = staticFieldCode,
	["cast"]         = castCode,
	["parens"]       = parensCode,
	["unaryOp"]      = unaryOpCode,
	["binOp"]        = binOpCode,
	["newArray"]     = newArrayCode,
	["arrayInit"]    = arrayInitCode,
	["new"]          = newClassCode,
}

-- Return the Lua code for the given expr
function exprCode( expr )
	-- Check for the expr node being a literal token node
	local tt = expr.tt
	if tt == "NULL" then
		return "nil"
	elseif tt then    -- INT, NUM, BOOL, STR
		return expr.str
	else
		local fn = fnGenerateExpr[expr.s]
		if fn then
			return fn( expr )
		end
		error( "Unknown expr type " .. expr.s )
	end
end


--- Statement Generation Functions -------------------------------------------

-- If block then generate Lua code for the stmts in the block
local function generateBlockStmts( block )
	if block and block.stmts then
		blockLevel = blockLevel + 1
		for _, stmt in ipairs( block.stmts ) do
			generateStmt( stmt )
		end
		blockLevel = blockLevel - 1
	end
end

-- Generate a var structure
local function generateVar( var )
	-- Generate the variable declaration
	if var.isGlobal then
		beginLuaLine( var.iLine, varNameCode( var.nameID.str, true ) )
	else
		beginLuaLine( var.iLine, "local " )
		addLua( varNameCode( var.nameID.str ) )
	end

	-- Generate the initialization. If no initExpr is given, then init to
	-- a default value so the Lua var doesn't start out nil (also needed
	-- for correct syntax of non-local variables).
	addLua( " = " )
	if var.initExpr then
		addLua( exprCode( var.initExpr ) )
	else
		addLua( tostring( defaultValueCodeForVt( var.vt ) ) )
	end
end

-- Generate Lua code for the given call stmt
local function generateCall( stmt )
	beginLuaLine( stmt.iLine, callCode( stmt ) )
end

-- Generate Lua code for the given assign stmt
local function generateAssign( stmt )
	-- Generate the left side
	beginLuaLine( stmt.iLine, lValueCode( stmt.lValue, true ) )
	addLua( " = " )

	-- Generate the right side
	local opType = stmt.opType
	if opType == "=" then
		addLua( exprCode( stmt.expr ) )
	elseif opType == "++" or opType == "--" then
		addLua( lValueCode( stmt.lValue ) )
		addLua( luaOpFromOpType[opType] )
	else   -- +=, -=, *=, /=
		addLua( lValueCode( stmt.lValue ) )
		if stmt.lValue.vt == "String" then
			addLua( " .. " )
		else
			addLua( luaOpFromOpType[opType] )
		end
		addLua( "(" )
		addLua( exprCode( stmt.expr ) )
		addLua( ")" )
	end

	-- When an array is (re)assigned, we need to notify the runtime
	-- because the varWatch window may need to be rebuilt.
	if type( stmt.lValue.vt ) == "table" then
		addLua( "; ct.arrayAssigned()" )
	end
end

-- Generate Lua code for the given if stmt
local function generateIf( stmt )
	-- Generate the if with the test expr and the controlled stmts
	beginLuaLine( stmt.iLine, "if ")
	addLua( exprCode( stmt.expr ) )
	addLua( " then")
	generateBlockStmts( stmt.block )

	-- Generate the else block if any.
	-- If the else block is a single stmt which is an if, 
	-- then we can generate a Lua elseif, and keep looking
	-- for more at the same level.
	local elseBlock = stmt.elseBlock
	while elseBlock do
		local elseStmts = elseBlock.stmts
		if #elseStmts == 1 and elseStmts[1].s == "if" then
			local ifStmt = elseStmts[1]
			beginLuaLine( nil, "elseif ")
			addLua( exprCode( ifStmt.expr ) )
			addLua( " then")
			generateBlockStmts( ifStmt.block )
			elseBlock = ifStmt.elseBlock
		else
			beginLuaLine( nil, "else" )
			generateBlockStmts( elseBlock )
			elseBlock = nil
		end
	end
	endBlock( stmt.block )
end

-- Generate Lua code for the given while stmt
local function generateWhile( stmt )
	beginLuaLine( stmt.iLine, "while " )
	addLua( exprCode( stmt.expr ) )
	addLua( " do ct.checkFrame() ")
	generateBlockStmts( stmt.block )
	endBlock( stmt.block )
end

-- Generate Lua code for the given doWhile stmt
local function generateDoWhile( stmt )
	beginLuaLine( stmt.iLine, "repeat ct.checkFrame() " )
	generateBlockStmts( stmt.block )
	beginLuaLine( stmt.iLineWhile, "until not (")
	addLua( exprCode( stmt.expr ) )
	addLua( ")" )
end

-- Generate Lua code for the given for stmt
local function generateFor( stmt )
	-- Start with the initStmt if any
	addLua( " do " )
	if stmt.initStmt then
		generateStmt( stmt.initStmt )
	end

	-- Generate a while loop with the test expression if any
	beginLuaLine( stmt.iLine, "while " )
	if stmt.expr then
		addLua( exprCode( stmt.expr ) )
	else
		addLua( "true" )
	end
	addLua( " do ct.checkFrame() " )

	-- Generate the controlled stmts, nextStmt if any, and the end
	generateBlockStmts( stmt.block )
	if stmt.nextStmt then
		generateStmt( stmt.nextStmt )
	end
	endBlock( stmt.block )
	addLua( " end" )
end

-- Generate Lua code for the given forArray stmt
local function generateForArray( stmt )
	beginLuaLine( stmt.iLine, "for _i = 0, (" )
	local exprCodeStr = exprCode( stmt.expr ) 
	addLua( exprCodeStr )
	addLua( ").length - 1 do " )   -- no ct.checkFrame() because can't be infinite
	addLua( varNameCode( stmt.var.nameID.str ) )
	addLua( " = ct.indexArray(" )
	addLua( exprCodeStr )
	addLua( ", _i) ")
	generateBlockStmts( stmt.block )
	endBlock( stmt.block )
end

-- Generate Lua code for the given break stmt
local function generateBreak( stmt )
	beginLuaLine( stmt.iLine, "break" )
end

-- Generate Lua code for the given return stmt
local function generateReturn( stmt )
	beginLuaLine( stmt.iLine, "return " )
	if stmt.expr then
		addLua( exprCode( stmt.expr ) )
	end
end

-- Functions to generate the various stmt types
local fnGenerateStmt = {
	["var"]       = generateVar,
	["call"]      = generateCall,
	["assign"]    = generateAssign,
	["if"]        = generateIf,
	["while"]     = generateWhile,
	["doWhile"]   = generateDoWhile,
	["for"]       = generateFor,
	["forArray"]  = generateForArray,
	["break"]     = generateBreak,
	["return"]    = generateReturn,
}

-- Generate code for the given stmt.
function generateStmt( stmt )
	local fn = fnGenerateStmt[stmt.s]
	if fn then
		return fn( stmt )
	end
	error( "Unknown stmt type %s at line %d", stmt.s, stmt.iLine )
end

-- Generate code for a func structure including its code block.
local function generateFunc( func )
	-- Generate the function header with name and formal parameter list
	beginLuaLine( func.iLine, "function " )
	addLua( fnNameCode( func.nameID.str ) )
	addLua( "(" )
	local params = func.paramVars
	if params then
		for i = 1, #params do
			addLua( params[i].nameID.str )
			if i < #params then
				addLua( ", ")
			end
		end
	end
	addLua( ")" )

	-- Generate the code block
	generateBlockStmts( func.block )
	endBlock( func.block )
end


--- Module Functions ---------------------------------------------------------

-- Return the Lua variable or function name for the given Java name
function codeGenJava.luaName( name )
	return nameFromLuaReservedWord[name] or name
end

-- Generate and return the Lua code string corresponding to the programTree,
function codeGenJava.getLuaCode( programTree )
	-- Init the Lua code state.
	-- Start the Lua program with a blank line to make a cleaner insertion of the
	-- package.path for generated standalone main.lua, then the table initialization
	luaCodeStrs = { "\nlocal ct, this, _fn = require('Code12.ct').getTables()" }
	luaLineNum = 2
	luaLineIsBlank = false
	blockLevel = 0

	-- Generate the instance variables then the member functions
	local vars = programTree.vars
	local funcs = programTree.funcs
	if vars then
		for _, var in ipairs( vars ) do
			generateVar( var )
		end
	end
	if funcs then
		for _, func in ipairs( funcs ) do
			if func.nameID.str ~= "main" then
				generateFunc( func )
			end
		end
	end

	-- Bulk concat and return all the Lua code
	return table.concat( luaCodeStrs )
end


------------------------------------------------------------------------------

return codeGenJava
