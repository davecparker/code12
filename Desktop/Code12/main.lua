-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Main program for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local javalex = require("javalex")

-- Lexer test string
local s = [[  { foo2_1(x, "ack", true,/*hey*/ch == 'a', _y, $z);  for a = 3.14;break;  if (a[23] == null)  } // this is a comment]]
--local s = " a>b  a>=b  a>>b a>>=b a>>>b a>>>=b "
--local s = "foo /*hey*/ bar /*this/*is*/nested*/ @bas // this is a comment"

-- Quick lexer test
local tokens = javalex.getTokens(s)
print(#tokens .. " tokens")
for i, token in ipairs(tokens) do
	print(token[3], token[1], "\"" .. token[2] .. "\"")
end
