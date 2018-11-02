package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

board = {{}, {}, {}, {}, {}, {}, {}, {}}
pieces, oppPieces = {}, {}
isPlayerTurn = nil

-- local Piece = {}
-- Piece Methods -------------------------------------------------------------

function newPiece(t, i, j, c)
    local p = {
        t = t,
        i = i,
        j = j,
        gameObj = getGameImage(type, i, j, c),
        possibleMoves = {},
        move = move,
        delete = delete,
    }
    return p
end

function newPawn(i, j, c)
    local p = newPiece("pawn", i, j, c)
    p.isFirstMove = true
    p.hasReachedEnd = false
    p.updatePossibleMoves = updatePossibleMovesPawn()
    return p
end

function newRook(i, j, c)
    local r = newPiece("rook", i, j, c)
    r.updatePossibleMoves = updatePossibleMovesRook()
    return r
end

function newKnight(i, j, c)
    local k = newPiece("knight", i, j, c)
    k.updatePossibleMoves = updatePossibleMovesKnight()
    return k
end

function newBishop(i, j, c)
    local b = newPiece("bishop", i, j, c)
    b.updatePossibleMoves = updatePossibleMovesBishop()
    return b
end

function newQueen(i, j, c)
    local q = newPiece("queen", i, j, c)
    q.updatePossibleMoves = updatePossibleMovesQueen()
    return q
end

function newKing(i, j, c)
    local k = newPiece("king", i, j, c)
    k.updatePossibleMoves = updatePossibleMovesKing()
    return k
end

function move(obj, i, j)
    obj.i, obj.j = i, j
    obj.gameObj.x, obj.gameObj.y = getCoords()
    --ct.logm("message", self)
    obj:updatePossibleMoves()
end

--TODO: implement en passant and promotion
function updatePossibleMovesPawn(obj)
    --normal move
    if not isPieceAt(obj.i - 1, obj.j) then
        obj.possibleMoves[#obj.possibleMoves + 1] = {obj.i - 1, obj.j}
        --double move
        if not isPieceAt(obj.i - 2, obj.j) and obj.isFirstMove then
            obj.possibleMoves[#obj.possibleMoves + 1] = {obj.i - 2, obj.j}
            obj.isFirstMove = false
        end
    end
    --diagonal capture left
    if obj.j - 1 >= 1 and isEnemyAt(obj.i - 1, obj.j - 1) then
        obj.possibleMoves[#obj.possibleMoves + 1] = {obj.i - 1, obj.j - 1}
    end
    --diagonal capture right
    if obj.j + 1 <= 8 and isEnemyAt(obj.i - 1, obj.j + 1) then
        obj.possibleMoves[#obj.possibleMoves + 1] = {obj.i - 1, obj.j + 1}
    end
end

--TODO: implement castling, but prevent queen from doing so
function updatePossibleMovesRook(obj)
    --up, down
    for i, s in ipairs{-1, 1} do
        for k = 1, #board - 1 do
            local i = obj.i + s * k
            if not isInRange(i, 1) and isAllyAt(i, obj.j) then
                break
            end
            obj.possibleMoves[#obj.possibleMoves + 1] = {i, obj.j}
            if isEnemyAt(i, obj.j) then
                break
            end
        end
    end
    --right, left
    for i, s in ipairs{-1, 1} do
        for k = 1, #board - 1 do
            local j = obj.j + s * k
            if obj.j + s * k > 8 and isAllyAt(obj.i, j) then
                break
            end
            obj.possibleMoves[#obj.possibleMoves + 1] = {obj.i, j}
            if isEnemyAt(obj.i, j) then
                break
            end
        end
    end
end

function updatePossibleMovesKnight(obj)
    for m, di in ipairs{-2, -1, 1, 2} do
        for n, dj in ipairs{-2, -1, 1, 2} do
            local i, j = obj.i + di, obj.j + dj
            if math.abs(di) ~= math.abs(dj) and isInRange(i, j) and (isEnemyAt(i, j) or not isAllyAt(i, j)) then
               obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            end
        end
    end
end

function updatePossibleMovesBishop(obj)
    -- down left, down right, up right, up left
    for m, v in ipairs{{1, 1}, {1, -1}, {-1, -1}, {-1, 1}} do
        for k = 1, #board - 1 do
            local i, j = obj.i + v[1] * k, obj.j + v[2] * k
            if i <= 1 and i >= 8 and j <= 1 and j >= 8 or isAllyAt(i, j) then
                break
            end
            obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            if isEnemyAt(i, j) then
                break
            end
        end
    end
end

function updatePossibleMovesQueen(obj)
    obj:updatePossibleMovesRook()
    obj:updatePossibleMovesBishop()
end

function updatePossibleMovesKing(obj)
    for i = obj.i - 1, obj.i + 1 do
        for j = obj.j - 1, obj.j + 1 do
            if isInRange(i, j) and not isAllyAt(i, j) then
                obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            end
        end
    end
end

function delete(obj)
end

-- Main Functions ------------------------------------------------------------

function start()
    startGame()
    --TODO bug: print() does not work without println()
    for i, v in ipairs(pieces) do
        --ct.println(type(v[1]))
        --ct.println("(" .. v[1] .. " " .. v[2] .. ") ")
        --ct.println(i)
        pieces[i]:updatePossibleMoves()
    end
end

function update()
end

function onMouseDrag(obj, x, y)
    obj.x, obj.y = x, y
end

function onMouseRelease(obj, x, y)
    local n = getPieceIndex(obj)
    local i, j = getIndex(x, y)
    for k, v in ipairs(pieces[n].possibleMoves) do
        ct.println("(" .. v[1] .. " " .. v[2] .. ") ")
        if v == {i, j} then
            pieces[n].i, pieces[n].j = i, j
            pieces[n].gameObj.x, pieces[n].gameObj.y = getCoords(i, j)
            break
        end
        pieces[n].gameObj.x, pieces[n].gameObj.y = getCoords(pieces[n].i, pieces[n].j)
    end

end

function createBoard()
    for i = 1, 8 do
        for j = 1, 8 do
            local color
            if i % 2 == j % 2 then
                color = "white"
            else
                color = "dark gray"
            end
            local x, y = getCoords(i, j)
            board[i][j] = ct.rect(x, y, 10, 10, color)
        end
    end
end

function startGame()
    createBoard()
    pieces = setupPieces(7, 8, "w")
    oppPieces = setupPieces(2, 1, "b")
end

function setupPieces(p, k, c)
    local newPieces = {}
    for i, f in ipairs{newRook, newKnight, newBishop, newQueen, newKing, newBishop, newKnight, newRook} do
        ct.println(type(f))
        pieces[i] = newPawn(p, i, c)
        pieces[i + #board] = f(k, i, c)
    end
    return pieces
end

-- Helper Functions ----------------------------------------------------------

function getPieceIndex(gameObj)
    for k = 1, #pieces do
        if gameObj == pieces[k].gameObj then
            return k
        end
    end
end

function getGameImage(type, i, j, c)
    local x, y = getCoords(i, j)
    return ct.image(c .. "_" .. type .. ".png", x, y, 8)
end

--TODO: use this
function isInRange(i, j)
    return i >= 1 and i <= #board and j >= 1 and j <= #board
end

function getCoords(i, j)
    return 10 * j, 10 * i
end

function getIndex(x, y)
    return math.floor(y / 10) + 1, math.floor(x / 10) + 1
end

function isPieceAt(i, j)
    return isAllyAt(i, j) or isEnemyAt(i, j)
end

function isAllyAt(i, j)
    for k = 1, #pieces do
        if pieces[k].i == i and pieces[k].j == j then
            return true
        end
    end
end

function isEnemyAt(i, j)
    for k = 1, #oppPieces do
        if oppPieces[k].i == i and oppPieces[k].j == j then
            return true
        end
    end
end

require('Code12.api')
require('Code12.runtime').run()
