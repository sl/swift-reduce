// TODO -- Officially decide on `Child` vs `ChildReducer`
@propertyWrapper
public struct Child<Value : Reducer> : _ChildReducerProtocol {
  private var value: Value
  
  public init(wrappedValue: Value) {
    self.value = wrappedValue
  }
  
  public var wrappedValue: Value { 
    get { value }
    set { value = newValue }
  }
  
  mutating func reduceChildWith(action: Action) {
    value._reduceWith(action: action)
  }
}

/// A dummy protocol to allow for type-ignorant forwarding of reduction to the
/// Child's contained reducer.
protocol _ChildReducerProtocol {
  /// Apply the given `Action` to the ChildReducer's wrapped Reducer.
  mutating func reduceChildWith(action: Action)
}