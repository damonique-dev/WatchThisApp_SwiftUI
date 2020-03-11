//
//  TVShowReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

func tvShowReducer(state: TVShowState, action: Action) -> TVShowState {
    var state = state
    switch(action) {
        case let action as TVShowActions.SetTVShowList:
            state.tvLists[action.list] = action.shows
        case let action as TVShowActions.SetTVShowDetail:
            state.tvShowDetail[action.id] = action.tvShowDetail
        case let action as TVShowActions.SetTVShowSeason:
            if state.tvShowSeasons[action.id] == nil {
                state.tvShowSeasons[action.id] = [:]
            }
            state.tvShowSeasons[action.id]![action.seasonId] = action.season
        case let action as TVShowActions.SetTVShowSearch:
            state = addToSearchList(state: state, query: action.query)
            state.tvShowSearch[action.query] = action.tvShows
        case let action as TVShowActions.SetSimilarTVShows:
            state.similarShows[action.id] = action.tvShows
        case let action as TVShowActions.SetShowCast:
            state.tvShowCast[action.id] = action.cast
            state.tvShowCrew[action.id] = action.crew
        case let action as TVShowActions.AddShowToFavorites:
            state.favoriteShows.insert(action.showId)
        case let action as TVShowActions.RemoveShowFromFavorites:
            state.favoriteShows.remove(action.showId)
        case let action as TVShowActions.SetSlugImage:
            state.images[action.slugImage.slug] = action.slugImage
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

private func addToSearchList(state: TVShowState, query: String) -> TVShowState {
    var state = state
    var existingQueries = state.tvSearchQueries
    let index = existingQueries.firstIndex(of: query)
    if index != nil {
        existingQueries.remove(at: index!)
    }
    existingQueries.insert(query, at: 0)
    if (existingQueries.count > 5) {
        existingQueries =  Array(existingQueries.prefix(upTo: 5))
    }
    
    state.tvSearchQueries =  existingQueries
    return state
}
