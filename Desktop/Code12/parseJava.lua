-----------------------------------------------------------------------------------------
--
-- parseJava.lua
--
-- Implements parsing for Java in the Code12 system.
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------

-- Code12 modules used
local app = require( "app" )
local source = require( "source" )
local err = require( "err" )
local javalex = require( "javalex" )
local javaTypes = require( "javaTypes" )


-- The parseJava module
local parseJava = {}


----- File Local Variables  --------------------------------------------------

-- Language feature names introduced at each syntax level
local syntaxFeatures = {
	--[[ 1 ]]   "function calls",
	--[[ 2 ]]   "comments",        -- actually allowed at all levels
	--[[ 3 ]]   "variables",
	--[[ 4 ]]   "expressions",
	--[[ 5 ]]   "function return values",
	--[[ 6 ]]   "if-else statements",
	--[[ 7 ]]   "object data fields",
	--[[ 8 ]]   "object method calls",
	--[[ 9 ]]   "user-defined functions",
	--[[ 10 ]]  "parameters in user-defined functions",
	--[[ 11 ]]  "loops",
	--[[ 12 ]]  "arrays",
}
local numSyntaxLevels = #syntaxFeatures

-- The parsing state
local lineNumber          -- the line number for the line being parsed
local tokens              -- array of tokens
local iToken              -- index of current token in tokens
local syntaxLevel         -- the syntax level for parsing
local matchCommonErrors   -- true to consider common error patterns

-- State for attempting to locate syntax errors
local findError           -- nil if not trying to find errors, or a table with:
-- {
--     lineOrStmtPattern = p,   -- current line or stmt pattern being parsed
--     iTokenMax = iToken,      -- token index of farthest successful partial parse
--     parses = array of:       -- for each partial parse that reached iTokenMax
--         {
--             stmtPattern = p,    -- the line or stmt pattern for this parse
--             ttExpected = tt,    -- the token type expected
--         }
-- }        

-- Forward function declarations necessary due to mutual recursion or 
-- use in the grammar tables below
local parseGrammar
local parsePattern
local primaryExpr
local lValueFull


----- Debugging help -------------------------------------------------------

-- Set these variables to get trace output while parsing
local printTrace = false;    -- set to true for trace output
local iLineTrace = nil;      -- set to a line number to trace just that line

-- Indent level for trace output
local traceIndentLevel = 0

-- Debug trace
local function trace( message )
	if printTrace and (iLineTrace == nil or iLineTrace == lineNumber) then
		print( string.rep( "\t", traceIndentLevel ) .. message )
	end
end


----- Misc Tables ---------------------------------------------------------

-- Operator precedence for binary operators: map operator text to precedence.
-- From: https://introcs.cs.princeton.edu/java/11precedence/
-- Operators not included are either parsed elsewhere or not considered 
-- expression-returning operators in Code12 (e.g. ++, +=). 
-- Note that all supported operators are left associative, and 
-- all unary operators have higher precedence than any of these.
local binaryOpPrecedence = {
	["*"]	= 12,
	["/"]	= 12,
	["%"]	= 12,
	["+"]	= 11,
	["-"]	= 11,
	["<<"]	= 10,
	[">>"]	= 10,
	[">>>"]	= 10,
	["<"]	= 9,
	["<="]	= 9,
	[">"]	= 9,
	[">="]	= 9,
	["=="]	= 8,
	["="]   = 8,  -- parse as alias for == then give error later
	["!="]	= 8,
	["&"]	= 7,
	["^"]	= 6,
	["|"]	= 5,
	["&&"]	= 4,
	["||"]	= 3,
	["?"]	= 2,
}

-- Description strings for various token types (map tt to string)
local strDescriptionForTokenType = {
	["ID"]    = "a name",
	["TYPE"]  = "a type",
	["INT"]   = "a number",
	["NUM"]   = "a number",
	["STR"]   = "a string",
	["BOOL"]  = "a boolean constant",
	["NULL"]  = "null",
	["END"]   = "end of line",
	[","]     = "a comma",
	["."]     = "a dot",
	[";"]     = "a semicolon",
}

----- Parsing Utilities  --------------------------------------------------

-- Return a description of the given token type for syntax errors
local function tokenTypeDescription( tt )
	return strDescriptionForTokenType[tt] or ("\"" .. tt .. "\"")
end	

-- Return a description of the given token for syntax errors
local function tokenDescription( token )
	local tt = token.tt
	if tt == "BOOL" then
		return "\"" .. token.str .. "\""   -- "true", "false"
	end
	return tokenTypeDescription( tt )
end	

-- Update the findError tracking state for an unexpected token at the current
-- parse location when type ttExpected was expected.
local function possibleExpectedToken( ttExpected )
	if findError then
		local iTokenMax = findError.iTokenMax or 0
		if iToken >= iTokenMax then
			local token = tokens[iToken] or tokens[#tokens]   -- use END if past end
			err.clearErr( lineNumber )   -- replace previous error on this line if any
			if iToken > iTokenMax then
				-- This partial parse made it the farthest so far
				findError.iTokenMax = iToken
				findError.parses = { {    -- first parses entry out this far
					stmtPattern = findError.lineOrStmtPattern,
					ttExpected = ttExpected 
				} }
				err.setErrNode( token, "Syntax Error: expected %s",
						tokenTypeDescription( ttExpected ) )
			else
				-- This partial parse went to the same token we stopped at before
				findError.parses[#findError.parses + 1] = { 
					stmtPattern = findError.lineOrStmtPattern, 
					ttExpected = ttExpected 
				}
				err.setErrNode( token, "Syntax Error: %s was unexpected here",
						tokenDescription( token ) )
			end
			err.addDocLink( "Java.html" )
		end
	end
end

-- Set the error state for an invalid variable name node.  
local function invalidVarName( nameNode )
	parseJava.isInvalidID( nameNode, "variable" )
end

-- Set the error state for an invalid parameter name node.  
local function invalidParamName( nameNode )
	parseJava.isInvalidID( nameNode, "parameter" )
end

-- Set the error state for an invalid function name node.  (TODO)
-- local function invalidFuncName( nameNode )
-- 	parseJava.isInvalidID( nameNode, "function" )
-- end

-- Set the error state for an invalid type node.
local function invalidTypeName( node )
	if node.tt == "ID" then
		local strName = node.str
		local tt, strCorrectCase, usageFound = javalex.knownName( strName )
		if tt == "TYPE" then
			err.setErrNode( node, 'Incorrect case for type name "%s"', strCorrectCase )
		elseif tt ~= nil and strCorrectCase == strName then
			err.setErrNode( node, 
					"%s is a %s, expected a type name here", strName, usageFound )
		else
			err.setErrNode( node, "Unknown type name" )
		end
	else
		err.setErrNode( node, "Expected a type name here" )
	end
	err.addDocLink( "Java.html#java-data-types" )
end


----- Special parsing functions used in the grammar tables below  ------------

-- Unless otherwise specified, parsing functions parse the tokens array starting 
-- at iToken, considering only patterns that are defined within the syntaxLevel.
-- They return a parse tree, or nil if failure.

-- A parse tree is either:
-- 		a token node, for example:
--          { tt = "ID", str = "foo", iLine = 10, iChar = 23 }
--      or a tree node, for example:
--          { t = "line", p = "stmt", nodes = {...} }
--      where t is the grammar or function name, p is the pattern name if any,
--		and nodes is an array of children nodes.


-- Parse the primaryExpr grammar plus single token literals (optimization)
local function parsePrimaryExpr()
	local token = tokens[iToken]
	local vt = javaTypes.vtFromTokenType( token.tt )
	if vt ~= nil then   -- literal token node
		iToken = iToken + 1
		token.vt = vt   -- assign the vt here so semantic checking doesn't have to
		return token    -- expr node can also be a single literal token node
	end
	if findError then
		possibleExpectedToken( "INT" )
		possibleExpectedToken( "NUM" )
		possibleExpectedToken( "BOOL" )
		possibleExpectedToken( "STR" )
		possibleExpectedToken( "NULL" )
	end
	return parseGrammar( primaryExpr )
end

-- Parse the rest of an expression after leftSide using Precedence Climbing.
-- See https://en.wikipedia.org/wiki/Operator-precedence_parser
local function parseOpExpr( leftSide, minPrecedence )
	-- Check for binary operator
	local token = tokens[iToken]
	local prec = binaryOpPrecedence[token.tt]
	-- Build nodes and recurse in the correct direction depending on prec
	while prec and prec >= minPrecedence do
		local op = token   -- the binary op
		local opPrec = prec
		iToken = iToken + 1
		local rightSide = parsePrimaryExpr()
		if rightSide == nil then
			err.setErrNodeAndRef( tokens[iToken], op,
					"Expected expression after %s operator", op.str )
			err.addDocLink( "Java.html#expressions" )
			return nil
		end
		-- Check for another op after this op's expr and compare precedence
		token = tokens[iToken]
		prec = binaryOpPrecedence[token.tt]
		while prec and prec > opPrec do
			-- Higher precedence op follows, so recurse to the right
			rightSide = parseOpExpr( rightSide, prec )
			if rightSide == nil then
				return nil  -- expected expression after binary op, err set above
			end
			-- Keep looking for the next op
			token = tokens[iToken]
			prec = binaryOpPrecedence[token.tt]
		end
		-- Build the node for this op
		leftSide = { t = "expr", p = op.tt, nodes = { leftSide, op, rightSide } }
		if rightSide.isError then
			leftSide.isError = true   -- propagate error up to parent
		end
	end
	return leftSide
end

-- Parse an expression 
local function expr()
	-- Start the recursive Precedence Climbing algorithm
	local leftSide = parsePrimaryExpr()
	if leftSide == nil then
		return nil
	elseif syntaxLevel < 4 or leftSide.isError then
		return leftSide
	end
	return parseOpExpr( leftSide, 0 )  -- include binary operators
end

-- Parse an access specifier (as a function for efficiency).
-- The resulting valid patterns are "public", "publicStatic",
-- "private", and false (empty).
local function access()
	local token = tokens[iToken]
	local tt = token.tt
	if tt == "public" then
		iToken = iToken + 1
		local token2 = tokens[iToken]
		if token2.tt == "static" then
			iToken = iToken + 1
			return { t = "access", p = "publicStatic", nodes = { token, token2 } }
		end
		return { t = "access", p = "public", nodes = { token } }
	elseif tt == "private" or tt == "protected" then
		iToken = iToken + 1
		return { t = "access", p = "private", nodes = { token } }
	end
	return false
end

-- Parse an lValue (as a function for efficiency).
-- The result may be a single ID node for a simple variable,
-- or an lValueFull.
local function lValue()
	-- Look for the required variable ID token
	local varToken = tokens[iToken]
	if varToken.tt ~= "ID" then
		possibleExpectedToken( "ID" )
		return nil
	end
	iToken = iToken + 1

	-- Check for index and/or field and re-parse as lValueFull if needed
	if syntaxLevel >= 7 then
		local tt = tokens[iToken].tt
		if tt == "." or tt == "[" then
			iToken = iToken - 1   -- start over with the variable ID
			return parseGrammar( lValueFull )
		end
	end
	return varToken
end


----- Grammar Tables ---------------------------------------------------------

-- An array index or empty
local index = { t = "index",
	{ 12, 12, "index",			"[", expr, "]"			},
	{ 1, 12, false										},
}

-- An field reference or empty
local field = { t = "field",
	{ 7, 12, "field",			".", "ID"				},
	{ 1, 12, false										},
}

-- An lValue (var or expr that can be assigned to)
-- An lValue can also be a single ID node, which is handled by lValue() above.
lValueFull = { t = "lValue",
	{ 3, 12, "lValue",			"ID", index, field		},
}

-- The start of a function call
local callHead = { t = "callHead",
	{ 1, 12, "ct",				"ct", ".", "ID", "("					},
	{ 1, 12, "System",			"System", ".", "ID", ".", "ID", "("		},
	{ 5, 12, "Math",			"Math", ".", "ID", "("					},
	{ 1, 7,  "unknown",         "ID", ".", "ID", "("                    },
	{ 1, 12, "user",			"ID", "("								},
	{ 8, 12, "method",			"ID", index, ".", "ID", field, "("		},
	-- Common Errors
	{ 8, 0, "method",			"TYPE", index, ".", "ID", field, "(",	iNode = 1,
		strErr = invalidVarName },
}

-- A return type for a function definition
local retType = { t = "retType",
	{ 1, 12, "void",			"void"						},
	{ 12, 12, "array",			"TYPE", "[", "]"			},
	{ 9, 12, "type",			"TYPE"						},
}

-- A formal parameter (in a function definition)
local param = { t = "param",
	{ 10, 12, "var",			"TYPE", "ID"				},
	{ 12, 12, "array",			"TYPE", "[", "]", "ID"		},
	-- Common Errors
	{ 9, 0, "var",				"TYPE", "ID",
			strErr = "" },   -- needs level 10
	{ 12, 0, "array",			"ID", "[", "]", "ID",		iNode = 1 },
	{ 10, 0, "var",				"ID", "ID",					iNode = 1,
			strErr = invalidTypeName },
	{ 10, 0, "var",				"TYPE", "TYPE",				iNode = 2,
			strErr = invalidParamName },
	{ 10, 0, "backwards",		"ID", "TYPE" },
	{ 10, 0, "type",			"TYPE" },
	{ 10, 0, "expr",			expr,
			strErr = "Parameters in a function definition should be a type followed by a name" },
}

-- A formal parameter list, which can be empty
local paramList = { t = "paramList",
	{ 9, 12, "list",			param,	list = true, 	 	},
	{ 1, 12, false											},
}

-- An identifier list (must have a least one)
local idList = { t = "idList",
	{ 3, 12, "list",			"ID",	list = true,  		},
	-- Common Errors
	{ 3, 0, "list",				"TYPE",	list = true,		iNode = 1,
			strErr = invalidVarName },
}

-- An expression list, which can be empty
local exprList = { t = "exprList",
	{ 1, 12, "list",			expr,	list = true,  		},
	{ 1, 12, false											},
}

-- An expression list, which must have at least one
local exprList1 = { t = "exprList1",
	{ 1, 12, "list",			expr,	list = true,  		},
}

-- A primary expression (no binary operators)
primaryExpr = { t = "expr",
	{ 5, 12, "call",			callHead, exprList, ")" 			},
	-- Common Error for call (must preceed lValue)
	{ 5, 0, "call",				callHead, exprList1, expr, 0,	iNode = 3, missing = true,
			strErr = "Function parameter values must be separated by commas" },
	-- More valid patterns
	{ 3, 12, "lValue",			lValue								},
	{ 4, 12, "cast",			"(", "TYPE", ")", parsePrimaryExpr	},
	{ 4, 12, "exprParens",		"(", expr, ")"						},
	{ 4, 12, "neg",				"-", parsePrimaryExpr 				},
	{ 4, 12, "not",				"!", parsePrimaryExpr 				},
	{ 5, 12, "Math",			"Math", ".", "ID"					},
	{ 12, 12, "newArray",		"new", "TYPE", "[", expr, "]"		},	
	{ 12, 12, "new",			"new", "ID", "(", exprList, ")"		},
	-- More Common Errors
	{ 12, 0, "new",				"new", "TYPE", "(", expr, ")",
			strErr = 'The syntax for a new array is "new type[count]"' },
	{ 12, 0, "new",				"new", "TYPE", "(", exprList, ")",
			strErr = "Code12 does not support creating objects with new" },
}

-- Shortcut "operate and assign" operators 
local opAssignOp = { t = "opAssignOp",
	{ 4, 12, "+=",				"+=",  		},
	{ 4, 12, "-=",				"-=",  		},
	{ 4, 12, "*=",				"*=",  		},
	{ 4, 12, "/=",				"/=",  		},
}

-- A simple statement
local stmt = { t = "stmt",
	{ 1, 12, "call",			callHead, exprList, ")" 			},
	{ 3, 12, "assign",			lValue, "=", expr 					},
	{ 4, 12, "opAssign",		lValue, opAssignOp, expr 			},
	{ 4, 12, "preInc",			"++", lValue 						},
	{ 4, 12, "preDec",			"--", lValue						},
	{ 4, 12, "postInc",			lValue, "++" 						},
	{ 4, 12, "postDec",			lValue, "--"						},
	-- Common Errors
	{ 1, 0, "call",				callHead, exprList1, expr, 0,	iNode = 3, missing = true,
			strErr = "Function parameter values must be separated by commas" },
}

-- The end of a while statement, either with a ; (for do-while) or not
local whileEnd = { t = "whileEnd",
	{ 11, 12, "doWhile",		")", ";"		},
	{ 11, 12, "while",			")"				},
}

-- The init part of a for loop
local forInit = { t = "forInit",
	{ 11, 12, "var",			"TYPE", "ID", "=", expr				},
	{ 11, 12, "stmt",			stmt								},
	{ 11, 12, false													},
}

-- The expr part of a for loop
local forExpr = { t = "forExpr",
	{ 11, 12, "expr",			expr		},
	{ 11, 12, false							},
}

-- The next part of a for loop
local forNext = { t = "forNext",
	{ 11, 12, "stmt",			stmt		},
	{ 11, 12, false							},
}

-- The control part of a for loop (inside the parens)
local forControl = { t = "forControl",
	{ 11, 12, "three",			forInit, ";", forExpr, ";", forNext			},
	{ 12, 12, "array",			"TYPE", "ID", ":", expr 					},
	-- Common Errors
	{ 11, 0, "three",			forInit, ",", 0,	 						iNode = 2 },
	{ 11, 0, "three",			forInit, ";", forExpr, ",", 0,				iNode = 4, 
			strErr = "for loop parts should be separated by semicolons (;)\nComma not supported" },
}

-- An array initializer
local arrayInit = { t = "arrayInit",
	{ 12, 12, "list", 			"{", exprList, "}"							},
	{ 12, 12, "expr", 			expr										},
}

-- An extends superclass or empty
local extends = { t = "extends",
	{ 1, 12, "extends",			"extends", "ID"				},
	{ 1, 12, false											},
}

-- A line of code
local line = { t = "line",
	{ 1, 12, "blank",																	"END" },
	{ 1, 12, "begin",			"{",													"END" },
	{ 1, 12, "end",				"}",													"END" },
	{ 1, 12, "stmt",			stmt, ";",												"END" },
	{ 3, 12, "varInit",			access, "TYPE", "ID", "=", expr, ";",					"END" },
	{ 3, 12, "varDecl",			access, "TYPE", idList, ";",							"END" },
	{ 3, 12, "constInit", 		access, "final", "TYPE", "ID", "=", expr, ";",			"END" },
	{ 1, 12, "func",			access, retType, "ID", "(", paramList, ")",				"END" },
	{ 6, 12, "if",				"if", "(", expr, ")",									"END" },
	{ 6, 12, "elseif",			"else", "if", "(", expr, ")",							"END" },
	{ 6, 12, "else",			"else", 												"END" },
	{ 9, 12, "returnVal",		"return", expr, ";",									"END" },
	{ 6, 12, "return",			"return", ";",											"END" },
	{ 11, 12, "do",				"do", 													"END" },
	{ 11, 12, "while",			"while", "(", expr, whileEnd,							"END" },
	{ 11, 12, "for",			"for", "(", forControl, ")",							"END" },
	{ 11, 12, "break",			"break", ";",											"END" },
	{ 12, 12, "arrayInit",		access, "TYPE", "[", "]", "ID", "=", arrayInit, ";",	"END" },
	{ 12, 12, "arrayDecl",		access, "TYPE", "[", "]", idList, ";",					"END" },
	{ 1, 12, "class",			access, "class", "ID", extends,							"END" },

	-- Common errors: unknown type
	{ 3, 0, "varInit",			access, "ID", "ID", "=", expr, ";", "END",					iNode = 2 },
	{ 3, 0, "varDecl",			access, "ID", idList, ";", "END",							iNode = 2 },
	{ 3, 0, "constInit", 		access, "final", "ID", "ID", "=", expr, ";", "END", 		iNode = 3 },
	{ 12, 0, "arrayInit",		access, "ID", "[", "]", "ID", "=", arrayInit, ";", "END",	iNode = 2 },
	{ 12, 0, "arrayDecl",		access, "ID", "[", "]", idList, ";", "END",					iNode = 2,
			strErr = invalidTypeName },

	-- Common errors: type instead of ID
	{ 3, 0, "varInit",			access, "TYPE", "TYPE", "=", expr, ";", "END",					iNode = 3 },
	{ 3, 0, "constInit", 		access, "final", "TYPE", "TYPE", "=", expr, ";", "END", 		iNode = 4 },
	{ 12, 0, "arrayInit",		access, "TYPE", "[", "]", "TYPE", "=", arrayInit, ";", "END",	iNode = 5,
			strErr = invalidVarName },

	{ 1, 0, "class",			access, "class", "TYPE", 0,										iNode = 3,
			strErr = "This name is already defined. Choose another name for your class." },

	-- Common errors: missing semicolon
	{ 1, 0, "stmt", 		stmt, "END", 											iNode = 2 }, 
	{ 9, 0, "returnVal", 	"return", expr, "END", 									iNode = 3 }, 
	{ 6, 0, "return", 		"return", "END", 										iNode = 2 },
	{ 11, 0, "break",		"break", "END",											iNode = 2 },
	{ 3, 0, "varInit",		access, "ID", "ID", "=", expr, "END",					iNode = 6 }, 
	{ 3, 0, "constInit", 	access, "final", "ID", "ID", "=", expr, "END",			iNode = 7 }, 
	{ 12, 0, "arrayInit",	access, "ID", "[", "]", "ID", "=", arrayInit, "END", 	iNode = 8 },
	{ 3, 0, "varDecl",		access, "ID", idList, "END",							iNode = 4 }, 
	{ 12, 0, "arrayDecl",	access, "ID", "[", "]", idList, "END",					iNode = 6,
			strErr = "Statement should end with a semicolon (;)" },

	-- Common errors: incorrect semicolon
	{ 1, 0, "func",			access, retType, "ID", "(", paramList, ")",	";", "END",	iNode = 7,
			strErr = "function header should not end with a semicolon" },

	{ 6, 0, "if",			"if", "(", expr, ")", ";", 0,							iNode = 5 },
	{ 6, 0, "elseif",		"else", "if", "(", expr, ")", ";", 0,					iNode = 6,
			strErr = "if statement should not end with a semicolon" },

	{ 6, 0, "else",			"else", ";", 0,											iNode = 2, 
			strErr = "else statement should not end with a semicolon" },

	{ 11, 0, "do",			"do", ";", 0,											iNode = 2, 
			strErr = "do statement should not end with a semicolon" },

	{ 11, 0, "for",			"for", "(", forControl, ")", ";", 0,	 				iNode = 5,
			strErr = "for loop header should not end with a semicolon" },

	{ 1, 0, "class",		access, "class", "ID", extends, ";",					iNode = 5,
			strErr = "class header should not end with a semicolon" },

	-- Common errors: unsupported bracket style
	{ 1, 0, "func",			access, retType, "ID", "(", paramList, ")",	"{", 0,		iNode = 7 },
	{ 6, 0, "if",			"if", "(", expr, ")", "{", 0,							iNode = 5 },
	{ 6, 0, "elseif",		"else", "if", "(", expr, ")", "{", 0,					iNode = 6 },
	{ 6, 0, "else",			"else", "{", 0,											iNode = 2 },
	{ 11, 0, "do",			"do", "{", 0,											iNode = 2 },
	{ 11, 0, "while",		"while", "(", expr, whileEnd, "{", 0,					iNode = 5 },
	{ 11, 0, "for",			"for", "(", forControl, ")", "{", 0,					iNode = 5 },
	{ 1, 0, "class",		access, "class", "ID", extends, "{", 0,					iNode = 5,
			strErr = "In Code12, each {  to start a new block must be on its own line" },

	{ 1, 0, "end",			"}", 1,
			strErr = "In Code12, each }  to end a block must be on its own line" },

	-- Common errors: multiple statements per line
	{ 1, 0, "stmt", 		stmt, ";", 2,
			strErr = "Code12 requires each statement to be on its own line" },

	{ 3, 0, "varInit",		access, "TYPE", "ID", "=", expr, ",",	"ID", "=", 1 },
	{ 3, 0, "varInit",		access, "TYPE", "ID", "=", expr, ";",	2 },
	{ 3, 0, "constInit", 	access, "final", "TYPE", "ID", "=", expr, ",", "ID", "=", 1 }, 
	{ 3, 0, "constInit", 	access, "final", "TYPE", "ID", "=", expr, ";", 2, 
			strErr = "Code12 requires each variable initialization to be on its own line" },

	{ 6, 0, "if",			"if", "(", expr, ")", 2, 								iNode = 5, toEnd = true },
	{ 6, 0, "elseif",		"else", "if", "(", expr, ")", 2,						iNode = 6, toEnd = true,
			strErr = "Code12 requires code after an if statement to be on its own line" },

	{ 6, 0, "else",			"else", stmt,											iNode = 2, toEnd = true,
			strErr = "Code12 requires code after an else to be on its own line" },

	{ 11, 0, "do",			"do", 2,												iNode = 2, toEnd = true	},
	{ 11, 0, "while",		"while", "(", expr, whileEnd, 2,						iNode = 5, toEnd = true },
	{ 11, 0, "for",			"for", "(", forControl, ")", 2,							iNode = 5, toEnd = true,
			strErr = "Code12 requires the contents of a loop to start on its own line" },

	-- Common errors: unsupported statements
	{ 1, 0, "import",		"import", "ID", 0,
			strErr = "Code12 does not support importing other classes" },
}


----- Grammar Parsing Functions ----------------------------------------------

-- Attempt to parse the given grammar table. 
-- Return the parseTree if sucessful or nil if failure.
-- If the parse matches a common syntax error, then set the error state
-- and return a parseTree with the isError field set to true inside it.
function parseGrammar( grammar )
	-- Look at each pattern in the grammar
	local iStart = iToken
	for i = 1, #grammar do
		local pattern = grammar[i]
		local p = pattern[3]

		-- If tracking with findError then keep track of the current line or stmt 
		-- pattern being parsed here and during contained grammars. 
		if findError then
			local t = grammar.t
			if t == "line" or t == "stmt" or (t == "expr" and pattern == "call") then
				findError.lineOrStmtPattern = p
			end
		end

		-- Consider only patterns defined for the syntaxLevel
		local patternMinLevel = pattern[1]
		local patternMaxLevel = pattern[2]
		if syntaxLevel >= patternMinLevel 
				and (syntaxLevel <= patternMaxLevel or matchCommonErrors) then
			if p == false then
				return false   -- empty pattern matches and returns tree = false
			end
			-- Try to match this pattern within the grammer table
			trace("Trying " .. grammar.t .. "[" .. i .. "] (" .. p .. ")")
			traceIndentLevel = traceIndentLevel + 1
			local nodes = parsePattern( pattern )
			traceIndentLevel = traceIndentLevel - 1
			if nodes then
				-- This pattern matches, so make a tree node to return
				local parseTree = { t = grammar.t, p = p, nodes = nodes }

				-- If we matched a common error then set the error state
				-- and mark the parse tree with isError.
				if nodes.isError then
					parseTree.isError = true  -- pass up error from lower node
				elseif patternMaxLevel == 0 then
					-- This pattern was the common error match
					parseTree.isError = true
					local strErr = pattern.strErr
					if not strErr then
						-- This common error pattern doesn't specify the strErr,
						-- so it should be in a group where the last one does.
						local j = i
						local patErr
						repeat 
							j = j + 1
							patErr = grammar[j]
						until patErr.strErr ~= nil
						strErr = patErr.strErr
					end
					local iNode = pattern.iNode
					if type(strErr) == "function" then
						strErr( nodes[iNode] )
					elseif iNode == nil then
						err.setErrNode( nodes, strErr )
					elseif pattern.toEnd then
						err.setErrNodeSpan( nodes[iNode], tokens[#tokens - 1], strErr )
					elseif pattern.missing then
						err.setErrNodeMissing( nodes[iNode], strErr )
					else
						err.setErrNode( nodes[iNode], strErr )
					end
					err.addDocLink( "Java.html" )
				end

				-- Return the parse tree
				trace( string.format( "== Returning %s[%d] (%s) %s", 
							grammar.t, i, p, parseTree.isError and "isError" or "" ) )
				return parseTree
			end
			iToken = iStart  -- reset position for next pattern to try
		end
	end
	return nil  -- no matching patterns
end

-- Attempt to parse the given list pattern, with results per parsePattern().
local function parseListPattern( pattern )
	local nodes = {}         -- node array to build
	local item = pattern[4]  -- build a list of this item
	local t = type(item)     -- list patterns always repeat a single item

	-- Match as many list items as possible
	repeat
		-- Try to parse the item
		local token = tokens[iToken]
		local node = nil
		if t == "string" then
			-- Token: compare to next token
			if token == nil or token.tt ~= item then
				-- Required next token type doesn't match
				possibleExpectedToken( item )
				return nil    -- required next token type doesn't match
			end
			node = token
			trace("Matched token " .. iToken .. " \"" .. token.str .. "\"")
			iToken = iToken + 1
		elseif t == "function" then
			node = item()    -- parsing function
		elseif t == "table" then
			node = parseGrammar( item )   -- sub-grammar
		end
		if node == nil then
			return nil   -- could not parse item
		end

		-- Store the node and propagate error from it if any
		nodes[#nodes + 1] = node
		if node.isError then
			nodes.isError = true
			return nodes
		end

		-- Look for a comma to continue the list
		if tokens[iToken].tt == "," then
			iToken = iToken + 1   -- pass comma and prepare to parse item again
		else
			possibleExpectedToken( "," )   -- could have expected a comma here
			return nodes  -- can't parse any more list items
		end
	until false  -- returns internally
end 

-- Attempt to parse the given pattern within a grammar table.
-- If successful then return an array of parse tree nodes that match the pattern.
-- If failure, return nil and iToken is left undefined.
-- If the parse matches a common syntax error, then set the error state
-- and return a nodes array with the isError field set to true inside it.
function parsePattern( pattern )
	-- Handle special list patterns
	if pattern.list then
		return parseListPattern( pattern )
	end

	-- Try to match the pattern starting at the first item (pattern[4])
	local nodes = {}   -- node array to build
	for iItem = 4, #pattern do   -- start after minLevel, maxLevel, patternName
		local item = pattern[iItem]

		-- Is this pattern item a token, grammar table, parsing function, or token count?
		local node = nil
		local t = type(item)
		if t == "string" then
			-- Token: compare to next token
			local token = tokens[iToken]
			if token == nil or token.tt ~= item then
				-- Required next token type doesn't match
				possibleExpectedToken( item )
				return nil
			end
			node = token
			trace("Matched token " .. iToken .. " \"" .. token.str .. "\"")
			iToken = iToken + 1
		elseif t == "function" then
			node = item()    -- parsing function
		elseif t == "table" then
			node = parseGrammar( item )   -- sub-grammar
		elseif t == "number" then
			-- Matches at least this many of any token until end of line
			if #tokens - iToken >= item then  -- are there enough tokens left?
				while iToken <= #tokens do
					nodes[#nodes + 1] = tokens[iToken]
					iToken = iToken + 1
				end
				return nodes
			end
			return nil  -- not enough tokens left
		end
		if node == nil then
			return nil   -- could not parse item
		end

		-- Store the node and propagate error from it if any
		nodes[#nodes + 1] = node
		if node and node.isError then
			nodes.isError = true
			return nodes
		end
	end
	return nodes  -- successful pattern match
end

-- Try to parse the current line at the given level.
-- Return the parse tree if successful or nil if failure.
-- If includeCommonErrors then include common error patterns
-- (will return a parse tree with tree.isError = true).
local function tryLineParseAtLevel( level, includeCommonErrors )
	syntaxLevel = level
	matchCommonErrors = includeCommonErrors
	iToken = 1
	return parseGrammar( line )
end

-- Try to parse the current token stream as a line of code at the given
-- syntax level. If a match is found then return the parseTree, otherwise
-- return nil and set the error state. If the match was for a known 
-- common syntax error, then set isError = true in the parse tree.
-- If parsing failed at this level but would succeed at a higher level, 
-- then set the error state to indicate this.
local function parseCurrentLine( level )
	-- Try normal parse at the requested syntax level first
	findError = nil    -- don't track error tokens (optimize for success)
	local parseTree = tryLineParseAtLevel( level )
	if parseTree then
		return parseTree  -- success
	end

	-- Try parsing at higher levels
	local strNote = nil
	for tryLevel = level + 1, numSyntaxLevels do
		err.clearErr( lineNumber )
		parseTree = tryLineParseAtLevel( tryLevel )
		if parseTree then
			-- Make note to add to syntax error
			strNote = string.format( "Use of %s requires syntax level %d",
							syntaxFeatures[tryLevel], tryLevel)
			break
		end
	end

	-- Try common errors at the given syntax level
	err.clearErr( lineNumber )
	parseTree = tryLineParseAtLevel( level, true )
	if parseTree then
		assert( parseTree.isError )  -- matched a common error
		err.addNoteToErrAtLineNum( lineNumber, strNote )
		return parseTree    -- TODO: Is this too risky?
	end

	-- Normal parse again at the user's level to look for basic parse errors.
	err.clearErr( lineNumber )
	parseTree = tryLineParseAtLevel( level )
	if err.errRecForLine( lineNumber ) then
		err.addNoteToErrAtLineNum( lineNumber, strNote )
		return parseTree
	end

	-- Try at the user's level with findError to try to find the error token
	findError = {}
	tryLineParseAtLevel( level )
	if findError.iTokenMax then
		-- Tracking found and reported an error
		print( string.format( '\nLine %s: Syntax error at token %d "%s"', 
				lineNumber, findError.iTokenMax, tokens[findError.iTokenMax].str ) )
		for _, parse in ipairs( findError.parses ) do
			print( string.format( "    %s expected %s", 
					parse.stmtPattern, parse.ttExpected ) )
		end

		-- Make a generic syntax error to use if a more specific error was not already set
		local lastToken = tokens[#tokens - 1]  -- not counting the END
		err.setErrNodeSpan( tokens[1], lastToken, "Syntax error (unrecognized code)" )
		err.addDocLink( "Java.html" )
	end
	err.addNoteToErrAtLineNum( lineNumber, strNote )

	-- Append the source line to our log of syntax errors if not a bulk error test
	if not err.bulkTestMode and not strNote then
		local filename = "../SyntaxErrors.txt"
		local logFile = io.open( filename, "r" )
		if logFile then   -- only if it already exists here 
			io.close( logFile )
			logFile = io.open( filename, "a" )
			if logFile then
				logFile:write( source.lines[lineNumber].str )
				logFile:write( "\n" )
				io.close( logFile )
			end
		end
	end

	-- Return failure
	return nil
end

-- Make and return a recursive copy of the given parse tree node 
-- (including leaf tokens), assigning the given line number to the tokens.
local function copyParseTreeNode( node, lineNum )
	if not node then
		return node   -- nil or false
	elseif node.tt then  
		-- Copy token node
		return { tt = node.tt, str = node.str, iLine = lineNum, 
				iChar = node.iChar, vt = node.vt }
	else  
		-- A parse tree node: make a copy recursively
		assert( node.t )
		local nodes = node.nodes
		local nodesCopy = {}
		for i = 1, #nodes do
			nodesCopy[i] = copyParseTreeNode( nodes[i], lineNum )
		end
		return { t = node.t, p = node.p, nodes = nodesCopy }
	end
end


----- Module functions -------------------------------------------------------

-- Make and return a full (deep) copy of the given line parse tree, assigning
-- the given line number to the tokens and the top (line) tree node.
function parseJava.copyLineParseTree( tree, lineNum )
	assert( tree.t == "line")
	local treeCopy = copyParseTreeNode( tree, lineNum )
	treeCopy.iLine = lineNum
	treeCopy.iLineStart = lineNum + tree.iLineStart - tree.iLine
	treeCopy.indentLevel = tree.indentLevel
	return treeCopy
end

-- If nameNode is an invalid name ID then set the error state and return true,
-- otherwise return false. Usage should be a description of how the name is 
-- being used (e.g. "variable", "function"), and existing is true if the name
-- is being used as an existing name (false if being defined).
function parseJava.isInvalidID( nameNode, usage, existing )
	local strName = nameNode.str
	local tt, strCorrectCase, usageFound = javalex.knownName( strName )
	if tt == nil then
		return false   -- not a variation on a known name
	end
	if not existing then
		err.setErrNode( nameNode, 
				"Code12 does not allow names that differ only by upper/lower case from known names (\"%s\" is a %s)", 
				strCorrectCase, usageFound )
	elseif strCorrectCase == strName then
		err.setErrNode( nameNode, 
				"%s is a %s, expected a %s name here", strName, usageFound, usage )
	elseif usageFound == "constant" then
		err.setErrNode( nameNode, 'Incorrect case for constant "%s"', strCorrectCase )
	else
		err.setErrNode( nameNode, 'Names are case-sensitive, known name is "%s"', strCorrectCase )
	end
	err.addDocLink( "Java.html" )
	return true
end

-- Parse the lineRec at the given syntax level (default numSyntaxLevels).
-- If iLineCommentStart then the line starts inside an open comment started there.
-- If startTokens is not nil, it is an array of tokens from a previous unfinished
-- line to prepend to the tokens found on this line, and iLineStart is the first line
-- of the multi-line parse.
-- Return (parseTree, tokens) if successful, store the results in the lineRec,
-- and set the iLine, iLineStart, and indentLevel fields in the parse tree root node.
-- If the line is unfinished (ends with a comma or ///) then return (false, tokens).
-- If the line cannot be parsed then return nil and set the error state.
function parseJava.parseLine( lineRec, iLineCommentStart, startTokens, iLineStart, level )
	-- Run lexical analysis to get the tokens array
	lineNumber = lineRec.iLine
	iLineStart = iLineStart or lineNumber
	lineRec.iLineStart = iLineStart
	tokens = javalex.getTokens( lineRec, iLineCommentStart )
	if tokens == nil then
		return nil
	end

	-- There sould be an "END" token at the end no matter what.
	assert( #tokens > 0 )
	assert( tokens[#tokens].tt == "END" )

	-- Prepend the startTokens if any
	if startTokens then
		-- There should be at least one real token and an END in startTokens
		assert( #startTokens > 1 )
		assert( startTokens[#startTokens].tt == "END" )
		local j = #startTokens   -- overwrite the END
		for i = 1, #tokens do
			startTokens[j] = tokens[i]
			j = j + 1
		end
		tokens = startTokens
		-- startTokens = nil
	end

	-- If this line has code and ends in a comma token or the /// continuation 
	-- comment, then it is unfinished.
	assert( #tokens > 0 )
	assert( tokens[#tokens].tt == "END" )
	local lastToken = tokens[#tokens - 1]  -- not counting the END
	if lastToken then
		if lastToken.tt == "," then
			lineRec.parseTree = false
			return false, tokens
		end
		-- Check for /// allowing trailing whitespace (only)
		local comment = lineRec.commentStr 
		if comment and string.match( comment, "/[ \t]*") == comment then
			lineRec.commentStr = nil
			lineRec.parseTree = false
			return false, tokens
		end			
	end

	-- Try to parse the line
	local tree = parseCurrentLine( level or numSyntaxLevels )
	if tree == nil then
		return nil
	end

	-- Store and return results
	tree.iLine = lineNumber
	tree.iLineStart = iLineStart
	tree.indentLevel = source.lines[iLineStart].indentLevel
	lineRec.parseTree = tree
	return tree, tokens
end

-- Print a parse tree recursively at the given indentLevel.
-- If file then output to it instead of the console.
function parseJava.printParseTree( node, indentLevel, file )
	if node then
		-- Print description string for this node
		local s = string.rep("    ", indentLevel)  -- indentation
		if node.tt then
			-- Token node
			-- Ignore tokens that are simple separators/operators
			if node.str == node.tt or node.tt == "END" then
				return
			end
			s = s .. node.tt .. " (" .. node.str .. ")"
		else
			-- Sub-tree node
			s = s .. node.t 
			if node.p then
				s = s .. " (" .. node.p .. ")"
			end
		end
		app.printDebugStr( s, file )

		-- Recursively print children at next indent level, if any
		if node.nodes then
			for _, child in ipairs(node.nodes) do
				parseJava.printParseTree( child, indentLevel + 1, file )
			end
		end
	end
end


-----------------------------------------------------------------------------------------


-- Return the module
return parseJava
