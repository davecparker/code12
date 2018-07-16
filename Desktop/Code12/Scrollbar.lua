-----------------------------------------------------------------------------------------
--
-- Scrollbar.lua
--
-- Class to implement a vertical scrollbar for the Code12 Desktop app.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules
local g = require( "Code12.globals" )


-- Layout constants
local xMargin = 2                            -- on either wide of shuttle
local yMargin = 2                            -- above and below the shuttle
local width = 12                             -- scrollbar width

-- Computed layout metrics
local radius = width / 2 - xMargin           -- radius of circlular parts
local diameter = radius * 2                  -- diameter of top circular parts
local minHeight = yMargin * 2 + diameter     -- don't show if shorter than this
local dyMinShuttle = diameter * 3            -- minimum pixel height of shuttle

-- Gray shades
local trackShade = 0.94
local shuttleShade = 0.75


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
	self.track.height = height
end

-- Set a new scroll pos and notify the app
function Scrollbar:setPos( pos )
	-- Force pos in range and adjust the scrollbar
	pos = g.pinValue( pos, self.rangeMin, self.rangeMax ) 
	self:adjust( self.rangeMin, self.rangeMax, pos, self.ratio )

	-- Notify the app, using nil if at the end of scroll range
	if pos == self.rangeMax then
		pos = nil
	end
	if self.onChangePos then
		self.onChangePos( pos )
	end
end

-- Handle touch events on the shuttle given phase and y within the scrollbar
function Scrollbar:touchShuttle( phase, y )
	if phase == "began" then
		self.yDragOffset = y - self.shuttleTop.y
		g.setFocusObj( self.shuttleTop )
	elseif g.getFocusObj() == self.shuttleTop and phase ~= "cancelled" then
		-- Compute new shuttle top
		local yTop = y - self.yDragOffset
		yTop = g.pinValue( yTop, self.yMinShuttle , self.yMaxShuttle )

		-- Move the graphics
		self.shuttleTop.y = yTop
		self.shuttleMiddle.y = yTop + radius
		self.shuttleBottom.y = yTop + self.shuttleMiddle.height

		-- Compute new pos and set it
		local range = self.rangeMax - self.rangeMin
		local yRange = self.yMaxShuttle - self.yMinShuttle
		local newPos = self.rangeMin + math.round( 
				(yTop - self.yMinShuttle) * range / yRange )
		self:setPos( newPos )
	end
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end
	return true
end

-- Handle touch events on the shuttle given phase and x, y within the scrollbar
function Scrollbar:touchTrack( phase, y )
	-- Touch on track. Go up or down down one "page" on a click
	if phase == "began" then
		local pageSize = math.round( self.ratio * (self.rangeMax - self.rangeMin) )
		-- print(self.rangeMin, self.rangeMax, self.ratio, pageSize)
		if y < self.shuttleTop.y then
			self:setPos( self.pos - pageSize )
		else
			self:setPos( self.pos + pageSize )
		end
		g.setFocusObj( self.track )
	elseif phase ~= "moved" then
		g.setFocusObj( nil )
	end
	return true
end

-- Handle touch events on a scrollbar
function Scrollbar:touch( event )
	-- Which part got touched?
	local _, y = self.group:contentToLocal( event.x, event.y )
	local yTop = self.shuttleTop.y
	if g.getFocusObj() == self.shuttleTop 
			or (y >= yTop and y <= self.shuttleBottom.y + diameter) then
		return self:touchShuttle( event.phase, y )
	end
	return self:touchTrack( event.phase, y )
end


--- Module Functions ---------------------------------------------------------

-- Construct and return a scrollbar at the given position and size in parent.
-- The onChangePos function will be called passing new the pos value when the 
-- user changes the scroll position.
function Scrollbar:new( parent, x, y, height, onChangePos )
	-- Make a group for the scrollbar
	local group = g.makeGroup( parent, x, y )

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
		yDragOffset = 0,     -- y offset when dragging shuttle

		-- Display parts (finished in layout)
		group = group,    -- display group for the scrollbar
		track = g.uiItem( display.newRect( group, 0, 0, width, height ), trackShade ),
		shuttleTop = g.uiItem( display.newCircle( group, xMargin, 0, radius ), shuttleShade ),
		shuttleMiddle = g.uiItem( display.newRect( group, xMargin, 0, width - xMargin * 2, 0 ), shuttleShade ),
		shuttleBottom = g.uiItem( display.newCircle( group, xMargin, 0, radius ), shuttleShade ),

		-- Change callback function
		onChangePos = onChangePos,
	}

	-- Set touch listeners for the shuttle and extra space
	sb.track:addEventListener( "touch", sb )
	sb.shuttleTop:addEventListener( "touch", sb )
	sb.shuttleMiddle:addEventListener( "touch", sb )
	sb.shuttleBottom:addEventListener( "touch", sb )

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
	pos = g.pinValue( pos, rangeMin, rangeMax )  -- force pos inside range
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
	self.yMinShuttle = yMargin
	local dyRangeShuttle = self.height - yMargin * 2 - dyShuttle
	self.yMaxShuttle = self.yMinShuttle + dyRangeShuttle

	-- Position the parts
	local yShuttle = (pos - rangeMin) * dyRangeShuttle / range + yMargin
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

-- Hide the scrollbar
function Scrollbar:hide()
	self.group.isVisible = false
end

-- Move the scrollbar to the front of its parent group
function Scrollbar:toFront()
	self.group:toFront()
end


------------------------------------------------------------------------------
return Scrollbar

