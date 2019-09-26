//
//  WebView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    let request: URLRequest
      
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
