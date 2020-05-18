import SwiftUI

@propertyWrapper
public struct Store<StoreType : Reducer> {
  private weak var storeRef: RootStore<StoreType>?
  
  public init() {
    guard let typedStore = rootStoreRef as? RootStore<StoreType> else {
      fatalError("""
      The root store did not have a model of type \
      \(String(describing: StoreType.self))
      """)
    }
    self.storeRef = typedStore
  }
  
  public init(
    withRoot storeRef: RootStore<StoreType>
  ) {
    self.storeRef = storeRef
  }
  
  public var wrappedValue: StoreType {
    guard let store = storeRef else {
      fatalError("A root store must be created before a store can be read from.")
    }
   return store.model
  }
  
  /// A `Binding` that reads from the `Store` and selects an `Action` to
  /// dispatch on set.
  public subscript<U>(
    _ keyPath: KeyPath<StoreType, U>,
    _ getAction: @escaping (U) -> Action
  ) -> Binding<U> {
    return Binding(
      get: { self.wrappedValue[keyPath: keyPath] },
      set: { value in getAction(value).perform() }
    )
  }
  
  /// A `Binding` that reads from the `Store` which dispatches an `Action`
  /// with a payload on set.
  public subscript<Bindable>(
    _ keyPath: KeyPath<StoreType, Bindable.Payload>,
    _ getAction: Bindable
  ) -> Binding<Bindable.Payload> where Bindable : BindableAction {
    return Binding(
      get: { self.wrappedValue[keyPath: keyPath] },
      set: { value in Bindable.constructWith(payload: value).perform() }
    )
  }
  
  /// A `Binding` that reads from the `Store` which does not dispatch an
  /// `Action` on set.
  public subscript<U>(_ keyPath: KeyPath<StoreType, U>) -> Binding<U> {
    return Binding(
      get: { self.wrappedValue[keyPath: keyPath] },
      set: { value in }
    )
  }
}