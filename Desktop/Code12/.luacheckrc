-- Config options for luacheck utility
-- See https://luacheck.readthedocs.io/en/stable/config.html

-- Warnings to ignore
ignore = { 
        "611", "612", "614"      -- trailing whitespace
        -- "212",                -- unused argument
}
self = false                -- OOP methods have implicit self that may be unused  

-- Lua standard globals 
std = "lua51"

-- Additional globals
read_globals = { 
	-- Lua globals
	math = { fields = { "round", "floor", "min", "max" } },
	string = { fields = { "starts" } },

	-- Corona SDK globals
	'audio', 'display', 'easing', 'graphics', 'lfs', 'media', 'native',
	'network', 'Runtime', 'system', 'timer', 'transition',	

	-- Code12 globals
	"_fn", "this",   -- these should be written only once/rarely
}
globals = { "ct" }      -- the runtime defines many functions in here

-- File-specific overrides
files["config.lua"].globals = { "application" }
files["apiTables.lua"].max_line_length = 300
