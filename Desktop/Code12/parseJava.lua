-----------------------------------------------------------------------------------------
--
-- parseJava.lua
--
-- Implements parsing for Java in the Code12 system.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules used
local app = require( "app" )
local err = require( "err" )
local javalex = require( "javalex" )


-- The parseJava module
local parseJava = {}


----- File Local Variables  --------------------------------------------------

-- Language feature names introduced at each syntax level
local syntaxFeatures = {
	"procedure calls",
	"comments",
	"variables",
	"expressions",
	"function return values",
	"object data fields",
	"object method calls",
	"if-else statements",
	"user-defined functions",
	"parameters in user-defined functions",
	"loops",
	"arrays",
}
local numSyntaxLevels = #syntaxFeatures

-- The parsing state
local sourceLine        -- the current source code line
local lineNumber        -- the line number for sourceLine
local tokens     	    -- array of tokens
local iToken            -- index of current token in tokens
local syntaxLevel	    -- the syntax level for parsing
local maxSyntaxLevel    -- max syntax level or 0 to match common errors

-- Forward function declarations necessary due to mutual recursion or 
-- use in the grammar tables below
local parseGrammar
local parsePattern
local parseOpExpr
local primaryExpr


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
	[":"]	= 2,
}


----- Parse Tree Utilities  --------------------------------------------------

-- A parse tree is either:
-- 		a token node, for example:
--          { tt = "ID", str = "foo", iLine = 10, iChar = 23 }
--      or a tree node, for example:
--          { t = "line", p = "stmt", nodes = {...}, info = {} }
--      where t is the grammar or function name, p is the pattern name if any,
--      info is an initially empty table where semantic info can be stored,
--		and nodes is an array of children nodes.

-- Create and return a parse tree node with the given type (t), pattern (p), 
-- and children nodes
local function makeParseTreeNode( t, p, nodes )
	-- TODO: Get from pool
	return { t = t, p = p, nodes = nodes, info = {} }
end	


----- Special parsing functions used in the grammar tables below  ------------

-- Parse the primaryExpr grammar (function version, for recursion)
local function parsePrimaryExpr()
	return parseGrammar( primaryExpr )
end

-- Parse an expression 
local function expr()
	-- Start the recursive Precedence Climbing algorithm
	local leftSide = parseGrammar( primaryExpr )
	if leftSide == nil then
		return nil
	elseif leftSide.isError then
		return leftSide
	end
	return parseOpExpr( leftSide, 0 )  -- include binary operators
end


----- Grammar Tables ---------------------------------------------------------

-- An array index or empty
local index = { t = "index",
	{ 12, 12, "index",			"[", expr, "]"			},
	{ 1, 12, "empty",									},
}

-- An field reference or empty
local field = { t = "field",
	{ 6, 12, "field",			".", "ID"				},
	{ 1, 12, "empty",									},
}

-- An lValue (var or expr that can be assigned to)
local lValue = { t = "lValue",
	{ 3, 12, "lValue",			"ID", index, field		},
}

-- A member reference or empty
local member = { t = "member",
	{ 1, 12, "member",			".", "ID"				},
	{ 1, 12, "empty",									},
}

-- A function value
local fnValue = { t = "fnValue",
	{ 1, 12, "fnValue",			"ID", index, member, member		},
}

-- A return type for a procedure/function definition
local retType = { t = "retType",
	{ 12, 12, "array",			"ID", "[", "]"			},
	{ 1, 12, "simple",			"ID"					},
}

-- An access permission specifier
local access = { t = "access",
	{ 1, 12, "public",			"public"				},
	{ 3, 12, "private",			"private"				},
	{ 1, 12, "empty",									},
}

-- A formal parameter (in a function definition)
local param = { t = "param",
	{ 12, 12, "array",			"ID", "[", "]", "ID"		},
	{ 6, 12, "var",				"ID", "ID"					},
}

-- A formal parameter list, which can be empty
local paramList = { t = "paramList",
	{ 10, 12, "list",			param,	list = true, 	 	},
	{ 1, 12, "empty"										},
}

-- An identifier list (must have a least one)
local idList = { t = "idList",
	{ 1, 12, "list",			"ID",	list = true,  		},
}

-- An expression list, which can be empty
local exprList = { t = "exprList",
	{ 1, 12, "list",			expr,	list = true,  		},
	{ 1, 12, "empty"										},
}

-- An expression list, which must have at least one
local exprList1 = { t = "exprList1",
	{ 1, 12, "list",			expr,	list = true,  		},
}

-- A primary expression (no binary operators)
primaryExpr = { t = "expr",
	{ 1, 12, "NUM",				"NUM" 								},
	{ 1, 12, "BOOL",			"BOOL" 								},
	{ 1, 12, "NULL",			"NULL" 								},
	{ 1, 12, "STR",				"STR" 								},
	{ 5, 12, "call",			fnValue, "(", exprList, ")" 		},
	-- Common Error for call (must preceed lValue)
	{ 1, 0, "call",				fnValue, "(", exprList1, expr, 0,	iNode = 4, missing = true,
			strErr = "Function parameter values must be separated by commas" },
	-- More valid patterns
	{ 3, 12, "lValue",			lValue								},
	{ 4, 12, "cast",			"(", "ID", ")", parsePrimaryExpr	},
	{ 4, 12, "exprParens",		"(", expr, ")"						},
	{ 4, 12, "neg",				"-", parsePrimaryExpr 				},
	{ 4, 12, "not",				"!", parsePrimaryExpr 				},
	{ 12, 12, "newArray",		"new", "ID", "[", expr, "]"			},
	-- Other Common Errors
	{ 1, 0, "new",				"new", "ID", "(", 0,				iNode = 1, 
			strErr = "Code12 does not support making objects with new" },
}

-- Shortcut "operate and assign" operators 
local opAssignOp = { t = "opAssignOp",
	{ 4, 12, "+=",				"+=",  		},
	{ 4, 12, "-=",				"-=",  		},
	{ 4, 12, "*=",				"*=",  		},
	{ 4, 12, "/=",				"/=",  		},
}

-- A statement
local stmt = { t = "stmt",
	{ 1, 12, "call",			fnValue, "(", exprList, ")" 		},
	{ 3, 12, "assign",			lValue, "=", expr 					},
	{ 4, 12, "opAssign",		lValue, opAssignOp, expr 			},
	{ 4, 12, "preInc",			"++", lValue 						},
	{ 4, 12, "preDec",			"--", lValue						},
	{ 4, 12, "postInc",			lValue, "++" 						},
	{ 4, 12, "postDec",			lValue, "--"						},
	-- Common Errors
	{ 1, 0, "call",				fnValue, "(", exprList1, expr, 0,	iNode = 4, missing = true,
			strErr = "Function parameter values must be separated by commas" },
}

-- The end of a while statement, either with a ; (for do-while) or not
local whileEnd = { t = "whileEnd",
	{ 11, 12, "doWhile",		")", ";"		},
	{ 11, 12, "while",			")"				},
}

-- The init part of a for loop
local forInit = { t = "forInit",
	{ 11, 12, "var",			"ID", "ID", "=", expr				},
	{ 11, 12, "stmt",			stmt								},
	{ 11, 12, "empty",												},
}

-- The expr part of a for loop
local forExpr = { t = "forExpr",
	{ 11, 12, "expr",			expr		},
	{ 11, 12, "empty",						},
}

-- The next part of a for loop
local forNext = { t = "forNext",
	{ 11, 12, "stmt",			stmt		},
	{ 11, 12, "empty",						},
}

-- The control part of a for loop (inside the parens)
local forControl = { t = "forControl",
	{ 11, 12, "three",			forInit, ";", forExpr, ";", forNext			},
	{ 12, 12, "array",			"ID", "ID", ":", expr 						},
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

-- A line of code
local line = { t = "line",
	{ 1, 12, "blank",																"END" },
	{ 1, 12, "stmt",			stmt, ";",											"END" },
	{ 3, 12, "varInit",			access, "ID", "ID", "=", expr, ";",					"END" },
	{ 3, 12, "varDecl",			access, "ID", idList, ";",							"END" },
	{ 3, 12, "constInit", 		access, "final", "ID", "ID", "=", expr, ";",		"END" },
	{ 1, 12, "func",			access, retType, "ID", "(", paramList, ")",			"END" },
	{ 1, 12, "begin",			"{",												"END" },
	{ 1, 12, "end",				"}",												"END" },
	{ 8, 12, "if",				"if", "(", expr, ")",								"END" },
	{ 8, 12, "elseif",			"else", "if", "(", expr, ")",						"END" },
	{ 8, 12, "else",			"else", 											"END" },
	{ 9, 12, "returnVal",		"return", expr, ";",								"END" },
	{ 9, 12, "return",			"return", ";",										"END" },
	{ 11, 12, "do",				"do", 												"END" },
	{ 11, 12, "while",			"while", "(", expr, whileEnd,						"END" },
	{ 11, 12, "for",			"for", "(", forControl, ")",						"END" },
	{ 11, 12, "break",			"break", ";",										"END" },
	{ 12, 12, "arrayInit",		access, "ID", "[", "]", "ID", "=", arrayInit, ";",	"END" },
	{ 12, 12, "arrayDecl",		access, "ID", "[", "]", idList, ";",				"END" },

	-- Boilerplate lines
	{ 1, 12, "importAll",		"import", "ID", ".", "*", ";",						"END" },
	{ 1, 12, "class",			"class", "ID",										"END" },
	{ 1, 12, "classUser",		access, "class", "ID", "extends", "ID",				"END" },
	{ 1, 12, "main",			"public", "static", "ID", "ID", 
									"(", "ID", "[", "]", "ID", ")",					"END" },
	{ 1, 12, "Code12Run",		"ID", ".", "ID", "(", "new", 
									"ID", "(", ")", ")", ";",						"END" },
	-- Common errors: missing semicolon
	{ 1, 0, "stmt", 		stmt, "END", 											iNode = 2 }, 
	{ 9, 0, "returnVal", 	"return", expr, "END", 									iNode = 3 }, 
	{ 9, 0, "return", 		"return", "END", 										iNode = 2 },
	{ 11, 0, "break",		"break", "END",											iNode = 2,
			strErr = "Statement should end with a semicolon (;)" },

	{ 3, 0, "varInit",		access, "ID", "ID", "=", expr, "END",					iNode = 6 }, 
	{ 3, 0, "constInit", 	access, "final", "ID", "ID", "=", expr, "END",			iNode = 7 }, 
	{ 12, 0, "arrayInit",	access, "ID", "[", "]", "ID", "=", arrayInit, "END", 	iNode = 8,
			strErr = "Variable initialization should end with a semicolon (;)" },

	{ 3, 0, "varDecl",		access, "ID", idList, "END",							iNode = 4 }, 
	{ 12, 0, "arrayDecl",	access, "ID", "[", "]", idList, "END",					iNode = 6,
			strErr = "Variable declaration should end with a semicolon (;)" },

	-- Common errors: incorrect semicolon
	{ 1, 0, "func",			access, retType, "ID", "(", paramList, ")",	";", "END",	iNode = 7,
			strErr = "function header should not end with a semicolon" },

	{ 8, 0, "if",			"if", "(", expr, ")", ";", 0,							iNode = 5 },
	{ 8, 0, "elseif",		"else", "if", "(", expr, ")", ";", 0,					iNode = 6,
			strErr = "if statement should not end with a semicolon" },

	{ 8, 0, "else",			"else", ";", 0,											iNode = 2, 
			strErr = "else statement should not end with a semicolon" },

	{ 11, 0, "do",			"do", ";", 0,											iNode = 2, 
			strErr = "do statement should not end with a semicolon" },

	{ 11, 0, "for",			"for", "(", forControl, ")", ";", 0,	 				iNode = 5,
			strErr = "for loop header should not end with a semicolon" },

	-- Common errors: unsupported bracket style
	{ 1, 0, "func",			access, retType, "ID", "(", paramList, ")",	"{", 0,		iNode = 7 },
	{ 8, 0, "if",			"if", "(", expr, ")", "{", 0,							iNode = 5 },
	{ 8, 0, "elseif",		"else", "if", "(", expr, ")", "{", 0,					iNode = 6 },
	{ 8, 0, "else",			"else", "{", 0,											iNode = 2 },
	{ 11, 0, "do",			"do", "{", 0,											iNode = 2 },
	{ 11, 0, "while",		"while", "(", expr, whileEnd, "{", 0,					iNode = 5 },
	{ 11, 0, "for",			"for", "(", forControl, ")", "{", 0,					iNode = 5,
			strErr = "In Code12, each { to start a new block must be on its own line" },

	{ 1, 0, "end",			"}", 1,
			strErr = "In Code12, each } to end a block must be on its own line" },

	-- Common errors: malformed boilerplate lines
	{ 1, 0, "import",		"import", "ID", 0, 
			strErr = "import should be \"Code12.*;\"" },

	-- Common errors: multiple statements per line
	{ 1, 0, "stmt", 		stmt, ";", 2,
			strErr = "Code12 requires each statement to be on its own line" },

	{ 3, 0, "varInit",		access, "ID", "ID", "=", expr, ",",	"ID", "=", 1 },
	{ 3, 0, "varInit",		access, "ID", "ID", "=", expr, ";",	2 },
	{ 3, 0, "constInit", 	access, "final", "ID", "ID", "=", expr, ",", "ID", "=", 1 }, 
	{ 3, 0, "constInit", 	access, "final", "ID", "ID", "=", expr, ";", 2, 
			strErr = "Code12 requires each variable initialization to be on its own line" },

	{ 8, 0, "if",			"if", "(", expr, ")", 2, 								iNode = 5, toEnd = true },
	{ 8, 0, "elseif",		"else", "if", "(", expr, ")", 2,						iNode = 6, toEnd = true,
			strErr = "Code12 requires code after an if statement to be on its own line" },

	{ 8, 0, "else",			"else", 2,												iNode = 2, toEnd = true,
			strErr = "Code12 requires code after an else to be on its own line" },

	{ 11, 0, "do",			"do", 2,												iNode = 2, toEnd = true	},
	{ 11, 0, "while",		"while", "(", expr, whileEnd, 2,						iNode = 5, toEnd = true },
	{ 11, 0, "for",			"for", "(", forControl, ")", 2,							iNode = 5, toEnd = true,
			strErr = "Code12 requires the contents of a loop to start on its own line" },

}


----- Parsing Functions --------------------------------------------------------

-- Unless otherwise specified, parsing functions parse the tokens array starting 
-- at iToken, considering only patterns that are defined within the syntaxLevel.
-- They return a parse tree, or nil if failure.


-- Parse the rest of an expression after leftSide using Precedence Climbing.
-- See https://en.wikipedia.org/wiki/Operator-precedence_parser
function parseOpExpr( leftSide, minPrecedence )
	-- Check for binary operator
	local token = tokens[iToken]
	local prec = binaryOpPrecedence[token.tt]
	-- Build nodes and recurse in the correct direction depending on prec
	while prec and prec >= minPrecedence do
		local op = token   -- the binary op
		local opPrec = prec
		iToken = iToken + 1
		local rightSide = parseGrammar( primaryExpr )
		if rightSide == nil then
			err.setErrNodeAndRef( tokens[iToken], op,
					"Expected expression after %s operator", op.str )
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
		leftSide = makeParseTreeNode( "expr", op.tt, { leftSide, op, rightSide } )
		if rightSide.isError then
			leftSide.isError = true   -- propagate error up to parent
		end
	end
	return leftSide
end

-- Attempt to parse the given grammar table. 
-- Return the parseTree if sucessful or nil if failure.
-- If the parse matches a common syntax error, then set the error state
-- and return a parseTree with the isError field set to true inside it.
function parseGrammar( grammar )
	-- Consider each pattern in the grammar table that includes the syntaxLevel range.
	local iStart = iToken
	for i = 1, #grammar do
		local pattern = grammar[i]
		local patternMinLevel = pattern[1]
		local patternMaxLevel = pattern[2]
		if syntaxLevel >= patternMinLevel and maxSyntaxLevel <= patternMaxLevel then
			-- Try to match this pattern within the grammer table
			trace("Trying " .. grammar.t .. "[" .. i .. "] (" .. pattern[3] .. ")")
			traceIndentLevel = traceIndentLevel + 1
			local nodes = parsePattern( pattern )
			traceIndentLevel = traceIndentLevel - 1
			if nodes then
				-- This pattern matches, so make a tree node to return
				local parseTree = makeParseTreeNode( grammar.t, pattern[3], nodes )

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
					if iNode == nil then
						err.setErrLineNum( tokens[1].iLine, strErr )
					elseif pattern.toEnd then
						err.setErrNodeSpan( nodes[iNode], tokens[#tokens - 1], strErr )
					elseif pattern.missing then
						err.setErrNodeMissing( nodes[iNode], strErr )
					else
						err.setErrNode( nodes[iNode], strErr )
					end
				end

				-- Return the parse tree
				trace( string.format( "== Returning %s[%d] (%s) %s", 
							grammar.t, i, pattern[3], parseTree.isError and "isError" or "" ) )
				return parseTree
			end
			iToken = iStart  -- reset position for next pattern to try
		end
	end
	return nil  -- no matching patterns
end

-- Attempt to parse the given list pattern, with results per parsePattern().
function parseListPattern( pattern )
	local nodes = {}         -- node array to build
	local item = pattern[4]  -- build a list of this item
	local t = type(item)     -- list patterns always repeat a single item

	-- Match as many list items as possible
	repeat
		-- A list item cannot start with a comma
		local token = tokens[iToken]
		if token.tt == "," then
			err.setErrNode( token, "Missing list item or extra comma" )
			return nil
		end

		-- Try to parse the item
		local node = nil
		if t == "string" then
			-- Token: compare to next token
			if token == nil or token.tt ~= item then
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
			local tt = tokens[iToken].tt   -- peek at token after the comma
			if tt == ")" or tt == "}" or tt == ";" then   -- always list terminators
				err.setErrNode( tokens[iToken - 1],
					"Missing list item or extra comma" )
				return nil
			end
		else
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
				return nil    -- required next token type doesn't match
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
			if #tokens - iToken >= item then
				for _ = iItem, #tokens do
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

		-- Store the node and propagate error from if if any
		nodes[#nodes + 1] = node
		if node.isError then
			nodes.isError = true
			return nodes
		end
	end
	return nodes  -- successful pattern match
end

-- Try to parse the current token stream as a line of code at the given
-- syntax level. If a match is found then return the parseTree, otherwise
-- return nil and set the error state. If the match was for a known 
-- common syntax error, then set isError = true in the parse tree.
-- If parsing failed at this level but would succeed at a higher level, 
-- then set the error state to indicate this.
local function parseCurrentLine( level )
	-- Try at the requested syntax level first
	syntaxLevel = level
	maxSyntaxLevel = level
	iToken = 1
	local parseTree = parseGrammar( line )
	if parseTree then
		return parseTree  -- success
	end

	-- Try common errors at the given syntax level
	local iLine = tokens[1].iLine
	err.clearErr( iLine )
	maxSyntaxLevel = 0   -- causes common errors to also be considered
	iToken = 1
	parseTree = parseGrammar( line )
	if parseTree then
		assert( parseTree.isError )  -- matched a common error
		return parseTree
	end	

	-- Try parsing at higher levels
	for tryLevel = level + 1, numSyntaxLevels do
		err.clearErr( iLine )
		syntaxLevel = tryLevel
		maxSyntaxLevel = 0   -- also match common errors
		iToken = 1
		parseTree = parseGrammar( line )
		if parseTree then
			err.clearErr( iLine )   -- in case we matched a common error
			-- Report level error with minimum level required
			local lastToken = tokens[#tokens - 1]  -- not counting the END
			err.setErrNodeSpan( tokens[1], lastToken,
					"Use of %s requires syntax level %d",
					syntaxFeatures[tryLevel], tryLevel )
			return nil
		end
	end

	-- If we set a known error at the max syntax level including common error
	-- patterns, then report it.
	if err.shouldStop() then
		return nil
	end

	-- TODO: Try modified patterns to isolate the error

	-- Make a generic syntax error to use if a more specific error was not found
	local lastToken = tokens[#tokens - 1]  -- not counting the END
	err.setErrNodeSpan( tokens[1], lastToken, "Syntax error (unrecognized code)" )

	-- Append the source line to our log of generic syntax errors if this
	-- is an abortable error (i.e. we are not running a bulk error test)
	if err.shouldStop() then
		local logFile = io.open( "../SyntaxErrors.txt", "a" )
		if logFile then
			logFile:write( sourceLine )
			logFile:write( "\n" )
			io.close( logFile )
		end
	end

	-- Return failure
	return nil
end


----- Module functions -------------------------------------------------------

-- Init the parsing state for a program
function parseJava.initProgram()
	javalex.initProgram()
end

-- Parse the given line of code at the given syntax level (default numSyntaxLevels).
-- If startTokens is not nil, it is an array of tokens from a previous unfinished
-- line to prepend to the tokens found on this line.
-- Return the parse tree (a recursive array of tokens and/or nodes) if successful.
-- The given iLine will be assigned to the tokens found and the resulting tree.
-- If the line is unfinished (ends with a comma token) then return (false, tokens).
-- If the line cannot be parsed then return nil and set the error state.
function parseJava.parseLine( strLine, iLine, startTokens, level )
	-- Run lexical analysis to get the tokens array
	sourceLine = strLine
	lineNumber = iLine
	tokens = javalex.getTokens( sourceLine, iLine )
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

	-- If this line ends in a comma token, then it is unfinished
	assert( #tokens > 0 )
	assert( tokens[#tokens].tt == "END" )
	local lastToken = tokens[#tokens - 1]  -- not counting the END
	if lastToken and lastToken.tt == "," then
		err.markIncompleteLine( iLine )
		return false, tokens
	end

	-- Try to parse the line
	local tree = parseCurrentLine( level or numSyntaxLevels )
	if tree then
		tree.iLine = iLine  -- store Java line number in the top tree node
	end
	return tree
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
		elseif node.p == "empty" then 
			return   -- empty optional parse node
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
