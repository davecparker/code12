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


-- The toolbar module
local toolbar = {}


-- File local state
local toolbarGroup        -- display group for toolbar
local bgRect              -- background rect
local chooseProgramBtn    -- Choose Program button
local optionsBtn          -- Options button
local restartBtn          -- Restart button


--- Internal Functions ------------------------------------------------


-- Event handler for the Choose Program button
local function onChooseProgram()
	composer.gotoScene( "getFile" )
end

-- Event handler for the Options button
local function onOptions()
	composer.gotoScene( "optionsView" )
end

--- Module Functions ------------------------------------------------

-- Make the toolbar UI
function toolbar.create()
	toolbarGroup = g.makeGroup()
	local yCenter = app.dyToolbar / 2

	-- Background
	bgRect = g.uiItem( display.newRect( toolbarGroup, 0, 0, app.width, app.dyToolbar ),
							app.toolbarShade, app.borderShade )

	-- Restart button
	restartBtn = widget.newButton{
		x = app.margin, 
		y = yCenter,
		onRelease = app.processUserFile,
		label = "Restart",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
		textOnly = true,
	}
	toolbarGroup:insert( restartBtn )
	restartBtn.anchorX = 0

	-- Options button 
	optionsBtn = widget.newButton{
		x = app.width - app.margin,
		y = yCenter,
		onRelease = onOptions,
		label = "Options",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
		textOnly = true,
	}
	toolbarGroup:insert( optionsBtn )
	optionsBtn.anchorX = 1

	-- Choose Program Button
	chooseProgramBtn = widget.newButton{
		x = optionsBtn.x - optionsBtn.width - app.margin,
		y = yCenter,
		onRelease = onChooseProgram,
		label = "Choose Program",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
		textOnly = true,
	}
	toolbarGroup:insert( chooseProgramBtn )
	chooseProgramBtn.anchorX = 1
end

-- Resize the toolbar
function toolbar.resize()
	bgRect.width = app.width
	optionsBtn.x = app.width - app.margin
	chooseProgramBtn.x = optionsBtn.x - optionsBtn.width - app.margin
end

-- Show/hide the toolbar
function toolbar.show( show )
	toolbarGroup.isVisible = show
end


------------------------------------------------------------------------------

return toolbar



