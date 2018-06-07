-----------------------------------------------------------------------------------------
--
-- screens.lua
--
-- Implementation of the screen management APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")
local GameObj = require("Code12.GameObjAPI")


---------------- Screen Management API ---------------------------------------

-- API
function ct.setTitle(title, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setTitle") then
		g.check1Param("string", title, ...)
	end

	-- The window title only affects macOS and Windows
	native.setProperty("windowTitleText", title)
end

-- API
function ct.setHeight(height, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setHeight") then
		g.check1Param("number", height, ...)
	end

	-- Unfortunately a Corona desktop app cannot change the window size via software,
	-- and a Corona mobile app can't affect the screen size at all, so height here
	-- only determines whether we switch to landscape (only on mobile).

	-- Is the requested aspect landscape?
	if g.isMobile and height < g.WIDTH then
		-- Landscape
		g.window.horz = g.device.vert
		g.window.vert = g.device.horz
		g.mainGroup.rotation = 90
		g.mainGroup.x = g.device.horz.origin + g.device.horz.size
	else
		-- Portrait
		g.window.horz = g.device.horz
		g.window.vert = g.device.vert
		g.mainGroup.rotation = 0
		g.mainGroup.x = g.device.horz.origin
	end

	-- Compute new actual logical height
	g.height = g.WIDTH * g.window.vert.size / g.window.horz.size
	g.scale = g.window.horz.size / g.WIDTH
	g.window.resized = true
end

-- API
function ct.getWidth(...)
	-- Check parameters
	if g.checkAPIParams("ct.getWidth") then
		g.checkNoParams(...)
	end

	-- Return logical width
	return g.WIDTH
end

-- API
function ct.getHeight(...)
	-- Check parameters
	if g.checkAPIParams("ct.getHeight") then
		g.checkNoParams(...)
	end

	-- Return logical height
	return g.height
end

-- API
function ct.getPixelsPerUnit(...)
	-- Check parameters
	if g.checkAPIParams("ct.getPixelsPerUnit") then
		g.checkNoParams(...)
	end

	-- Return logical to pixel scale factor
	return g.scale
end

-- API
function ct.getScreen(...)
	-- Check parameters
	if g.checkAPIParams("ct.getScreen") then
		g.checkNoParams(...)
	end

	-- Return name of current screen
	return g.screen.name
end

-- API
function ct.setScreen(name, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setScreen") then
		g.check1Param("string", name, ...)
	end

	-- Hide old screen if any
	if g.screen then
		g.screen.group.isVisible = false;
	end

	-- Does this screen name already exist?
	local screen = g.screens[name]
	if screen then
		-- Switch to existing screen
		g.screen = screen
	else
		-- Create a new screen with its own display group
		screen = {
			name = name,
			group = display.newGroup(),
			objs = display.newGroup(),   -- layer above background obj
			backObj = nil,    -- background object, set below
		}
		g.mainGroup:insert(screen.group)
		screen.group:insert(screen.objs)
		g.screen = screen

		-- Add default white background
		ct.setBackColor("white")
	end

	-- Show new screen
	screen.group.isVisible = true;
end

-- API
function ct.clearScreen(...)
	-- Check parameters
	if g.checkAPIParams("ct.clearScreen") then
		g.checkNoParams(...)
	end

	-- Delete all objects in the screen group, from top down
	local screenGroup = g.screen.objs
	for i = screenGroup.numChildren, 1, -1 do
		screenGroup[i].code12GameObj:removeAndDelete()
	end
end

-- API
function ct.clearGroup(group, ...)
	-- Check parameters
	if g.checkAPIParams("ct.clearGroup") then
		g.check1Param("string", group, ...)
	end

	-- Delete objects with matching group name, from top down
	local screenGroup = g.screen.objs
	for i = screenGroup.numChildren, 1, -1 do
		local gameObj = screenGroup[i].code12GameObj
		if gameObj.group == group then
			gameObj:removeAndDelete()
		end
	end
end

-- API
function ct.setBackColor(colorName, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setBackColor") then
		g.check1Param("string", colorName, ...)
	end

	-- Delete previous background object if any
	local backObj = g.screen.backObj
	if backObj then
		backObj:delete()
		g.screen.backObj = nil
	end

	-- Make a rect big enough to cover the screen without needing to scale it
	backObj = GameObj:newRect(g.screen.group, 0, 0, 100000, 100000, colorName)
	backObj.updateBackObj = function (gameObj, scale) end

	-- Put the rect behind the objs layer in the screen group
	backObj._code12.obj:toBack()
	g.screen.backObj = backObj
end

-- API
function ct.setBackColorRGB(red, green, blue, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setBackColorRGB") then
		g.checkTypes({"number", "number", "number"}, red, green, blue, ...)
	end

	-- Make a default background rect first, then set its color
	ct.setBackColor("white")
	g.screen.backObj:setFillColorRGB(red, green, blue)
end

-- API
function ct.setBackImage(filename, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setBackImage") then
		g.check1Param("string", filename, ...)
	end

	-- Delete previous background object if any
	local backObj = g.screen.backObj
	if backObj then
		backObj:delete()
		g.screen.backObj = nil
	end

	-- Make an image object with temporary position and size for now
	backObj = GameObj:newImage(g.screen.group, filename, 0, 0, g.WIDTH)

	-- Install special update method to position and crop properly
	backObj.updateBackObj = 
			function (gameObj)
				local obj = gameObj._code12.obj
				local scale = g.scale

				-- Center it in the window
				obj.x = (g.WIDTH / 2) * scale
				obj.y = (g.height / 2) * scale

				-- Use as much of the image as possible while filling 
            	-- the window and retaining the image aspect ratio.
				local aspect = obj.width / obj.height
				if aspect > (g.WIDTH / g.height) then
					obj.width = g.height * aspect * scale
					obj.height = g.height * scale
				else
					obj.width = g.WIDTH * scale
					obj.height = (g.WIDTH / aspect) * scale
				end
			end

	-- Put the image behind the objs layer in the screen group
	backObj._code12.obj:toBack()
	g.screen.backObj = backObj
end

