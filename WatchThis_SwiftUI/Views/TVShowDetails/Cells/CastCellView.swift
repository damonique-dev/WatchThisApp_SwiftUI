//
//  CastCellView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct CastCellView: View {
    @EnvironmentObject var store: Store<AppState>
    
    let person: TraktCast
    
    private let width = UIScreen.main.bounds.width/3
    private let imageWidth = UIScreen.main.bounds.width/3 - 30
    private var posterPath: String? {
        if let tmdbId = person.person.ids.tmdb{
            return store.state.tvShowState.traktImages[.Person]?[tmdbId]?.posterPath
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance.loaderFor(path: posterPath,
                                                                                       size: .original), contentMode: .fill, placeholder: .person)
                .frame(width: imageWidth, height: imageWidth, alignment: .center)
                .clipShape(Circle())
                Text("\(person.person.name ?? "")")
                    .font(Font.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text("\(person.character ?? "")")
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }.frame(width: width, height: width * 11/8)
            .cornerRadius(10)
    }
}
