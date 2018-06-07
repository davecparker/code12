-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Test stub to allow running generated Lua files standalone under the Lua runtime.
-- Put target file in this folder and rename it to "test.lua".
-----------------------------------------------------------------------------------------

package.path = package.path .. ';../?.lua'
require("Code12.api")

this = {}
_fn = {}
require( "test" )
