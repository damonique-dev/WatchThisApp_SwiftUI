//
//  ContentView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/7/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TVShowDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var isFavorite = false
    @State private var selectedTab = 0
    
    let showId: Int
    
    private var imagePath: String {
        return store.state.tvShowState.tvShowDetail[showId]?.posterPath ?? ""
    }
    private var backgroundImagePath: String {
        return store.state.tvShowState.tvShowDetail[showId]?.backdropPath ?? ""
    }
    private var showDetail: TVShowDetails {
        return store.state.tvShowState.tvShowDetail[showId] ?? TVShowDetails(id: showId, name: "")
    }
    
    private func fetchShowDetails() {
        if store.state.tvShowState.tvShowDetail[showId] == nil {
            store.dispatch(action: TVShowActions.FetchTVShowDetails(id: showId))
        }
        isFavorite = store.state.tvShowState.favoriteShows.contains(showDetail.id)
    }
        
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            
            VStack {
                TVDetailScrollView(isFavorite: $isFavorite,showDetail: showDetail)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(showDetail.name)"))
        .onAppear() {
            self.fetchShowDetails()
        }
    }
}

#if DEBUG
struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailView(showId: testTVShowDetail.id).environmentObject(sampleStore)
    }
}
#endif
