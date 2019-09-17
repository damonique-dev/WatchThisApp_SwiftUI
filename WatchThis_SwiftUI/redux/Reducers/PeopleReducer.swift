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
        case let action as PeopleActions.SetPersonSearch:
            state = addToSearchList(state: state, query: action.query)
            state.peopleSearch[action.query] = action.people
        case let action as PeopleActions.AddPersonToCustomList:
            state.customPeopleLists[action.customListUUID]?.peopleIds.insert(action.personId)
        case let action as PeopleActions.RemovePersonFromCustomList:
           state.customPeopleLists[action.customListUUID]?.peopleIds.remove(action.personId)
        default:
            break
    }
    
    return state
}

private func addToSearchList(state: PeopleState, query: String) -> PeopleState {
    var state = state
    var existingQueries = state.peopleSearchQueries
    let index = existingQueries.firstIndex(of: query)
    if index != nil {
        existingQueries.remove(at: index!)
    }
    existingQueries.insert(query, at: 0)
    if (existingQueries.count > 5) {
        existingQueries =  Array(existingQueries.prefix(upTo: 5))
    }
    
    state.peopleSearchQueries =  existingQueries
    return state
}
