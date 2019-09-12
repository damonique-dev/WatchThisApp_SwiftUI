//
//  TabbedView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/29/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TabbedView: View {
    @State var selectedTab = Tab.showList
    
    enum Tab: Int {
        case showList, movieList, myShows, search
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ShowHomeView().tabItem{
                Image(systemName: "tv.fill").font(.system(size: 30))
            }.tag(Tab.showList)
            Text("Movies").tabItem{
                Image(systemName: "film.fill").font(.system(size: 30))
            }.tag(Tab.movieList)
            Text("My Shows").tabItem{
                Image(systemName: "person.fill").font(.system(size: 30))
            }.tag(Tab.myShows)
            SearchView().tabItem{
                Image(systemName: "magnifyingglass").font(.system(size: 30))
            }.tag(Tab.search)
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(.orange)
        .colorScheme(.dark)
    }
}


struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView()
    }
}
