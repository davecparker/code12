package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()
function _fn.start()

	ct.println("Hey")
	ct.setTitle("My Program")
	local c = ct.circle(50, 30, 10)
	c:align("back")
	ct.image("foo", 50, 70, 20)
	c:setFillColor("blue")
	ct.sound("hoy")
	ct.log(c)
end

require('Code12.api')
require('Code12.runtime').run()
