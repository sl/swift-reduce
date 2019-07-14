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
  
  public subscript<U>(
    _ keyPath: KeyPath<Model, U>,
    _ getAction: @escaping (U) -> Action
  ) -> Binding<U> {
    return Binding(
      getValue: { return self.model[keyPath: keyPath] },
      setValue: { value in getAction(value).action() }
    )
  }
  
  public subscript<U>(_ keyPath: KeyPath<Model, U>) -> Binding<U> {
    return Binding(
      getValue: { return self.model[keyPath: keyPath] },
      setValue: { value in }
    )
  }
}

extension ReduceHierarchyNode {
  public func createStore() -> Store<Self> {
    return Store(model: self)
  }
}