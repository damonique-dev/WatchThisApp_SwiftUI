//
//  TVShowReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

func tvShowReducer(state: TVShowState, action: Action) -> TVShowState {
    var state = state
    switch(action) {
        case let action as TVShowActions.SetTVShowList:
            state.tvLists[action.list] = action.ids
        case let action as TVShowActions.SetTVShowDetail:
            state.tvShowDetail[action.id] = action.tvShowDetail
        case let action as TVShowActions.SetTVShowSeason:
            if state.tvShowSeasons[action.id] == nil {
                state.tvShowSeasons[action.id] = [:]
            }
            state.tvShowSeasons[action.id]![action.seasonId] = action.season
        case let action as TVShowActions.SetTVShowCast:
            state.tvShowCast[action.id] = action.cast
        case let action as TVShowActions.SetTVShowSearch:
            state.tvShowSearch[action.query] = action.tvShows
        case let action as TVShowActions.SetSimilarTVShows:
            state.similarShows[action.id] = action.tvShows
        default:
            break
    }
    
    return state
}

private func mergeTVShows(state: TVShowState, tvShows: [TVShow]) -> TVShowState {
    var state = state
    for tvShow in tvShows {
        if state.tvShow[tvShow.id] == nil {
            state.tvShow[tvShow.id] = tvShow
        }
    }
    return state
}
