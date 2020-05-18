public protocol Middleware {
  associatedtype StoreType : Reducer
  
  func modify(action: Action, store: StoreType) -> Action?
  func resultOf(action: Action, store: StoreType)
}