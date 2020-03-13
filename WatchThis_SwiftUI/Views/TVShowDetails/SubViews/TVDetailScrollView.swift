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
    let showDetail: TraktShow
    let slug: String
    
    private var cast: [TraktCast] {
        return store.state.tvShowState.traktShowCast[slug] ?? []
    }
    private var similarShows: [TVShowDetails] {
        return []
    }
    private var seasons: [TraktSeason] {
        return store.state.tvShowState.traktSeasons[slug] ?? []
    }
    
    private func getRuntime() -> String {
        if let runtime = showDetail.runtime {
            return "\(runtime) minutes"
        }
        return ""
    }
    
    private func getGenreList() -> String {
        if let genres = showDetail.genres {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    
    private func getNumberStringOf(_ number: Int?) -> String? {
        if let number  = number {
            return "\(number)"
        }
        
        return nil
    }
    
    private var hasVideo: Bool {
        return showDetail.trailer != nil
    }
    
    private var posterPath: String? {
        return store.state.tvShowState.slugImages[slug]?.posterPath
    }
    
    private var backgroundPath: String? {
        return store.state.tvShowState.slugImages[slug]?.backgroundPath
    }
    
    private var details: [OverviewDetail] {
        return [
            .init(title: "Rating:", detail: showDetail.certification),
//            .init(title: "Next Air Date:", detail: showDetail.nextEpisodeToAir?.airDate),
            .init(title: "First Air Date:", detail: showDetail.firstAired?.fromISOtoDateString(format: "EEEE, MMMM d yyyy")),
//            .init(title: "Number of Seasons:", detail: getNumberStringOf(showDetail.numberOfSeasons)),
            .init(title: "Number of Episodes:", detail: getNumberStringOf(showDetail.airedEpisodes)),
            .init(title: "Runtime:", detail: getRuntime()),
            .init(title: "Genres:", detail: getGenreList()),
        ]
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    DetailHeaderView(showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer, title: showDetail.title ?? "", posterPath: posterPath, backdropPath: backgroundPath, itemType: .TVShow, rating: showDetail.rating, hasVideo: hasVideo)
                    DetailOverviewView(title: showDetail.title, overview: showDetail.overview, details: details, posterPath: posterPath)
                    if cast.count > 0 {
                        DetailCategoryRow(categoryTitle: "Cast") {
                            ForEach(self.cast) { cast in
//                                NavigationLink(destination: PersonDetailsView(personId: cast.id, personName: cast.name)) {
                                    CastCellView(person: cast)
//                                }
                            }
                        }
                    }
                    if seasons.count > 0 {
                        DetailCategoryRow(categoryTitle: "Seasons") {
                            ForEach(self.seasons) { season in
//                                NavigationLink(destination: SeasonDetailView(showId: self.showDetail.id, seasonId: season.id)) {
                                    SeasonCell(season: season)
//                                }
                            }
                        }
                    }
                    if similarShows.count > 0 {
                        DetailCategoryRow(categoryTitle: "Similar Shows") {
                            ForEach(self.similarShows) { show in
//                                NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                                    RoundedImageCell(title: show.name, posterPath: show.posterPath, height: CGFloat(125))
//                                }
                            }
                        }
                    }
                }
            }
        }.padding(8)
    }
}
