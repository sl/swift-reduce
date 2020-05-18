import Foundation

public protocol Action {
  /// Get the `Action` as a SwiftUI compatible action closure for use anywhere
  /// SwiftUI expects an action.
  func perform()
}

extension Action {
  public func perform() {
    if Thread.isMainThread {
      rootStoreRef?.reduceWith(action: self)
    } else {
      DispatchQueue.main.async {
        rootStoreRef?.reduceWith(action: self)
      }
    }
  }
}

public struct NeverReduced : Action {
  internal init() {}
}