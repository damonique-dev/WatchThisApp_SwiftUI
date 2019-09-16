//
//  TVSimilarShowsRow.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TVSimilarShowsRow: View {
    let similarShows: [TVShowDetails]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Similar Shows")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            ScrollView(.horizontal) {
                HStack(spacing: 16.0) {
                    ForEach(similarShows) { show in
                        NavigationLink(destination: TVShowDetailView(showId: show.id)) {
                            RoundedImageCell(title: show.name, posterPath: show.posterPath, height: CGFloat(125))
                        }
                    }
                }
            }
        }.padding(8)
    }
}
