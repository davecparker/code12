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
local javaTypes = require( "javaTypes" )
local apiTables = require( "apiTables" )   -- note: generated by the "Make API" tool


-- The checkJava module
local checkJava = {}


-- Tables of user-defined variables and methods. These map a name to a table containing 
-- where the name was defined (node), its value type (vt), and the params if a method. 
-- There are also entries of type string that map a lowercase version of the name to the
-- name with the correct case. So the entries are one of:
--     Variables:
--         { node = token, vt = vt, assigned = false }   -- assigned set when assigned
--     Methods:
--         { node = token, vt = vt, params = {} }   
--                    -- params is an array of { name = name, vt = vtParam }
--     Either:
--         strCorrectCase    -- string name with correct case
local variables = {}
local userMethods = {}

-- Table that maps a name to true if it is an instance variable (not a local variable)
local isInstanceVar = {} 

-- Stack of local variable names, with an empty name "" marking the beginning of each block
local localNameStack = {}


--- Misc Analysis Functions --------------------------------------------------

-- Find user-defined methods in parseTrees and put them in the userMethods table.
-- Return true if successful, false if an error occured.
local function getMethods( parseTrees )
	for i = 1, #parseTrees do
		local tree = parseTrees[i]
		assert( tree.t == "line" )
		local p = tree.p
		local nodes = tree.nodes
		if p == "eventFn" then
			-- Code12 event func (e.g. setup, update)
			-- TODO: Check that the API signature is what is needed for this event
		elseif p == "func" then
			-- User-defined function
			local nameNode = nodes[3]
			local fnName = nameNode.str
			if nameNode.tt ~= "ID" or fnName:find("%.") then 
				err.setErrNode( nameNode, "User-defined function names cannot contain a dot (.)" )
			else
				-- Build the parameter table
				local paramTable = {}
				local params = nodes[5].nodes
				for i = 1, #params do
					local param = params[i]
					local vtParam, name = javaTypes.vtAndNameFromParam( param )
					paramTable[#paramTable + 1] = { name = name, vt = vtParam }
				end
				-- Add entry to userMethods table
				userMethods[fnName] = { 
					node = nameNode,
					vt = javaTypes.vtFromRetType( nodes[2] ), 
					params = paramTable
				}
				-- Add lowercase version if different
				local nameLower = string.lower( fnName )
				if nameLower ~= fnName then
					userMethods[nameLower] = fnName
				end
			end
		end
		if err.hasErr() then
			return false
		end
	end
	return true
end

-- Look up the name of nameToken in the nameTable (variables, userMethods, or API tables).
-- If the name is found and the entry is a record (table) then return the record.
-- If an entry has an index (name) differing only in case, then set the error state 
-- to a description of the error and return (nil, entryCorrectCase, strCorrectCase). 
-- If the name is not found at all then return nil.
local function lookupID( nameToken, nameTable )
	assert( nameToken.tt == "ID" )
	local name = nameToken.str

	-- Try the name as-is
	local result = nameTable[name]
	if type(result) == "table" then
		return result  -- found it spelled correctly
	end

	-- Try the name in all lower-case
	local nameLower = string.lower( name )
	local strCorrectCase = nil
	result = nameTable[nameLower]
	if type(result) == "table" then
		strCorrectCase = nameLower   -- name is supposed to be all lowercase
	elseif type(result) == "string" then
		strCorrectCase = result      -- result gives the correct case
		result = nameTable[strCorrectCase]
		assert( type(result) == "table" )
	end

	-- Found but wrong case?
	if strCorrectCase then
		err.setErrNode( nameToken, 
				"Names are case-sensitive, known name is \"%s\"", strCorrectCase )
		return nil, result, strCorrectCase
	end
	return nil
end


--- Misc Type Functions ------------------------------------------------------

-- Return the resulting numeric vt for an operation on vt1 and vt2 (both numeric)
local function vtNumber( vt1, vt2 )
	local vt = vt1 + vt2    -- int promotes to double
	if vt > 1 then
		return 1   -- both were double, too bad we don't have bitwise OR here.
	end
	return vt
end

-- Return the variable name of a variable token or lValue node, or nil if none.
local function varNameFromNode( node )
	if node.tt == "ID" then
		return node.str
	elseif node.t == "lValue" then
		if node.p == "var" then
			return node.nodes[1].str
		elseif node.p == "this" then
			return node.nodes[3].str
		end
	end
	return nil
end

-- Return the value type (vt) for an lValue node.
-- If there is an error, then set the error state and return nil.
local function vtLValueNode( lValue )
	assert( lValue.t == "lValue" )
	local p = lValue.p
	local nodes = lValue.nodes
	if p == "var" then
		return checkJava.vtVar( nodes[1] )
	elseif p == "index" then
		-- indexing an array
		local indexExpr = nodes[3]
		local vtIndex = indexExpr.info.vt
		if vtIndex ~= 0 then
			err.setErrNode( indexExpr, "Array index must be an integer value" )
			return nil
		end
		vt = checkJava.vtVar( nodes[1] )
		if type(vt) ~= "table" then
			err.setErrNodeAndRef( nodes[2], nodes[1], 
					"An index in [brackets] can only be applied to an array" )
			return nil
		end
		return vt.vt   -- element type of the array
	elseif p == "this" then
		-- explicit reference to class variable
		local varNode = nodes[3]
		local vt = checkJava.vtVar( varNode )
		if vt ~= nil and not isInstanceVar[varNode.str] then
			err.setErrNodeAndRef( varNode, nodes[1],
					"Variable %s referenced with \"this\" is not a class or instance variable", 
					varNode.str )
			return nil
		end
		return vt
	elseif p == "field" then
		-- Public field access (only possible with Math or GameObj, or array.length)
		local object = nodes[1]
		local field = nodes[3]
		-- Determine the class
		local className
		assert( object.tt == "ID" )
		local objName = object.str
		if objName == "Math" then   -- Math has all static members
			className = "Math"
		else
			-- object should be an instance
			local vtObj = checkJava.vtVar( object )
			if vtObj == "GameObj" then
				className = "GameObj"
			elseif type(vtObj) == "table" then
				-- Support array.length
				if field.str == "length" then
					return 0  -- int
				else
					err.setErrNodeAndRef( field, object,
						"Arrays can only access their \".length\" field" )
					return nil
				end
			else
				err.setErrNode( object, "Type %s has no data fields",
						javaTypes.typeNameFromVt( vtObj ))
				return nil
			end
		end
		local class = apiTables[className]

		-- Look up the field
		assert( field.tt == "ID" )
		local fieldFound = lookupID( field, class.fields )
		if fieldFound == nil then
			err.setErrNodeAndRef( field, object, 
					"Unknown field \"%s\" for class %s",
					field.str, className )
			return nil
		end
		return fieldFound.vt
	end
	error( "Unknown lValue pattern " .. p )
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
	return nodes[2].info.vt
end

-- primaryExpr pattern: neg
local function vtExprNeg( nodes )
	local expr = nodes[2]
	local vt = expr.info.vt
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
	local vt = expr.info.vt
	if vt ~= true then
		err.setErrNodeAndRef( nodes[1], expr, 
				"The not operator (!) can only apply to boolean values" )
		return nil
	end
	return vt
end

-- primaryExpr pattern: call
local function vtExprCall( nodes )
	return checkJava.vtCheckCall( nodes[1], nodes[3] )
end

-- primaryExpr pattern: lValue
local function vtExprLValue( nodes )
	return vtLValueNode( nodes[1] )
end

-- primaryExpr pattern: newArray
local function vtExprNewArray( nodes )
	local countExpr = nodes[4]
	if countExpr.info.vt ~= 0 then
		err.setErrNode( countExpr, "Array count must be an integer" )
		return nil
	end
	local vt = javaTypes.vtFromVarType( nodes[2] )
	return { vt = vt }  -- array of specified type
end

-- expr pattern: +
local function vtExprPlus( nodes )
	-- May be numeric add or string concat, depending on the operands
	assert( nodes[2].tt == "+" )
	local vtLeft = nodes[1].info.vt
	local vtRight = nodes[3].info.vt
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
		-- Find the side that is wrong
		local exprOther
		if vtLeft == "String" or type(vtLeft) == "number" then
			exprOther = nodes[3]
		else
			exprOther = nodes[1]
		end
		err.setErrNodeAndRef( nodes[2], exprOther, 
				"The (+) operator can only apply to numbers or Strings" )
	end
	return nil
end

-- expr patterns: -, *, /, %
local function vtExprNumeric( nodes )
	-- Both sides must be numeric, result is number
	local vtLeft = nodes[1].info.vt
	local vtRight = nodes[3].info.vt
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
	local vtLeft = nodes[1].info.vt
	local vtRight = nodes[3].info.vt
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
	local vtLeft = nodes[1].info.vt
	local vtRight = nodes[3].info.vt
	if type(vtLeft) == "number" and type(vtRight) == "number" then
		return true
	end
	local exprErr = ((type(vtLeft) ~= "number" and nodes[1]) or nodes[3])
	err.setErrNodeAndRef( nodes[2], exprErr, 
			"Inequality operator (%s) can only apply to numbers", nodes[2].str )
	return nil
end

-- expr patterns: ==, !=
local function vtExprEquality( nodes )
	local vtLeft = nodes[1].info.vt
	local vtRight = nodes[3].info.vt
	if javaTypes.canCompareVts( vtLeft, vtRight ) then
		return true
	end
	err.setErrNodeAndRef( nodes[1], nodes[3], "Cannot compare %s to %s", 
		javaTypes.typeNameFromVt( vtLeft ), javaTypes.typeNameFromVt( vtRight ) )
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
	["newArray"]	= vtExprNewArray,
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
-- Also store the vt into node.info.vt for future use.
-- If an error is found, set the error state and return nil.
function vtSetExprNode( node )
	local vt = nil
	if node.t == "lValue" then
		vt = vtLValueNode( node )
	else
		assert( node.t == "expr" )
		-- Look up and call the correct vt function above
		local fnVt = fnVtExprPatterns[node.p]
		if fnVt == nil then
			err.setErrNode( node, "Unsupported operator" )  -- TODO: improve
			return nil
		end
		vt = fnVt( node.nodes )
	end
	-- Store and return the result
	node.info.vt = vt       
	return vt
end


--- Post Check Analysis Functions  -------------------------------------------

-- If the integer divide in expr might have a remainder, then set
-- the error state and return true, otherwise return false.
local function isBadIntDivide( expr )
	assert( expr.p == "/" )
	assert( expr.info.vt == 0 )
	local nodes = expr.nodes
	local left = nodes[1]
	local right = nodes[3]

	if left.p == "NUM" and right.p == "NUM" then
		-- Both sides are constant so we can check for a remainder
		local n = tonumber( left.nodes[1].str )
		local d = tonumber( right.nodes[1].str )
		local r = n / d
		if r == math.floor( r ) then
			return false   -- no remainder, so OK as-is
		else
			err.setErrNode( expr, "Integer divide has remainder. Use double or ct.intDiv()" )
			return true
		end
	end
	-- The remainder can't be determined, but Code12 doesn't allow this
	-- because chances are the programmer made a mistake.
	err.setErrNode( expr, "Integer divide may lose remainder. Use double or ct.intDiv()" )
	return true
end


--- Module Functions ---------------------------------------------------------

-- Return true if the given variable name is a defined instance variable.
function checkJava.isInstanceVarName( varName )
	return isInstanceVar[varName]
end

-- Return the value type (vt) for a variable name token node.
-- If the variable is undefined then set the error state and return nil.
-- Unless unassignedOK is passed and true then also check to make sure the
-- variable has been assigned and if not then set the error state and return nil. 
function checkJava.vtVar( varNode, unassignedOK )
	assert( varNode.tt == "ID" )
	local varFound = lookupID( varNode, variables )
	if varFound == nil then
		err.setErrNode( varNode,  "Undefined variable %s", varNode.str )
		return nil
	end
	if unassignedOK ~= true then
		if not varFound.assigned then
			err.setErrNode( varNode,  
				"Variable %s must be assigned before it is used", varNode.str )
			--error("Stop")
			return nil
		end
	end
	return varFound.vt
end

-- Define the variable with the given nameNode and type (vt, isArray).
-- If assigned (default false) then mark it as assigned.
-- Return true if successful, false if error.
function checkJava.defineVar( nameNode, vt, isArray, assigned )
	if vt == nil or err.hasErr() then
		return false
	end
	if isArray then
		vt = { vt = vt }   -- make vt into array of specified type
	end

	-- Check for invalid name
	local varName = nameNode.str
	if varName == "ct" or varName == "_fn" then
		err.setErrNode( nameNode, 
				"The name \"%s\" is reserved for use by the system", varName )
		return false
	end

	-- Check for existing definition
	local varFound, varCorrectCase, nameCorrectCase = lookupID( nameNode, variables )
	if varFound then
		err.setErrNodeAndRef( nameNode, varFound.node, 
				"Variable %s was already defined", varName )
		return false
	elseif varCorrectCase then
		err.clearErr()
		err.setErrNodeAndRef( nameNode, varCorrectCase.node, 
				"Variable %s differs only by upper/lower case from existing variable %s", 
				varName, nameCorrectCase )
		return false
	end

	-- Define it and the case-insensitive lower-case version as well if necessary
	variables[varName] = { node = nameNode, vt = vt, assigned = assigned }
	local varNameLower = string.lower( varName )
	if varNameLower ~= varName then
		variables[varNameLower] = varName
	end
	return true
end

-- Define an instance variable with the given nameNode and type (vt, isArray).
-- If assigned (default false) then mark it as assigned.
-- Return true if successful, false if error.
function checkJava.defineInstanceVar( nameNode, vt, isArray, assigned )
	if not checkJava.defineVar( nameNode, vt, isArray, assigned ) then
		return false
	end
	isInstanceVar[nameNode.str] = true
	return true
end

-- Define a local variable with the given nameNode and type (vt, isArray).
-- If assigned (default false) then mark it as assigned.
-- Return true if successful, false if error.
function checkJava.defineLocalVar( nameNode, vt, isArray, assigned )
	if not checkJava.defineVar( nameNode, vt, isArray, assigned ) then
		return false
	end
	localNameStack[#localNameStack + 1] = nameNode.str    -- push on locals stack
	return true
end

-- Begin a new local variable block, then if paramList then define the params.
function checkJava.beginLocalBlock( paramList )
	localNameStack[#localNameStack + 1] = ""   -- push special sentinel marking block start
	if paramList then
		for i = 1, #paramList do
			local param = paramList[i]
			local vt = javaTypes.vtFromVarType( param.nodes[1] )
			if param.p == "array" then
				checkJava.defineLocalVar( param.nodes[4], vt, true, true )
			else
				checkJava.defineLocalVar( param.nodes[2], vt, false, true )
			end
		end
	end
end

-- End a local variable block, discarding any definitions in the top block
function checkJava.endLocalBlock()
	local iTop = #localNameStack
	while iTop > 0 do
		-- Pop a name off the localNameStack
		local varName = localNameStack[iTop]
		localNameStack[iTop] = nil
		iTop = iTop - 1

		-- Is this the end of block sentinel? 
		if varName == "" then
			break
		end

		-- Remove the definition of this variable and lowercase version too
		variables[varName] = nil
		variables[string.lower( varName )] = nil
	end
end

-- Return true if the expr can be assigned to the given vt (value type) at node.
-- If the types are not compatible then set the error state and return false.
function checkJava.canAssignToVt( node, vt, expr )
	local vtExpr = expr.info.vt
	if javaTypes.vtCanAcceptVtExpr( vt, vtExpr ) then
		return true
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
					javaTypes.typeNameFromVt( vtExpr ), javaTypes.typeNameFromVt( vt ) )
	end
	err.setErrNodeAndRef( node, expr, str )
	return false
end	

-- Return true if the expr can be assigned to the variable node.
-- If the types are not compatible then set the error state and return false.
-- Otherwise mark the variable as assigned and return true.
function checkJava.canAssignToVarNode( varNode, expr )
	local vt = checkJava.vtVar( varNode, true )
	if not checkJava.canAssignToVt( varNode, vt, expr ) then
		return false
	end
	local varRecord = variables[varNode.str]
	if type(varRecord) == "table" then
		varRecord.assigned = true
	end
	return true
end

-- Return true if the expr can be assigned to the lValue node.
-- If the types are not compatible then set the error state and return false.
function checkJava.canAssignToLValue( lValue, expr )
	return checkJava.canAssignToVt( lValue, vtLValueNode( lValue ), expr )
end

-- Find a known ct API or user function with the given fnValue node.
-- Return the entry in the API or userMethods table if found.
-- If not found then set the error state and return nil.
local function findGlobalFunction( fnValue )
	assert( fnValue.tt == "ID" )
	local method = lookupID( fnValue, apiTables["ct"].methods )
	if method == nil then
		method = lookupID( fnValue, userMethods )
	end
	if method == nil then
		err.setErrNode( fnValue, "Undefined function %s", fnValue.str )
		return nil
	end
	return method
end

-- Find a known API method for the given non-ID fnValue node.
-- Return the method entry in the API tables if found.
-- If not found then set the error state and return nil.
local function findAPIMethod( fnValue )
	assert( fnValue.t == "fnValue" )
	local object = fnValue.nodes[1]
	local fnNode = fnValue.nodes[2]
	local fnName = fnNode.str

	-- Determine the class
	local className
	assert( object.tt == "ID" )
	local objName = object.str
	if objName == "Math" then   -- Math has all static methods
		className = "Math"
	else
		local vtObj = checkJava.vtVar( object )
		if vtObj == "String" or vtObj == "GameObj" then
			className = vtObj
		else
			err.setErrNode( object, "Method call on invalid type (%s)",
					javaTypes.typeNameFromVt( vtObj ))
			return nil
		end
	end
	local class = apiTables[className]

	-- Look up the method
	method = lookupID( fnNode, class.methods )
	if method == nil then
		err.setErrNodeAndRef( fnNode, object, 
				"Unknown method \"%s\" for class %s",
				fnName, className )
		return nil
	end
	return method
end

-- Do type checking on a function or method call with the given fnValue and 
-- paramList nodes If there is an error then set the error state and return nil.
-- Return the return type vt if successful.
function checkJava.vtCheckCall( fnValue, paramList )
	-- Find the method
	local fnName
	local method
	if fnValue.tt == "ID" then
		-- A global API or user-defined method call
		fnName = fnValue.str
		method = findGlobalFunction( fnValue )
	else
		-- A method call
		assert( fnValue.t == "fnValue" )
		fnName = fnValue.nodes[2].str
		method = findAPIMethod( fnValue )
	end
	if method == nil then
		return nil
	end

	-- Check parameter count
	local params = paramList.nodes
	local min = method.min or #method.params
	if #params < min then
		if #params == 0 then
			err.setErrNode( fnValue, 
					"Function %s requires %d parameter%s", 
					fnName, min, (min ~= 1 and "s") or "" )
		else
			err.setErrNodeAndRef( paramList, fnValue, 
					"Not enough parameters passed to %s (requires %d)", 
					fnName, min )
		end
		return nil
	elseif not method.variadic and #params > #method.params then
		err.setErrNodeAndRef( paramList, fnValue, 
				"Too many parameters passed to %s", fnName )
		return nil
	end

	-- Check parameter types for validity and match with the API
	-- TODO: Handle overloaded Math methods
	for i = 1, #params do
		if i > #method.params then
			assert( method.variadic )
			break    -- variadic function can take any types after those specified
		end
		local expr = params[i]
		local vtPassed = expr.info.vt
		local vtNeeded = method.params[i].vt
		if not javaTypes.vtCanAcceptVtExpr( vtNeeded, vtPassed ) then
			err.setErrNode( expr, "Parameter %d of %s expects type %s, but %s was passed",
					i, fnName, javaTypes.typeNameFromVt( vtNeeded ), 
					javaTypes.typeNameFromVt( vtPassed ))
			return nil
		end
	end

	-- Result is the method's return type
	return method.vt 
end

-- Recursively run type analysis on the given parse tree.
-- Set the info.vt field on all expr and lValue nodes.
-- If there is an error, then set the error state and return false,
-- otherwise return true if there were no errors.
function checkJava.doTypeChecks( tree )
	-- Check children recursively first
	local nodes = tree.nodes
	if nodes then
		for i = 1, #nodes do
			local node = nodes[i]
			if node.t then  -- don't recurse down into tokens
				if not checkJava.doTypeChecks( node ) then
					return false
				end
			end
		end
	end

	-- Check this node
	local t = tree.t
	if t == "expr" or t == "lValue" then
		local vt = vtSetExprNode( tree )

		-- Do additional post checks after we know the type of this node
		-- and all types underneath it.
		if vt == 0 and tree.p == "/" and isBadIntDivide( tree ) then
			return false   -- invalid int divide 
		end
	end
	return true
end

-- Init the state for a new program with the given parseTrees
-- Return true if successful, false if not.
function checkJava.initProgram( parseTrees )
	variables = {}
	userMethods = {}
 	isInstanceVar = {}
 	localNameStack = {}

 	err.initProgram()

	-- Get method types first, since vars can forward reference them
	return getMethods( parseTrees )
end


------------------------------------------------------------------------------

return checkJava
