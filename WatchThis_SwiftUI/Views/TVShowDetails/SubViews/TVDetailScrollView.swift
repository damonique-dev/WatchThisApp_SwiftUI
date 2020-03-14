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
    let slug: String
    
    private var showDetail: TraktShow? {
        return store.state.traktState.traktShows[slug]
    }
    private var cast: [TraktCast] {
        return store.state.traktState.traktShowCast[slug] ?? []
    }
    private var similarShows: [TraktShow] {
        return store.state.traktState.traktRelatedShows[slug] ?? []
    }
    private var seasons: [TraktSeason] {
        return store.state.traktState.traktSeasons[slug] ?? []
    }
    
    private func getRuntime() -> String {
        if let runtime = showDetail?.runtime {
            return "\(runtime) minutes"
        }
        return ""
    }
    
    private func getGenreList() -> String {
        if let genres = showDetail?.genres {
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
    
    private func getPosterPath(for show: TraktShow) -> String? {
        return store.state.traktState.slugImages[show.slug!]?.posterPath
    }
    
    private var hasVideo: Bool {
        return showDetail?.trailer != nil
    }
    
    private var posterPath: String? {
        return store.state.traktState.slugImages[slug]?.posterPath
    }
    
    private var backgroundPath: String? {
        return store.state.traktState.slugImages[slug]?.backgroundPath
    }
    
    private var details: [OverviewDetail] {
        return [
            .init(title: "Rating:", detail: showDetail?.certification),
//            .init(title: "Next Air Date:", detail: showDetail.nextEpisodeToAir?.airDate),
            .init(title: "First Air Date:", detail: showDetail?.firstAired?.fromISOtoDateString(format: "EEEE, MMMM d yyyy")),
//            .init(title: "Number of Seasons:", detail: getNumberStringOf(showDetail.numberOfSeasons)),
            .init(title: "Number of Episodes:", detail: getNumberStringOf(showDetail?.airedEpisodes)),
            .init(title: "Runtime:", detail: getRuntime()),
            .init(title: "Genres:", detail: getGenreList()),
        ]
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    DetailHeaderView(showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer, title: showDetail?.title ?? "", posterPath: posterPath, backdropPath: backgroundPath, itemType: .TVShow, rating: showDetail?.rating, hasVideo: hasVideo)
                    DetailOverviewView(title: showDetail?.title, overview: showDetail?.overview, details: details, posterPath: posterPath)
                    if cast.count > 0 {
                        DetailCategoryRow(categoryTitle: "Cast") {
                            ForEach(self.cast) { cast in
                                NavigationLink(destination: PersonDetailsView(personDetails: cast.person)) {
                                    CastCellView(person: cast)
                                }
                            }
                        }
                    }
                    if seasons.count > 0 {
                        DetailCategoryRow(categoryTitle: "Seasons") {
                            ForEach(self.seasons) { season in
                                NavigationLink(destination: SeasonDetailView(showSlug: self.slug, seasonDetails: season)) {
                                    SeasonCell(season: season)
                                }
                            }
                        }
                    }
                    if similarShows.count > 0 {
                        DetailCategoryRow(categoryTitle: "Related Shows") {
                            ForEach(self.similarShows) { show in
                                NavigationLink(destination: TVShowDetailView(slug: show.slug!, showIds: show.ids)) {
                                    RoundedImageCell(title: show.title ?? "", posterPath: self.getPosterPath(for: show), height: CGFloat(125))
                                }
                            }
                        }
                    }
                }
            }
        }.padding(8)
    }
}
