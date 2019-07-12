/// A value which specifies the ways in which it reacts to changes specified
/// by `Actions`. Expects it and its children to have reference semantics.
///
/// Unfortunately, we can't leverage value semantics due to limitations
/// with the way reflection on value semantic types works. Hopefully
/// that will change in the future.
public protocol Reducer : ReduceHierarchyNode, KeyPathListable {
  associatedtype RespondsTo : Action = NeverDispatched
  
  /// Updates the `Reducer` with the change associated with the given
  /// `Action` that the `Reducer` responds to.
  ///
  /// Has a default implementation that does nothing.
  mutating func reduce(action: RespondsTo)
  
  /// Reduces the `Reducer` with the given `Action`. This allows the model to
  /// respond to any `Action` which reaches its depth in the reducer hierarchy.
  ///
  /// Has a default implementation which calls reduce if the action passed
  /// is a `RespondsTo`. Implementing this should be generally avoided
  /// by users but may be used in few advanced use cases.
  mutating func attemptReduceWithAny(action: Action)
  
  /// Recursively call all reducers in all children of the `Reducer`.
  ///
  /// Has a default implementation which does this via reflection.
  /// This should almost always be called from within `globallyReduce(with:)`.
  mutating func reduceChildren(with action: Action)
}

extension Reducer {
  public mutating func reduceChildren(with action: Action) {
    for path in self.allKeyPaths {
      guard var reducerChild = self[keyPath: path] as? ReduceHierarchyNode else { continue }
      reducerChild._reduceSubtree(with: action)
    }
  }
  
  public mutating func reduce(action: RespondsTo) {}
  
  public mutating func attemptReduceWithAny(action: Action) {
    guard let respondableAction = action as? RespondsTo else { return }
    reduce(action: respondableAction)
  }
  
  public mutating func _reduceSubtree(with action: Action) {
    attemptReduceWithAny(action: action)
    reduceChildren(with: action)
  }
}

class AnyReduceHierarchyNode : ReduceHierarchyNode {
 func _reduceSubtree(with action: Action) {
   fatalError("should be overridden")
 }
 
 var _keyPathReadableFormat: [String: Any] {
   fatalError("should be overridden")
 }
 var allKeyPaths: [KeyPath<Self, Any?>] {
   fatalError("should be overridden")
 }
}

final class AnyReduceHierarchyNodeBox<
  Concrete : ReduceHierarchyNode
> : AnyReduceHierarchyNode {
  var base: Concrete
  
  init(_ base: Concrete) {
    self.base = base
  }
  
  override func _reduceSubtree(with action: Action) {
    base._reduceSubtree(with: action)
  }
}