-----------------------------------------------------------------------------------------
--
-- ct.lua
--
-- The ct table, which contains the Code12 API functions and user program data.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- The ct table
local ct = {
	-- User program data
	userVars = nil,        -- table for user code class-level variables
	userFns = nil,         -- table for user code functions (including event functions)

	-- Options
	checkParams = true,    -- set to false to disable runtime API parameter checks

	-- The ct.xxx API functions are added here by the Code12 API sub-modules
}


-- Return (ct table, userVars table, userFns table)
function ct.getTables()
	return ct, ct.userVars, ct.userFns
end


-- Return the ct table
return ct
