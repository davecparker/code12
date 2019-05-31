-----------------------------------------------------------------------------------------
--
-- env.lua
--
-- Environment, platform, and file system utilities for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12
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
local consoleFontYOffsets = {      -- for fixing off center text on Mac in errView and varWatch
	[12] = 0,
	[14] = 0,
	[18] = 0,
	[20] = 0,
	[24] = 0,
}


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
-- Return (dir, filename). The dir includes the last dirSeperator, 
-- which defaults to / or \ depending on the platform if not included.
function env.dirAndFilenameOfPath( path, dirSeperator )
	-- Find the last dir seperator if any
	local byteSep = (dirSeperator and string.byte( dirSeperator )) or byteDirSeperator
	local iChar = string.len( path )
	while iChar > 0 do
		if string.byte( path, iChar ) == byteSep then
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

-- Return the basename and extension of the given filename
function env.basenameAndExtFromFilename( filename )
	-- Find the last "." if any
	local iChar = string.len( filename )
	while iChar > 0 do
		if string.byte( filename, iChar ) == string.byte( "." ) then
			break
		end
		iChar = iChar - 1
	end
	if iChar <= 0 then
		return filename -- simple filename with no extension
	end

	-- Split the filename and return the parts
	return string.sub( filename, 1, iChar - 1 ), string.sub( filename, iChar + 1 )
end

-- Return the file modification time for a file 
function env.fileModTimeFromPath( path )
	return lfs.attributes( path, "modification" )
end

-- Return the path to the user's Documents folder with a folder seperator at the end
function env.documentsPath()
	if env.isWindows then
		local userProfile = os.getenv( "USERPROFILE" )
		return userProfile .. [[\Documents\]]
	else
		local home = os.getenv( "HOME" )
		return home .. [[/Documents/]]
	end
end

-- Run the Open File dialog with the given title, and optional 
-- filterPatterns, filterDescription and defaultPath.
-- Return the string pathname chosen or nil if cancelled.
function env.pathFromOpenFileDialog( title, filterPatterns, filterDescription, defaultPath )
	if not env.isWindows then
		filterPatterns = nil
		filterDescription = nil
	end
	local result = fileDialogs.openFileDialog{
		title = title,
		default_path_and_file = defaultPath,
		filter_patterns = filterPatterns,
		filter_description = filterDescription,
		allow_multiple_selects = false,
	}
	if type(result) == "string" then
		-- fileDialogs.openFileDialog leaves a trailing / in some cases, so remove it
		if string.sub( result, -1, -1 ) == chDirSeperator then
			result = string.sub( result, 1, -2 )
		end
		return result
	end
	return nil
end

-- Run the Save File dialog with the given title.
-- Return the string pathname chosen or nil if cancelled.
function env.pathFromSaveFileDialog( title, defaultPathAndFile )
	local result = fileDialogs.saveFileDialog{
		title = title,
		default_path_and_file = defaultPathAndFile,
	}
	if type(result) == "string" then
		return result
	end
	return nil
end

-- Return true if the given path can be opened for reading, false otherwise
function env.canRead( path )
	local file = io.open( path, "r" )
	if file then
		io.close( file )
		return true
	end
	return false
end

-- Open the given source file using app.editorPath if it is valid 
-- or the system default editor if it is not
function env.openFileInEditor( path )
	if path then
		-- Check that editorPath is valid
		local editorPath = app.editorPath
		if editorPath and not env.canRead( editorPath ) then
			editorPath = nil
			app.editorPath = editorPath
		end

		-- Open using editorPath or system default
		if env.isWindows then
			if editorPath then
				os.execute( 'start "" "' .. editorPath .. '" "' .. path .. '"' )
			else
				os.execute( 'start "" "' .. path .. '"' )
			end
		else
			if editorPath then
				local _, filename = env.dirAndFilenameOfPath( editorPath )
				os.execute( 'open -a "' .. filename .. '" "' .. path .. '"' )
			else
				os.execute( 'open "' .. path .. '"' )
			end
		end
	end
end

-- Show an info alert message dialog with an OK button and the given
-- title and message
function env.showInfoAlert( title, message )
	fileDialogs.messageBox{
		title = title,
		message = message,
		icon_type = "info",
	}
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

-- Show an error alert message dialog with Yes and No buttons and the given
-- title and message
-- Return wether the Yes button was clicked, or nil if closed
function env.showWarningAlert( title, message )
	return fileDialogs.messageBox{
		title = title,
		message = message,
		icon_type = "warning",
		dialog_type = "yesno",
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
	local macEditors = {
			{ name = "Sublime Text", path = [[/Applications/Sublime Text.app]] },		
			{ name = "Atom", path = [[/Applications/Atom.app]] },		
	}
	local editors
	if env.isWindows then
		editors = winEditors
	else
		editors = macEditors
	end
	-- Add user's saved custom editors
	for i = 1, #app.customEditors do
		editors[#editors + 1] = app.customEditors[i]
	end
	-- Find installed editors (skipping over duplicate names if the first path is good)
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

-- Return the console font y-offset for the given fontSize
function env.consoleFontYOffset( fontSize )
	if env.isWindows then
		return 1
	end
	-- return consoleFontYOffsets[fontSize]
	return -math.round( fontSize * 0.15 )
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

