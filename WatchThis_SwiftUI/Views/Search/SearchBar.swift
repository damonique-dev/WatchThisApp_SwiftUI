//
//  SearchBar.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var searchModel: SearchModel
    @State var isActiveBar = false
    var body: some View {
        HStack(alignment: VerticalAlignment.center, spacing: 0, content: {
            ZStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    TextField("Search", text: $searchModel.searchQuery, onEditingChanged: {_ in
                        self.isActiveBar.toggle()
                    }).foregroundColor(.black)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.white))
                    
                    if !searchModel.searchQuery.isEmpty {
                        Button(action: {
                            self.searchModel.searchQuery = ""
                        }) {
                            Image(systemName: "multiply.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
        }).animation(.default)
            .padding(.horizontal)
    }
}
