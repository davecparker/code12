-----------------------------------------------------------------------------------------
--
-- javaTypes.lua
--
-- Basic type info for Java for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- Code12 modules
local err = require( "err" )


-- The javaTypes module
local javaTypes = {}



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
	["Integer"] = "int",
	["Double"] = "double",
	["Boolean"] = "boolean",
}


--- Module Functions ---------------------------------------------------------

-- Return the value type (vt) for a variable type ID node,
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtFromVarType( node )
	assert( node.tt == "ID" )     -- varType nodes should be IDs
	local typeName = node.str
	local vt = mapTypeNameToVt[typeName]
	if vt then
		return vt  -- known valid type
	end

	-- Invalid type
	if vt == false then
		-- Variables can't be void (void return type is handled in vtFromRetType)
		err.setErrNode( node, "Variables cannot have void type" )
	else
		-- Unknown or unsupported type
		local subType = substituteType[typeName]
		if subType then
			err.setErrNode( node, "The %s type is not supported by Code12. Use %s instead.",
					typeName, subType )
		else
			-- Unknown type. See if the case is wrong.
			local typeNameLower = string.lower( typeName )
			for name, _ in pairs( mapTypeNameToVt ) do
				if string.lower( name ) == typeNameLower then
					err.setErrNode( node, 
						"Names are case-sensitive, known name is \"%s\"", name )
					return nil
				end
			end
			err.setErrNode( node, "Unknown variable type \"%s\"", typeName )
		end
	end
	return nil
end

-- Return the value type (vt) for a retType node
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtFromRetType( retType )
	local p = retType.p
	if p == "void" then
		return false
	end
	local vt = javaTypes.vtFromVarType( retType.nodes[1] )
	if p == "array" and vt ~= nil then
		vt = { vt = vt }   -- array of specified type
	end
	return vt  -- normal or unknown type
end

-- Return (vt, name) for a param node
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtAndNameFromParam( param )
	assert( param.t == "param" )
	local vt = javaTypes.vtFromVarType( param.nodes[1] )
	if param.p == "array" then
		if vt == nil then
			return nil
		end
		return { vt = vt }, param.nodes[4].str
	end
	return vt, param.nodes[2].str
end

-- Return the type name of the given value type (vt)
function javaTypes.typeNameFromVt( vt )
	if type(vt) == "table" then
		return "array of " .. javaTypes.typeNameFromVt( vt.vt )
	end
	return mapVtToTypeName[vt] or "(unknown)"
end

-- Return true if vtExpr can be passed or assigned to a variable of type vt.
function javaTypes.vtCanAcceptVtExpr( vt, vtExpr )
	if vtExpr == nil then
		return false   -- unknown type
	elseif vt == nil then
		return true    -- assigning to "Object", will accept anything
	elseif vt == vtExpr then
		return true  -- same types so directly compatible
	elseif vtExpr == 0 and type(vt) == "number" then
		return true    -- int can silently promote to double
	elseif vtExpr == "null" and type(vt) == "string" then
		return true    -- null can be assigned to any object (String or GameObj)
	elseif type(vt) == "table" and type(vtExpr) == "table" then
		return vt.vt == vtExpr.vt    -- array of same type
	end
	return false
end

-- Return true if vt1 and vt2 can be compared for equality
function javaTypes.canCompareVts( vt1, vt2 )
	if vt1 == vt2 then
		return true     -- same non-array type
	end
	local t1 = type(vt1)
	local t2 = type(vt2)
	if t1 == "number" and t2 == "number" then
		return true       -- can compare int to double
	elseif t1 == "string" and t2 == "string" then
		-- Objects of different types
		return (vt1 == "null" or vt2 == "null")  -- can compare any object to null
	elseif t1 == "table" and t2 == "table" then
		return t1.vt == t2.vt    -- can compare arrays of same type
	end	
	return false
end

-- Return the default (if unitialized) value for a vt.
function javaTypes.defaultValueForVt( vt )
	if type(vt) == "number" then
		return 0
	elseif vt == true then
		return false
	end
	return nil
end

-- Return true if name is the name of a supported class with public static members
function javaTypes.isClassWithStaticMembers( name )
	return name == "ct" or name == "Math"
end


------------------------------------------------------------------------------

return javaTypes
