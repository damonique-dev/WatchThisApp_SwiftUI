//
//  SeasonCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct SeasonCell: View {
    @EnvironmentObject var store: Store<AppState>
    let season: TraktSeason
    
    private var posterPath: String? {
        if let tmdbId = season.ids.tmdb {
            return store.state.traktState.traktImages[.Season]?[tmdbId]?.posterPath
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            Text("\(season.title ?? "")")
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .frame(width: 125 * 8/11, height: 125)
                .foregroundColor(.white)
                .lineLimit(nil)
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath,
                                                                                       size: .original), placeholder: .poster)
                    .frame(width: 125 * 8/11, height: 125)
                    .cornerRadius(15)
                Text("\(season.title ?? "")")
                    .font(Font.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .lineLimit(2)
                Text("\(season.episodeCount ?? 0) Episodes")
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
        }
    }
}
