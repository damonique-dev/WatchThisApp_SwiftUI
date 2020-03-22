//
//  TraktModels.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/11/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

enum TVShowList: String, Codable {
    case Popular
    case Trending
    case MostWatchedWeekly
    case Anticipated
}

enum MovieList: String, Codable {
    case Popular
    case Trending
    case MostWatchedWeekly
    case TopGrossing
    case NowShowing
    case Anticipated
}

struct TraktShowListResults: Codable {
    var show: TraktShow?
}

struct TraktMovieListResults: Codable {
    var movie: TraktMovie?
}

struct TraktList: Codable {
    var title: String?
    var year: Int?
    var ids: Ids?
}

struct TraktShow: Codable, Identifiable {
    let id = UUID()
    let title: String?
    let year: Int?
    let ids: Ids
    let overview: String?
    let firstAired: String?
    let airs: AirDate?
    let runtime: Int?
    let certification: String?
    let network: String?
    let trailer: String?
    let homepage: String?
    let status: String? // TODO: Change to enum and use icons
    let rating: Double?
    let airedEpisodes: Int?
    let genres: [String]?
    
    var slug: String {
        return ids.slug!
    }
}

struct TraktSeason: Codable, Identifiable {
    let id = UUID()
    let number: Int
    let ids: Ids
    let rating: Double?
    let episodeCount: Int?
    let title: String?
    let overview: String?
    let firstAired: String?
}

struct TraktEpisode: Codable, Identifiable {
    let id = UUID()
    let season: Int
    let number: Int
    let title: String?
    let ids: Ids
    let overview: String?
    let rating: Double?
    let firstAired: String?
    let runtime: Int?
}

struct TraktMovie: Codable, Identifiable {
    let id = UUID()
    let title: String?
    let year: Int?
    let ids: Ids
    let tagline: String?
    let overview: String?
    let released: String?
    let runtime: Int?
    let certification: String?
    let network: String?
    let trailer: String?
    let homepage: String?
    let status: String? // TODO: Change to enum and use icons
    let rating: Double?
    let genres: [String]?
    
    var slug: String {
        return ids.slug!
    }
}

struct TraktPeopleResults: Codable {
    let cast: [TraktCast]
}

struct TraktCast: Codable, Identifiable {
    let id = UUID()
    let character: String?
    let person: TraktPerson
    let episodeCount: Int?
}

struct TraktPerson: Codable, Identifiable {
    let id = UUID()
    let name: String?
    let ids: Ids
    let biography: String?
    let birthday: String?
    let death: String?
    let birthplace: String?
    
    var slug: String {
        return ids.slug!
    }
}

struct TraktCreditsResults: Codable {
    let cast: [TraktCredits]
}

struct TraktCredits: Codable, Identifiable {
    let id = UUID()
    let character: String?
    let show: TraktShow?
    let movie: TraktMovie?
    let episodeCount: Int?
}

struct Ids: Codable {
    var trakt: Int?
    var tmdb: Int?
    var imdb: String?
    var slug: String?
}

struct IdSearchResult: Codable {
    var type: String?
    var show: TraktList?
    var movie: TraktList?
}

struct AirDate: Codable {
    var day: String?
    var time: String?
    var timezone: String?
}

struct TraktImages: Codable {
    var backgroundPath: String?
    var posterPath: String?
}

struct TraktSearchResult: Codable {
    var show: TraktShow?
    var movie: TraktMovie?
    var person: TraktPerson?
}

struct TMDbImagesResponse: Codable {
    var backdropPath: String?
    var posterPath: String?
    var profilePath: String?
    var stillPath: String?
}
