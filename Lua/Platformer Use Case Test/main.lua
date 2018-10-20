package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

this.player = nil
this.time = nil
this.steps = {}
this.isOnStep = nil

function _fn.start()
    ct.setBackColor("dark gray")
    this.player = ct.rect(50, 20, 5, 5, "white")
    this.player.ySpeed = 2
    this.time = ct.getTimer()
    for i = 1, 8 do
        this.steps[i] = ct.rect(50, -15 * i + 40, 100 - 100 / 9 * i, 2, "light blue")
        this.steps[i]:setLineColor("light blue")
        this.steps[i].ySpeed = 1
    end
end

function _fn.onCharTyped(c)
    if c == " " and this.isOnStep then
        this.player.ySpeed = -0.25
        this.isOnStep = nil
    end
end

function _fn.onKeyPress(c)
    if c == "a" then
        this.player.xSpeed = -2
    elseif c == "d" then
        this.player.xSpeed = 2
    elseif c == "s" then
        this.player.ySpeed = 2
    end
end

function _fn.onKeyRelease(c)
    if c == "a" or c == "d" then
        this.player.xSpeed = 0
    end
end

function _fn.update()
    if this.player.ySpeed < 2 then
        this.player.ySpeed = this.player.ySpeed + 0.005
    end

    if this.player.x + this.player.width / 2 < 0 then
        this.player.x = ct.getWidth() - 1 + this.player.width / 2
    elseif this.player.x - this.player.width / 2 > ct.getWidth() then
        this.player.x = 1 - this.player.width / 2
    end

    if this.player.y - this.player.height / 2 > ct.getHeight() then
        ct.showAlert("You Lost")
    end

    for i = 1, #this.steps do
        _fn.playerHitsStep(this.steps[i])
        _fn.stepAutoDelete(i)
    end
end

function _fn.playerHitsStep(s)
    if this.player:hit(s) and this.player.y + this.player.height / 2 < s.y then
        this.player.y = this.player.y - 0.25
        this.player.ySpeed = 1
        this.isOnStep = true
    end
end

function _fn.stepAutoDelete(i)
    if this.steps[i].y + this.steps[i].height / 2 > ct.getHeight() then
        this.steps[i]:delete()
        this.steps[i] = ct.rect(ct.random(3, 97), -1, ct.random(5, 30), 2, "light blue")
        this.steps[i]:setLineColor("light blue")
        this.steps[i].ySpeed = 1
    end
end

require('Code12.api')
require('Code12.runtime').run()
