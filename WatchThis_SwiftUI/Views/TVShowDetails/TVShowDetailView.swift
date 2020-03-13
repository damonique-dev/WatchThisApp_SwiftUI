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
    private var showDetail: TraktShow {
        return store.state.tvShowState.traktShows[slug] ?? TraktShow()
    }
    
    private func fetchShowDetails() {
        let showState = store.state.tvShowState
        if store.state.tvShowState.traktShows[slug] == nil {
            store.dispatch(action: TVShowActions.FetchFromTraktApi<TraktShow>(ids: showIds, endpoint: .TV_Details(slug: slug)))
        }
        if showState.traktShowCast[slug] == nil {
            store.dispatch(action: TVShowActions.FetchFromTraktApi<TraktPeopleResults>(ids: showIds, endpoint: .TV_Cast(slug: slug)))
        }
        if showState.traktSeasons[slug] == nil {
            store.dispatch(action: TVShowActions.FetchFromTraktApi<[TraktSeason]>(ids: showIds, endpoint: .TV_Seasons(slug: slug)))
        }
        if showState.traktRelatedShows[slug] == nil {
            store.dispatch(action: TVShowActions.FetchFromTraktApi<[TraktShow]>(ids: showIds, endpoint: .TV_Related(slug: slug)))
        }
    }
    
    private var posterPath: String? {
        return store.state.tvShowState.slugImages[slug]?.posterPath
    }
    
    private var video: Video? {
//        if let videos = showDetail.trailer, {
//            return videos[0]
//        }
        
        return nil
    }
        
    var body: some View {
        DetailView(id: 0, title: showDetail.title ?? "", itemType: .TVShow, video: video, imagePath: posterPath, showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer) {
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
