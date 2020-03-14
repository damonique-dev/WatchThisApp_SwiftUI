//
//  VideoPlayerRepresentable.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 10/3/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import UIKit
import youtube_ios_player_helper

struct VideoPlayerRepresentable: UIViewRepresentable {
    @Binding var showPlayer: Bool
    private let youtubeUrl = "http://youtube.com/watch?v="
    let trailerPath: String?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(showPlayer: $showPlayer)
    }
    
    func makeUIView(context: Context) -> YTPlayerView {
        let view = YTPlayerView()
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ view: YTPlayerView, context: Context) {
        guard let trailerPath = trailerPath else { return }
        guard let range = trailerPath.range(of: youtubeUrl) else { return }
        
        let key = String(trailerPath[range.upperBound...])
        view.load(withVideoId: key)

        if !showPlayer {
            view.stopVideo()
        }
    }
    
    class Coordinator: NSObject, YTPlayerViewDelegate {
        @Binding var showPlayer: Bool
        @State private var isInitialLoad = true
        
        init(showPlayer: Binding<Bool>) {
            _showPlayer = showPlayer
        }
        
        func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
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

