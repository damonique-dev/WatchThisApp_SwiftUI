//
//  ContentView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/7/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct TVShowDetailView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var isFavorite = false
    @State private var showCustomListAlert = false
    @State private var showActionSheet = false
    @State private var selectedTab = 0
    @State private var customListModel = CustomListModel()
    @State private var showCustomListConfirmation = false
    @State private var showVideoPlayer = false
    
    let showId: Int
    
    private var imagePath: String {
        return store.state.tvShowState.tvShowDetail[showId]?.posterPath ?? ""
    }
    private var backgroundImagePath: String {
        return store.state.tvShowState.tvShowDetail[showId]?.backdropPath ?? ""
    }
    private var showDetail: TVShowDetails {
        return store.state.tvShowState.tvShowDetail[showId] ?? TVShowDetails(id: showId, name: "")
    }
    
    private var showVideo: Video? {
        return store.state.tvShowState.tvShowDetail[showId]?.videos?.results?[0]
    }
    
    private func fetchShowDetails() {
        if store.state.tvShowState.tvShowDetail[showId] == nil {
            store.dispatch(action: TVShowActions.FetchTVShowDetails(id: showId))
        }
    }
    
    lazy var computedActionSheet: CustomListActionSheet = {
        let customLists = Array(store.state.userState.customLists.values)
        return CustomListActionSheet(customListModel: customListModel, showCustomListConfirmation: $showCustomListConfirmation, showCustomListAlert: $showCustomListAlert, customLists: customLists, objectName: showDetail.name, objectId: showId, itemType: .TVShow)
    }()
    
    private var actionSheet: CustomListActionSheet {
        var mutatableSelf = self
        return mutatableSelf.computedActionSheet
    }
        
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            VStack {
                TVDetailScrollView(showActionSheet: $showActionSheet, showVideoPlayer: $showVideoPlayer, showDetail: showDetail)
            }
            if showVideoPlayer && showVideo != nil {
                VideoPlayerView(showPlayer: $showVideoPlayer, video: showVideo)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(showDetail.name)"))
        .onAppear() {
            self.fetchShowDetails()
        }
        .textFieldAlert(isShowing: $showCustomListAlert, title: Text("Create Custom List"), doneAction: { (newListName) in
            let newListUUID = UUID()
            self.customListModel.response.listName = newListName
            self.store.dispatch(action: UserActions.CreateNewCustomList(listName: newListName, uuid: newListUUID))
            self.store.dispatch(action: UserActions.AddToCustomList(customListUUID: newListUUID, itemType: .TVShow, itemId: self.showId))
            self.showCustomListConfirmation = true
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: actionSheet.title, message: actionSheet.message, buttons: actionSheet.buttons)
        }.alert(isPresented: $showCustomListConfirmation) {
            if customListModel.response.shouldRemove {
                return Alert(title: Text("Successfully Removed \"\(showDetail.name)\" from \(customListModel.response.listName!)"))
            }
            
            return Alert(title: Text("Successfully Added \"\(showDetail.name)\" to \(customListModel.response.listName!)"))
        }
    }
}

#if DEBUG
struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           TVShowDetailView(showId: testTVShowDetail.id).environmentObject(sampleStore)
              .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
              .previewDisplayName("iPhone SE")

          TVShowDetailView(showId: testTVShowDetail.id).environmentObject(sampleStore)
              .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
              .previewDisplayName("iPhone XS Max")
        }
    }
}
#endif
