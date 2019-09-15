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
            VStack {
                ShowOverviewDetailView(showDetail: showDetail)
                if cast.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Cast")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(cast) { cast in
                                    NavigationLink(destination: PersonDetailsView(personId: cast.id, personName: cast.name)) {
                                        CastCellView(person: cast)
                                    }
                                }
                            }
                        }
                    }.padding(.top, 8)
                }
                if seasons.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Seasons")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(seasons) { season in
                                    SeasonCell(season: season)
                                }
                            }
                        }.padding(8)
                    }.padding(.top, 8)
                }
                if similarShows.count > 0 {
                    VStack(alignment: .leading) {
                        Text("Similar Shows")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        ScrollView(.horizontal) {
                            HStack(spacing: 16.0) {
                                ForEach(similarShows) { show in
                                    NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                                        RoundedImageCell(title: show.name, posterPath: show.posterPath, height: CGFloat(125))
                                    }
                                }
                            }
                        }
                    }.padding(.top, 8)
                }
            }
        }.padding(8)
    }
}
