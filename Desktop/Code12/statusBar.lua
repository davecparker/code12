-----------------------------------------------------------------------------------------
--
-- statusBar.lua
--
-- The status bar for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules and plugins
local widget = require( "widget" )

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local env = require( "env" )

-- The statusBar module
local statusBar = {}


-- File local state
local statusBarGroup       -- display group for status bar
local bgRect               -- background rect
local fileText             -- filename text object
local openFileBtn          -- Open in Editor button


--- Internal Functions ------------------------------------------------

-- Open the source file in the system default text editor for its file type
local function openFileInEditor()
	local path = app.sourceFile.path
	if path then
		env.openFileInEditor( path )
	end
end


--- Module Functions ------------------------------------------------

-- Update the status bar based on data in app.sourceFile
function statusBar.update()
	local sourceFile = app.sourceFile
	if sourceFile.path == nil then
		openFileBtn.isVisible = false
		return
	end

	-- Set the fileText with update status
	local _, filename = env.dirAndFilenameOfPath( sourceFile.path )
	if sourceFile.timeModLast <= sourceFile.timeLoaded then
		fileText.text = filename    -- file has not been updated
	else
		local updateStr
		local secs = os.time() - sourceFile.timeModLast
		if secs < 10 then
			updateStr = "just now"
		elseif secs < 60 then
			updateStr = "less than a minute ago"
		elseif secs < 120 then
			updateStr = "about a minute ago"
		else
			local min = math.floor(secs / 60)
			if min > 60 then
				updateStr = "over an hour ago"
			else
				updateStr = min .. " minutes ago"
			end
		end
		fileText.text = filename .. " - Updated " .. updateStr
	end

	-- Hide the Open button if there isn't enough room
	local dxNeeded = fileText.contentWidth + openFileBtn.contentWidth + app.margin * 3
	openFileBtn.isVisible = (app.width > dxNeeded)
end

-- Resize the status bar
function statusBar.resize()
	statusBarGroup.y = app.height - app.dyStatusBar
	bgRect.width = app.width
	openFileBtn.x = app.width - app.margin
	statusBar.update()
end

-- Make the status bar UI
function statusBar.create()
	statusBarGroup = g.makeGroup( nil, 0, app.height - app.dyStatusBar )

	-- Background color
	bgRect = g.uiItem( display.newRect( statusBarGroup, 0, 0, app.width, app.dyStatusBar ),
							app.toolbarShade, app.borderShade )

	-- Filename and update status text
	local yCenter = app.dyStatusBar / 2
	fileText = display.newText( statusBarGroup, "", app.margin, yCenter, 
						native.systemFont, fontSizeUI )
	fileText.anchorX = 0
	fileText:setFillColor( 0 )

	-- Open in Editor button
	openFileBtn = widget.newButton{
		x = app.width - app.margin,
		y = yCenter,
		onRelease = openFileInEditor,
		textOnly = true,
		label = "Open in Editor",
		labelAlign = "right",
		font = native.systemFontBold,
		fontSize = app.fontSizeUI,
	}
	statusBarGroup:insert( openFileBtn )
	openFileBtn.anchorX = 1

	-- Set initial state
	statusBar.update()
end

------------------------------------------------------------------------------

return statusBar


