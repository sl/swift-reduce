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
    case setInput(String)
    case submit
    case removeMovie(String)
}

struct FavoriteMovies : Reducer {
    var input: String = ""
    var movies: [String : Int] = [:]
    
    mutating func apply(action: UpdateMovies) {
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
