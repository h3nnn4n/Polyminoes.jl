function solvePoolOld(board :: Board, pool :: Array{Piece}, lvl :: Int64 = 1)
    x, y = board.size

    if lvl == 1 && length(pool) * 4 != x * y
        println("Error")
        println(length(pool) * 4, " != ", x*y)
    end

    for i in 1:x, j in 1:y
        for (n, pp) in enumerate(pool)
            for p in pp.cubits

                if canFit(board, p, i, j)
                    newBoard = deepcopy(board)
                    newPool  = deepcopy(pool)
                    putPiece(newBoard, p, pp.id, i, j)

                    splice!(newPool, n)
                    if length(newPool) == 0 && isFilled(newBoard)
                        if output
                            println(newBoard)
                        end
                        return true
                    end

                    result = solvePoolOld((newBoard), newPool, lvl + 1)

                    if result
                        board = newBoard
                        return true
                    end
                end
            end
        end
    end

    return false
end

function solvePoolTopLeftMost(board :: Board, pool :: Array{Piece}, lvl :: Int64 = 1, poolCtrl = [])
    x, y = board.size
    iter = 0
    poolSize = length(pool)

    if lvl == 1
        poolControl = trues(poolSize)
    else
        poolControl = poolCtrl
    end

    if lvl == 1 && length(pool) * 4 != x * y
        println("Error")
        println(length(pool) * 4, " != ", x*y)
    end

    for (n, pp) in enumerate(pool)
            for np in 1:poolSize
                if poolControl[np]
                    piece = pool[np]
                    iter += 1

                    for p in piece.cubits
        for i in 1:x, j in 1:y
                        if canFit(board, p, i, j)
                            poolControl[np] = false
                            putPiece(board, p, piece.id, i, j)

                            q = true
                            for w in poolControl
                                if w
                                    q = false
                                end
                            end

                            if q && isFilled(board)
                                output && println(board)
                                return true
                            end

                            result = solvePool(board, pool, lvl + 1, poolControl)

                            if result
                                return true
                            else
                                removePiece(board, p, i, j)
                                poolControl[np] = true
                            end
                        end
                    end
                end
            end
        end
        break
    end

    return false
end

function solvePool(board :: Board, pool :: Array{Piece}, lvl :: Int64, poolControl :: Array{Piece})
    x, y = board.size
    poolSize = length(pool)

    if lvl == 1 && length(pool) * 4 != x * y
        println("Error")
        println(length(pool) * 4, " != ", x*y)
    end

    for i in 1:x, j in 1:y
        if board.squares[i, j] != 0
            continue
        end
        for (n, pp) in enumerate(pool)
            for np in 1:poolSize
                if poolControl[np]
                    piece = pool[np]

                    for p in piece.cubits
                        if canFit(board, p, i, j)
                            poolControl[np] = false
                            putPiece(board, p, piece.id, i, j)

                            q = true
                            for w in poolControl
                                if w
                                    q = false
                                end
                            end

                            if q && isFilled(board)
                                output && println(board)
                                return true
                            end

                            result = solvePool(board, pool, lvl + 1, poolControl)

                            if result
                                return true
                            else
                                removePiece(board, p, i, j)
                                poolControl[np] = true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end
