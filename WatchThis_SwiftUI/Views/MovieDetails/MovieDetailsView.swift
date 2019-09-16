//
//  MovieDetailsView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct MovieDetailsView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var isFavorite = false
    
    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId        
    }
    
    private var movieDetails: MovieDetails {
        return store.state.movieState.movieDetails[movieId] ?? MovieDetails(id: movieId, title: "")
    }
    
    private func fetchMovieDetails() {
        if store.state.movieState.movieDetails[movieId] == nil {
            store.dispatch(action: MovieActions.FetchMovieDetails(id: movieDetails.id))
        }
        
        isFavorite = store.state.movieState.favoriteMovies.contains(movieDetails.id)
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: movieDetails.posterPath)
            VStack {
                MovieDetailsScrollView(isFavorite: $isFavorite, movieDetails: movieDetails)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(movieDetails.title)"))
        .onAppear() {
            self.fetchMovieDetails()
        }
    }
}

#if DEBUG
struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movieId: testMovieDetails.id).environmentObject(sampleStore)
    }
}
#endif
