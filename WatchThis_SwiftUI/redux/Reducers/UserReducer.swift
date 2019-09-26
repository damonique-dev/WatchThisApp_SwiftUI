//
//  UserReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/17/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

func userReducer(state: UserState, action: Action) -> UserState {
    var state = state
    
    switch(action) {
        case let action as UserActions.AddToCustomList:
            state.customLists[action.customListUUID]?.items[action.itemId] = ListItem(id: action.itemId, itemType: action.itemType)
        case let action as UserActions.RemoveFromCustomList:
            state.customLists[action.customListUUID]?.items.removeValue(forKey: action.itemId)
        case let action as UserActions.CreateNewCustomList:
            state.customLists[action.uuid] = CustomList(id: action.uuid, listName: action.listName)
        default:
            break
    }
    
    return state
}
