output = false

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

Base.println(board :: Board) = print(board :: Board)

function Base.print(board :: Board)
    colors = [:red, :green, :blue, :yellow, :cyan, :magenta, :white]
    bx, by = board.size

    for i in 1:bx
        for j in 1:by
            print_with_color(colors[board.squares[i, j]], string(board.squares[i, j]))
        end
        println("")
    end
    println("")

end

function getRectangleBoard(x :: Int64, y :: Int64)
    return Board((x, y), zeros(Int64, (x, y)))
end

function canFit(board :: Board, piece :: Node, x :: Int64, y :: Int64)
    bx, by = board.size
    for p in piece.cubes
        posx, posy = x + p[1] - 1, y + p[2] - 1
        if posx > bx || posy > by
            return false
        elseif board.squares[posx, posy] != 0
            return false
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

function removePiece(board :: Board, piece :: Node, x :: Int64, y :: Int64)
    for p in piece.cubes
        posx, posy = x + p[1] - 1, y + p[2] - 1
        board.squares[posx, posy] = 0
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

function solvePool(board :: Board, pool :: Array{Piece}, lvl :: Int64 = 1, poolCtrl = [])
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

    for i in 1:x, j in 1:y
        for (n, pp) in enumerate(pool)
            for np in 1:poolSize
                if poolControl[np]
                    piece = pool[np]
                    iter += 1

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

function tester(board, pool)
    b1 = deepcopy(board)
    b2 = deepcopy(board)

    p1 = deepcopy(pool)
    p2 = deepcopy(pool)

    #=println("-------------------")=#
    #=@time solvePool(b1, p1)=#
    #=@time solvePoolOld(b2, p2)=#
    #=println("-------------------")=#

    tic()
    #=@profile solvePool(b1, p1)=#
    solvePool(b1, p1)
    t1 = toc()

    #=Profile.print()=#

    tic()
    solvePoolOld(b2, p2)
    t2 = toc()

    return t1, t2
end

function main()
    board = getRectangleBoard(8, 5)
    pool  = Piece[]

    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, lllll)
    push!(pool, sssss)
    push!(pool, zzzzz)
    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, lllll)
    push!(pool, sssss)
    push!(pool, zzzzz)

    tester(board, pool)
    #=solvePool(board, pool)=#

    return

    #=x, y = 4, 5=#
    #=board = getRectangleBoard(x, y)=#
    #=pool = [Piece([Node([(1,1),(2,1),(2,2),(2,3)]),Node([(1,2),(2,2),(3,2),(3,1)]),Node([(1,1),(1,2),(1,3),(2,3)]),Node([(1,2),(1,1),(2,1),(3,1)])],4,4,7),=#
            #=Piece([Node([(1,1),(2,1),(3,1),(4,1)]),Node([(1,1),(1,2),(1,3),(1,4)])],2,4,2),=#
            #=Piece([Node([(1,1),(2,1),(3,1),(4,1)]),Node([(1,1),(1,2),(1,3),(1,4)])],2,4,2),=#
            #=Piece([Node([(1,1),(1,2),(1,3),(2,1)]),Node([(1,1),(2,1),(3,1),(3,2)]),Node([(1,3),(2,3),(2,2),(2,1)]),Node([(1,1),(1,2),(2,2),(3,2)])],4,4,6),=#
            #=Piece([Node([(2,1),(2,2),(1,2),(3,1)]),Node([(1,1),(1,2),(2,2),(2,3)])],2,4,5)]=#

    #=t1, t2 = tester(board, pool)=#
    #=println("$t1 $t2")=#

    return

    x, y = 4, 5

    board = getRectangleBoard(x, y)
    pool  = Piece[]

    #=push!(pool, triangle)=#
    #=push!(pool, lllll)=#
    #=push!(pool, triangle)=#
    #=push!(pool, stick)=#
    push!(pool, stick)
    push!(pool, stick)
    push!(pool, lllll)
    push!(pool, jjjjj)
    push!(pool, zzzzz)

    n = 1

    for per in permutations(pool)
        t1, t2 = tester(board, per)
        if t1 > 1.0
            println(per)
        end
        println("$n $t1 $t2")
        n += 1
    end
    return

    #################################

    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, square)
    push!(pool, lllll)
    push!(pool, lllll)
    push!(pool, stick)

    tester(board, pool)

    #################################

    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, jjjjj)
    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, zzzzz)

    tester(board, pool)

    #################################

    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, stick)
    push!(pool, lllll)
    push!(pool, jjjjj)
    push!(pool, zzzzz)

    tester(board, pool)

    #################################
    return

    board = getRectangleBoard(8, 8)
    pool  = Piece[]

    push!(pool, stick)
    push!(pool, stick)
    push!(pool, stick)
    push!(pool, stick)

    push!(pool, square)
    push!(pool, square)
    push!(pool, square)
    push!(pool, square)

    push!(pool, lllll)
    push!(pool, lllll)
    push!(pool, lllll)
    push!(pool, lllll)

    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, triangle)

    solvePool(board, pool)

    #=push!(pool, triangle)=#
    #=push!(pool, stick)=#
    #=push!(pool, square)=#
    #=push!(pool, zzzzz)=#
    #=push!(pool, jjjjj)=#
    #=push!(pool, lllll)=#

end

main()
