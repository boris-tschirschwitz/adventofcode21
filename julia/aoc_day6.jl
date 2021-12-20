# https://adventofcode.com/2021/day/5

include("aoc_day6_data.jl")

function parseData(data::String)::Vector{Int}
    fish = map(split(data, ",")) do x
        parse(Int, x)        
    end
    ages = zeros(Int, 9)
    for f in fish
        ages[f+1] += 1
    end
    return ages
end

# let's not do an in-place modifying step function, we can't go that many steps anyways
function step(ages::Vector{Int})::Vector{Int}
    newAges = zeros(Int, 9)
    for i in 1:8
        newAges[i] = ages[i+1]
    end
    newAges[9] = ages[1]
    newAges[7] += ages[1]

    return newAges
end

function wait(days::Int, ages::Vector{Int})::Vector{Int}
    for _ in 1:days
        ages = step(ages)
    end
    ages
end

using Test

# Part 1

@test let ages = parseData(testData), ages = wait(80, ages)
    sum(ages) == 5934
end

@test let ages = parseData(day6Data), ages = wait(80, ages)
    sum(ages) == 365862
end

# Part 2

@test let ages = parseData(testData), ages = wait(256, ages)
    sum(ages) == 26984457539
end

@test let ages = parseData(day6Data), ages = wait(256, ages)
    sum(ages) == 1653250886439
end
