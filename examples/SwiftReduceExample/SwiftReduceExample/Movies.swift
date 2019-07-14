//
//  Movies.swift
//  SwiftReduceExample
//
//  Created by Sam Lazarus on 7/13/19.
//  Copyright © 2019 Sam Lazarus. All rights reserved.
//

import SwiftReduce

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
    case setInput(String)
    case submit
    case removeMovie(String)
}

final class FavoriteMovies : Reducer {
    var input: String = ""
    var movies: [String : Int] = [:]
    
    func reduce(action: UpdateMovies) {
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
