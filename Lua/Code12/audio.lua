-----------------------------------------------------------------------------------------
--
-- audio.lua
--
-- Implementation of the audio APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")


-- Data for this module
local sounds = {}           -- Cached loaded sounds, indexed by filename
local soundVolume = 1.0     -- Sound volume from 0.0 to 1.0


---------------- Audio API ---------------------------------------------

-- API
function ct.sound(filename, ...)
	-- Check parameters
	if g.checkAPIParams("ct.sound") then
		g.check1Param("string", filename, ...)
	end

	-- Is this sound already loaded?
	local sound = sounds[filename]
	if sound == nil then
		-- Load it from app context working directory if any, else current dir. 
		local path = filename
		if ct._appContext and ct._appContext.sourceDir then
			path = ct._appContext.sourceDir .. filename
		end
		sound = audio.loadSound(path)
		if sound then 
			sounds[filename] = sound   -- cache it
		else
			g.warning("Cannot find sound file", filename)
		end
	end

	-- Play sound if successfully loaded
	if sound then
		-- Find an available channel, set the volume, and play it
		local channel = audio.findFreeChannel()
		if channel then
			local options = { channel = channel }
			audio.setVolume(soundVolume, options)
			audio.play(sound, options)
		end
	end
end

-- API
function ct.setSoundVolume(volume, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setSoundVolume") then
		g.check1Param("number", volume, ...)
	end

	-- Set sound volume for future audio
	soundVolume = volume
end

