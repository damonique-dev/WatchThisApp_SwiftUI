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
    
    let movieDetails: MovieDetails
    
    private var cast: [Cast] {
        return store.state.movieState.movieDetails[movieDetails.id]?.credits?.cast ?? [Cast]()
    }
    
    private var similarMovies: [MovieDetails] {
        return store.state.movieState.movieDetails[movieDetails.id]?.similar?.results ?? [MovieDetails]()
    }
    
    private var movieRuntime: String {
        if let runtime = movieDetails.runtime {
            return "\(runtime)"
        }
        return "-"
    }
    
    private var movieRevenue: String {
        if let revenue = movieDetails.revenue {
            return formatLargeCurrency(currency: revenue)
        }
        return "-"
    }
    
    var body: some View {
       ScrollView(.vertical) {
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
            if similarMovies.count > 0 {
                VStack(alignment: .leading) {
                    Text("Similar Movies")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    ScrollView(.horizontal) {
                        HStack(spacing: 16.0) {
                            ForEach(similarMovies) { movie in
                                NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                                    RoundedImageCell(title: movie.title, posterPath: movie.posterPath, height: CGFloat(125))
                                }
                            }
                        }
                    }
                }.padding(.top, 8)
            }
        }.padding(8)
    }
}
