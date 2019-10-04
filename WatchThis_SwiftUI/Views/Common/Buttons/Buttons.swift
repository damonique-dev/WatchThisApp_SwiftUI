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
    let action: () -> Void
        
    var body: some View {
        Button(action: {self.action()}) {
            Text(text)
                .font(Font.system(.body, design: .rounded))
                .fontWeight(.bold)
                .frame(minHeight:30)
                .padding(.horizontal, 8)
                .foregroundColor(Color.white)
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
        
    }
}

struct PlayTrailerButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: { self.action() } ) {
            ZStack {
                Circle().foregroundColor(.orange)
                Image(systemName: "play.fill")
                    .imageScale(.medium)
                    .foregroundColor(.white)
            }
        }.frame(width: 30, height: 30)
    }
}

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: { self.action() } ) {
            ZStack {
                Circle().foregroundColor(.orange)
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
        }.frame(width: 30, height: 30)
    }
}

struct DetailTabButton: View {
    @Binding var selectedTab: Int
    var text = "Button Text"
    var buttonIndex = 0
    
    let buttonWidth = (UIScreen.main.bounds.width - 60)/4
    
    var body: some View {
        Button(action: {self.selectedTab = self.buttonIndex}) {
            Text(text)
                .font(Font.system(.body, design: .rounded))
                .fontWeight(.bold)
                .frame(width: buttonWidth, height:30)
                .foregroundColor(Color.white)
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(selectedTab == buttonIndex ? .green : .orange))
        
    }
}

#if DEBUG
struct WatchThisButton_Previews: PreviewProvider {
    static var previews: some View {
        WatchThisButton(action: {print("action")})
    }
}
#endif
