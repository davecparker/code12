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

-- Reserved/known word tokens: indexed by string name, maps to:
--    the token tt (a string) if reserved word or type known by Code12,
--    false if reserved word not supported by Code12,
--    nil if not reserved word, or not treated as a reserved word.
local ttForKnownName = {
	["abstract"]		= false,	
	["assert"] 			= false,	
	["boolean"]			= "TYPE",	
	["break"] 			= "break",
	["byte"]			= "TYPE",	
	["case"] 			= false,
	["catch"] 			= false,	
	["char"]			= "TYPE",	
	["class"] 			= "class",	
	["const"] 			= "const",	
	["continue"] 		= false,
	["default"] 		= false,
	["do"] 				= "do",	
	["double"]			= "TYPE",	
	["else"] 			= "else",	
	["enum"] 			= false,	
	["extends"] 		= "extends",	
	["false"] 			= "BOOL",
	["final"] 			= "final",	
	["finally"] 		= false,	
	["float"]			= "TYPE",	
	["for"] 			= "for",	
	["goto"] 			= false,	
	["if"] 				= "if",
	["implements"] 		= false,	
	["import"] 			= "import",	
	["instanceof"] 		= false,	
	["int"]				= "TYPE",	
	["interface"] 		= false,	
	["long"]			= "TYPE",	
	["native"] 			= false,	
	["new"] 			= "new",	
	["null"] 			= "NULL",
	["package"] 		= false,	
	["private"] 		= "private",	
	["protected"] 		= false,
	["public"] 			= "public",	
	["return"] 			= "return",	
	["short"]			= "TYPE",	
	["static"] 			= "static",	
	["strictfp"]	 	= false,	
	["super"] 			= false,
	["switch"] 			= false,	
	["synchronized"] 	= false,	
	["this"] 			= false,	
	["throw"] 			= false,	
	["throws"] 			= false,	
	["transient"] 		= false,
	["true"] 			= "BOOL",	
	["try"] 			= false,	
	["void"]			= "void",	
	["volatile"] 		= false,	
	["while"] 			= "while",

	-- The following classes are also recognized as defined types.
	["GameObj"] 		= "TYPE",
	["String"] 			= "TYPE",
	["Object"]			= "TYPE",

	-- These classes are treated as reserved words so they parse distinctly.
	["ct"] 				= "ct",
	["System"] 			= "System",
	["Math"] 			= "Math",

	-- Pre-defined Code12 classes that we don't want redefined
	["Code12"]          = "ID",
	["Code12Program"]   = "ID",

	-- Standard Java classes in java.lang that we don't want redefined.
	["Character"]		= "ID",      
	["Integer"]			= "ID",        
	["Number"]			= "ID",         
	["Runtime"]			= "ID",        
	["Throwable"]		= "ID",

	-- Lowercase versions of the above class names scan as IDs
	-- but are here for use by javalex.knownName()
	["gameobj"] 		= "ID",
	["string"] 			= "ID",
	["object"]			= "ID",         
	["system"] 			= "ID",
	["math"] 			= "ID",
	["code12"]          = "ID",
	["code12program"]   = "ID",
	["character"]		= "ID",      
	["integer"]			= "ID",        
	["number"]			= "ID",         
	["runtime"]			= "ID",        
	["throwable"]		= "ID",
}

-- The correct case for mixed-case known IDs above
local correctCaseForLowercaseName = {
	-- Names used by Code12
	["gameobj"]			= "GameObj",
	["string"] 			= "String",
	["system"] 			= "System",
	["math"] 			= "Math",
	["code12"]          = "Code12",
	["code12program"]   = "Code12Program",
	["character"]		= "Character",      
	["integer"]			= "Integer",        
	["number"]			= "Number",         
	["object"]			= "Object",         
	["runtime"]			= "Runtime",        
	["throwable"]		= "Throwable",      
} 

-- State for the lexer used by token scanning functions
local source    		   -- the source string
local chars     		   -- array of ASCII codes for the source string
local lineNumber           -- the line number for the source string
local iChar     		   -- index to current char in chars
local iLineBlockComment    -- line number for start of block comment (/* */) or nil if none
local commentForLine       -- array of end-of-line comments indexed by line number
local indentLevelForLine   -- array of indent levels indexed by line number
local prevIndentStr        -- previous (non blank/comment) line of code's indent string
local prevLineNumber       -- previous (non blank/comment) line of code's line number


----- Token scanning functions ------------------------------------------------

-- Token scanning functions return one of:
--     A single string for simple tokens, which is both the tt and str of the token
--     (tt, str) for ID, literals, etc.
--     nil for an error and the error state is set


-- Set the error state using the the current lineNumber, the given char index range,
-- and strErr plus any additional arguments for string.format( strErr, ... )
local function setTokenErr( iCharFirst, iCharLast, strErr, ... )
	err.setErrCharRange( lineNumber, iCharFirst, iCharLast, strErr, ... )
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
	elseif charNext == 60 then  --  <
		setTokenErr( iChar - 1, iChar, "Invalid operator. Did you mean <= ?" )
		return nil
	elseif charNext == 62 then  --  >
		setTokenErr( iChar - 1, iChar, "Invalid operator. Did you mean >= ?" )
		return nil
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
	elseif charNext == 47 then  -- /
		setTokenErr( iChar - 1, iChar, 
				"Close of comment without matching opening /*" )
		return nil
	end
	return "*"
end

-- Read through a block comment (/*  */), disallowing nesting per Java.
-- If the comment is closed on this line then set iLineBlockComment = nil.
-- Return false if an error is encountered, else true.
local function skipBlockComment()
	assert( iLineBlockComment )
	while true do
		local ch = chars[iChar]
		if ch == 42 and chars[iChar + 1] == 47 then  -- */
			iChar = iChar + 2
			iLineBlockComment = nil   -- comment closed
			return
		elseif ch == 47 and chars[iChar + 1] == 42 then  -- /*
			err.setErrLineNumAndRefLineNum( lineNumber, iLineBlockComment, 
					"Java does not allow nesting comments within comments using /* */" )
			iChar = iChar + 2   -- pass the 2nd /* and keep going per Java
		elseif ch == nil then
			return    -- unclosed comment continues to next line
		else
			iChar = iChar + 1
		end
	end	
end

-- Return string for token starting with /  (/  /=)
-- or ("COMMENT", str) for a comment to end of line, 
-- or just "COMMENT" for a block comment.
local function slashToken()
	iChar = iChar + 1
	local charNext = chars[iChar]
	if charNext == 47 then   --  /
		-- Comment to end of line
		local str = string.sub( source, iChar + 1 )
		iChar = #chars + 1
		return "COMMENT", str
	elseif charNext == 42 then  -- *
		-- Start of block comment
		iChar = iChar + 1
		iLineBlockComment = lineNumber
		skipBlockComment()
		return "COMMENT"
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

-- Return ("INT", str) for an integer literal token starting with a digit
-- or ("NUM", str) if the number contains a decimal point or exponential notation.
local function numericLiteralToken( startsWithDot )
	local isNUM = startsWithDot
	local iCharStart = iChar   -- the first digit char or . if startsWithDot == true
	iChar = iChar + 1
	local charType = charTypes[chars[iChar]]
	while charType == false do   -- digit chars 
		iChar = iChar + 1
		charType = charTypes[chars[iChar]]
	end
	if not startsWithDot and chars[iChar] == 46 then  -- .
		isNUM = true
		repeat
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		until charType ~= false    -- digit chars past decimal point
	end
	-- Handle exponential notation
	local ch = chars[iChar]
	if ch == 69 or ch == 101 then -- E or e
		isNUM = true
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
	elseif charTypes[ch] == true then 
		-- Error: number immediately followed by a letter, e.g. 123a, 123abc, 123i45
		repeat   -- get to the end of the string of ID chars
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		until type(charType) ~= "boolean"
		setTokenErr( iCharStart, iChar - 1, "This is not a valid number or name" )
		return nil
	end
	local str = string.sub(source, iCharStart, iChar - 1)
	if isNUM then
		return "NUM", str
	end
	return "INT", str
end

-- Return string for token starting with .  
-- (dot or a numeric literal token starting with a dot)
local function dotToken()
	if charTypes[chars[iChar + 1]] == false then   -- digit char after dot
		return numericLiteralToken( true )
	end
	iChar = iChar + 1
	return "."
end

-- Determine and store the indentation level of source and check for consistent use of tabs and spaces
local function checkIndentation( tokens )
	if #tokens == 0 then
		-- set indent for this line to 0
		indentLevelForLine[lineNumber] = 0
	else
		-- determine indent
		local indLvl = tokens[1].iChar - 1
		-- store indent level
		indentLevelForLine[lineNumber] = indLvl
		local indentStr = string.sub( source, 1, indLvl )
		-- check inconsistent indent
		if prevIndentStr then
			local prevIndLvl = indentLevelForLine[prevLineNumber]
			if indLvl == prevIndLvl and indentStr ~= prevIndentStr
					or indLvl > prevIndLvl and string.sub( indentStr, 1, prevIndLvl ) ~= prevIndentStr
					or indLvl < prevIndLvl and string.sub( prevIndentStr, 1, indLvl ) ~= indentStr then
				err.setErr( { iLine = lineNumber }, { iLine = prevLineNumber }, 
						"Mix of tabs and spaces used for indentation is not consistent with the previous line of code" )
			end
		end
		-- save prev indent
		prevIndentStr = indentStr
		prevLineNumber = lineNumber
	end
end


----- Module functions -------------------------------------------------------

-- Init the state of the lexer for a program
function javalex.initProgram()
	iLineBlockComment = nil
	commentForLine = {}
	indentLevelForLine = {}
	prevIndentStr = nil
	prevLineNumber = nil
end

-- Return an array of tokens for the given source string and line number. 
-- Each token is a table with 4 fields named, for example: 
--     { tt = "ID", str = "foo", iLine = 10, iChar = 23 }
-- where iChar is the index of the start of the token in sourceStr, 
-- iLine is the given lineNum, str is the text of the token, 
-- and tt is a string that identifies the token type as follows:
--     Keywords, operators, and seperators have tt == str (e.g. "for", "++", ";")
--     "TYPE": a known Java primitive type or class used by Code12
--     "ID": an identifer that is not a reserved word
--     "INT": integer literal
--     "NUM": non-integer numeric literal (has decimal or E notation)
--     "STR": string literal (note that str includes the quotes)
--     "BOOL": boolean literal (str is "false" or "true")
--     "NULL": the null literal (str is "null")
--     "COMMENT": a comment (str is comment text if to end of line, else nil)
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
	if iLineBlockComment then
		skipBlockComment()
	end

	-- Scan the chars array
	repeat
		-- Skip whitespace
		local charType = charTypes[chars[iChar]]
		while charType == " " do
			iChar = iChar + 1
			charType = charTypes[chars[iChar]]
		end

		-- Determine what token type to build next
		local iCharStart = iChar
		if charType == true then    -- ID start char
			-- Identifier or reserved/known word
			repeat
				iChar = iChar + 1
				charType = charTypes[chars[iChar]]
			until type(charType) ~= "boolean"    -- ID char
			local iCharEnd = iChar - 1
			local str = string.sub( source, iCharStart, iCharEnd )
			local tt = ttForKnownName[str]
			if tt == nil then
				-- Not a known word, so user-defined ID
				tt = "ID"
				-- Code12 does not allow IDs to start with an understore
				if chars[iCharStart] == 95 then   -- _
					setTokenErr( iCharStart, iCharEnd, 
							"Names cannot start with an underscore in Code12")
					return nil
				end
			elseif tt == false then
				-- Unsupported reserved word
				setTokenErr( iCharStart, iCharEnd, 
						"Unsupported reserved word \"%s\"", str )
				return nil
			end
			tokens[#tokens + 1] = { tt = tt, str = str, 
					iLine = lineNum, iChar = iCharStart }
		elseif charType == false then   -- numeric 0-9
			-- Number constant
			local tt, str = numericLiteralToken()
			if tt == nil then
				return nil
			end
			tokens[#tokens + 1] = { tt = tt, str = str, 
					iLine = lineNum, iChar = iCharStart }
		elseif charType == nil then
			-- End of source string
			checkIndentation( tokens )
			tokens[#tokens + 1] = { tt = "END", str = " ", 
					iLine = lineNum, iChar = iCharStart }
			return tokens 
		elseif type(charType) == "function" then
			-- Possible multi-char token, char or string literal, or comment
			local tt, str = charType()   -- tt, (tt, str) or (nil, errRecord)
			if tt == nil then 
				return nil   -- token error (e.g. unclosed string literal)
			elseif tt == "COMMENT" then
				-- Remember text for end-of-line comments (discard block comments)
				commentForLine[lineNum] = str
			else
				tokens[#tokens + 1] = { tt = tt, str = str or tt, 
						iLine = lineNum, iChar = iCharStart }
			end
		else
			-- Single char token
			iChar = iChar + 1
			tokens[#tokens + 1] = { tt = charType, str = charType, 
					iLine = lineNum, iChar = iCharStart }
		end 
	until false   -- returns internally when end of string is found
end

-- If nameStr matches a known pre-defined reserved word, type, class, constant
-- or special ID, ignoring case, then return (tt, strCorrectCase, strUsage),
-- where tt is the token type, strCorrectCase is the correct case for nameStr,
-- and usage is a description of the type of word (e.g. "type name").
-- If there is no match then return (nil, nameStr, nil).
function javalex.knownName( nameStr )
	local nameLower = string.lower( nameStr )
	local tt = ttForKnownName[nameLower]
	if tt == nil then
		return nil, nameStr, nil   -- no match
	end
	local strCorrectCase = correctCaseForLowercaseName[nameLower] or nameLower
	tt = ttForKnownName[strCorrectCase]

	local usage
	if tt == "TYPE" then
		usage = "type name"
	elseif tt == "ID" and (strCorrectCase == "Code12" or strCorrectCase == "Code12Program") then
		usage = "Code12 reserved class name"
	elseif tt == "ID" or strCorrectCase == "Math" then
		usage = "Java class name"
	elseif tt == "BOOL" or tt == "NULL" then
		usage = "constant"
	elseif tt == false then
		usage = "Unsupported Java reserved word"
	else
		usage = "Reserved word"
	end
	return tt, strCorrectCase, usage
end 

-- Return the comment string at the end of the given line number or nil if none
function javalex.commentForLine( lineNum )
	return commentForLine[lineNum]
end

-- Return the indent level of the given line number in number of spaces,
-- assuming a tab stop of 8 spaces
function javalex.indentLevelForLine( lineNum )
	return indentLevelForLine[lineNum]
end

-- If the parsing state is inside an unclosed block comment then return the 
-- line number where the comment started, otherwise return nil.
function javalex.iLineStartOfUnclosedBlockComment()
	return iLineBlockComment
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
