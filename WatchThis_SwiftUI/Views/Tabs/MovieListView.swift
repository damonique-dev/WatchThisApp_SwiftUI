//
//  MovieListView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MovieListView: View {
     @EnvironmentObject var store: Store<AppState>
    
    private var boxOfficeMovies: [MovieDetails] {
        let movieState = store.state.movieState
        return movieState.movieLists[.TopGrossing]?.compactMap {movieState.movieDetails[$0]} ?? [MovieDetails]()
    }
    
    private var trendingMovies: [MovieDetails] {
        let movieState = store.state.movieState
        return movieState.movieLists[.Trending]?.compactMap {movieState.movieDetails[$0]} ?? [MovieDetails]()
    }
    
    private var mostWatchedWeekly: [MovieDetails] {
        let movieState = store.state.movieState
        return movieState.movieLists[.MostWatchedWeekly]?.compactMap {movieState.movieDetails[$0]} ?? [MovieDetails]()
    }
    
    private var anticipatedMovies: [MovieDetails] {
        let movieState = store.state.movieState
        return movieState.movieLists[.Anticipated]?.compactMap {movieState.movieDetails[$0]} ?? [MovieDetails]()
    }
            
    func fetchMovieLists() {
        store.dispatch(action: MovieActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_TopGrossing, movieList: .TopGrossing))
        store.dispatch(action: MovieActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_Trending, movieList: .Trending))
        store.dispatch(action: MovieActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_MostWatchedWeekly, movieList: .MostWatchedWeekly))
        store.dispatch(action: MovieActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_Anticipated, movieList: .Anticipated))
    }
    
    private var noListsLoaded: Bool {
        return boxOfficeMovies.isEmpty && trendingMovies.isEmpty && mostWatchedWeekly.isEmpty && anticipatedMovies.isEmpty
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
            
            ScrollView(.vertical) {
                VStack {
                    MovieCategoryRow(title: "Top Grossing Movies", movies: boxOfficeMovies)
                    MovieCategoryRow(title: "Trending Movies", movies: trendingMovies)
                    MovieCategoryRow(title: "Most Watched (Weekly)", movies: mostWatchedWeekly)
                    MovieCategoryRow(title: "Anticipated", movies: anticipatedMovies)
                }
            }.padding(.vertical, 44)
            if noListsLoaded {
                ActivitySpinner()
            }
        }
        .navigationBarTitle(Text("Movies"), displayMode: .inline)
        .onAppear() {
            self.fetchMovieLists()
        }
    }
}

struct MovieCategoryRow: View {
    let title: String
    let movies: [MovieDetails]
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            if !movies.isEmpty {
                HStack {
                    Text(title)
                        .font(Font.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(movies, id: \.id) { movie in
                            NavigationLink(destination: MovieDetailsView(movieId: movie.id) ) {
                                RoundedImageCell(title: movie.title, posterPath: movie.posterPath, height: CGFloat(200))
                            }
                        }
                    }
                }.frame(height: 200)
                Spacer()
            }
        }.padding(.top, 8)
            .padding(.horizontal, 8)
    }
}

#if DEBUG
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView().environmentObject(sampleStore)
    }
}
#endif
