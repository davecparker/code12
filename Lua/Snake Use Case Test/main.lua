package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

this.snake = nil
this.food = nil
this.prevCharTyped = "w"
this.charTyped = "a"
this.time = nil

function _fn.start()
    ct.setBackColor("dark gray")
    this.snake = {ct.rect(47.5, 47.5, 5, 5, "light red"), ct.rect(52.5, 47.5, 5, 5, "light red")}
    this.snake[1]:setLineColor("white")
    this.snake[2]:setLineColor("white")
    this.food = ct.circle(17.5, 47.5, 5, "white")
    this.food:setLayer(0)
    this.time = ct.getTimer()
end

function _fn.update()
    if ct.getTimer() - this.time >= 150 then
        this.time = ct.getTimer()
        _fn.moveSnake()
        if _fn.isSnakeDead() then
            ct.showAlert("You Lost")
        end
        if this.snake[1].x == this.food.x and this.snake[1].y == this.food.y then
            _fn.snakeEatsFood()
        end
    end
end

function _fn.moveSnake()
    _fn.moveSnakeBody()
    _fn.moveSnakeHead()
    this.prevCharTyped = this.charTyped
end

function _fn.moveSnakeBody()
    local i = #this.snake
    while i >= 2 do
        this.snake[i].x, this.snake[i].y = this.snake[i - 1].x, this.snake[i - 1].y
        i = i - 1
    end
end

function _fn.moveSnakeHead()
    if this.charTyped == "a" then
        this.snake[1].x = this.snake[1].x - 5
    elseif this.charTyped == "d" then
        this.snake[1].x = this.snake[1].x + 5
    elseif this.charTyped == "w" then
        this.snake[1].y = this.snake[1].y - 5
    elseif this.charTyped == "s" then
        this.snake[1].y = this.snake[1].y + 5
    end
end

function _fn.isSnakeDead()
    if this.snake[1].x <= 0 or this.snake[1].x >= ct.getWidth() or this.snake[1].y <= 0 or this.snake[1].y >= ct.getHeight() then
        return true
    end
    for i = 5, #this.snake do
        if this.snake[1].x == this.snake[i].x and this.snake[1].y == this.snake[i].y then
            return true
        end
    end
    return false
end

function _fn.snakeEatsFood()
    this.food.x, this.food.y = ct.random(0, ct.getWidth() / 5 - 1) * 5 + 2.5, ct.random(0, ct.getHeight() / 5 - 1) * 5 + 2.5
    local s = this.snake[#this.snake]
    this.snake[#this.snake + 1] = ct.rect(s.x, s.y, 5, 5, "light red")
    this.snake[#this.snake]:setLineColor("white")
end

function _fn.onCharTyped(c)
    if (c == "a" or c == "d") and (this.prevCharTyped == "w" or this.prevCharTyped == "s") or
    (c == "w" or c == "s") and (this.prevCharTyped == "a" or this.prevCharTyped == "d") then
        this.charTyped = c
    end
end

require('Code12.api')
require('Code12.runtime').run()
