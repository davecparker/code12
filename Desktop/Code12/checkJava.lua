-----------------------------------------------------------------------------------------
--
-- checkJava.lua
--
-- Semantic Analysis and Error Checking for Java for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- Code12 modules
local app = require( "app" )
local err = require( "err" )
local javaTypes = require( "javaTypes" )
local apiTables = require( "apiTables" )   -- note: generated by the "Make API" tool


-- The checkJava module
local checkJava = {}


-- File local state
local syntaxLevel          -- the langauge (syntax) level

-- Table of variables that are currently defined. 
-- These map a name to a var structure. There are also entries of type string 
-- that map a lowercase version of the name to the name with the correct case.
local variables = {}

-- Table of user-defined methods that are currently defined. 
-- These map a name to a table in the same format as the apiTables 
-- plus a func field that references the function definition.
--     { vt = vtReturn, func = func, 
--            params = array of { name = str, vt = vtParam, var = var } }
-- There are also entries of type string 
-- that map a lowercase version of the name to the name with the correct case.
local userMethods = {}

-- Set of strings for names of event methods that the user has defined (overridden)
local eventMethodsDefined = {}

-- Stack of local variable names, with an empty name "" marking the beginning of each block
local localNameStack = {}

-- Program processing state
local beforeStart       -- true when checking code that will run before start()
local currentFunc		-- the func body currently being checked or nil if none
local currentLoop       -- the loop body currently being checked or nil if none 

-- Forward declarations for recursion
local vtSetExprNode
local checkStmt


--- Misc Analysis Functions --------------------------------------------------

-- If the name is an invalid name for a variable or function, then set the 
-- error state and return true. Usage should be a description of how the name
-- is being used (e.g. "variable", "function"). 
-- Return false if the name is valid.
local function isInvalidName( nameNode, usage )
	-- Check special Code12 reserved names
	local name = nameNode.str
	if name == "ct" or name == "_fn" then
		err.setErrNode( nameNode, 
				"The name \"%s\" is reserved for use by the system", name )
		return true
	end

	-- Check for constants with the wrong case
	local nameLower = string.lower( name )
	if nameLower == "true" or nameLower == "false" or nameLower == "null" then
		err.setErrNode( nameNode, 
				"Incorrect case for constant, should be \"%s\"", nameLower )
		return true
	end		

	-- Check for known types
	local typeName = javaTypes.correctTypeName( nameLower ) 
	if typeName then
		if typeName == name then
			err.setErrNode( nameNode, 
					"%s is a type name, expected a %s name here", name, usage )
		else
			err.setErrNode( nameNode, 
					"Code12 does not allow names that differ only by upper/lower case from known names (\"%s\" is a type name)", 
					typeName )
		end
		return true
	end
	return false
end

-- If the name does not start with a lower-case letter, then set the error state.
-- The usage should be a description of how the name is being used 
-- (e.g. "variable", "function"). 
local function checkLowerCaseStart( nameNode, usage )
	local chFirst = string.byte( nameNode.str, 1 )
	if chFirst < 97 or chFirst > 122 then    -- a to z
		err.setErrNode( nameNode, 
				"By convention, %s names should start with a lower-case letter", usage )
	end
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

-- Look for a name similar to nameStr but misspelled in nameTable.
-- Return the similar string or nil if none.
local function findMisspelledName( nameStr, nameTable )
	-- Find best match in nameTable
	local bestMatch = 0
	local bestMatchStr
	for entryStr, entry in pairs( nameTable ) do
		if type(entry) == "table" then
			local match = app.partialMatchString( nameStr, entryStr )
			-- print( nameStr, entryStr, match )
			if match > bestMatch then
				bestMatch = match
				bestMatchStr = entryStr
			end
		end
	end

	-- Consider it similar if match is greater than threshold
	if bestMatch > 0.3 then
		return bestMatchStr
	end
	return nil
end

-- Define the variable with the given var structure.
-- Return true if successful, false if error.
local function defineVar( var )
	-- Check to make sure the name is valid
	local vt = var.vt
	local nameNode = var.nameID
	if vt == nil or isInvalidName( nameNode, "variable" ) then
		return false   -- invalid type or name
	end

	-- Check for existing definition
	local varName = nameNode.str
	local varFound, varCorrectCase, nameCorrectCase = lookupID( nameNode, variables )
	if varFound then
		err.setErrNodeAndRef( var, varFound, 
				"Variable %s was already defined", varName )
		return false
	elseif varCorrectCase then
		err.clearErr( nameNode.iLine )
		err.setErrNodeAndRef( var, varCorrectCase, 
				"Variable %s differs only by upper/lower case from existing variable %s", 
				varName, nameCorrectCase )
		return false
	end

	-- Enforce case convention
	if not var.isConst then
		checkLowerCaseStart( nameNode, "variable" )
	end

	-- Define it and the case-insensitive lower-case version as well if necessary
	variables[varName] = var
	local varNameLower = string.lower( varName )
	if varNameLower ~= varName then
		variables[varNameLower] = varName
	end

	-- Push local variables on the locals stack
	if not var.isGlobal then
		localNameStack[#localNameStack + 1] = nameNode.str
	end
	return true
end

-- Return the variable table entry for the given variable name node.
-- If the variable is undefined then set the error state and return nil.
-- Unless unassignedOK is passed and true then also check to make sure the
-- variable has been assigned and if not then set the error state and return nil. 
local function getVariable( varNode, unassignedOK )
	assert( varNode.tt == "ID" )
	if isInvalidName( varNode, "variable" ) then
		return nil
	end
	local varFound = lookupID( varNode, variables )
	if varFound == nil then
		if varNode.str == "System" then
			err.setErrNode( varNode, "Invalid use of Java System class" )
		else
			err.setErrNode( varNode,  "Undefined variable %s", varNode.str )
		end
		return nil
	end
	if unassignedOK ~= true then
		if not varFound.assigned then
			err.setErrNode( varNode,  
				"Variable %s must be assigned before it is used", varNode.str )
			return nil
		end
	end
	return varFound
end

-- Process a method definition header, but not the body.
-- If the method is a Code12 event, then check the signature, otherwise add the
-- user-defined method to userMethods. Set the error state if there is an error.
local function defineMethod( func )
	-- Make sure the name is valid
	local nameNode = func.nameID
	if isInvalidName( nameNode, "function" ) then
		return
	end
	local fnName = nameNode.str

	-- Check the parameter names and build the params table
	local params = {}
	local paramVars = func.paramVars
	local numParams = (paramVars and #paramVars) or 0
	for i = 1, numParams do
		local var = paramVars[i]
		local nameID = var.nameID
		if isInvalidName( nameID, "parameter" ) then
			return
		end
		checkLowerCaseStart( nameID, "parameter" )
		params[#params + 1] = { name = nameID.str, vt = var.vt }
	end

	-- Is this a pre-defined event function?
	local event = lookupID( nameNode, apiTables["Code12Program"].methods )
	if event then
		-- Event: Check if the signature matches
		if event.vt ~= func.vt then
			err.setErrNode( func, 
					"Return type of %s function should be %s",
					fnName, javaTypes.typeNameFromVt( event.vt ) )
		elseif #event.params ~= numParams then
			err.setErrNode( func, 
					"Wrong number of parameters for function %s ", fnName )
		else
			for i = 1, numParams do
				if params[i].vt ~= event.params[i].vt then
					err.setErrNodeAndRef( paramVars[i], nameNode,
							"Wrong type for parameter %d of function %s",
							i, fnName )
					return
				end
			end
			if not func.isPublic then 
				err.setErrNode( func, 
						'The %s function must be declared starting with "public"', 
						fnName )
			end
		end
		-- Remember that the user defined this event
		eventMethodsDefined[nameNode.str] = true
		return
	end

	-- User-defined function: Check if already defined
	local methodFound, methodCorrectCase, nameCorrectCase 
			= lookupID( nameNode, userMethods )
	if methodFound then
		err.setErrNodeAndRef( func, methodFound.func, 
				"Function %s was already defined", fnName )
		return
	elseif methodCorrectCase then
		err.clearErr( nameNode.iLine )
		err.setErrNodeAndRef( func, methodCorrectCase.func, 
				"Function %s differs only by upper/lower case from existing function %s", 
				fnName, nameCorrectCase )
		return
	end

	-- Enforce case convention
	checkLowerCaseStart( nameNode, "function" )

	-- Add entry to userMethods table and lowercase mapping if different
	userMethods[fnName] = { vt = func.vt, func = func, params = params }
	local nameLower = string.lower( fnName )
	if nameLower ~= fnName then
		userMethods[nameLower] = fnName
	end
end

-- Return the resulting numeric vt for an operation on vt1 and vt2 (both numeric)
local function vtNumber( vt1, vt2 )
	local vt = vt1 + vt2    -- int promotes to double
	if vt > 1 then
		return 1   -- both were double, too bad we don't have bitwise OR here.
	end
	return vt
end


--- Structure Checking ---------------------------------------------------------

-- If the target node of type vtTarget can be assigned to the expr node of type
-- vtExpr then return true, otherwise set the error state and return false.
local function canAssign( target, vtTarget, expr, vtExpr )
	if javaTypes.vtCanAcceptVtExpr( vtTarget, vtExpr ) then
		return true
	end

	-- Check for various type mismatch combinations
	local str
	if vtExpr == 1 and vtTarget == 0 then          -- double assigned to int
		str = "Value of type double cannot be assigned to an int, use ct.round() or ct.toInt()"
	elseif vtExpr == 1 and vtTarget == "String" then   -- double assigned to String
		str = "Value of type double cannot be assigned to a String, consider using ct.formatDecimal()"
	elseif vtExpr == 0 and vtTarget == "String" then   -- int assigned to String
		str = "Integer value cannot be assigned to a String, consider using ct.formatInt()"
	elseif vtExpr == "String" and vtTarget == 1 then   -- String assigned to double
		str = "A String cannot be assigned to a double, consider using ct.parseNumber()"
	elseif vtExpr == "String" and vtTarget == 0 then   -- String assigned to int
		str = "A String cannot be assigned to an int, consider using ct.parseInt()"
	elseif vtExpr == "GameObj" and vtTarget == "String" then
		str = "A GameObj cannot be assigned to a String, consider using the toString() method"
	else
		str = string.format( "Value of type %s cannot be assigned to type %s",
					javaTypes.typeNameFromVt( vtExpr ), 
					javaTypes.typeNameFromVt( vtTarget ) )
	end
	err.setErrNodeAndRef( target, expr, str )
	return false
end	

-- Check a var structure and define the variable.
-- If there is an initExpr then check it and mark the var as assigned.
local function checkVar( var )
	-- { s = "var", iLine, nameID, vt, isConst, isGlobal, initExpr }
	local expr = var.initExpr
	if expr then
		local vtExpr = vtSetExprNode( expr ) 
		local assignmentOK = canAssign( var.nameID, var.vt, expr, vtExpr )
		defineVar( var )
		if assignmentOK then
			var.assigned = true
		end
	else
		defineVar( var )
	end
end

-- Check an lValue structure, which is being assigned if assigned.
-- Store the isGlobal and vt fields in the lValue, and return the vt. 
-- If there is an error, then set the error state and return nil.
local function vtCheckLValue( lValue, assigned )
	assert( lValue.s == "lValue" )
	local varNode = lValue.varID
	local indexExpr = lValue.indexExpr
	local fieldID = lValue.fieldID
	local varName = varNode.str

	-- Is this a simple variable assignment?
	local isVarAssign = assigned and (indexExpr == nil and fieldID == nil)

	-- Get the variable and its type, and store isGlobal in the lValue
	-- mark the variable assigned as appropriate.
	local vt = nil
	local isClass = javaTypes.isClassWithStaticMembers( varName )  --  ct, Math
	if not isClass then
		local varFound = getVariable( varNode, isVarAssign )
		if varFound == nil then
			return nil
		end
		lValue.isGlobal = varFound.isGlobal
		vt = varFound.vt
		if isVarAssign then
			if varFound.isConst then
				err.setErrNode( varNode, "Cannot assign to constant (final) variable" )
			end
			varFound.assigned = true
		end
	end

	-- Check array index if any, and get the element type
	if indexExpr then
		if type(vt) ~= "table" then
			err.setErrNodeAndRef( indexExpr, varNode, 
					"An index in [brackets] can only be applied to an array" )
			return nil
		elseif vtSetExprNode( indexExpr ) ~= 0 then
			err.setErrNode( indexExpr, "Array index must be an integer value" )
			return nil
		end
		vt = vt.vt   -- get element type of the array
	end

	-- Check field type if any, and get the field type.
	-- Public field access is only possible with Math or GameObj, or array.length
	if fieldID then
		-- Determine the class
		local className
		if isClass then
			className = varName    -- e.g. Math
		elseif vt == "GameObj" then
			className = "GameObj"
		elseif type(vt) == "table" then
			-- Support array.length
			if fieldID.str == "length" then
				return 0  -- int
			else
				err.setErrNodeAndRef( fieldID, lValue,
					"Arrays can only access their \".length\" field" )
				return nil
			end
		else
			err.setErrNodeAndRef( fieldID, lValue, "Type %s has no data fields",
					javaTypes.typeNameFromVt( vt ) )
			return nil
		end
		local class = apiTables[className]

		-- Look up the field
		local fieldFound = lookupID( fieldID, class.fields )
		if fieldFound == nil then
			if lookupID( fieldID, class.methods ) then
				-- Trying to use a method as a data field
				err.setErrNode( lValue, 
						"Attempt to use function as a variable: missing ( ) for function call?" )
			else
				err.setErrNode( lValue, 'Unknown field "%s" for class %s',
						fieldID.str, className )
			end
			return nil
		end
		vt = fieldFound.vt
	end

	-- If assigning then check if the object is assignable
	if assigned and isClass then
		err.setErrNode( lValue, "This is not a variable that can be assigned to" )
	end
	
	-- Store the vt in the lValue and return it
	lValue.vt = vt
	return vt
end

-- Find a user-defined method with the given nameID node.
-- Return the entry in the userMethods table if found.
-- If not found then set the error state and return nil.
local function findUserMethod( nameID )
	assert( nameID.tt == "ID" )
	if isInvalidName( nameID, "function" ) then
		return nil
	end
	local method = lookupID( nameID, userMethods )
	if method == nil then
		-- User function not found
		if lookupID( nameID, apiTables["Code12Program"].methods ) then
			-- Trying to call a Code12 event
			err.setErrNode( nameID, "Calling event functions directly is not allowed")
		elseif lookupID( nameID, apiTables["ct"].methods ) then
			-- Looks like the user left off "ct." of a known Code API 
			err.setErrNode( nameID, 'The Code12 function name is "%s"', 
					"ct." .. nameID.str )
		else
			err.setErrNode( nameID, "Undefined function %s", nameID.str )
		end
		return nil
	end
	return method
end

-- If the lValue and nameID from a call match a supported System.out method,
-- then return the entry in the apiTables. If there is an error then
-- set the error state and return nil. Just return nil if no match.
local function findSystemOutMethod( lValue, nameID )
	if lValue.fieldID == nil then
		return nil
	end
	local varName = lValue.varID.str
	if string.lower( varName ) ~= "system" then
		return nil
	end
	local fieldName = lValue.fieldID.str
	if string.lower( fieldName ) ~= "out" or lValue.indexExpr then
		err.setErrNodeSpan( lValue, nameID, "Invalid function name" )
		return nil
	end
	if varName ~= "System" or fieldName ~= "out" then
		err.setErrNode( lValue, 
				'Names are case-sensitive. The correct case is "System.out"' )
		return nil
	end
	return lookupID( nameID, apiTables["PrintStream"].methods )
end

-- Return (method table entry, class name, method display name) for the
-- given lValue and nameID in a call structure. The class name will be nil
-- for user-defined methods. If the method is not found then return nil.
local function findMethod( lValue, nameID )
	assert( lValue == nil or lValue.s == "lValue" )
	assert( nameID.tt )
	local nameStr = nameID.str

	-- Is this a call to a user-defined function?
	if lValue == nil then
		return findUserMethod( nameID ), nil, nameStr
	end

	-- Check for System.out methods
	local method = findSystemOutMethod( lValue, nameID )
	if method then
		return method, "PrintStream", "System.out." .. nameStr
	end

	-- Determine the className and class API entry
	local className
	local class = lookupID( lValue.varID, apiTables )
	if class then
		-- Static method call
		if lValue.indexExpr then
			err.setErrNode( lValue.indexExpr,
					"An index in [brackets] can only be applied to an array" )
			return nil
		end
		local varName = lValue.varID.str
		if javaTypes.isClassWithStaticMembers( varName ) then
			className = varName    -- ct or Math
		else
			-- Error: e.g. GameObj.delete(), String.equals()
			err.setErrNodeSpan( lValue, nameID,
					"Cannot call methods directly on class %s", varName );
			return nil
		end
	else
		-- Instance method call
		local vt = vtCheckLValue( lValue )
		if vt == "String" or vt == "GameObj" then
			className = vt
			class = apiTables[className]
		else
			-- Error: e.g. intVar.delete()
			err.setErrNodeSpan( lValue, nameID, 
					"Method call on invalid type (%s)",
					javaTypes.typeNameFromVt( vt ) )
			return nil
		end
	end

	-- Look up the method
	method = lookupID( nameID, class.methods )
	if method == nil then
		-- Not found: look for close misspellings
		local misName = findMisspelledName( nameID.str, class.methods )
		if className == "ct" then
			if misName then
				err.setErrNodeSpan( lValue, nameID, 
						'Unknown or misspelled API function, did you mean "%s" ?', 
						"ct." .. misName )
			else
				err.setErrNodeSpan( lValue, nameID, "Unknown API function" )
			end
		else
			if misName then
				err.setErrNodeAndRef( nameID, lValue, 
						'Unknown or misspelled method for class %s, did you mean "%s" ?', 
						className, misName )
			else
				err.setErrNodeAndRef( nameID, lValue, 
						'Unknown method "%s" for class %s', nameStr, className )
			end
		end
		return nil
	end

	-- Return results
	return method, className, className .. "." .. nameStr
end

-- Check a call stmt or expr structure.
-- If there is an error then set the error state and return nil, 
-- otherwise return the vt for the return type vt if successful.
local function vtCheckCall( call )
	-- { s = "call", lValue, nameID, exprs }
	local lValue = call.lValue
	local nameID = call.nameID
	local exprs = call.exprs

	-- Find the method
	local method, className, fnName = findMethod( lValue, nameID )
	if method == nil then
		return nil
	end
	local refFunc = method.func   -- for user-defined methods, nil for API

	-- Code12 does not allow calling ct or user-defined methods before start()
	if beforeStart then
		if lValue == nil then
			err.setErrNode( call, "User-defined functions cannot be called before start()" )
			return nil
		elseif className == "ct" then
			err.setErrNode( call, "Code12 API functions cannot be called before start()" )
			return nil
		end
	end

	-- Check parameter count
	local numExprs = (exprs and #exprs) or 0
	local numParams = #method.params
	local min = method.min or numParams
	if numExprs < min then
		if numExprs == 0 then
			err.setErrNodeAndRef( call, refFunc, "%s requires %d parameter%s", 
					fnName, min, (min ~= 1 and "s") or "" )
		else
			err.setErrNodeAndRef( call, refFunc, 
					"Not enough parameters passed to %s (requires %d)", 
					fnName, min )
		end
		return nil
	elseif not method.variadic and numExprs > numParams then
		err.setErrNodeAndRef( call, refFunc, 
				"Too many parameters passed to %s", fnName )
		return nil
	end

	-- Get the exprs types and the check special case for overloaded Math methods:
	-- If all parameters are int then it returns int (only apples to Math methods).
	if exprs then
		local allExprsAreInt = true
		for _, expr in ipairs( exprs ) do
			local vt = vtSetExprNode( expr )
			if vt ~= 0 then
				allExprsAreInt = false
			end
		end
		if method.overloaded and allExprsAreInt then
			return 0   -- e.g. Math.max(int, int) returns int
		end
	end

	-- Check parameter types for validity and match with the API
	for i = 1, numExprs do
		if i > numParams then
			assert( method.variadic )
			break    -- variadic function can take any types after those specified
		end
		local expr = exprs[i]
		local vtPassed = expr.vt
		local vtNeeded = method.params[i].vt
		if not javaTypes.vtCanAcceptVtExpr( vtNeeded, vtPassed ) then
			err.setErrNodeAndRef( expr, refFunc, 
					"Parameter %d (%s) of %s expects type %s, but %s was passed",
					i, method.params[i].name, fnName, javaTypes.typeNameFromVt( vtNeeded ), 
					javaTypes.typeNameFromVt( vtPassed ) )
			return nil
		end
	end

	-- Result is the method's return type
	return method.vt
end

-- Begin a new local variable block, then if paramVars then define 
-- the formal parameters as local variables.
local function beginLocalBlock( paramVars )
	localNameStack[#localNameStack + 1] = ""   -- push special sentinel marking block start
	if paramVars then
		for _, var in ipairs( paramVars ) do
			checkVar( var )
			var.assigned = true
		end
	end
end

-- End a local variable block, discarding any definitions in the top block
local function endLocalBlock()
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

-- If stmts then check the block of stmts. If paramVars is included then define 
-- these formal parameters at the beginning of the block.
local function checkBlock( stmts, paramVars )
	if stmts then
		beginLocalBlock( paramVars )
		for _, stmt in ipairs( stmts ) do
			checkStmt( stmt )
		end
		endLocalBlock()
	end
end

-- Check that the loop test expr is boolean
local function checkLoopExpr( expr )
	if vtSetExprNode( expr ) ~= true then
		err.setErrNode( expr, "Loop test must evaluate to a boolean (true or false)" )
	end
end

-- If expr then type check it, otherwise assume the type is int (++ or --),
-- then check the lValue, then return true if the type can be op-assigned 
-- (e.g. +=) to lValue, otherwise set the error state and return false.
local function canOpAssign( lValue, opNode, expr )
	-- Make sure the lValue is numeric
	local vtLValue = vtCheckLValue( lValue )   -- is read before assigned
	if type(vtLValue) ~= "number" then
		err.setErrNodeAndRef( opNode, lValue, 
				"%s can only be applied to numbers", opNode.str )
		return false
	end

	-- Check the expr if any
	if expr then
		local vtExpr = vtSetExprNode( expr )
		if type(vtExpr) ~= "number" then
			err.setErrNodeAndRef( expr, opNode, 
					"Expression for %s must be numeric", opNode.str )
			return false
		elseif vtExpr == 1 and vtLValue == 0 then
			err.setErrNodeAndRef( expr, lValue, 
					"Value of type double cannot be assigned to int" )
			return false
		end
	end
	return true
end

-- Check the stmt block for the given loop stmt
local function checkLoopBlock( stmt )
	local currentLoopSav = currentLoop
	currentLoop = stmt
	checkBlock( stmt.stmts )
	currentLoop = currentLoopSav
end

-- Check a stmt structure. Set the error state if there is an error.
function checkStmt( stmt )
	local s = stmt.s
	if s == "var" then
		-- { s = "var", iLine, nameID, vt, isConst, isGlobal, initExpr }
		checkVar( stmt )
	elseif s == "call" then
		-- { s = "call", iLine, className, objLValue, nameID, exprs }
		vtCheckCall( stmt )
	elseif s == "assign" then
		-- { s = "assign", iLine, lValue, opToken, opType, expr }   opType: =, +=, -=, *=, /=, ++, --	
		local lValue = stmt.lValue
		local opNode = stmt.opToken	
		local opType = stmt.opType
		local expr = stmt.expr
		if opType == "=" then
			local vtExpr = vtSetExprNode( expr )
			local vtLValue = vtCheckLValue( lValue, true )
			canAssign( lValue, vtLValue, expr, vtExpr )
		else
			canOpAssign( lValue, opNode, expr )
		end
	elseif s == "if" then
		-- { s = "if", iLine, expr, stmts, elseStmts }
		if vtSetExprNode( stmt.expr ) ~= true then
			err.setErrNode( stmt.expr, "Conditional test must be boolean (true or false)" )
		end
		checkBlock( stmt.stmts )
		checkBlock( stmt.elseStmts )
	elseif s == "while" then
		-- { s = "while", iLine, expr, stmts }
		checkLoopExpr( stmt.expr )
		checkLoopBlock( stmt )
	elseif s == "doWhile" then
		-- { s = "doWhile", iLine, expr, stmts }
		checkLoopBlock( stmt )
		checkLoopExpr( stmt.expr )
	elseif s == "for" then
		-- { s = "for", iLine, initStmt, expr, nextStmt, stmts }
		local initStmt = stmt.initStmt
		if initStmt then
			beginLocalBlock()  -- extra block to contain the loop var
			checkStmt( initStmt )
		end
		if stmt.expr then
			checkLoopExpr( stmt.expr )
		end
		if stmt.nextStmt then
			checkStmt( stmt.nextStmt )
		end
		checkLoopBlock( stmt )
		if initStmt then
			endLocalBlock()
		end
	elseif s == "forArray" then
		-- { s = "forArray", iLine, var, expr, stmts }
		beginLocalBlock()  -- extra block to contain the loop var
		local var = stmt.var
		checkVar( var )
		local vtExpr = vtSetExprNode( stmt.expr )
		if type(vtExpr) ~= "table" then
			err.setErrNode( stmt.expr, "A for-each loop must operate on an array" )
		elseif vtExpr.vt ~= var.vt then
			err.setErrNodeAndRef( var, stmt.expr,
					"The loop array contains elements of type %s",
					javaTypes.typeNameFromVt( vtExpr.vt ) )
		else
			var.assigned = true
			checkLoopBlock( stmt )
		end
		endLocalBlock()
	elseif s == "return" then
		-- { s = "return", iLine, expr }
		local vtFunc = currentFunc.vt
		if stmt.expr then
			local vtExpr = vtSetExprNode( stmt.expr )
			if vtFunc == false then   -- function is void
				err.setErrNodeAndRef( stmt, currentFunc,
						"void functions cannot return a value" )
			elseif not javaTypes.vtCanAcceptVtExpr( vtFunc, vtExpr ) then
				err.setErrNodeAndRef( stmt, currentFunc,
						"Incorrect return value type (%s) for function %s (requires %s)",
						javaTypes.typeNameFromVt( vtExpr ), currentFunc.nameID.str,
						javaTypes.typeNameFromVt( vtFunc ) )
			end
		elseif vtFunc ~= false then  -- missing return value
			err.setErrNodeAndRef( stmt, currentFunc,
				"Function %s requires a return value of type %s",
				 currentFunc.nameID.str, javaTypes.typeNameFromVt( vtFunc ) )
		end
	elseif s == "break" then
		-- { s = "break" }
		if currentLoop == nil then
			err.setErrNode( stmt, "break statements are only allowed inside loops" )
		end
	else
		error( "Unknown stmt structure " .. s )
	end
end


--- Type Analysis of expressions  --------------------------------------------

-- The following local functions are all hashed into from the fnVtExprVariations
-- table below. They all check the expr node recursively then return the result vt.
-- If there is an error, they set the error state and return nil.

-- literal: NUM
local function vtExprNUM( node )
	-- Imitating Java, a number is double if it has a decimal point or
	-- is in exponential notation, regardless of its value
	return ((node.token.str:find("[%.eE]") and 1) or 0)   -- double or int
end

-- literal: BOOL
local function vtExprBOOL()
	return true
end

-- literal: NULL
local function vtExprNULL()
	return "null"
end

-- literal: STR
local function vtExprSTR()
	return "String"
end

-- cast
local function vtExprCast( node )
	-- The only cast currently supported is (int) doubleExpr
	assert( node.vt == 0 )  -- (int) enforced by parseProgram
	local vtExpr = vtSetExprNode( node.expr )
	if vtExpr == 1 then
		return 0   -- proper cast of double to int
	elseif vtExpr == 0 then
		err.setErrNode( node, "Type cast is not necessary: expression is already of type int" )
	else
		err.setErrNode( node, "(int) type cast can only be applied to type double" )
	end
	return nil
end

-- parens
local function vtExprExprParens( node )
	return vtSetExprNode( node.expr )
end

-- unaryOp: neg
local function vtExprNeg( node )
	local vt = vtSetExprNode( node.expr )
	if type(vt) ~= "number" then
		err.setErrNodeAndRef( node.opToken, node.expr, 
				"The negate operator (-) can only apply to numbers" )
		return nil
	end
	return vt
end

-- unaryOp: not
local function vtExprNot( node )
	local vt = vtSetExprNode( node.expr )
	if vt ~= true then
		err.setErrNodeAndRef( node.opToken, node.expr, 
				"The not operator (!) can only apply to boolean values" )
		return nil
	end
	return vt
end

-- newArray
local function vtExprNewArray( node )
	local vtCount = vtSetExprNode( node.lengthExpr )
	if vtCount ~= 0 then
		err.setErrNode( node.lengthExpr, "Array count must be an integer" )
		return nil
	end
	return { vt = node.vt }  -- array of element type
end

-- arrayInit
local function vtExprArrayInit( node )
	local exprs = node.exprs
	if #exprs == 0 then
		err.setErrNode( node, "Array initializer cannot be empty" )
		return nil
	end
	-- Check that all members are the same type
	local vtMembers = nil
	for i = 1, #exprs do
		local vt = vtSetExprNode( exprs[i] )
		if vt == nil then
			return nil
		elseif type(vt) == "table" then
			err.setErrNode( node, "Code12 does not support arrays of arrays" )
			return nil
		elseif vtMembers == nil then
			vtMembers = vt
		elseif vt ~= vtMembers then
			if type(vt) == "number" and type(vtMembers) == "number" then
				vtMembers = vtNumber( vt, vtMembers )
			else
				err.setErrNode( node, "Array initializers must all be the same type" )
				return nil
			end
		end
	end
	return { vt = vtMembers }
end

-- binOp: +
local function vtExprPlus( node )
	-- May be numeric add or string concat, depending on the operands
	local vtLeft = vtSetExprNode( node.left )
	local vtRight = vtSetExprNode( node.right )
	if type(vtLeft) == "number" and type(vtRight) == "number" then
		return vtNumber( vtLeft, vtRight )
	elseif vtLeft == "String" and vtRight == "String" then
		return "String"
	elseif vtLeft == "String" or vtRight == "String" then
		-- Check if the other operand can be promoted to string
		local exprOther, vtOther
		if vtLeft == "String" then
			exprOther = node.right
			vtOther = vtRight
		else
			exprOther = node.left
			vtOther = vtLeft
		end
		if type(vtOther) == "table" then
			err.setErrNodeAndRef( node.opToken, exprOther, 
					"The (+) operator cannot be applied to arrays" ) 
		end
		return "String"   -- all primitive types can promote to a string 
	else
		-- Find the side that is wrong
		local exprOther
		if vtLeft == "String" or type(vtLeft) == "number" then
			exprOther = node.right
		else
			exprOther = node.left
		end
		err.setErrNodeAndRef( node.opToken, exprOther, 
				"The (+) operator can only apply to numbers or Strings" )
	end
	return nil
end

-- binOp: -, *, /, %
local function vtExprNumeric( node )
	-- Both sides must be numeric, result is number
	local vtLeft = vtSetExprNode( node.left )
	local vtRight = vtSetExprNode( node.right )
	if type(vtLeft) == "number" and type(vtRight) == "number" then
		return vtNumber( vtLeft, vtRight )
	end
	local exprErr = ((type(vtLeft) ~= "number" and node.left) or node.right)
	err.setErrNodeAndRef( node.opToken, exprErr, 
			"Numeric operator (%s) can only apply to numbers", node.opToken.str )
	return nil
end

-- binOp: / (calls vtExprNumeric then does additional checks)
local function vtExprDivide( node )
	-- Check as numeric binOp then check for bad int divide
	local vt = vtExprNumeric( node )
	if vt == 0 then
		-- int divide: allow only if dividing constants with no remainder
		local left = node.left
		local right = node.right
		if left.s == "literal" and left.token.tt == "NUM" 
				and right.s == "literal" and right.token.tt == "NUM" then
			-- Both sides are constant so we can check for a remainder
			local n = tonumber( left.token.str )
			local d = tonumber( right.token.str )
			local r = n / d
			if r == math.floor( r ) then
				return 0   -- valid int result
			end
			err.setErrNode( node, "Integer divide has remainder. Use double or ct.intDiv()" )
		end
		-- The remainder can't be determined, but Code12 doesn't allow this
		-- because chances are the programmer made a mistake.
		err.setErrNode( node, "Integer divide may lose remainder. Use double or ct.intDiv()" )
	end
	return vt
end

-- binOp: &&, ||
local function vtExprLogical( node )
	-- Both sides must be boolean, result is boolean
	local vtLeft = vtSetExprNode( node.left )
	local vtRight = vtSetExprNode( node.right )
	if vtLeft == true and vtRight == true then
		return true
	end
	local exprErr = ((vtLeft ~= true and node.left) or node.right)
	err.setErrNodeAndRef( node.opToken, exprErr, 
			"Logical operator (%s) can only apply to boolean values", node.opToken.str )
	return nil
end

-- binOp: <, >, <=, >=
local function vtExprInequality( node )
	-- Both sides must be numeric, result is boolean
	local vtLeft = vtSetExprNode( node.left )
	local vtRight = vtSetExprNode( node.right )
	if type(vtLeft) == "number" and type(vtRight) == "number" then
		return true
	end
	local exprErr = ((type(vtLeft) ~= "number" and node.left) or node.right)
	err.setErrNodeAndRef( node.opToken, exprErr, 
			"Inequality operator (%s) can only apply to numbers", node.opToken.str )
	return nil
end

-- binOp: ==, !=
local function vtExprEquality( node )
	local vtLeft = vtSetExprNode( node.left )
	local vtRight = vtSetExprNode( node.right )
	if javaTypes.canCompareVts( vtLeft, vtRight ) then
		-- Don't allow comparing Strings with ==
		if vtLeft == "String" and vtRight == "String" then
			if syntaxLevel >= 7 then
				err.setErrNodeAndRef( node.opToken, node.left,
						"Use str1.equals( str2 ) to compare two String values" )
			else
				err.setErrNodeAndRef( node.opToken, node.left,
						"Strings cannot be compared with ==. You must use the equals method, which requires level 7" )
			end
			return nil
		end
		return true
	end
	err.setErrNodeAndRef( node.left, node.right, "Cannot compare %s to %s", 
		javaTypes.typeNameFromVt( vtLeft ), javaTypes.typeNameFromVt( vtRight ) )
	return nil
end

-- binOp: = (incorrect use of = as a binary operator) 
local function vtExprBadEquality( node )
	err.setErrNodeAndRef( node.opToken, node.left,
					"Use == to compare for equality (= is for assignment)" )
	return nil
end


-- Since there are so many expr variations, we hash them to functions by their
-- structure name (s), opType, or literal token tt.
local fnVtExprVariations = {
	-- literal patterns
	["NUM"]         = vtExprNUM,
	["BOOL"]        = vtExprBOOL,
	["NULL"]        = vtExprNULL,
	["STR"]         = vtExprSTR,
	-- unary operators
	["neg"]         = vtExprNeg,
	["not"]         = vtExprNot,
	-- binary operators
	["+"]           = vtExprPlus,
	["-"]           = vtExprNumeric,
	["*"]           = vtExprNumeric,
	["/"]           = vtExprDivide,
	["%"]           = vtExprNumeric,
	["&&"]          = vtExprLogical,
	["||"]          = vtExprLogical,
	["<"]           = vtExprInequality,
	[">"]           = vtExprInequality,
	["<="]          = vtExprInequality,
	[">="]          = vtExprInequality,
	["=="]          = vtExprEquality,
	["!="]          = vtExprEquality,
	["="]           = vtExprBadEquality,
	-- other expr patterns
	["call"]        = vtCheckCall,
	["lValue"]      = vtCheckLValue,
	["cast"]        = vtExprCast,
	["parens"]      = vtExprExprParens,
	["newArray"]	= vtExprNewArray,
	["arrayInit"]   = vtExprArrayInit,
}

-- Return the value type (vt) for an expr or lValue node.
-- Also store the vt into node.vt for future use.
-- If an error is found, set the error state and return nil.
function vtSetExprNode( node )
	-- Determine the function to dispatch to from table above
	local s = node.s
	local fnVt
	if s == "literal" then
		fnVt = fnVtExprVariations[node.token.tt]
	elseif s == "unaryOp" or s == "binOp" then
		fnVt = fnVtExprVariations[node.opType]
	else
		fnVt = fnVtExprVariations[s]
	end

	-- Check for unsupported operator or other unexpected index
	if fnVt == nil then
		if node.opToken then
			err.setErrNode( node.opToken, 
					"The %s operator is not supported by Code12 ", node.opToken.str )
		else
			err.setErrNode( node, "Unrecognized expression type" )  -- shouldn't happen
		end
		return nil
	end

	-- Dispatch to the function, store and return the result
	local vt = fnVt( node )
	node.vt = vt       
	return vt
end


--- Module Functions ---------------------------------------------------------

-- Do semantic checking on the programTree at the given syntax level.
-- Record any error(s) in the error state.
function checkJava.checkProgram( programTree, level )
	-- Init program state
	syntaxLevel = level
	variables = {}
	userMethods = {}
	eventMethodsDefined = {}
	localNameStack = {}
	beforeStart = true
	currentFunc = nil
	currentLoop = nil

	-- Get method definitions first, since vars can forward reference them
	assert( programTree.s == "program" )
	local vars = programTree.vars
	local funcs = programTree.funcs
	if funcs then
		for _, func in ipairs( funcs ) do
			defineMethod( func )
		end
	end

	-- Check instance vars
	if vars then
		for _, var in ipairs( vars ) do
			checkVar( var )
		end
	end

	-- Check method bodies
	beforeStart = false
	if funcs then
		for _, func in ipairs( funcs ) do
			currentFunc = func
			checkBlock( func.stmts, func.paramVars )
		end
	end
	currentFunc = nil

	-- Do some overall post-checks if there are no other errors
	if not err.shouldStop() then
		-- Make sure that a start function was defined
		if not eventMethodsDefined["start"] then
			err.setErrLineNum( programTree.nameID.iLine,
					"A Code12 program must define a \"start\" function" )
		end
	end
end


------------------------------------------------------------------------------

return checkJava
