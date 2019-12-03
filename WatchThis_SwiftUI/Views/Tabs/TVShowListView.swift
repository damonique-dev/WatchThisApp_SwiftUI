//
//  ShowHomeView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct TVShowListView: View {
    @EnvironmentObject var store: Store<AppState>
    
    private var popularShows: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.tvLists[.Popular]?.compactMap {showState.tvShowDetail[$0]} ?? [TVShowDetails]()
    }
    
    private var trendingShows: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.tvLists[.Trending]?.compactMap {showState.tvShowDetail[$0]} ?? [TVShowDetails]()
    }
    
    private var mostWatched: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.tvLists[.MostWatchedWeekly]?.compactMap {showState.tvShowDetail[$0]} ?? [TVShowDetails]()
    }
    
    private var anticipatedShows: [TVShowDetails] {
        let showState = store.state.tvShowState
        return showState.tvLists[.Anticipated]?.compactMap {showState.tvShowDetail[$0]} ?? [TVShowDetails]()
    }
            
    func fetchShowLists() {
        store.dispatch(action: TVShowActions.FetchTraktShowList<[TraktList]>(endpoint: .TV_Popular, showList: .Popular))
        store.dispatch(action: TVShowActions.FetchTraktShowList<[TraktShowListResults]>(endpoint: .TV_Trending, showList: .Trending))
        store.dispatch(action: TVShowActions.FetchTraktShowList<[TraktShowListResults]>(endpoint: .TV_MostWatchedWeekly, showList: .MostWatchedWeekly))
        store.dispatch(action: TVShowActions.FetchTraktShowList<[TraktShowListResults]>(endpoint: .TV_Anticipated, showList: .Anticipated))
    }
    
    private var noListsLoaded: Bool {
        return popularShows.isEmpty && trendingShows.isEmpty && mostWatched.isEmpty && anticipatedShows.isEmpty
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
            
            ScrollView(.vertical) {
                VStack {
                    TVCategoryRow(title: "Trending Shows", shows: trendingShows)
                    TVCategoryRow(title: "Popular Shows", shows: popularShows)
                    TVCategoryRow(title: "Most Watched (weekly)", shows: mostWatched)
                    TVCategoryRow(title: "Anticipated Shows", shows: anticipatedShows)
                }
            }.padding(.vertical, 44)
            if noListsLoaded {
                ActivitySpinner()
            }
        }
        .navigationBarTitle(Text("Hot Shows"), displayMode: .inline)
        .onAppear() {
            self.fetchShowLists()
        }
    }
}

struct TVCategoryRow: View {
    let title: String
    let shows: [TVShowDetails]
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            if !shows.isEmpty {
                HStack {
                    Text(title)
                        .font(Font.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(shows, id: \.id) { show in
                            NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                                RoundedImageCell(title: show.name, posterPath: show.posterPath, height: CGFloat(200))
                            }
                        }
                    }
                }.frame(height: 200)
                Spacer()
            }
        }.padding(.top, 8)
            .padding(.horizontal, 8)
    }
}

#if DEBUG
struct ShowHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowListView().environmentObject(sampleStore)
    }
}
#endif
