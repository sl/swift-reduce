import XCTest
@testable import SwiftReduce

enum NameChange : Action {
  case clear
  case setName(String)
}

struct Person : Reducer {
  var name: String = ""
  @Child var favoriteMovies = FavoriteMovies()
  
  mutating func apply(action: NameChange) {
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

struct FavoriteMovies : Reducer {
  var movies: [String : Int] = [:]
  
  mutating func apply(action: UpdateMovies) {
    switch action {
    case let .sawMovie(name):
      movies[name] = movies[name, default: 0] + 1
    case let .removeMovie(name):
      movies.removeValue(forKey: name)
    }
  }
}

final class MoviesTests: XCTestCase {
  func testBasicReduction() {
    var model = Person()
    model._reduceWith(action: NameChange.setName("Hello"))
    XCTAssertEqual(model.name, "Hello")
    model._reduceWith(action: NameChange.clear)
    XCTAssertEqual(model.name, "")
  }
  
  func testRecursiveReduction() {
    var model = Person()
    model._reduceWith(action: UpdateMovies.sawMovie("Jaws"))
    XCTAssertEqual(model.favoriteMovies.movies["Jaws"], 1)
    model._reduceWith(action: UpdateMovies.sawMovie("Jaws"))
    XCTAssertEqual(model.favoriteMovies.movies["Jaws"], 2)
  }

  static var allTests = [
    ("testBasicReduction", testBasicReduction),
    ("testRecursiveReduction", testRecursiveReduction),
  ]
}
