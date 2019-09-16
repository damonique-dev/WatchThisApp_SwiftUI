//
//  ShowOverviewDetailView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ShowOverviewDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    let showDetail: TVShowDetails
    
    private var updatedShowDetail: TVShowDetails {
        return store.state.tvShowState.tvShowDetail[showDetail.id] ?? showDetail
    }
    
    func getRuntime() -> String {
        if let runtime = updatedShowDetail.episodeRunTime?.first {
            return "\(runtime) minutes"
        }
        return ""
    }
    
    func getGenreList() -> String {
        if let genres = updatedShowDetail.genres {
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if updatedShowDetail.overview != nil {
                Text(updatedShowDetail.overview!)
                    .font(.body)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            DetailsLabel(title: "Airs:", detail: updatedShowDetail.lastAirDate)
            DetailsLabel(title: "First Air Date:", detail: updatedShowDetail.firstAirDate)
            DetailsLabel(title: "Number of Seasons:", detail: getNumberStringOf(updatedShowDetail.numberOfSeasons))
            DetailsLabel(title: "Number of Episodes:", detail: getNumberStringOf(updatedShowDetail.numberOfEpisodes))
            DetailsLabel(title: "Runtime:", detail:  getRuntime())
            DetailsLabel(title: "Genres:", detail: getGenreList())
            Spacer()
        }.padding(.horizontal, 8)
    }
}

