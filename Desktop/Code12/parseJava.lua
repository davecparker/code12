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
local syntaxLevel	-- the syntax level for parsing (1-12, or 0 for full)


----- Grammar Tables ---------------------------------------------------------

-- A literal
local literal = { t = "literal",
	{ 1, 12, "num",		"NUM" },
	{ 1, 12, "str",		"STR" },
	{ 1, 12, "char",	"CHAR" },
	{ 1, 12, "bool",	"BOOL" },
	{ 1, 12, "null",	"NULL" },
}

-- An expression
local expr = { t = "expr",
	{ 1, 12, "literal",		literal },
	{ 3, 12, "var",			"ID" }
}

-- An expression list
local exprList = { t = "exprList",
	{ 1, 12, "exprList",	expr,	list = true, sep = "," },
}

-- A line of code
local line = { t = "line",
	{ 1, 12, "blank",				"END" },
	{ 1, 12, "importCode12",		"import", "ID", ".", "*", ";" },
	{ 1, 12, "classUser",			"class", "ID", "extends", "ID" },
	{ 1, 12, "eventFn",				"public", "void", "ID", "(", ")", "END" },
	{ 1, 12, "methCall",			"ID", ".", "ID", "(", ")", ";" },
	{ 1, 12, "methCallParams",		"ID", ".", "ID", "(", exprList, ")", ";" },
	{ 1, 12, "procCall",			"ID", "(", ")", ";" },
	{ 1, 12, "procCallParams",		"ID", "(", exprList, ")", ";" },
	{ 1, 12, "begin",				"{", "END" },
	{ 1, 12, "end",					"}", "END" },
}


----- Internal functions -------------------------------------------------------

-- Debug trace
local function trace(message)
	-- print(message)
end


-- Mutually recursive parsing functions defined below
local parseGrammar
local parsePattern
local printParseTree


-- Attempt to parse the given grammar table from the tokens starting at iStart,
-- at the current syntaxLevel. 
-- If successful then return (parseTree, iNext) where iNext is the index of the
-- next (unparsed) token. Return nil if failure.
function parseGrammar( grammar, iStart )
	-- Consider each pattern in the grammar table that includes the syntaxLevel
	for i = 1, #grammar do
		local pattern = grammar[i]
		if syntaxLevel == 0 or (syntaxLevel >= pattern[1] and syntaxLevel <= pattern[2]) then
			-- Try to match this pattern within the grammer table
			trace("Trying " .. grammar.t .. "[" .. i .. "]")
			local nodes, iNext = parsePattern( pattern, iStart )
			if nodes then
				-- This pattern matches, make grammar node and return it
				local parseTree = {    -- TODO: get from pool
					grammar = grammar, 
					patternIndex = i, 
					t = grammar.t, 
					p = pattern[3],  -- pattern name
					nodes = nodes, 
				}
				trace("------")
				--printParseTree( parseTree, 0 )
				trace("------")
				return parseTree, iNext
			end
		end
	end
	return nil  -- no matching patterns
end

-- Attempt to parse the given pattern within a grammar table, from the tokens 
-- starting at iStart, at the current syntaxLevel. 
-- If successful then return (nodeArray, iNext) where iNext is the index of the
-- next (unparsed) token. Return nil if failure.
function parsePattern( pattern, iStart )
	-- Try to match the pattern starting at the fist item (pattern[4])
	local nodes = {}   -- node array to build
	local iItem = 4
	local iToken = iStart
	while iItem <= #pattern do
		-- Is this pattern item a token or another grammar table?
		local item = pattern[iItem]
		if type(item) == "string" then
			-- Token: compare to next token
			local token = tokens[iToken]
			if not token or item ~= token.tt then
				return nil   -- required token type doesn't match next token
			end
			-- Matched a token
			trace("Matched token " .. iToken .. " " .. token.str)
			nodes[#nodes + 1] = token
			iToken = iToken + 1
		else
			-- Sub-grammar table item: try recursive parse
			local subTree, iNext = parseGrammar( item, iToken )
			if not subTree then
				return nil  -- could not parse sub-grammar item
			end
			-- Matched a sub-grammar item
			nodes[#nodes + 1] = subTree
			iToken = iNext
			trace("Matched sub-grammar, next token is #" .. iNext .. "(" .. tokens[iNext].str .. ")")
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
	return nodes, iToken
end

-- Print a parse tree recursively at the given indentLevel
function printParseTree( node, indentLevel )
	if node then
		local s = string.rep("   ", indentLevel)  -- indentation

		if node.grammar == nil then
			-- Token node
			s = s .. node.tt
			if node.str ~= node.tt then
				s = s .. " (" .. node.str .. ")"
			end
			print(s)
		else
			-- Sub-tree node
			s = s .. node.t .. " (pattern #" .. node.patternIndex .. " " .. node.p .. "):"
			print(s)
			local children = node.nodes
			for i = 1, #children do
				printParseTree( children[i], indentLevel + 1 )
			end
		end
	end
end


----- Module functions -------------------------------------------------------

-- Init the parsing state
function parseJava.init()
	javalex.init()
end

-- Parse the given line of code at the given syntax level (1-12, or 0 for full),
-- and return the parse tree (recursive array of tokens and/or grammar tables).
-- If the line cannot be parsed then return (nil, strErr, iChar) for a lexical error,
-- or just nil for an unknown syntax error.
function parseJava.parseLine( sourceLine, level )
	-- Run lexical analysis to get the tokens array
	local strErr, iChar
	tokens, strErr, iChar = javalex.getTokens( sourceLine )
	if tokens == nil then
		return nil, strErr, iChar
	end

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
	local parseTree = parseGrammar( line, 1 )
	if parseTree == nil then
		-- print("*** Failed")
		return nil
	end
	-- print("*** Success:")
	-- printParseTree( parseTree, 0 )
	return parseTree
end


-----------------------------------------------------------------------------------------

-- Do a quick parse test
-- printParseTree( parseJava.parseLine([[ ct.circle(x, y, 50, "red"); ]], 4), 0 )


-- Return the module
return parseJava
