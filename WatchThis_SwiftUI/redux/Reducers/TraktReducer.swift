//
//  TraktReducer.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 3/12/20.
//  Copyright © 2020 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

func traktReducer(state: TraktState, action: Action) -> TraktState {
    var state = state

    switch(action) {
        case let action as TraktActions.SetTVShowList:
            state.tvLists[action.list] = action.shows
            for show in action.shows {
                state.traktShows[show.slug] = show
            }
        case let action as TraktActions.SetSlugImage:
            state.slugImages[action.slug] = action.slugImage
        case let action as TraktActions.SetSeasons:
            state.traktSeasons[action.showSlug] = action.seasons
        case let action as TraktActions.SetEntityImages:
            if state.traktImages[action.entity] == nil {
                state.traktImages[action.entity] = [:]
            }
            state.traktImages[action.entity]![action.tmdbId] = action.slugImage
        case let action as TraktActions.SetCast:
            state.traktShowCast[action.showSlug] = action.cast
            for cast in action.cast {
                let person = cast.person
                state.people[person.slug] = person
            }
        case let action as TraktActions.SetRelatedShows:
            state.traktRelatedShows[action.showSlug] = action.shows
        case let action as TraktActions.SetShow:
            state.traktShows[action.slug] = action.show
        case let action as TraktActions.SetPersonShowCredits:
            state.personShowCredits[action.slug] = action.credit
        case let action as TraktActions.SetEpisodes:
            if state.traktEpisodes[action.showSlug] == nil {
                state.traktEpisodes[action.showSlug] = [:]
            }
            state.traktEpisodes[action.showSlug]![action.seasonNumber] = action.episodes
        default:
            break
    }
    
    return state
}
