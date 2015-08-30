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

function getRectangleBoard(x :: Int64, y :: Int64)
    return Board((x, y), zeros(Int64, (x, y)))
end

function canFit(board, piece :: Piece, x :: Int64, y :: Int64)
    for p in piece.cubits
        if board.squares[x + p[1] - 1, y + p[2] - 1] != 0
            return false
        end
    end

    return true
end

function putPiece(board, piece :: Piece,  x :: Int64, y :: Int64)
    for p in piece.cubits
        board.squares[x + p[1] - 1, y + p[2] - 1] = piece.id
    end

    return board
end

function fitPiece(board, piece :: Piece)
    x, y = board.size

    for i = 1:x, j in 1:y
        if canFit(board, piece, i, j)
            putPiece(board, piece, i, j)
            break
        end
    end

    return board
end
