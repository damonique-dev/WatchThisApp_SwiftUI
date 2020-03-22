//
//  MovieDetailsView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MovieDetailsView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var showActionSheet = false
    @State private var showVideoPlayer = false
    
    let slug: String
    let movieIds: Ids
    private var movieDetails: TraktMovie? {
        return store.state.traktState.traktMovies[slug]
    }
    
    private func fetchMovieDetails() {
        let state = store.state.traktState
        if state.traktMovies[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<TraktMovie>(ids: movieIds, endpoint: .Movie_Details(slug: slug)))
        }
        if state.traktCast[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<TraktPeopleResults>(ids: movieIds, endpoint: .Movie_Cast(slug: slug)))
        }
        if state.traktRelatedShows[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<[TraktMovie]>(ids: movieIds, endpoint: .Movie_Related(slug: slug)))
        }
    }
    
    private var posterPath: String? {
        return store.state.traktState.slugImages[slug]?.posterPath
    }
        
    var body: some View {
        DetailView(slug: slug, title: movieDetails?.title ?? "", itemType: .Movie, imagePath: posterPath, trailerPath: movieDetails?.trailer, showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer) {
            MovieDetailsScrollView(showActionSheet: self.$showActionSheet, showVideoPlayer: self.$showVideoPlayer, slug: self.slug)
        }.onAppear() {
            self.fetchMovieDetails()
        }
    }
}
