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
    private var showDetail: TraktShow {
        return store.state.tvShowState.traktShows[slug] ?? TraktShow()
    }
    
    private func fetchShowDetails() {
        let showState = store.state.tvShowState
//        if store.state.tvShowState.traktShows[slug] == nil {
//            store.dispatch(action: TVShowActions.FetchTraktShow(slug: slug))
//        }
        if showState.traktShowCast[slug] == nil {
            store.dispatch(action: TVShowActions.FetchFromTraktApi<TraktPeopleResults>(ids: showDetail.ids!, endpoint: .TV_Cast(slug: slug)))
        }
        if showState.traktSeasons[slug] == nil {
            store.dispatch(action: TVShowActions.FetchFromTraktApi<[TraktSeason]>(ids: showDetail.ids!, endpoint: .TV_Seasons(slug: slug), extendedInfo: true))
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
            TVDetailScrollView(showActionSheet: self.$showActionSheet, showVideoPlayer: self.$showVideoPlayer, showDetail: self.showDetail, slug: self.slug)
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
