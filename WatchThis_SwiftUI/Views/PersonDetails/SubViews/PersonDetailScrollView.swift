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
    let personDetails: PersonDetails
    
    private var tvCredits: [PersonCredit] {
        return personDetails.tvCredits?.cast ?? []
    }
    
    private var movieCredits: [PersonCredit] {
        return personDetails.movieCredits?.cast ?? []
    }
    
    private var firstCreditBackdrop: String? {
        if !(personDetails.movieCredits?.cast?.isEmpty ?? false) {
            let firstCredit = personDetails.movieCredits?.cast![0]
            return firstCredit?.backdropPath
        }
        if !(personDetails.tvCredits?.cast?.isEmpty ?? false) {
            let firstCredit = personDetails.tvCredits?.cast![0]
            return firstCredit?.backdropPath
        }
        
        // TODO: Add placeholder if person has no tv or movie credits
        return nil
    }
    
    private var details: [OverviewDetail] {
        return [
            .init(title: "Birthday:", detail: personDetails.birthday),
            .init(title: "Deathday:", detail: personDetails.deathday),
            .init(title: "Place of Birth:", detail: personDetails.placeOfBirth)
        ]
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    DetailHeaderView(showActionSheet: $showActionSheet, showVideoPlayer: .constant(false), title: personDetails.name ?? "", posterPath: personDetails.profilePath, backdropPath: firstCreditBackdrop, itemType: .Person, rating: nil, hasVideo: false)
                    DetailOverviewView(overview: personDetails.biography, details: details, posterPath: personDetails.profilePath)
                    if tvCredits.count > 0 {
                        DetailCategoryRow(categoryTitle: "TV Credits") {
                            ForEach(self.tvCredits) { show in
                                NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                                    RoundedImageCell(title: show.name ?? "", posterPath: show.posterPath, height: CGFloat(125))
                                }
                            }
                        }
                    }
                    if movieCredits.count > 0 {
                        DetailCategoryRow(categoryTitle: "Movie Credits") {
                            ForEach(self.movieCredits) { movie in
                                NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                                    RoundedImageCell(title: movie.title ?? "", posterPath: movie.posterPath, height: CGFloat(125))
                                }
                            }
                        }
                    }
                }.padding(8)
            }
        }.padding(8)
    }
}
