//
//  PersonDetailsView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PersonDetailsView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var showActionSheet = false
    @State private var showVideoPlayer = false
    
    let personDetails: TraktPerson
    
    private var profilePath: String? {
        if let tmdbId = personDetails.ids.tmdb {
            return store.state.traktState.traktImages[.Person]?[tmdbId]?.posterPath
        }
        return nil
    }
    
    private func fetchPersonDetails() {
        guard let slug = personDetails.ids.slug else {
            return
        }
        
        if store.state.traktState.personShowCredits[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<TraktCreditsResults>(ids: personDetails.ids, endpoint: .Person_TVCredits(slug: slug)))
        }
        if store.state.traktState.personMovieCredits[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<TraktCreditsResults>(ids: personDetails.ids, endpoint: .Person_MovieCredits(slug: slug)))
        }
    }
        
    var body: some View {
        DetailView(slug: personDetails.ids.slug!, title: personDetails.name ?? "", itemType: .Person, imagePath: profilePath, trailerPath: nil, showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer) {
            PersonDetailScrollView(showActionSheet: self.$showActionSheet, personDetails: self.personDetails)
        }
        .onAppear() {
            self.fetchPersonDetails()
        }
    }
}
