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
    @State private var showActionSheet = false
    @State private var selectedTab = 0
    @State private var customListModel = TVCustomListModel()
    @State private var alertInput = ""
    @State private var showCustomListConfirmation = false
    
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
    
    private func fetchShowDetails() {
        if store.state.tvShowState.tvShowDetail[showId] == nil {
            store.dispatch(action: TVShowActions.FetchTVShowDetails(id: showId))
        }
    }
    
    lazy var computedActionSheet: CustomListActionSheet<CustomTVList> = {
        let customLists = Array(store.state.tvShowState.customTVLists.values)
        return CustomListActionSheet(customListModel: customListModel, showCustomListConfirmation: $showCustomListConfirmation, customLists: customLists, objectName: showDetail.name, objectId: showId)
    }()
    
    private var actionSheet: CustomListActionSheet<CustomTVList> {
        var mutatableSelf = self
        return mutatableSelf.computedActionSheet
    }
        
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: imagePath)
            VStack {
                TVDetailScrollView(isFavorite: $isFavorite, showActionSheet: $showActionSheet, showDetail: showDetail)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(showDetail.name)"))
        .onAppear() {
            self.fetchShowDetails()
        }
        .textFieldAlert(isShowing: $customListModel.response.shouldCreateNewList, title: Text("Create Custom List"), doneAction: { (newListName) in
            let newListUUID = UUID()
            self.customListModel.response.listName = newListName
            self.store.dispatch(action: TVShowActions.CreateNewCustomList(listName: newListName, uuid: newListUUID))
            self.store.dispatch(action: TVShowActions.AddTVShowToCustomList(customListUUID: newListUUID, tvShowId: self.showId))
            self.showCustomListConfirmation = true
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: actionSheet.title, message: actionSheet.message, buttons: actionSheet.buttons)
        }.alert(isPresented: $showCustomListConfirmation) {
            if customListModel.response.shouldRemove {
                return Alert(title: Text("Successfully Removed \(showDetail.name) from \(customListModel.response.listName!)"))
            }
            
            return Alert(title: Text("Successfully Added \(showDetail.name) to \(customListModel.response.listName!)"))
        }
    }
}

#if DEBUG
struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailView(showId: testTVShowDetail.id).environmentObject(sampleStore)
    }
}
#endif
