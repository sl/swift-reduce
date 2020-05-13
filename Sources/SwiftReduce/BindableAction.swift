/// An action carrying a single value payload.
///
/// Given a store to read from, such an action con be used to construct a two
/// way SwiftUI `Binding`.
public protocol BindableAction : Action {
  associatedtype Payload
  
  /// Create an instance of the `BindableAction` from its payload.
  static func constructWith(payload: Payload) -> Self
}