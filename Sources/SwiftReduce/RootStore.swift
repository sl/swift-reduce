import SwiftUI
import Combine

weak var rootStoreRef: _AnyRootStore? = nil

public class _AnyRootStore : ObservableObject {
  
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
  }
  
  public subscript<U>(dynamicMember keyPath: KeyPath<Model, U>) -> U {
    return self.model[keyPath: keyPath]
  }
  
  public subscript<U>(
    _ keyPath: KeyPath<Model, U>,
    _ getAction: @escaping (U) -> Action
  ) -> Binding<U> {
    return Binding(
      get: { return self.model[keyPath: keyPath] },
      set: { value in getAction(value).action() }
    )
  }
  
  public subscript<Bindable>(
    _ keyPath: KeyPath<Model, Bindable.Payload>,
    _ getAction: Bindable
  ) -> Binding<Bindable.Payload> where Bindable : BindableAction {
    return Binding(
      get: { return self.model[keyPath: keyPath] },
      set: { value in Bindable.constructWith(payload: value).action() }
    )
  }
  
  public subscript<U>(_ keyPath: KeyPath<Model, U>) -> Binding<U> {
    return Binding(
      get: { return self.model[keyPath: keyPath] },
      set: { value in }
    )
  }
}

extension ReduceHierarchyNode {
  public func createStore() -> Store<Self> {
    return Store(model: self)
  }
}