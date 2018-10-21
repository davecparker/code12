package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()


this.doubleArr = nil
this.gObj = nil
this.intArr = nil
this.intArr1 = { 1, 2, 3, 4, 5, length = 5 }
this.intArr2 = { 5, 10, 15, length = 3 }

function _fn.start()

	this.gObj = nil
end

function _fn.update()

	local len = this.intArr1.length
	local i = 0; while i < len do
		ct.checkArrayIndex(this.intArr1, i); this.intArr1[1+(i)] = ct.indexArray(this.intArr1, i) + 1; i = i + 1
	end; len = this.intArr2.length
	local i = 0; while i < len do
		ct.checkArrayIndex(this.intArr2, i); this.intArr2[1+(i)] = ct.indexArray(this.intArr2, i) + 1; i = i + 1
	end; end

function _fn.onKeyPress(keyName)

	if (keyName == "1") then
		this.intArr = this.intArr1
	elseif (keyName == "2") then
		this.intArr = this.intArr2
	elseif (keyName == "3") then
		this.doubleArr = { length = 10, default = 0 }
	elseif (keyName == "g") then

		if this.gObj == nil then

			this.gObj = ct.rect(5, 10, 10, 10)
			this.gObj.xSpeed = 0.1
		else


			this.gObj:delete()
			this.gObj = nil; end
	end

end

require('Code12.api')
require('Code12.runtime').run()
