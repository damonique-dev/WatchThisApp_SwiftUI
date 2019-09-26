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
    let video: Video?
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.8)
            VStack(alignment: .leading) {
                Button(action: {self.showPlayer.toggle()}) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                }.padding(.leading, 8)
                VideoPlayerRepresentable(showPlayer: $showPlayer, video: video)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct VideoPlayerRepresentable: UIViewRepresentable {
    @Binding var showPlayer: Bool
    let video: Video?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(showPlayer: $showPlayer)
    }
    
    func makeUIView(context: Context) -> YTPlayerView {
        let view = YTPlayerView()
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ view: YTPlayerView, context: Context) {
        if let key = video?.key {
            view.load(withVideoId: key)
        }
        if !showPlayer {
            view.stopVideo()
        }
    }
    
    class Coordinator: NSObject, YTPlayerViewDelegate {
        @Binding var showPlayer: Bool
        
        init(showPlayer: Binding<Bool>) {
            _showPlayer = showPlayer
        }
        
        func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            // call play video when the player is finished loading.
            playerView.playVideo()
        }
        
        func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
            print("YTPlayerState: \(state.rawValue)")
            switch state {
            case .ended:
                showPlayer = false
                break
            default:
                break
            }
        }
    }
}
