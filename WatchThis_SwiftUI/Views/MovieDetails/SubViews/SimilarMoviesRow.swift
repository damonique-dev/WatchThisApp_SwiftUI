//
//  SimilarMoviesRow.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SimilarMoviesRow: View {
    let similarMovies: [MovieDetails]
    
    var body: some View {
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
}
