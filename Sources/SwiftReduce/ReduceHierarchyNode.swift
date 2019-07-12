public protocol ReduceHierarchyNode {
  /// Reduces the `ReduceHierarchyNode` and its entire reducer hierarchy with
  /// the given action. This should not be implemented by users.
  mutating func _reduceSubtree(with action: Action)
}