# https://adventofcode.com/2021/day/3

include("aoc_day3_data.jl")

function parseData(data::String)::Tuple{Vector{Int}, Int}
    function splitLine(line)
        map(n -> parse(Int, n), collect(line))
    end
    lines = split(data, "\n")
    bits = length(lines[1])
    (map(l -> parse(Int, l, base = 2), lines), bits)
end

function populations(numbers::Vector{Int}, bits::Int)::Vector{Int}
    counts = fill(0, bits)
    for n in numbers
        for i = 0:(bits-1)
            counts[i+1] += (n >> i) % 2
        end
    end
    return counts
end

function rate(test::Function, populations::Vector{Int})::Int
    reduce((total, bit) -> total * 2 + bit, map(test, reverse(populations)), init = 0)
end

function gammaRate(populations::Vector{Int}, bits::Int)::Int
    rate(p -> p > (bits - p), populations)
end

function epsilonRate(populations::Vector{Int}, bits::Int)::Int
    rate(p -> p < (bits - p), populations)
end

function filterBit(test::Function, numbers::Vector{Int}, bit::Int)
    numberOfOnes = sum(map(x -> (x >> bit) % 2, numbers))
    test(numberOfOnes, length(numbers)) ? 1 : 0
end

function eleminationRating(bitCriteria::Function, numbers::Vector{Int}, bits::Int)::Int
    remaining = numbers
    for i = (bits-1):-1:0
        if length(remaining) < 2
            break
        end
        dominant = filterBit(bitCriteria, remaining, i)
        remaining = filter(x -> ((x >> i) % 2) == dominant, remaining)
    end
    return remaining[1]
end

function oxygenGeneratorRating(numbers::Vector{Int}, bits::Int)::Int
    eleminationRating((pop, len) -> pop >= len - pop, numbers, bits)
end

function co2ScrubberRating(numbers::Vector{Int}, bits::Int)::Int
    eleminationRating((pop, len) -> pop < len - pop, numbers, bits)
end

using Test

# Part 1

@test let (numbers, bits) = parseData(testData)
    gammaRate(populations(numbers, bits), length(numbers)) == 22
end
@test let (numbers, bits) = parseData(testData)
    epsilonRate(populations(numbers, bits), length(numbers)) == 9
end
@test let (numbers, bits) = parseData(day3Data), pops = populations(numbers, bits), len = length(numbers)
    gammaRate(pops, len) * epsilonRate(pops, len) == 1131506
end

# Part 2

@test let (numbers, bits) = parseData(testData)
    oxygenGeneratorRating(numbers, bits) == 23
end
@test let (numbers, bits) = parseData(testData)
    co2ScrubberRating(numbers, bits) == 10
end
@test let (numbers, bits) = parseData(day3Data), oxygen = oxygenGeneratorRating(numbers, bits), scrubber = co2ScrubberRating(numbers, bits)
    oxygen * scrubber == 7863147
end
