//
//  PeopleReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

func peopleReducer(state: PeopleState, action: Action) -> PeopleState {
    var state = state
    
    switch(action) {
        case let action as PeopleActions.SetPersonDetail:
            state.people[action.id] = action.personDetail
        case let action as PeopleActions.AddPersonToFavorites:
            state.favoritePeople.insert(action.personId)
        case let action as PeopleActions.RemovePersonFromFavorites:
            state.favoritePeople.remove(action.personId)
        default:
            break
    }
    
    return state
}
