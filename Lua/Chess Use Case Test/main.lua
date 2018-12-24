package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

local files = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}
local board = {{}, {}, {}, {}, {}, {}, {}, {}}
local pieces = {{}, {}}
local isPlayerTurn, isGameFinished
local pCaptured, oCaptured = 0, 0
local tileLength = 12
local time

-- Piece ---------------------------------------------------------------------

function newPiece(t, i, j, c)
    return {
        t = t,
        i = i,
        j = j,
        c = c,
        isWhite = c == 'w',
        gameObj = getGameImage(t, i, j, c),
        possibleMoves = {},
        move = move,
        capture = capture,
        delete = delete,
        sudoMove = sudoMove,
        undoMove = undoMove,
        isAllyAt = isAllyAt,
        isEnemyAt = isEnemyAt,
        isPossibleMove = isPossibleMove,
    }
end

function move(obj, i, j)
    colorBoard()
    colorMove(obj.i, obj.j, i, j)
    ct.logm(log(obj.i, obj.j, i, j), obj.gameObj)
    ct.sound("chess sound.wav")

    if obj:isEnemyAt(i, j) then
        getPieceAt(i, j):capture()
    end
    obj.i, obj.j = i, j
    obj.gameObj.x, obj.gameObj.y = getCoords(i, j)
    updateAllPossibleMoves()
    endingConditions()
end

function capture(obj)
    local gameObj = obj.gameObj
    gameObj:setSize(3, 3)
    if isPlayerPiece(obj) then
        pCaptured = pCaptured + 1
        gameObj.x, gameObj.y = 3 * pCaptured, 3
    else
        oCaptured = oCaptured + 1
        gameObj.x, gameObj.y = 3 * oCaptured, 108
    end
    obj:delete()
end

function delete(obj)
    local m, n = getPieceIndex(obj)
    for n = n, #pieces[m] do
        pieces[m][n] = pieces[m][n + 1]
    end
end

function sudoMove(obj, i, j)
    if obj:isEnemyAt(i, j) then
        local p = getPieceAt(i, j)
        p.ni, p.nj = p.i, p.j
        p.i, p.j = -1, -1
    end
    obj.ni, obj.nj = obj.i, obj.j
    obj.i, obj.j = i, j
    obj:updatePossibleMoves()
end

function undoMove(obj)
    obj.i, obj.j = obj.ni, obj.nj
    obj.ni, obj.nj = nil, nil
    if obj:isEnemyAt(-1, -1) then
        local p = getPieceAt(-1, -1)
        p.i, p.j = p.ni, p.nj
        p.ni, p.nj = nil, nil
    end
    obj:updatePossibleMoves()
end

function isAllyAt(obj, i, j)
    local piece = getPieceAt(i, j)
    if piece then
        return obj.isWhite == piece.isWhite
    end
end

function isEnemyAt(obj, i, j)
    local piece = getPieceAt(i, j)
    if piece then
        return obj.isWhite ~= piece.isWhite
    end
end

function isPossibleMove(obj, i, j)
    for k, v in ipairs(obj.possibleMoves) do
        if v[1] == i and v[2] == j then
            return true
        end
    end
end

-- Pawn Piece ----------------------------------------------------------------

function newPawn(i, j, c)
    local p = newPiece("pawn", i, j, c)
    p.dir = -1
    p.isFirstMove = true
    p.move = movePawn
    p.updatePossibleMoves = updatePossibleMovesPawn
    p.promotion = promotion
    if i == 2 then
        p.dir = 1
        p.promotion = oppPromotion
    end
    return p
end

function movePawn(obj, i, j)
    obj.isFirstMove = nil
    move(obj, i, j)
    if not isGameFinished and (obj.i == 1 or obj.i == 8) then
        local i, j = getPieceIndex(obj)
        obj:promotion()
        local t = getPieceName(pieces[i][j].t)
        ct.logm(j .. files[i] .. t, pieces[i][j].gameObj)
    end
end

function updatePossibleMovesPawn(obj)
    -- normal move
    local i = obj.i + obj.dir
    if not getPieceAt(i, obj.j) then
        obj.possibleMoves[1] = {i, obj.j}
        --double move
        if obj.isFirstMove and not getPieceAt(i + obj.dir, obj.j) then
            obj.possibleMoves[2] = {i + obj.dir, obj.j}
        end
    end
    -- diagonal capture
    for n, dj in ipairs{-1, 1} do
        if isInRange(i, obj.j + dj) and obj:isEnemyAt(i, obj.j + dj)  then
            obj.possibleMoves[#obj.possibleMoves + 1] = {i, obj.j + dj}
        end
    end
end

function promotion(obj)
    local m, n = getPieceIndex(obj)
    local promotedPiece = promotionPrompt()
    obj.gameObj:delete()
    pieces[m][n] = promotedPiece(obj.i, obj.j, obj.c)
    pieces[m][n]:updatePossibleMoves()
end

function oppPromotion(obj)
    obj.gameObj:delete()
    local m, n = getPieceIndex(obj)
    local promotedPieces = {newQueen, newBishop, newRook, newKnight}
    pieces[m][n] = promotedPieces[ct.random(1, 4)](obj.i, obj.j, obj.c)
end

-- Rook Piece ----------------------------------------------------------------

function newRook(i, j, c)
    local r = newPiece("rook", i, j, c)
    r.updatePossibleMoves = updatePossibleMovesRook
    return r
end

function updatePossibleMovesRook(obj)
    -- down, up, right, left
    for n, s in ipairs{{1, 0}, {-1, 0}, {0, -1}, {0, 1}} do
        for k = 1, #board - 1 do
            local i, j = obj.i + s[1] * k, obj.j + s[2] * k
            if not isInRange(i, j) or obj:isAllyAt(i, j) then
                break
            end
            obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            if obj:isEnemyAt(i, j) then
                break
            end
        end
    end
end

-- Knight Piece --------------------------------------------------------------

function newKnight(i, j, c)
    local k = newPiece("knight", i, j, c)
    k.updatePossibleMoves = updatePossibleMovesKnight
    return k
end

function updatePossibleMovesKnight(obj)
    for m, di in ipairs{-2, -1, 1, 2} do
        for n, dj in ipairs{-2, -1, 1, 2} do
            local i, j = obj.i + di, obj.j + dj
            if math.abs(di) ~= math.abs(dj) and isInRange(i, j) and not obj:isAllyAt(i, j) then
               obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            end
        end
    end
end

-- Bishop Piece --------------------------------------------------------------

function newBishop(i, j, c)
    local b = newPiece("bishop", i, j, c)
    b.updatePossibleMoves = updatePossibleMovesBishop
    return b
end

function updatePossibleMovesBishop(obj)
    -- down right, down left, up left, up right
    for n, s in ipairs{{1, 1}, {1, -1}, {-1, -1}, {-1, 1}} do
        for k = 1, #board - 1 do
            local i, j = obj.i + s[1] * k, obj.j + s[2] * k
            if not isInRange(i, j) or obj:isAllyAt(i, j) then
                break
            end
            obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            if obj:isEnemyAt(i, j) then
                break
            end
        end
    end
end

-- Queen Piece ---------------------------------------------------------------

function newQueen(i, j, c)
    local q = newPiece("queen", i, j, c)
    q.updatePossibleMoves = updatePossibleMovesQueen
    return q
end

function updatePossibleMovesQueen(obj)
    updatePossibleMovesRook(obj)
    updatePossibleMovesBishop(obj)
end

-- King Piece ----------------------------------------------------------------

function newKing(i, j, c)
    local k = newPiece("king", i, j, c)
    k.updatePossibleMoves = updatePossibleMovesKing
    return k
end

function updatePossibleMovesKing(obj)
    for i = obj.i - 1, obj.i + 1 do
        for j = obj.j - 1, obj.j + 1 do
            if isInRange(i, j) and not obj:isAllyAt(i, j) then
                obj.possibleMoves[#obj.possibleMoves + 1] = {i, j}
            end
        end
    end
end

-- Main Functions ------------------------------------------------------------

function _fn.start()
    ct.setBackColor("dark gray")
    --TODO: setOutputFile cannot open file
    ct.setOutputFile("log.txt")
    ct.println("Algebraic Notation Records")
    ct.println("\tFor more information visit: https://en.wikipedia.org/wiki/Algebraic_notation_(chess)")
    ct.setSoundVolume(0.5)
    ct.loadSound("chess sound.wav")
    createBoard()
    local c = colorPrompt()
    setupPieces(c)
    updateAllPossibleMoves()
    isPlayerTurn = c == 'w'
    time = ct.getTimer()
end

function _fn.update()
    if not isPlayerTurn and not isGameFinished and #pieces[2] > 0 and ct.getTimer() - time > 500 then
        opponentMove()
        isPlayerTurn = true
    end
end

function _fn.onMouseDrag(gameObj, x, y)
    local piece = getPieceFromGameObj(gameObj)
    if isPlayerTurn and isPlayerPiece(piece) then
        colorBoard()
        gameObj:setLayer(2)
        gameObj:setSize(3, 3)
        gameObj.x, gameObj.y = x, y
        local i, j = getBoardIndex(x, y)
        if piece:isPossibleMove(i, j) and piece:isEnemyAt(i, j) then
            board[i][j]:setFillColor("light red")
        elseif piece:isPossibleMove(i, j) then
            board[i][j]:setFillColor("light blue")
        end
    end
end

function _fn.onMouseRelease(gameObj, x, y)
    local piece = getPieceFromGameObj(gameObj)
    local i, j = getBoardIndex(x, y)
    if isPlayerTurn and isPlayerPiece(piece) and piece:isPossibleMove(i, j) then
        colorTile(i, j)
        gameObj:setLayer(1)
        gameObj:setSize(8, 9)
        piece:move(i, j)
        isPlayerTurn = false
        time = ct.getTimer()
    elseif isPlayerPiece(piece) then
        gameObj:setLayer(1)
        gameObj:setSize(8, 9)
        x, y = getCoords(piece.i, piece.j)
        gameObj.x, gameObj.y = x, y
    end
end

function createBoard()
    local x, y
    for i = 1, #board do
        for j = 1, #board do
            x, y = getCoords(i, j)
            board[i][j] = ct.rect(x, y, tileLength, tileLength)
            board[i][j]:setLineWidth(0)
            ct.text(ct.parseInt(math.abs(j - 8) + 1), 1, x + 4, 2, "white")
        end
        ct.text(files[i], y - 4, 103, 2, "white")
    end
    colorBoard()
end

function setupPieces(pColor)
    local oColor = 'b'
    if pColor == 'b' then
        oColor = 'w'
    end
    local player = {7, 8, pColor}
    local opponent = {2, 1, oColor}
    for m, v in ipairs{player, opponent} do
        for n, piece in ipairs{newRook, newKnight, newBishop, newQueen, newKing, newBishop, newKnight, newRook} do
            pieces[m][n] = newPawn(v[1], n, v[3])
            pieces[m][n + #board] = piece(v[2], n, v[3])
        end
    end
end

function opponentMove()
    local rpiece
    while true do
        rpiece = pieces[2][ct.random(1, #pieces[2])]
        rpiece.possibleMoves = {}
        rpiece:updatePossibleMoves()
        if #rpiece.possibleMoves > 0 then
            break
        end
    end
    local v = rpiece.possibleMoves[ct.random(1, #rpiece.possibleMoves)]
    rpiece:move(v[1], v[2])
end

--TODO: opponent winning is not working
function endingConditions()
    ct.print(not getPlayerKing())
    ct.print(' ')
    ct.println(isPlayerInCheckMate())
    if not getOppKing() or isOppInCheckMate() then
        isGameFinished = true
        ct.text("Player Won!", 49, 49, 20, "white")
        ct.text("Player Won!", 50, 50, 20, "dark cyan")
        ct.println("Player Won!")
    elseif not getPlayerKing() or isPlayerInCheckMate() then
        isGameFinished = true
        ct.text("Opponent Won", 49, 49, 16, "white")
        ct.text("Opponent Won", 50, 50, 16, "light red")
        ct.println("Opponent Won")
    elseif isDraw() then
        isGameFinished = true
        ct.text("Draw", 49, 49, 20, "white")
        ct.text("Draw", 50, 50, 20, "light blue")
        ct.println("Draw")
    end
    if isGameFinished then
        preventPiecesFromMoving()
    end
end

function isInCheck(k)
    local king = getKing(k)
    local m = math.abs(k - 2) + 1
    for n = 1, #pieces[m] do
        if pieces[m][n]:isPossibleMove(king.i, king.j) then
            return true
        end
    end
end

function isInCheckMate(m)
    if not isInCheck(m) then
        return false
    end
    for n = 1, #pieces[m] do
        for i = 1, #pieces[m][n].possibleMoves do
            local pm = pieces[m][n].possibleMoves[i]
            pieces[m][n]:sudoMove(pm[1], pm[2])
            local flag = not isInCheck(m)
            pieces[m][n]:undoMove()
            if flag then
                return false
            end
        end
    end
    return true
end

function isDraw()
    local m = 2
    if isPlayerTurn then
        m = 1
    end
    for n = 1, #pieces[m] do
        if #pieces[m][n].possibleMoves ~= 0 then
            return false
        end
    end
    return true
end

function log(i1, j1, i2, j2)
    local piece = getPieceAt(i1, j1)
    local t = getPieceName(piece.t)
    local file1, rank1 = files[j1], math.abs(i1 - 8) + 1
    local file2, rank2 = files[j2], math.abs(i2 - 8) + 1
    if getPieceAt(i2, j2) then
        return t .. file1 .. rank1 .. 'x' .. file2 .. rank2
    end
    return t .. file1 .. rank1 .. file2 .. rank2
end

function colorMove(i1, j1, i2, j2)
    board[i1][j1]:setFillColor("light blue")
    if getPieceAt(i2, j2) then
        board[i2][j2]:setFillColor("light red")
    else
        board[i2][j2]:setFillColor("light blue")
    end
end

function colorBoard()
    for i = 1, #board do
        for j = 1, #board[i] do
            colorTile(i, j)
        end
    end
end

function colorTile(i, j)
    if i % 2 == j % 2 then
        board[i][j]:setFillColorRGB(220, 220, 220)
    else
        board[i][j]:setFillColorRGB(100, 127, 127)
    end
end

function colorPrompt()
    local message = "What piece color would you like to play as?\n\tBlack or White"
    local values = {
        {"black", 'b'},
        {"white", 'w'},
    }
    return prompt(message, values)
end

function promotionPrompt()
    local input = ct.inputYesNo("Would you like to promote your pawn to a queen?")
    if input then
        return newQueen
    end
    local message = "Please enter a piece you wish to promote your pawn to:\n\tQueen, Bishop, Rook, or Knight"
    local values = {
        {"queen",  newQueen},
        {"bishop", newBishop},
        {"rook",   newRook},
        {"knight", newKnight},
    }
    return prompt(message, values)
end

-- Helper Functions ----------------------------------------------------------

function prompt(message, values)
    while true do
        input = ct.inputString(message):lower()
        for m in pairs(values) do
            if input == values[m][1] or input == values[m][1]:sub(1, 1) then
                return values[m][2]
            end
        end
    end
end

function updateAllPossibleMoves()
    for m = 1, #pieces do
        for n = 1, #pieces[m] do
            pieces[m][n].possibleMoves = {}
            pieces[m][n]:updatePossibleMoves()
        end
    end
end

function preventPiecesFromMoving()
    for m = 1, #pieces do
        for n = 1, #pieces[m] do
            pieces[m][n].gameObj:setClickable(false)
        end
    end
end

function isPlayerInCheck()
    return isInCheck(1)
end

function isOppInCheck()
    return isInCheck(2)
end

function isPlayerInCheckMate()
    return isInCheckMate(1)
end

function isOppInCheckMate()
    return isInCheckMate(2)
end

function getPlayerKing()
    return getKing(1)
end

function getOppKing()
    return getKing(2)
end

function getKing(m)
    for n = 1, #pieces[m] do
        if pieces[m][n].t == "king" then
            return pieces[m][n]
        end
    end
end

function getPieceAt(i, j)
    for m = 1, #pieces do
        for n = 1, #pieces[m] do
            if pieces[m][n].i == i and pieces[m][n].j == j then
                return pieces[m][n]
            end
        end
    end
end

function getPieceFromGameObj(gameObj)
    for m = 1, #pieces do
        for n = 1, #pieces[m] do
            if gameObj == pieces[m][n].gameObj then
                return pieces[m][n]
            end
        end
    end
end

function getPieceIndex(obj)
    for m = 1, #pieces do
        for n = 1, #pieces[m] do
            if obj == pieces[m][n] then
                return m, n
            end
        end
    end
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

function getGameImage(t, i, j, c)
    local x, y = getCoords(i, j)
    local image = ct.image(c .. "_" .. t .. ".png", x, y, 8)
    image:setSize(8, 9)
    return image
end

function getCoords(i, j)
    return tileLength * j - 4, tileLength * i
end

function getPieceName(t)
    if t == "pawn" then
        return ''
    end
    if t == "knight" then
        return 'N'
    end
    return t:sub(1, 1):upper()
end

function isPlayerPiece(obj)
    local m, n = getPieceIndex(obj)
    return m == 1
end

function isInRange(i, j)
    return i >= 1 and i <= #board and j >= 1 and j <= #board
end

require('Code12.api')
require('Code12.runtime').initAndRun()
