# Polyminoes.jl

My own attempt in writing a Polyminoes solver.
For now the objective is: given a set of pieces, find a way in which they all fit in a given space.

There are the 7 classical pieces from tetris implemented and an NxM board.

Usage example: Fit a stick, L, J and Z in a 4x4 square

```
    board = getRectangleBoard(4, 4)
    pool  = Piece[]

    push!(pool, stick)
    push!(pool, lllll)
    push!(pool, jjjjj)
    push!(pool, zzzzz)
    solvePool(board, pool)

```



For now the code works for small shapes, like 4x4 and 4x5, more than that... good luck :)
