package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()
-- Variables to keep track of hits and misses
this.hits = 0
this.misses = 0

function _fn.start()

	-- Make the background 
	ct.setBackImage("underwater.jpg")

	-- Pre-load the pop sound
	ct.loadSound("pop.wav")
end

function _fn.update()

	-- Make bubbles at random times, positions, and sizes
	if ct.random(1, 20) == 1 then

		local x = ct.random(0, 100)
		local y = ct.getHeight() + 25
		local size = ct.random(5, 20)
		local bubble = ct.image("bubble.png", x, y, size)
		bubble.ySpeed =  -1
		bubble.autoDelete = true
	end
end

function _fn.onMousePress(obj, x, y)

	-- Pop bubbles that get clicked, and count hits and misses
	if obj == nil then
		this.misses = this.misses + 1
	else

		obj:delete()
		ct.sound("pop.wav")
		this.hits = this.hits + 1
	end
	ct.println(tostring(this.hits) .. " hits, " .. tostring(this.misses) .. " misses")
end

require('Code12.api')
require('Code12.runtime').run()
