//
//  WatchTrailerButton.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/15/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct WatchTrailerButton: View {
    let action: () -> Void
        
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                WatchThisButton(text: "Watch Trailer", action: action)
                Spacer()
            }.padding(.leading, UIScreen.main.bounds.width / 2 + UIScreen.main.bounds.width/6 + 10)
            Spacer()
        }.padding(.top, UIScreen.main.bounds.height/3 + 8)
    }
}
