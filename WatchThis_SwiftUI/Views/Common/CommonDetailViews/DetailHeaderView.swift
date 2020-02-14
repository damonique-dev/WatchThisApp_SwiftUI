//
//  DetailHeaderView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 10/2/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct DetailHeaderView: View {
    @Binding var showActionSheet: Bool
    @Binding var showVideoPlayer: Bool
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let itemType: ItemType
    let rating: Double?
    let hasVideo: Bool
    
    init(showActionSheet: Binding<Bool>, showVideoPlayer: Binding<Bool>, title: String, posterPath: String?, backdropPath: String?, itemType: ItemType, rating: Double?, hasVideo: Bool) {
        self._showActionSheet = showActionSheet
        self._showVideoPlayer = showVideoPlayer
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.itemType = itemType
        self.rating = rating
        self.hasVideo = hasVideo
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundImageHeight = UIScreen.main.bounds.height/5
    private let showImageWidth = UIScreen.main.bounds.width/4
    private let showImageHeight = (UIScreen.main.bounds.width/4) * 11/8
    private let showImageTop = (UIScreen.main.bounds.height/5) - (((UIScreen.main.bounds.width/4) * 11/8)/2)
    
    private let gradient = Gradient(colors: [Color(.black).opacity(0), Color(.black).opacity(0.95)])
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: backdropPath,
                                                                                             size: .original), contentMode: .fill)
                    Rectangle()
                        .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                       
                }.frame(width: screenWidth, height: backgroundImageHeight, alignment: .center)
                Spacer()
            }
            VStack {
                HStack {
                    ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath,
                                                                                             size: .original), contentMode: .fill)
                        .frame(width: showImageWidth, height: showImageHeight, alignment: .center)
                        .padding(.leading, 16)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(title)
                            .font(Font.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(8)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack(alignment: .center) {
                            if itemType != .Person {
                                RatingView(rating: rating)
                                if hasVideo {
                                    WatchTrailerButton(action: {self.showVideoPlayer.toggle()})
                                }
                            }
                            CustomListButtonView(showActionSheet: $showActionSheet)
                        }.frame(height: 50)
                    }.frame(maxHeight: showImageHeight)
                    Spacer()
                }.padding(.top, showImageTop + 16)
                
            }
        }.padding(.bottom, 16)
    }
}

struct DetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DetailHeaderView(showActionSheet: .constant(false), showVideoPlayer: .constant(false), title: "Movie Title", posterPath: "/y6JABtgWMVYPx84Rvy7tROU5aNH.jpg", backdropPath: "/y6JABtgWMVYPx84Rvy7tROU5aNH.jpg", itemType: .Movie, rating: 7.0, hasVideo: true)
    }
}
