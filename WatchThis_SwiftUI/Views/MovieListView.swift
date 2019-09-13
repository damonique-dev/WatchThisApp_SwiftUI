//
//  MovieListView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct MovieListView: View {
     @EnvironmentObject var store: Store<AppState>
    
    private var favoriteMovies: [MovieDetails] {
        let movieState = store.state.movieState
        return movieState.favoriteMovies.compactMap {movieState.movieDetails[$0]}
    }
    
    private var boxOfficeMovies: [MovieDetails] {
        let movieState = store.state.movieState
        return movieState.movieLists[.TopGrossing]?.compactMap {movieState.movieDetails[$0]} ?? [MovieDetails]()
    }
    
    private var trendingMovies: [MovieDetails] {
        let movieState = store.state.movieState
        return movieState.movieLists[.Trending]?.compactMap {movieState.movieDetails[$0]} ?? [MovieDetails]()
    }
            
    func fetchMovieLists() {
        store.dispatch(action: MovieActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_TopGrossing, movieList: .TopGrossing))
        store.dispatch(action: MovieActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_Trending, movieList: .Trending))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
                
                ScrollView(.vertical) {
                    VStack {
                        if !favoriteMovies.isEmpty {
                            MovieCategoryRow(title: "My Movies", movies: favoriteMovies)
                        }
                        MovieCategoryRow(title: "Top Grossing Movies", movies: boxOfficeMovies)
                        MovieCategoryRow(title: "Trending Movies", movies: trendingMovies)
                    }
                }.padding(.vertical, 44)
            }
            .navigationBarTitle(Text("Movies"), displayMode: .inline)
                .onAppear() {
                    self.fetchMovieLists()
            }
        }
    }
}

struct MovieCategoryRow: View {
    let title: String
    let movies: [MovieDetails]
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            HStack {
                Text(title)
                    .font(Font.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(movies, id: \.id) { movie in
//                        NavigationLink(destination: TVShowDetailView(showDetail: show)) {
                            RoundedImageCell(item: movie, height: CGFloat(200))
//                        }
                    }
                }
            }.frame(height: 200)
            Spacer()
        }.padding(.top, 8)
            .padding(.horizontal, 8)
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView().environmentObject(sampleStore)
    }
}
