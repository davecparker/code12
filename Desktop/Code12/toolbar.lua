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
local buttons = require( "buttons" )
local runtime = require( "Code12.runtime" )
local runView = require( "runView" )


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
local gridBtn             -- Toggle grid button
local toolbarBtns         -- Array of buttons on the toolbar


--- Internal Functions ------------------------------------------------

-- Event handler for the Choose Program button
local function onChooseProgram()
	composer.gotoScene( "getFile" )
end

-- Event handler for the Options button
local function onOptions()
	composer.gotoScene( "optionsView" )
end

-- Show the toolbar buttons in given array btns and hide any other buttons
local function showButtons( btns )
	for i = 1, #toolbarBtns do
		toolbarBtns[i].isVisible = false
		for j = 1, #btns do
			if toolbarBtns[i] == btns[j] then
				toolbarBtns[i].isVisible = true
				break
			end
		end
	end
	if gridBtn.isVisible then
		-- Check if it is overlapping choose program button or options button
		local xMax = gridBtn.x + gridBtn.width + app.margin 
		if chooseProgramBtn.isVisible and chooseProgramBtn.x < xMax or
				optionsBtn.isVisible and optionsBtn.x < xMax then
			gridBtn.isVisible = false
		end
	end
end


--- Module Functions ------------------------------------------------

-- Make the toolbar UI
function toolbar.create()
	local pauseBtnWidth = 80
	toolbarGroup = g.makeGroup()
	toolbarBtns = {}

	-- Background
	bgRect = g.uiItem( display.newRect( toolbarGroup, 0, 0, app.width, app.dyToolbar ),
							app.toolbarShade, app.borderShade )

	-- Options button
	optionsBtn = buttons.newToolbarButton( toolbarGroup, "Options", "options-icon.png", onOptions, "right" )
	toolbarBtns[#toolbarBtns + 1] = optionsBtn

	-- Choose Program Button
	chooseProgramBtn = buttons.newToolbarButton( toolbarGroup, "Choose Program", "choose-program-icon.png", 
			onChooseProgram, "right", optionsBtn )
	toolbarBtns[#toolbarBtns + 1] = chooseProgramBtn 

	-- Pause button
	pauseBtn = buttons.newToolbarButton( toolbarGroup, "Pause", "pause-icon.png", runtime.pause, "left", nil, 
			pauseBtnWidth )
	toolbarBtns[#toolbarBtns + 1] = pauseBtn

	-- Resume button
	resumeBtn = buttons.newToolbarButton( toolbarGroup, "Resume", "resume-icon.png", runtime.resume, "left", nil, 
			pauseBtnWidth )
	toolbarBtns[#toolbarBtns + 1] = resumeBtn
	
	-- Stop button
	stopBtn = buttons.newToolbarButton( toolbarGroup, "Stop", "stop-icon.png", runtime.stop, "left", pauseBtn )
	toolbarBtns[#toolbarBtns + 1] = stopBtn

	-- Next Frame button
	nextFrameBtn = buttons.newToolbarButton( toolbarGroup, "Next Frame", "next-frame-icon.png", runtime.stepOneFrame, 
			"left",	stopBtn )
	toolbarBtns[#toolbarBtns + 1] = nextFrameBtn

	-- Restart button
	restartBtn = buttons.newToolbarButton( toolbarGroup, "Restart", "resume-icon.png", app.processUserFile, "left", nil, 
			pauseBtnWidth )
	toolbarBtns[#toolbarBtns + 1] = restartBtn

	-- Toggle Grid button
	gridBtn = buttons.newToolbarButton( toolbarGroup, "Grid", "grid-icon.png", runView.toggleGrid, "left", nextFrameBtn )
	toolbarBtns[#toolbarBtns + 1] = gridBtn

	-- Set the initial visibility of the toolbar buttons
	toolbar.update()
end

-- Resize the toolbar
function toolbar.resize()
	bgRect.width = app.width
	optionsBtn.x = app.width - app.margin - optionsBtn.width
	chooseProgramBtn.x = optionsBtn.x - chooseProgramBtn.width - app.margin
	toolbar.update()
end

-- Show/hide the toolbar
function toolbar.show( show )
	toolbarGroup.isVisible = show
end

-- Update the buttons visible on the toolbar based on the run state
function toolbar.update()
	local runState = g.runState
	if runState == nil then
		showButtons{ optionsBtn }
	elseif runState == "running" then
		showButtons{ stopBtn, pauseBtn, gridBtn }
	elseif runState == "waiting" then
		showButtons{ stopBtn, gridBtn }
	elseif runState == "paused" then
		showButtons{ resumeBtn, stopBtn, nextFrameBtn, gridBtn }
	elseif runState == "stopped" then
		showButtons{ restartBtn, chooseProgramBtn, optionsBtn, gridBtn }
	elseif runState == "error" then
		showButtons{ chooseProgramBtn, optionsBtn }
	end
end


------------------------------------------------------------------------------

return toolbar



