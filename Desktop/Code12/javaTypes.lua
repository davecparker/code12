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

-- Known Java types: map lowercase version to correct case string
local knownTypes = {
	["int"]      = "int",
	["double"]   = "double",
	["void"]     = "void",
	["boolean"]  = "boolean",
	["string"]   = "String",
	["gameobj"]  = "GameObj",
	["byte"]     = "byte",
	["char"]     = "char",
	["float"]    = "float",
	["long"]     = "long",
	["short"]    = "short",
	["integer"]  = "Integer",
}

-- Known class names
local isKnownClassName = {
	-- Code12 names
	["Code12"]         = true,
	["Code12Program"]  = true,
	["ct"]             = true,
	["GameObj"]        = true,
	-- Standard Java classes used by Code12
	["Math"]           = true,
	["Object"]         = true,
	["String"]         = true,
	["PrintStream"]    = true,
	-- Selection of other common Java classes in java.lang
	["Boolean"]        = true,
	["Byte"]           = true,
	["Character"]      = true,
	["Class"]          = true,
	["Double"]         = true,
	["Enum"]           = true,
	["Float"]          = true,
	["Integer"]        = true,
	["Long"]           = true,
	["Number"]         = true,
	["Package"]        = true,
	["Runtime"]        = true,
	["Short"]          = true,
	["System"]         = true,
	["Throwable"]      = true,
	["Void"]           = true,
}


--- Module Functions ---------------------------------------------------------


-- Return the value type (vt) for a typeID token and optional isArray flag,
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtFromType( typeID, isArray )
	assert( typeID.tt == "ID" )
	local typeName = typeID.str
	local vt = mapTypeNameToVt[typeName]
	if vt then
		-- known non-void type
		if isArray then
			return { vt = vt }
		end
		return vt
	end

	-- Check for void type
	if vt == false then
		if isArray then
			err.setErrNode( typeID, "Invalid type: array of void" )
			return nil
		end
		return false  -- void
	end

	-- Unknown or unsupported type
	local subType = substituteType[typeName]
	if subType then
		err.setErrNode( typeID, "The %s type is not supported by Code12. Use %s instead.",
				typeName, subType )
	else
		-- Unknown type. See if the case is wrong.
		local typeNameLower = string.lower( typeName )
		for name, _ in pairs( mapTypeNameToVt ) do
			if string.lower( name ) == typeNameLower then
				err.setErrNode( typeID, 
					"Names are case-sensitive, known name is \"%s\"", name )
				return nil
			end
		end
		err.setErrNode( typeID, "Unknown type name \"%s\"", typeName )
	end
	return nil
end

-- Return the value type (vt) for a variable typeID token and optional isArray flag,
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtFromVarType( typeID, isArray )
	local vt = javaTypes.vtFromType( typeID, isArray )
	if vt == false then
		err.setErrNode( typeID, "Variables cannot have void type" )
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

-- Return true if name is a pre-defined class name known by Code12
function javaTypes.isKnownClassName( name )
	return isKnownClassName[name]
end

-- Return true if name is the name of a supported class with public static members
function javaTypes.isClassWithStaticMembers( name )
	return name == "ct" or name == "Math"
end

-- If nameLower (which should be all lowercase) is a Java type name ignoring case,
-- then return the correct case, else nil. 
function javaTypes.correctTypeName( nameLower )
	return knownTypes[nameLower]
end


------------------------------------------------------------------------------

return javaTypes
