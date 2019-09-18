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
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    PersonDetailsHeaderView(personDetails: personDetails)
                    Text("\(personDetails.biography ?? "")")
                        .font(.body)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading) {
                        DetailsLabel(title: "Birthday:", detail: personDetails.birthday)
                        DetailsLabel(title: "Deathday:", detail: personDetails.deathday)
                        DetailsLabel(title: "Place of Birth:", detail: personDetails.placeOfBirth)
                    }.padding(.top, 8)
                    if tvCredits.count > 0 {
                        PersonTVCreditRow(tvCredits: tvCredits)
                    }
                    if movieCredits.count > 0 {
                        PersonMovieCreditRow(movieCredits: movieCredits)
                    }
                }
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
