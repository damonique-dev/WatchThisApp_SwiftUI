//
//  TraktModels.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/11/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct TraktShowListResults: Codable {
    var show: TraktShow?
}

struct TraktMovieListResults: Codable {
    var movie: TraktList?
    var revenue: Int?
}

struct TraktList: Codable {
    var title: String?
    var year: Int?
    var ids: Ids?
}

struct TraktShow: Codable, Identifiable {
    let id = UUID()
    var title: String?
    var year: Int?
    var ids: Ids?
    var overview: String?
    var firstAired: String?
    var airs: AirDate?
    var runtime: Int?
    var certification: String?
    var network: String?
    var trailer: String?
    var homepage: String?
    var status: String? // TODO: Change to enum and use icons
    var rating: Double?
    var airedEpisodes: Int?
    var genres: [String]?
    
    var slug: String? {
        return ids!.slug
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
}

struct TraktShowCreditsResults: Codable {
    let cast: [TraktShowCredits]
}

struct TraktShowCredits: Codable, Identifiable {
    let id = UUID()
    let character: String?
    let show: TraktShow
    let episodeCount: Int?
    let seriesRegular: Bool
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
