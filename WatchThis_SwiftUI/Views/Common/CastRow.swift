//
//  TVCastRow.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct CastRow: View {
    let cast: [Cast]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(cast) { cast in
                        NavigationLink(destination: PersonDetailsView(personId: cast.id, personName: cast.name)) {
                            CastCellView(person: cast)
                        }
                    }
                }
            }
        }.padding(8)
    }
}
