//
//  PersonDetailScrollView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PersonDetailScrollView: View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var showActionSheet: Bool
    let personDetails: TraktPerson
    
    private var tvCredits: [TraktCredits] {
        guard let slug = personDetails.ids.slug else {
            return []
        }
        return store.state.traktState.personShowCredits[slug] ?? []
    }
    
    private var movieCredits: [TraktCredits] {
        guard let slug = personDetails.ids.slug else {
            return []
        }
        return store.state.traktState.personMovieCredits[slug] ?? []
    }
    
    private var profilePath: String? {
        return store.state.traktState.slugImages[personDetails.slug]?.posterPath
    }
    
    private func creditPosterPath(credit: TraktCredits, itemType: ItemType) -> String? {
        if itemType == .TVShow {
            if let showSlug = credit.show?.slug {
                return store.state.traktState.slugImages[showSlug]?.posterPath
            }
        }
        if itemType == .Movie {
            if let movieSlug = credit.movie?.slug {
                return store.state.traktState.slugImages[movieSlug]?.posterPath
            }
        }
        return nil
    }
    
    private func getEpisodeCountText(credit: TraktCredits) -> String {
        let count = credit.episodeCount ?? 0
        return count == 1 ? "1 Episode" : "\(count) Episodes"
    }
    
    private var firstCreditBackdrop: String? {
//        if !(personDetails.movieCredits?.cast?.isEmpty ?? false) {
//            let firstCredit = personDetails.movieCredits?.cast![0]
//            return firstCredit?.backdropPath
//        }
//        if !(personDetails.tvCredits?.cast?.isEmpty ?? false) {
//            let firstCredit = personDetails.tvCredits?.cast![0]
//            return firstCredit?.backdropPath
//        }
        
        // TODO: Add placeholder if person has no tv or movie credits
        return nil
    }
    
    private var details: [OverviewDetail] {
        return [
            .init(title: "Birthday:", detail: personDetails.birthday),
            .init(title: "Deathday:", detail: personDetails.death),
            .init(title: "Place of Birth:", detail: personDetails.birthplace)
        ]
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    DetailHeaderView(showActionSheet: $showActionSheet, showVideoPlayer: .constant(false), title: personDetails.name ?? "", posterPath: profilePath, backdropPath: firstCreditBackdrop, itemType: .Person, rating: nil, hasVideo: false)
                    DetailOverviewView(title: personDetails.name, overview: personDetails.biography, details: details, posterPath: profilePath)
                    if tvCredits.count > 0 {
                        DetailCategoryRow(categoryTitle: "TV Credits") {
                            ForEach(self.tvCredits) { credit in
                                if credit.show != nil {
                                    NavigationLink(destination: TVShowDetailView(slug: credit.show!.slug, showIds: credit.show!.ids)) {
                                        PersonCreditCell(posterPath: self.creditPosterPath(credit: credit, itemType: .TVShow), imageText: credit.show!.title, title: self.getEpisodeCountText(credit: credit), subTitle: credit.character)
                                    }
                                }
                            }
                        }
                    }
                    if movieCredits.count > 0 {
                        DetailCategoryRow(categoryTitle: "Movie Credits") {
                            ForEach(self.movieCredits) { credit in
                                if credit.movie != nil {
                                    NavigationLink(destination: MovieDetailsView(slug: credit.movie!.slug, movieIds: credit.movie!.ids)) {
                                        PersonCreditCell(posterPath: self.creditPosterPath(credit: credit, itemType: .Movie), imageText: credit.movie!.title, title: "", subTitle: credit.character)
                                    }
                                }
                            }
                        }
                    }
                }.padding(8)
            }
        }.padding(8)
    }
}
