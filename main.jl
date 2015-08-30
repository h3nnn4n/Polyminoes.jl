type Piece
    cubits    :: Array{(Int64, Int64)}
    rotations :: Int64
    size      :: Int64
    id        :: Int64
end

type Board
    size      :: (Int64, Int64)
    squares   :: Array{Int64}
end

square = Piece([(1,1), (1,2), (2,1), (2,2)], 1, 4, 1)
stick  = Piece([(1,1), (2,1), (3,1), (4,1)], 2, 4, 2)

function getRectangleBoard(x :: Int64, y :: Int64)
    return Board((x, y), zeros(Int64, (x, y)))
end

function canFit(board :: Board, piece :: Piece, x :: Int64, y :: Int64)
    bx, by = board.size
    for p in piece.cubits
        posx, posy = x + p[1] - 1, y + p[2] - 1
        if posx > bx || posy > by
            return false
        else
            if board.squares[posx, posy] != 0
                return false
            end
        end
    end

    return true
end

function putPiece(board :: Board, piece :: Piece,  x :: Int64, y :: Int64)
    for p in piece.cubits
        posx, posy = x + p[1] - 1, y + p[2] - 1
        board.squares[posx, posy] = piece.id
    end

    return board
end

function fitPiece(board :: Board, piece :: Piece)
    x, y = board.size

    for i = 1:x, j in 1:y
        if canFit(board, piece, i, j)
            putPiece(board, piece, i, j)
            break
        end
    end

    return board
end

function isFilled(board :: Board)
    x, y = board.size

    for i = 1:x, j = 1:y
        if board.squares[i, j] == 0
            return false
        end
    end

    return true
end

function solvePool(board :: Board, pool :: Array{Piece})
    x, y = board.size

    for (n, p) in enumerate(pool)
        for i in 1:x, j in 1:y
            if canFit(board, p, i, j)
                newBoard = deepcopy(board)
                newPool  = deepcopy(pool)
                putPiece(newBoard, p, i, j)

                splice!(newPool, n)
                if length(newPool) == 0 && isFilled(newBoard)
                    println(newBoard.squares)
                    return true
                end

                result = solvePool((newBoard), newPool)

                if result
                    board = newBoard
                    return true
                end
            end
        end
    end

    return false
end

function main()
    board = getRectangleBoard(4, 4)

    pool  = Piece[]

    push!(pool, square)
    push!(pool, stick)
    push!(pool, stick)
    push!(pool, square)

    solvePool(board, pool)
end
