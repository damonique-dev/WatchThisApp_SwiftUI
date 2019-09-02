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
    var contentMode = ContentMode.fit
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: contentMode)
                    .onAppear{
                        DispatchQueue.main.async {
                            self.isImageLoaded = true
                        }
                }
            } else {
                RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.black.opacity(0))
                .border(Color.white)
            }
        }
    }
}
