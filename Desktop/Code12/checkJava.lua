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

-- Map unsupported Java types to the type the user should use instead in Code12
local substituteType = {
	["byte"]  = "int",
	["char"]  = "String",
	["float"]  = "double",
	["long"]  = "int",
	["short"]  = "int",
}

-- Type analysis tables
local methodTypes = {}       -- map method names to value type
local classVarTypes = {}     -- map instance var name to value type
local localVarTypes = {}     -- map local var name to value type


--- Analysis Functions -------------------------------------------------------

-- Return the value type (vt) for a variable type ID node,
-- or return nil and set the error state if the type is invalid.
local function vtFromVarType( node )
	assert( node.tt == "ID" )     -- varType nodes should be IDs
	local vt = vtFromVarTypeName[node.str]
	if vt then 
		return vt  -- known valid type
	end

	-- Invalid type
	if vt == false then
		-- Variables can't be void (void return type is handled in vtFromRetType)
		err.setErrNode( node, "Variables cannot have void type" )
	else
		-- Unknown or unsupported type
		local subType = substituteType[node.str]
		if subType then
			err.setErrNode( node, "The %s type is not supported by Code12. Use %s instead.",
					node.str, subType )
		else
			err.setErrNode( node, "Unknown variable type \"%s\"", node.str )
		end
	end
	return nil
end

-- Return the value type (vt) for a retType node
-- or return nil and set the error state if the type is invalid.
local function vtFromRetType( node )
	local p = node.p
	local vt = nil
	if p == "void" then
		vt = false
	elseif p == "value" then
		vt = vtFromVarType( node.nodes[1] )
	elseif p == "array" then
		vt = vtFromVarType( node.nodes[1] )
		if vt ~= nil then
			vt = { vt = vt }   -- array of specified type
		end
	else
		error( "Unknown retType pattern " .. p )
	end
	return vt
end

-- Do expression type analysis for the given parse tree.
-- Set the vt field in each expr node to its value type.
-- If an error is found, set the error state to the first error
-- and return nil, otherwise return the vt type of this node
-- if node is an expr node, else return false if not an expr node.
local function setExprTypes( tree )
	local nodes = tree.nodes

	-- Determine vt = the value type if this is an expr node
	if tree.t == "expr" then
		local p = tree.p
		local vt
		if p == "NUM" then
			vt = ((nodes[1].str:find("%.") and 1) or 0)   -- double or int
		elseif p == "BOOL" then
			vt = true
		elseif p == "NULL" then
			vt = "null"
		elseif p == "STR" then
			vt = "String"
		elseif p == "exprParens" then
			vt = setExprTypes( nodes[2] )
		elseif p == "neg" then
			local expr = nodes[2]
			vt = setExprTypes( expr )
			if type(vt) ~= "number" then
				err.setErrNodeAndRef( nodes[1], expr, 
						"The negate operator (-) can only apply to numbers" )
				vt = nil
			end
		elseif p == "!" then
			local expr = nodes[2]
			vt = setExprTypes( expr )
			if vt ~= true then
				err.setErrNodeAndRef( nodes[1], expr, 
						"The not operator (!) can only apply to boolean values" )
				vt = nil
			end
		elseif p == "+" then
			-- May be numeric add or string concat, depending on the operands
			assert( nodes[2].tt == "+" )
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[3] )
			if type(vtLeft) == "number" and type(vtRight) == "number" then
				vt = vtLeft + vtRight   -- int promotes automatically to double :)
			elseif vtLeft == "String" and vtRight == "String" then
				vt = "String"
			elseif vtLeft == "String" or vtRight == "String" then
				-- TODO: Check that other operand can be promoted to string
				vt = "String"
			else
				err.setErrNodeAndRef( nodes[2], nodes[1], 
						"The (+) operator can only apply to numbers or Strings" )
				vt = nil
			end
		elseif p == "-" or p == "*" or p == "/" or p == "%" then
			-- Both sides must be numeric, result is number
			assert( nodes[2].str == p )
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[3] )
			if type(vtLeft) == "number" and type(vtRight) == "number" then
				vt = vtLeft + vtRight   -- int promotes automatically to double :)
			else
				local exprErr = ((type(vtLeft) ~= "number" and nodes[1]) or nodes[3])
				err.setErrNodeAndRef( nodes[2], exprErr, 
						"Numeric operator (%s) can only apply to numbers", p )
				vt = nil
			end
		elseif p == "&&" or p == "||" then
			-- Both sides must be boolean, result is boolean
			assert( nodes[2].str == p )
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[3] )
			if vtLeft == true and vtRight == true then
				vt = true
			else
				local exprErr = ((vtLeft ~= true and nodes[1]) or nodes[3])
				err.setErrNodeAndRef( nodes[2], exprErr, 
						"Logical operator (%s) can only apply to boolean values", p )
				vt = nil
			end
		elseif p == "<" or p == ">" or p == "<=" or p == ">=" then
			-- Both sides must be numeric, result is boolean
			assert( nodes[2].str == p )
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[3] )
			if type(vtLeft) == "number" and type(vtRight) == "number" then
				vt = true
			else
				local exprErr = ((type(vtLeft) ~= "number" and nodes[1]) or nodes[3])
				err.setErrNodeAndRef( nodes[2], exprErr, 
						"Comparison operator (%s) can only apply to numbers", p )
				vt = nil
			end
		elseif p == "==" or p == "!=" then
			-- Both sides must have matching-ish type  TODO: Compare in more detail
			assert( nodes[2].str == p )
			local vtLeft = setExprTypes( nodes[1] )
			local vtRight = setExprTypes( nodes[3] )
			if type(vtLeft) == type(vtRight) then
				vt = true
			else
				err.setErrNodeAndRef( nodes[2], nodes[3], 
						"Compare operator (%s) must compare matching types", p )
				vt = nil
			end
		elseif p == "call" then
			-- Process parameter expressions
			local exprs = nodes[3].nodes  -- exprList
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
		return vt
	end

	-- Process any children nodes of non-expr nodes to look for expressions
	-- witin other patterns, such as if (expr)
	if nodes then
		for i = 1, #nodes do
			setExprTypes( nodes[i] )
		end
	end
	return false   -- Not an expr node
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
			local fnName = tree.nodes[3].str
			methodTypes[fnName] = false   -- void
		elseif p == "func" then
			-- User-defined function
			local retType = tree.nodes[1]
			local fnName = tree.nodes[2].str
			methodTypes[fnName] = vtFromRetType( retType )
		end
		if err.hasErr() then
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
	return not err.hasErr()
end


------------------------------------------------------------------------------

return checkJava
