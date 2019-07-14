//
//  ContentView.swift
//  SwiftReduceExample
//
//  Created by Sam Lazarus on 7/12/19.
//  Copyright © 2019 Sam Lazarus. All rights reserved.
//

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

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
