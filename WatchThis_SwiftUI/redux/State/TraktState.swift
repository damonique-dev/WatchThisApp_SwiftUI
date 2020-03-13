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
    case Season, Person
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
    var traktRelatedShows: [String: [TraktShow]] = [:]
    
    var tvLists: [TVShowList : [TraktShow]] = [:]
}

