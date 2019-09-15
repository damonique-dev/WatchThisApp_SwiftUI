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
    
    let showDetail: TVShowDetails
    let fetchDetails: Bool
    init(showDetail: TVShowDetails, fetchDetails: Bool = false) {
        self.showDetail = showDetail
        self.fetchDetails = fetchDetails

        if let path = showDetail.posterPath {
            imagePath = path
        }
        if let backgroundPath = showDetail.backdropPath {
            backgroundImagePath = backgroundPath
        }
    }
    
    private var imagePath = ""
    private var backgroundImagePath = ""
    
    private func fetchShowDetails() {
        isFavorite = store.state.tvShowState.favoriteShows.contains(showDetail.id)
        if fetchDetails {
            store.dispatch(action: TVShowActions.FetchTVShowDetails(id: showDetail.id))
        }
    }
        
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            
            VStack {
                TVDetailHeader(showDetail: showDetail, isFavorite: $isFavorite)
                TVDetailScrollView(showDetail: showDetail)
            }
            VStack(alignment: .leading) {
                HStack {
                    FavoriteButton(isFavorite: $isFavorite, action: {
                        self.isFavorite.toggle()
                        if self.isFavorite {
                            self.store.dispatch(action: TVShowActions.AddShowToFavorites(showId: self.showDetail.id))
                        } else {
                            self.store.dispatch(action: TVShowActions.RemoveShowFromFavorites(showId: self.showDetail.id))
                        }
                    })
                    Spacer()
                }.padding(.leading, UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width/6 - 40)
                Spacer()
            }.padding(.top, 310)
            VStack(alignment: .leading) {
                HStack {
                    WatchThisButton(text: "Watch Trailer")
                    Spacer()
                }.padding(.leading, UIScreen.main.bounds.width / 2 + UIScreen.main.bounds.width/6 + 10)
                Spacer()
            }.padding(.top, 310)
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
        TVShowDetailView(showDetail: testTVShowDetail).environmentObject(sampleStore)
    }
}
#endif
