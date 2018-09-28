package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()
function _fn.start()

	ct.println("Hey")
	ct.setTitle("My Program")
	--GameObj x = ct.setTitle("My Program");
	local c = ct.circle(50, 30, 10)
	if ct.clicked() then
		c:setFillColor("blue")
	end; math.sin(50)
end

require('Code12.api')
require('Code12.runtime').run()
