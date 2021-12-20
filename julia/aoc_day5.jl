# https://adventofcode.com/2021/day/5

include("aoc_day5_data.jl")

const Point = CartesianIndex{2}
Point(coords::AbstractVector{Int}) = CartesianIndex{2}(coords[1], coords[2])
const Line = Tuple{Point, Point}
Line(p1::Point, p2::Point) = (p1, p2)

function parseData(data::String)::Vector{Line}
    lines = split(data, "\n")

    function parseLine(line::AbstractString)::Line
        coords = map(match(r"^([0-9]*),([0-9]*) -> ([0-9]*),([0-9]*)", line).captures) do 
            x -> parse(Int, x) + 1
        end
        Line(Point(coords[1:2]), Point(coords[3:4]))
    end

    map(parseLine, lines)
end

function line(a::Point, b::Point)::Vector{Point}
    result = Point[]
    step = Point(sign.(Tuple(b - a)))
    position = a
    while position != b
        push!(result, position)
        position += step
    end
    push!(result, position)
    return result
end

function isMajor(line::Line)::Bool
    (line[1][1] == line[2][1]) || (line[1][2] == line[2][2])
end

function drawLine!(field::Matrix{Int}, a::Point, b::Point)
    coords = line(a, b)
    field[coords] .+= 1
end

function fieldSize(lines::Vector{Line})::Tuple{Int, Int}
    m = (0, 0)
    for line in lines
        for point in line
            m = max.(m, Tuple(point))
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
