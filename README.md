# SwiftReduce

SwiftReduce is a Redux-like state management system built for SwiftUI!

SwiftReduce is currently extremely experimental, expect lots of changes in the very short term.

### Getting Started

SwiftReduce has a couple of concepts that you need to be familiar with. The most important of theses are the Store, and the Reducer. In SwiftReduce, all your data is a part of one large data structure called the Store. You'll create one of these at the root of your application.

A reducer is a pure function which takes your store, or a piece of your store, and updates it with the given action. In SwiftReduce, we represent reducers as mutating methods on your model types.

### Actions

Actions are data types which represent a change that your reducers can respond to. A single reducer can respond to any type which conforms to the `Action` protocol. When actions are dispatched (by invoking the perform function on them) the framework will start with your root store, and check if it has a reducer which responds to the invoked action. If it does, it will apply the action. Then, it will recursively search all of the fields of that struct for fields marked with `@Child`. If it finds one, it will apply the action on the child reducer.

### A Simple Model using SwiftReduce

```swift
enum NameChange : Action {
  case clear
  case setName(String)
}

struct Person : Reducer {
  var name: String = ""
  
  @Child var favoriteMovies = FavoriteMovies()
  
  func apply(action: NameChange) {
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
  
  func apply(action: UpdateMovies) {
    switch action {
    case let .sawMovie(name):
      movies[name] = movies[name, default: 0] + 1
    case let .removeMovie(name):
      movies.removeValue(forKey: name)
    }
  }
}
```

## A Slightly Less Contrived Example With SwiftUI!

Model code:

```swift
import SwiftReduce

enum NameChange : Action {
  case clear
  case setName(String)
}

struct Person : Reducer {
  var name: String = ""
  
  @Child var favoriteMovies = FavoriteMovies()
  
  func apply(action: NameChange) {
    switch action {
    case .clear: self.name = ""
    case let .setName(name): self.name = name
    }
  }
}

enum UpdateMovies : Action {
  case setInput(String)
  case submit
  case removeMovie(String)
}

struct FavoriteMovies : Reducer {
  var input: String = ""
  var movies: [String : Int] = [:]
  
  func apply(action: UpdateMovies) {
    switch action {
    case let .setInput(name):
      input = name
    case .submit:
      movies[input] = movies[input, default: 0] + 1
      input = ""
    case let .removeMovie(name):
      movies.removeValue(forKey: name)
    }
  }
}
```

View Code:

```swift
import SwiftUI
import SwiftReduce

struct ContentView : View {
  @EnvironmentObject var store: Store<Person>
  
  var body: some View {
    VStack {
      Text(store.name)
      HStack {
        TextField("Enter Name", text: store[\.name, { NameChange.setName($0) }])
        Button("Clear", action: NameChange.clear)
      }
      MoviesView()
    }
    .padding()
  }
}

struct MoviesView : View {
  @EnvironmentObject var store: Store<Person>
  
  var body: some View {
    VStack {
      HStack {
        TextField("Movie Name", text: store[\.favoriteMovies.input, { UpdateMovies.setInput($0) }])
        Button("watch", action: UpdateMovies.submit)
      }
      List(Array(store.favoriteMovies.movies.keys).identified(by: \.self)) {
        MovieView(title: $0, count: self.store.favoriteMovies.movies[$0]!)
      }
    }
  }
}

struct MovieView : View {
  let title: String
  let count: Int
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text("views: \(count)")
    }
    .tapAction(UpdateMovies.removeMovie(title))
  }
}
```

As you can see, a few conveniences have been added to make working with SwiftReduce actions easier! The main ones used here are:

- Most places where closures are taken by SwiftUI, you can instead pass a SwiftReduce `Action` and everything will (eventually) work fine! Currently, only a few such locations have been implemented, but more are being added as the framework develops.
- you can get a `Binding` from your `Store` which publishes SwiftReduce `Action` by subscripting it with a keypath to the value in your store, and giving it a closure which determines which `Action` to publish on changes.

##### Disclaimer

Swift reduce is in no way associated with Apple, the Swift project, or the actual SwiftUI.