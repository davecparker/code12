-----------------------------------------------------------------------------------------
--
-- source.lua
--
-- Data structures and utilities for the source code of a Code 12 program.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------


-- The source module with public data fields
local source =  {
	-- These are set by the main program
	path = nil,                  -- full pathname to the source code file
	timeModLast = 0,             -- last modification time or 0 if unknown
	updated = false,             -- set to true when file update is detected

	-- These are set by source.readFile()
	timeLoaded = 0,              -- time this file was loaded or 0 if not loaded
	strLines = nil,              -- array of source lines from last read of file

	-- Array of line records built by the last parse, indexed by line number.
	-- Note that immediately after a call to source.readFile(), source.strLines 
	-- contains the new lines, and source.lines contains the data built by the 
	-- last parse, which will be reused when possible.
	numLines = 0,  -- number of lines relevant to this parse (lines may have more)
	lines = {},    -- each record contains:
	-- {
	--     -- These are set by program parsing
	--     iLine,                -- line number in file = index of this record in lines
	--     str,                  -- source code string for this line
	--
	--     -- These are set by lexical analysis
	--     commentStr,           -- comment string at end of the line or nil if none
	--     iLineCommentStart,    -- start iLine of block comment involving this line, or nil
	--     openComment,          -- true if line ends with an unclosed block comment
	--     hasCode,              -- true if the line has code (not blank or just comment)
	--     indentLevel,          -- indent level calculated for this line
	--     indentStr,            -- substring of line that is indent at the beginning
	--
	--     -- These are set by line parsing
	--     iLineStart,           -- starting line number if multi-line parse, else nil
	--     parseTree,            -- parse tree for line, false if incomplete, nil if error
	-- }

	-- Cache of source lines mapped to line records for lines that can be reused
	lineCacheForStrLine = {}
}


--- Utility Functions ----------------------------------------------------------------

-- If path then set source.path to it, otherwise use the existing source.path.
-- Read the source and store all of its source lines in source.strLines.
-- Return true if success.
function source.readFile( path )
	if path then
		source.path = path
	end
	local success = false
	if source.path then
		local file = io.open( source.path, "r" )
		if file then
			-- Try to read the first line to see if it's really readable now
			local s = file:read( "*l" )
			if s then
				source.timeLoaded = os.time()
				source.strLines = {}   -- replace previous lines if any
				local strs = source.strLines
				local lineNum = 1
				repeat
					strs[lineNum] = s
					lineNum = lineNum + 1
					s = file:read( "*l" )  -- read next line
				until s == nil
				success = true
			end
			io.close( file )
		end
	end
	return success
end


------------------------------------------------------------------------------
return source
