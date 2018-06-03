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


--- Type tables -------------------------------------------------------

-- A value type (vt) is one of:
--      0            (int)
--      1            (double)
--      false        (void)
--      true         (boolean)
--      "null"       (null or Object)
--      "String"     (String)
--      "GameObj"    (GameObj)
--      { vt = vt }  (array of vt)
--      nil          (no type or can't be determined)

-- The type name for a simple value type (vt) not including arrays
local mapVtToTypeName = {
	[0]          = "int",
	[1]          = "double",
	[false]      = "void",
	[true]       = "boolean",
	["null"]     = "Object",
	["String"]   = "String",
	["GameObj"]  = "GameObj",
}

-- The value type (vt) of a declared type name
local mapTypeNameToVt = {
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
local methods = {}      -- map method names to { node = token, vt = vt }
local classVars = {}    -- map instance var name to { node = token, vt = vt }
local localVars = {}    -- map local var name to { node = token, vt = vt }
local vtNodes = {}      -- types of expression nodes determined on a line


--- Misc Analysis Functions --------------------------------------------------

-- Find defined methods in parseTrees and put them in the methods table.
-- Return true if successful, false if an error occured.
local function getMethods( parseTrees )
	for i = 1, #parseTrees do
		local tree = parseTrees[i]
		assert( tree.t == "line" )
		local p = tree.p
		if p == "eventFn" then
			-- Code12 event func (e.g. setup, update)
			local nameNode = tree.nodes[3]
			assert( nameNode.tt == "ID" )
			methods[nameNode.str] = { node = nameNode, vt = false }   -- void
		elseif p == "func" then
			-- User-defined function
			local retType = tree.nodes[1]
			local nameNode = tree.nodes[2]
			local fnName = nameNode.str
			if nameNode.tt ~= "ID" or fnName:find("%.") then 
				err.setErrNode( nameNode, "User-defined function names cannot contain a dot (.)" )
			else
				methods[fnName] = { node = nameNode, vt = checkJava.vtFromRetType( retType ) }
			end
		end
		if err.hasErr() then
			return false
		end
	end
	return true
end

--- Misc Type Functions ------------------------------------------------------

-- Return the type name of the given value type (vt)
local function typeNameFromVt( vt )
	if type(vt) == "table" then
		return "array of " .. typeNameFromVt( vt.vt )
	end
	return mapVtToTypeName[vt] or "(unknown)"
end

-- Return the resulting numeric vt for an operation on vt1 and vt2 (both numeric)
local function vtNumber( vt1, vt2 )
	local vt = vt1 + vt2    -- int promotes to double
	if vt > 1 then
		return 1   -- both were double, too bad we don't have bitwise OR here.
	end
	return vt
end

-- Return the value type (vt) for a variable node.
-- If the variable is undefined, then set the error state and return nil.
local function vtVar( varNode )
	assert( varNode.tt == "ID" )
	local varName = varNode.str
	local varFound = localVars[varName] or classVars[varName]
	if varFound == nil then
		err.setErrNode( varNode,  "Undefined variable %s", varName )
		return nil
	end
	return varFound.vt
end

-- Return the value type (vt) for an lValue node.
-- If there is an undefined type, then set the error state and return nil.
local function vtLValueNode( lValue )
	assert( lValue.t == "lValue" )
	local p = lValue.p
	local nodes = lValue.nodes
	if p == "var" then
		return vtVar( nodes[1] )
	elseif p == "index" then
		-- indexing an array
		local indexExpr = nodes[3]
		local vtIndex = checkJava.vtCheckExpr( indexExpr )
		if vtIndex ~= 0 then
			err.setErrNode( indexExpr, "Array index must be an integer value" )
			return nil
		end
		vt = vtVar( nodes[1] )
		if type(vt) ~= "table" then
			err.setErrNodeAndRef( nodes[2], nodes[1], 
					"An index in [brackets] can only be applied to an array" )
			return nil
		end
		return vt.vt
	elseif p == "this" then
		-- explicit reference to class variable
		local varNode = nodes[3]
		if classVars[varNode.str] == nil then
			err.setErrNodeAndRef( varNode, nodes[1],
					"Undefined class variable %s referenced with \"this\"", varNode.str )
			return nil
		end
		return vtVar( varNode )
	elseif p == "field" then
		return 1   -- TODO: check known field types
	end
	error( "Unknown lValue pattern " .. p )
	return nil
end


--- Type Analysis of expressions  --------------------------------------------

-- Forward decl for mutual recursion
local vtExprNode

-- The following local functions are all hashed into from the fnVtExprPatterns
-- table below. They all return the vt of a particular pattern of an expr node
-- (primaryExpr or expr with binary op) given the children nodes array.
-- If there is an error, they set the error state and return nil.

-- primaryExpr pattern: NUM
local function vtExprNUM( nodes )
	return ((nodes[1].str:find("%.") and 1) or 0)   -- double or int
end

-- primaryExpr pattern: BOOL
local function vtExprBOOL( nodes )
	return true
end

-- primaryExpr pattern: NULL
local function vtExprNULL( nodes )
	return "null"
end

-- primaryExpr pattern: STR
local function vtExprSTR( nodes )
	return "String"
end

-- primaryExpr pattern: exprParens
local function vtExprExprParens( nodes )
	return vtExprNode( nodes[2] )
end

-- primaryExpr pattern: neg
local function vtExprNeg( nodes )
	local expr = nodes[2]
	local vt = vtExprNode( expr )
	if type(vt) ~= "number" then
		err.setErrNodeAndRef( nodes[1], expr, 
				"The negate operator (-) can only apply to numbers" )
		return nil
	end
	return vt
end

-- primaryExpr pattern: !
local function vtExprNot( nodes )
	local expr = nodes[2]
	local vt = vtExprNode( expr )
	if vt ~= true then
		err.setErrNodeAndRef( nodes[1], expr, 
				"The not operator (!) can only apply to boolean values" )
		return nil
	end
	return vt
end

-- primaryExpr pattern: call
local function vtExprCall( nodes )
	local fnValue = nodes[1]
	if fnValue.tt == "ID" then
		local fnName = fnValue.str
		local vt = "GameObj"  -- TODO: get from API table
		if vt == nil then
			local method = methods[fnName]
			if method then
				vt = method.vt
				if vt == nil then
					err.setErrNode( fnValue, "Undefined function %s", fnName )
				end
			end
		end
		return vt
	else
		-- TODO: Check method
		return "String"
	end
end

-- primaryExpr pattern: lValue
local function vtExprLValue( nodes )
	return vtLValueNode( nodes[1] )
end

-- expr pattern: +
local function vtExprPlus( nodes )
	-- May be numeric add or string concat, depending on the operands
	assert( nodes[2].tt == "+" )
	local vtLeft = vtExprNode( nodes[1] )
	local vtRight = vtExprNode( nodes[3] )
	if type(vtLeft) == "number" and type(vtRight) == "number" then
		return vtNumber( vtLeft, vtRight )
	elseif vtLeft == "String" and vtRight == "String" then
		return "String"
	elseif vtLeft == "String" or vtRight == "String" then
		-- Check if the other operand can be promoted to string (numbers only)
		local exprOther, vtOther
		if vtLeft == "String" then
			exprOther = nodes[3]
			vtOther = vtRight
		else
			exprOther = nodes[1]
			vtOther = vtLeft
		end
		if type(vtOther) == "number" then
			return "String"   -- the number will promote to a string 
		elseif vtOther == "GameObj" then
			err.setErrNodeAndRef( nodes[2], exprOther, 
					"The (+) operator cannot be used on GameObj objects directly. Use the toString() method." )
		else
			err.setErrNodeAndRef( nodes[2], exprOther, 
					"The (+) operator can only apply to numbers or Strings" )
		end
	else
		-- Neither side is valid
		err.setErrNodeAndRef( nodes[2], nodes[1], 
				"The (+) operator can only apply to numbers or Strings" )
	end
	return nil
end

-- expr patterns: -, *, /, %
local function vtExprNumeric( nodes )
	-- Both sides must be numeric, result is number
	-- TODO: Check divide in more detail
	local vtLeft =  vtExprNode( nodes[1] )
	local vtRight = vtExprNode( nodes[3] )
	if type(vtLeft) == "number" and type(vtRight) == "number" then
		return vtNumber( vtLeft, vtRight )
	end
	local exprErr = ((type(vtLeft) ~= "number" and nodes[1]) or nodes[3])
	err.setErrNodeAndRef( nodes[2], exprErr, 
			"Numeric operator (%s) can only apply to numbers", nodes[2].str )
	return nil
end

-- expr patterns: &&, ||
local function vtExprLogical( nodes )
	-- Both sides must be boolean, result is boolean
	local vtLeft = vtExprNode( nodes[1] )
	local vtRight = vtExprNode( nodes[3] )
	if vtLeft == true and vtRight == true then
		return true
	end
	local exprErr = ((vtLeft ~= true and nodes[1]) or nodes[3])
	err.setErrNodeAndRef( nodes[2], exprErr, 
			"Logical operator (%s) can only apply to boolean values", nodes[2].str )
	return nil
end

-- expr patterns: <, >, <=, >=
local function vtExprInequality( nodes )
	-- Both sides must be numeric, result is boolean
	local vtLeft = vtExprNode( nodes[1] )
	local vtRight = vtExprNode( nodes[3] )
	if type(vtLeft) == "number" and type(vtRight) == "number" then
		return true
	end
	local exprErr = ((type(vtLeft) ~= "number" and nodes[1]) or nodes[3])
	err.setErrNodeAndRef( nodes[2], exprErr, 
			"Comparison operator (%s) can only apply to numbers", nodes[2].str )
	return nil
end

-- expr patterns: ==, !=
local function vtExprEquality( nodes )
	-- Both sides must have matching-ish type  TODO: Compare in more detail
	local vtLeft = vtExprNode( nodes[1] )
	local vtRight = vtExprNode( nodes[3] )
	if type(vtLeft) == type(vtRight) then
		return true
	end
	err.setErrNodeAndRef( nodes[3], nodes[1], 
			"Compare operator (%s) must compare matching types", nodes[2].str )
	return nil
end

-- Since there are so many primaryExpr and expr patterns, we hash them to functions
local fnVtExprPatterns = {
	-- primaryExpr patterns
	["NUM"]         = vtExprNUM,
	["BOOL"]        = vtExprBOOL,
	["NULL"]        = vtExprNULL,
	["STR"]         = vtExprSTR,
	["exprParens"]  = vtExprExprParens,
	["neg"]         = vtExprNeg,
	["!"]           = vtExprNot,
	["call"]        = vtExprCall,
	["lValue"]      = vtExprLValue,
	-- binary operators
	["+"]           = vtExprPlus,
	["-"]           = vtExprNumeric,
	["*"]           = vtExprNumeric,
	["/"]           = vtExprNumeric,
	["%"]           = vtExprNumeric,
	["&&"]          = vtExprLogical,
	["||"]          = vtExprLogical,
	["<"]           = vtExprInequality,
	[">"]           = vtExprInequality,
	["<="]          = vtExprInequality,
	[">="]          = vtExprInequality,
	["=="]          = vtExprEquality,
	["!="]          = vtExprEquality,
}

-- Return the value type (vt) for an expr, primaryExpr, or lValue node.
-- Also remember the node's type in vtNodes for possible later calls 
-- to checkJava.vtKnownExpr().
-- If an error is found, set the error state and return nil.
function vtExprNode( node )
	local vt = nil
	if node.t == "lValue" then
		vt = vtLValueNode( node )
	else
		assert( node.t == "expr" )
		-- Look up and call the correct vt function above
		local fnVt = fnVtExprPatterns[node.p]
		if fnVt == nil then
			error( "vtExprNode: Unknown expr pattern " .. p )
		end
		vt = fnVt( node.nodes )
	end
	-- Remember and return the result
	vtNodes[node] = vt       
	return vt
end


--- Module Functions ---------------------------------------------------------

-- Check and return the value type (vt) for an expr, primaryExpr, or lValue node.
-- If an error is found, set the error state and return nil.
function checkJava.vtCheckExpr( node )
	return vtExprNode( node )
end

-- Return the type of an expression that has already been checked and determined
-- on the current line, or nil if unknown.
function checkJava.vtKnownExpr( node )
	return vtNodes[node]
end

-- Return the value type (vt) for a variable type ID node,
-- or return nil and set the error state if the type is invalid.
function checkJava.vtFromVarType( node )
	assert( node.tt == "ID" )     -- varType nodes should be IDs
	local vt = mapTypeNameToVt[node.str]
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
function checkJava.vtFromRetType( retType )
	if retType.p == "void" then
		return false
	end
	local vt = checkJava.vtFromVarType( retType.nodes[1] )
	if p == "array" and vt ~= nil then
		vt = { vt = vt }   -- array of specified type
	end
	return vt  -- normal or unknown type
end

-- Return (vt, name) for a param node
-- or return nil and set the error state if the type is invalid.
function checkJava.vtAndNameFromParam( param )
	assert( param.t == "param" )
	local vt = checkJava.vtFromVarType( param.nodes[1] )
	if param.p == "array" then
		if vt == nil then
			return nil
		end
		return { vt = vt }, param.nodes[4].str
	end
	return vt, param.nodes[2].str
end

-- Return the vt type of the given class variable name or nil if not defined.
function checkJava.vtClassVar( varName )
	local classVar = classVars[varName]
	if classVar then
		return classVar.vt
	end
	return nil
end

-- Define the class variable with the given nameNode and type (vt, isArray).
-- Return true if successful, false if error.
function checkJava.defineClassVar( nameNode, vt, isArray )
	if vt == nil then
		return false
	end
	if isArray then
		vt = { vt = vt }   -- make vt into array of specified type
	end
	-- Check for existing definition
	local varName = nameNode.str
	local varFound = classVars[varName]
	if varFound ~= nil then
		err.setErrNodeAndRef( nameNode, varFound.node, 
				"Variable %s was already defined", varName )
		return false
	end
	-- Define it
	classVars[varName] = { node = nameNode, vt = vt }
	return true
end

-- Return the vt type of the given local variable name or nil if not defined.
function checkJava.vtLocalVar( varName )
	local localVar = localVars[varName]
	if localVar then
		return localVar.vt
	end
	return nil
end

-- Define the local variable with the given nameNode and type (vt, isArray).
-- Return true if successful, false if error.
function checkJava.defineLocalVar( nameNode, vt, isArray )
	if vt == nil then
		return false
	end
	if isArray then
		vt = { vt = vt }   -- make vt into array of specified type
	end
	-- Check for existing definition
	local varName = nameNode.str
	local varFound = localVars[varName] or classVars[varName]
	if varFound ~= nil then
		err.setErrNodeAndRef( nameNode, varFound.node, 
				"Variable %s was already defined", varName )
		return false
	end
	-- Define it
	localVars[varName] = { node = nameNode, vt = vt }
	return true
end

-- Clear then init the local variable state for a new function with the paramList
function checkJava.initLocalVars( paramList )
	localVars = {}
	for i = 1, #paramList do
		local param = paramList[i]
		local vt = checkJava.vtFromVarType( param.nodes[1] )
		if param.p == "array" then
			checkJava.defineLocalVar( param.nodes[4], vt, true )
		else
			checkJava.defineLocalVar( param.nodes[2], vt, false )
		end
	end
end

-- Do type checking on expr and then return true if the expr can be assigned to 
-- the given vt (value type) at node.
-- If the types are not compatible then set the error state and return false.
function checkJava.canAssignToVt( node, vt, expr )
	local vtExpr = vtExprNode( expr )
	if vt == nil or vtExpr == nil then
		return false
	elseif vt == vtExpr then
		return true  -- same types so directly compatible
	elseif vtExpr == 0 and type(vt) == "number" then
		return true    -- int can silently promote to double
	elseif vtExpr == "null" and type(vt) == "string" then
		return true    -- null can be assigned to any object (String or GameObj)
	end

	-- Check for various type mismatch combinations
	local str
	if vtExpr == 1 and vt == 0 then          -- double assigned to int
		str = "Value of type double cannot be assigned to an int, use ct.round() or ct.toInt()"
	elseif vtExpr == 1 and vt == "String" then   -- double assigned to String
		str = "Value of type double cannot be assigned to a String, consider using ct.formatDecimal()"
	elseif vtExpr == 0 and vt == "String" then   -- int assigned to String
		str = "Integer value cannot be assigned to a String, consider using ct.formatInt()"
	elseif vtExpr == "String" and vt == 1 then   -- String assigned to double
		str = "A String cannot be assigned to a double, consider using ct.parseNumber()"
	elseif vtExpr == "String" and vt == 0 then   -- String assigned to int
		str = "A String cannot be assigned to an int, consider using ct.parseInt()"
	elseif vtExpr == "GameObj" and vt == "String" then
		str = "A GameObj cannot be assigned to a String, consider using the toString() method"
	else
		str = string.format( "Value of type %s cannot be assigned to type %s",
					typeNameFromVt( vtExpr ), typeNameFromVt( vt ) )
	end
	err.setErrNodeAndRef( node, expr, str )
	return false
end	

-- Return true if the expr can be assigned to the lValue node.
-- The expr must already have had type analysis done on it and have a vt field.
-- If the types are not compatible then set the error state and return false.
function checkJava.canAssignToLValue( lValue, expr )
	return checkJava.canAssignToVt( lValue, vtLValueNode( lValue ), expr )
end

-- Init the state for a new line in the program
function checkJava.initLine()
	-- We only need to store the known expression types on the current line
	vtNodes = {}
end

-- Init the state for a new program with the given parseTrees
-- Return true if successful, false if not.
function checkJava.initProgram( parseTrees )
	methods = {}
 	classVars = {}
 	localVars = {}
 	vtNodes = {}
 	err.initProgram()

	-- Get method types first, since vars can forward reference them
	return getMethods( parseTrees )
end


------------------------------------------------------------------------------

return checkJava
