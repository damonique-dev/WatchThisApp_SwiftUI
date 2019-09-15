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
    
    let movieDetails: MovieDetails
    let fetchDetails: Bool
    
    init(movieDetails: MovieDetails, fetchDetails: Bool = false) {
        self.movieDetails = movieDetails
        self.fetchDetails = fetchDetails
    }
    
    private func fetchMovieDetails() {
        isFavorite = store.state.movieState.favoriteMovies.contains(movieDetails.id)
        if fetchDetails {
            store.dispatch(action: MovieActions.FetchMovieDetails(id: movieDetails.id))
        }
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: movieDetails.posterPath)
            VStack {
                MovieDetailHeader(isFavorite: $isFavorite, movieDetail: movieDetails)
                MovieDetailsScrollView(movieDetails: movieDetails)
            }
            VStack(alignment: .leading) {
                HStack {
                    FavoriteButton(isFavorite: $isFavorite, action: {
                        self.isFavorite.toggle()
                        if self.isFavorite {
                            self.store.dispatch(action: MovieActions.AddMovieToFavorites(movieId: self.movieDetails.id))
                        } else {
                            self.store.dispatch(action: MovieActions.RemoveMovieFromFavorites(movieId: self.movieDetails.id))
                        }
                    })
                    Spacer()
                }.padding(.leading, UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width/6 - 40)
                Spacer()
            }.padding(.top, 310)
            VStack(alignment: .leading) {
                HStack {
                    WatchThisButton(text: "Watch Trailer")
                    Spacer()
                }.padding(.leading, UIScreen.main.bounds.width / 2 + UIScreen.main.bounds.width/6 + 10)
                Spacer()
            }.padding(.top, 310)
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
        MovieDetailsView(movieDetails: testMovieDetails, fetchDetails: false).environmentObject(sampleStore)
    }
}
#endif
