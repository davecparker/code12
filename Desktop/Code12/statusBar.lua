-----------------------------------------------------------------------------------------
--
-- statusBar.lua
--
-- The status bar for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 app modules
local g = require( "Code12.globals" )
local app = require( "app" )
local source = require( "source" )
local env = require( "env" )

-- The statusBar module
local statusBar = {}


-- File local state
local statusBarGroup       -- display group for status bar
local bgRect               -- background rect
local fileText             -- filename text object


--- Module Functions ------------------------------------------------

-- Update the status bar based on data in source
function statusBar.update()
	-- Set blank status bar if no file
	if source.path == nil then
		fileText.text = ""
		return
	end

	-- Set the fileText with runState and update status
	local _, text = env.dirAndFilenameOfPath( source.path )
	if source.timeLoaded ~= 0 and source.timeModLast ~= 0 
			and source.timeModLast >= app.startTime then
		-- File has been updated since first loaded
		local updateStr
		local secs = os.time() - source.timeModLast
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
		text = text .. " - Updated " .. updateStr
	end
	if g.runState then
		text = text .. " (" .. g.runState .. ")"
	end 
	fileText.text = text
end

-- Resize the status bar
function statusBar.resize()
	statusBarGroup.y = app.height - app.dyStatusBar
	bgRect.width = app.width
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
						native.systemFont, app.fontSizeUI )
	fileText.anchorX = 0
	fileText:setFillColor( 0 )

	-- Set initial state
	statusBar.update()
end

------------------------------------------------------------------------------

return statusBar


