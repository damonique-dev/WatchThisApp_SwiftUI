//
//  MovieDetailsScrollView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MovieDetailsScrollView: View {
    @EnvironmentObject var store: Store<AppState>
    
    @Binding var showActionSheet: Bool
    @Binding var showVideoPlayer: Bool
    let movieDetails: MovieDetails
    
    private var cast: [Cast] {
        return store.state.movieState.movieDetails[movieDetails.id]?.credits?.cast ?? [Cast]()
    }
    
    private var similarMovies: [MovieDetails] {
        return store.state.movieState.movieDetails[movieDetails.id]?.similar?.results ?? [MovieDetails]()
    }
    
    private var movieRuntime: String? {
        if let runtime = movieDetails.runtime {
            return "\(runtime)"
        }
        return nil
    }
    
    private var movieRevenue: String? {
        if let revenue = movieDetails.revenue {
            return formatLargeCurrency(currency: revenue)
        }
        return nil
    }
    private var details: [OverviewDetail] {
        return [
            .init(title: "Release Date:", detail: movieDetails.releaseDate),
            .init(title: "Runtime:", detail: movieRuntime),
            .init(title: "Revenue:", detail: movieRevenue),
        ]
    }
    
    private var hasVideo: Bool {
        if let videos = movieDetails.videos?.results, !videos.isEmpty {
            return true
        }
        
        return false
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    DetailHeaderView(showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer, title: movieDetails.title, posterPath: movieDetails.posterPath, backdropPath: movieDetails.backdropPath, itemType: .Movie, rating: movieDetails.voteAverage, hasVideo: hasVideo)
                    DetailOverviewView(title: movieDetails.title, overview: movieDetails.overview, details: details, posterPath: movieDetails.posterPath)
//                    if cast.count > 0 {
//                        DetailCategoryRow(categoryTitle: "Cast") {
//                            ForEach(self.cast) { cast in
//                                NavigationLink(destination: PersonDetailsView(personId: cast.id, personName: cast.name)) {
//                                    CastCellView(person: cast)
//                                }
//                            }
//                        }
//                    }
//                    if similarMovies.count > 0 {
//                        DetailCategoryRow(categoryTitle: "Similar Movies") {
//                            ForEach(self.similarMovies) { movie in
//                                NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
//                                    RoundedImageCell(title: movie.title, posterPath: movie.posterPath, height: CGFloat(125))
//                                }
//                            }
//                        }
//                    }
                }
            }
        }.padding(8)
    }
}
