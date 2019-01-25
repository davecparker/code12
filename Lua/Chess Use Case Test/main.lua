package.path = package.path .. [[;../../Desktop/Code12/?.lua;C:\Users\lando\Documents\code12\Desktop\Code12\?.lua]]
local ct, this, _fn = require('Code12.ct').getTables()

local files = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}
local playerTurn, gameFinished, check, checkmate, draw
local vectors, pvpButton, pvcButton, pvp, pvc, wins, losses
local setting, settings, logo, money, bet, origin
local tileLen, tile, time, pc, oc
local board, pieces

-- piece ----------------------------------------------------------------------

function newPiece(t, i, j, c)
    local p = getGameObj(t, i, j, c)
    p.t = t
    p.i = i
    p.j = j
    p.c = c
    p.group = "pieces"
    p.moves = {}
    p.move = move
    p.sudoMove = sudoMove
    p.moveVisual = moveVisual
    p.capture = capture
    p.remove = remove
    p.restore = restore
    p.log = log
    p.getName = getName
    p.isMove = isMove
    p.isAllyAt = isAllyAt
    p.isEnemyAt = isEnemyAt
    return p
end

function move(obj, i, j)
    for i, p in pairs(pieces) do
        p.justMoved = false
    end
    if obj:isEnemyAt(i, j) then
        getPieceAt(i, j):capture()
    end
    obj.justMoved = true
    obj.i, obj.j = i, j
    obj.x, obj.y = getCoords(i, j)
end

function sudoMove(obj, i, j)
    local p = getPieceAt(i, j)
    if p then
        p:remove()
    end
    obj.i2, obj.j2 = obj.i, obj.j
    obj.i, obj.j = i, j
    return p
end

function moveVisual(obj, i, j)
    colorBoard()
    colorMove(obj.i, obj.j, i, j)
    ct.logm(obj:log(i, j), obj)
    ct.sound("chess sound.wav")
end

function capture(obj)
    obj:setSize(tileLen / 4, tileLen / 4)
    obj.y = 108
    if isPlayerPiece(obj) then
        obj.y = 3
    end
    for i = 1, 16 do
        obj.x = 4 * i
        if not obj:objectHitInGroup("pieces") then
            break
        end
    end
    obj:remove()
end

function remove(obj)
    obj.i2, obj.j2 = obj.i, obj.j
    obj.i, obj.j = nil, nil
    obj.removed = true
end

function restore(obj, p)
    obj.i, obj.j = obj.i2, obj.j2
    obj.removed = nil
    if p then
        p:restore()
    end
end

function log(obj, i, j)
    local t = obj:getName()
    local ch = getLogCheck(obj.c)
    local file1, rank1 = files[obj.j], 9 - obj.i
    local file2, rank2 = files[    j], 9 -     i
    if getPieceAt(i, j) then
        return t .. file1 .. rank1 .. 'x' .. file2 .. rank2 .. ch
    end
    return t .. file1 .. rank1 .. file2 .. rank2 .. ch
end

function getName(obj)
    return obj.t:sub(1, 1):upper()
end

function isMove(obj, i, j)
    for k, m in pairs(obj.moves) do
        if m[1] == i and m[2] == j then
            return true
        end
    end
end

function isAllyAt(obj, i, j)
    local piece = getPieceAt(i, j)
    return piece and obj.c == piece.c
end

function isEnemyAt(obj, i, j)
    local piece = getPieceAt(i, j)
    return piece and obj.c ~= piece.c
end

-- pawn piece -----------------------------------------------------------------

function newPawn(i, j, c)
    local p = newPiece("pawn", i, j, c)
    p.moveCount = 0
    p.move = movePawn
    p.sudoMove = sudoMovePawn
    p.updateMoves = updatePawnMoves
    p.enPassant = enPassant
    p.promotion = promotion
    p.log = logPawn
    if isPlayerPiece(p) then
        p.dir = -1
    else
        p.dir = 1
    end
    return p
end

function movePawn(obj, i, j)
    if obj.j ~= j and not getPieceAt(i, j) then
        getPieceAt(i - obj.dir, j):capture()
    end
    obj.moveCount = obj.moveCount + 1
    move(obj, i, j)
    if not gameFinished and (obj.i == 1 or obj.i == 8) then
        local k = getPieceIndex(obj)
        obj:promotion()
        local t = pieces[k]:getName()
        local ch = getLogCheck(obj.c)
        ct.logm(files[i] .. j .. '=' .. t .. ch, obj)
    end
end

function sudoMovePawn(obj, i, j)
    local p
    if obj.j ~= j and not getPieceAt(i, j) then
        p = getPieceAt(obj.i, j)
        p:remove()
    end
    return sudoMove(obj, i, j) or p
end

function updatePawnMoves(obj)
    local i = obj.i + obj.dir
    -- normal move
    if not getPieceAt(i, obj.j) then
        obj.moves[1] = {i, obj.j}
        -- double move
        if obj.moveCount == 0 and not getPieceAt(i + obj.dir, obj.j) then
            obj.moves[2] = {i + obj.dir, obj.j}
        end
    end
    -- diagonal capture and en passant
    for k, dj in pairs{-1, 1} do
        if obj:isEnemyAt(i, obj.j + dj) or obj:enPassant(i, obj.j + dj) then
            obj.moves[#obj.moves + 1] = {i, obj.j + dj}
        end
    end
end

function enPassant(obj, i, j)
    local p = getPieceAt(obj.i, j)
    local b1 = obj:isEnemyAt(obj.i, j) and not getPieceAt(i, j)
    local b2 = b1 and p.t == "pawn" and p.justMoved and p.moveCount == 1 and (p.i == 4 or p.i == 5)
    return b1 and b2
end

function promotion(obj)
    local i = getPieceIndex(obj)
    if pvp or isPlayerPiece(obj) then
        local promotion = promotionPrompt()
        pieces[i] = promotion(obj.i, obj.j, obj.c)
    else
        local promotions = {newQueen, newBishop, newRook, newKnight}
        pieces[i] = promotions[ct.random(1, 4)](obj.i, obj.j, obj.c)
    end
    updateAllMoves()
    for k, c in pairs{pc, oc} do
        check[c] = isInCheck(c)
        checkmate[c] = isInCheckmate(c)
    end
    draw = isDraw()
    obj:delete()
end

function logPawn(obj, i, j)
    local l = files[j] .. 9 - i
    local ch = getLogCheck(obj.c)
    if obj.j ~= j and not getPieceAt(i, j) then
        return files[obj.j] .. 'x' .. l .. "e.p." .. ch
    end
    if getPieceAt(i, j) then
        return files[obj.j] .. 'x' .. l .. ch
    end
    return l .. ch
end

-- rook piece -----------------------------------------------------------------

function newRook(i, j, c)
    local r = newPiece("rook", i, j, c)
    r.moveCount = 0
    r.move = moveRook
    r.updateMoves = updateRookMoves
    return r
end

function moveRook(obj, i, j)
    obj.moveCount = obj.moveCount + 1
    move(obj, i, j)
end

function updateRookMoves(obj)
    -- down, up, right, left
    for n, s in pairs{{1, 0}, {-1, 0}, {0, -1}, {0, 1}} do
        for k = 1, 7 do
            local i, j = obj.i + s[1] * k, obj.j + s[2] * k
            if not isInRange(i, j) or obj:isAllyAt(i, j) then
                break
            end
            obj.moves[#obj.moves + 1] = {i, j}
            if obj:isEnemyAt(i, j) then
                break
            end
        end
    end
end

-- knight piece ---------------------------------------------------------------

function newKnight(i, j, c)
    local k = newPiece("knight", i, j, c)
    k.updateMoves = updateKnightMoves
    k.getName = getKnightName
    return k
end

function updateKnightMoves(obj)
    for m, di in pairs{-2, -1, 1, 2} do
        for n, dj in pairs{-2, -1, 1, 2} do
            local i, j = obj.i + di, obj.j + dj
            if math.abs(di) ~= math.abs(dj) and isInRange(i, j) and not obj:isAllyAt(i, j) then
               obj.moves[#obj.moves + 1] = {i, j}
            end
        end
    end
end

function getKnightName(obj)
    return 'N'
end

-- bishop piece ---------------------------------------------------------------

function newBishop(i, j, c)
    local b = newPiece("bishop", i, j, c)
    b.updateMoves = updateBishopMoves
    return b
end

function updateBishopMoves(obj)
    -- down-left, down-right, up-right, up-left
    for n, s in pairs{{1, 1}, {1, -1}, {-1, -1}, {-1, 1}} do
        for k = 1, 7 do
            local i, j = obj.i + s[1] * k, obj.j + s[2] * k
            if not isInRange(i, j) or obj:isAllyAt(i, j) then
                break
            end
            obj.moves[#obj.moves + 1] = {i, j}
            if obj:isEnemyAt(i, j) then
                break
            end
        end
    end
end

-- queen piece ----------------------------------------------------------------

function newQueen(i, j, c)
    local q = newPiece("queen", i, j, c)
    q.updateMoves = updateQueenMoves
    return q
end

function updateQueenMoves(obj)
    updateRookMoves(obj)
    updateBishopMoves(obj)
end

-- king piece -----------------------------------------------------------------

function newKing(i, j, c)
    local k = newPiece("king", i, j, c)
    k.moveCount = 0
    k.move = moveKing
    k.sudoMove = sudoMoveKing
    k.updateMoves = updateKingMoves
    k.castling = castling
    k.log = logKing
    return k
end

function moveKing(obj, i, j)
    if obj.moveCount == 0 and (j == 3 or j == 7) then
        if j == 3 then
            getPieceAt(i, 1):move(i, 4)
        else
            getPieceAt(i, 8):move(i, 6)
        end
    end
    obj.moveCount = obj.moveCount + 1
    move(obj, i, j)
end

function sudoMoveKing(obj, i, j)
    local p
    if obj.moveCount == 0 and (j == 3 or j == 7) then
        if j == 3 then
            p = getPieceAt(i, 1)
            p:sudoMove(i, 4)
        else
            p = getPieceAt(i, 8)
            p:sudoMove(i, 6)
        end
    end
    return sudoMove(obj, i, j) or p
end

function updateKingMoves(obj)
    -- normal move
    for i = obj.i - 1, obj.i + 1 do
        for j = obj.j - 1, obj.j + 1 do
            if isInRange(i, j) and not obj:isAllyAt(i, j) then
                obj.moves[#obj.moves + 1] = {i, j}
            end
        end
    end
    -- castling
    for k, j in pairs{3, 7} do
        local ca = obj:castling(obj.i, j)
        if ca then
            obj.moves[#obj.moves + 1] = {obj.i, j}
        end
    end
end

function castling(obj, i, j)
    if obj.moveCount ~= 0 or not check or check[obj.c] then
        return false
    end
    local r, a, b
    if j == 3 then
        r = getPieceAt(i, 1)
        a, b = 2, 4
    elseif j == 7 then
        r = getPieceAt(i, 8)
        a, b = 6, 7
    else
        return false
    end
    if not r or r.t ~= "rook" or r.moveCount ~= 0 then
        return false
    end
    for k = a, b do
        if getPieceAt(obj.i, k) or isTileInCheck(obj.c, obj.i, k) then
            return false
        end
    end
    return true
end

function logKing(obj, i, j)
    if obj.moveCount == 0 and (j == 3 or j == 7) then
        local ch = getLogCheck(obj.c)
        if j == 3 then
            return "O-O-O" .. ch
        end
        return "O-O" .. ch
    end
    return log(obj, i, j)
end

-- vector ---------------------------------------------------------------------

function newVector()
    local v = ct.circle(ct.random(1, 199), ct.random(1, 99), 2)
    v.shade = 102
    v.updateShade = updateShade
    v.setSpeed = setSpeed
    v:setSpeed()
    v:setLayer(-51)
    v:setFillColorRGB(0, 102, 102)
    v:setLineColorRGB(0, 102, 102)
    return v
end

function updateVectors()
    local x = ct.round(ct.clickX())
    local y = ct.round(ct.clickY())
    for i, v in pairs(vectors) do
        if v.shade < 153 then
            v:updateShade()
        end
        if v.x < -20 or v.x > 200 or v.y < -20 or v.y > 120 then
            vectors[i]:delete()
            vectors[i] = newVector()
        end
        if ct.clicked() and vectors[i]:containsPoint(x, y) then
            ct.println(vectors[i]:toString() .. ' ' .. vectors[i]:getXSpeed() .. ", " .. vectors[i]:getYSpeed())
            vectors[i]:delete()
            vectors[i] = newVector()
        end
        for j = i + 1, #vectors do
            if vectors[i]:hit(vectors[j]) then
                vectors[i]:delete()
                vectors[j]:delete()
                vectors[i] = newVector()
                vectors[j] = newVector()
            end
        end
    end
end

function updateShade(obj)
    obj.shade = obj.shade + 1
    obj:setLayer(obj:getLayer() + 1)
    obj:setFillColorRGB(0, obj.shade, obj.shade)
end

function setSpeed(obj)
    local speeds = {-0.05, 0, 0.05}
    local xSpeed, ySpeed
    while true do
        xSpeed = speeds[ct.random(1, 3)]
        ySpeed = speeds[ct.random(1, 3)]
        if xSpeed ~= 0 or ySpeed ~= 0 then
            break
        end
    end
    obj:setXSpeed(xSpeed)
    obj:setYSpeed(ySpeed)
end

function defineLines()
    for i, v1 in pairs(vectors) do
        for j, v2 in pairs(vectors) do
            if v1 ~= v2 and ct.distance(v1.x, v1.y, v2.x, v2.y) <= 20 then
                local line = ct.line(v1.x, v1.y, v2.x, v2.y)
                local shade = math.min(v1.shade, v2.shade)
                line:setLineColorRGB(0, shade, shade)
                line:setLayer(-51)
                line.group = "lines"
            end
        end
    end
end

-- main functions -------------------------------------------------------------

-- declaration functions

function _fn.start()
    ct.setTitle("Chess")
    ct.setHeight(100)
    ct.setOutputFile("log.txt")
    ct.print("Algebraic Notation Records")
    ct.println("\n\tFor more information visit: https://en.wikipedia.org/wiki/Algebraic_notation_(chess)")
    ct.setSoundVolume(0.5)
    ct.loadSound("chess sound.wav")
    tileLen = ct.intDiv(96, ct.getPixelsPerUnit())
    time = ct.getTimer()
    wins, losses = 0, 0
    tile, vectors = {}, {}
    createMainScreen()
    createTitleScreen()
end

function createTitleScreen()
    ct.setScreen("title")
    ct.setBackColorRGB(0, 102, 102)
    ct.text("Chess", 49, 19, 20)
    ct.text("Chess", 50, 20, 20, "white")
    local line1 = ct.line(27, 29, 71, 29)
    local line2 = ct.line(28, 30, 72, 30, "white")
    line1:setLineWidth(6)
    line2:setLineWidth(6)
    ct.rect(49, 69, 80, 10, "black")
    pvpButton = ct.rect(50, 70, 80, 10, "white")
    pvpButton:setLineColor("white")
    local text1 = ct.text("play with a friend", 50, 70, 6)
    text1:setClickable(false)
    ct.rect(49, 89, 80, 10, "black")
    pvcButton = ct.rect(50, 90, 80, 10, "white")
    pvcButton:setLineColor("white")
    local text2 = ct.text("play with the computer", 50, 90, 6)
    text2:setClickable(false)
    ct.text("Made using Code12 v" .. ct.formatDecimal(ct.getVersion()), 86, 110, 3, "white")
    ct.text("win/loss ratio:", 20, 50, 5, "white")
    local ratio = wins / losses
    if ratio == 1 / 0 then
        ratio = 1
    end
    if ct.isError(ratio) then
        ct.text("0", 30, 55, 5, "white")
    else
        ct.text(ct.formatDecimal(ct.roundDecimal(ratio, 2)), 30, 55, 5, "white")
    end
    for i = 1, 40 do
        vectors[i] = newVector()
    end
end

function createMainScreen()
    ct.setScreen("main")
    ct.setBackColor("dark gray")
    createSettings()
    createBoard()
    money = ct.text("$100", 88, 108, 5, "white")
    origin = 0
end

function createSettings()
    settings = {}
    ct.text("Settings", 140, 10, 15, "light red")
    for i, t in pairs{"add picture", "pause game", "exit to title", "restart game", "restart program", "stop program"} do
        local x, y = 120 + 40 * (i % 2), 30 + 20 * ct.intDiv(i - 1, 2)
        settings[i] = ct.circle(x, y, 12)
        settings[i]:setFillColorRGB(220, 220, 220)
        settings[i]:setLineColorRGB(220, 220, 220)
        settings[i]:setSize(25, 10)
        local text = ct.text(t, x, y, 4)
        text:setClickable(false)
    end
    logo = ct.image("code12.ico", 140, 90, 10, 10)
    ct.text("Made using Code12 v" .. ct.formatDecimal(ct.getVersion()), 166, 110, 3, "white")
end

function createBoard()
    board = {}
    local x, y
    for i = 1, 8 do
        board[i] = {}
        for j = 1, 8 do
            x, y = getCoords(i, j)
            board[i][j] = ct.rect(x, y, tileLen, tileLen)
            board[i][j]:setLineWidth(0)
            board[i][j]:setLayer(0)
            board[i][j]:align("center")
            ct.text(ct.formatInt(9 - j), 1, x + 4, tileLen / 6, "white")
        end
        ct.text(files[i], y - 4, 103, tileLen / 6, "white")
    end
    colorBoard()
end

function setupPieces()
    pieces = {}
    for i, piece in pairs{newRook, newKnight, newBishop, newQueen, newKing, newBishop, newKnight, newRook} do
        pieces[i]      = newPawn(7, i, pc)
        pieces[i +  8] = piece(8, i, pc)
        pieces[i + 16] = newPawn(2, i, oc)
        pieces[i + 24] = piece(1, i, oc)
    end
end

function playButton()
    local b1 = pvpButton:clicked()
    local b2 = pvcButton:clicked()
    local t = {{b1, pvp}, {b2, pvc}}
    if b1 then
        pvp, pvc = true, nil
        ct.println('')
        ct.log(pvpButton)
    elseif b2 then
        pvp, pvc = nil, true
        ct.println('')
        ct.log(pvcButton)
    end
    for k, b in pairs(t) do
        if b[1] then
            ct.clearScreen()
            ct.setScreen("main")
            ct.setScreenOrigin(0, 0)
            setting = nil
            origin = 0
            tile = {}
            if not b[2] then
                setupGame()
                time = ct.getTimer()
            end
        end
    end
end

function setupGame()
    ct.setBackColor("dark gray")
    ct.clearGroup("pieces")
    ct.setScreenOrigin(0, 0)
    logo:setImage("code12.ico")
    gameFinished = false
    setting = nil
    origin = 0
    bet = 0
    colorBoard()
    betPrompt()
    if pvc then
        colorPrompt()
    else
        pc, oc = 'w', 'b'
        playerTurn = true
    end
    setupPieces()
    updateAllMoves()
    if pvp then
        preventPlayerMovement(oc)
    end
end

-- user input/interaction functions

function _fn.update()
    playButton()
    if ct.getScreen() == "title" then
        updateVectors()
        ct.clearGroup("lines")
        defineLines()
    elseif ct.getScreen() == "main" then
        if pvc then
            oppMove()
        end
        charTypedMove()
        updateOrigin()
        updateCharTyped()
        settingActions()
    end
end

function _fn.onMouseDrag(obj, x, y)
    tile = {}
    if isPlayerPiece(obj) and not obj.removed then
        colorBoard()
        obj:setLayer(2)
        obj:setSize(board[1][1]:getWidth() / 4, board[1][1]:getHeight() / 4)
        obj.x, obj.y = x, y
        local i, j = getBoardIndex(x, y)
        local ep = obj.t == "pawn" and obj.j ~= j and not getPieceAt(i, j)
        board[obj.i][obj.j]:setFillColor("light blue")
        if obj:isMove(i, j) and (obj:isEnemyAt(i, j) or ep) then
            board[i][j]:setFillColor("light red")
        elseif obj:isMove(i, j) then
            board[i][j]:setFillColor("light blue")
        end
    end
end

function _fn.onMouseRelease(obj, x, y)
    if isPlayerPiece(obj) and not obj.removed then
        obj:setLayer(1)
        obj:setSize(2 * tileLen / 3, 3 * tileLen / 4)
        local i, j = getBoardIndex(x, y)
        if obj:isMove(i, j) then
            updateState(obj, i, j)
            obj:moveVisual(i, j)
            obj:move(i, j)
            endingConditions()
            updateAllMoves()
            if pvp and not gameFinished then
                enableMovement()
                preventPlayerMovement(obj.c)
            end
            playerTurn = not playerTurn
            time = ct.getTimer()
        else
            x, y = getCoords(obj.i, obj.j)
            obj.x, obj.y = x, y
        end
    end
end

function charTypedMove()
    if not gameFinished and ct.keyPressed("enter") and tile[1] and tile[2] then
        local obj = getPieceAt(tile[1], tile[2])
        if isPlayerPiece(obj) and not obj.removed then
            for i, m in pairs(obj.moves) do
                colorMove(obj.i, obj.j, m[1], m[2])
            end
            local i, j = movePrompt(obj)
            colorBoard()
            updateState(obj, i, j)
            obj:moveVisual(i, j)
            obj:move(i, j)
            endingConditions()
            updateAllMoves()
            if pvp and not gameFinished then
                enableMovement()
                preventPlayerMovement(obj.c)
            end
            playerTurn = not playerTurn
            time = ct.getTimer()
            tile = {}
        end
    end
end

function oppMove()
    if not playerTurn and not gameFinished and ct.getTimer() - time > 500 then
        local p, i, j = getOppMove()
        updateState(p, i, j)
        p:moveVisual(i, j)
        p:move(i, j)
        endingConditions()
        updateAllMoves()
        playerTurn = true
    end
end

function getOppMove()
    local rpiece = pieces[ct.random(1, #pieces)]
    while rpiece.removed or isPlayerPiece(rpiece) or #rpiece.moves == 0 do
        rpiece = pieces[ct.random(1, #pieces)]
    end
    local m = rpiece.moves[ct.random(1, #rpiece.moves)]
    return rpiece, m[1], m[2]
end

function updateOrigin()
    if ct.getScreen() == "main" and ct.keyPressed("escape") and ct.getTimer() - time > 300 then
        setting = not setting
        time = ct.getTimer()
    end
    if ct.getScreen() == "main" and setting and origin < 80 then
        origin = origin + 1
        ct.setScreenOrigin(origin, 0)
    elseif ct.getScreen() == "main" and not setting and origin > 0 then
        origin = origin - 1
        ct.setScreenOrigin(origin, 0)
    end
end

function settingActions()
    if ct.clicked() then
        local obj = ct.objectClicked()
        for i, f in pairs{setBackgroundImage, ct.pause, createTitleScreen, restartGame, restartProgram, stopProgram} do
            if obj == settings[i] then
                f()
            end
        end
    end
end

function setBackgroundImage()
    local image = ct.inputString("Place a picture in the directory of this program then enter the file's name")
    ct.setBackImage(image)
end

function restartGame()
    if gameFinished then
        setupGame()
    else
        local input = ct.inputYesNo("Are you sure? Game progress will be lost")
        if input then
            setupGame()
        end
    end
end

function restartProgram()
    local input = ct.inputYesNo("Are you sure? All program data will be lost")
    if input then
        ct.restart()
    end
end

function stopProgram()
    local input = ct.inputYesNo("Are you sure? All program data will be lost")
    if input then
        ct.stop()
    end
end

function updateCharTyped()
    local rank, file, k
    for i = 1, #board do
        rank = ct.charTyped(ct.formatInt(i))
        file = ct.charTyped(files[i])
        k = i
        if rank or file then
            break
        end
    end
    if rank and tile[1] or file and tile[2] then
        tile = {}
    end
    if rank then
        tile[1] = math.abs(9 - k)
    elseif file then
        tile[2] = k
    end
    if rank or file then
        colorBoard()
        colorCharTyped()
    end
end

function endingConditions()
    if gameFinished then
        preventAllMovement()
    end
    local ps, os
    if pvp then
        local c = {w = "White", b = "Black"}
        ps, os = c[pc], c[oc]
    elseif pvc then
        ps, os = "Player", "Opponent"
    end
    if getKing(oc).removed or checkmate[oc] or draw and check[oc] then
        ct.showAlert(ps .. " Won")
        wins = wins + 1
        logo:setImage("trophy.png")
        money:setText('$' .. ct.parseNumber(money:getText():sub(2)) + 2 * bet)
    elseif getKing(pc).removed or checkmate[pc] or draw and check[pc] then
        ct.showAlert(os .. " Won")
        losses = losses + 1
        if ct.parseNumber(money:getText():sub(2)) == 0 then
            ct.showAlert("You have no more money to continue..")
            ct.stop()
        end
    elseif draw then
        ct.showAlert("Draw")
    end
end

function _fn.onResize()
    local p = ct.getPixelsPerUnit()
    tileLen = ct.intDiv(96, p)
    if ct.isError(tileLen) then
        ct.showAlert("Screen is too small")
    end
    createBoard()
end

-- check/checkmate functions

function updateState(obj, i, j)
    check, checkmate = {}, {}
    local i2, j2 = obj.i, obj.j
    local p = obj:sudoMove(i, j)
    updateAllMoves()
    for k, c in pairs{pc, oc} do
        check[c] = isInCheck(c)
        checkmate[c] = isInCheckmate(c)
    end
    draw = isDraw()
    gameFinished = checkmate[pc] or checkmate[oc] or draw or getKing(pc).removed or getKing(oc).removed
    obj.i, obj.j = i2, j2
    if p then
        p:restore()
    end
end

function isInCheck(c)
    local king = getKing(c)
    if not king.removed then
        return isTileInCheck(c, king.i, king.j)
    end
end

function isTileInCheck(c, i, j)
    local dc = getDiffColor(c)
    for k, p in pairs(pieces) do
        if p.c == dc and not p.removed and p:isMove(i, j) then
            return true
        end
    end
end

function isInCheckmate(c)
    if not check[c] then
        return false
    end
    for i, p in pairs(pieces) do
        if not p.removed and p.c == c then
            for j, m in pairs(p.moves) do
                local o = p:sudoMove(m[1], m[2])
                updateAllMoves()
                local notInCheck = not isInCheck(c)
                p:restore(o)
                updateAllMoves()
                if notInCheck then
                    return false
                end
            end
        end
    end
    return true
end

function isDraw()
    local b, n, o = 0, 0, 0
    for i, p in pairs(pieces) do
        if not p.removed then
            if p.t == "knight" then
                n = n + 1
            elseif p.t == "bishop" then
                b = b + 1
            else
                o = o + 1
            end
        end
    end
    local b1 = pieces[11].removed and pieces[30].removed
    local b2 = pieces[14].removed and pieces[27].removed
    if o == 2 and b == 0 and n == 0 or
       o == 2 and b == 1 and n == 0 or
       o == 2 and b == 0 and n == 1 or
       o == 2 and b == 2 and n == 0 and (b1 or b2) then
        return true
    end
end

-- color functions

function colorMove(i1, j1, i2, j2)
    local p = getPieceAt(i1, j1)
    local ep = p.t == "pawn" and j1 ~= j2 and not getPieceAt(i2, j2)
    board[i1][j1]:setFillColor("light blue")
    if getPieceAt(i2, j2) or ep then
        board[i2][j2]:setFillColor("light red")
    else
        board[i2][j2]:setFillColor("light blue")
    end
end

function colorCharTyped()
    if tile[1] and tile[2] then
        board[tile[1]][tile[2]]:setFillColor("light blue")
    else
        for i = 1, #board do
            for j = 1, #board[i] do
                if i == tile[1] or j == tile[2] then
                    board[i][j]:setFillColor("light blue")
                end
            end
        end
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

-- prompt functions

function colorPrompt()
    local message = "What piece color would you like to play as?\n\tBlack or White"
    local values = {
        {"black", 'b'},
        {"white", 'w'},
    }
    pc = prompt(message, values)
    oc = getDiffColor(pc)
    playerTurn = pc == 'w'
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

function movePrompt(obj)
    local message1 = "Please enter a valid "
    local message2, validRanks, validFiles = "", {}, {}
    for i, m in pairs(obj.moves) do
        message2 = message2 .. '{' .. math.abs(9 - m[1]) .. ", " .. files[m[2]] .. "}, "
        validRanks[i] = {ct.formatDecimal(math.abs(9 - m[1])), m[1]}
        validFiles[i] = {files[m[2]], m[2]}
    end
    while true do
        local i = prompt(message1 .. "rank: " .. message2, validRanks)
        local j = prompt(message1 .. "file: " .. message2, validFiles)
        for k, m in pairs(obj.moves) do
            if i == m[1] and j == m[2] then
                return i, j
            end
        end
    end
end

function betPrompt()
    while true do
        bet = ct.inputNumber("Please enter the amount of money you would like to bet")
        if bet > 0 and bet <= ct.parseNumber(money:getText():sub(2)) then
            break
        end
    end
    if ct.canParseNumber(money:getText():sub(2)) then
        money:setText('$' .. ct.parseNumber(money:getText():sub(2)) - bet)
    end
end

-- helper functions -----------------------------------------------------------

-- prompt helper functions

function prompt(message, values)
    while true do
        local input = ct.inputString(message):lower()
        for i, v in pairs(values) do
            if input == v[1] or input == v[1]:sub(1, 1) then
                return v[2]
            end
        end
    end
end

-- piece helper functions

function updateAllMoves()
    for i, p in pairs(pieces) do
        if not p.removed then
            p.moves = {}
            p:updateMoves()
        end
    end
end

function enableMovement()
    for i, p in pairs(pieces) do
        p:setClickable(true)
    end
end

function preventAllMovement()
    for i, p in pairs(pieces) do
        p:setClickable(false)
    end
end

function preventPlayerMovement(c)
    for i, p in pairs(pieces) do
        if p.c == c then
            p:setClickable(false)
        end
    end
end

function getGameObj(t, i, j, c)
    local x, y = getCoords(i, j)
    local image = ct.image(c .. '_' .. t .. ".png", x, y, 8)
    image:setSize(8, 9)
    return image
end

function getKing(c)
    for i, p in pairs(pieces) do
        if p.t == "king" and p.c == c then
            return p
        end
    end
end

function getPieceAt(i, j)
    for k, p in pairs(pieces) do
        if p.i == i and p.j == j then
            return p
        end
    end
end

function getPieceIndex(obj)
    for i, p in pairs(pieces) do
        if obj == p then
            return i
        end
    end
end

function getLogCheck(c)
    local dc = getDiffColor(c)
    if checkmate[dc] then
        return '#'
    end
    if check[dc] then
        return '+'
    end
    return ''
end

function getDiffColor(c)
    if c == 'w' then
        return 'b'
    end
    return 'w'
end

function isPiece(obj)
    return obj and obj:getType() == "image"
end

function isPlayerPiece(obj)
    if pvc then
        return isPiece(obj) and obj.c == pc
    end
    return isPiece(obj) and (playerTurn and obj.c == pc or not playerTurn and obj.c == oc)
end

-- board helper functions

function getBoardIndex(x, y)
    if x < 2 or x > ct.getWidth() - 2 or y < 6 or y > ct.getHeight() + 2 then
        return nil
    end
    local i, j = 1, 1
    for k = 2, #board do
        if x > tileLen * (k - 1) + 2 then
            j = k
        end
        if y > tileLen * (k - 1) + 6 then
            i = k
        end
    end
    return i, j
end

function getCoords(i, j)
    return tileLen * j - 4, tileLen * i
end

function isInRange(i, j)
    return i >= 1 and i <= #board and j >= 1 and j <= #board
end

require('Code12.api')
require('Code12.runtime').initAndRun()
