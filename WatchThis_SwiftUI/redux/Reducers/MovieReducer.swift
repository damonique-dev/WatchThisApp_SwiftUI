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
        default:
            break
    }
    
    return state
}
