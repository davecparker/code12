package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

local snake = nil
local food = nil
local prevCharTyped = "w"
local charTyped = "a"
local time = nil

function _fn.start()
    ct.setBackColor("dark gray")
    snake = {ct.rect(47.5, 47.5, 5, 5, "light red"), ct.rect(52.5, 47.5, 5, 5, "light red")}
    snake[1]:setLineColor("white")
    snake[2]:setLineColor("white")
    food = ct.circle(17.5, 47.5, 5, "white")
    food:setLayer(0)
    time = ct.getTimer()
end

function _fn.update()
    if ct.getTimer() - time >= 150 then
        time = ct.getTimer()
        moveSnake()
        if isSnakeDead() then
            ct.showAlert("You Lost")
        end
        if snake[1].x == food.x and snake[1].y == food.y then
            snakeEatsFood()
        end
    end
end

function moveSnake()
    moveSnakeBody()
    moveSnakeHead()
    prevCharTyped = charTyped
end

function moveSnakeBody()
    for i = #snake, 2, -1 do
        snake[i].x, snake[i].y = snake[i - 1].x, snake[i - 1].y
    end
end

function moveSnakeHead()
    if charTyped == "a" then
        snake[1].x = snake[1].x - 5
    elseif charTyped == "d" then
        snake[1].x = snake[1].x + 5
    elseif charTyped == "w" then
        snake[1].y = snake[1].y - 5
    elseif charTyped == "s" then
        snake[1].y = snake[1].y + 5
    end
end

function isSnakeDead()
    if snake[1].x <= 0 or snake[1].x >= ct.getWidth() or snake[1].y <= 0 or snake[1].y >= ct.getHeight() then
        return true
    end
    for i = 5, #snake do
        if snake[1].x == snake[i].x and snake[1].y == snake[i].y then
            return true
        end
    end
    return false
end

function snakeEatsFood()
    food.x, food.y = ct.random(0, ct.getWidth() / 5 - 1) * 5 + 2.5, ct.random(0, ct.getHeight() / 5 - 1) * 5 + 2.5
    local s = snake[#snake]
    snake[#snake + 1] = ct.rect(s.x, s.y, 5, 5, "light red")
    snake[#snake]:setLineColor("white")
end

function _fn.onCharTyped(c)
    if (c == "a" or c == "d") and (prevCharTyped == "w" or prevCharTyped == "s") or
    (c == "w" or c == "s") and (prevCharTyped == "a" or prevCharTyped == "d") then
        charTyped = c
    end
end

require('Code12.api')
require('Code12.runtime').initAndRun()
