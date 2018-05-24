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

-- Reserved word tokens: indexed by string, maps to:
--    string (token tt) if reserved word supported by Code12
--    false if reserved word not supported by Code12
--    nil if not reserved word
local reservedWordTokens = {
	["abstract"]		= false,	
	["assert"] 			= false,	
	["boolean"] 		= "boolean",	
	["break"] 			= "break",	
	["byte"] 			= false,	
	["case"] 			= false,
	["catch"] 			= false,	
	["char"] 			= false,	
	["class"] 			= "class",	
	["const"] 			= "const",	
	["continue"] 		= "continue",	
	["default"] 		= false,
	["do"] 				= "do",	
	["double"] 			= "double",	
	["else"] 			= "else",	
	["enum"] 			= false,	
	["extends"] 		= "extends",	
	["final"] 			= "final",	
	["finally"] 		= false,	
	["float"] 			= false,	
	["for"] 			= "for",	
	["goto"] 			= false,	
	["if"] 				= "if",
	["implements"] 		= false,	
	["import"] 			= "import",	
	["instanceof"] 		= false,	
	["int"] 			= "int",	
	["interface"] 		= false,	
	["long"] 			= false,
	["native"] 			= false,	
	["new"] 			= false,	
	["package"] 		= false,	
	["private"] 		= false,	
	["protected"] 		= false,
	["public"] 			= "public",	
	["return"] 			= "return",	
	["short"] 			= false,	
	["static"] 			= "static",	
	["strictfp"]	 	= false,	
	["super"] 			= false,
	["switch"] 			= false,	
	["synchronized"] 	= false,	
	["this"] 			= false,	
	["throw"] 			= false,	
	["throws"] 			= false,	
	["transient"] 		= false,
	["try"] 			= false,	
	["void"] 			= "void",	
	["volatile"] 		= false,	
	["while"] 			= "while",

	-- These reserved words are actually special literals
	["true"] 			= "BOOL",	
	["false"] 			= "BOOL",
	["null"] 			= "NULL",
}

-- State for the lexer used by token scanning functions
local source    		-- the source string
local chars     		-- array of ASCII codes for the source string
local iChar     		-- index to current char in chars
local commentLevel		-- current nesting level for block comments (/* */)


----- Token scanning functions ------------------------------------------------

-- Return (nil, strError) for an invalid character
local function invalidCharToken()
	local strErr = "Invalid character code " .. chars[iChar]
	return nil, strErr
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

-- Read through a block comment (/*  */), handling nesting.
-- The current comment level is tracked in commentLevel.
-- Before the initial call to this function, commentLevel should
-- be set to 1 and iChar should be just past the initial /*
-- Return the index of the last char in the comment.
local function skipBlockComment()
	while true do
		local ch = chars[iChar]
		if ch == 42 and chars[iChar + 1] == 47 then  -- */
			iChar = iChar + 2
			commentLevel = commentLevel - 1
			if commentLevel == 0 then
				return iChar - 3
			end
		elseif ch == 47 and chars[iChar + 1] == 42 then  -- /*
			iChar = iChar + 2
			commentLevel = commentLevel + 1
		elseif ch == nil then
			return iChar - 1  -- unclosed comment continues to next line
		else
			iChar = iChar + 1
		end
	end	
end

-- Return string for token starting with /  (/  /=)
-- or ("COMMENT", str) for a comment (either block or to end of line)
local function slashToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 47 then   --  /
		-- Comment to end of line
		local str = string.sub( source, iChar + 1 )
		iChar = #chars + 1
		return "COMMENT", str
	elseif charNext == 42 then  -- *
		-- Block comment
		iChar = iChar + 1
		local iCharStart = iChar
		commentLevel = 1
		local iCharEnd = skipBlockComment()
		return "COMMENT", string.sub( source, iCharStart, iCharEnd )
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
-- Return (nil, strErr) if the literal is invalid.
local function charLiteralToken()
	local iCharStart = iChar   -- the single quote
	iChar = iChar + 1
	local charNext = chars[iChar]
	-- TODO: if charNext == 92 then   --  \
	iChar = iChar + 1
	local str = string.sub(source, iCharStart, iChar)
	if chars[iChar] ~= 39 then
		return nil, "Invalid character literal"
	end
	iChar = iChar + 1
	return "CHAR", str
end

-- Return ("STR", str) for a string literal token.
-- The str includes the double quotes.
-- Return (nil, strErr) if the literal is unclosed by the end of line.
local function stringLiteralToken()
	local iCharStart = iChar    -- the double quote
	iChar = iChar + 1
	local charNext = chars[iChar]
	while charNext ~= 34 do   -- "
		-- TODO: if charText == 92 then   -- \
		if charNext == nil then
			iChar = iCharStart
			return nil, "Unclosed string literal"
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

-- Init the state of the lexer 
function javalex.init()
	-- We need to remember the nested block comment level across calls to getTokens
	commentLevel = 0
end

-- Return an array of tokens for the given source string. 
-- Each token is a table with 3 fields named, for example: 
--     { tt = "ID", str = "foo", iChar = 23 }
-- where iChar is the index of the start of the token in sourceStr, str is the 
-- text of the token, and tt is a string that identifies the token type as follows:
--     Keywords, operators, and seperators have tt == str (e.g. "for", "++", ";")
--     "ID": an identifer that is not a reserved word
--     "NUM": numeric literal (any numeric type)
--     "STR": string literal (note that str includes the quotes)
--     "CHAR": char literal (note that str includes the quotes)
--     "BOOL": boolean literal (str is "false" or "true")
--     "NULL": the null literal (str is "null")
--     "COMMENT": a comment (str is text of the comment not including the open/close)
--     "END": the end of the source string
-- Return (nil, strErr, iChar) if a token is malformed. 
function javalex.getTokens(sourceStr)
	-- Make array of ASCII codes for the source string
	source = sourceStr
	chars = { string.byte(source, 1, string.len(source)) }   -- supposedly faster than a loop
	iChar = 1

	-- Init array of tokens to return
	local tokens = {}

	-- Are we inside a block comment that started on a previous line?
	if commentLevel > 0 then
		skipBlockComment()  -- don't generate COMMENT tokens for multi-line comments 
	end

	-- Scan the chars array
	repeat
		-- Skip whitespace
		local charType = charTypes[chars[iChar]]
		while charType == " " do
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		end

		-- Make a token table  TODO: get from pool
		local token = { tt = "", str = "", iChar = iChar }

		-- Determine what token type to build next
		if charType == true then    -- ID start char
			-- Identifier
			local iCharStart = iChar
			repeat
				iChar = iChar + 1
				charType = charTypes[chars[iChar]]
			until type(charType) ~= "boolean"    -- ID char
			local str = string.sub(source, iCharStart, iChar - 1)
			local tt = reservedWordTokens[str]
			if tt == nil then
				token.tt = "ID"   -- not a reserved word
			elseif tt == false then
				local strErr = "Unsupported reserved word \"" .. str .. "\""
				return nil, strErr, iCharStart   -- unsupported reserved word
			else
				token.tt = tt
			end
			token.str = str
		elseif charType == false then   -- numeric 0-9
			-- Number constant
			token.tt, token.str = numericLiteralToken()
		elseif charType == nil then
			-- End of source string
			token.tt = "END"
			token.str = ""
			 -- We're done, so add this last token and return tokens array
			tokens[#tokens + 1] = token
			return tokens 
		elseif type(charType) == "function" then
			-- Possible multi-char token, or char or string literal
			local tt, str = charType()   -- token scanning function returns tt, str
			if tt == nil then 
				return nil, str, iChar   -- token error (e.g. unclosed string literal)
			end
			token.tt = tt
			token.str = str or tt    -- simple tokens are their own string
		else
			-- Single char token
			iChar = iChar + 1
			token.tt = charType    -- single char string
			token.str = charType   -- simple tokens are their own string
		end 

		-- Add token to tokens array
		tokens[#tokens + 1] = token
	until false   -- returns internally when end of string is found
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
