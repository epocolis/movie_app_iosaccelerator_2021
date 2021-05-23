//
//  FavoritesView.swift
//  MyMovies
//
//  Created by Leotis buchanan on 2021-05-23.
//

import SwiftUI

struct FavoritesView: View {
    
    @FetchRequest(
        entity: SavedMovie.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \SavedMovie.title,
                             ascending:true)
        ]
    ) var savedMovies: FetchedResults<SavedMovie>
    
    
    var favoriteMovies:[Movie] {
        savedMovies.map {
            movie in
            let genreIDs = movie.genres?.components(separatedBy: ",").compactMap(Int.init) ?? []
            
            return Movie(id: Int(movie.id),
                         title:movie.title ?? "",
                         overview: movie.overview ?? "",
                         releaseDate: movie.releaseDate ?? "",
                         voteAverage: movie.voteAverage,
                         posterPath: movie.posterPath ?? "",
                         backdropPath: movie.backdropPath ?? "",
                         genreIds: Set(genreIDs)
                        )
        }
        
    }
    
    
    var body: some View {
        NavigationView {
            List(favoriteMovies, rowContent:MovieRow.init)
            .navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
