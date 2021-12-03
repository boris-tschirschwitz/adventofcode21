/// Read the array of dephs from the string of one depth per line.
func depths(fromData data: String) -> [Int] {
  return data.split(separator: "\n").compactMap { Int($0) }
}

/// Counts how often the depth increases from one entry to the next.
/// see: [Day1](https://adventofcode.com/2021/day/1)
func increases(in values: [Int]) -> Int {
  let (increases, _) = values.reduce((0, Int.max)) { (partialAndLast, depth) in
    let (partialIncreases, lastDepth) = partialAndLast
    return ((partialIncreases + ((lastDepth < depth) ? 1 : 0)), depth)
  }
  return increases
}

/// Counts how often the depth increases as sums over three entries.
/// see: [Day1](https://adventofcode.com/2021/day/1)
func windowIncreases(in values: [Int]) -> Int {
  var windowValues = [Int]()
  for i in 0..<(values.count - 2) {
    windowValues.append(values[i] + values[i+1] + values[i+2])
  }
  return increases(in: windowValues)
}
