# https://adventofcode.com/2021/day/2

include("aoc_day2_data.jl")

const Command = Vector{String}
const Position = Tuple{Int, Int}
Position() = Position((0,0))
const PositionAndAim = Tuple{Int, Int, Int}
PositionAndAim() = PositionAndAim((0,0,0))

function parseData(data::String)::Vector{Command}
    map(line -> split(line, " "), split(data, "\n"))
end

function follow(commands::Vector{Command})::Position
    function step(total::Position, command::Command)::Position
        direction = command[1]
        distance = parse(Int, command[2])
        (position, depth) = total
        if direction == "forward"
            position += distance
        elseif direction == "up"
            depth -= distance
        elseif direction == "down"
            depth += distance
        end
        return (position, depth)
    end

    foldl(step, commands, init = Position())
end

function followAimed(commands::Vector{Command})::PositionAndAim
    function step(total::PositionAndAim, command::Command)
        direction = command[1]
        distance = parse(Int, command[2])
        (position, depth, aim) = total
        if direction == "forward"
            position += distance
            depth += distance * aim
        elseif direction == "up"
            aim -= distance
        elseif direction == "down"
            aim += distance
        end
        return (position, depth, aim)
    end

    foldl(step, commands, init = PositionAndAim())
end

using Test

# Part 1

@test follow(parseData(testData)) == (15, 10)
@test let commands = parseData(day2Data), traveled = follow(commands)
    traveled[1] * traveled[2] == 1670340
end

# Part 2
@test followAimed(parseData(testData))[1:2] == (15, 60)
@test let commands = parseData(day2Data), traveled = followAimed(commands)
    traveled[1] * traveled[2] == 1954293920
end
