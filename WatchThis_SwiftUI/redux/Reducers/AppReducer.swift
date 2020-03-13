//
//  AppReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

func appStateReducer(state: AppState, action: Action) -> AppState {
    var state = state
    state.tvShowState = tvShowReducer(state: state.tvShowState, action: action)
    state.peopleState = peopleReducer(state: state.peopleState, action: action)
    state.movieState = movieReducer(state: state.movieState, action: action)
    state.userState = userReducer(state: state.userState, action: action)
    state.traktState = traktReducer(state: state.traktState, action: action)
    return state
}
