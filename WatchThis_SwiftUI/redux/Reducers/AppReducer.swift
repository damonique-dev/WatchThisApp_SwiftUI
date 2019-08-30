//
//  AppReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

func appStateReducer(state: AppState, action: Action) -> AppState {
    var state = state
    switch(action) {
        case let action as AppActions.SetImage:
            if state.images[action.urlPath] == nil {
                state.images[action.urlPath] = [:]
            }
            state.images[action.urlPath]![action.size] = action.imageData
        default:
            break
    }
    state.tvShowState = tvShowReducer(state: state.tvShowState, action: action)
    state.peopleState = peopleReducer(state: state.peopleState, action: action)
    return state
}
