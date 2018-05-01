-----------------------------------------------------------------------------------------
--
-- api.lua
--
-- The top-level module for the Lua implementation of the Code 12 Runtime API,
-- for the Corona SDK.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- Create the main Code 12 Runtime object
local ct = require("Code12.runtime")

-- Submodule API files that add functions to the runtime object
require("Code12.errors")
require("Code12.text")
require("Code12.screens")
require("Code12.objects")
require("Code12.input")
require("Code12.audio")
require("Code12.misc")
require("Code12.types")


------------------------------------------------------------------------------

-- Initialize the runtime and return the ct object
ct.initRuntime()
return ct
