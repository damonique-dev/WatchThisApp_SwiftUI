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
    
    private var boxOfficeMovies: [TraktMovie] {
        return store.state.traktState.movieLists[.TopGrossing] ?? []
    }
    
    private var trendingMovies: [TraktMovie] {
        return store.state.traktState.movieLists[.Trending] ?? []
    }
    
    private var mostWatchedWeekly: [TraktMovie] {
        return store.state.traktState.movieLists[.MostWatchedWeekly] ?? []
    }
    
    private var anticipatedMovies: [TraktMovie] {
        return store.state.traktState.movieLists[.Anticipated] ?? []
    }
            
    func fetchMovieLists() {
        store.dispatch(action: TraktActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_TopGrossing, movieList: .TopGrossing))
        store.dispatch(action: TraktActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_Trending, movieList: .Trending))
        store.dispatch(action: TraktActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_MostWatchedWeekly, movieList: .MostWatchedWeekly))
        store.dispatch(action: TraktActions.FetchTraktMovieList<[TraktMovieListResults]>(endpoint: .Movie_Anticipated, movieList: .Anticipated))
    }
    
    private var noListsLoaded: Bool {
        return boxOfficeMovies.isEmpty && trendingMovies.isEmpty && mostWatchedWeekly.isEmpty && anticipatedMovies.isEmpty
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
            if noListsLoaded {
                ActivitySpinner()
            } else {
                ScrollView(.vertical) {
                    VStack {
                        MovieCategoryRow(title: "Top Grossing Movies", movies: boxOfficeMovies)
                        MovieCategoryRow(title: "Trending Movies", movies: trendingMovies)
                        MovieCategoryRow(title: "Most Watched (Weekly)", movies: mostWatchedWeekly)
                        MovieCategoryRow(title: "Anticipated", movies: anticipatedMovies)
                    }
                }.padding(.vertical, 44)
            }
        }
        .navigationBarTitle(Text("Movies"), displayMode: .inline)
        .onAppear() {
            self.fetchMovieLists()
        }
    }
}

struct MovieCategoryRow: View {
    @EnvironmentObject var store: Store<AppState>
    let title: String
    let movies: [TraktMovie]
    
    private func getPosterPath(for movie: TraktMovie) -> String? {
        return store.state.traktState.slugImages[movie.slug]?.posterPath
    }
    
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
                            NavigationLink(destination: MovieDetailsView(slug: movie.slug, movieIds: movie.ids) ) {
                                RoundedImageCell(title: movie.title ?? "", posterPath: self.getPosterPath(for: movie), height: CGFloat(200))
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

