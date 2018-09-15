-----------------------------------------------------------------------------------------
--
-- err.lua
--
-- Utilities to create and track the Error state for Code12.
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- The err module
local err = {
	bulkTestMode = false    -- set to true for bulk error test drivers
}


-- An error rec contains the following fields:
-- {
--     iLineRank,        -- line number to use for determining the "first" error
--     strErr,           -- error message text
--     loc = {           -- Source code location of the error
--	       iLine,        -- line number of the start of the error
--	       iLineEnd,     -- ending line number (error may spans multiple lines)
--	       iCharStart,   -- char index of start of error, or nil for whole line
--	       iCharEnd,     -- last char index for the error, or nil for end of line
--     },
--     refLoc,           -- reference location if any (same fields as loc above)
-- }

-- Array mapping iLine to err record, to store the first error on each line
local errRecForLine

-- Line numbers for the first and last error known
local iLineFirstErr
local iLineLastErr

-- A set of lines that were found to be incomplete (map lineNumber to true).
-- The err.iLineRank is determined by the first line that is not incomplete.
local incompleteLines


--- Utility Functions -------------------------------------------------------

-- Expand loc as necessary to contain the location spanned by node,
-- which can be a token, parse tree node, or strucure node.
local function expandLocToNode( loc, node )
	assert( type(node) == "table" )
	if node.tt then
		-- Token: update start position if this token is before
		if loc.iLine == nil or node.iLine < loc.iLine then
			loc.iLine = node.iLine
			loc.iCharStart = nil
			loc.iCharEnd = nil
		end
		if loc.iCharStart == nil or node.iChar < loc.iCharStart then
			loc.iCharStart = node.iChar
		end
		-- Update end position if this token is after
		if loc.iLineEnd == nil or node.iLine > loc.iLineEnd then
			loc.iLineEnd = node.iLine
		end
		local iCharEnd = node.iChar + string.len( node.str ) - 1
		if loc.iCharEnd == nil or iCharEnd > loc.iCharEnd then
			loc.iCharEnd = iCharEnd
		end
	elseif node.t then
		-- Parse tree node: expand to all children
		for _, child in ipairs(node.nodes) do
			expandLocToNode( loc, child ) 
		end
	elseif node.s or #node then
		-- Structure node or array: expand to all children
		for _, child in pairs(node) do
			if type(child) == "table" then
				expandLocToNode( loc, child )
			end
		end
	end
end

-- Return a loc representing the entire source line at iLine
local function locEntireLine( iLine )
	return { iLine = iLine, iLineEnd = iLine }
end

-- Make and return a loc record using the extent of the given parse tree or structure node
local function errLocFromNode( node )
	assert( type(node) == "table" )
	if node.isError or (node.s and node.entireLine and node.iLine) then
		return locEntireLine( node.iLine )
	end
	local loc = {}
	expandLocToNode( loc, node )
	return loc
end

-- Make and return an err rec using:
--      iLineRank     line number to rank this error by
--      loc           errLoc for main location of the error
--      refLoc        errLoc for an addition location to reference, or nil if none.
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
local function makeErrRec( iLineRank, loc, refLoc, strErr, ... )
	return {
		iLineRank = iLineRank,
		strErr = string.format( strErr, ... ),
		loc = loc,
		refLoc = refLoc,
	}
end

-- Return the line number used to rank an error on iLine 
-- (incomplete lines are forwarded and reported on the final line).
local function iLineRankFromILine( iLine )
	while incompleteLines[iLine] do
		iLine = iLine + 1
	end
	return iLine
end

-- Return a string describing the given loc
function err.getLocString( loc )
	if loc.iLineEnd ~= loc.iLine then   -- Multi-line
		return string.format( "Lines %d-%d", loc.iLine, loc.iLineEnd )
	elseif loc.iCharStart == nil then   -- Whole line
		return string.format( "Line %d", loc.iLine )
	elseif loc.iCharStart == loc.iCharEnd then   -- Single char
		return string.format( "Line %d char %d", loc.iLine, loc.iCharStart ) 
	else   -- Char range
		return string.format( "Line %d chars %d-%d",
					loc.iLine, loc.iCharStart, loc.iCharEnd ) 
	end
end


--- Module Functions -------------------------------------------------------


-- Init the error state for a new program
function err.initProgram()
	errRecForLine = {}
	incompleteLines = {}
	iLineFirstErr = nil
	iLineLastErr = nil
end

-- Mark the given line number as incomplete (tokens were forward to the next line)
function err.markIncompleteLine( iLine )
	assert( type(iLine) == "number" )
	incompleteLines[iLine] = true
end

-- Record an error with:
--      loc           errLoc for main location of the error
--      refLoc        errLoc for an addition location to reference, or nil if none.
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErr( loc, refLoc, strErr, ... )
	assert( type(loc) == "table" )
	assert( refLoc == nil or type(refLoc) == "table" )
	assert( type(strErr) == "string" )

	-- Determine the line number that we are ranking this error with 
	local iLineRank = iLineRankFromILine( loc.iLine )

	-- Keep only the first error on each line
	if errRecForLine[iLineRank] == nil then
		errRecForLine[iLineRank] = makeErrRec( iLineRank, loc, refLoc, strErr, ... )

		-- Keep track of the first and last line numbers with errors
		if iLineFirstErr == nil or iLineRank < iLineFirstErr then
			iLineFirstErr = iLineRank
		end
		if iLineLastErr == nil or iLineRank > iLineLastErr then
			iLineLastErr = iLineRank
		end
	end
end

-- Record an error with:
--      iLine         line number for the error (entire line)
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrLineNum( iLine, strErr, ... )
	assert( type(iLine) == "number" )
	assert( type(strErr) == "string" )

	-- Make a loc that indicates the entire line
	err.setErr( locEntireLine( iLine ), nil, strErr, ... )
end

-- Record an error with:
--      iLine         line number for the error (entire line)
--      iLineRef      line number for the line to reference (entire line)
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrLineNumAndRefLineNum( iLine, iLineRef, strErr, ... )
	assert( type(iLine) == "number" )
	assert( type(iLineRef) == "number" )
	assert( type(strErr) == "string" )

	-- Make locs that indicates the entire lines
	err.setErr( locEntireLine( iLine ), locEntireLine( iLineRef ), strErr, ... )
end

-- Record an error with:
--      iLine         line number for the error
--      iCharStart    starting char index
--      iCharEnd      ending char index
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrCharRange( iLine, iCharStart, iCharEnd, strErr, ... )
	assert( type(iLine) == "number" )
	assert( type(iCharStart) == "number" )
	assert( type(iCharEnd) == "number" )
	assert( type(strErr) == "string" )

	local loc = {
		iLine = iLine,
		iLineEnd = iLine,
		iCharStart = iCharStart,
		iCharEnd = iCharEnd,
	}
	err.setErr( loc, nil, strErr, ... )
end

-- Record an error with:
--      node          parse or structure node for main location of the error
--      refNode       parse or structure node for addition loc to reference, or nil if none.
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNodeAndRef( node, refNode, strErr, ... )
	assert( type(node) == "table" )
	assert( refNode == nil or type(refNode) == "table" )
	assert( type(strErr) == "string" )

	if refNode then
		err.setErr( errLocFromNode( node ), errLocFromNode( refNode ), strErr, ... )
	else
		err.setErr( errLocFromNode( node ), nil, strErr, ... )
	end
end

-- Record an error with:
--      node          parse or structure node for location of the error
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNode( node, strErr, ... )
	assert( type(node) == "table" )
	assert( type(strErr) == "string" )

	err.setErr( errLocFromNode( node ), nil, strErr, ... )
end

-- Record an error for missing code with:
--      node          parse or structure node right after the missing code
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNodeMissing( node, strErr, ... )
	assert( type(node) == "table" )
	assert( type(strErr) == "string" )

	local loc = errLocFromNode( node )
	local iCharNode = loc.iCharStart
	if iCharNode then
		-- Try to hilight the space/char before the node
		loc.iCharStart = math.max( 1, iCharNode - 1 )
		loc.iCharEnd = loc.iCharStart
	end 
	err.setErr( loc, nil, strErr, ... )
end

-- Record an error with:
--      firstNode     first node for location of the error
--      lastNode      last node for token span containing the error
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNodeSpan( firstNode, lastNode, strErr, ... )
	assert( type(firstNode) == "table" )
	assert( type(lastNode) == "table" )
	assert( type(strErr) == "string" )

	local loc = errLocFromNode( firstNode )
	expandLocToNode( loc, lastNode  )
	err.setErr( loc, nil, strErr, ... )
end

-- Record an error with:
--      tree          A line parse tree
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrLineParseTree( tree, strErr, ... )
	assert( type(tree) == "table" )
	local iLine = tree.iLine
	assert( type(iLine) == "number" )
	assert( type(strErr) == "string" )

	err.setErrLineNum( iLine, strErr, ... )
end

-- Override any error currently on the tree's line and record an error with:
--      tree          A line parse tree
--      strErr        error message string
--      ...           optional params to send to string.format( strErr, ... )
function err.overrideErrLineParseTree( tree, strErr, ... )
	assert( type(tree) == "table" )
	local iLine = tree.iLine
	assert( type(iLine) == "number" )
	assert( type(strErr) == "string" )

	err.clearErr( iLine )
	err.setErrLineNum( iLine, strErr, ... )
end

-- Return a string describing the given error rec, or return nil if no error
function err.getErrString( rec )
	if rec == nil then
		return nil
	end
	local str = "*** " .. err.getLocString( rec.loc ) .. ": " .. rec.strErr
	if rec.refLoc then
		str = str .. "\n*** Reference " .. err.getLocString( rec.refLoc )
	end
	return str
end

-- Clear the error for the given line number, if any
function err.clearErr( iLine )
	assert( type(iLine) == "number" )
	errRecForLine[iLineRankFromILine( iLine )] = nil
end

-- Return the logged error for the given line number, or nil if none.
function err.errRecForLine( iLine )
	assert( type(iLine) == "number" )
	return errRecForLine[iLine]
end

-- Return an array of line numbers that have errors
function err.lineNumbersWithErrors()
	-- Find the first line if any
	local lineNumbers = {}
	if iLineFirstErr == nil then
		return lineNumbers
	end
	local iLine = iLineFirstErr   -- might have gotten cleared so loop below
	while errRecForLine[iLine] == nil do
		iLine = iLine + 1
		if iLine > iLineLastErr then
			return lineNumbers
		end
	end
	lineNumbers[1] = iLine

	-- Add all the line numbers that have errors
	for i = iLine + 1, iLineLastErr do
		if errRecForLine[i] then
			lineNumbers[#lineNumbers + 1] = i
		end
	end
	return lineNumbers
end

-- Return true if the program has an error in it
function err.hasErr()
	if iLineFirstErr == nil then
		return false
	end
	return #err.lineNumbersWithErrors() > 0
end


------------------------------------------------------------------------------

return err
