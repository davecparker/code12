-----------------------------------------------------------------------------------------
--
-- Scrollbar.lua
--
-- Class to implement a vertical scrollbar for the Code12 Desktop app.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 app modules
local app = require( "app" )


-- Layout constants
local margin = 2                             -- pixel margin to use
local width = 12                             -- scrollbar width

-- Computed layout metrics
local radius = (width - margin) / 2          -- radius of circlular parts
local diameter = radius * 2                  -- diameter of top circular parts
local minHeight = margin * 2 + diameter      -- don't show if shorter than this
local dyMinShuttle = diameter * 3              -- minimum pixel height of shuttle

-- Gray shades
local bgShade = 0.95
local shuttleShade = 0.8


-- The scrollbar class
local Scrollbar = {
	width = width,                -- width of scrollbars, for app use
}


--- Internal Functions ---------------------------------------------------------

-- Layout the track elements 
function Scrollbar:layoutTrack()
	-- Hide scrollbar if not enought height to show
	local height = self.height
	if height < minHeight then
		self.group.isVisible = false
		return
	end
	self.group.isVisible = true
	self.bg.height = height

	-- Layout track parts
	self.trackMiddle.height = height - margin - margin - diameter
	self.trackBottom.y = margin + self.trackMiddle.height
end

-- Move the shuttle using the given touch position and notify the app
function Scrollbar:moveShuttle( y )
	-- Compute new shuttle top
	local yTop = y - self.yDragOffset
	yTop = math.min( math.max( yTop, self.yMinShuttle ), self.yMaxShuttle )

	-- Move the graphics
	self.shuttleTop.y = yTop
	self.shuttleMiddle.y = yTop + radius
	self.shuttleBottom.y = yTop + self.shuttleMiddle.height
end

-- Handle touch events on a scrollbar
function Scrollbar:touch( event )
	-- Which part got touched?
	local x, y = self.group:contentToLocal( event.x, event.y )
	local yTop = self.shuttleTop.y
	if y >= yTop and y <= self.shuttleBottom.y + diameter then
		-- Touch on shuttle
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			self.dragging = true
			self.yDragOffset = event.y - yTop
		else
			if event.phase ~= "cancelled" and self.dragging then
				self:moveShuttle( event.y )
			end
			if event.phase ~= "moved" then
				self.dragging = false
				display.getCurrentStage():setFocus( nil )
			end
		end
	else
		-- Touch on track. Go up or down down one "page" on a click
		if event.phase == "began" then
			local pageSize = self.rangeMax - self.rangeMin
			local newPos
			if y < yTop then
				newPos = self.pos - pageSize
			else
				newPos = self.pos + pageSize
			end
			self:adjust( self.rangeMin, self.rangeMax, newPos, self.ratio )
		end
	end
	return true
end


--- Module Functions ---------------------------------------------------------

-- Construct and return a scrollbar at the given position and size in parent.
-- The onChangePos function will be called passing new the pos value when the 
-- user changes the scroll position.
function Scrollbar:new( parent, x, y, height, onChangePos )
	-- Make a group for the scrollbar
	local group = app.makeGroup( parent, x, y )

	-- Create a new instance
	local sb = {
		-- Layout metrics
		rangeMin = 0,        -- range minimum from app, set by adjust
		rangeMax = 100,      -- range minimum from app, set by adjust
		pos = 0,             -- current position, set by adjust
		ratio = 0,           -- shuttle size relative to range (0-1), set by adjust
		height = height,     -- pixel height of scrollbar
		yMinShuttle = 0,     -- min pixel pos for shuttle
		yMaxShuttle = 0,     -- max pixel pos for shuttle
		dragging = false,    -- true when dragging the shuttle
		yDragOffset = 0,     -- y offset when dragging shuttle

		-- Display parts (finished in layout)
		group = group,    -- display group for the scrollbar
		bg = app.uiWhite( display.newRect( group, 0, 0, width, height ) ),
		trackTop = app.uiItem( display.newCircle( group, 0, margin, radius ), bgShade ),
		trackMiddle = app.uiItem( display.newRect( group, 0, radius, width - margin, 0 ), bgShade ),
		trackBottom = app.uiItem( display.newCircle( group, 0, 0, radius ), bgShade ),
		shuttleTop = app.uiItem( display.newCircle( group, 0, 0, radius ), shuttleShade ),
		shuttleMiddle = app.uiItem( display.newRect( group, 0, 0, width - margin, 0 ), shuttleShade ),
		shuttleBottom = app.uiItem( display.newCircle( group, 0, 0, radius ), shuttleShade ),

		-- Change callback function
		onChangePos = onChangePos,
	}

	-- Set touch listeners for the shuttle and extra space
	sb.shuttleTop:addEventListener( "touch", sb )
	sb.shuttleMiddle:addEventListener( "touch", sb )
	sb.shuttleBottom:addEventListener( "touch", sb )
	sb.trackTop:addEventListener( "touch", sb )
	sb.trackMiddle:addEventListener( "touch", sb )
	sb.trackBottom:addEventListener( "touch", sb )

	-- Set the object's metatable
	setmetatable( sb, self)
	self.__index = self

	-- Do the track layout then return it
	sb:layoutTrack()
	return sb
end

-- Set the range and position of a scrollbar. 
-- The pos should be within the range rangeMin to rangeMax,
-- and ratio is the size for the shuttle relative to the range (0-1).
-- If ratio is >= 1 then the scrollbar is hidden.
function Scrollbar:adjust( rangeMin, rangeMax, pos, ratio )
	-- Store the metrics
	pos = math.min( math.max( pos, rangeMin ), rangeMax )  -- force pos inside range
	self.rangeMin = rangeMin
	self.rangeMax = rangeMax
	self.pos = pos
	self.ratio = ratio

	-- Determine the shuttle range and hide the scrollbar if not needed
	if ratio >= 1 or self.height < minHeight then
		self.group.isVisible = false
		return
	end
	self.group.isVisible = true
	local range = rangeMax - rangeMin
	local dyShuttle = math.max( ratio * self.height, dyMinShuttle )
	self.yMinShuttle = margin
	local dyRangeShuttle = self.height - margin * 2 - dyShuttle
	self.yMaxShuttle = self.yMinShuttle + dyRangeShuttle

	-- Position the parts
	local yShuttle = (pos - rangeMin) * dyRangeShuttle / range + margin
	self.shuttleTop.y = yShuttle
	self.shuttleMiddle.y = yShuttle + radius
	self.shuttleMiddle.height = dyShuttle - diameter
	self.shuttleBottom.y = yShuttle + self.shuttleMiddle.height
end 
	
-- Change the display position and/or height of the scrollbar
function Scrollbar:setPosition( x, y, height )
	self.group.x = x
	self.group.y = y
	self.height = height

	self:layoutTrack()
	self:adjust( self.rangeMin, self.rangeMax, self.pos, self.ratio )
end



------------------------------------------------------------------------------
return Scrollbar

