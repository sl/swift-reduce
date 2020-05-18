import SwiftUI
import Combine

weak var rootStoreRef: _AnyRootStore? = nil

public func usingRootStore<Model : Reducer>(_ rootStore: RootStore<Model>) {
  rootStoreRef = rootStore
}

public class _AnyRootStore : ObservableObject {
  
  fileprivate init() {}
  
  internal func reduceWith(action: Action) {
    fatalError("implemented by subclass")
  }
}

public final class RootStore<Model : Reducer> : _AnyRootStore {
  public private(set) var model: Model
  
  fileprivate init(model: Model) {
    self.model = model
    super.init()
    rootStoreRef = self
  }
  
  override internal func reduceWith(action: Action) {
    model._reduceWith(action: action)
    objectWillChange.send()
  }
}

extension Reducer {
  public func createStore() -> RootStore<Self> {
    return RootStore(model: self)
  }
}