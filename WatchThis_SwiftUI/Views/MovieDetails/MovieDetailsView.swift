//
//  MovieDetailsView.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import SwiftUI

struct MovieDetailsView: View {
    @EnvironmentObject var store: Store<AppState>
    @State private var customListModel = CustomListModel()
    @State private var showActionSheet = false
    @State private var showCustomListConfirmation = false
    @State private var isFavorite = false
    
    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId        
    }
    
    private var movieDetails: MovieDetails {
        return store.state.movieState.movieDetails[movieId] ?? MovieDetails(id: movieId, title: "")
    }
    
    private func fetchMovieDetails() {
        if store.state.movieState.movieDetails[movieId] == nil {
            store.dispatch(action: MovieActions.FetchMovieDetails(id: movieDetails.id))
        }
        
        isFavorite = store.state.movieState.favoriteMovies.contains(movieDetails.id)
    }
    
    lazy var computedActionSheet: CustomListActionSheet = {
        let customLists = Array(store.state.userState.customLists.values)
        return CustomListActionSheet(customListModel: customListModel, showCustomListConfirmation: $showCustomListConfirmation, customLists: customLists, objectName: movieDetails.title, objectId: movieId, itemType: .Movie)
    }()
    
    private var actionSheet: CustomListActionSheet {
        var mutatableSelf = self
        return mutatableSelf.computedActionSheet
    }
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: movieDetails.posterPath)
            VStack {
                MovieDetailsScrollView(isFavorite: $isFavorite, movieDetails: movieDetails)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text("\(movieDetails.title)"))
        .onAppear() {
            self.fetchMovieDetails()
        }
        .textFieldAlert(isShowing: $customListModel.response.shouldCreateNewList, title: Text("Create Custom List"), doneAction: { (newListName) in
            let newListUUID = UUID()
            self.customListModel.response.listName = newListName
            self.store.dispatch(action: UserActions.CreateNewCustomList(listName: newListName, uuid: newListUUID))
            self.store.dispatch(action: UserActions.AddToCustomList(customListUUID: newListUUID, itemType: .Movie, itemId: self.movieId))
            self.showCustomListConfirmation = true
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: actionSheet.title, message: actionSheet.message, buttons: actionSheet.buttons)
        }.alert(isPresented: $showCustomListConfirmation) {
            if customListModel.response.shouldRemove {
                return Alert(title: Text("Successfully Removed \(movieDetails.title) from \(customListModel.response.listName!)"))
            }
            
            return Alert(title: Text("Successfully Added \(movieDetails.title) to \(customListModel.response.listName!)"))
        }
    }
}

#if DEBUG
struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movieId: testMovieDetails.id).environmentObject(sampleStore)
    }
}
#endif
