-----------------------------------------------------------------------------------------
--
-- env.lua
--
-- Environment, platform, and file system utilities for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules and plugins
local lfs = require( "lfs" )
local fileDialogs = require( "plugin.tinyfiledialogs" )
local app = require( "app" )


-- The env module and public data fields
local env = {
	isWindows = false,       -- true if app is running on Windows (vs. Mac)
	isSimulator = false,     -- true if running under the Corona simulator
	docsDir = "",            -- path to the app's documents directory
	baseDirDocs = nil,       -- Corona's baseDir constant to use for docsDir
	installedEditors = {},   -- Table of editor data { name, path } for intalled editors
}

-- File local data
local chDirSeperator               -- directory seperator (/ on Mac, \ on Windows)
local byteDirSeperator             -- byte (ASCII) value of chDirSeperator



--- Module Functions ------------------------------------------------

-- Return a relative path in the file system leading from fromDir to destDir.
function env.relativePath( fromDir, destDir )
	-- TODO: This is annoying and doesn't feel very reliable

	-- Count the chDirSeperators in fromDir and create upDirs to go up to root
	local _, count = string.gsub( fromDir, chDirSeperator, "." )
	local up = ".." .. chDirSeperator
	local upDirs = string.rep( up, count )

	-- Remove the drive from destDir if any
	-- TODO: This means it won't work across drives
	if env.isWindows then
		local iCharColon = string.find( destDir, ":" )
		if iCharColon then
			destDir = string.sub( destDir, iCharColon + 1 )
		end
	end

	-- Remove root folder indicator from destDir if any
	if string.sub( destDir, 1, 1 ) == chDirSeperator then
		destDir = string.sub( destDir, 2 )
	end

	-- Attach the relative dir and return it
	return upDirs .. destDir
end

-- Split a file pathname into dir and filename parts.
-- Return (dir, filename). The dir includes the last / or \.
function env.dirAndFilenameOfPath( path )
	-- Find the last dir seperator if any
	local iChar = string.len( path )
	while iChar > 0 do
		if string.byte( path, iChar ) == byteDirSeperator then
			break
		end
		iChar = iChar - 1
	end
	if iChar <= 0 then
		return "", path  -- simple filename with no dir
	end

	-- Split the path and return the parts
	return string.sub( path, 1, iChar ), 
			(string.sub( path, iChar + 1 ) or "")
end

-- Return the file modification time for a file 
function env.fileModTimeFromPath( path )
	return lfs.attributes( path, "modification" )
end

-- Run the Open File dialog with the given title.
-- Return the string pathname chosen or nil if cancelled.
function env.pathFromOpenFileDialog( title )
	local filterPatterns, filterDescription
	if env.isWindows then
		filterPatterns = "*.java"
		filterDescription = "Java Files (*.java)"
	end
	local result = fileDialogs.openFileDialog{
		title = title,
		filter_patterns = filterPatterns,
		filter_description = filterDescription,
		allow_multiple_selects = false,
	}
	if type(result) == "string" then
		return result
	end
	return nil
end

-- Run the Save File dialog with the given title.
-- Return the string pathname chosen or nil if cancelled.
function env.pathFromSaveFileDialog( title )
	local defaultPathAndFile
	if env.isWindows then
		local homeDrive = os.getenv( "HOMEDRIVE" )
		local homePath = os.getenv( "HOMEPATH" )
		local path = homeDrive .. homePath .. [[\Documents\Code12 Programs\]]
		lfs.mkdir( path )
		defaultPathAndFile = path .. [[MyProgram.java]]
	end
	local result = fileDialogs.saveFileDialog{
		title = title,
		default_path_and_file = defaultPathAndFile,
		filter_patterns = "*.java",
		filter_description = "Java Files (*.java)",
	}
	if type(result) == "string" then
		return result
	end
	return nil
end

-- Open the given source file using app.editorPath if it is valid 
-- or the system default editor if it is not
function env.openFileInEditor( path )
	if path then
		local editorPath = app.editorPath
		if editorPath then
			-- Check that editorPath is valid
			local file = io.open( editorPath, "r" )
			if file then
				io.close( file )
			else
				editorPath = nil
				app.editorPath = editorPath
			end
		end
		if env.isWindows then
			if editorPath then
				os.execute( [[""]] .. editorPath .. [[" "]] .. path .. [[""]] )
			else
				os.execute( 'start "" "' .. path .. '"' )
			end
		else
			os.execute( 'open -a "Sublime Text.app" "' .. path .. '"' )
		end
	end
end

-- Show an error alert message dialog with an OK button and the given
-- title and message
function env.showErrAlert( title, message )
	fileDialogs.messageBox{
		title = title,
		message = message,
		icon_type = "error",
	}
end

-- Populate the env.installedEditors table with editors found installed
-- in the current environment
function env.findInstalledEditors()
	local winEditors = {
			{ name = "Sublime Text 3", path = [[C:\Program Files\Sublime Text 3\sublime_text.exe]] },
			{ name = "Sublime Text 3", path = [[C:\Program Files (x86)\Sublime Text 3\sublime_text.exe]] },
			{ name = "Notepad++", path = [[C:\Program Files\Notepad++\notepad++.exe]] },
			{ name = "Notepad++", path = [[C:\Program Files (x86)\Notepad++\notepad++.exe]] },
	}
	local macEditors = {}
	local editors
	if env.isWindows then
		editors = winEditors
	else
		editors = macEditors
	end
	
	env.installedEditors = { { name = "System Default", path = nil } }
	for i = 1, #editors do
		local editor = editors[i]
		if editor.name ~= env.installedEditors[#env.installedEditors].name then
			local f = io.open( editor.path , "r" )
			if f then
				io.close( f )
				env.installedEditors[#env.installedEditors + 1] = editor
			end
		end
	end
end


--- Main Chunk -------------------------------------------------------

-- Get the env data fields
env.isSimulator = (system.getInfo( "environment" ) == "simulator")
env.docsDir = system.pathForFile( nil, system.DocumentsDirectory )
env.baseDirDocs = system.DocumentsDirectory
if env.isSimulator then
	-- Platform will report as Android/iOS if simulating on that device,
	-- so look at a pathname to see if it starts with a / (not Windows)
	if not string.starts( env.docsDir, "/" ) then
		env.isWindows = true
	end
elseif system.getInfo( "platform" ) == "win32" then
	env.isWindows = true
end

-- Get other local data
if env.isWindows then
	chDirSeperator = "\\"
else
	chDirSeperator = "/"
end
byteDirSeperator = string.byte( chDirSeperator )


-- Return the module
return env

