-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local fileDialogs = require( "plugin.tinyfiledialogs" )

local resultGroup
local yImageDir = 160


--- Utility functions from Code12 app ----------------------------

-- Return a relative path in the file system leading from fromDir to destDir.
local function relativePath( fromDir, destDir )
	-- TODO: This is Mac-only for now and doesn't feel very reliable
	local str, count = string.gsub( fromDir, "/", "." )
	local upDirs = string.rep( "../", count )
	print(count, upDirs)
	return upDirs .. string.sub( destDir, 2 )
end

-- Split a file pathname into dir, filename (includes ext), and ext.
-- Return (dir, filename, ext).
local function dirFilenameAndExtFromPath( path )
	-- TODO: Got this from internet, does it really work?
	return string.match( path, "(.-)([^\\/]-%.?([^%.\\/]*))$" )
end


--- Test program ----------------------------------------------------

-- Display label at y and then dir below it
local function showDir( y, label, dir )
	local group = resultGroup or display.newGroup()
	local labelText = display.newText( group, label, 10, y, native.systemFontBold, 8 )
	labelText.anchorX = 0
	labelText.anchorY = 0

	if dir then
		local dirText = display.newText{
			parent = group,
			text = dir,
			x = 10, 
			y = y + 10, 
			width = display.contentWidth - 20,
			align = "left",
			font = native.systemFont, 
			fontSize = 7,
		}
		dirText.anchorX = 0	
		dirText.anchorY = 0
	end
	return group
end

-- Run the open file dialog and display the result
local function useOpenDialog()
	local path = fileDialogs.openFileDialog{
		title = "Choose Image",
		allow_multiple_selects = false,
	}
	if type(path) == "string" then 
		resultGroup = showDir( yImageDir, "Chosen file", path )

		-- Build the relative path and display the results
		local dir, filename, ext = dirFilenameAndExtFromPath( path )
		showDir( yImageDir + 30, "File dir", dir )
		local relDir = relativePath( system.pathForFile(nil, system.DocumentsDirectory), dir )
		local relPath = relDir .. filename
		showDir( yImageDir + 60, "Relative Path from Documents dir", relPath )

		-- Try to open the image and display it
		local w = display.contentWidth
		local h = display.contentHeight
		local img = display.newImage( resultGroup, relPath, w / 2, 0 )
		if img then
			local height = 100
			img.width = img.width * height / img.height
			img.height = height
			img.y = height / 2 + 10
			showDir( yImageDir + 90, "Success" )
			img:toBack()
			resultGroup:toBack()
		else
			showDir( yImageDir + 90, "Failure" )
		end
	end
end

-- Tap handler for the screen. Remove past result if any then run Open dialog.
local function onTap()
	if resultGroup then
		resultGroup:removeSelf()
		resultGroup = nil
	end
	timer.performWithDelay( 100, useOpenDialog )
end

-- Display Corona's available base directories
showDir( 10, "Documents dir", system.pathForFile(nil, system.DocumentsDirectory) )
showDir( 40, "Resource dir", system.pathForFile(nil, system.ResourceDirectory) )
showDir( 70, "App Support dir", system.pathForFile(nil, system.ApplicationSupportDirectory) )
showDir( 100, "Temp dir", system.pathForFile(nil, system.TemporaryDirectory) )
showDir( 130, "Cache dir", system.pathForFile(nil, system.CachesDirectory) )

-- Prompt if user wants to choose an image
resultGroup = showDir( yImageDir, "(Tap to Choose Image File)" )

-- Wait for tap(s)
Runtime:addEventListener( "tap", onTap )

