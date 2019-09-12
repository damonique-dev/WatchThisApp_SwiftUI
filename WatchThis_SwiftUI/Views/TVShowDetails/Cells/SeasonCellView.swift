//
//  SeasonCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SeasonCellView: View {
    @EnvironmentObject var store: Store<AppState>
    
    let season: Season
    init(season: Season) {
        self.season = season
        if let name = season.name {
            seasonName = name
        }
        if let count = season.episodeCount {
            episodeCount = "\(count) Episodes"
        }
    }
    
    private var seasonName = ""
    private var episodeCount = ""
    
    var body: some View {
        ZStack {
            Color("LightGrey")
            HStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: season.posterPath,
                                                                                         size: .original), contentMode: .fill)
                .frame(width: 60 * 8/11, height: 60, alignment: .center)
                VStack(alignment: .leading) {
                    Text(seasonName)
                        .font(Font.system(.callout, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text(episodeCount)
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                }.frame(width: UIScreen.main.bounds.width/2 - 120)
                Spacer()
            }.padding(.leading, 8)
        }.frame(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.width/5)
            .cornerRadius(10)
    }
}
