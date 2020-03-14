//
//  VideoPlayerView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/23/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import UIKit
import youtube_ios_player_helper

struct VideoPlayerView: View {
    @Binding var showPlayer: Bool
    let trailerPath: String?
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.8)
            VStack(alignment: .leading) {
                Button(action: {self.showPlayer.toggle()}) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                }.padding(.leading, 8)
                VideoPlayerRepresentable(showPlayer: $showPlayer, trailerPath: trailerPath)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
