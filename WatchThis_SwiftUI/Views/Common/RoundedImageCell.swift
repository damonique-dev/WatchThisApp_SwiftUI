//
//  ShowCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct RoundedImageCell: View {
    @EnvironmentObject var store: Store<AppState>
    let title: String
    let posterPath: String?
    let height: CGFloat

    var body: some View {
        ZStack {
            Text(title)
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .padding(16)
            ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath,
                                                                                     size: .original))
                .cornerRadius(15)
        }
        .frame(width: height * 8/11, height: height)
        .padding(8)
    }
}

#if DEBUG
struct ShowCell_Previews: PreviewProvider {
    static var previews: some View {
        RoundedImageCell(title: testTVShowDetail.name, posterPath: testTVShowDetail.posterPath, height: CGFloat(200)).environmentObject(sampleStore)
    }
}
#endif
