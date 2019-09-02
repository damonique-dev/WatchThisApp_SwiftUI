//
//  ShowCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ShowCell: View {
    @EnvironmentObject var store: Store<AppState>
    let tvShow: TVShowDetails
    let height: CGFloat
    
    init(tvShow: TVShowDetails, height: CGFloat) {
        self.tvShow = tvShow
        self.height = height
    }

    var body: some View {
        ZStack {
            Text(tvShow.name)
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .frame(width: height * 8/11, height: height)
                .foregroundColor(.white)
                .lineLimit(nil)
            ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: tvShow.poster_path,
                                                                                     size: .original))
                .frame(width: height * 8/11, height: height)
                .cornerRadius(15)
        }
    }
}

#if DEBUG
struct ShowCell_Previews: PreviewProvider {
    static var previews: some View {
        ShowCell(tvShow: testTVShowDetail, height: CGFloat(200)).environmentObject(sampleStore)
    }
}
#endif
