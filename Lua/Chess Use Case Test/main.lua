package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

board = {{}, {}, {}, {}, {}, {}, {}, {}}
pieces, oppPieces = {}, {}
isPlayerTurn = nil
tileLength = 12

-- Piece Methods -------------------------------------------------------------

function newPiece(t, i, j, c)
    local p = {
        t = t,
        i = i,
        j = j,
        gameObj = getGameImage(t, i, j, c),
        possibleMoves = {},
        move = move,
        delete = delete,
    }
    return p
end

-- TODO: add variable indicating direction pawns are heading
function newPawn(i, j, c)
    local p = newPiece("pawn", i, j, c)
    p.dir = -1
    if c == "b" then
        p.dir = 1
    end
    p.isFirstMove = true
    p.hasReachedEnd = false
    p.updatePossibleMoves = updatePossibleMovesPawn
    return p
end

function newRook(i, j, c)
    local r = newPiece("rook", i, j, c)
    r.updatePossibleMoves = updatePossibleMovesRook
    return r
end

function newKnight(i, j, c)
    local k = newPiece("knight", i, j, c)
    k.updatePossibleMoves = updatePossibleMovesKnight
    return k
end

function newBishop(i, j, c)
    local b = newPiece("bishop", i, j, c)
    b.updatePossibleMoves = updatePossibleMovesBishop
    return b
end

function newQueen(i, j, c)
    local q = newPiece("queen", i, j, c)
    q.updatePossibleMoves = updatePossibleMovesQueen
    return q
end

function newKing(i, j, c)
    local k = newPiece("king", i, j, c)
    k.updatePossibleMoves = updatePossibleMovesKing
    return k
end

function move(obj, i, j)
    obj.i, obj.j = i, j
    obj.gameObj.x, obj.gameObj.y = getCoords(i, j)
    --ct.logm("message", self)
    obj:updatePossibleMoves()
end

--TODO: implement en passant and promotion -> (make sure to toggle hasReachedEnd)
function updatePossibleMovesPawn(obj)
    --normal move
    obj.possibleMoves = {}
    if not isPieceAt(obj.i + obj.dir, obj.j) then
        obj.possibleMoves[1] = {obj.i + obj.dir, obj.j}
        --double move
        if not isPieceAt(obj.i + obj.dir * 2, obj.j) and obj.isFirstMove then
            obj.possibleMoves[2] = {obj.i + obj.dir * 2, obj.j}
            obj.isFirstMove = false
        end
    end
    --diagonal capture left
    if obj.j - 1 >= 1 and isEnemyAt(obj.i + obj.dir, obj.j - 1) then
        obj.possibleMoves[#obj.possibleMoves + 1] = {obj.i + obj.dir, obj.j - 1}
    end
    --diagonal capture right
    if obj.j + 1 <= 8 and isEnemyAt(obj.i + obj.dir, obj.j + 1) then
        obj.possibleMoves[#obj.possibleMoves + 1] = {obj.i + obj.dir, obj.j + 1}
    end
end

--TODO: implement castling, but prevent queen from doing so
function updatePossibleMovesRook(obj)
    obj.possibleMoves = {}
    --up, down
    for i, s in ipairs{-1, 1} do
        for k = 1, #board - 1 do
            local i = obj.i + s * k
            --ct.print(i .. " ")
            if not isInRange(i, obj.j) or isAllyAt(i, obj.j) then
                --ct.print(i .. " ")
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
            if not isInRange(obj.i, j) and isAllyAt(obj.i, j) then
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
    obj.possibleMoves = {}
    for m, di in ipairs{-2, -1, 1, 2} do
        for n, dj in ipairs{-2, -1, 1, 2} do
            local i, j = obj.i + di, obj.j + dj
            if math.abs(di) ~= math.abs(dj) and isInRange(i, j) and (isEnemyAt(i, j) or not isPieceAt(i, j)) then
               obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            end
        end
    end
end

function updatePossibleMovesBishop(obj)
    obj.possibleMoves = {}
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

-- TODO: create independent function
function updatePossibleMovesQueen(obj)
    updatePossibleMovesRook(obj)
    updatePossibleMovesBishop(obj)
end

function updatePossibleMovesKing(obj)
    obj.possibleMoves = {}
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

function _fn.start()
    startGame()

    --TODO bug: print() does not work without println()
end

function _fn.update()
    for i, v in ipairs(pieces) do
        pieces[i]:updatePossibleMoves()
    end
end

function onMouseDrag(obj, x, y)
    obj.x, obj.y = x, y
end

function _fn.onMouseRelease(obj, x, y)
    local k = getPieceIndex(obj)
    local i, j = getBoardIndex(x, y)
    if k then
        for m, v in ipairs(pieces[k].possibleMoves) do
            --ct.println("(" .. v[1] .. " " .. v[2] .. ") ")
            if v[1] == i and v[2] == j then
                pieces[k]:move(i, j)
                break
            end
            --pieces[k].gameObj.x, pieces[k].gameObj.y = getCoords(pieces[k].i, pieces[k].j)
        end
    end
end

function startGame()
    createBoard()
    pieces = setupPieces(7, 8, "w")
    oppPieces = setupPieces(2, 1, "b")
end

function createBoard()
    for i = 1, #board do
        for j = 1, #board do
            local x, y = getCoords(i, j)
            local color = "dark gray"
            if i % 2 == j % 2 then
                color = "white"
            end
            board[i][j] = ct.rect(x, y, tileLength, tileLength, color)
        end
    end
end

function setupPieces(p, k, c)
    local newPieces = {}
    for i, f in ipairs{newRook, newKnight, newBishop, newQueen, newKing, newBishop, newKnight, newRook} do
        newPieces[i] = newPawn(p, i, c)
        newPieces[i + #board] = f(k, i, c)
    end
    return newPieces
end

-- Helper Functions ----------------------------------------------------------

function getPieceIndex(obj)
    ct.println(obj)
    for k = 1, #pieces do
        if obj == pieces[k].gameObj then
            return k
        end
    end
end

function getGameImage(t, i, j, c)
    local x, y = getCoords(i, j)
    return ct.image(c .. "_" .. t .. ".png", x, y, 8)
end

function isInRange(i, j)
    return i >= 1 and i <= #board and j >= 1 and j <= #board
end

function getCoords(i, j)
    return tileLength * j - 4, tileLength * i
end

function getBoardIndex(x, y)
    if x < 2 or x > 98 or y < 6 or y > 102 then
        return nil
    end
    local i, j = 1, 1
    for k = 2, #board do
        if x > tileLength * (k - 1) + 2 then
            j = k
        end
        if y > tileLength * (k - 1) + 6 then
            i = k
        end
    end
    return i, j
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
