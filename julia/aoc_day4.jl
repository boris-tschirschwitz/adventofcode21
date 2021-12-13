# https://adventofcode.com/2021/day/3

include("aoc_day4_data.jl")

function parseData(data) # (draws, boards)
    parts = split(data, "\n\n")
    draws = map(x -> parse(Int, x), split(parts[1], ","))

    function splitLine(line)
        numberStrings = split(line, " ", keepempty = false)
        map(x -> parse(Int, x), numberStrings)
    end
    function splitPart(part)
        lines = split(part, "\n")
        map(splitLine, lines)
    end

    boards = map(b -> hcat(b...)', map(splitPart, parts[2:end]))
    return (draws, boards)
end

function mark!(board, draw)
    markindices = findall(x -> x == draw, board)
    board[markindices] .= -1
end

function bingo(board)
    for c in eachcol(board)
        if sum(c) == -5
            return true
        end
    end

    for r in eachrow(board)
        if sum(r) == -5
            return true
        end
    end

    return false
end

function bingoStep(boards, draw)
    map(b -> mark!(b, draw), boards)
    bingos = map(bingo, boards)
    return boards[bingos]
end

function runBingo(boards, draws)
    for draw in draws
        bingos = bingoStep(boards, draw)
        if !isempty(bingos)
            return (draw, bingos[1])
        end
    end
end

function sumBoard(board)
    reduce((total, x) -> total + max(x, 0), board, init = 0)
end

function findLast(boards, draws)
    remainingBoards = boards
    for draw in draws
        bingos = bingoStep(remainingBoards, draw)
        if length(bingos) == length(remainingBoards)
            return (draw, bingos[end])
        end
        filter!(b -> !in(b, bingos), remainingBoards)
    end
end

using Test

# Part 1

@test let data = parseData(testData), draws = data[1], boards = data[2]
    (draw, bingo) = runBingo(boards, draws)
    draw * sumBoard(bingo) == 4512
end

@test let data = parseData(day4Data), draws = data[1], boards = data[2]
    (draw, bingo) = runBingo(boards, draws)
    draw * sumBoard(bingo) == 41668
end

# Part 2

@test let data = parseData(testData), draws = data[1], boards = data[2]
    (draw, bingo) = findLast(boards, draws)
    draw * sumBoard(bingo) == 1924
end

@test let data = parseData(day4Data), draws = data[1], boards = data[2]
    (draw, bingo) = findLast(boards, draws)
    draw * sumBoard(bingo) == 10478
end
