-----------------------------------------------------------------------------------------
--
-- parseJava.lua
--
-- Implements parsing for Java in the Code12 system.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules used
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

-- Set this to true to get trace output while parsing
local printTrace = false;

-- Debug trace
local function trace( message )
	if printTrace then
		print(message)
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

-- A method reference or empty
local method = { t = "method",
	{ 1, 12, "method",			".", "ID"				},
	{ 1, 12, "empty",									},
}

-- A function value
local fnValue = { t = "fnValue",
	{ 1, 12, "fnValue",			"ID", index, method,	},
}

-- A return type for a procedure/function definition
local retType = { t = "retType",
	{ 1, 12, "void",			"void" 					},
	{ 12, 12, "array",			"ID", "[", "]"			},
	{ 9, 12, "value",			"ID"					},
}

-- An access permission specifier
local access = { t = "access",
	{ 1, 12, "public",			"public"				},
	{ 1, 12, "empty",									},
}

-- A formal parameter (in a function definition)
local param = { t = "param",
	{ 12, 12, "array",			"ID", "[", "]", "ID"		},
	{ 6, 12, "var",				"ID", "ID"					},
}

-- A formal parameter list, which can be empty
local paramList = { t = "paramList",
	{ 10, 12, "list",			param,	list = true, sep = "," 		},
	{ 1, 12, "empty"												},
}

-- An identifier list (must have a least one)
local idList = { t = "idList",
	{ 1, 12, "list",			"ID",	list = true, sep = "," 		},
}

-- An expression list, which can be empty
local exprList = { t = "exprList",
	{ 1, 12, "list",			expr,	list = true, sep = "," 		},
	{ 1, 12, "empty"												},
}

-- A primary expression (no binary operators)
primaryExpr = { t = "expr",
	{ 1, 12, "NUM",				"NUM" 								},
	{ 1, 12, "BOOL",			"BOOL" 								},
	{ 1, 12, "NULL",			"NULL" 								},
	{ 1, 12, "STR",				"STR" 								},
	{ 5, 12, "call",			fnValue, "(", exprList, ")" 		},
	{ 3, 12, "lValue",			lValue								},
	{ 4, 12, "exprParens",		"(", expr, ")"						},
	{ 4, 12, "neg",				"-", parsePrimaryExpr 				},
	{ 4, 12, "!",				"!", parsePrimaryExpr 				},
	{ 12, 12, "newArray",		"new", "ID", "[", expr, "]"			},
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
	{ 3, 12, "varAssign",		"ID", "=", expr 					},
	{ 3, 12, "assign",			lValue, "=", expr 					},
	{ 4, 12, "opAssign",		lValue, opAssignOp, expr 			},
	{ 4, 12, "preInc",			"++", lValue 						},
	{ 4, 12, "preDec",			"--", lValue						},
	{ 4, 12, "postInc",			lValue, "++" 						},
	{ 4, 12, "postDec",			lValue, "--"						},
	{ 11, 12, "break",			"break"								},
}

-- The end of a while statement, either with a ; (for do-while) or not
local whileEnd = { t = "whileEnd",
	{ 11, 12, "do-while",		")", ";"		},
	{ 11, 12, "while",			")"				},
}

-- The init part of a for loop
local forInit = { t = "forInit",
	{ 11, 12, "varInit",		"ID", "ID", "=", expr				},
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
	{ 12, 12, "array",			"ID", "ID", ":", "ID" 						},
	-- Common Errors
	{ 11, 0, "three",			forInit, ",", "(*)", 						iNode = 2 },
	{ 11, 0, "three",			forInit, ";", forExpr, ",", "(*)",			iNode = 4, 
			strErr = "for loop parts should be separated by semicolons (;)\nComma not supported" },
}

-- An array initializer
local arrayInit = { t = "arrayInit",
	{ 12, 12, "list", 			"{", exprList, "}"							},
	{ 12, 12, "expr", 			expr										},
}

-- A line of code
local line = { t = "line",
	{ 1, 12, "blank",															"END" },
	{ 1, 12, "comment",			"COMMENT",										"END" },
	{ 1, 12, "stmt",			stmt, ";",										"END" },
	{ 3, 12, "varInit",			"ID", "ID", "=", expr, ";",						"END" },
	{ 3, 12, "varDecl",			"ID", idList, ";",								"END" },
	{ 3, 12, "constInit", 		"final", "ID", "ID", "=", expr, ";",			"END" },
	{ 1, 12, "func",			access, retType, "ID", "(", paramList, ")",		"END" },
	{ 1, 12, "begin",			"{",											"END" },
	{ 1, 12, "end",				"}",											"END" },
	{ 8, 12, "if",				"if", "(", expr, ")",							"END" },
	{ 8, 12, "elseif",			"else", "if", "(", expr, ")",					"END" },
	{ 8, 12, "else",			"else", 										"END" },
	{ 9, 12, "return",			"return", expr, ";",							"END" },
	{ 11, 12, "do",				"do", 											"END" },
	{ 11, 12, "while",			"while", "(", expr, whileEnd,					"END" },
	{ 11, 12, "for",			"for", "(", forControl, ")",					"END" },
	{ 12, 12, "arrayInit",		"ID", "[", "]", "ID", "=", arrayInit, ";",		"END" },
	{ 12, 12, "arrayDecl",		"ID", "[", "]", idList, ";",					"END" },
	-- Boilerplate lines
	{ 1, 12, "importCode12",	"import", "ID", ".", "*", ";",					"END" },
	{ 1, 12, "class",			"class", "ID", 									"END" },
	{ 1, 12, "classUser",		access, "class", "ID", "extends", "ID",			"END" },
	{ 1, 12, "main",			"public", "static", "void", "ID", 
									"(", "ID", "[", "]", "ID", ")",				"END" },
	{ 1, 12, "Code12Run",		"ID", ".", "ID", "(", "new", 
									"ID", "(", ")", ")", ";",					"END" },
	-- Common errors
	{ 1, 0, "stmt", 			stmt, "END", 								iNode = 2, 
			strErr = "Statement should end with a semicolon (;)" },
	{ 3, 0, "varInit",			"ID", "ID", "=", expr, "END",				iNode = 5, 
			strErr = "Variable initialization should end with a semicolon (;)" },
	{ 3, 0, "varDecl",			"ID", idList, "END",						iNode = 3, 
			strErr = "Variable declaration should end with a semicolon (;)" },
	{ 3, 0, "constInit", 		"final", "ID", "ID", "=", expr, "END",		iNode = 3, 
			strErr = "Variable declaration should end with a semicolon (;)" },
	{ 8, 0, "if",				"if", "(", expr, ")", ";", "END",			iNode = 5, 
			strErr = "if statement should not end with a semicolon" },
	{ 8, 0, "if",				"if", expr, "END",							iNode = 2, 
			strErr = "if statement test must be in parentheses" },
	{ 1, 0, "import",			"import", "(*)", 
			strErr = "Code12 programs should import only Code12.*" },

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
	end
	return leftSide
end

-- Attempt to parse the given grammar table. 
-- Return the parseTree if sucessful or nil if failure.
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
			local nodes = parsePattern( pattern )
			if nodes then
				-- If this matched a common error then set the error state
				if patternMaxLevel == 0 then
					local iNode = pattern.iNode
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
					if iNode then
						err.setErrNode( nodes[iNode], strErr )
					else
						err.setErrLineNum( nodes[1].iLine, strErr )
					end
					err.setErrPattern( pattern[3] )  -- pattern name
				end

				-- This pattern matches, so make a grammar node and return it
				local parseTree = makeParseTreeNode( grammar.t, pattern[3], nodes )
				trace("== Returning " .. grammar.t .. "[" .. i .. "] (" .. pattern[3] .. ")")
				return parseTree
			end
			iToken = iStart  -- reset position for next pattern
		end
	end
	return nil  -- no matching patterns
end

-- Attempt to parse the given pattern within a grammar table.
-- If successful then return an array of parse tree nodes that match the pattern.
-- If failure, return nil and iToken is left undefined.
function parsePattern( pattern )
	-- Try to match the pattern starting at the first item (pattern[4])
	local nodes = {}   -- node array to build
	local iItem = 4
	while iItem <= #pattern do
		local item = pattern[iItem]
		if item == "(*)" then
			-- Special token matches and ignores anything to end of line
			return nodes
		end
		-- Is this pattern item a token, grammar table, or parsing function?
		local t = type(item)
		if t == "string" then
			-- Token: compare to next token
			local token = tokens[iToken]
			if token == nil or token.tt ~= item then
				return nil   -- required token type doesn't match next token
			end
			-- Matched a token
			trace("Matched token " .. iToken .. " \"" .. token.str .. "\"")
			nodes[#nodes + 1] = token
			iToken = iToken + 1
		elseif t == "function" then
			-- Call parsing function
			local subTree = item()
			if subTree == nil then
				return nil  -- could not parse item
			end
			-- Matched item
			nodes[#nodes + 1] = subTree
		elseif t == "table" then
			-- Sub-grammar table item: try recursive parse
			local subTree = parseGrammar( item )
			if subTree == nil then
				return nil  -- could not parse sub-grammar item
			end
			-- Matched a sub-grammar item
			nodes[#nodes + 1] = subTree
		else
			error( "*** Pattern " .. pattern[3] .. ": Unknown pattern element type " .. t )
		end

		-- Is this a list pattern?
		if pattern.list then
			if tokens[iToken].tt == pattern.sep then   -- next token is the list seperator
				iToken = iToken + 1   -- pass seperator and prepare to parse item again
			else
				break  -- can't parse any more list items
			end
		else 
			-- Normal (non-list) pattern, so go on to next item in pattern
			iItem = iItem + 1
		end
	end

	-- Reached the end of the pattern, so success
	return nodes
end

-- Try to parse the current token stream as a line of code at the given
-- syntax level. If successful then return the parseTree. 
-- To match common errors specified in the grammar pass true for
-- matchCommonErrors, otherwise leave it nil for normal parsing.
-- If a parse cannot be made then return nil with the error state as set by
-- the parser or a generic syntax error if the specific error is not known.
local function parseLineGrammar( level, matchCommonErrors )
	-- Reset the parse state and parse the current token stream at level
	err.clearErr()
	syntaxLevel = level
	maxSyntaxLevel = (matchCommonErrors and 0) or level
	iToken = 1
	return parseGrammar( line )
end

-- Try to parse the current token stream as a line of code at the given
-- syntax level. If successful then return the parseTree, otherwise
-- return nil and set the error state. 
-- If parsing failed at this level but would succeed at a higher level, 
-- then set the error state to indicate this.
local function parseCurrentLine( level )
	-- Try at the requested syntax level first
	local parseTree = parseLineGrammar( level )
	if parseTree then
		return parseTree  -- success
	end

	-- Try common errors at the given syntax level
	parseTree = parseLineGrammar( level, true )
	if parseTree then
		assert( err.hasErr() )
		return nil  -- matched common error
	end	

	-- Try parsing at higher levels
	for tryLevel = level + 1, numSyntaxLevels do
		parseTree = parseLineGrammar( tryLevel, true )
		if parseTree then
			-- Report error with minimum level required
			err.clearErr()   -- in case we matched a common error
			local lastToken = tokens[#tokens - 1]  -- not counting the END
			err.setErrTokenSpan( tokens[1], lastToken,
					"Use of %s requires syntax level %d",
					syntaxFeatures[tryLevel], tryLevel )
			return nil
		end
	end

	-- TODO: Try modified patterns to isolate the error

	-- Make a generic syntax error if the error is unknown
	if not err.hasErr() then
		err.setErrLineNum( tokens[1].iLine, "Syntax error (unrecognized code)" )
	end
	return nil
end


----- Module functions -------------------------------------------------------

-- Init the parsing state
function parseJava.init()
	javalex.init()
end

-- Parse the given line of code at the given syntax level (default numSyntaxLevels).
-- If startTokens is not nil, it is an array of tokens from a previous unfinished
-- line to prepend to the tokens found on this line.
-- Return the parse tree (recursive array of tokens and/or nodes).
-- The given lineNumber will be assigned to the tokens found.
-- If the line is unfinished (ends with a comma token) then return (false, tokens).
-- If the line cannot be parsed then return nil and set the error state.
function parseJava.parseLine( sourceLine, lineNumber, startTokens, level )
	-- Run lexical analysis to get the tokens array
	tokens = javalex.getTokens( sourceLine, lineNumber )
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

	-- Discard comment tokens, except if the entire line is a comment
	if #tokens > 2 then
		local i = 1
		while i <= #tokens do
			if tokens[i].tt == "COMMENT" then
				table.remove( tokens, i )
			else
				i = i + 1
			end
		end
	end

	-- If this line ends in a comma token, then it is unfinished
	assert( #tokens > 0 )
	assert( tokens[#tokens].tt == "END" )
	local lastToken = tokens[#tokens - 1]  -- not counting the END
	if lastToken and lastToken.tt == "," then
		return false, tokens
	end

	-- Try to parse the line
	local tree = parseCurrentLine( level or numSyntaxLevels )
	if tree then
		tree.iLine = lineNumber  -- store Java line number in the top tree node
	end
	return tree
end

-- Print a parse tree recursively at the given indentLevel.
-- If file then output to it instead of the console.
function parseJava.printParseTree( node, indentLevel, file )
	if node then
		-- Make description string for this node
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

		-- Output description
		if file then
			file:write( s )
			file:write( "\n" )
		else 
			print(s)
		end

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
