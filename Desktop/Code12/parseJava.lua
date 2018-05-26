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



----- Grammar Tables ---------------------------------------------------------

-- An expression list
local exprList = { t = "exprList",
	{ 1, 12, "exprList",			expr,	list = true, sep = "," },
}

-- A primary expression (no binary operators)
primaryExpr = { t = "expr",
	{ 1, 12, "NUM",					"NUM" 									},
	{ 1, 12, "CHAR",				"CHAR" 									},
	{ 1, 12, "BOOL",				"BOOL" 									},
	{ 1, 12, "NULL",				"NULL" 									},
	{ 1, 12, "STR",					"STR" 									},
	{ 4, 12, "exprParens",			"(", expr, ")"							},
	{ 4, 12, "neg",					"-", parsePrimaryExpr 					},
	{ 4, 12, "!",					"!", parsePrimaryExpr 					},
	{ 5, 12, "fnCallParams",		"ID", "(", exprList, ")" 				},
	{ 5, 12, "fnCall",				"ID", "(", ")" 							},
	{ 7, 12, "methCallParams",		"ID", ".", "ID", "(", exprList, ")" 	},
	{ 7, 12, "methCall",			"ID", ".", "ID", "(", ")" 				},
	{ 6, 12, ".",					"ID", ".", "ID"							},
	{ 3, 12, "var",					"ID" 									},
}

-- An identifier list
local idList = { t = "idList",
	{ 1, 12, "idList",				"ID",	list = true, sep = "," },
}

-- A variable type
local varType = { t = "varType",
	{ 3, 12, "int",					"int" 		},
	{ 3, 12, "double",				"double" 	},
	{ 3, 12, "boolean",				"boolean" 	},
	{ 3, 12, "String",				"String" 	},
	{ 3, 12, "GameObj",				"GameObj" 	},
	{ 3, 12, "other",				"ID" 		},
}

-- An lvalue (var or expr that can be assigned to)
local lvalue = { t = "lvalue",
	{ 6, 12, "field",				"ID", ".", "ID"		},
	{ 3, 12, "var",					"ID" 				},
}

-- A statement
local stmt = { t = "stmt",
	{ 1, 12, "methCallParams",		"ID", ".", "ID", "(", exprList, ")" 		},
	{ 1, 12, "methCall",			"ID", ".", "ID", "(", ")" 					},
	{ 1, 12, "procCallParams",		"ID", "(", exprList, ")" 					},
	{ 1, 12, "procCall",			"ID", "(", ")" 								},
	{ 3, 12, "assign",				lvalue, "=", expr 							},
}

-- A line of code
local line = { t = "line",
	{ 1, 12, "stmt",				stmt, ";",								"END" },
	{ 3, 12, "varInit",				varType, "ID", "=", expr, ";",			"END" },
	{ 3, 12, "varDecl",				varType, idList, ";",					"END" },
	{ 3, 12, "constInit", 			"final", varType, "ID", "=", expr, ";",	"END" },
	{ 1, 12, "begin",				"{",									"END" },
	{ 1, 12, "end",					"}",									"END" },
	{ 1, 12, "eventFn",				"public", "void", "ID", "(", ")",		"END" },
	{ 1, 12, "importCode12",		"import", "ID", ".", "*", ";",			"END" },
	{ 1, 12, "classUser",			"class", "ID", "extends", "ID",			"END" },
	{ 8, 12, "if",					"if", "(", expr, ")",					"END" },
	{ 8, 12, "elseif",				"else", "if", "(", expr, ")",			"END" },
	{ 8, 12, "else",				"else", 								"END" },
	{ 1, 12, "blank",														"END" },
}


----- Internal functions -------------------------------------------------------

-- Debug trace
local function trace(message)
	-- print(message)
end


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
			trace("Trying " .. grammar.t .. "[" .. i .. "]")
			local nodes = parsePattern( pattern )
			if nodes then
				-- This pattern matches, so make a grammar node and return it
				local parseTree = {    -- TODO: get from pool
					t = grammar.t, 
					p = pattern[3],  -- pattern name
					nodes = nodes, 
				}
				-- trace("------")
				-- parseJava.printParseTree( parseTree, 0 )
				-- trace("------")
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
			trace("Matched token " .. iToken .. " " .. token.str)
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

-- Parse the given line of code at the given syntax level.
-- Return the parse tree (recursive array of tokens and/or nodes).
-- If the line cannot be parsed then return (nil, strErr, iChar) for a lexical error,
-- or just nil for an unknown syntax error.
function parseJava.parseLine( sourceLine, level )
	-- Run lexical analysis to get the tokens array
	local strErr, iChar
	tokens, strErr, iChar = javalex.getTokens( sourceLine )
	if tokens == nil then
		return nil, strErr, iChar
	end
	iToken = 1

	-- Discard comment tokens
	local i = 1
	while i <= #tokens do
		if tokens[i].tt == "COMMENT" then
			table.remove( tokens, i )
		else
			i = i + 1
		end
	end

	-- Set syntax level and try to parse the line grammar
	syntaxLevel = level
	local parseTree = parseGrammar( line )
	if parseTree == nil then
		-- print("*** Failed")
		return nil
	end
	-- print("*** Success:")
	-- parseJava.printParseTree( parseTree, 0 )
	return parseTree
end

-- Print a parse tree recursively at the given indentLevel
function parseJava.printParseTree( node, indentLevel )
	if node then
		local s = string.rep("\t", indentLevel)  -- indentation

		if node.tt then
			-- Token node
			s = s .. node.tt
			if node.str ~= node.tt then
				s = s .. " (" .. node.str .. ")"
			end
			print(s)
		else
			-- Sub-tree node
			s = s .. node.t 
			if node.p then
				s = s .. " (" .. node.p .. ")"
			end
			print(s)
			for i, child in ipairs(node.nodes) do
				parseJava.printParseTree( child, indentLevel + 1 )
			end
		end
	end
end


-----------------------------------------------------------------------------------------


-- Return the module
return parseJava
