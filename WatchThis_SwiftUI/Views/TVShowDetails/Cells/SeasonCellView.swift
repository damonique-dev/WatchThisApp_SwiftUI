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
        if let path = season.poster_path {
            imagePath = path
        }
        if let count = season.episode_count {
            episodeCount = "\(count) Episodes"
        }
    }
    
    private var imagePath = ""
    private var seasonName = ""
    private var episodeCount = ""
    
    private var image: UIImage {
        if let data = store.state.images[imagePath]?[.original] {
            return UIImage(data: data)!
        }
        return UIImage()
    }
    
    private func fetchImages() {
        store.dispatch(action: AppActions.FetchImage(urlPath: imagePath, size: .original))
    }
    
    var body: some View {
        ZStack {
            Color("LightGrey")
            HStack {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 60 * 8/11, height: 60, alignment: .center)
                    .aspectRatio(contentMode: .fill)
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
            .onAppear() {
                self.fetchImages()
        }
    }
}
