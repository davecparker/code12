package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()


this.intVarrrrrrrrrrrrrrrr = 0
this.dblVar = 0
this.boolVar = false
this.strVar = nil
this.doubleArr = { length = 0, default = 0 }
this.gObj = nil
this.intArr = nil
this.intArr1 = { 1, 2, 3, 4, 5, length = 5 }
this.intArr2 = { 5, 10, 15, length = 3 }
this.gObjArr = { length = 5, default = nil }
this.gObjArr1 = { length = 1, default = nil }
this.gObjArr2 = { length = 2, default = nil }

function _fn.start()

	this.gObj = nil
	local i = 1; while i < 100 do
		ct.println(i); i = i + 1
	end; ct.checkArrayIndex(this.gObjArr2, 0); this.gObjArr2[1+(0)] = ct.rect(50, 20, 30, 5)
	ct.checkArrayIndex(this.gObjArr1, 0); this.gObjArr1[1+(0)] = ct.text("gObjArr1[0]", 50, 20, 5)
end

function _fn.update()

	local len = this.intArr1.length
	local i = 0; while i < len do
		ct.checkArrayIndex(this.intArr1, i); this.intArr1[1+(i)] = ct.indexArray(this.intArr1, i) + 1; i = i + 1
	end; len = this.intArr2.length
	local i = 0; while i < len do
		ct.checkArrayIndex(this.intArr2, i); this.intArr2[1+(i)] = ct.indexArray(this.intArr2, i) + (5); i = i + 1
	end; if this.gObj ~= nil then

		this.gObj.width = this.gObj.width + (0.01)
		this.gObj.height = this.gObj.height + (0.01)
	end
end

function _fn.onKeyPress(keyName)

	if (keyName == "1") then

		this.intArr = this.intArr1
		this.gObjArr = this.gObjArr1
	elseif (keyName == "2") then


		this.intArr = this.intArr2
		this.gObjArr = this.gObjArr2
	elseif (keyName == "3") then

		this.doubleArr = { length = 10, default = 0 }
	elseif (keyName == "g") then

		if this.gObj == nil then

			this.gObj = ct.rect(5, 10, 10, 10)
			this.gObj.group = "rectangles"
			this.gObj.xSpeed = 0.1
			this.gObj.ySpeed = 0.1
		else


			this.gObj:delete()
			this.gObj = nil; end
	elseif (keyName == "a") then



		local len = this.gObjArr.length
		if ct.indexArray(this.gObjArr, 0) == nil then

			local i = 0; while i < len do

				ct.checkArrayIndex(this.gObjArr, i); this.gObjArr[1+(i)] = ct.circle(0, 10 * i, 10)
				ct.checkArrayIndex(this.gObjArr, i); this.gObjArr[1+(i)].group = "circles"
				ct.checkArrayIndex(this.gObjArr, i); this.gObjArr[1+(i)].xSpeed = ct.random(0, 10) / 100.0
				ct.checkArrayIndex(this.gObjArr, i); this.gObjArr[1+(i)].ySpeed = ct.random(0, 10) / 100.0; i = i + 1
			end
		else


			local i = 0; while i < len do

				if ct.indexArray(this.gObjArr, i) ~= nil then

					ct.indexArray(this.gObjArr, i):delete()
					ct.checkArrayIndex(this.gObjArr, i); this.gObjArr[1+(i)] = nil
				end; i = i + 1
			end; end

		if this.gObj == nil then

			this.gObj = ct.rect(5, 10, 10, 10)
			this.gObj.group = "rectangles"
		else   -- gObj.xSpeed = 0.1;



			this.gObj:delete()
			this.gObj = nil; end
	elseif (keyName == "d") then



		if ct.indexArray(this.gObjArr1, 0) ~= nil then

			ct.indexArray(this.gObjArr1, 0):delete()
			ct.checkArrayIndex(this.gObjArr1, 0); this.gObjArr1[1+(0)] = nil
		end
		if ct.indexArray(this.gObjArr2, 0) ~= nil then

			ct.indexArray(this.gObjArr2, 0):delete()
			ct.checkArrayIndex(this.gObjArr2, 0); this.gObjArr2[1+(0)] = nil
		end; end

end

require('Code12.api')
require('Code12.runtime').run()
