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
	path = nil,              -- full pathname to the source code file
	timeLoaded = 0,          -- time this file was loaded or 0 if not loaded
	timeModLast = 0,         -- last modification time or 0 if unknown
	updated = false,         -- set to true when file update is detected
	numLines = 0,            -- number of source lines
	lines = {},              -- array of record for each source line, each with:
	-- {
	--     iLine = number,       -- index of this record in lines (line number in file)
	--     str = string,         -- source code string for this line
	--     comment = string,     -- comment string at end of this line if any
	-- }
}


--- Utility Functions ----------------------------------------------------------------

-- If path then set source.path to it, otherwise use the existing source.path.
-- Read the source and store all of its source lines.
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
				source.lines = {}   -- replace previous lines if any
				local lineNum = 1
				repeat
					source.lines[lineNum] = { iLine = lineNum, str = s }
					lineNum = lineNum + 1
					s = file:read( "*l" )  -- read next line
				until s == nil
				source.numLines = lineNum - 1
				source.lines[lineNum] = { iLine = lineNum, str = "" }  -- sentinel
				success = true
			end
			io.close( file )
		end
	end
	return success
end


------------------------------------------------------------------------------
return source
