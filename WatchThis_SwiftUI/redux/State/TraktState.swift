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
    case Season, Episode
}

struct TraktState: FluxState, Codable {
    // [TMDBId: Slug]
    var tmdbIdToSlug: [Int: String] = [:]
    
    // Keys are SlugIds from Trakt.
    // Contains images for Shows, Movies, People
    var slugImages: [String: TraktImages] = [:]
    
    // [TraktEntity : [TmdbId: TraktImages]]
    // Contains images for Seasons and Episodes
    var traktImages: [TraktEntity : [Int: TraktImages]] = [:]
    
    // TV
    var traktShows: [String: TraktShow] = [:]
    var traktCast: [String: [TraktCast]] = [:]
    var traktSeasons: [String: [TraktSeason]] = [:]
    var traktEpisodes: [String: [Int: [TraktEpisode]]] = [:]
    var traktRelatedShows: [String: [TraktShow]] = [:]
    var tvLists: [TVShowList : [TraktShow]] = [:]
    
    // People
    var people: [String: TraktPerson] = [:]
    var personShowCredits: [String: [TraktCredits]] = [:]
    var personMovieCredits: [String: [TraktCredits]] = [:]
    
    // Movies
    var traktMovies: [String: TraktMovie] = [:]
    var traktRelatedMovies: [String: [TraktMovie]] = [:]
    var movieLists: [MovieList : [TraktMovie]] = [:]
    
    // Search
    var tvShowSearch: [String: [TraktShow]] = [:]
    var peopleSearch: [String: [TraktPerson]] = [:]
    var movieSearch: [String: [TraktMovie]] = [:]
    var tvSearchQueries: [String] = []
    var movieSearchQueries: [String] = []
    var peopleSearchQueries: [String] = []
}

