type Node
    cubes      :: Array{(Int64, Int64)}
end

type Piece
    cubits     :: Array{Node}
    rotations  :: Int64
    size       :: Int64
    id         :: Int64
end

type Board
    size       :: (Int64, Int64)
    squares    :: Array{Int64}
end

square   = Piece([Node([(1,1), (1,2), (2,1), (2,2)])], 1, 4, 1)

stick    = Piece([Node([(1,1), (2,1), (3,1), (4,1)]),
                  Node([(1,1), (1,2), (1,3), (1,4)])], 2, 4, 2)

triangle = Piece([Node([(1,1), (2,1), (3,1), (2,2)]),
                  Node([(1,2), (2,2), (3,2), (2,1)]),
                  Node([(1,1), (1,2), (1,3), (2,2)]),
                  Node([(1,2), (2,1), (2,2), (2,3)])], 4, 4, 3)

sssss    = Piece([Node([(1,1), (2,1), (2,2), (3,2)]),
                  Node([(1,2), (2,2), (2,1), (1,3)])], 2, 4, 4)

zzzzz    = Piece([Node([(2,1), (2,2), (1,2), (3,1)]),
                  Node([(1,1), (1,2), (2,2), (2,3)])], 2, 4, 5)

jjjjj    = Piece([Node([(1,1), (1,2), (1,3), (2,1)]),
                  Node([(1,1), (2,1), (3,1), (3,2)]),
                  Node([(1,3), (2,3), (2,2), (2,1)]),
                  Node([(1,1), (1,2), (2,2), (3,2)])], 4, 4, 6)

lllll    = Piece([Node([(1,1), (2,1), (2,2), (2,3)]),
                  Node([(1,2), (2,2), (3,2), (3,1)]),
                  Node([(1,1), (1,2), (1,3), (2,3)]),
                  Node([(1,2), (1,1), (2,1), (3,1)])], 4, 4, 7)

function getRectangleBoard(x :: Int64, y :: Int64)
    return Board((x, y), zeros(Int64, (x, y)))
end

function canFit(board :: Board, piece :: Node, x :: Int64, y :: Int64)
    bx, by = board.size
    for p in piece.cubes
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

function putPiece(board :: Board, piece :: Node, id :: Int64,  x :: Int64, y :: Int64)
    for p in piece.cubes
        posx, posy = x + p[1] - 1, y + p[2] - 1
        board.squares[posx, posy] = id
    end

    return board
end

function fitPiece(board :: Board, piece :: Node)
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


function solvePool(board :: Board, pool :: Array{Piece}, lvl :: Int64 = 1)
    x, y = board.size
    iter = 0

    if lvl == 0 && length(pool) * 4 != x * y
        println("Error")
        println(length(pool) * 4, " != ", x*y)
    end

    for (n, pp) in enumerate(pool)
        for i in 1:x, j in 1:y
            #=if lvl == 5=#
                #=println("i = $i \t j = $j")=#
            #=end=#

            for p in pp.cubits
                iter += 1
                if mod(iter, 1000) == 0
                    #=println(board.squares)=#
                end

                if canFit(board, p, i, j)
                    newBoard = deepcopy(board)
                    newPool  = deepcopy(pool)
                    putPiece(newBoard, p, pp.id, i, j)

                    splice!(newPool, n)
                    if length(newPool) == 0 && isFilled(newBoard)
                        println(newBoard.squares)
                        return true
                    end

                    result = solvePool((newBoard), newPool, lvl + 1)

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

function main()
    x, y = 4, 4

    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, triangle)
    push!(pool, lllll)
    push!(pool, triangle)
    push!(pool, stick)

    solvePool(board, pool)


    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, square)
    push!(pool, lllll)
    push!(pool, lllll)
    push!(pool, stick)

    solvePool(board, pool)


    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, jjjjj)
    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, zzzzz)

    solvePool(board, pool)


    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, stick)
    push!(pool, lllll)
    push!(pool, jjjjj)
    push!(pool, zzzzz)

    solvePool(board, pool)


    #=push!(pool, triangle)=#
    #=push!(pool, stick)=#
    #=push!(pool, square)=#
    #=push!(pool, zzzzz)=#
    #=push!(pool, jjjjj)=#
    #=push!(pool, lllll)=#

end
