-----------------------------------------------------------------------------------------
--
-- javalex.lua
--
-- Implements lexical analysis for Java
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- The Java Lexer module
local javalex = {}


----- File local data --------------------------------------------------------

-- Character type table: An array that maps an ASCII code to a type value as follows:
--    Invalid chars: function invalidToken
--    Whitespace: the string " "
--    Numeric (0-9): false
--    ID start char (A-Z, a-z, $, _): true
--    Chars that are always single-char tokens (; , . ( ) { } [ ] ~ ? :): string equal to the char
--    Chars that lead to possibly multi-char tokens: a token scanning function
local charTypes = {}  -- built in initCharTypes()

-- Reserved word tokens: indexed by string, maps to token tt string or nil if not reserved
local reservedWordTokens = {
	["abstract"]		= "abstract",	
	["assert"] 			= "assert",	
	["boolean"] 		= "boolean",	
	["break"] 			= "break",	
	["byte"] 			= "byte",	
	["case"] 			= "case",
	["catch"] 			= "catch",	
	["char"] 			= "char",	
	["class"] 			= "class",	
	["const"] 			= "const",	
	["continue"] 		= "continue",	
	["default"] 		= "default",
	["do"] 				= "do",	
	["double"] 			= "double",	
	["else"] 			= "else",	
	["enum"] 			= "enum",	
	["extends"] 		= "extends",	
	["final"] 			= "final",	
	["finally"] 		= "finally",	
	["float"] 			= "float",	
	["for"] 			= "for",	
	["goto"] 			= "goto",	
	["if"] 				= "if",
	["implements"] 		= "implements",	
	["import"] 			= "import",	
	["instanceof"] 		= "instanceof",	
	["int"] 			= "int",	
	["interface"] 		= "interface",	
	["long"] 			= "long",
	["native"] 			= "native",	
	["new"] 			= "new",	
	["package"] 		= "package",	
	["private"] 		= "private",	
	["protected"] 		= "protected",
	["public"] 			= "public",	
	["return"] 			= "return",	
	["short"] 			= "short",	
	["static"] 			= "static",	
	["strictfp"]	 	= "strictfp",	
	["super"] 			= "super",
	["switch"] 			= "switch",	
	["synchronized"] 	= "synchronized",	
	["this"] 			= "this",	
	["throw"] 			= "throw",	
	["throws"] 			= "throws",	
	["transient"] 		= "transient",
	["try"] 			= "try",	
	["void"] 			= "void",	
	["volatile"] 		= "volatile",	
	["while"] 			= "while",

	-- These reserved words are actually special literals
	["true"] 			= "BOOL",	
	["false"] 			= "BOOL",
	["null"] 			= "NULL",	
}

-- State for the lexer used by token scanning functions
local source    -- the source string
local chars     -- array of ASCII codes for the source string
local iChar     -- index to current char in chars


----- Token scanning functions ------------------------------------------------

-- Return string for an invalid character
local function invalidCharToken()
	print("Invalid character code " .. chars[iChar] .. " at index " .. iChar)
	local str = string.char(chars[iChar])
	iChar = iChar + 1
	return "", str   -- TODO: Report error
end

-- Return string for token starting with =  (=  ==)
local function equalsToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "=="
	end
	return "="
end

-- Return string for token starting with >  (>  >=  >>  >>>  >>=  >>>=)
local function greaterThanToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return ">="
	elseif charNext == 62 then  --  >
		iChar = iChar + 1		
		charNext = chars[iChar]
		if charNext == 61 then  --  =
			iChar = iChar + 1
			return ">>="
		elseif charNext == 62 then  --  >
			iChar = iChar + 1
			charNext = chars[iChar]
			if charNext == 61 then  --  =
				iChar = iChar + 1
				return ">>>="
			end
			return ">>>"
		end
		return ">>"
	end
	return ">"
end

-- Return string for token starting with <  (<  <=  <<  <<=)
local function lessThanToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "<="
	elseif charNext == 60 then  --  <
		iChar = iChar + 1		
		charNext = chars[iChar]
		if charNext == 61 then  --  =
			iChar = iChar + 1
			return "<<="
		end
		return "<<"
	end
	return "<"
end

-- Return string for token starting with !  (!  !=)
local function bangToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "!="
	end
	return "!"
end

-- Return string for token starting with &  (&  &&  &=)
local function andToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "&="
	elseif charNext == 38 then  -- &
		iChar = iChar + 1
		return "&&"
	end
	return "&"
end

-- Return string for token starting with |  (|  ||  |=)
local function orToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "|="
	elseif charNext == 124 then  --  |
		iChar = iChar + 1
		return "||"
	end
	return "|"
end

-- Return string for token starting with +  (+  ++  +=) 
local function plusToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "+="
	elseif charNext == 42 then  --  +
		iChar = iChar + 1
		return "++"
	end
	return "+"
end

-- Return string for token starting with -  (-  --  -=)
local function minusToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "-="
	elseif charNext == 45 then  --  -
		iChar = iChar + 1
		return "--"
	end
	return "-"
end

-- Return string for token starting with *  (*  *=)
local function starToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "*="
	end
	return "*"
end

-- Return string for token starting with /  (/  /=)
-- or ("COMMENT", str) for a comment (either block or to end of line)
local function slashToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 47 then   --  /
		-- Comment to end of line
		local str = string.sub(source, iChar + 1)
		iChar = #chars + 1
		return "COMMENT", str
	elseif charNext == 42 then  -- *
		-- Block comment (possibly nested)
		iChar = iChar + 1
		local iCharStart = iChar
		local level = 1
		while true do
			local ch = chars[iChar]
			if ch == 42 and chars[iChar + 1] == 47 then  -- */
				iChar = iChar + 2
				level = level - 1
				if level == 0 then
					break
				end
			elseif ch == 47 and chars[iChar + 1] == 42 then  -- /*
				iChar = iChar + 2
				level = level + 1
			elseif ch == nil then
				print("Unclosed block comment")   -- TODO: Support multi-line
				return nil
			else
				iChar = iChar + 1
			end
		end
		return "COMMENT", string.sub(source, iCharStart, iChar - 3)
	elseif charNext == 61 then   --  =
		iChar = iChar + 1
		return "/="
	end
	return "/"
end

-- Return string for token starting with  ^  (^  ^=)
local function caretToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "^="
	end
	return "^"
end

-- Return string for token starting with %  (%  %=)
local function percentToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 61 then   --  =
		iChar = iChar + 1
		return "%="
	end
	return "%"
end

-- Return ("CHAR", str) for a char literal token.
-- The str includes the single quotes.
local function charLiteralToken()
	local iCharStart = iChar   -- the single quote
	iChar = iChar + 1
	local charNext = chars[iChar]
	-- TODO: if charNext == 92 then   --  \
	iChar = iChar + 1
	if chars[iChar] ~= 39 then
		print("Invalid char literal")    -- TODO
	end
	local str = string.sub(source, iCharStart, iChar)
	iChar = iChar + 1
	return "CHAR", str
end

-- Return ("STR", str) for a string literal token.
-- The str includes the double quotes.
local function stringLiteralToken()
	local iCharStart = iChar    -- the double quote
	iChar = iChar + 1
	local charNext = chars[iChar]
	while charNext ~= 34 do   -- "
		-- TODO: if charText == 92 then   -- \
		if charNext == nil then
			print("Unclosed string literal")    -- TODO
			return nil
		end
		iChar = iChar + 1
		charNext = chars[iChar]
	end
	local str = string.sub(source, iCharStart, iChar)
	iChar = iChar + 1
	return "STR", str
end

-- Return ("NUM", str) for a numeric literal token starting with a digit
local function numericLiteralToken()
	local iCharStart = iChar   -- the first digit char
	iChar = iChar + 1
	local charType = charTypes[chars[iChar]]
	while charType == false do   -- digit chars 
		iChar = iChar + 1
		charType = charTypes[chars[iChar]]
	end
	if charType == "." then
		repeat
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		until charType ~= false    -- digit chars past decimal point
	end
	-- TODO: Handle E notation
	local str = string.sub(source, iCharStart, iChar - 1)
	return "NUM", str
end


----- Module functions -------------------------------------------------------

-- Return an array of tokens for the given source string. 
-- Each token is a 3-element array { tt, str, iCharFirst }, where iCharFirst is 
-- the index of the start of the token in sourceStr, str is the text of the token, 
-- and tt is a string that identifies the token type as follows:
--     Keywords, operators, and seperators have tt == str (e.g. "for", "++", ";")
--     "ID": an identifer that is not a reserved word
--     "NUM": numeric literal (any numeric type)
--     "STR": string literal (note that str includes the quotes)
--     "CHAR": char literal (note that str includes the quotes)
--     "BOOL": boolean literal (str is "false" or "true")
--     "NULL": the null literal (str is "null")
--     "COMMENT": a comment (str is text of the comment not including the open/close)
function javalex.getTokens(sourceStr)
	-- Make array of ASCII codes for the source string
	source = sourceStr
	chars = { string.byte(source, 1, string.len(source)) }   -- supposedly faster than a loop

	-- Init array of tokens to return
	local tokens = {}

	-- Scan the chars array
	iChar = 1
	repeat
		-- Skip whitespace
		local charType = charTypes[chars[iChar]]
		while charType == " " do
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		end

		-- Make a token, which is a 3-array: { tt, str, iCharFirst }
		local token = { "", "", iChar }   -- TODO: get from pool

		-- Determine what token type to build next
		if charType == true then    -- ID start char
			-- Identifier
			local iCharStart = iChar
			repeat
				iChar = iChar + 1
				charType = charTypes[chars[iChar]]
			until type(charType) ~= "boolean"    -- ID char
			local str = string.sub(source, iCharStart, iChar - 1)
			token[1] = reservedWordTokens[str] or "ID"    -- ID if not a reserved word
			token[2] = str
		elseif charType == false then   -- numeric 0-9
			-- Number constant
			token[1], token[2] = numericLiteralToken()
		elseif charType == nil then
			-- End of source string
			break
		elseif type(charType) == "function" then
			-- Possible multi-char token, or char or string literal
			local tt, str = charType()   -- token scanning function returns tt, str
			token[1] = tt
			token[2] = str or tt    -- simple tokens are their own string
		else
			-- Single char token
			iChar = iChar + 1
			token[1] = charType   -- single char string
			token[2] = charType   -- simple tokens are their own string
		end 

		-- Add token to tokens array
		tokens[#tokens + 1] = token
	until false   -- breaks internally when end of string is found

	-- Return tokens array
	return tokens
end


----- Initialization ---------------------------------------------------------

-- Init the charTypes array
local function initCharTypes()
	-- Init array to all invalid chars to start with (and ensure contiguous array)
	for ch = 0, 127 do
		charTypes[ch] = invalidCharToken
	end

	-- Whitespace
	for ch = 9, 13 do   -- TAB through CR
		charTypes[ch] = " "   
	end
	charTypes[32] = " "    -- Space

	-- Numeric
	for ch = 48, 57 do     -- 0-9
		charTypes[ch] = false
	end

	-- Alpha and other ID start chars
	for ch = 65, 90 do     -- A-Z
		charTypes[ch] = true
	end
	for ch = 97, 122 do    -- a-z
		charTypes[ch] = true
	end
	charTypes[36] = true   -- $
	charTypes[95] = true   -- _

	-- Quotes
	charTypes[39] = charLiteralToken      -- '
	charTypes[34] = stringLiteralToken    -- "

	-- Chars that are always single-char tokens
	charTypes[59] = ";"
	charTypes[44] = ","
	charTypes[46] = "."
	charTypes[40] = "("
	charTypes[41] = ")"
	charTypes[123] = "{"
	charTypes[125] = "}"
	charTypes[91] = "["
	charTypes[93] = "]"
	charTypes[126] = "~"
	charTypes[63] = "?"
	charTypes[58] = ":"

	-- Chars that may lead to multi-char tokens use scanning functions
	charTypes[61] = equalsToken
    charTypes[62] = greaterThanToken
    charTypes[60] = lessThanToken
    charTypes[33] = bangToken
    charTypes[38] = andToken
    charTypes[124] = orToken
    charTypes[43] = plusToken
    charTypes[45] = minusToken
    charTypes[42] = starToken
    charTypes[47] = slashToken
    charTypes[94] = caretToken
    charTypes[37] = percentToken
end

-- Init the module
local function initModule()
	initCharTypes()
end


-----------------------------------------------------------------------------------------

-- Init and return the module
initModule()
return javalex
