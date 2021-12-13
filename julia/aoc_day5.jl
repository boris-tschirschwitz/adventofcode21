# https://adventofcode.com/2021/day/3

include("aoc_day5_data.jl")

function parseData(data)
    lines = split(data, "\n")

    function parseLine(line)
        coordPairs = split(line, " -> ")

        function parsePoint(point)
            map(x -> parse(Int, x), split(point, ","))
        end

        map(parsePoint, coordPairs)
    end

    map(parseLine, lines)
end

function line(a, b)
    result = CartesianIndex{2}[]
    step = sign.(b .- a)
    position = a
    while position != b
        push!(result, CartesianIndex(position[1] + 1, position[2] + 1))
        position .+= step
    end
    push!(result, CartesianIndex(position[1] + 1, position[2] + 1))
    return result
end

function isMajor(line)
    (line[1][1] == line[2][1]) || (line[1][2] == line[2][2])
end

function drawLine!(field, a, b)
    coords = line(a, b)
    field[coords] .+= 1
end

function fieldSize(lines)
    m = [0, 0]
    for line in lines
        for point in line
            m = max.(m, point)
        end
    end
    return m .+ 1
end

using Test

# Part 1

@test let data = parseData(testData), fs = fieldSize(data), field = fill(0, fs...)
    for line in filter(isMajor, data)
        drawLine!(field, line...)
    end
    sum(field .> 1) == 5
end

@test let data = parseData(day5Data), fs = fieldSize(data), field = fill(0, fs...)
    for line in filter(isMajor, data)
        drawLine!(field, line...)
    end
    sum(field .> 1) == 6687
end

# Part 2

@test let data = parseData(testData), fs = fieldSize(data), field = fill(0, fs...)
    for line in data
        drawLine!(field, line...)
    end
    sum(field .> 1) == 12
end

@test let data = parseData(day5Data), fs = fieldSize(data), field = fill(0, fs...)
    for line in data
        drawLine!(field, line...)
    end
    sum(field .> 1) == 19851
end
