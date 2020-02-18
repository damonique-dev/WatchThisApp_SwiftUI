//
//  TVDetailScrollView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

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
    
    private var hasVideo: Bool {
        if let videos = showDetail.videos?.results, !videos.isEmpty {
            return true
        }
        
        return false
    }
    
    private var details: [OverviewDetail] {
        return [
            .init(title: "Next Air Date:", detail: showDetail.nextEpisodeToAir?.airDate),
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
                    DetailHeaderView(showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer, title: showDetail.name, posterPath: showDetail.posterPath, backdropPath: showDetail.backdropPath, itemType: .TVShow, rating: showDetail.voteAverage, hasVideo: hasVideo)
                    DetailOverviewView(title: showDetail.name, overview: showDetail.overview, details: details, posterPath: showDetail.posterPath)
                    if cast.count > 0 {
                        DetailCategoryRow(categoryTitle: "Cast") {
                            ForEach(self.cast) { cast in
                                NavigationLink(destination: PersonDetailsView(personId: cast.id, personName: cast.name)) {
                                    CastCellView(person: cast)
                                }
                            }
                        }
                    }
                    if seasons.count > 0 {
                        DetailCategoryRow(categoryTitle: "Seasons") {
                            ForEach(self.seasons) { season in
                                NavigationLink(destination: SeasonDetailView(showId: self.showDetail.id, seasonId: season.id)) {
                                    SeasonCell(season: season)
                                }
                            }
                        }
                    }
                    if similarShows.count > 0 {
                        DetailCategoryRow(categoryTitle: "Similar Shows") {
                            ForEach(self.similarShows) { show in
                                NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                                    RoundedImageCell(title: show.name, posterPath: show.posterPath, height: CGFloat(125))
                                }
                            }
                        }
                    }
                }
            }
        }.padding(8)
    }
}
