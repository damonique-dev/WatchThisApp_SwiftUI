//
//  SearchHeaderView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SearchHeaderView: View {
    @ObservedObject var searchModel: SearchModel
    
    var body: some View {
        VStack {
            SearchBar(searchModel: searchModel)
                .padding(.top, 25)
            Picker(selection: $searchModel.searchCategory, label: Text("")) {
                Text("TV Shows").tag(SearchCategories.TVshows)
                Text("Movies").tag(SearchCategories.Movies)
                Text("People").tag(SearchCategories.People)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
}
