import Runtime

/// A value which specifies the ways in which it reacts to changes specified
/// by `Actions`. Expects it and its children to have reference semantics.
///
/// Unfortunately, we can't leverage value semantics due to limitations
/// with the way reflection on value semantic types works. Hopefully
/// that will change in the future.
public protocol Reducer {
  associatedtype RespondsTo : Action = NeverReduced
  
  /// Updates the `Reducer` with the change associated with the given
  /// `Action` that the `Reducer` responds to.
  mutating func apply(action: RespondsTo)
  
  /// Reduces the `Reducer` with the given `Action`. This allows the model to
  /// respond to any `Action` which reaches its depth in the reducer hierarchy.
  ///
  /// Has a default implementation which calls reduce if the action passed
  /// is a `RespondsTo`. Implementing this should be generally avoided
  /// by users but may be used in few advanced use cases.
  mutating func _applyAny(action: Action)
  
  /// Recursively call all reducers in all children of the `Reducer`.
  ///
  /// Has a default implementation which does this via reflection.
  mutating func _applyToChildren(action: Action)
}

extension Reducer {
  public mutating func _applyToChildren(action: Action) {
    let fieldNames = Mirror(reflecting: self).children.compactMap { $0.label }
    for fieldName in fieldNames {
      // Use the Swift runtime to mutate the field with the given name
      // in place inside the reducer.
      let info = try! typeInfo(of: Self.self)
      let property = try! info.property(named: fieldName)
      
      guard var reducerChild = try! property.get(from: self)
        as? _ChildReducerProtocol else { continue }
      
      reducerChild._applyAny(action: action)
      try! property.set(value: reducerChild, on: &self)
    }
  }
  
  public mutating func _applyAny(action: Action) {
    guard let respondableAction = action as? RespondsTo else { return }
    apply(action: respondableAction)
  }
  
  public mutating func _reduceSubtree(with action: Action) {
    _applyAny(action: action)
    _applyToChildren(action: action)
  }
}