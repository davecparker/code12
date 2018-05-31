-----------------------------------------------------------------------------------------
--
-- checkJava.lua
--
-- Semantic Analysis and Error Checking for Java for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- Code12 modules
local err = require( "err" )


-- The checkJava module
local checkJava = {}


-- A value type (vt) is one of:
--      0            (int)
--      >0           (double)
--      false        (void)
--      true         (boolean)
--      "null"       (any Object type)
--      "String"     (String)
--      "GameObj"    (GameObj)
--      { vt = vt }  (array of vt)

-- The value type (vt) of a varType name
local vtFromVarTypeName = {
	["int"]      = 0,
	["double"]   = 1,
	["void"]     = false,
	["boolean"]  = true,
	["String"]   = "String",
	["GameObj"]  = "GameObj",
}

-- Type analysis tables
local methodTypes = {}       -- map method names to value type
local classVarTypes = {}     -- map instance var name to value type
local localVarTypes = {}     -- map local var name to value type


--- Analysis Functions -------------------------------------------------------

-- Return the value type (vt) for a varType node
local function vtFromVarType( node )
	assert( node.tt ~= nil )     -- varType nodes should always be tokens
	local vt = vtFromVarTypeName[node.str]
	if vt == nil then
		err.setErrNode( node, "Unknown type" )
	end
	return vt
end

-- Return the value type (vt) for a retType node
local function vtFromRetType( node )
	local p = node.p
	if p == "void" then
		return false
	elseif p == "value" then
		return vtFromVarType( node.nodes[1] )
	elseif p == "array" then
		return { vt = vtFromVarType( node.nodes[1] ) }
	else
		error( "Unknown retType pattern " .. p )
	end
end

-- Do expression type analysis for the given parse tree.
-- Set the vt field in each expr node to its value type.
-- If an error is found, set the error state to the first error
-- and return nil, otherwise return the vt type of this node.
local function setExprTypes( tree )
	local nodes = tree.nodes

	-- Determine vt = the value type if this is an expr node
	if tree.t == "expr" then
		local p = tree.p
		local vt
		if p == "NUM" then
			vt = ((nodes[1].str:find("%.") and 1) or 0) 
		elseif p == "BOOL" then
			vt = true
		elseif p == "NULL" then
			vt = "null"
		elseif p == "STR" then
			vt = "String"
		elseif p == "exprParens" then
			vt = setExprTypes( nodes[1] )
		elseif p == "neg" then
			local expr = nodes[1]
			vt = setExprTypes( expr )
			if type(vt) ~= "number" then
				vt = nil
				err.setErrNode( expr, "The negate operator (-) can only apply to numbers" )   -- TODO $$$
			end
		elseif p == "!" then
			local expr = nodes[1]
			vt = setExprTypes( expr )
			if vt ~= true then
				vt = setErr( expr, "The not operator (!) can only apply to boolean values" )
			end
		elseif p == "+" then
			-- May be numeric add or string concat, depending on the operands
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[2] )
			if type(vtLeft) == "number" and type(vtRight) == "number" then
				vt = vtLeft + vtRight   -- int promotes automatically to double :)
			elseif vtLeft == "String" and vtRight == "String" then
				vt = "String"
			elseif vtLeft == "String" or vtRight == "String" then
				-- TODO: Check that other operand can be promoted to string
				vt = "String"
			else
				vt = setErr( nodes[1], "The (+) operator can only apply to numbers or Strings" )
			end
		elseif p == "-" or p == "*" or p == "/" or p == "%" then
			-- Both sides must be numeric, result is number
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[2] )
			if type(vtLeft) == "number" and type(vtRight) == "number" then
				vt = vtLeft + vtRight   -- int promotes automatically to double :)
			else
				local expr = ((type(vtLeft) ~= "number" and nodes[1]) or nodes[2])
				vt = setErr( expr, "Numeric operator (" .. p .. ") can only apply to numbers" )
			end
		elseif p == "&&" or p == "||" then
			-- Both sides must be boolean, result is boolean
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[2] )
			if vtLeft == true and vtRight == true then
				vt = true
			else
				local expr = ((vtLeft ~= true and nodes[1]) or nodes[2])
				vt = setErr( expr, "Logical operator (" .. p .. ") can only apply to boolean values" )
			end
		elseif p == "<" or p == ">" or p == "<=" or p == ">=" then
			-- Both sides must be numeric, result is boolean
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[2] )
			if type(vtLeft) == "number" and type(vtRight) == "number" then
				vt = true
			else
				local expr = ((type(vtLeft) ~= "number" and nodes[1]) or nodes[2])
				vt = setErr( expr, "Comparison operator (" .. p .. ") can only apply to numbers" )
			end
		elseif p == "==" or p == "!=" then
			-- Both sides must have matching-ish type  TODO: Compare in more detail
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[2] )
			if true then -- TODO: type(vtLeft) == type(vtRight) then
				vt = true
			else
				vt = setErr( nodes[2], "Compare operator (" .. p .. ") must compare matching types" )
			end
		elseif p == "call" then
			-- Process parameter expressions
			local exprs = nodes[2].nodes  -- exprList
			for i = 1, #exprs do
				setExprTypes( exprs[i] )
			end
			vt = 1   -- TODO: Need function return type
		elseif p == "lValue" then
			vt = 1   -- TODO: Need variable/field type
		else
			error( "Unknown expr pattern " .. p )
		end

		-- Set the node's type and return it
		tree.vt = vt
	end

	-- Process any children nodes of non-expr nodes
	if nodes then
		for i = 1, #nodes do
			if setExprTypes( nodes[i] ) == nil then
				return nil
			end
		end
	end

	-- Return the top node's type
	return tree.vt
end

-- Find defined methods in parseTrees and put their types in methodTypes.
-- Return true if successful, false if not.
local function getMethodTypes( parseTrees )
	for i = 1, #parseTrees do
		local tree = parseTrees[i]
		assert( tree.t == "line" )
		local p = tree.p
		if p == "eventFn" then
			-- Code12 event func (e.g. setup, update)
			local fnName = tree.nodes[1].str
			methodTypes[fnName] = false   -- void
		elseif p == "func" then
			-- User-defined function
			local retType = tree.nodes[1]
			local fnName = tree.nodes[2].str
			methodTypes[fnName] = vtFromRetType( retType )
		end
		if errRecord then
			return false
		end
	end
	return true
end


--- Module Functions ---------------------------------------------------------

-- Clear then init the local variable state for a new fucntion 
-- with the given paramList
function checkJava.initLocalVars( paramList )
	localVarTypes = {}
	-- TODO
end

-- Init the state for a new program with the given parseTrees
-- Return true if successful, false if not.
function checkJava.initProgram( parseTrees )
	methodTypes = {}
 	classVarTypes = {}
 	localVarTypes = {}
 	err.initProgram()

	-- Get method types first, since vars can forward reference them
	return getMethodTypes( parseTrees )
end

-- Do expression type analysis for the given parseTree.
-- Set the vt field in each expr node to its value type.
-- Return true if successful, false if not.
function checkJava.doTypeAnalysis( parseTree )
	setExprTypes( parseTree )
	return true   -- TODO
end


------------------------------------------------------------------------------

return checkJava
