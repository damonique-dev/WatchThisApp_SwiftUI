//
//  TraktState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Blake on 3/12/20.
//  Copyright © 2020 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

enum TraktEntity: String, Codable {
    case Season, Episode, Person
}

struct TraktState: FluxState, Codable {
    // [TMDBId: Slug]
    var tvShowSlugId: [Int: String] = [:]
    
    // Keys are SlugIds from Trakt.
    var slugImages: [String: TraktImages] = [:]
    // [TraktEntity : [TmdbId: TraktImages]]
    var traktImages: [TraktEntity : [Int: TraktImages]] = [:]
    
    var traktShows: [String: TraktShow] = [:]
    var traktShowCast: [String: [TraktCast]] = [:]
    var traktSeasons: [String: [TraktSeason]] = [:]
    var traktEpisodes: [String: [Int: [TraktEpisode]]] = [:]
    var traktRelatedShows: [String: [TraktShow]] = [:]
    var people: [String: TraktPerson] = [:]
    
    var tvLists: [TVShowList : [TraktShow]] = [:]
    
    var personShowCredits: [String: [TraktShowCredits]] = [:]
    //TODO: Add movie credits
}

