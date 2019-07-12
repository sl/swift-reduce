// Credit for this hack goes to: 
// https://stackoverflow.com/questions/47764795/in-swift-4-how-can-you-assign-to-a-keypath-when-the-type-of-the-keypath-and-val

struct WritableKeyPathApplicator<Type> {
  private let applicator: (Type, Any) -> Type
  init<ValueType>(_ keyPath: WritableKeyPath<Type, ValueType>) {
    applicator = {
      var instance = $0
      if let value = $1 as? ValueType {
        instance[keyPath: keyPath] = value
      }
      return instance
    }
  }
  func apply(value: Any, to: Type) -> Type {
    return applicator(to, value)
  }
}