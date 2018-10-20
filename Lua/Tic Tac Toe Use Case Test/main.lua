package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

this.board = {{nil, nil, nil},
              {nil, nil, nil},
              {nil, nil, nil}}
this.results = nil
this.isPlayerTurn = true
this.time = 0

function _fn.start()
    ct.line(10, ct.getHeight() / 3, ct.getWidth() - 10, ct.getHeight() / 3, "light blue")
    ct.line(10, ct.getHeight() * 2 / 3, ct.getWidth() - 10, ct.getHeight() * 2 / 3, "light blue")
    ct.line(ct.getWidth() / 3, 25, ct.getWidth() / 3, ct.getHeight() - 25, "light blue")
    ct.line(ct.getWidth() * 2 / 3, 25, ct.getWidth() * 2 / 3, ct.getHeight() - 25, "light blue")
end

function _fn.update()
    local winner = _fn.getWinner()
    if winner then
       this.results = ct.text(winner .. " Won", ct.getWidth() / 2, ct.getHeight() / 2, 15)
    elseif _fn.isTie() then
       this.results = ct.text("Tie Game", ct.getWidth() / 2, ct.getHeight() / 2, 15)
    end

    if not this.isPlayerTurn and not this.results and ct.getTimer() - this.time > 400 then
        local i, j
        while true do
            i, j = ct.random(1, #this.board), ct.random(1, #this.board)
            if not this.board[i][j] then
                break
            end
            ct.println("loopin")
        end
        local x1, y1 = _fn.getCoord(i, j)
        this.board[i][j] = ct.text("X", x1, y1, 10, "light red")
        this.board[i][j].group = "Computer"
        this.isPlayerTurn = true
    end
end

function _fn.onMouseRelease(obj, x, y)
    if this.isPlayerTurn then
        local i, j = _fn.getIndex(x, y)
        if not this.board[i][j] then
            local x1, y1 = _fn.getCoord(i, j)
            this.board[i][j] = ct.text("O", x1, y1, 10, "light blue")
            this.board[i][j].group = "Player"
            this.time = ct.getTimer()
            this.isPlayerTurn = nil
        end
    end
end

function _fn.getWinner()
    for i = 1, #this.board do
        local a, b, c = this.board[i][1], this.board[i][2], this.board[i][3]
        if a and b and c and a.group == b.group and a.group == c.group then
            return a.group
        end
        local d, e, f = this.board[1][i], this.board[2][i], this.board[3][i]
        if d and e and f and d.group == e.group and d.group == f.group then
            return d.group
        end
    end
    local g, h, i = this.board[1][1], this.board[2][2], this.board[3][3]
    if g and h and i and g.group == h.group and g.group == i.group then
        return g.group
    end
    local j, k, l = this.board[3][1], this.board[2][2], this.board[1][3]
    if j and k and l and j.group == k.group and j.group == l.group then
        return j.group
    end
end

function _fn.isTie()
    for i = 1, #this.board do
        for j = 1, #this.board do
            if not this.board[i][j] then
                return false
            end
        end
    end
    return not this.isPlayerTurn
end

function _fn.getIndex(x, y)
    local i, j = 1, 1
    for k = 1, #this.board do
        if y > ct.getHeight() * (k - 1) / 3 then
            i = k
        end
        if x > ct.getWidth() * (k - 1) / 3 then
            j = k
        end
    end
    return i, j
end

function _fn.getCoord(i, j)
    return ct.getWidth() * j / 4, ct.getHeight() * i / 4
end

require('Code12.api')
require('Code12.runtime').run()
