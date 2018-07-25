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
	-- Public error record for the earliest error, or nil if none.
	rec = nil,
}

-- An error rec contains the following fields:
-- {
--     strErr,           -- error message text
--     loc = {           -- Source code location of the error
--	       iLine,        -- line number of the error
--	       iLineEnd,     -- ending line number (error may spans multiple lines)
--	       iCharStart,   -- char index of start of error, or nil for whole line
--	       iCharEnd,     -- last char index for the error, or nil for end of line
--     },
--     refLoc,           -- reference location if any (same fields as loc above)
--     pattern,   	     -- pattern name if syntax error matched common error pattern
--     nodes,            -- node array matched if common error pattern
--     level,            -- syntax level if higher level required to parse
-- }

-- In diagnostic error logging mode, we keep an error for each source line
local errRecForLine = nil    -- array mapping iLine to err record if logging


--- Utility Functions -------------------------------------------------------

-- Expand loc as necessary to contain the location spanned by node
local function expandLocToNode( loc, node )
	-- Is this a token or a parse tree?
	if node.tt then   -- token
		-- Update start position if this token is before
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
	else
		-- Non-token, search all children
		local nodes = node.nodes
		for i = 1, #nodes do
			expandLocToNode( loc, nodes[i] ) 
		end
	end
end

-- Make and return a loc record using the extent of the given parse tree node
local function errLocFromNode( node )
	local loc = {}
	expandLocToNode( loc, node )
	return loc
end

-- Make and return an err rec using:
--      loc           errLoc for main location of the error
--      refLoc        errLoc for an addition location to reference, or nil if none.
--      errInfo       string (strErr) or table (with strErr and additional fields)
--      ...           optional params to send to string.format( strErr, ... )
local function makeErrRec( loc, refLoc, errInfo, ... )
	local rec = {
		loc = loc,
		refLoc = refLoc,
	}
	if type( errInfo ) == "string" then
		rec.strErr = errInfo
	else
		for i, v in pairs( errInfo ) do
			rec[i] = v
		end
	end
	return rec
end


--- Module Functions -------------------------------------------------------


-- Init the error state for a new program
function err.initProgram()
	err.rec = nil
	errRecForLine = nil
end

-- Record an error with:
--      loc           errLoc for main location of the error
--      refLoc        errLoc for an addition location to reference, or nil if none.
--      errInfo       string (strErr) or table (with strErr and additional fields)
--      ...           optional params to send to string.format( strErr, ... )
function err.setErr( loc, refLoc, errInfo, ... )
	assert( type(loc) == "table" )
	assert( refLoc == nil or type(refLoc) == "table" )
	assert( type(errInfo) == "string" or type(errInfo) == "table" )

	-- Are we keeping an error for each line?
	local iLine = loc.iLine
	if errRecForLine then
		-- Keep only the first error on each line
		if errRecForLine[iLine] == nil then
			errRecForLine[iLine] = makeErrRec( loc, refLoc, errInfo, ... )
		end
	end

	-- Make err.rec keep the first error for the lowest line number
	if err.rec == nil or iLine < err.rec.loc.iLine then
		err.rec = makeErrRec( loc, refLoc, errInfo, ... )
	end
end

-- Record an error with:
--      iLine         line number for the error (entire line)
--      errInfo       string (strErr) or table (with strErr and additional fields)
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrLineNum( iLine, errInfo, ... )
	assert( type(iLine) == "number" )
	assert( type(errInfo) == "string" or type(errInfo) == "table" )

	-- Make a loc that indicates the entire line
	local loc = {
		iLine = iLine,
		iLineEnd = iLine,
	}
	err.setErr( loc, nil, errInfo, ... )
end

-- Record an error with:
--      node          parse tree for main location of the error
--      refNode       parse tree for an addition location to reference, or nil if none.
--      errInfo       string (strErr) or table (with strErr and additional fields)
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNodeAndRef( node, refNode, errInfo, ... )
	assert( type(node) == "table" )
	assert( refNode == nil or type(refNode) == "table" )
	assert( type(errInfo) == "string" or type(errInfo) == "table" )

	err.setErr( errLocFromNode( node ), errLocFromNode( refNode ), strErr, ... )
end

-- Record an error with:
--      node          parse tree for location of the error
--      errInfo       string (strErr) or table (with strErr and additional fields)
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNode( node, errInfo, ... )
	assert( type(node) == "table" )
	assert( type(errInfo) == "string" or type(errInfo) == "table" )

	err.setErr( errLocFromNode( node ), nil, errInfo, ... )
end

-- Record an error with:
--      firstToken    first token for location of the error
--      lastToken     last token for token span containing the error
--      errInfo       string (strErr) or table (with strErr and additional fields)
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrTokenSpan( firstToken, lastToken, errInfo, ... )
	assert( type(firstToken) == "table" )
	assert( firstToken.tt )
	assert( type(lastToken) == "table" )
	assert( lastToken.tt )
	assert( type(errInfo) == "string" or type(errInfo) == "table" )

	local loc = errLocFromNode( firstToken )
	expandLocToNode( loc, lastToken  )
	err.setErr( loc, nil, errInfo, ... )
end

-- Return true if there is an error in the error state.
function err.hasErr()
	return (err.rec ~= nil)
end

-- Return the error record (nil if no error)
function err.getErrRecord()
	return err.rec
end

-- Return a string describing the error state, or return nil if no error
function err.getErrString()
	if err.rec then
		local rec = err.rec
		local loc = rec.loc
		if loc.iLineEnd ~= loc.iLine then
			return string.format( "*** Lines %d-%d: %s", 
						loc.iLine, loc.iLineEnd, rec.strErr )
		elseif loc.iCharStart == nil then
			return string.format( "*** Line %d: %s", loc.iLine, rec.strErr )
		else
			local str = string.format( "*** Line %d chars %d-%d: %s",
							loc.iLine, loc.iCharStart, loc.iCharEnd, rec.strErr ) 
			if rec.refLoc then
				str = str .. string.format( "\n*** Reference line %d", rec.refLoc.iLine )
			end
			return str
		end
	end
	return nil
end

-- Clear the last error recorded
function err.clearErr()
	err.rec = nil
end

-- Set the error logging mode that keeps an error for each line
function err.logAllErrors()
	errRecForLine = {}
end

-- Get the logged error for the given line number
function err.getLoggedErrForLine( iLine )
	return errRecForLine[iLine]
end

-- Return true if we should stop on errors
function err.stopOnErrors()
	return errRecForLine == nil
end


------------------------------------------------------------------------------

return err
