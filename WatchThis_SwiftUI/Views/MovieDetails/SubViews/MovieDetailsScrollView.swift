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
    let slug: String

    private var movieDetails: TraktMovie? {
        return store.state.traktState.traktMovies[slug]
    }
    
    private var cast: [TraktCast] {
        return store.state.traktState.traktCast[slug] ?? []
    }
    
    private var similarMovies: [TraktMovie] {
        return store.state.traktState.traktRelatedMovies[slug] ?? []
    }
    
    private var movieRuntime: String? {
        if let runtime = movieDetails?.runtime {
            return "\(runtime) minutes"
        }
        return nil
    }

    private var details: [OverviewDetail] {
        return [
            .init(title: "Rated:", detail: movieDetails?.certification),
            .init(title: "Release Date:", detail: movieDetails?.released),
            .init(title: "Runtime:", detail: movieRuntime),
        ]
    }
    
    private var posterPath: String? {
        return store.state.traktState.slugImages[slug]?.posterPath
    }
    
    private var backgroundPath: String? {
        return store.state.traktState.slugImages[slug]?.backgroundPath
    }
    
    private var hasVideo: Bool {
        return movieDetails?.trailer != nil
    }
    
    private func getPosterPath(for show: TraktMovie) -> String? {
        return store.state.traktState.slugImages[show.slug]?.posterPath
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    DetailHeaderView(showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer, title: movieDetails?.title ?? "", posterPath: posterPath, backdropPath: backgroundPath, itemType: .Movie, rating: movieDetails?.rating, hasVideo: hasVideo)
                    DetailOverviewView(title: movieDetails?.title, overview: movieDetails?.overview, details: details, posterPath: posterPath)
                    if cast.count > 0 {
                        DetailCategoryRow(categoryTitle: "Cast") {
                            ForEach(self.cast) { cast in
                                NavigationLink(destination: PersonDetailsView(personDetails: cast.person)) {
                                    CastCellView(person: cast)
                                }
                            }
                        }
                    }
                    if similarMovies.count > 0 {
                        DetailCategoryRow(categoryTitle: "Similar Movies") {
                            ForEach(self.similarMovies) { movie in
                                NavigationLink(destination: MovieDetailsView(slug: movie.slug, movieIds: movie.ids)) {
                                    RoundedImageCell(title: movie.title ?? "", posterPath: self.getPosterPath(for: movie), height: CGFloat(125))
                                }
                            }
                        }
                    }
                }
            }
        }.padding(8)
    }
}
