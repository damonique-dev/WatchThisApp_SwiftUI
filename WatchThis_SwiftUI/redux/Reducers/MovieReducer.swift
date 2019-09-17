//
//  MovieReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/11/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

func movieReducer(state: MovieState, action: Action) -> MovieState {
    var state = state
    
    switch(action) {
        case let action as MovieActions.SetMovieList:
            state.movieLists[action.list] = action.ids
        case let action as MovieActions.SetMovieDetail:
            state.movieDetails[action.id] = action.movieDetails
        case let action as MovieActions.AddMovieToFavorites:
            state.favoriteMovies.insert(action.movieId)
        case let action as MovieActions.RemoveMovieFromFavorites:
            state.favoriteMovies.remove(action.movieId)
        case let action as MovieActions.SetNowShowingMovies:
            state.nowShowingMovies = action.movies
        case let action as MovieActions.SetMovieSearch:
            state.movieSearch[action.query] = action.movies
            state = addToSearchList(state: state, query: action.query)
        case let action as MovieActions.AddMovieToCustomList:
            state.customMovieLists[action.customListUUID]?.movieIds.insert(action.movieId)
        case let action as MovieActions.RemoveMovieFromCustomList:
            state.customMovieLists[action.customListUUID]?.movieIds.remove(action.movieId)
        default:
            break
    }
    
    return state
}

private func addToSearchList(state: MovieState, query: String) -> MovieState {
    var state = state
    var existingQueries = state.movieSearchQueries
    let index = existingQueries.firstIndex(of: query)
    if index != nil {
        existingQueries.remove(at: index!)
    }
    existingQueries.insert(query, at: 0)
    if (existingQueries.count > 5) {
        existingQueries =  Array(existingQueries.prefix(upTo: 5))
    }
    
    state.movieSearchQueries =  existingQueries
    return state
}
