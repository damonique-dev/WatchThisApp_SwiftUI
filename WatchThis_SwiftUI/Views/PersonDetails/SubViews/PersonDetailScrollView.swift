//
//  PersonDetailScrollView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

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
                    DetailHeaderView(title: personDetails.name ?? "", posterPath: personDetails.profilePath, backdropPath: firstCreditBackdrop)
                    DetailOverviewView(overview: personDetails.biography, details: details)
                    if tvCredits.count > 0 {
                        PersonTVCreditRow(tvCredits: tvCredits)
                    }
                    if movieCredits.count > 0 {
                        PersonMovieCreditRow(movieCredits: movieCredits)
                    }
                }.padding(8)
                CustomListButtonView(showActionSheet: $showActionSheet)
            }
        }.padding(8)
    }
}

struct PersonTVCreditRow: View {
    let tvCredits: [PersonCredit]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("TV Credits")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            ScrollView(.horizontal) {
                HStack(spacing: 16.0) {
                    ForEach(tvCredits) { show in
                        NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                            RoundedImageCell(title: show.name ?? "", posterPath: show.posterPath, height: CGFloat(125))
                        }
                    }
                }
            }
        }.padding(.top, 8)
    }
}

struct PersonMovieCreditRow: View {
    let movieCredits: [PersonCredit]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Movie Credits")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            ScrollView(.horizontal) {
                HStack(spacing: 16.0) {
                    ForEach(movieCredits) { movie in
                        NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                            RoundedImageCell(title: movie.title ?? "", posterPath: movie.posterPath, height: CGFloat(125))
                        }
                    }
                }
            }
        }.padding(.top, 8)
    }
}
