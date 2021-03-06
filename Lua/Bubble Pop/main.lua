-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

package.path = package.path .. ';../../Desktop/Code12/?.lua'
require("Code12.api")


function start()
	-- Make the background 
	ct.setHeight(150)
	ct.setBackImage("underwater.jpg")
end

function update()
	-- Make bubbles at random times, positions, and sizes
	if ct.random(1, 20) == 1 then
		local x = ct.random(0, 100)
		local y = ct.getHeight() + 25
		local size = ct.random(5, 20)
		local bubble = ct.image("bubble.png", x, y, size)
		bubble.ySpeed = -1
		bubble.clickable = true
	end
end

function onMousePress(obj, x, y)
	-- Pop bubbles that get clicked
	if obj then
		obj:delete()
		ct.sound("pop.wav")
	end
end


