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

-- The getFile module and scene
local getFile = composer.newScene()

-- UI Metrics
local margin = app.margin
local extraMargin = margin * 4
local topMargin = app.dyToolbar
local iconSize = 30
local btnLabelOffset = 40
local fontSize = 24

-- Display objects and groups
local newProgramBtn
local openProgramBtn
local recentProgramsTxt
local recentProgramsGroup


--- Internal Functions ------------------------------------------------

-- Return the file name from the given file path
local function getNameFromPath( path )
	return string.match( path, '[^\\/]+%.java' )
end

-- Update app.sourseFile and add path to app.recentSourceFilePaths
local function updateSourceFile( path )
	if path then
		app.sourceFile.path = path
		app.sourceFile.timeLoaded = 0
		app.sourceFile.timeModLast = 0
		app.addRecentSourceFilePath( path )
	end
end

-- Show dialog to choose the user source code file
local function chooseFile()
	local path = env.pathFromOpenFileDialog( "Choose Java Source Code File" )
	updateSourceFile( path )
	native.setActivityIndicator( false )
end

-- Event handler for the New Program button
local function onNewProgram()
	-- TODO
end

-- Event handler for the Open Program button
local function onOpenProgram()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, chooseFile )
end

local function updateRecentProgramsGroup()
	-- TODO
end

local function setOpenInEditorCheckbox()
	-- TODO
end


--- Scene Methods ------------------------------------------------

-- Create the getFile scene
function getFile:create()
	local sceneGroup = self.view

	-- Background
	g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 
	
	-- New Program Button
	newProgramBtn = widget.newButton{
		x = app.width / 2,
		y = topMargin + extraMargin,
		onRelease = onNewProgram,
		label = "New Program",
		labelAlign = "left",
		labelXOffset = btnLabelOffset,
		font = native.systemFontBold,
		fontSize = fontSize,
		width = iconSize,
		height = iconSize,
		defaultFile = "images/newProgram.png",
	}
	sceneGroup:insert( newProgramBtn )
	newProgramBtn.anchorY = 0
	local xBtns = newProgramBtn.x - newProgramBtn.width / 2

	-- Open Program Button
	openProgramBtn = widget.newButton{
		x = xBtns,
		y = newProgramBtn.y + newProgramBtn.height + margin,
		onRelease = onOpenProgram,
		label = "Open Program",
		labelAlign = "left",
		labelXOffset = btnLabelOffset,
		font = native.systemFontBold,
		fontSize = fontSize,
		width = iconSize,
		height = iconSize,
		defaultFile = "images/openProgram.png",
	}
	sceneGroup:insert( openProgramBtn )
	openProgramBtn.anchorX = 0
	openProgramBtn.anchorY = 0

	-- Recent Programs label
	recentProgramsTxt = display.newText{
		parent = sceneGroup,
		text = "Recent Programs",
		x = xBtns,
		y = openProgramBtn.y + openProgramBtn.height + extraMargin,
		font = native.systemFontBold,
		fontSize = fontSize,
	}
	g.uiItem( recentProgramsTxt )

	-- Recent Programs list
	recentProgramsGroup = display.newGroup()
	recentProgramsGroup.x = xBtns
	recentProgramsGroup.y = recentProgramsTxt.y + recentProgramsTxt.height + margin
	recentProgramsGroup.anchorX = 0
	recentProgramsGroup.anchorY = 0
	updateRecentProgramsGroup()
	sceneGroup:insert( recentProgramsGroup )
	local yBtn = 0
	for i = 1, #app.recentSourceFilePaths do
		local path = app.recentSourceFilePaths[i]
		-- Make icon and filename text
		local recentProgramBtn = widget.newButton{
			x = 0,
			y = yBtn,
			label = getNameFromPath( path ),
			labelAlign = "left",
			labelXOffset = btnLabelOffset,
			font = native.systemFontBold,
			fontSize = fontSize,
			width = iconSize,
			height = iconSize,
			defaultFile = "images/recentProgram.png",
			onRelease =
				function ()
					if app.openFilesInEditor then
						env.openFileInEditor( path )
					end
					updateSourceFile( path )
					app.saveSettings()
					app.processUserFile()
				end

		}
		recentProgramBtn.anchorX = 0
		recentProgramBtn.anchorY = 0
		recentProgramBtn.path = 
		recentProgramsGroup:insert( recentProgramBtn )
		-- Make file path text
		local pathTxt = display.newText{
			parent = recentProgramsGroup,
			text = path,
			x = iconSize + btnLabelOffset,
			y = recentProgramBtn.y + recentProgramBtn.height,
			width = app.width - margin - xBtns - iconSize - btnLabelOffset,
			font = native.systemFont,
			fontSize = fontSize * 0.5,
		}
		g.uiItem( pathTxt )
		yBtn = yBtn + recentProgramBtn.height + pathTxt.height + margin
	end
end

-- Prepare to show the getFile scene
function getFile:show( event )
	if event.phase == "will" then
		updateRecentProgramsGroup()
		setOpenInEditorCheckbox()
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
getFile:addEventListener( "create", getFile )
getFile:addEventListener( "show", getFile )
return getFile
