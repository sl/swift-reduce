import Foundation

public protocol Action {
  /// Any side effects the action should have. These will be run before the
  /// action occurs, and can be asynchronous.
  func sideEffect()
  
  /// Forcibly dispatch the action. This should ony be used to report the
  /// results of sideEffects.
  func forceDispatch()
  
  /// Get the `Action` as a SwiftUI compatible action closure for use anywhere
  /// SwiftUI expects an action.
  func action()
}

extension Action {
  public func action() {
    sideEffect()
    forceDispatch()
  }
  
  public func forceDispatch() {
    if Thread.isMainThread {
      rootStoreRef?.reduce(with: self)
    } else {
      DispatchQueue.main.async {
        rootStoreRef?.reduce(with:self)
      }
    }
  }
  
  public func sideEffect() {}
}

public struct NeverDispatched : Action {
  private init() {}
}