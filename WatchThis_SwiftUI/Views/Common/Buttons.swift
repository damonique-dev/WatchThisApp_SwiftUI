//
//  Buttons.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct WatchThisButton: View {
    var text = "Button Text"
        
    var body: some View {
        Button(action: {}) {
            Text(text)
                .font(Font.system(.body, design: .rounded))
                .fontWeight(.bold)
                .frame(height:30)
                .padding(.horizontal, 4)
                .foregroundColor(Color.white)
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
        
    }
}

#if DEBUG
struct WatchThisButton_Previews: PreviewProvider {
    static var previews: some View {
        WatchThisButton()
    }
}
#endif
