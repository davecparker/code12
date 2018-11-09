package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

local constants = "F"
local rules = {
    F = "F+F-F-F+F",
}
local angle = math.pi / 2
local x1, y1
local button, buttonText

function _fn.start()
    ct.setBackColor("dark gray")
    button = ct.rect(10, 10, 10, 5, "light red")
    buttonText = ct.text("generate", 10, 10, 3, "white")
    x, y = 10, ct.getHeight()
end

function _fn.onMouseRelease(obj, x, y)
    if obj == button or obj == buttonText then
        ct.clearScreen()
        button = ct.rect(10, 10, 10, 5, "light red")
        buttonText = ct.text("generate", 10, 10, 3, "white")
        x1, y1 = 10, ct.getHeight()
        generate()
        show()
    end
end

function _fn.update()
end

function generate()
    local newConstants = ""
    for i = 1, string.len(constants) do
        local s = string.sub(constants, i, i)
        local c = rules[s]
        if c then
            newConstants = newConstants .. c
        else
            newConstants = newConstants .. s
        end
    end
    constants = newConstants
end

function show()
    for i = 1, string.len(constants) do
        local c = string.sub(constants, i, i)
        if c == "F" then
            local x2, y2 = x1 + 5 * math.cos(angle), y1 - 5 * math.sin(angle)
            ct.line(x1, y1, x2, y2, "white")
            x1, y1 = x2, y2
        elseif c == "+" then
            angle = angle - math.pi / 2
        elseif c == "-" then
            angle = angle + math.pi / 2
        end
    end
end

require('Code12.api')
require('Code12.runtime').run()
