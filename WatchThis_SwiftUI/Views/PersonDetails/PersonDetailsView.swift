//
//  PersonDetailsView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/14/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct PersonDetailsView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var customListModel = CustomListModel()
    @State private var showActionSheet = false
    @State private var showCustomListConfirmation = false
    @State private var showCustomListAlert = false
    @State private var isFavorite = false
    
    let personId: Int
    let personName: String
    
    private var personDetails: PersonDetails {
        return store.state.peopleState.people[personId] ?? PersonDetails(id: personId)
    }
        
    private func fetchPersonDetails() {
        if store.state.peopleState.people[personId] == nil {
            store.dispatch(action: PeopleActions.FetchPersonDetails(id: personId))
        }
    }
    
    lazy var computedActionSheet: CustomListActionSheet = {
        let customLists = Array(store.state.userState.customLists.values)
        return CustomListActionSheet(customListModel: customListModel, showCustomListConfirmation: $showCustomListConfirmation, showCustomListAlert: $showCustomListAlert, customLists: customLists, objectName: personName, objectId: personId, itemType: .Person)
    }()
    
    private var actionSheet: CustomListActionSheet {
        var mutatableSelf = self
        return mutatableSelf.computedActionSheet
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: personDetails.profilePath)
            VStack {
                PersonDetailScrollView(showActionSheet: $showActionSheet, personDetails: personDetails)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text(personName))
        .onAppear() {
            self.fetchPersonDetails()
        }
        .textFieldAlert(isShowing: $showCustomListAlert, title: Text("Create Custom List"), doneAction: { (newListName) in
            let newListUUID = UUID()
            self.customListModel.response.listName = newListName
            self.store.dispatch(action: UserActions.CreateNewCustomList(listName: newListName, uuid: newListUUID))
            self.store.dispatch(action: UserActions.AddToCustomList(customListUUID: newListUUID, itemType: .Movie, itemId: self.personId))
            self.showCustomListConfirmation = true
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: actionSheet.title, message: actionSheet.message, buttons: actionSheet.buttons)
        }.alert(isPresented: $showCustomListConfirmation) {
            if customListModel.response.shouldRemove {
                return Alert(title: Text("Successfully Removed \"\(personName)\" from \(customListModel.response.listName!)"))
            }
            
            return Alert(title: Text("Successfully Added \"\(personName)\" to \(customListModel.response.listName!)"))
        }
    }
}

#if DEBUG
struct PersonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailsView(personId: 123, personName: "Name").environmentObject(sampleStore)
    }
}
#endif
