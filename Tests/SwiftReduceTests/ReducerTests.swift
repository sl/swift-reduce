import XCTest
@testable import SwiftReduce

private enum XAction : Action {
  case increment
  case decrement
}

private struct X : Reducer {
  var num: Int = 5
  @Child var y: Y = Y()
  
  mutating func apply(action: XAction) {
    switch action {
    case .increment: num += 1
    case .decrement: num -= 1
    }
  }
}

private enum YAction : Action {
  case increment
  case decrement
}

private struct Y : Reducer {
  var num: Int = 10
  
  mutating func apply(action: YAction) {
    switch action {
    case .increment: num += 1
    case .decrement: num -= 1
    }
  }
}

final class ReducerTests: XCTestCase {
  func testBasicReduction() {
    var model = X()
    model._reduceWith(action: XAction.increment)
    XCTAssertEqual(model.num, 6, "Basic increment action not correctly applied")
    XCTAssertEqual(model.y.num, 10, "Subtree modified by non-recursive action application")
    model._reduceWith(action: XAction.decrement)
    XCTAssertEqual(model.num, 5, "Sequenced decrement action not correct apllied")
    XCTAssertEqual(model.y.num, 10, "Subtree modified by non-recursive action application")
  }
  
  func testRecursiveReduction() {
    var model = X()
    model._reduceWith(action: YAction.increment)
    XCTAssertEqual(model.y.num, 11, "Recursive increment action not correctly applied")
  }

  static var allTests = [
    ("testBasicReduction", testBasicReduction),
    ("testRecursiveReduction", testRecursiveReduction),
  ]
}
