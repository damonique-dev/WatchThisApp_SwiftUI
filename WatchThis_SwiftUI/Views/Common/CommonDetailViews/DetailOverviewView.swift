//
//  DetailOverviewView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 10/2/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct DetailOverviewView: View {
    let overview: String?
    let details: [OverviewDetail]
    let posterPath: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if overview != nil {
                ExpandableTextView(text: overview!, imagePath: posterPath, font: .body, color: .white)
            }
            ForEach(details, id: \.self) { detail in
                DetailsLabel(title: detail.title, detail: detail.detail)
            }
            Spacer()
        }.padding(.horizontal, 8)
    }
}

struct OverviewDetail: Hashable {
    let title: String
    let detail: String?
}
