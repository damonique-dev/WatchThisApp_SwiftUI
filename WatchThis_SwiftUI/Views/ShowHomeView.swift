//
//  ShowHomeView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ShowHomeView: View {
    var shows: [TVShow] = [TVShow(id: 1, name: "Grey's Anatomy", poster_path: "testTvShowImage"),TVShow(id: 2, name: "Grey's Anatomy", poster_path: "testTvShowImage"),TVShow(id: 3, name: "Grey's Anatomy", poster_path: "testTvShowImage"),TVShow(id: 4, name: "Grey's Anatomy", poster_path: "testTvShowImage"),TVShow(id: 5, name: "Grey's Anatomy", poster_path: "testTvShowImage")]
    
    init() {
        UINavigationBar.appearance().backgroundColor = .darkGray
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            BlurredBackground(imagePath: "appBackground")
            
            ScrollView(.vertical) {
                VStack {
                    CategoryRow(title: "My Shows", shows: shows)
                    CategoryRow(title: "Trending Shows", shows: shows)
                    CategoryRow(title: "Popular Shows", shows: shows)
                }
            }.padding(.top, 44)
        }
    }
}

struct CategoryRow: View {
    let title: String
    let shows: [TVShow]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(Font.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(shows, id: \.id) { show in
                        ShowCell(tvShow: show)
                    }
                }
            }.frame(height: 200)
            Spacer()
        }.padding(.top, 8)
            .padding(.horizontal, 8)
    }
}

#if DEBUG
struct ShowHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ShowHomeView()
    }
}
#endif
