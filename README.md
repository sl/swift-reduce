# SwiftReduce

SwiftReduce is a Redux-like state management system built for SwiftUI!

SwiftReduce is currently extremely experimental, expect lots of changes in the very short term.

## Notes

Currently, much to my shagrin, models in SwiftReduce cannot be represented as structs. This is due to the limitations of the reflection API when manipulating value types. Hopefully, this will change in the future either with some clever Swift hackery (I've tried a lot of things, but maybe something I hadn't thought of will be brought up) or due to a future language feature.

## Getting Started

SwiftReduce has a couple of concepts that you need to be familiar with. The most important of theses are the Store, and the Reducer. In SwiftReduce, all your data is a part of one large data structure called the Store. You'll create one of these as a SwiftUI `EnvironmentObject` at the root view of your application.

A reducer is a pure function which takes your store, or a piece of your store, and updates it with the given action. In SwiftReduce, we represent reducers as methods on your model types.

## Actions

Actions are data types which represent a change that your reducers can respond to. A single reducer can respond to any type which conforms to the `Action` protocol. When actions are dispatched (by invoking the action function on them) the framework will start with your root store, and check if it has a reducer which responds to the invoked action. If it does, it will invoke the reducer. Then, it will recursively search all of the fields of that class for other reducers. If it finds one, it will invoke that reducer.

## A Simple Model using SwiftReduce

```swift
enum NameChange : Action {
  case clear
  case setName(String)
}

final class Person : Reducer {
  var name: String = ""
  var favoriteMovies = FavoriteMovies()
  
  func reduce(action: NameChange) {
    switch action {
    case .clear: self.name = ""
    case let .setName(name): self.name = name
    }
  }
}

enum UpdateMovies : Action {
  case sawMovie(String)
  case removeMovie(String)
}

final class FavoriteMovies : Reducer {
  var movies: [String : Int] = [:]
  
  func reduce(action: UpdateMovies) {
    switch action {
    case let .sawMovie(name):
      movies[name] = movies[name, default: 0] + 1
    case let .removeMovie(name):
      movies.removeValue(forKey: name)
    }
  }
}
```

## Integration with SwiftUI

Will add this section to the README shortly once the example application is complete 🙂