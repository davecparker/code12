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


-- The Java parse trees and processing state
local javaParseTrees
local iTree            -- index of next parse tree to process

-- The generated Lua code
local luaCodeStrs = {}   -- array of strings for bulk concat


--- Utility Functions --------------------------------------------------------

-- Add strCode as Lua code
local function addLua( strCode )
	luaCodeStrs[#luaCodeStrs + 1] = strCode
end

-- Add strCode plus a newline as Lua code
local function addLuaLine( strCode )
	if strCode then
		luaCodeStrs[#luaCodeStrs + 1] = strCode
	end
	luaCodeStrs[#luaCodeStrs + 1] = "\n"
end

--- Code Generation Functions ------------------------------------------------

-- Mutually recursive code gen functions
local lValueCode
local fnCallCode
local exprCode


-- Return lua code for an lValue
function lValueCode( lValue )
	p = lValue.p
	if p == "var" then
		return "g." .. lValue.nodes[1].str
	elseif p == "field" then
		return "g." .. lValue.nodes[1].str .. "." .. lValue.nodes[2].str
	elseif p == "index" then
		return lValue.nodes[1].str .. "[" 
				.. exprCode( lValue.nodes[2] ) .. "]"
	end
	error( "Unknown lValue " .. p )
end

-- Return Lua code for a function call in the given parse tree node
function fnCallCode( tree )
	-- e.g. ct.circle( x, y, d )
	local parts = {}
	local fnName = tree.nodes[1].str
	if fnName == "ct.circle" then
		parts[1] = "g.ctCircle("
		local nodes = tree.nodes[2].nodes  -- exprs
		parts[2] = exprCode( nodes[1] )
		parts[3] = ", "
		parts[4] = exprCode( nodes[2] )
		parts[5] = ", "
		parts[6] = exprCode( nodes[3] )
		parts[7] = ")"
	end
	return table.concat( parts )
end

-- Return lua code for an expr
function exprCode( expr )
	local p = expr.p
	if p == "NUM" or p == "STR" or p == "BOOL" then
		return expr.nodes[1].str
	elseif p == "NULL" then
		return "nil"
	elseif p == "+" or p == "-" or p == "*" or p == "/" then
		return exprCode( expr.nodes[1] ) .. " " .. p .. " "
				.. exprCode( expr.nodes[2] )
	elseif p == "lValue" then
		return lValueCode( expr.nodes[1] )
	elseif p == "call" then
		return fnCallCode( expr )
	else
		error( "Unknown expr " .. p )
	end
end


--- Module Functions ---------------------------------------------------------


-- Generate and return the Lua code string corresponding to parseTrees,
-- which is an array of parse trees for each line of Java code.
-- If there is an error, return (nil, lineNum, errorString)
function codeGenJava.getLuaCode( parseTrees )
	-- Set up the Java data
	javaParseTrees = parseTrees
	iTree = 1

	-- Start with code for Lua global state
	addLuaLine( "g = appGlobalState" )

	-- Scan the parse trees in a simple way for now
	while iTree <= #parseTrees do
		local tree = javaParseTrees[iTree]
		local p = tree.p

		if p == "classUser" then
			addLuaLine( [[function g.userCode()]] )
		elseif p == "end" then
			addLuaLine( "end" )
		elseif p == "eventFn" then
			-- Code12 event function (e.g. setup, update)
			addLuaLine( string.format( "function g.%s()", tree.nodes[1].str ) )
		elseif tree.p == "varInit" then
			-- e.g. int x = y + 10;
			addLua( "g." .. tree.nodes[2].str )
			addLua( " = " )
			addLuaLine( exprCode( tree.nodes[3] ) )
		elseif p == "stmt" then
			tree = tree.nodes[1]
			p = tree.p
			if p == "call" then
				addLuaLine( fnCallCode( tree ) )
			elseif p == "assign" then
				addLua( lValueCode( tree.nodes[1] ) )
				addLua( " = ") 
				addLuaLine( exprCode( tree.nodes[2].nodes[1] ) )
			else
				print("*** Unknown " .. p )
			end
		end
		iTree = iTree + 1 
	end

	-- Hack: Delete the "end" at the end of the class and final newline
	-- luaCodeStrs[#luaCodeStrs] = nil
	-- luaCodeStrs[#luaCodeStrs] = nil

	-- Bulk concat and return all the Lua code
	local code = table.concat( luaCodeStrs )
	print("==============")
	print( code )
	return code
end


------------------------------------------------------------------------------

return codeGenJava
