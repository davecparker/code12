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

-- The value type (vt) of a supported type name
local mapTypeNameToVt = {
	["int"]      = 0,
	["double"]   = 1,
	["boolean"]  = true,
	["String"]   = "String",
	["GameObj"]  = "GameObj",
}

-- The value type (vt) of a literal token type
local mapTokenTypeToVt = {
	["INT"]   = 0,
	["NUM"]   = 1,
	["BOOL"]  = true,
	["STR"]   = "String",
	["NULL"]  = "null",
}

-- Map unsupported Java types to the type the user should use instead in Code12
local substituteType = {
	["byte"]     = "int",
	["char"]     = "String",
	["float"]    = "double",
	["long"]     = "int",
	["short"]    = "int",
	["Integer"]  = "int",
	["Double"]   = "double",
	["Boolean"]  = "boolean",
}


--- Module Functions ---------------------------------------------------------


-- Return the value type (vt) for a typeNode token and optional isArray flag,
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtFromType( typeNode, isArray )
	if ( typeNode.tt ~= "TYPE" ) then
		print(typeNode.tt, typeNode.str)
		assert(false)
	end
	local typeName = typeNode.str
	local vt = mapTypeNameToVt[typeName]
	if vt then
		if isArray then
			return { vt = vt }
		end
		return vt
	end

	-- Unsupported type
	if typeName == "Object" then
		err.setErrNode( typeNode, "The Object type is not supported by Code12. Use GameObj or String instead." )
	else
		local subType = substituteType[typeName]
		if subType then
			err.setErrNode( typeNode, "The %s type is not supported by Code12. Use %s instead.",
					typeName, subType )
		else
			err.setErrNode( typeNode, "Unknown type name" )   -- shouldn't happen
		end
	end
	return nil
end

-- Return the value type (vt) for a variable typeNode token and optional isArray flag,
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtFromVarType( typeNode, isArray )
	local vt = javaTypes.vtFromType( typeNode, isArray )
	if vt == false then
		err.setErrNode( typeNode, "Variables cannot have void type" )
		return nil
	end
	return vt
end

-- Return the type name of the given value type (vt)
function javaTypes.typeNameFromVt( vt )
	if type(vt) == "table" then
		return "array of " .. javaTypes.typeNameFromVt( vt.vt )
	end
	return mapVtToTypeName[vt] or "(unknown)"
end

-- Return the value type (vt) for a token type if it is a literal, else nil.
function javaTypes.vtFromTokenType( tt )
	return mapTokenTypeToVt[tt]
end

-- Return true if vt1 and vt2 are the same type.
function javaTypes.vtsEqual( vt1, vt2 )
	if type(vt1) == "table" and type(vt2) == "table" then
		return javaTypes.vtsEqual( vt1.vt, vt2.vt )
	end
	return vt1 == vt2
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


------------------------------------------------------------------------------

return javaTypes
