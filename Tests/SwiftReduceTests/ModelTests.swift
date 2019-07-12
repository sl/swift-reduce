import XCTest
@testable import SwiftReduce

private enum XAction : Action {
  case increment
  case decrement
}

private final class X : Model {
  var num: Int = 5
  var y: Y = Y()
  
  func reduce(action: XAction) {
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

private final class Y : Model {
  var num: Int = 10
  
  func reduce(action: YAction) {
    switch action {
    case .increment: num += 1
    case .decrement: num -= 1
    }
  }
}

final class ModelTests: XCTestCase {
  func testBasicReduction() {
    var model = X()
    model._reduceSubtree(with: XAction.increment)
    XCTAssertEqual(model.num, 6, "Basic increment action not correctly applied")
    XCTAssertEqual(model.y.num, 10, "Subtree modified by non-recursive action application")
    model._reduceSubtree(with: XAction.decrement)
    XCTAssertEqual(model.num, 5, "Sequenced decrement action not correct apllied")
    XCTAssertEqual(model.y.num, 10, "Subtree modified by non-recursive action application")
  }
  
  func testRecursiveReduction() {
    var model = X()
    model._reduceSubtree(with: YAction.increment)
    XCTAssertEqual(model.y.num, 11, "Recursive increment action not correctly applied")
  }

  static var allTests = [
    ("testBasicReduction", testBasicReduction),
    ("testRecursiveReduction", testRecursiveReduction),
  ]
}
