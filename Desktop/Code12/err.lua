-----------------------------------------------------------------------------------------
--
-- err.lua
--
-- Utilities to create and track the Error state for Code12.
--
-- (c)Copyright 2018 by David C. Parker 
-----------------------------------------------------------------------------------------

-- The err module
local err = {}



-- The error state. We only detect and store the first error in the program.
local errRecord



--- Utility Functions -------------------------------------------------------

-- Find the bounds of the location spanned by node and store it in errLoc
-- (see err.makeErrLoc) 
local function findNodeLoc( node, errLoc )
	-- Is this a token or a parse tree?
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
	assert( typeof(iLine) == "number" )
	assert( typeof(iChar) == "number" )
	return { iLine = iLine, iChar = iChar }
end

-- Make and return an errLoc with the given fields.
-- An errLoc (error location) is a table with the following named fields:
--      first      srcLoc of first part of affected code
--      last       srcLoc of last part of affected code
function err.makeErrLoc( first, last )
	return { first = first, last = last }
end

-- Make and return an errLoc (see err.makeErrLoc) using the extent of the given
-- parse tree node for the location.
function err.errLocFromNode( node )
	local errLoc = { first = {}, last = {} }
	findNodeLoc( node, errLoc )
	return errLoc
end

-- If there is not already an error recorded, then set the error state with:
--      loc           errLoc for main location of the error
--      refLoc        errLoc for an addition location to reference, or nil if none.
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErr( loc, refLoc, strErr, ... )
	assert( typeof(loc) == "table" and loc.iLine ~= nil )
	if refLoc then
		assert( typeof(refLoc) == "table" and refLoc.iLine ~= nil )
	end
	assert( typeof(strErr) == "string" )
	if errRecord == nil then
		errRecord = { strErr = string.format( strErr, ...), loc = loc, refLoc = refLoc }
	end
end

-- If there is not already an error recorded, then set the error state with:
--      node          parse tree for main location of the error
--      refNode       parse tree for an addition location to reference, or nil if none.
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNodeAndRef( node, refNode, strErr, ... )
	assert( typeof(node) == "table" )
	if refNode then
		assert( typeof(refNode) == "table" )
	end
	assert( typeof(strErr) == "string" )
	err.setErr( errLocFromNode( node ), errLocFromNode( refNode ), strErr, ... )
end

-- If there is not already an error recorded, then set the error state with:
--      node          parse tree for location of the error
--      strErr        string message for the error
--      ...           optional params to send to string.format( strErr, ... )
function err.setErrNode( node, strErr, ... )
	assert( typeof(node) == "table" )
	assert( typeof(strErr) == "string" )
	err.setErr( errLocFromNode( node ), nil, strErr, ... )
end

-- If an error occurred then and display it and return true, else return false.
function err.hasError()
	if errRecord then
		print( string.format( "*** Location %d.%d to %d.%d: %s", 
					errRecord.loc.first.iLine, errRecord.loc.first.Char, 
					errRecord.loc.last.iLine, errRecord.loc.last.Char, 
					errRecord.strErr ) )
		if errRecord.refLoc then
			print( string.format( "*** Reference %d.%d to %d.%d", 
						errRecord.refLoc.first.iLine, errRecord.refLoc.first.Char, 
						errRecord.refLoc.last.iLine, errRecord.refLoc.last.Char ) )
		end
		return true
	end
	return false
end


------------------------------------------------------------------------------

return err
