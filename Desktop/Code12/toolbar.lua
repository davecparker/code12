-----------------------------------------------------------------------------------------
--
-- toolbar.lua
--
-- The toolbar for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local composer = require( "composer" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local source = require( "source" )
local buttons = require( "buttons" )
local runtime = require( "Code12.runtime" )
local runView = require( "runView" )
local err = require( "err" )


-- The toolbar module
local toolbar = {}


-- File local state
local toolbarGroup        -- display group for toolbar
local bgRect              -- background rect
local chooseProgramBtn    -- Choose Program button
local optionsBtn          -- Options button
local restartBtn          -- Restart button
local stopBtn             -- Stop button
local pauseBtn            -- Pause button
local resumeBtn           -- Resume button
local nextFrameBtn        -- Next Frame button
local helpBtn             -- Help button
local gridBtn             -- Toggle grid button
local toolbarBtns         -- Array of buttons on the toolbar


--- Internal Functions ------------------------------------------------

-- Event handler for the Choose Program button
local function onChooseProgram()
	runtime.clearProgram()
	source.clear()
	err.initProgram()
	composer.gotoScene( "getFile" )
end

-- Event handler for the Options button
local function onOptions()
	if g.runState == "running" then
		runtime.pause()
	end
	composer.gotoScene( "optionsView" )
end

-- Show the toolbar buttons in given array btns and hide any other buttons.
-- The btns should be ordered as right-aligned buttons right to left,
-- then left-aligned buttons left to right.
local function showButtons( btns )
	-- Show requested buttons only, place right-aligned buttons, 
	-- and hide left-aligned buttons as necessary if not enough room.
	for _, btn in ipairs(toolbarBtns) do
		btn.isVisible = false
	end
	local xMax = app.width - app.margin / 2
	for _, btn in ipairs(btns) do
		btn.isVisible = true
		if btn.placement == "right" then
			btn.x = xMax - btn.btn.width
			xMax = btn.x - app.margin / 2
		elseif btn.x + btn.btn.width > xMax then
			btn.isVisible = false
		end
	end
end


--- Module Functions ------------------------------------------------

-- Make the toolbar UI
function toolbar.create()
	local restartBtnWidth = 75
	local resumeBtnWidth = 80
	toolbarGroup = g.makeGroup()
	toolbarBtns = {}

	-- Background
	bgRect = g.uiItem( display.newRect( toolbarGroup, 0, 0, app.width, app.dyToolbar ),
							app.toolbarShade, app.borderShade )

	-- Help button
	helpBtn = buttons.newToolbarButton( toolbarGroup, "Help", "help-icon.png", 
			app.showHelp, "right" )
	toolbarBtns[#toolbarBtns + 1] = helpBtn

	-- Options button
	optionsBtn = buttons.newToolbarButton( toolbarGroup, "Options", "options-icon.png", 
			onOptions, "right", helpBtn )
	toolbarBtns[#toolbarBtns + 1] = optionsBtn

	-- Choose Program Button
	chooseProgramBtn = buttons.newToolbarButton( toolbarGroup, "File", "choose-program-icon.png", 
			onChooseProgram, "right", optionsBtn )
	toolbarBtns[#toolbarBtns + 1] = chooseProgramBtn 

	-- Stop button
	stopBtn = buttons.newToolbarButton( toolbarGroup, " Stop", "stop-icon.png", 
			runtime.stop, "left", nil, restartBtnWidth )
	toolbarBtns[#toolbarBtns + 1] = stopBtn

	-- Restart button
	restartBtn = buttons.newToolbarButton( toolbarGroup, "Restart", "resume-icon.png", 
			app.processUserFile, "left", nil, restartBtnWidth )
	toolbarBtns[#toolbarBtns + 1] = restartBtn

	-- Pause button
	pauseBtn = buttons.newToolbarButton( toolbarGroup, "Pause", "pause-icon.png", 
			runtime.pause, "left", restartBtn, resumeBtnWidth )
	toolbarBtns[#toolbarBtns + 1] = pauseBtn

	-- Resume button
	resumeBtn = buttons.newToolbarButton( toolbarGroup, "Resume", "resume-icon.png", 
			runtime.resume, "left", restartBtn, resumeBtnWidth )
	toolbarBtns[#toolbarBtns + 1] = resumeBtn
	
	-- Next Frame button
	nextFrameBtn = buttons.newToolbarButton( toolbarGroup, "Next Frame", "next-frame-icon.png", 
			runtime.stepOneFrame, "left", resumeBtn )
	toolbarBtns[#toolbarBtns + 1] = nextFrameBtn

	-- Toggle Grid button
	gridBtn = buttons.newToolbarButton( toolbarGroup, "Grid", "grid-icon.png", 
			runView.toggleGrid, "left", nextFrameBtn )
	toolbarBtns[#toolbarBtns + 1] = gridBtn

	-- Set the initial visibility of the toolbar buttons
	toolbar.update()
end

-- Resize the toolbar
function toolbar.resize()
	bgRect.width = app.width
	toolbar.update()
end

-- Show/hide the toolbar
function toolbar.show( show )
	toolbarGroup.isVisible = show
end

-- Update the buttons visible on the toolbar based on the run state
function toolbar.update()
	local runState = g.runState
	if runState == "running" then
		showButtons{ helpBtn, optionsBtn, stopBtn, pauseBtn, gridBtn }
	elseif runState == "waiting" then
		showButtons{ helpBtn, stopBtn, gridBtn }
	elseif runState == "paused" then
		if runtime.canStepOneFrame() then
			showButtons{ helpBtn, optionsBtn, resumeBtn, stopBtn, nextFrameBtn, gridBtn }
		else
			showButtons{ helpBtn, resumeBtn, stopBtn, gridBtn }
		end
	elseif runState == "stopped" then
		showButtons{ helpBtn, optionsBtn, chooseProgramBtn, restartBtn, gridBtn }
	elseif runState == "error" then
		showButtons{ helpBtn, optionsBtn, chooseProgramBtn, }
	else
		showButtons{ helpBtn, optionsBtn }
	end
end


------------------------------------------------------------------------------

return toolbar



