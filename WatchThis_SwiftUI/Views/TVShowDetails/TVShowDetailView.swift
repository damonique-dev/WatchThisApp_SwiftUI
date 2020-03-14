//
//  ContentView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/7/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct TVShowDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var showActionSheet = false
    @State private var showVideoPlayer = false
    
    let slug: String
    let showIds: Ids
    private var showDetail: TraktShow? {
        return store.state.traktState.traktShows[slug]
    }
    
    private func fetchShowDetails() {
        let state = store.state.traktState
        if state.traktShows[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<TraktShow>(ids: showIds, endpoint: .TV_Details(slug: slug)))
        }
        if state.traktShowCast[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<TraktPeopleResults>(ids: showIds, endpoint: .TV_Cast(slug: slug)))
        }
        if state.traktSeasons[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<[TraktSeason]>(ids: showIds, endpoint: .TV_Seasons(slug: slug)))
        }
        if state.traktRelatedShows[slug] == nil {
            store.dispatch(action: TraktActions.FetchFromTraktApi<[TraktShow]>(ids: showIds, endpoint: .TV_Related(slug: slug)))
        }
    }
    
    private var posterPath: String? {
        return store.state.traktState.slugImages[slug]?.posterPath
    }
        
    var body: some View {
        DetailView(slug: slug, title: showDetail?.title ?? "", itemType: .TVShow, imagePath: posterPath, trailerPath: showDetail?.trailer, showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer) {
            TVDetailScrollView(showActionSheet: self.$showActionSheet, showVideoPlayer: self.$showVideoPlayer, slug: self.slug)
        }.onAppear() {
            self.fetchShowDetails()
        }
    }
}

#if DEBUG
//struct TVShowDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            TVShowDetailView(showId: testTVShowDetail.id).environmentObject(sampleStore)
//                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
//                .previewDisplayName("iPhone XS Max")
//
////            TVShowDetailView(showId: testTVShowDetail.id).environmentObject(sampleStore)
////                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
////                .previewDisplayName("iPhone SE")
//        }
//    }
//}
#endif
