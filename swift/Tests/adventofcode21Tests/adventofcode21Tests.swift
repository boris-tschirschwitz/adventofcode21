import XCTest
@testable import adventofcode21

final class swiftTests: XCTestCase {
  func testDay1Part1() {
    let depths = depths(fromData: dataDay1)
    let increases = increases(in: depths)
    XCTAssertEqual(increases, 1387)
    let windowIncreases = windowIncreases(in: depths)
    XCTAssertEqual(windowIncreases, 1362)
  }

  func testDay1Part2() {
    let depths = depths(fromData: dataDay1)
    let windowIncreases = windowIncreases(in: depths)
    XCTAssertEqual(windowIncreases, 1362)
  }

  func testDay2Part1() {
    let (position, depth) = try! navigation(commands: dataDay2)
    XCTAssertEqual(position * depth, 1670340)
  }

  func testDay2Part2() {
    let (position, depth) = try! navigation2(commands: dataDay2)
    XCTAssertEqual(position * depth, 1954293920)
  }
}
