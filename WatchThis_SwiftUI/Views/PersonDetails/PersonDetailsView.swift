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
//        if store.state.peopleState.people[personId] == nil {
//            store.dispatch(action: PeopleActions.FetchPersonDetails(id: personId))
//        }
    }
        
    var body: some View {
        DetailView(id: personDetails.ids.tmdb ?? 0, title: personDetails.name ?? "", itemType: .Person, video: nil, imagePath: profilePath, showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer) {
            PersonDetailScrollView(showActionSheet: self.$showActionSheet, personDetails: self.personDetails)
        }
        .onAppear() {
            self.fetchPersonDetails()
        }
    }
}
