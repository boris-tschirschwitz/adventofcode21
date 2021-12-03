//
//  File.swift
//  
//
//  Created by Boris Tschirschwitz on 03.12.21.
//

import Foundation

enum Day2Error: Error {
  case invalidCommend
  case invalidDisplacement
}

enum Direction {
  case forward
  case up
  case down
}

struct Command {
  let direction: Direction
  let distance: Int
  
  init<Text: StringProtocol>(text: Text) throws {
    let parts = text.split(separator: " ")
    guard let distance = Int(parts[1]) else {
      throw Day2Error.invalidDisplacement
    }
    self.distance = distance
    switch(parts[0]) {
    case "forward":
      self.direction = .forward
    case "up":
      self.direction = .up
    case "down":
      self.direction = .down
    default:
      throw Day2Error.invalidCommend
    }
  }
}

/// Navigate following the commands as interpreted in part 1 of day 2 problem
/// see: [Day2](https://adventofcode.com/2021/day/2)
func navigation(commands data: String) throws -> (Int, Int) {
  let commands = data.split(separator: "\n")
  let (position, depth) = try commands.reduce((0,0)) { (positionAndDepth, commandText) in
    let (position, depth) = positionAndDepth
    let command = try Command(text: commandText)
    switch(command.direction) {
    case .forward:
      return (position + command.distance, depth)
    case .up:
      return (position, depth - command.distance)
    case .down:
      return (position, depth + command.distance)
    }
  }
  return (position, depth)
}

/// Navigate following the commands as interpreted in part 2 of day 2 problem
/// see: [Day2](https://adventofcode.com/2021/day/2)
func navigation2(commands data: String) throws -> (Int, Int) {
  let commands = data.split(separator: "\n")
  let (position, depth, _) = try commands.reduce((0, 0, 0)) { (positionAndDepthAndAim, commandText) in
    let (position, depth, aim) = positionAndDepthAndAim
    let command = try Command(text: commandText)
    switch(command.direction) {
    case .forward:
      return (position + command.distance, depth + command.distance * aim, aim)
    case .up:
      return (position, depth, aim - command.distance)
    case .down:
      return (position, depth, aim + command.distance)
    }
  }
  return (position, depth)
}
