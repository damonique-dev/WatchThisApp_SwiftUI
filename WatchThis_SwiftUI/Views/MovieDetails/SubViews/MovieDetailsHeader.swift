//
//  MovieDetailsHeader.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct MovieDetailHeader: View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var isFavorite: Bool
    let movieDetail: MovieDetails
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundImageHeight = UIScreen.main.bounds.height/3
    private let showImageWidth = UIScreen.main.bounds.width/3
    private let showImageHeight = (UIScreen.main.bounds.width/3) * 11/8
    private let showImageTop = (UIScreen.main.bounds.height/3) - (((UIScreen.main.bounds.width/3) * 11/8)/2)
    
    var body: some View {
        ZStack {
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: movieDetail.backdropPath,
                                                                                         size: .original), contentMode: .fill)
                .frame(width: screenWidth, height: backgroundImageHeight, alignment: .center)
                Spacer()
            }
            VStack {
                HStack {
                    ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: movieDetail.posterPath,
                                                                                             size: .original), contentMode: .fill)
                    .frame(width: showImageWidth, height: showImageHeight, alignment: .center)
                }
                    
                HStack {
                    Text("\(movieDetail.title)")
                        .font(Font.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }.padding(.top, showImageTop)
        }
    }
}
