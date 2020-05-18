import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(ReducerTests.allTests),
    testCase(MoviesTests.allTests),
    testCase(StoreWrapperTests.allTests),
  ]
}
#endif
