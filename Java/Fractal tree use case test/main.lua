package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()



this.thetaSlider = nil; this.branchLengthSlider = nil
this.playerTheta = 0; this.prevPlayerTheta = 0; this.referanceTheta = 0; this.playerBranchLength = 0; this.prevPlayerBranchLength = 0; this.referanceBranchLength = 0; this.randomTheta = 0; this.randomBranchLength = 0; this.thetaIncrement = 0; this.branchLengthIncrement = 0
this.beginLevelTransition = false; this.endLevelTransition = false






function _fn.start()

	ct.setBackColor("dark gray")
	ct.line(12.5, 5, 87.5, 5, "white")
	this.thetaSlider = ct.circle(87.5, 5, 2, "white")
	this.thetaSlider:setLineColor("white")
	ct.line(12.5, 9, 87.5, 9, "white")
	this.branchLengthSlider = ct.circle(12.5, 9, 2, "white")
	this.branchLengthSlider:setLineColor("white")

	this.playerTheta = math.pi
	this.prevPlayerTheta = math.pi
	this.referanceTheta = math.pi
	this.playerBranchLength = 0
	this.prevPlayerBranchLength = 0
	this.referanceBranchLength = 0
	this.randomTheta = math.pi * (ct.random(1, 99) * 0.01)
	this.randomBranchLength = ct.random(180, 280) * 0.1
	this.thetaIncrement = 0.5
	this.branchLengthIncrement = 0.5
	this.beginLevelTransition = true
	this.endLevelTransition = false
end

function _fn.onMouseDrag(obj, x, y)

	if (obj == this.thetaSlider or obj == this.branchLengthSlider) and  not this.beginLevelTransition and  not this.endLevelTransition then
		_fn.updateSlider(obj, x)
	end; end

function _fn.onCharTyped(ch)

	if  not this.beginLevelTransition and  not this.endLevelTransition then

		if this.thetaSlider.x <= 12.5 or this.thetaSlider.x >= 87.5 then
			this.thetaIncrement = this.thetaIncrement * ( -1)
		end; if this.branchLengthSlider.x <= 12.5 or this.branchLengthSlider.x >= 87.5 then
			this.branchLengthIncrement = this.branchLengthIncrement * ( -1)
		end; _fn.updateSlider(this.thetaSlider, this.thetaSlider.x + this.thetaIncrement)
		_fn.updateSlider(this.branchLengthSlider, this.branchLengthSlider.x + this.branchLengthIncrement)
	end
end

function _fn.update()

	_fn.updatePlayerTree()
	if this.beginLevelTransition then
		_fn.beginLevel()
	elseif this.endLevelTransition then
		_fn.endLevel()
	elseif _fn.hasPlayerWon() then

		ct.clearGroup("referance branches")
		this.randomTheta = math.pi * (ct.random(1, 99) * 0.01)
		this.randomBranchLength = ct.random(180, 280) * 0.1
		this.endLevelTransition = true
	end
end

function _fn.beginLevel()

	ct.clearGroup("referance branches")
	if this.referanceTheta > this.randomTheta then
		this.referanceTheta = this.referanceTheta - (0.02)
	end; if this.referanceBranchLength < this.randomBranchLength then
		this.referanceBranchLength = this.referanceBranchLength + (0.3)
	end; if this.thetaSlider.x > 25 then
		_fn.updateSlider(this.thetaSlider, this.thetaSlider.x - 0.5)
	end; if this.referanceTheta <= this.randomTheta and this.referanceBranchLength >= this.randomBranchLength and this.thetaSlider.x <= 25 then
		this.beginLevelTransition = false
	end; _fn.updateReferanceTree()
end

function _fn.endLevel()

	_fn.updateSlider(this.thetaSlider, this.thetaSlider.x + 0.5)
	_fn.updateSlider(this.branchLengthSlider, this.branchLengthSlider.x - 0.5)
	if this.thetaSlider.x >= 87.5 and this.branchLengthSlider.x <= 12.5 then

		this.referanceTheta = math.pi
		this.referanceBranchLength = 10
		this.endLevelTransition = false
		this.beginLevelTransition = true
	end
end

function _fn.defineBranches(x1, y1, phi, branchLength, bundlesRemaining)

	local x2 = branchLength * math.cos(phi) + x1
	local y2 = y1 - branchLength * math.sin(phi)
	local branch = ct.line(x1, y1, x2, y2, "white")
	branch.group = "player branches"
	if bundlesRemaining > 0 then

		branchLength = branchLength / (1.45)
		bundlesRemaining = bundlesRemaining - 1
		_fn.defineBranches(x2, y2, phi + this.playerTheta, branchLength, bundlesRemaining)
		_fn.defineBranches(x2, y2, phi - this.playerTheta, branchLength, bundlesRemaining)
	end
end

function _fn.defineReferanceBranches(x1, y1, phi, branchLength, bundlesRemaining)

	local x2 = branchLength * math.cos(phi) + x1
	local y2 = y1 - branchLength * math.sin(phi)
	local branch = ct.line(x1, y1, x2, y2, "light blue")
	branch.group = "referance branches"
	branch:setLayer(0)
	if bundlesRemaining > 0 then

		branchLength = branchLength / (1.45)
		bundlesRemaining = bundlesRemaining - 1
		_fn.defineReferanceBranches(x2, y2, phi + this.referanceTheta, branchLength, bundlesRemaining)
		_fn.defineReferanceBranches(x2, y2, phi - this.referanceTheta, branchLength, bundlesRemaining)
	end
end

function _fn.updateSlider(slider, x)

	if x < 12.5 then
		slider.x = 12.5
	elseif x > 87.5 then
		slider.x = 87.5
	else
		slider.x = x
	end; end

function _fn.updatePlayerTree()

	this.playerTheta = math.pi / 6 * (0.08 * this.thetaSlider.x - 1)
	this.playerBranchLength = 1.0 / 3 * (0.8 * this.branchLengthSlider.x + 20)
	if this.playerTheta ~= this.prevPlayerTheta or this.playerBranchLength ~= this.prevPlayerBranchLength then

		this.prevPlayerTheta = this.playerTheta
		this.prevPlayerBranchLength = this.playerBranchLength
		ct.clearGroup("player branches")
		_fn.defineBranches(50, 100, math.pi / 2, this.playerBranchLength, 6)
	end
end

function _fn.updateReferanceTree()

	_fn.defineReferanceBranches(50, 100, math.pi / 2, this.referanceBranchLength, 6)
end

function _fn.hasPlayerWon()

	return this.playerTheta > this.referanceTheta - 0.01 and this.playerTheta < this.referanceTheta + 0.01 and this.playerBranchLength > this.referanceBranchLength - 0.3 and this.playerBranchLength < this.referanceBranchLength + 0.3
end

require('Code12.api')
require('Code12.runtime').run()
