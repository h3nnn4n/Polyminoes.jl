function tester(board, pool)
    b1 = deepcopy(board)
    b2 = deepcopy(board)
    b3 = deepcopy(board)

    p1 = deepcopy(pool)
    p2 = deepcopy(pool)
    p3 = deepcopy(pool)

    tic()
    solvePool(b1, p1, 1, trues(length(pool)))
    t1 = toq()

    tic()
    solvePoolOld(b2, p2)
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
