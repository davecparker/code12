-----------------------------------------------------------------------------------------
--
-- toolbar.lua
--
-- The toolbar for the Code 12 Desktop app
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


-- The toolbar module
local toolbar = {}


-- File local state
local toolbarGroup        -- display group for toolbar
local bgRect              -- background rect
local chooseFileBtn       -- Choose File button
local optionsBtn          -- Options button
local restartBtn          -- Restart button


--- Internal Functions ------------------------------------------------

-- Show dialog to choose the user source code file
local function chooseFile()
	local path = env.pathFromOpenFileDialog( "Choose Java Source Code File" )
	if path then
		app.sourceFile.path = path
		app.sourceFile.timeLoaded = 0
		app.sourceFile.timeModLast = 0
	end
	native.setActivityIndicator( false )
end

-- Event handler for the Choose File button
local function onChooseFile()
	native.setActivityIndicator( true )
	timer.performWithDelay( 50, chooseFile )
end

-- Event handler for the Options button
local function onOptions()
	-- composer.gotoScene( "optView", { effect = "slideLeft", time = 500 } )
	composer.showOverlay( "optView", { isModal = true, effect = "slideLeft", time = 500 } )
	optionsBtn.isVisible = false
end

--- Module Functions ------------------------------------------------

-- Make the toolbar UI
function toolbar.create()
	toolbarGroup = g.makeGroup()

	-- Background
	bgRect = g.uiItem( display.newRect( toolbarGroup, 0, 0, app.width, app.dyToolbar ),
							app.toolbarShade, app.borderShade )

	-- Choose File Button
	local yCenter = app.dyToolbar / 2
	chooseFileBtn = widget.newButton{
		x = app.margin, 
		y = yCenter,
		onRelease = onChooseFile,
		label = "Choose File",
		labelAlign = "left",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	toolbarGroup:insert( chooseFileBtn )
	chooseFileBtn.anchorX = 0

	-- Options button 
	optionsBtn = widget.newButton{
		x = app.width - app.margin,
		y = yCenter,
		onRelease = onOptions,
		label = "☰",
		labelAlign = "right",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
		width = 25
	}
	toolbarGroup:insert( optionsBtn )
	optionsBtn.anchorX = 1

	-- Restart button
	restartBtn = widget.newButton{
		x = optionsBtn.x - optionsBtn.width, 
		y = yCenter,
		onRelease = app.processUserFile,
		label = "Restart",
		labelAlign = "right",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	toolbarGroup:insert( restartBtn )
	restartBtn.anchorX = 1
end

-- Resize the toolbar
function toolbar.resize()
	bgRect.width = app.width
	optionsBtn.x = app.width - app.margin
end

-- Show the options button
function toolbar.showOptionsButton()
	optionsBtn.isVisible = true
end


------------------------------------------------------------------------------

return toolbar



