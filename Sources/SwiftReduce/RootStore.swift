import SwiftUI
import Combine

weak var rootStoreRef: _AnyRootStore? = nil

public class _AnyRootStore : BindableObject {
  public var didChange = PassthroughSubject<Void, Never>()
  
  fileprivate init() {}
  
  internal func reduce(with action: Action) {
    fatalError("implemented by subclass")
  }
}

@dynamicMemberLookup
public final class Store<Model : ReduceHierarchyNode> : _AnyRootStore {
  var model: Model
  
  fileprivate init(model: Model) {
    self.model = model
    super.init()
    rootStoreRef = self
  }
  
  override internal func reduce(with action: Action) {
    model._reduceSubtree(with: action)
    didChange.send(())
  }
  
  public subscript<U>(dynamicMember keyPath: KeyPath<Model, U>) -> U {
    return self.model[keyPath: keyPath]
  }
}

extension ReduceHierarchyNode {
  public func createStore() -> Store<Self> {
    return Store(model: self)
  }
}