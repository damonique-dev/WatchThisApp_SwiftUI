//
//  CastCellView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/1/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct CastCellView: View {
    @EnvironmentObject var store: Store<AppState>
    
    let person: Cast
    
    init(person: Cast) {
        self.person = person
    }
    
    var body: some View {
        ZStack {
            VStack {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: person.profile_path,
                                                                                         size: .original), contentMode: .fill)
                .frame(width: 90, height: 90, alignment: .center)
                .clipShape(Circle())
                Text(person.name)
                    .font(Font.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .lineLimit(2)
                Text(person.character)
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
        }.frame(width: UIScreen.main.bounds.width/3 - 20, height: UIScreen.main.bounds.width/3 - 5)
            .cornerRadius(10)
    }
}
