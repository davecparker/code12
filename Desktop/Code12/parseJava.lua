-----------------------------------------------------------------------------------------
--
-- parseJava.lua
--
-- Implements parsing for Java in the Code12 system.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules used
local javalex = require( "javalex" )
local err = require( "err" )


-- The parseJava module
local parseJava = {}


----- File Local Variables  --------------------------------------------------

-- The parsing state
local tokens     	-- array of tokens
local iToken        -- index of current token in tokens
local syntaxLevel	-- the syntax level for parsing

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
	["!="]	= 8,
	["&"]	= 7,
	["^"]	= 6,
	["|"]	= 5,
	["&&"]	= 4,
	["||"]	= 3,
	["?"]	= 2,
	[":"]	= 2,
}


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

-- Parse a function value (an expression that can be called as a function).
-- This is either just an ID, or ID.ID, and if the object ID is "ct" then
-- the "ct." is added to the front of the method name to make a single name.
-- This is done for convenience and performance.
-- Return an ID token for a simple name (or ct.name), a method pattern node
-- for other object.method names, or nil if failure.
local function fnValue()
	local token = tokens[iToken]
	if token.tt ~= "ID" then
		return nil    -- not an ID
	end
	iToken = iToken + 1
	if tokens[iToken].tt ~= "." then
		return token   -- simple name token
	end
	iToken = iToken + 1
	local token2 = tokens[iToken]
	if token2.tt ~= "ID" then
		return nil   -- expected ID after .
	end
	iToken = iToken + 1	
	if token.str == "ct" then
		token2.str = "ct." .. token2.str
		return token2   -- ct.name token
	end
	-- Return a method pattern node
	return { t = "fnValue", p = "method", nodes = { token, token2 } }
end


----- Grammar Tables ---------------------------------------------------------

-- An lValue (var or expr that can be assigned to)
local lValue = { t = "lValue",
	{ 6, 12, "field",			"ID", ".", "ID"			},
	{ 12, 12, "index",			"ID", "[", expr, "]"	},
	{ 3, 12, "var",				"ID" 					},
	{ 6, 12, "this",			"this", ".", "ID"		},
}

-- A return type for a procedure/function definition
local retType = { t = "retType",
	{ 9, 12, "void",			"void" 					},
	{ 12, 12, "array",			"ID", "[", "]"			},
	{ 9, 12, "value",			"ID"					},
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
	{ 4, 12, "exprParens",		"(", expr, ")"						},
	{ 4, 12, "neg",				"-", parsePrimaryExpr 				},
	{ 4, 12, "!",				"!", parsePrimaryExpr 				},
	{ 5, 12, "call",			fnValue, "(", exprList, ")" 		},
	{ 4, 12, "lValue",			lValue								},
}

-- The right side of things that can be done to an lValue in a stmt
local rightSide = { t = "rightSide",
	{ 3, 12, "=",				"=", expr 		},
	{ 4, 12, "+=",				"+=", expr 		},
	{ 4, 12, "-=",				"-=", expr 		},
	{ 4, 12, "*=",				"*=", expr 		},
	{ 4, 12, "/=",				"/=", expr 		},
	{ 4, 12, "++",				"++"			},
	{ 4, 12, "--",				"--"			},
}

-- A statement
local stmt = { t = "stmt",
	{ 1, 12, "call",			fnValue, "(", exprList, ")" 		},
	{ 3, 12, "assign",			lValue, rightSide 					},
	{ 4, 12, "++",				"++", lValue 						},
	{ 4, 12, "--",				"--", lValue						},
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
}

-- An array initializer
local arrayInit = { t = "arrayInit",
	{ 12, 12, "new", 			"new", "ID", "[", expr, "]"					},
	{ 12, 12, "list", 			"{", exprList, "}"							},
}

-- A line of code
local line = { t = "line",
	{ 1, 12, "blank",															"END" },
	{ 1, 12, "comment",			"COMMENT",										"END" },
	{ 1, 12, "stmt",			stmt, ";",										"END" },
	{ 3, 12, "varInit",			"ID", "ID", "=", expr, ";",						"END" },
	{ 3, 12, "varDecl",			"ID", idList, ";",								"END" },
	{ 3, 12, "constInit", 		"final", "ID", "ID", "=", expr, ";",			"END" },
	{ 1, 12, "begin",			"{",											"END" },
	{ 1, 12, "end",				"}",											"END" },
	{ 1, 12, "eventFn",			"public", "void", "ID", "(", paramList, ")",	"END" },
	{ 8, 12, "if",				"if", "(", expr, ")",							"END" },
	{ 8, 12, "elseif",			"else", "if", "(", expr, ")",					"END" },
	{ 8, 12, "else",			"else", 										"END" },
	{ 9, 12, "func",			retType, "ID", "(", paramList, ")",				"END" },
	{ 9, 12, "return",			"return", expr, ";",							"END" },
	{ 11, 12, "do",				"do", 											"END" },
	{ 11, 12, "while",			"while", "(", expr, whileEnd,					"END" },
	{ 11, 12, "for",			"for", "(", forControl, ")",					"END" },
	{ 12, 12, "array",			"ID", "[", "]", "ID", "=", arrayInit, ";",		"END" },
	-- Boilerplate lines
	{ 1, 12, "importCode12",	"import", "ID", ".", "*", ";",					"END" },
	{ 1, 12, "classUser",		"class", "ID", "extends", "ID",					"END" },
	{ 1, 12, "main",			"public", "static", "void", "ID", 
									"(", "ID", "[", "]", "ID", ")",				"END" },
	{ 1, 12, "Code12Run",		"ID", ".", "ID", "(", "new", 
									"ID", "(", ")", ")", ";",					"END" },

}


----- Parsing Functions --------------------------------------------------------

-- Unless otherwise specified, parsing functions parse the tokens array starting 
-- at iToken, considering only patterns that are defined within the syntaxLevel.
-- They return a parse tree, or nil if failure.
-- A parse tree is either:
-- 		a token, for example:
--          { tt = "ID", str = "foo", iChar = 23 }
--      or a node, for example:
--          { t = "line", p = "stmt", nodes = {...} }
--      where t is the grammar or function name, p is the pattern name if any,
--		and nodes is an array of children parse tree nodes


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
			return nil  -- expected expression after binary op
		end
		-- Check for another op after this op's expr and compare precedence
		token = tokens[iToken]
		prec = binaryOpPrecedence[token.tt]
		while prec and prec > opPrec do
			-- Higher precedence op follows, so recurse to the right
			rightSide = parseOpExpr( rightSide, prec )
			if rightSide == nil then
				return nil  -- expected expression after binary op
			end
			-- Keep looking for the next op
			token = tokens[iToken]
			prec = binaryOpPrecedence[token.tt]
		end
		-- Build the node for this op
		leftSide = { t = "expr", p = op.tt, nodes = { leftSide, rightSide } }
	end
	return leftSide
end

-- Attempt to parse the given grammar table
function parseGrammar( grammar )
	-- Consider each pattern in the grammar table that includes the syntaxLevel
	local iStart = iToken
	for i = 1, #grammar do
		local pattern = grammar[i]
		if syntaxLevel >= pattern[1] and syntaxLevel <= pattern[2] then
			-- Try to match this pattern within the grammer table
			trace("Trying " .. grammar.t .. "[" .. i .. "] (" .. pattern[3] .. ")")
			local nodes = parsePattern( pattern )
			if nodes then
				-- This pattern matches, so make a grammar node and return it
				local parseTree = {    -- TODO: get from pool
					t = grammar.t, 
					p = pattern[3],  -- pattern name
					nodes = nodes, 
				}
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
		-- Is this pattern item a token, grammar table, or parsing function?
		local item = pattern[iItem]
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


----- Module functions -------------------------------------------------------

-- Init the parsing state
function parseJava.init()
	javalex.init()
end

-- Parse the given line of code at the given syntax level (default 12).
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
		local iToken = #startTokens   -- overwrite the END
		for i = 1, #tokens do
			startTokens[iToken] = tokens[i]
			iToken = iToken + 1
		end
		tokens = startTokens
		startTokens = nil
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

	-- Set syntax level and try to parse the line grammar
	syntaxLevel = level or 12
	iToken = 1
	local parseTree = parseGrammar( line )
	if parseTree == nil then
		if not err.hasErr() then
			-- Unknown error: Set generic syntax error for the entire line.
			assert( lastToken )    -- blank lines can't be syntax errors
			local iCharLast = lastToken.iChar + string.len( lastToken.str ) - 1
			local locStart = err.makeSrcLoc( lineNumber, 1 )
			local locEnd = err.makeSrcLoc( lineNumber, iCharLast )
			err.setErr( err.makeErrLoc( locStart, locEnd ), nil, "Syntax Error" )
		end
		return nil
	end
	return parseTree
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
			for i, child in ipairs(node.nodes) do
				parseJava.printParseTree( child, indentLevel + 1, file )
			end
		end
	end
end


-----------------------------------------------------------------------------------------


-- Return the module
return parseJava
