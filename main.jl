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

function tester(board, pool)
    b1 = deepcopy(board)
    b2 = deepcopy(board)
    b3 = deepcopy(board)

    p1 = deepcopy(pool)
    p2 = deepcopy(pool)
    p3 = deepcopy(pool)

    #=println("-------------------")=#
    #=@time solvePool(b1, p1)=#
    #=@time solvePoolOld(b2, p2)=#
    #=println("-------------------")=#

    tic()
    solvePoolOld(b2, p2)
    t1 = toq()

    #=Profile.print()=#

    tic()
    solvePool(b1, p1, 1, trues(length(pool)))
    t2 = toq()

    tic()
    solvePoolTopLeftMost(b3, p3)
    t3 = toq()

    return t1, t2, t3
end

function main()
    x, y = 4, 6

    board = getRectangleBoard(x, y)
    pool  = Piece[]

    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, triangle)
    push!(pool, square)
    push!(pool, square)
    push!(pool, triangle)

    n = 1

    for per in permutations(pool)
        t1, t2, t3 = tester(board, per)
        println("$n\t$t1\t$t2\t$t3")
        n += 1
    end
    return

end

#=main()=#
