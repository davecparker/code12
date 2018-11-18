-----------------------------------------------------------------------------------------
--
-- GameObj.lua
--
-- Implementation of the GameObj class for the Code12 Lua runtime.
--
-- (c)Copyright 2018 by Code12. All Rights Reserved.
-----------------------------------------------------------------------------------------


-- Runtime support modules
local g = require("Code12.globals")
local runtime = require("Code12.runtime")


-- Constants
local textObjectFont = "Roboto-Bold.ttf"


-- The GameObj class
local GameObj = {}


---------------- Misc. Internal Functions  ----------------------------

-- Return 0 if num is negative, else num.
local function forceNotNegative(num)
	if num < 0 then
		return 0
	end
	return num
end

-- Init the GameObj class
local function initGameObjClass()
	-- Create a dummy display object for deleted GameObj objects to reference,
	-- to try to avoid crashes in buggy client code.
	local obj = display.newRect(-10000, -10000, 0, 0)
	obj.isVisible = false
	GameObj.dummyObj = obj
end


---------------- Object Sizing Methods --------------------------------
 
-- Update the size for a rectangular object
local function updateSizeRect(gameObj, width, height, scale)
	gameObj.width = width
	gameObj.height = height
	local obj = gameObj.obj
	obj.width = width * scale
	obj.height = height * scale
end

-- Update the size for a circle object
local function updateSizeCircle(gameObj, width, height, scale)
	gameObj.width = width
	gameObj.height = height
	local obj = gameObj.obj
	obj.path.radius = (width / 2) * scale
	obj.yScale = height / width   -- to allow an ellipse in Corona
end

-- Return the Corona font size to use for a given logical object height at the
-- given scale, so that the GameObj and drawing object heights match.
local function fontSizeFromHeight(height, scale)
	return height * scale * 0.85   -- TODO: is the fudge device-dependent?
end

-- Update the size for a text object (width is ignored)
local function updateSizeText(gameObj, _, height, scale)
	local prevHeight = gameObj.height
	gameObj.height = height
	-- Determine and set new font size
	local fontSize = fontSizeFromHeight(height, scale)   -- new font size
	gameObj.obj.size = math.max(1, fontSize)      -- 0 means default in Corona so 1 is as small we can go
	-- Estimate the new width because Corona hasn't calculated it yet
	gameObj.width = gameObj.width * height / prevHeight
end

-- Update the size for a line object. 
-- Note that width and height are signed offsets to the second point.
local function updateSizeLine(gameObj, width, height, scale)
	gameObj.width = width
	gameObj.height = height
	-- Line endpoints cannot be changed in Corona, so when the endpoint changes
	-- we need to delete and re-create the line display object.
	-- Find object index in parent group
	local obj = gameObj.obj
	local group = obj.parent
	for i = 1, group.numChildren do
		if group[i] == obj then
			-- Create the new line to replace this one
			local x = obj.x
			local y = obj.y
			local newObj = display.newLine(x, y, x + width * scale, y + height * scale)
			gameObj:setObj(newObj)
			group:insert(i, newObj)   -- insert at same z-order as old line
			gameObj:setLineColorFromColor(gameObj.lineColor)  -- sets color and stroke width
			-- Remove old line
			obj:removeSelf()
			break
		end
	end
end


---------------- GameObj Construction ----------------------------------------

-- Base constructor
function GameObj:new(typeName, x, y, width, height)
	-- Create a new instance
	local gameObj = {
		-- Public data fields (units here are logical unscaled)
		x = x,
		y = y,
		xSpeed = 0,
		ySpeed = 0,
		visible = true,
		clickable = true,
		group = "",

		-- Private fields
		typeName = typeName,     -- "circle", "rect", etc.
		width = width,
		height = height,
		obj = nil,               -- the Corona display object
		text = nil,
		fillColor = nil,
		lineColor = nil,
		lineWidth = 1,
		layer = 1,
		deleted = false,
	}

	-- Assign default methods
	gameObj.updateSize = updateSizeRect
	gameObj.objContainsPoint = GameObj.boundsContainsPoint

	-- Set the object's metatable and return it
	setmetatable(gameObj, self)
	self.__index = self
	return gameObj
end

-- Return true if gameObj is an instance of a GameObj
function GameObj.isGameObj(gameObj)
	return (type(gameObj) == "table") and (getmetatable(gameObj) == GameObj)
end

-- Set the Corona display object for a GameObj
function GameObj:setObj(obj)
	-- Both objects have a reference to each other
	self.obj = obj
	if obj ~= nil then
		obj.code12GameObj = self
		self:setLayer(self.layer)
		obj:addEventListener("touch", g.onTouchGameObj)
		obj:addEventListener("finalize", obj)

		function obj:finalize()
			self.code12GameObj = nil
		end
	end
end

-- Remove a GameObj and delete the display object.
-- The GameObj will be subject to garbage collection when outstanding refs to it are gone.
function GameObj:removeAndDelete()
	if self.deleted then  -- This object was already deleted
		runtime.warning("Attempt to delete an object that was already deleted")
		return
	end
	local obj = self.obj
	obj.code12GameObj = nil    -- remove display object's reference to the GameObj
	obj:removeSelf()	       -- remove and destroy the display object
	self.obj = GameObj.dummyObj    -- dummy display object to help client avoid crashes
	self.deleted = true
	self.visible = false       -- to reduce impact of any stale references
	self.clickable = false
end

-- Circle constructor
function GameObj:newCircle(group, x, y, diameter, colorName)
	diameter = forceNotNegative(diameter)
	local gameObj = GameObj:new("circle", x, y, diameter, diameter)
	gameObj:setObj(display.newCircle(group, x, y, diameter / 2))
	gameObj.updateSize = updateSizeCircle    -- override sizing method
	gameObj.objContainsPoint = GameObj.circleContainsPoint  -- override hit test method
	gameObj:setFillColorFromName(colorName or "red")
	gameObj:setLineColorFromName("black")
	return gameObj
end

-- Rect constructor
function GameObj:newRect(group, x, y, width, height, colorName)
	width = forceNotNegative(width)
	height = forceNotNegative(height)
	local gameObj = GameObj:new("rect", x, y, width, height)
	gameObj:setObj(display.newRect(group, x, y, width, height))
	gameObj:setFillColorFromName(colorName or "yellow")
	gameObj:setLineColorFromName("black")
	return gameObj
end

-- Line constructor
function GameObj:newLine(group, x1, y1, x2, y2, colorName)
	local gameObj = GameObj:new("line", x1, y1, x2 - x1, y2 - y1)
	gameObj:setObj(display.newLine(group, x1, y1, x2, y2))
	gameObj.updateSize = updateSizeLine   -- override sizing method
	gameObj.objContainsPoint = GameObj.lineContainsPoint   -- override hit test method
	gameObj.hitObj = GameObj.lineHitObj   -- override collision test method
	gameObj:setLineColorFromName(colorName or "black")
	return gameObj
end

-- Text constructor
function GameObj:newText(group, text, x, y, height, colorName)
	text = text or ""
	height = forceNotNegative(height)
	local gameObj = GameObj:new("text", x, y, 0, height)  -- width set below
	local obj = display.newText(group, text, x, y, textObjectFont,
						fontSizeFromHeight(height, g.scale))
	gameObj:setObj(obj)
	gameObj.width = obj.width / g.scale   -- Corona measured when obj created
	gameObj.updateSize = updateSizeText   -- override sizing method
	gameObj.text = text
	gameObj:setFillColorFromName(colorName or "black")
	return gameObj
end

-- Image constructor
function GameObj:newImage(group, filename, x, y, width)
	width = forceNotNegative(width)
	if filename == "" then
		filename = nil
	end
	local obj = nil
	if filename ~= nil then
		-- If an app context tells us the media directory then use it, else current dir.
		local baseDir, path
		local appContext = runtime.appContext
		if appContext and appContext.mediaDir then
			path = appContext.mediaDir .. filename
			baseDir = appContext.mediaBaseDir
		else
			path = filename
			baseDir = system.ResourceDirectory
		end

		-- Try to open the image at native resolution
		obj = display.newImage(group, path, baseDir, x, y)
	end
	if not obj then
		-- Can't open image, substitute a text object with a red X
		runtime.warning("Cannot find image file", filename)
		return GameObj:newText(group, "[x]", x, y, width, "red")
	end

	-- Create the GameObj at the right size, preserving the original aspect
	local height = width * obj.height / obj.width
	local gameObj = GameObj:new("image", x, y, width, height)
	gameObj:setObj(obj)
	gameObj:setText(filename)     -- set text field to filename by default
	return gameObj
end


---------------- Geometry and Hit Testing ------------------------------------

-- Return true if the object bounding box contains (xPoint, yPoint)
function GameObj:boundsContainsPoint(xPoint, yPoint)
	-- Test each side, taking alignment into account.
	local obj = self.obj
	local left = self.x - (self.width * obj.anchorX)
	if xPoint < left then
		return false
	end
	local right = left + self.width
	if xPoint > right then
		return false
	end
	local top =  self.y - (self.height * obj.anchorY)
	if yPoint < top then
		return false
	end
	local bottom = top + self.height
	if yPoint > bottom then
		return false
	end         
	return true   
end	

-- Return true if a circle object contains (xPoint, yPoint)
function GameObj:circleContainsPoint(xPoint, yPoint)
	-- Reject test rectangular bounds first
	if not self:boundsContainsPoint(xPoint, yPoint) then
		return false
	end

	-- Find ellipse center point considering alignment
	local w = self.width
	local h = self.height
	local obj = self.obj
	local xCenter = self.x + (w * (0.5 - obj.anchorX)) 
	local yCenter = self.y + (h * (0.5 - obj.anchorY))

	-- Test for point inside ellipse
	local dx = xPoint - xCenter
	local dy = yPoint - yCenter
	return ((dx * dx) / (w * w)) + ((dy * dy) / (h * h)) <= 0.25
end

-- Returns the squared distance from lineObj to (xPoint, yPoint)
local function squaredDistanceFromPointToLine(lineObj, xPoint, yPoint)
   local ax = xPoint - lineObj.x
   local ay = yPoint - lineObj.y
   local bx = lineObj.width
   local by = lineObj.height
   local compAB = (ax * bx + ay * by) / (bx * bx + by * by)
   local nx = ax - bx * compAB
   local ny = ay - by * compAB
   return nx * nx + ny * ny
end

-- Return true if xPoint, yPoint is inside the line (for thick lines)
-- or within 2 pixels of the line (for thin lines)
function  GameObj:lineContainsPoint(xPoint, yPoint)
   -- Reject test rectangular bounds first
   local halfW
   local lineWidth = self.lineWidth
   if lineWidth < 4 then
      halfW = 2 / g.scale
   else
      halfW = (lineWidth / g.scale) / 2
   end
   local left = self.x
   local right = left + self.width
   if left > right then
      left, right = right, left
   elseif left == right then
      left = self.x - halfW
      right = self.x + halfW
   end
   if xPoint < left or xPoint > right then
      return false
   end
   local top = self.y
   local bottom = top + self.height
   if top > bottom then
      top, bottom = bottom, top
   elseif top == bottom then
      top = self.y - halfW
      bottom = self.y + halfW
   end
   if yPoint < top or yPoint > bottom then
      return false
   end
   -- Compare squared distance from point to line to squared halfwidth of line
   return squaredDistanceFromPointToLine(self, xPoint, yPoint) <= halfW * halfW
end

-- Return true if this object intersects with gameObj2
function GameObj:hitObj(gameObj2)
	-- Just do a rectangle intersection test on the bounding rects.
	if gameObj2.typeName == "line" then
      return gameObj2:hitObj(self)
   end
	local obj = self.obj
	local obj2 = gameObj2.obj
	local left = self.x - (self.width * obj.anchorX)
	local right = left + self.width;
	local left2 = gameObj2.x - (gameObj2.width * obj2.anchorX)
	local right2 = left2 + gameObj2.width
	if right2 < left or left2 > right then
		return false
	end
	local top =  self.y - (self.height * obj.anchorY)
	local bottom = top + self.height
	local top2 =  gameObj2.y - (gameObj2.height * obj2.anchorY)
	local bottom2 = top2 + gameObj2.height
	if bottom2 < top or top2 > bottom then
		return false
	end
	return true
end

-- Return true if lineObj (from left to right) intersects a vertical line from (x2, top2) to (x2, bottom2)
-- Assumes top2 < bottom2 and lineObj is not vertical
local function slantLineHitVertical(lineObj, left, right, x2, top2, bottom2)
   if left > x2 or right < x2 then
      return false
   end
   local yIntercept = lineObj.height / lineObj.width * (x2 - lineObj.x) + lineObj.y
   return top2 <= yIntercept and yIntercept <= bottom2
end

-- Return true if lineObj (from top to bottom) intersects a horizontal line from (left2, y2) to (right2, y2)
-- Assumes left2 < right2 and this line is not horizontal
local function slantLineHitHorizontal(lineObj, top, bottom, y2, left2, right2)
   if top > y2 or bottom < y2 then
      return false
   end
   local xIntercept = lineObj.width / lineObj.height * (y2 - lineObj.y) + lineObj.x
   return left2 <= xIntercept and xIntercept <= right2
end

-- Return true if lineObj intersects a rectangle aligned with the coordinate axes.
-- Assumes the lineObj's bounding rect is intersecting the rectangle and lineObj is not horizontal or vertical.
local function slantLineHitRect(lineObj, left, right, top, bottom, rectLeft, rectRight, rectTop, rectBottom)
   if slantLineHitVertical(lineObj, left, right, rectLeft, rectTop, rectBottom) then -- hit rectLeft
      return true
   end
   if slantLineHitVertical(lineObj, left, right, rectRight, rectTop, rectBottom) then -- hit rectRight
      return true
   end
   if slantLineHitHorizontal(lineObj, top, bottom, rectTop, rectLeft, rectRight) then -- hit rectTop
      return true
   end
   if slantLineHitHorizontal(lineObj, top, bottom, rectBottom, rectLeft, rectRight) then -- hit rectBottom
      return true
   end
   -- Check if this line is inside the rect's bounds
   if left >= rectLeft and right <= rectRight and top >= rectTop and bottom <= rectBottom then
      return true
   end
   return false
end

-- Return true if this line intersects with gameObj2
function GameObj:lineHitObj(gameObj2)
   if gameObj2.typeName == "line" then
      -- Do a rectangle intersection test on the bounding rects.
      local halfW = (self.lineWidth / g.scale) / 2
      local halfW2 = (gameObj2.lineWidth / g.scale) / 2
      local x, width = self.x, self.width
      local left = x
      local right = left + width
      if left == right then
         left = x - halfW
         right = x + halfW
      elseif left > right then
         left, right = right, left
      end
      local x2, width2 = gameObj2.x, gameObj2.width
      local left2 = x2
      local right2 = left2 + width2
      if left2 == right2 then
         left2 = x2 - halfW2
         right2 = x2 + halfW2
      elseif left2 > right2 then
         left2, right2 = right2, left2
      end
      if right2 < left or left2 > right then
         return false
      end
      local y, height = self.y, self.height
      local top = y
      local bottom = top + height
      if top == bottom then
         top = y - halfW
         bottom = y + halfW
      elseif top > bottom then
         top, bottom = bottom, top
      end
      local y2, height2 = gameObj2.y, gameObj2.height
      local top2 = y2
      local bottom2 = top2 + height2
      if top2 == bottom2 then
         top2 = y2 - halfW2
         bottom2 = y2 + halfW2
      elseif top2 > bottom2 then
         top2, bottom2 = bottom2, top2
      end
      if bottom2 < top or top2 > bottom then
         return false
      end
      -- Check vertical/horizontal line cases
      if width == 0 or height == 0 then
         if width2 == 0 or height2 == 0 then
            return true
         else
            return slantLineHitRect(gameObj2, left2, right2, top2, bottom2, left, right, top, bottom)
         end
      elseif width2 == 0 or width2 == 0 then
         return slantLineHitRect(self, left, right, top, bottom, left2, right2, top2, bottom2)
      end
      -- Both lines are slant lines
      -- Calculate the intersection point
      local det = height2 * width - width2 * height
      if det == 0 then 
         -- parallel lines and bounding boxes intersect
         -- check if they are close enough for a hit
         local minDist = halfW + halfW2
         return squaredDistanceFromPointToLine(self, x2, y2) <= minDist * minDist
      end
      local t = ( width2 * (y - y2) - height2 * (x - x2) ) / det
      if t < 0 or t > 1 then
         return false
      end
      local s = ( width * (y - y2) - height * (x - x2) ) / det
      if s < 0 or s > 1 then
         return false
      end
      return true
   else 
   -- gameObj2 is not a line
   -- Do a rectangle intersection test on the bounding rects.
      local halfW = (self.lineWidth / g.scale) / 2
      local obj2 = gameObj2.obj
      local x, width = self.x, self.width
      local left = x
      local right = left + width
      if left > right then
         left, right = right, left
      elseif left == right then
         left = x - halfW
         right = x + halfW
      end
      local width2 = gameObj2.width
      local left2 = gameObj2.x - (width2 * obj2.anchorX)
      local right2 = left2 + width2
      if left2 > right or right2 < left then
         return false
      end
      local y, height = self.y, self.height
      local top = y
      local bottom = top + height
      if top > bottom then
         top, bottom = bottom, top
      elseif top == bottom then
         top = y - halfW
         bottom = y + halfW
      end
      local height2 = gameObj2.height
      local top2 = gameObj2.y - (height2 * obj2.anchorY)
      local bottom2 = top2 + height2
      if top2 > bottom or bottom2 < top then
         return false
      end
      -- Bounding rects intersect
      -- TODO: Circles?
      if width == 0 or height == 0 then
         return true
      end
      return slantLineHitRect(self, left, right, top, bottom, left2, right2, top2, bottom2)
   end
end


---------------- Alignment ---------------------------------------------------

-- Map alignment names to { anchorX, anchorY }
local alignments = {
	["top left"] =       { 0,   0 },
	["top"] =            { 0.5, 0 },
	["top center"] =     { 0.5, 0 },
	["top right"] =      { 1,   0 },
	["left"] =           { 0,   0.5 },
	["center"] =         { 0.5, 0.5 },
	["right"] =          { 1,   0.5 },
	["bottom left"] =    { 0,   1 },
	["bottom"] =         { 0.5, 1 },
	["bottom center"] =  { 0.5, 1 },
	["bottom right"] =   { 1,   1 };
}

-- Set an object's alignment from an alignment name. 
-- If the name is invalid, print a warning and don't change the object.
function GameObj:setAlignmentFromName(alignment)
	local anchorXY = alignments[string.lower(alignment)]
	if anchorXY then
		local obj = self.obj
		obj.anchorX = anchorXY[1]
		obj.anchorY = anchorXY[2]
	else
		runtime.warning("Unknown alignment", alignment)
	end
end


---------------- Colors ------------------------------------------------------

-- Map color names to a 3 element array with 255-based r, g, b values.
local colors = {
    ["black"] =          { 0, 0, 0 },
    ["white"] =          {255, 255, 255},
    ["red"] =            {255, 0, 0},
    ["green"] =          {0, 255, 0},
    ["blue"] =           {0, 0, 255},
    ["cyan"] =           {0, 255, 255},
    ["magenta"] =        {255, 0, 255},
    ["yellow"] =         {255, 255, 0},
         
    ["gray"] =           {127, 127, 127},
    ["orange"] =         {255, 127, 0},
    ["pink"] =           {255, 192, 203},
    ["purple"] =         {64, 0, 127},
         
    ["light gray"] =     {191, 191, 191},
    ["light red"] =      {255, 127, 127},
    ["light green"] =    {127, 255, 127},
    ["light blue"] =     {127, 127, 255},
    ["light cyan"] =     {127, 255, 255},
    ["light magenta"] =  {255, 127, 255},
    ["light yellow"] =   {255, 255, 127},

    ["dark gray"] =      {64, 64, 64},
    ["dark red"] =       {127, 0, 0},
    ["dark green"] =     {0, 127, 0},
    ["dark blue"] =      {0, 0, 127},
    ["dark cyan"] =      {0, 127, 127},
    ["dark magenta"] =   {127, 0, 127},
    ["dark yellow"] =    {127, 127, 0},
}

-- Return the color (3-array) for the given color name, or gray if name not known.
-- Return nil if colorName is nil.
local function colorFromName(colorName)
	if colorName == nil then
		return nil
	end
	local color = colors[string.lower(colorName)]
	if color then
		return color
	end
	runtime.warning("Unknown color name", colorName)
	return colors["gray"]
end

-- Set a GameObj's fill color from a color 3-array (nil for none)
function GameObj:setFillColorFromColor(color)
	self.fillColor = color
	local obj = self.obj
	if obj.setFillColor then  -- lines don't have a setFillColor method
		if color then
			obj:setFillColor(
					g.pinValue(color[1], 0, 255) / 255, 
					g.pinValue(color[2], 0, 255) / 255, 
					g.pinValue(color[3], 0, 255) / 255)
		else
			obj:setFillColor(0, 0, 0, 0)   -- alpha 0 makes transparent fill
		end
	end
end

-- Set a GameObj's line color from a color 3-array (nil for none)
function GameObj:setLineColorFromColor(color)
	self.lineColor = color
	local obj = self.obj
	if color then
		obj:setStrokeColor(
				g.pinValue(color[1], 0, 255) / 255, 
				g.pinValue(color[2], 0, 255) / 255, 
				g.pinValue(color[3], 0, 255) / 255)
		obj.strokeWidth = self.lineWidth
	else
		obj.strokeWidth = 0
	end
end

-- Set a GameObj's fill color from a color name
function GameObj:setFillColorFromName(colorName)
	self:setFillColorFromColor(colorFromName(colorName))
end

-- Set a GameObj's line color from a color name
function GameObj:setLineColorFromName(colorName)
	self:setLineColorFromColor(colorFromName(colorName))
end


---------- Public GameObj APIs -----------------------------------------------

-- API
function GameObj:getType()
	return self.typeName
end

-- API
function GameObj:getWidth()
	return self.width
end

-- API
function GameObj:getHeight()
	return self.height
end

-- API
function GameObj:setSize(width, height)
	self:updateSize(forceNotNegative(width), forceNotNegative(height), g.scale)
end

-- API
function GameObj:getText()
	return self.text
end

-- API
function GameObj:setText(text)
	self.text = text
	self.obj.text = text
	-- TODO: Re-measure text
end

-- API
function GameObj:toString()
	-- e.g. [text at (30, 20) "Game Over"]
	local s = "[" .. self.typeName .. " at (" .. 
			math.round(self.x) .. ", " .. math.round(self.y) .. ")"
	if self.text then
		s = s .. " \"" .. self.text .. "\""
	end
	return s .. "]"
end

-- API
function GameObj:align(alignment)
	self:setAlignmentFromName(alignment or "center")
end

-- API
function GameObj:setFillColor(colorName)
	self:setFillColorFromName(colorName)
end

-- API
function GameObj:setFillColorRGB(red, green, blue)
	self:setFillColorFromColor({red, green, blue})
end

-- API
function GameObj:setLineColor(colorName)
	self:setLineColorFromName(colorName)
end

-- API
function GameObj:setLineColorRGB(red, green, blue)
	self:setLineColorFromColor({red, green, blue})
end

-- API
function GameObj:setLineWidth(lineWidth)
	self.lineWidth = lineWidth
	self:setLineColorFromColor(self.lineColor)    -- sets obj.strokeWidth
end

-- API
function GameObj:getLayer()
	return self.layer
end

-- API
function GameObj:setLayer(layer)
	-- Change the stored layer number
	self.layer = layer

	-- Re-insert the display object at the top the layer
	local obj = self.obj
	local objs = obj.parent
	local i = objs.numChildren
	while i > 0 do
		local gameObj = objs[i].code12GameObj
		if gameObj and gameObj ~= self and gameObj.layer <= layer then
			break
		end
		i = i - 1
	end
	objs:insert(i + 1, obj)
end

-- API
function GameObj:delete()
	self:removeAndDelete()
end

-- API
function GameObj:clicked()
	return (g.gameObjClicked == self)
end

-- API
function GameObj:containsPoint(x, y)
	return self:objContainsPoint(x, y)
end

-- API
function GameObj:hit(gameObj)
	-- Make sure object is valid and visible first
	if gameObj == nil then
		return false
	elseif gameObj.deleted then
		runtime.warning("Attempt to test for hit with a deleted object")
		return false
	elseif self.deleted then
		runtime.warning("Attempt to call hit method on a deleted object")
		return false
	elseif not gameObj.visible then
		return false
	end
	return self:hitObj(gameObj)
end

-- API
function GameObj:objectHitInGroup(group)
	-- Hit test the matching objects
	local objs = g.screen.objs
	for i = 1, objs.numChildren do
		local gObj = objs[i].code12GameObj
		if gObj ~= self and (group == nil or gObj.group == group) then
			if self:hit(gObj) then
				return gObj
			end
		end
	end
	return nil
end


------------------------------------------------------------------------------

-- Init and return the GameObj class
initGameObjClass()
return GameObj
