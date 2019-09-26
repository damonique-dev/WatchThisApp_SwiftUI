//
//  SettingsView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/25/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State var showCopyConfirmation = false
    private var privacyPolicy: URLRequest {
        return URLRequest(url: URL(string: "https://upnext-track-shows.flycricket.io/privacy.html")!)
    }
    private var feedbackEmail: String {
        return "feedback@damonique.dev"
    }
    
    private func addEmailToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = feedbackEmail
        showCopyConfirmation = true
    }
    
    private func openEmail() {
        if let url = URL(string: "mailto:\(feedbackEmail)") {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("About").font(.headline).foregroundColor(.white)) {
                NavigationLink(destination: AboutView()) {
                    Text("About")
                }
                NavigationLink(destination: WebView(request: privacyPolicy)) {
                    Text("Privacy Policy")
                }
            }
            Section(header: Text("Contact").font(.headline).foregroundColor(.white)) {
                Text("Compose Email")
                    .onTapGesture(perform: {
                        self.openEmail()
                    })
                Text("Copy Email")
                    .onTapGesture(perform: {
                        self.addEmailToClipboard()
                    })
            }
        }.colorScheme(.dark)
        .navigationBarTitle(Text("Settings"), displayMode: .large)
        .alert(isPresented: $showCopyConfirmation) {
            Alert(title: Text("Email Copied!"))
        }
    }
}

struct AboutView: View {
    var body: some View {
        ZStack {
            BlurredBackground(image: UIImage(named: "appBackground"), imagePath: nil)
            
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    Text("UpNext helps you find and track your favorite TV Shows and Movies. This app is powered by The Movie Database (TMDB) and Trakt.tv")
                        .font(.headline)
                        .foregroundColor(.white)
                    Image("tmdb_icon")
                        .resizable()
                        .frame(maxWidth: UIScreen.main.bounds.width - 16)
                        .aspectRatio(contentMode: .fit)
                    Image("trakt_icon")
                        .resizable()
                        .frame(maxWidth: UIScreen.main.bounds.width - 16)
                        .aspectRatio(contentMode: .fit)
                    Text("Note: This app is not endorsed or certified by TMDB or Trakt.tv")
                        .font(.caption)
                    .foregroundColor(.white)
                }.padding(8)
            }.padding(.top, 44)
        }
    }
}

#if DEGUB
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
#endif
