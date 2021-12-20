# https://adventofcode.com/2021/day/4

include("aoc_day4_data.jl")

const Board = Matrix{Int}

function parseData(data::String)::Tuple{Vector{Int},Vector{Board}} # (draws, boards)
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

function mark!(board::Board, draw::Int)
    markindices = findall(x -> x == draw, board)
    board[markindices] .= -1
end

function bingo(board::Board)::Bool
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

function bingoStep(boards::Vector{Board}, draw::Int)::Vector{Board}
    map(b -> mark!(b, draw), boards)
    bingos = map(bingo, boards)
    return boards[bingos]
end

function runBingo(boards::Vector{Board}, draws::Vector{Int})::Tuple{Int,Board}
    for draw in draws
        bingos = bingoStep(boards, draw)
        if !isempty(bingos)
            return (draw, bingos[1])
        end
    end
end

function sumBoard(board::Board)::Int
    reduce((total, x) -> total + max(x, 0), board, init = 0)
end

function findLast(boards::Vector{Board}, draws::Vector{Int})::Tuple{Int,Board}
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
