-----------------------------------------------------------------------------------------
--
-- getFile.lua
--
-- The view for the user to start a new program or open an existing one for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )
local source = require( "source" )

-- The getFile module and scene
local getFile = composer.newScene()

-- UI Metrics
local margin = app.margin
local extraMargin = margin * 4
local largeFontSize = 24
local medFontSize = 14
local smallFontSize = 12

-- Display objects and groups
local UIGroup


--- Internal Functions ------------------------------------------------

-- Return the file name from the given file path
local function getNameFromPath( path )
	return string.match( path, '[^\\/]+%.java' )
end

-- Ruturn true if given path is to a valid new java program,
-- false otherwise
local function isValidNewProgramPath( path )
	return true -- TODO
end

-- Update app.sourseFile and add path to app.recentSourceFilePaths
-- and save user settings
local function updateSourceFile( path )
	if path then
		source.path = path
		source.timeLoaded = 0
		source.timeModLast = 0
		source.updated = false
		source.numLines = 0
		app.addRecentSourceFilePath( path )
		app.saveSettings()
	end
end

-- Show dialog to choose the user source code file
local function openProgram()
	local path = env.pathFromOpenFileDialog( "Choose Java Source Code File" )
	if not path then
		native.setActivityIndicator( false )
	elseif string.sub( path, -5, -1 ) ~= ".java" then
		env.showErrAlert( "Wrong File Extension", "Please choose a .java file" )
		openProgram()
	else
		updateSourceFile( path )
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
		local _, filename = env.dirAndFilenameOfPath( path )
		local classname = string.gsub( filename, ".java", "" )
		local skeleton = "class " .. classname .. "\n"
		if app.syntaxLevel <= 4 then
			skeleton = skeleton ..
[[
{
	public void start()
	{
		// Start your code here
	}
}
]]
		else
			skeleton = skeleton ..
[[
{
	// Declare your class-level variables here

	public void start()
	{
		// Your code here runs once at the start of running the program
	}

	public void update()
	{
		// Your code here runs once per new frame after start()
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
	local path = env.pathFromSaveFileDialog( "Save New Program As" )
	if not path then
		native.setActivityIndicator( false )
	elseif isValidNewProgramPath( path ) then
		writeNewProgramSkeleton( path )
		updateSourceFile( path )
		if app.openFilesInEditor then
			env.openFileInEditor( path )
		end
		native.setActivityIndicator( false )
	else
		os.remove( path )
		local errMessage = "Invalid filename" -- TODO: different messages depending on why the filename is invalid
		env.showErrAlert( "Error", errMessage )
		newProgram()
	end
end

-- Event handler for the New Program button
local function onNewProgram()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, newProgram )
end

-- Event handler for the list of recent programs
local function onRecentProgram( event )
	local path = event.target.path
	updateSourceFile( path )
	app.saveSettings()
	if app.openFilesInEditor then
		env.openFileInEditor( path )
	end
end

-- Event handler for the Also Open in Text Editor checkbox
local function onAlsoOpenInEditor( event )
	app.openFilesInEditor = event.target.isOn
end

local function makeUIGroup()
	if UIGroup then
		UIGroup:removeSelf()
		UIGroup = nil
	end
	UIGroup = display.newGroup()

	-- New Program Text Button
	local newProgramTxtBtn = widget.newButton{
		x = app.width / 2,
		y = app.dyToolbar + extraMargin,
		onRelease = onNewProgram,
		textOnly = true,
		label = "New Program",
		font = native.systemFontBold,
		fontSize = largeFontSize,
	}
	UIGroup:insert( newProgramTxtBtn )
	newProgramTxtBtn.anchorY = 0
	local iconSize = newProgramTxtBtn.height
	
	-- New Program Icon Button
	local newProgramIcnBtn = widget.newButton{
		x = newProgramTxtBtn.x - newProgramTxtBtn.width / 2 - margin,
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
		y = newProgramTxtBtn.y + newProgramTxtBtn.height + margin,
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
			label = getNameFromPath( path ),
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

	-- Also Open in Text Editor text
	local openInEditorTxt = display.newText{
		parent = UIGroup,
		text = "Also Open in Text Editor",
		x = leftMargin,
		y = recentProgramsGroup.y + recentProgramsGroup.height + extraMargin,
		width = app.width - leftMargin - margin,
		font = native.systemFontBold,
		fontSize = largeFontSize,
	}
	openInEditorTxt.anchorX = 0
	openInEditorTxt.anchorY = 0
	openInEditorTxt:setFillColor( 0 )

	-- Also Open in Text Editor checkbox
	local openInEditorCheckbox = widget.newSwitch{
		style = "checkbox",
		x = openInEditorTxt. x - margin,
		y = openInEditorTxt.y,
		width = iconSize,
		height = iconSize,
		onPress = onAlsoOpenInEditor,
		sheet = app.checkboxSheet,
		frameOn = 1,
		frameOff = 2,
	}
	openInEditorCheckbox.anchorX = 1
	openInEditorCheckbox.anchorY = 0
	openInEditorCheckbox:setState{ isOn = app.openFilesInEditor }
	UIGroup:insert( openInEditorCheckbox )
end

--- Scene Methods ------------------------------------------------

-- Create the getFile scene
function getFile:create()
	local sceneGroup = self.view

	-- Background
	g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 
	
	-- UI Elements
	makeUIGroup()
	sceneGroup:insert( UIGroup )

	-- Install resize handler
	Runtime:addEventListener( "resize", self )
end

-- Prepare to hide the getFile scene
function getFile:hide( event )
	if event.phase == "did" then
		composer.removeScene( "getFile" )
	end
end

-- Window resize handler
function getFile:resize()
	makeUIGroup()
end

------------------------------------------------------------------------------

-- Complete and return the composer scene
getFile:addEventListener( "create", getFile )
getFile:addEventListener( "hide", getFile )
return getFile
