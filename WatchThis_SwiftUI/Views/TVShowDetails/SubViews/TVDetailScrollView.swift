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
    
    func getRuntime() -> String {
        if let runtime = showDetail.episodeRunTime?.first {
            return "\(runtime) minutes"
        }
        return ""
    }
    
    func getGenreList() -> String {
        if let genres = showDetail.genres {
            return genres.map({$0.name!}).joined(separator: ", ")
        }
        return ""
    }
    
    func getNumberStringOf(_ number: Int?) -> String? {
        if let number  = number {
            return "\(number)"
        }
        
        return nil
    }
    
    private var details: [OverviewDetail] {
        return [
            .init(title: "Airs:", detail: showDetail.lastAirDate),
            .init(title: "First Air Date:", detail: showDetail.firstAirDate),
            .init(title: "Number of Seasons:", detail: getNumberStringOf(showDetail.numberOfSeasons)),
            .init(title: "Number of Episodes:", detail: getNumberStringOf(showDetail.numberOfEpisodes)),
            .init(title: "Runtime:", detail: getRuntime()),
            .init(title: "Genres:", detail: getGenreList()),
        ]
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    DetailHeaderView(title: showDetail.name, posterPath: showDetail.posterPath, backdropPath: showDetail.backdropPath)
                    DetailOverviewView(overview: showDetail.overview, details: details)
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
