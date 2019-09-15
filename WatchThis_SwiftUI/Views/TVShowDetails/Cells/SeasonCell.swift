//
//  SeasonCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SeasonCell: View {
    let season: Season
    
    var body: some View {
        ZStack {
            Text("\(season.name ?? "")")
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .frame(width: 125 * 8/11, height: 125)
                .foregroundColor(.white)
                .lineLimit(nil)
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: season.posterPath,
                                                                                         size: .original))
                    .frame(width: 125 * 8/11, height: 125)
                    .cornerRadius(15)
                Text("\(season.name ?? "")")
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
