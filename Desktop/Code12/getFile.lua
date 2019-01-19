-----------------------------------------------------------------------------------------
--
-- getFile.lua
--
-- The view for the user to start a new program or open an existing one for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )
local buttons = require( "buttons" )


-- The getFile module and scene
local getFile = composer.newScene()

-- UI Metrics
local margin = app.margin       -- Distance between most UI elements
local extraMargin = margin * 2  -- Extra distance between UI sections
local largeFontSize = 24        -- Font size for main labels (New Program, Open Program, etc.)
local medFontSize = 14          -- Font size for recent program names
local smallFontSize = 12        -- Font size for recent program paths

-- File local state variables
local firstSave = true        -- Set to false after the first time a user successfully uses the new program button

-- Display objects and groups
local UIGroup


--- Internal Functions ------------------------------------------------

-- Return the file name from the given file path
-- Assumes the path ends in ".java"
local function classNameOfPath( path )
	local _, filename = env.dirAndFilenameOfPath( path )
	return string.gsub( filename, ".java$", "" )
end

-- Return true if given className is a valid java class name
-- Return false otherwise
local function isValidClassName( className )
	local chFirst = string.byte( className, 1 )
	if not chFirst then
		-- no className
		return false
	elseif chFirst < 65 or chFirst > 90 then
		-- className doesn't start with a capital letter
		return false
	end
	local i, j = string.find( className, "[%a%d_]+" )
	if i ~= 1 or j ~= string.len( className ) then
		-- className contains characters other than letters, digits, and underscores
		return false
	end
	return true
end

-- Show dialog to choose the user source code file
local function openProgram()
	local path = env.pathFromOpenFileDialog( "Choose Java Source Code File", "*.java", "Java Files (*.java)" )
	if not path then
		native.setActivityIndicator( false )
	elseif string.sub( path, -5, -1 ) ~= ".java" then
		env.showErrAlert( "Wrong File Extension", "Please choose a .java file" )
		openProgram()
	else
		app.updateSourceFile( path )
		if app.openFilesInEditor then
			env.openFileInEditor( path )
		end
		native.setActivityIndicator( false )
	end
end

-- Event handler for the Open Program button
local function onOpenProgram()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, openProgram )
end

-- Write a new program skeleton to the given path
local function writeNewProgramSkeleton( path )
	if path then
		local skeleton = "class " .. classNameOfPath( path ) .. "\n"
		if app.syntaxLevel <= 4 then
			skeleton = skeleton ..
[[
{
	public void start()
	{
		// Your code goes here
	}
}
]]
		else
			skeleton = skeleton ..
[[
{
	// Declare class-level variables here

	public void start()
	{
		// Your program starts here
	}

	public void update()
	{
		// Code here runs before each animation frame
	}
}
]]
		end
		local file = io.open( path, "w" )
		file:write( skeleton )
		file:close()
	end
end

-- Show dialog to create a new user source code file
local function newProgram()
	-- Start with a default path and program name
	local path = "MyProgram.java"
	if firstSave then
		-- Try to default to Documents folder on first use
		path = env.documentsPath() .. path
	end
	-- Open Save As dialog for user to choose name and folder
	while true do -- breaks internally when path is valid
		print( "Proposed: ", path )
		path = env.pathFromSaveFileDialog( "Save New Program As", path )
		print( "Got: ", path )
		if not path then
			-- User clicked "Cancel" in save program dialog
			native.setActivityIndicator( false )
			return nil
		end
		local _, fileName = env.dirAndFilenameOfPath( path )
		local className, ext = env.basenameAndExtFromFilename( fileName )
		-- Default file extension to java if not included
		if not ext then
			ext = "java"
			path = path .. ".java"
		end
		-- Check for valid filename
		print( "Checking: ", path )
		if not isValidClassName( className ) or ext ~= "java" then
			env.showErrAlert( "Invalid Filename", 
					"A Java filename should start with a capital letter, "
					.. "contain only letters and digits, and end with .java" )
		elseif env.canRead( path ) then
			env.showErrAlert( "Filename already exists",
					"Code12 does not allow overwriting an existing program file. Choose another name." )
		else
			break  -- got a valid filename
		end
	end	
	-- Save the new program
	writeNewProgramSkeleton( path )
	app.updateSourceFile( path )
	if app.openFilesInEditor then
		env.openFileInEditor( path )
	end
	firstSave = false
	native.setActivityIndicator( false )
end

-- Event handler for the New Program button
local function onNewProgram()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, newProgram )
end

-- Event handler for the list of recent programs
local function onRecentProgram( event )
	local path = event.target.path
	if env.canRead( path ) then
		app.updateSourceFile( path )
		app.saveSettings()
		if app.openFilesInEditor then
			env.openFileInEditor( path )
		end
	else
		env.showErrAlert( "File Not Readable", "There was an error reading file " .. path )
		composer.gotoScene( "getFile" )
	end
end

-- Event handler for the Also Open in Text Editor checkbox
local function onAlsoOpenInEditor( event )
	app.openFilesInEditor = event.target.isOn
	app.saveSettings()
end

-- Make the UI elements
local function makeUIGroup( sceneGroup )
	if UIGroup then
		UIGroup:removeSelf()
		UIGroup = nil
	end
	UIGroup = display.newGroup()
	sceneGroup:insert( UIGroup )

	-- New Program Text Button
	local newProgramTxtBtn = widget.newButton{
		x = 0,
		y = app.dyToolbar + extraMargin * 2,
		onRelease = onNewProgram,
		textOnly = true,
		label = "New Program",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = largeFontSize,
	}
	newProgramTxtBtn.x = math.round( app.width / 2 - newProgramTxtBtn.width / 2 )
	newProgramTxtBtn.anchorX = 0
	newProgramTxtBtn.anchorY = 0
	local iconSize = newProgramTxtBtn.height
	UIGroup:insert( newProgramTxtBtn )
	
	-- New Program Icon Button
	local newProgramIcnBtn = widget.newButton{
		x = newProgramTxtBtn.x - margin,
		y = newProgramTxtBtn.y,
		onRelease = onNewProgram,
		width = iconSize,
		height = iconSize,
		defaultFile = "images/newProgram.png",
	}
	UIGroup:insert( newProgramIcnBtn )
	newProgramIcnBtn.anchorX = 1
	newProgramIcnBtn.anchorY = 0
	local leftMargin = newProgramIcnBtn.x - iconSize

	-- New Program Icon Button
	local openProgramIcnBtn = widget.newButton{
		x = leftMargin,
		y = newProgramTxtBtn.y + newProgramTxtBtn.height + extraMargin,
		onRelease = onOpenProgram,
		width = iconSize,
		height = iconSize,
		defaultFile = "images/openProgram.png",
	}
	UIGroup:insert( openProgramIcnBtn )
	openProgramIcnBtn.anchorX = 0
	openProgramIcnBtn.anchorY = 0

	-- Open Program Text Button
	local openProgramTxtBtn = widget.newButton{
		x = openProgramIcnBtn.x + openProgramIcnBtn.width + margin,
		y = openProgramIcnBtn.y,
		onRelease = onOpenProgram,
		textOnly = true,
		label = "Open Program",
		font = native.systemFontBold,
		fontSize = largeFontSize,
	}
	openProgramTxtBtn.anchorY = 0
	openProgramTxtBtn.anchorX = 0
	UIGroup:insert( openProgramTxtBtn )

	-- Recent Programs Text
	local recentProgramsTxt = display.newText{
		parent = UIGroup,
		text = "Recent Programs",
		x = leftMargin,
		y = openProgramTxtBtn.y + openProgramTxtBtn.height + extraMargin,
		font = native.systemFontBold,
		fontSize = largeFontSize,
	}
	recentProgramsTxt.anchorX = 0
	recentProgramsTxt.anchorY = 0
	recentProgramsTxt:setFillColor( 0 )

	-- Recent Programs Group
	local recentProgramsGroup = display.newGroup()
	recentProgramsGroup.x = leftMargin
	recentProgramsGroup.y = recentProgramsTxt.y + recentProgramsTxt.height + margin
	recentProgramsGroup.anchorX = 0
	recentProgramsGroup.anchorY = 0
	UIGroup:insert( recentProgramsGroup )
	local yBtn = 0
	local numRecentSourceFilePaths = #app.recentSourceFilePaths
	-- Check app.addRecentSourceFilePaths for missing files and update
	if numRecentSourceFilePaths > 0 then
		local pathRemoved
		for i = #app.recentSourceFilePaths, 1, -1 do
			if not env.canRead( app.recentSourceFilePaths[i] ) then
				table.remove( app.recentSourceFilePaths, i )
				pathRemoved = true
			end
		end
		if pathRemoved then
			app.saveSettings()
		end
	end
	-- Make recent programs list
	for i = 1, #app.recentSourceFilePaths do
		local path = app.recentSourceFilePaths[i]
		-- Make icon button
		local icnBtn = widget.newButton{
			x = 0,
			y = yBtn,
			width = iconSize,
			height = iconSize,
			defaultFile = "images/recentProgram.png",
			onRelease = onRecentProgram,
		}
		icnBtn.anchorX = 0
		icnBtn.anchorY = 0
		icnBtn.path = path
		recentProgramsGroup:insert( icnBtn )
		-- Make file title text button
		local fileNameBtn = widget.newButton{
			x = iconSize + margin,
			y = icnBtn.y,
			label = classNameOfPath( path ),
			labelAlign = "left",
			font = native.systemFontBold,
			fontSize = medFontSize,
			textOnly = true,
			onRelease = onRecentProgram,
		}
		fileNameBtn.anchorX = 0
		fileNameBtn.anchorY = 0
		fileNameBtn.path = path
		recentProgramsGroup:insert( fileNameBtn )
		-- Make file path text
		local filePathTxt = display.newText{
			parent = recentProgramsGroup,
			text = path,
			x = fileNameBtn.x,
			y = fileNameBtn.y + fileNameBtn.height,
			width = app.width - leftMargin - iconSize - margin * 2,
			font = native.systemFont,
			fontSize = smallFontSize,
		}
		g.uiItem( filePathTxt )
		filePathTxt.path = path
		local yOffset = math.max( fileNameBtn.height + filePathTxt.height, iconSize )
		yBtn = yBtn + yOffset + margin
	end
	if #app.recentSourceFilePaths == 0 then
		local noRecentProgramsTxt = display.newText{
			parent = recentProgramsGroup,
			text = "No recent programs\n",
			font = native.systemFont,
			fontSize = medFontSize,
		}
		g.uiItem( noRecentProgramsTxt )
	end

	-- Also Open in Text Editor Checkbox and Label
	local openInEditorPicker = buttons.newSettingPicker{
		parent = UIGroup,
		labels = { "Also Open In Text Editor" },
		labelsFont = native.systemFontBold,
		labelsFontSize = medFontSize,
		style = "checkbox",
		switchSize = 16,
		x = leftMargin,
		y = recentProgramsGroup.y + recentProgramsGroup.height + extraMargin + margin,
		onPress = onAlsoOpenInEditor,
	}
	openInEditorPicker.switches[1]:setState{ isOn = app.openFilesInEditor }
end

--- Scene Methods ------------------------------------------------

-- Create the getFile scene
function getFile:create()
	local sceneGroup = self.view

	-- Background
	g.uiItem( display.newRect( sceneGroup, 0, 0, 10000, 10000 ), 1 ) 
	
	-- Install resize handler
	Runtime:addEventListener( "resize", self )
end

-- Prepare to show the getFile scene
function getFile:show( event )
	if event.phase == "will" then
		makeUIGroup( self.view )
	end
end

-- Window resize handler
function getFile:resize()
	if composer.getSceneName( "current" ) == "getFile" then
		makeUIGroup( self.view )
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
getFile:addEventListener( "create", getFile )
getFile:addEventListener( "show", getFile )
return getFile
