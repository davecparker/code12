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
local fontSize = app.fontSizeUI * 2

-- Display objects and groups
local newProgramBtn
local openProgramBtn
local recentProgramsTxt


--- Internal Functions ------------------------------------------------

local function onNewProgram()
	print("new program")
end

local function onOpenProgram()
	print("open program")
end

local function updateRecentPrograms()

end

local function setOpenInEditorCheckbox()

end


--- Scene Methods ------------------------------------------------

-- Create the getFile scene
function getFile:create()
	local sceneGroup = self.view

	-- Background
	g.uiWhite( display.newRect( sceneGroup, 0, 0, 10000, 10000 ) ) 
	
	-- New Program Group
	-- newProgramGroup = display.newGroup( )
	-- sceneGroup:insert( newProgramGroup )
	-- newProgramGroup.x = app.width / 2
	-- newProgramGroup.y = topMargin
	-- newProgramGroup.anchorY = 0

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

	-- Open Program Button
	openProgramBtn = widget.newButton{
		x = newProgramBtn.x - newProgramBtn.width / 2,
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
		x = openProgramBtn.x,
		y = openProgramBtn.y + openProgramBtn.height + extraMargin,
		font = native.systemFontBold,
		fontSize = fontSize,
	}
	g.uiItem( recentProgramsTxt )
end

-- Prepare to show the getFile scene
function getFile:show( event )
	if event.phase == "will" then
		updateRecentPrograms()
		setOpenInEditorCheckbox()
	end
end


------------------------------------------------------------------------------

-- Complete and return the composer scene
getFile:addEventListener( "create", getFile )
getFile:addEventListener( "show", getFile )
return getFile
