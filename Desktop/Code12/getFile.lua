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
local buttons = require( "buttons" )


-- The getFile module and scene
local getFile = composer.newScene()

-- UI Metrics
local margin = app.margin       -- Distance between most UI elements
local extraMargin = margin * 4  -- Extra distance between UI sections
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
-- Return false and an error message string otherwise
local function isValidClassNameAndErrMessage( className )
	local chFirst = string.byte( className, 1 )
	if not chFirst then
		return false, "No class name was entered."
	elseif chFirst < 65 or chFirst > 90 then
		return false, "By convention, your program class name should start with an upper-case letter."
	end
	local i, j = string.find( className, "[%a%d_]+" )
	if i ~= 1 or j ~= string.len( className ) then
		return false, "Java class names can only contain letters, digits, and underscores."
	end
	return true
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
		local skeleton = "class " .. classNameOfPath( path ) .. "\n"
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
	-- Get className
	local className = env.strFromInputBoxDialog( "New Program", "Enter a class name for your new program." )
	if className then
		-- Check for valid Java class name
		local isValidClassName, errMessage = isValidClassNameAndErrMessage( className )
		if isValidClassName then
			-- Open Save As dialog for user to save file
			local defaultPathAndFile
			if env.isWindows then
				local defaultPath = ""
				if firstSave then
					local userProfile = os.getenv( "USERPROFILE" )
					defaultPath = userProfile .. [[\Documents\Code12 Programs\]]
					lfs.mkdir( defaultPath )
				end
				defaultPathAndFile = defaultPath .. className .. [[.java]]
			end
			local path = env.pathFromSaveFileDialog( "Save New Program As", defaultPathAndFile )
			if path then
				local _, fileName = env.dirAndFilenameOfPath( path )
				-- Append ".java" to file name if missing
				if string.sub( fileName, -5, -1 ) ~= ".java" then
					fileName = fileName .. ".java"
				end
				-- Check that fileName matches className.java
				local saveFile = true
				if fileName ~= className .. [[.java]] then
					local message = "Java program file names should match the class name.\n" ..
							"Do you wish the save your as ".. fileName .." instead of " .. className .. ".java?"
					saveFile = env.showWarningAlert( "Unexpected File Name", message, "yesno" )
				end
				print( "saveFile", saveFile )
				if saveFile then
					-- Save the new program
					writeNewProgramSkeleton( path )
					updateSourceFile( path )
					if app.openFilesInEditor then
						env.openFileInEditor( path )
					end
					firstSave = false
				end
			end
		else
			env.showErrAlert( "Invalid File Name", errMessage )
			newProgram()
		end
	end
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
	updateSourceFile( path )
	app.saveSettings()
	if app.openFilesInEditor then
		env.openFileInEditor( path )
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
		labelsFontSize = largeFontSize,
		style = "checkbox",
		switchSize = iconSize,
		x = leftMargin - iconSize - margin ,
		y = recentProgramsGroup.y + recentProgramsGroup.height + extraMargin,
		onPress = onAlsoOpenInEditor,
	}
	openInEditorPicker.switches[1]:setState{ isOn = app.openFilesInEditor }
end

--- Scene Methods ------------------------------------------------

-- Create the getFile scene
function getFile:create()
	local sceneGroup = self.view

	-- Background
	g.uiItem( display.newRect( sceneGroup, 0, 0, 10000, 10000 ), 0.9 ) 
	
	-- UI Elements
	makeUIGroup( sceneGroup )

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
	makeUIGroup( self.view )
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
getFile:addEventListener( "create", getFile )
getFile:addEventListener( "show", getFile )
return getFile
