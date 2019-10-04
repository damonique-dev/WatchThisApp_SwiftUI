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
        HStack {
            Button(action: {self.action()}) {
                GeometryReader { geo in
                    HStack {
                        Image(systemName: "play.fill")
                            .imageScale(.medium)
                            .foregroundColor(.white)
                        if geo.size.width > 60 {
                            Text("Trailer")
                                .font(Font.system(.body, design: .rounded))
                                .fontWeight(.bold)
                                
                                .foregroundColor(Color.white)
                        }
                    }
                }.frame(maxHeight:30)
            }
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
        }
    }
}
