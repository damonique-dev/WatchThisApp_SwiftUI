//
//  TVShowState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

enum TraktEntity: String, Codable {
    case Season, Person
}

struct TVShowState: FluxState, Codable {
    var tvShowDetail: [Int: TVShowDetails] = [:]
    var tvShowCast: [Int: [Cast]] = [:]
    var tvShowCrew: [Int: [Crew]] = [:]
    var tvShowSearch: [String: [TVShowDetails]] = [:]
    var similarShows: [Int: [TVShowDetails]] = [:]
    
    // [TVShowId: [SeasonId: Season]]
    var tvShowSeasons: [Int: [Int: Season]] = [:]
    
    var favoriteShows: Set<Int> = Set()
    var tvSearchQueries: [String] = []
    // [TMDBId: Slug]
    var tvShowSlugId: [Int: String] = [:]
    
    // Keys are SlugIds from Trakt.
    var slugImages: [String: TraktImages] = [:]
    // [TraktEntity : [TmdbId: TraktImages]]
    var traktImages: [TraktEntity : [Int: TraktImages]] = [:]
    
    var traktShows: [String: TraktShow] = [:]
    var traktShowCast: [String: [TraktCast]] = [:]
    var traktSeasons: [String: [TraktSeason]] = [:]
    var traktRelatedShows: [String: [TraktShow]] = [:]
    
    var tvLists: [TVShowList : [TraktShow]] = [:]
    var tvShow: [Int: TVShow] = [:]
}
