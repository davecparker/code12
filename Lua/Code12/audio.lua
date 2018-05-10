-----------------------------------------------------------------------------------------
--
-- audio.lua
--
-- Implementation of the audio APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
local ct = require("Code12.runtime")


-- Data for this module
local CODE12_SOUND_PATH = "Code12/sounds/"   -- path to built-in sounds relative to project
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
		-- Try to load from project folder first, else Code12 sounds folder
		-- Finally, check to see if the Code12 folder is in the parent folder.
		sound = audio.loadSound(filename)  -- Corona prints warnings if not found :(
		if not sound then 
			sound = audio.loadSound(CODE12_SOUND_PATH .. filename)
			if not sound then 
				sound = audio.loadSound("../" .. CODE12_SOUND_PATH .. filename)
			end
		end
		sounds[filename] = sound   -- cache it if found
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

