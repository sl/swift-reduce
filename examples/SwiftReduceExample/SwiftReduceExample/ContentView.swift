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
    @Store var store: Person
    
    var body: some View {
        VStack {
            Text(store.name)
            HStack {
                TextField("Enter Name", text: $store[\.name, { NameChange.setName($0) }])
                Button("Clear", action: NameChange.clear.perform)
            }
            MoviesView()
        }
        .padding()
    }
}

struct MoviesView : View {
    @Store var store: Person
    
    var body: some View {
        VStack {
            HStack {
                TextField("Movie Name", text: $store[\.favoriteMovies.input, { UpdateMovies.setInput($0) }])
                Button("watch", action: UpdateMovies.submit.perform)
            }
            List(Array(store.favoriteMovies.movies.keys), id: \.self) { title in
                MovieView(title: title, count: self.store.favoriteMovies.movies[title]!)
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
        .onTapGesture {
            UpdateMovies.removeMovie(self.title).perform()
        }
    }
}

/*struct ContentView : View {
    @Store var store: Person
    
    var body: some View {
        VStack {
            TextField("Person:", text: $store[\.name, { NameChange.setName($0) }])
            Text("Should match: \(store.name)")
        }
        .padding()
    }
}*/

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
