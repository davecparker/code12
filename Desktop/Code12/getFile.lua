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
	-- Ask the user for a program name
	local programName = nil
	local className, ext
	while true do -- breaks internally when valid program name is entered
		programName = env.strFromInputBoxDialog( "New Program", 
				"Enter a name for your new program, then press OK to choose where to save it",
				programName )
		if not programName then
			-- User clicked "Cancel" in new program dialog
			native.setActivityIndicator( false )
			return nil
		end
		-- Check for valid Java class name, and ext must be .java if included
		className, ext = env.basenameAndExtFromFilename( programName )
		if not isValidClassName( className ) then
			env.showErrAlert( "Invalid Program Name", 
					"Program names must start with a capital letter, then contain only letters and digits (no spaces)" )
		elseif ext and ext ~= "java" then
			env.showErrAlert( "Invalid Program Name", "Java programs must have an extension of .java" )
		else
			break  -- valid name entered
		end
	end
	local defaultPath = ""
	if firstSave then
		-- Try to default to Documents folder on first use
		defaultPath = env.documentsPath()
	end
	-- Append className and ".java" to defaultPath
	defaultPath = defaultPath .. className .. [[.java]]
	-- Open Save As dialog for user to save file
	local path
	while true do -- breaks internally when path is valid
		path = env.pathFromSaveFileDialog( "Save New Program As", defaultPath )
		if not path then
			-- User clicked "Cancel" in save program dialog
			native.setActivityIndicator( false )
			return nil
		end
		local _, fileName = env.dirAndFilenameOfPath( path )
		className, ext = env.basenameAndExtFromFilename( fileName )
		if not isValidClassName( className ) then
			env.showErrAlert( "Invalid Filename", 
					"The filename must be a valid program name. It must start with a " .. 
							"capital letter and contain only letters and digits." )
		elseif not ext then
			-- path is valid except missing extension
			path = path .. ".java"
			break
		elseif ext ~= "java" then
			env.showErrAlert( "Invalid Filename", "The filename extension must be .java" )
		else
			-- path is valid and includes extension
			break
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
		x = app.width / 2,
		y = app.dyToolbar + extraMargin * 2,
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
