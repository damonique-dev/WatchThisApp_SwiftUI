//
//  MovieDetailsScrollView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct MovieDetailsScrollView: View {
    @EnvironmentObject var store: Store<AppState>
    
    @Binding var showActionSheet: Bool
    let movieDetails: MovieDetails
    
    private var cast: [Cast] {
        return store.state.movieState.movieDetails[movieDetails.id]?.credits?.cast ?? [Cast]()
    }
    
    private var similarMovies: [MovieDetails] {
        return store.state.movieState.movieDetails[movieDetails.id]?.similar?.results ?? [MovieDetails]()
    }
    
    private var movieRuntime: String? {
        if let runtime = movieDetails.runtime {
            return "\(runtime)"
        }
        return nil
    }
    
    private var movieRevenue: String? {
        if let revenue = movieDetails.revenue {
            return formatLargeCurrency(currency: revenue)
        }
        return nil
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    MovieDetailHeader(movieDetail: movieDetails)
                    Text("\(movieDetails.overview ?? "")")
                        .font(.body)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading) {
                        DetailsLabel(title: "Release Date:", detail: movieDetails.releaseDate)
                        DetailsLabel(title: "Runtime:", detail: movieRuntime)
                        DetailsLabel(title: "Revenue:", detail: movieRevenue)
                    }.padding(.top, 8)
                    if cast.count > 0 {
                        CastRow(cast: cast)
                    }
                    if similarMovies.count > 0 {
                        SimilarMoviesRow(similarMovies: similarMovies)
                    }
                }
                CustomListButtonView(showActionSheet: $showActionSheet)
                WatchTrailerButton()
            }
        }.padding(8)
    }
}
