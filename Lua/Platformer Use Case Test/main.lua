package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

local player = nil
local time = nil
local steps = {}
local isOnStep = nil

function _fn.start()
    ct.setBackColor("dark gray")
    player = ct.rect(50, 20, 5, 5, "white")
    player.ySpeed = 2
    time = ct.getTimer()
    for i = 1, 8 do
        steps[i] = ct.rect(50, -15 * i + 40, 100 - 100 / 9 * i, 2, "light blue")
        steps[i]:setLineColor("light blue")
        steps[i].ySpeed = 1
    end
end

function _fn.onCharTyped(c)
    if c == " " and isOnStep then
        player.ySpeed = -0.25
        isOnStep = nil
    end
end

function _fn.onKeyPress(c)
    if c == "a" then
        player.xSpeed = -2
    elseif c == "d" then
        player.xSpeed = 2
    elseif c == "s" then
        player.ySpeed = 2
    end
end

function _fn.onKeyRelease(c)
    if c == "a" or c == "d" then
        player.xSpeed = 0
    end
end

function _fn.update()
    if player.ySpeed < 2 then
        player.ySpeed = player.ySpeed + 0.005
    end

    if player.x + player.width / 2 < 0 then
        player.x = ct.getWidth() - 1 + player.width / 2
    elseif player.x - player.width / 2 > ct.getWidth() then
        player.x = 1 - player.width / 2
    end

    if player.y - player.height / 2 > ct.getHeight() then
        ct.showAlert("You Lost")
    end

    for i = 1, #steps do
        playerHitsStep(steps[i])
        stepAutoDelete(i)
    end
end

function playerHitsStep(s)
    if player:hit(s) and player.y + player.height / 2 < s.y then
        player.y = player.y - 0.25
        player.ySpeed = 1
        isOnStep = true
    end
end

function stepAutoDelete(i)
    if steps[i].y + steps[i].height / 2 > ct.getHeight() then
        steps[i]:delete()
        steps[i] = ct.rect(ct.random(3, 97), -1, ct.random(5, 30), 2, "light blue")
        steps[i]:setLineColor("light blue")
        steps[i].ySpeed = 1
    end
end

require('Code12.api')
require('Code12.runtime').initAndRun()
