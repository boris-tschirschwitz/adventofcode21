# https://adventofcode.com/2021/day/3

include("aoc_day3_data.jl")

function parseData(data)
    function splitLine(line)
        map(n -> parse(Int, n), collect(line))
    end
    lines = split(data, "\n")
    bits = length(lines[1])
    (map(l -> parse(Int, l, base = 2), lines), bits)
end

function populations(numbers, bits)
    counts = fill(0, bits)
    for n in numbers
        for i = 0:(bits-1)
            counts[i+1] += (n >> i) % 2
        end
    end
    return counts
end

function rate(test, populations)
    reduce((total, bit) -> total * 2 + bit, map(test, reverse(populations)), init = 0)
end

function gammaRate(populations, count)
    rate(p -> p > (count - p), populations)
end

function epsilonRate(populations, count)
    rate(p -> p < (count - p), populations)
end

function filterBit(test, numbers, bit)
    numberOfOnes = sum(map(x -> (x >> bit) % 2, numbers))
    test(numberOfOnes, length(numbers)) ? 1 : 0
end

function eleminationRating(bitCriteria, numbers, bits)
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

function oxygenGeneratorRating(numbers, bits)
    eleminationRating((pop, len) -> pop >= len - pop, numbers, bits)
end

function co2ScrubberRating(numbers, bits)
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
