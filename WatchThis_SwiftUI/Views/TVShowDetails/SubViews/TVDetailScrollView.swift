//
//  TVDetailScrollView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TVDetailScrollView: View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var showActionSheet: Bool
    @Binding var showVideoPlayer: Bool
    let showDetail: TVShowDetails
    
    private var cast: [Cast] {
        return store.state.tvShowState.tvShowDetail[showDetail.id]?.credits?.cast ?? []
    }
    private var similarShows: [TVShowDetails] {
        return store.state.tvShowState.tvShowDetail[showDetail.id]?.similar?.results ?? []
    }
    private var seasons: [Season] {
        return store.state.tvShowState.tvShowDetail[showDetail.id]?.seasons ?? []
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    TVDetailHeader(showDetail: showDetail)
                    ShowOverviewDetailView(showDetail: showDetail)
                    if cast.count > 0 {
                        CastRow(cast: cast)
                    }
                    if seasons.count > 0 {
                        TVSeasonsRow(seasons: seasons, showId: showDetail.id)
                    }
                    if similarShows.count > 0 {
                        TVSimilarShowsRow(similarShows: similarShows)
                    }
                }
                CustomListButtonView(showActionSheet: $showActionSheet)
                WatchTrailerButton(action: {self.showVideoPlayer.toggle()})
            }
        }.padding(8)
    }
}
