# https://adventofcode.com/2021/day/1

include("aoc_day1_data.jl")

function parseData(data::String)::Vector{Int}
    map(x -> parse(Int, x), split(data, "\n"))
end

function countIncreases(depths)
    sum(map(<, depths, depths[2:end]))
end

function windowedDepths(depths)
    map(+, depths, depths[2:end], depths[3:end])
end

using Test

@test parseData(testData) == [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

# Part 1
@test countIncreases(parseData(testData)) == 7
@test countIncreases(parseData(day1Data)) == 1387

# Part 2
@test countIncreases(windowedDepths(parseData(testData))) == 5
@test countIncreases(windowedDepths(parseData(day1Data))) == 1362
