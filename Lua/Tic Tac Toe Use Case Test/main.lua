package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

local board = {{nil, nil, nil},
               {nil, nil, nil},
               {nil, nil, nil}}
local results = nil
local isPlayerTurn = true
local time = 0

function _fn.start()
    ct.line(10, ct.getHeight() / 3, ct.getWidth() - 10, ct.getHeight() / 3, "light blue")
    ct.line(10, ct.getHeight() * 2 / 3, ct.getWidth() - 10, ct.getHeight() * 2 / 3, "light blue")
    ct.line(ct.getWidth() / 3, 25, ct.getWidth() / 3, ct.getHeight() - 25, "light blue")
    ct.line(ct.getWidth() * 2 / 3, 25, ct.getWidth() * 2 / 3, ct.getHeight() - 25, "light blue")
end

function _fn.update()
    local winner = getWinner()
    if winner then
       results = ct.text(winner .. " Won", ct.getWidth() / 2, ct.getHeight() / 2, 15)
    elseif isTie() then
       results = ct.text("Tie Game", ct.getWidth() / 2, ct.getHeight() / 2, 15)
    end

    if not isPlayerTurn and not results and ct.getTimer() - time > 400 then
        local i, j
        while true do
            i, j = ct.random(1, #board), ct.random(1, #board)
            if not board[i][j] then
                break
            end
            ct.println("loopin")
        end
        local x1, y1 = getCoord(i, j)
        board[i][j] = ct.text("X", x1, y1, 10, "light red")
        board[i][j].group = "Computer"
        isPlayerTurn = true
    end
end

function _fn.onMouseRelease(obj, x, y)
    if isPlayerTurn then
        local i, j = getIndex(x, y)
        if not board[i][j] then
            local x1, y1 = getCoord(i, j)
            board[i][j] = ct.text("O", x1, y1, 10, "light blue")
            board[i][j].group = "Player"
            time = ct.getTimer()
            isPlayerTurn = false
        end
    end
end

function getWinner()
    for i = 1, #board do
        local a, b, c = board[i][1], board[i][2], board[i][3]
        if a and b and c and a.group == b.group and a.group == c.group then
            return a.group
        end
        local d, e, f = board[1][i], board[2][i], board[3][i]
        if d and e and f and d.group == e.group and d.group == f.group then
            return d.group
        end
    end
    local g, h, i = board[1][1], board[2][2], board[3][3]
    if g and h and i and g.group == h.group and g.group == i.group then
        return g.group
    end
    local j, k, l = board[3][1], board[2][2], board[1][3]
    if j and k and l and j.group == k.group and j.group == l.group then
        return j.group
    end
end

function isTie()
    for i = 1, #board do
        for j = 1, #board do
            if not board[i][j] then
                return false
            end
        end
    end
    return not isPlayerTurn
end

function getIndex(x, y)
    local i, j = 1, 1
    for k = 1, #board do
        if y > ct.getHeight() * (k - 1) / 3 then
            i = k
        end
        if x > ct.getWidth() * (k - 1) / 3 then
            j = k
        end
    end
    return i, j
end

function getCoord(i, j)
    return ct.getWidth() * j / 4, ct.getHeight() * i / 4
end

require('Code12.api')
require('Code12.runtime').initAndRun()
