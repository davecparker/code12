-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Test of directory handling for images
-----------------------------------------------------------------------------------------

-- Use Code12's env module to test it
package.path = package.path .. ';../?.lua'
local env = require("Code12.env")


-- File local data
local resultGroup
local yImageDir = 160


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
	local path = env.pathFromOpenFileDialog( "Choose Image" )
	if path then 
		resultGroup = showDir( yImageDir, "Chosen file", path )

		-- Build the relative path and display the results
		local dir, filename = env.dirAndFilenameOfPath( path )
		print( "dir = \"" .. dir .. "\"" )
		print( "filename = \"" .. filename .. "\"" )

		showDir( yImageDir + 30, "File dir", dir )
		local relDir = env.relativePath( env.docsDir, dir )
		local relPath = relDir .. filename
		showDir( yImageDir + 60, "Relative Path from env.docsDir", relPath )

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


-- Init the display
display.setStatusBar( display.HiddenStatusBar )

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

