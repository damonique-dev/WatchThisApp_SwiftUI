//
//  BlurredBackgroundView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct BlurredBackground: View {
    let image: UIImage?
    let imagePath: String?

    var body: some View {
        ZStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .blur(radius: 20)
            } else {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: imagePath,
                                                                                         size: .original))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .blur(radius: 20)
            }
            Color(.black).opacity(0.8)
        }.edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

#if DEBUG
struct BlurredBackground_Previews: PreviewProvider {
    static var previews: some View {
        BlurredBackground(image: UIImage(named: "testTvShowImage")!, imagePath: "testTvShowImage")
    }
}
#endif
