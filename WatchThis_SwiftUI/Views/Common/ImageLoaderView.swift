//
//  ImageLoaderView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

enum PlaceholderImage: String {
    case none = "none"
    case poster = "tv_icon"
    case person = "profile_icon"
    case header = "tv_icon_header"
}

struct ImageLoaderView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var isImageLoaded = false
    var contentMode = ContentMode.fit
    
    var placeholder: PlaceholderImage = .none
    
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: contentMode)
            } else {
                if placeholder == .person {
                    GeometryReader { geometry in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.black.opacity(0.1))
                            Image(self.placeholder.rawValue)
                                .resizable()
                                .renderingMode(.original)
                                .opacity(0.2)
                                .padding([.top, .leading, .trailing], 8)
                        }
                    }
                } else if placeholder == .poster {
                    GeometryReader { geometry in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.black.opacity(0.2))
                            VStack {
                                Image(self.placeholder.rawValue)
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                                .opacity(0.2)
                            }
                        }
                    }
                }
                else if placeholder == .header {
                        GeometryReader { geometry in
                            ZStack {
                                HStack {
                                    Spacer()
                                    Image(self.placeholder.rawValue)
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.7)
                                    .opacity(0.2)
                                    Spacer()
                                }
                            }
                        }
                    }
                else {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.white.opacity(0.2))
                }
            }
        }
    }
}
