//
//  DetailCategoryRow.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 10/3/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct DetailCategoryRow<Content: View>: View {
    let categoryTitle: String
    let viewBuilder: () -> Content
    
    init(categoryTitle: String, @ViewBuilder builder: @escaping () -> Content) {
        self.categoryTitle = categoryTitle
        self.viewBuilder = builder
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryTitle)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            ScrollView(.horizontal) {
                HStack {
                    viewBuilder()
                }
            }.padding(8)
        }.padding(8)
    }
}
