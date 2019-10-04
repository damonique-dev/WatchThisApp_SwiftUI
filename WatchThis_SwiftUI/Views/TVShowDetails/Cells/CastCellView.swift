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
    
    private let width = UIScreen.main.bounds.width/3
    private let imageWidth = UIScreen.main.bounds.width/3 - 30
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                ImageLoaderView(imageLoader: ImageLoaderCache.sharedInstance().loaderFor(path: person.profilePath,
                                                                                         size: .original), contentMode: .fill)
                .frame(width: imageWidth, height: imageWidth, alignment: .center)
                .clipShape(Circle())
                Spacer()
                Text(person.name)
                    .font(Font.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(person.character)
                    .font(Font.system(.caption, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }.frame(width: width, height: width * 11/8)
            .cornerRadius(10)
    }
}

#if DEBUG
struct CastCellView_Previews: PreviewProvider {
    static var previews: some View {
        CastCellView(person: Cast(id: 1, name: "Samuel L. Jackson", character: "Samuel L. Jackson Jackson", profilePath: nil)).environmentObject(sampleStore)
    }
}
#endif
