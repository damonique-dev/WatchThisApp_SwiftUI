//
//  TVSeasonsRow.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TVSeasonsRow: View {
    let seasons: [Season]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Seasons")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(seasons) { season in
                        SeasonCell(season: season)
                    }
                }
            }.padding(8)
        }.padding(8)
    }
}
