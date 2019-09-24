//
//  ActivitySpinner.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/23/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct ActivitySpinner: View {
    @State var spinCircle = false

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.75, to: 1)
                .stroke(Color.orange, lineWidth: 5)
                .frame(width: 50)
                .rotationEffect(.degrees(spinCircle ? 0 : -360), anchor: .center)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear {
            self.spinCircle = true
        }
    }
}

#if DEBUG
struct ActivitySpinner_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySpinner()
    }
}
#endif
