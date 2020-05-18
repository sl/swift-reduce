import XCTest
@testable import SwiftReduce

enum MyAction : Action {
  case setToSeven
}

struct MyModel : Reducer {
  var test: Int = 3
  mutating func apply(action: MyAction) {
    switch action {
    case .setToSeven: test = 7
    }
  }
}

private struct X {
  @Store var y: MyModel
}

final class StoreWrapperTests : XCTestCase {
  func testPropertyWrapper() {
    let store = MyModel().createStore()
    usingRootStore(store)
    let someX = X()
    MyAction.setToSeven.perform()
    XCTAssertEqual(store.model.test, someX.y.test) 
  }
  
  static var allTests = [
    ("testPropertyWrapper", testPropertyWrapper)
  ]
}