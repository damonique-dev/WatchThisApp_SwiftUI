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
        case showList, calendar, myShows
    }
    
    func tabbarItem(image: String) -> some View {
        HStack() {
            Image(image)
                
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ShowHomeView().tabItem{
                self.tabbarItem(image: "fire_icon")
            }.tag(Tab.showList)
            Text("Calender").tabItem{
                self.tabbarItem(image: "calendar_icon")
            }.tag(Tab.calendar)
            Text("My Shows").tabItem{
                self.tabbarItem(image: "profile_icon")
            }.tag(Tab.myShows)
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
