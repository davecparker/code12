-----------------------------------------------------------------------------------------
--
-- ct.lua
--
-- The ct table, which contains the Code12 API functions and user program data.
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------


-- The ct table
local ct = {
	-- User program data
	userVars = {},        -- table for user code class-level variables
	userFns = {},         -- table for user code functions (including event functions)

	-- The ct.xxx API functions are added here by api.lua and the Code12 API sub-modules
}


-- Return (ct table, userVars table, userFns table)
function ct.getTables()
	return ct, ct.userVars, ct.userFns
end


-- Return the ct table
return ct
