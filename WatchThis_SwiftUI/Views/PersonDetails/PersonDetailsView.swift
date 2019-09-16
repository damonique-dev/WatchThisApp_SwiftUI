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
    
    var body: some View {
        ZStack {
            BlurredBackground(image: nil, imagePath: personDetails.profilePath)
            VStack {
                PersonDetailScrollView(isFavorite: $isFavorite, personDetails: personDetails)
            }
        }
        .padding(.vertical, 44)
        .navigationBarTitle(Text(personName))
        .onAppear() {
            self.fetchPersonDetails()
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
