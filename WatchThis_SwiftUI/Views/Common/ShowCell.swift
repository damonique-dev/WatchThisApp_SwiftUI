//
//  ShowCell.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ShowCell: View {
    let tvShow: TVShow
    
    init(tvShow: TVShow) {
        self.tvShow = tvShow
        if let name = tvShow.name {
            showName = name
        }
        if let path = tvShow.poster_path {
            imagePath = path
        }
    }
    
    private var showName = "Grey's Anatomy"
    private var imagePath = "testTvShowImage"
    
    var body: some View {

        ZStack {
            Text(showName)
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Image(imagePath)
                .resizable()
                .frame(width: 200 * 8/11, height: 200)
                .cornerRadius(15)
        }
    }
}
