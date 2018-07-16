-----------------------------------------------------------------------------------------
--
-- err.lua
--
-- Utilities to create and track the Error state for Code12.
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- Code12 modules
local g = require( "Code12.globals" )

-- The err module
local err = {}


-- The error state. We only detect and store the first error in the program.
-- The errRecord is a table as follows:
-- {
-- 	   strErr = "Error text",
--     loc = {     -- error location
--         first = { iLine = lineNumber, iChar = charIndex },
--         last  = { iLine = lineNumber, iChar = charIndex },
--     },
--     refLoc = {   -- other referenced location or nil if none
--         first = { iLine = lineNumber, iChar = charIndex },
--         last  = { iLine = lineNumber, iChar = charIndex },
--     },
-- }
local errRecord


--- Utility Functions -------------------------------------------------------

-- Find the bounds of the location spanned by node and store it in errLoc
-- (see err.makeErrLoc) 
local function findNodeLoc( node, errLoc )
	-- Is this a token or a parse tree?
	if node.tt then
		-- Token
		-- Update first position if this token is before
		if errLoc.first.iLine == nil or node.iLine < errLoc.first.iLine then
			errLoc.first.iLine = node.iLine
			errLoc.first.iChar = nil
		end
		if errLoc.first.iChar == nil or node.iChar < errLoc.first.iChar then
			errLoc.first.iChar = node.iChar
		end
		-- Update last position if this token is after
		if errLoc.last.iLine == nil or node.iLine > errLoc.last.iLine then
			errLoc.last.iLine = node.iLine
			errLoc.last.iChar = nil
		end
		local iCharLast = node.iChar + string.len( node.str ) - 1
		if errLoc.last.iChar == nil or iCharLast > errLoc.last.iChar then
			errLoc.last.iChar = iCharLast
		end
	else
		-- Non-token, search all children
		local nodes = node.nodes
		for i = 1, #nodes do
			findNodeLoc( nodes[i], errLoc ) 
		end
	end
end

-- Make and return an errLoc (see err.makeErrLoc) using the extent of the given
-- parse tree node for the location.
local function errLocFromNode( node )
	local errLoc = { first = {}, last = {} }
	findNodeLoc( node, errLoc )
	return errLoc
end


--- Module Functions -------------------------------------------------------


-- Init the error state for a new program
function err.initProgram()
	errRecord = nil
end

-- Make and return a srcLoc record from the given fields.
-- A srcLoc (source code location) is a table with the following named fields:
--      iLine      source code line number
--      iChar      character index in the source line
function err.makeSrcLoc( iLine, iChar )
	assert( type(iLine) == "number" )
	assert( type(iChar) == "number" )
	return { iLine = iLine, iChar = iChar }
end

-- Make and return an errLoc with the given fields.
-- An errLoc (error location) is a table with the following named fields:
--      first      srcLoc of first part of affected code
--      last       srcLoc of last part of affected code, or nil for whole line
function err.makeErrLoc( first, last )
	-- print( string.format( "makeErrLoc  %d.%d  to  %d.%d", first.iLine, first.iChar, last.iLine, last.iChar ) )
	return { first = first, last = last }
end

-- If there is not already an error recorded, then set the error state with:
--      loc           errLoc for main location of the error
--      refLoc        errLoc for an addition location to reference, or nil if none.
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErr( loc, refLoc, strErr, ... )
	assert( type(loc) == "table" and loc.first ~= nil )
	if refLoc then
		assert( type(refLoc) == "table" and refLoc.first ~= nil )
	end
	assert( type(strErr) == "string" )

	local errNew = { strErr = string.format( strErr, ...), loc = loc, refLoc = refLoc }
	if g.fnLogErr then
		-- In diagnostic mode, report every error but don't store the error state 
		-- in errRecord (force checking to continue). 
		g.fnLogErr( errNew )
	else
		-- Only set the error state if not already set (take the first error only)
		if errRecord == nil then
			errRecord = errNew
		end
	end
end

-- If there is not already an error recorded, then set the error state with:
--      iLine         line number for the error (entire line)
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrLineNum( iLine, strErr, ... )
	err.setErr( err.makeErrLoc( err.makeSrcLoc( iLine, 1 ) ), nil, strErr, ... )
end

-- If there is not already an error recorded, then set the error state with:
--      node          parse tree for main location of the error
--      refNode       parse tree for an addition location to reference, or nil if none.
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNodeAndRef( node, refNode, strErr, ... )
	assert( type(node) == "table" )
	if refNode then
		assert( type(refNode) == "table" )
	end
	assert( type(strErr) == "string" )
	err.setErr( errLocFromNode( node ), errLocFromNode( refNode ), strErr, ... )
end

-- If there is not already an error recorded, then set the error state with:
--      node          parse tree for location of the error
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNode( node, strErr, ... )
	assert( type(node) == "table" )
	assert( type(strErr) == "string" )
	err.setErr( errLocFromNode( node ), nil, strErr, ... )
end

-- If there is not already an error recorded, then set the error state with:
--      firstToken    first token for location of the error
--      lastToken     last token for token span containing the error
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrTokenSpan( firstToken, lastToken, strErr, ... )
	assert( type(firstToken) == "table" )
	assert( firstToken.tt )
	assert( type(lastToken) == "table" )
	assert( lastToken.tt )
	assert( type(strErr) == "string" )
	local locStart = err.makeSrcLoc( firstToken.iLine, firstToken.iChar )
	local iCharLast = lastToken.iChar + string.len( lastToken.str ) - 1
	local locEnd = err.makeSrcLoc( lastToken.iLine, iCharLast )
	err.setErr( err.makeErrLoc( locStart, locEnd ), nil, strErr, ... )
end

-- Return true if there is an error in the error state.
function err.hasErr()
	return (errRecord ~= nil)
end

-- Return the error record (nil if no error)
function err.getErrRecord()
	return errRecord
end

-- Return a string describing the error state, or return nil if no error
function err.getErrString()
	if errRecord then
		local str = string.format( "*** Location %d.%d to %d.%d: %s", 
						errRecord.loc.first.iLine, errRecord.loc.first.iChar, 
						errRecord.loc.last.iLine, errRecord.loc.last.iChar, 
						errRecord.strErr ) 
		if errRecord.refLoc then
			str = str .. string.format( "\n*** Reference %d.%d to %d.%d", 
							errRecord.refLoc.first.iLine, errRecord.refLoc.first.iChar, 
							errRecord.refLoc.last.iLine, errRecord.refLoc.last.iChar )
		end
		return str
	end
	return nil
end

-- Clear the error state
function err.clearErr()
	errRecord = nil
end


------------------------------------------------------------------------------

return err
