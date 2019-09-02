//
//  ShowHomeView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ShowHomeView: View {
    @EnvironmentObject var store: Store<AppState>
    
    private var popularShows: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.tvLists[.Popular]?.compactMap {showState.tvShowDetail[$0]} ?? [TVShowDetails]()
    }
    
    private var trendingShows: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.tvLists[.Trending]?.compactMap {showState.tvShowDetail[$0]} ?? [TVShowDetails]()
    }
    
    private var favoriteShows: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.favoriteShows.compactMap {showState.tvShowDetail[$0]} 
    }
            
    func fetchShowLists() {
        store.dispatch(action: TVShowActions.FetchTraktPopularShowList(endpoint: .TV_Popular, showList: .Popular))
        store.dispatch(action: TVShowActions.FetchTraktTrendingShowList(endpoint: .TV_Trending, showList: .Trending))
        store.dispatch(action: TVShowActions.FetchShowDetailsFromIds(idList: store.state.tvShowState.favoriteShows))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
                
                ScrollView(.vertical) {
                    VStack {
                        if !favoriteShows.isEmpty {
                            CategoryRow(title: "My Shows", shows: favoriteShows)
                        }
                        CategoryRow(title: "Trending Shows", shows: trendingShows)
                        CategoryRow(title: "Popular Shows", shows: popularShows)
                    }
                }
                .padding(.vertical, 44)                
            }
            .navigationBarTitle(Text("Hot Shows"), displayMode: .inline)
            .onAppear() {
                self.fetchShowLists()
            }
        }
    }
}

struct CategoryRow: View {
    let title: String
    let shows: [TVShowDetails]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(Font.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(shows, id: \.id) { show in
                        NavigationLink(destination: TVShowDetailView(showDetail: show)) {
                            ShowCell(tvShow: show, height: CGFloat(200))
                        }
                    }
                }
            }.frame(height: 200)
            Spacer()
        }.padding(.top, 8)
            .padding(.horizontal, 8)
    }
}

#if DEBUG
struct ShowHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ShowHomeView().environmentObject(sampleStore)
    }
}
#endif
