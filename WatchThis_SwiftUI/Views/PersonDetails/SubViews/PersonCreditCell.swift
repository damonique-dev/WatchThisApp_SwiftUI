//
//  PersonCreditCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 3/13/20.
//  Copyright © 2020 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PersonCreditCell: View {
    @EnvironmentObject var store: Store<AppState>
    let posterPath: String?
    let imageText: String?
    let title: String?
    let subTitle: String?
    
    private let width = UIScreen.main.bounds.width/3
    private let imageWidth = UIScreen.main.bounds.width/3 - 30
    
    var body: some View {
        ZStack {
            Text("\(imageText ?? "")")
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .frame(width: 125 * 8/11, height: 125)
                .foregroundColor(.white)
                .lineLimit(nil)
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath,
                                                                                       size: .original), placeholder: .poster)
                    .frame(width: imageWidth, height: imageWidth * 11/8)
                    .cornerRadius(15)
                Text("\(title ?? "")")
                    .font(Font.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text("\(subTitle ?? "")")
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }.frame(width: width, height: width * 11/8 + 40)
    }
}

