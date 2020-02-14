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
            Button(action: { self.action() }) {
                GeometryReader { geo in
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "play.fill")
                            .imageScale(.medium)
                            .foregroundColor(.white)
                        if geo.size.width > 81 {
                            Text("Trailer")
                                .font(Font.system(.body, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                        Spacer()
                    }
                }
            }
            .frame(height: 30)
            .frame(maxWidth: 100)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
        }
    }
}

struct WatchTrailerButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RatingView(rating: nil)
            WatchTrailerButton(action: {})
            Spacer()
        }.frame(width: 160)
    }
}
