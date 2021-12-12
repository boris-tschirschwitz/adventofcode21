# https://adventofcode.com/2021/day/2

include("aoc_day2_data.jl")

function parseData(data)
    map(line -> split(line, " "), split(data, "\n"))
end

function follow(directions)
    function step(total, command) # total = [position, depth]
        direction = command[1]
        distance = parse(Int, command[2])
        if direction == "forward"
            total[1] += distance
        elseif direction == "up"
            total[2] -= distance
        elseif direction == "down"
            total[2] += distance
        end
        return total
    end

    foldl(step, directions, init = [0, 0])
end

function followAimed(directions)
    function step(total, command) # total = [position, depth, aim]
        direction = command[1]
        distance = parse(Int, command[2])
        if direction == "forward"
            total[1] += distance
            total[2] += distance * total[3]
        elseif direction == "up"
            total[3] -= distance
        elseif direction == "down"
            total[3] += distance
        end
        return total
    end

    foldl(step, directions, init = [0, 0, 0])
end

using Test

# Part 1

@test follow(parseData(testData)) == [15, 10]
@test let commands = parseData(day2Data), traveled = follow(commands)
    traveled[1] * traveled[2] == 1670340
end

# Part 2
@test followAimed(parseData(testData))[1:2] == [15, 60]
@test let commands = parseData(day2Data), traveled = followAimed(commands)
    traveled[1] * traveled[2] == 1954293920
end
