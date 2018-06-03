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
}


--- Module Functions ---------------------------------------------------------

-- Return the value type (vt) for a variable type ID node,
-- or return nil and set the error state if the type is invalid.
function javaTypes.vtFromVarType( node )
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
function javaTypes.vtFromRetType( retType )
	if retType.p == "void" then
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
		return "array of " .. typeNameFromVt( vt.vt )
	end
	return mapVtToTypeName[vt] or "(unknown)"
end


------------------------------------------------------------------------------

return javaTypes
