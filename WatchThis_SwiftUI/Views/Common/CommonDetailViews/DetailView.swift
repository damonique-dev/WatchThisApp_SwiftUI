//
//  DetailView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 10/3/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct DetailView<Content: View>: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var isFavorite = false
    @State private var showCustomListAlert = false
    @State private var selectedTab = 0
    @State private var customListModel = CustomListModel()
    @State private var showCustomListConfirmation = false
    @Binding var showActionSheet: Bool
    @Binding var showVideoPlayer: Bool
    
    let slug: String
    let title: String
    let itemType: ItemType
    let imagePath: String?
    let trailerPath: String?
    let viewBuilder: () -> Content
    
    init(slug: String, title: String, itemType: ItemType, imagePath: String?, trailerPath: String?, showActionSheet: Binding<Bool> , showVideoPlayer: Binding<Bool>, @ViewBuilder builder: @escaping () -> Content) {
        self.slug = slug
        self.itemType = itemType
        self.title = title
        self.imagePath = imagePath
        self._showActionSheet = showActionSheet
        self._showVideoPlayer = showVideoPlayer
        self.viewBuilder = builder
        self.trailerPath = trailerPath
    }
    
    lazy var computedActionSheet: CustomListActionSheet = {
        let customLists = Array(store.state.userState.customLists.values)
        return CustomListActionSheet(customListModel: customListModel, showCustomListConfirmation: $showCustomListConfirmation, showCustomListAlert: $showCustomListAlert, customLists: customLists, objectName: title, slug: slug, itemType: .TVShow)
    }()
    
    private var actionSheet: CustomListActionSheet {
        var mutatableSelf = self
        return mutatableSelf.computedActionSheet
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            VStack {
                viewBuilder()
            }
            if showVideoPlayer && trailerPath != nil {
                VideoPlayerView(showPlayer: $showVideoPlayer, trailerPath: trailerPath)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(title)"))
        .textFieldAlert(isShowing: $showCustomListAlert, title: Text("Create Custom List"), doneAction: { (newListName) in
            let newListUUID = UUID()
            self.customListModel.response.listName = newListName
            self.store.dispatch(action: UserActions.CreateNewCustomList(listName: newListName, uuid: newListUUID))
            self.store.dispatch(action: UserActions.AddToCustomList(customListUUID: newListUUID, itemType: self.itemType, slug: self.slug))
            self.showCustomListConfirmation = true
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: actionSheet.title, message: actionSheet.message, buttons: actionSheet.buttons)
        }.alert(isPresented: $showCustomListConfirmation) {
            if customListModel.response.shouldRemove {
                return Alert(title: Text("Successfully Removed \"\(title)\" from \(customListModel.response.listName!)"))
            }
            
            return Alert(title: Text("Successfully Added \"\(title)\" to \(customListModel.response.listName!)"))
        }
    }
}
