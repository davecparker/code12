-----------------------------------------------------------------------------------------
--
-- javalex.lua
--
-- Implements lexical analysis for Java
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules
local err = require( "err" )


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
--    nil if not reserved word, or not treated as a reserved word.
-- The following reserved words (primitive types) are treated as normal IDs:
--    byte, boolean, char, double, float, int, long, short
local reservedWordTokens = {
	["abstract"]		= false,	
	["assert"] 			= false,	
	["break"] 			= "break",	
	["case"] 			= false,
	["catch"] 			= false,	
	["class"] 			= "class",	
	["const"] 			= "const",	
	["continue"] 		= false,
	["default"] 		= false,
	["do"] 				= "do",	
	["else"] 			= "else",	
	["enum"] 			= false,	
	["extends"] 		= "extends",	
	["final"] 			= "final",	
	["finally"] 		= false,	
	["for"] 			= "for",	
	["goto"] 			= false,	
	["if"] 				= "if",
	["implements"] 		= false,	
	["import"] 			= "import",	
	["instanceof"] 		= false,	
	["interface"] 		= false,	
	["native"] 			= false,	
	["new"] 			= "new",	
	["package"] 		= false,	
	["private"] 		= false,	
	["protected"] 		= false,
	["public"] 			= "public",	
	["return"] 			= "return",	
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
local lineNumber        -- the line number for the source string
local iChar     		-- index to current char in chars
local commentLevel		-- current nesting level for block comments (/* */)


----- Token scanning functions ------------------------------------------------

-- Token scanning functions return one of:
--     A single string for simple tokens, which is both the tt and str of the token
--     (tt, str) for ID, literals, etc.
--     nil for an error and the error state is set


-- Set the error state using the the current lineNumber, the given char index range,
-- and strErr plus any additional arguments for string.format( strErr, ... )
local function setTokenErr( iCharFirst, iCharLast, strErr, ... )
	local locStart = err.makeSrcLoc( lineNumber, iCharFirst )
	local locEnd = err.makeSrcLoc( lineNumber, iCharLast )
	err.setErr( err.makeErrLoc( locStart, locEnd ), nil, strErr, ... )
end

-- Set the error state for an invalid character, and return nil.
local function invalidCharToken()
	setTokenErr( iChar, iChar, "Invalid character" )
	return nil
end

-- Set the error state for an invalid $ char, and return nil.
local function invalidDollarSign()
	setTokenErr( iChar, iChar, "The $ character is not allowed in Code12" )
	return nil
end

-- Set the error state for invalid use of ? or :, and return nil.
local function invalidTernaryToken()
	setTokenErr( iChar, iChar, "Invalid character (The \"? :\" operator is not supported by Code12)")
	return nil
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
	elseif charNext == 43 then  --  +
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

-- Set the error state for the beginning of a char literal token
-- (not supported in Code12), and return nil.
local function charLiteralToken()
	setTokenErr( iChar, iChar, "char type not supported, use double quotes" )
	return nil
end

-- Return ("STR", str) for a string literal token.
-- The str includes the double quotes.
-- Return nil and set the error state if the literal is unclosed by the end of line.
local function stringLiteralToken()
	local iCharStart = iChar    -- the double quote
	iChar = iChar + 1
	local charNext = chars[iChar]
	while charNext ~= 34 do   -- "
		if charNext == nil then
			setTokenErr( iCharStart, iChar - 1, "Unclosed string literal" )
			return nil
		elseif charNext == 92 then   -- \
			iChar = iChar + 1 -- check next char for supported escape sequence
			charNext = chars[iChar]
			if charNext ~= 34 and charNext ~= 92 and charNext ~= 110 and charNext ~= 116 then -- " \ n t
				setTokenErr( iChar - 1, iChar, "Unsupported or illegal escape sequence" )
			return nil
			end
		end
		iChar = iChar + 1
		charNext = chars[iChar]
	end
	local str = string.sub(source, iCharStart, iChar)
	iChar = iChar + 1
	return "STR", str
end

-- Return ("NUM", str) for a numeric literal token starting with a digit
local function numericLiteralToken(startsWithDot)
	local iCharStart = iChar   -- the first digit char or . if startsWithDot == true
	iChar = iChar + 1
	local charType = charTypes[chars[iChar]]
	while charType == false do   -- digit chars 
		iChar = iChar + 1
		charType = charTypes[chars[iChar]]
	end
	if not startsWithDot and chars[iChar] == 46 then  -- .
		repeat
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		until charType ~= false    -- digit chars past decimal point
	end
	-- Handle exponential notation
	local ch = chars[iChar]
	if ch == 69 or ch == 101 then -- E or e
		iChar = iChar + 1
		ch = chars[iChar]
		if ch == 43 or ch == 45 then -- + or -
			iChar = iChar + 1
			ch = chars[iChar]
		end
		charType = charTypes[ch]
		if charType ~= false then
			setTokenErr( iCharStart, iChar, "Invalid exponential notation" )
			return nil
		end
		repeat
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		until charType ~= false -- digit chars of exponent
	end
	local str = string.sub(source, iCharStart, iChar - 1)
	return "NUM", str
end

-- Return string for token starting with .  (. or numeric literal token starting with a dot)
local function  dotToken()
	local charType = charTypes[chars[iChar + 1]]
	if charType == false then   -- digit char
		return numericLiteralToken(true)
	end
	iChar = iChar + 1
	return "."
end

----- Module functions -------------------------------------------------------

-- Init the state of the lexer 
function javalex.init()
	-- We need to remember the nested block comment level across calls to getTokens
	commentLevel = 0
end

-- Return an array of tokens for the given source string and line number. 
-- Each token is a table with 4 fields named, for example: 
--     { tt = "ID", str = "foo", iLine = 10, iChar = 23 }
-- where iChar is the index of the start of the token in sourceStr, 
-- iLine is the given lineNum, str is the text of the token, 
-- and tt is a string that identifies the token type as follows:
--     Keywords, operators, and seperators have tt == str (e.g. "for", "++", ";")
--     "ID": an identifer that is not a reserved word
--     "NUM": numeric literal (any numeric type)
--     "STR": string literal (note that str includes the quotes)
--     "BOOL": boolean literal (str is "false" or "true")
--     "NULL": the null literal (str is "null")
--     "COMMENT": a comment (str is text of the comment not including the open/close)
--     "END": the end of the source string (str is empty string)
-- Return nil and set the error state if a token is malformed or illegal.
function javalex.getTokens( sourceStr, lineNum )
	-- Make array of ASCII codes for the source string
	source = sourceStr
	lineNumber = lineNum
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

		-- Make a token record  TODO: get from pool
		local token = { tt = "", str = "", iLine = lineNum, iChar = iChar }

		-- Determine what token type to build next
		if charType == true then    -- ID start char
			-- Identifier
			local iCharStart = iChar
			repeat
				iChar = iChar + 1
				charType = charTypes[chars[iChar]]
			until type(charType) ~= "boolean"    -- ID char
			local iCharEnd = iChar - 1
			local str = string.sub( source, iCharStart, iCharEnd )
			local tt = reservedWordTokens[str]
			if tt == nil then
				-- Not a reserved word, so user-defined ID
				token.tt = "ID"
				-- Code12 does not allow IDs to start with an understore
				if chars[iCharStart] == 95 then   -- _
					setTokenErr( iCharStart, iCharEnd, "Names cannot start with an underscore in Code12")
					return nil
				end
			elseif tt == false then
				-- Unsupported reserved word
				setTokenErr( iCharStart, iCharEnd, "Unsupported reserved word \"%s\"", str )
				return nil
			else
				token.tt = tt   -- reserved word
			end
			token.str = str
		elseif charType == false then   -- numeric 0-9
			-- Number constant
			token.tt, token.str = numericLiteralToken()
			if token.tt == nil then
				return nil
			end
		elseif charType == nil then
			-- End of source string
			token.tt = "END"
			token.str = ""
			 -- We're done, so add this last token and return tokens array
			tokens[#tokens + 1] = token
			return tokens 
		elseif type(charType) == "function" then
			-- Possible multi-char token, or char or string literal
			local tt, str = charType()   -- tt, (tt, str) or (nil, errRecord)
			if tt == nil then 
				return nil   -- token error (e.g. unclosed string literal)
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
	charTypes[36] = invalidDollarSign   -- $  (not allowed in Code12)
	charTypes[95] = true                -- _  (will be allowed only if not start char)

	-- Quotes
	charTypes[39] = charLiteralToken      -- '
	charTypes[34] = stringLiteralToken    -- "

	-- Chars that are always single-char tokens
	charTypes[59] = ";"
	charTypes[44] = ","
	charTypes[40] = "("
	charTypes[41] = ")"
	charTypes[123] = "{"
	charTypes[125] = "}"
	charTypes[91] = "["
	charTypes[93] = "]"
	charTypes[126] = "~"
	charTypes[58] = ":"
	charTypes[63] = invalidTernaryToken   -- (?)  ?: is not supported

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
    charTypes[46] = dotToken
end

-- Init the module
local function initModule()
	initCharTypes()
end


-----------------------------------------------------------------------------------------

-- Init and return the module
initModule()
return javalex
