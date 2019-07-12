import SwiftUI
import Combine

weak var rootStoreRef: AnyRootStore? = nil

class AnyRootStore : BindableObject {
  var didChange = PassthroughSubject<Void, Never>()
  
  internal func reduce(with action: Action) {
    fatalError("implemented by subclass")
  }
}

@dynamicMemberLookup
final class Store<Model : ReduceHierarchyNode> : AnyRootStore {
  var model: Model
  
  init(model: Model) {
    self.model = model
    super.init()
    rootStoreRef = self
  }
  
  override internal func reduce(with action: Action) {
    model._reduceSubtree(with: action)
    didChange.send(())
  }
  
  subscript<U>(dynamicMember keyPath: KeyPath<Model, U>) -> U {
    return self.model[keyPath: keyPath]
  }
}