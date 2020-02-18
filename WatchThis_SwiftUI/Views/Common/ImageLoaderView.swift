//
//  ImageLoaderView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ImageLoaderView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var isImageLoaded = false
//    @State var image: UIImage = UIImage()
    var contentMode = ContentMode.fit
    
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: contentMode)
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.black.opacity(0.2))
            }
        }
//        .onReceive(imageLoader.didChange) { image in
//                self.image = image
//        }
    }
}
