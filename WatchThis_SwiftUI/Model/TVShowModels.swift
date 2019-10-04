//
//  TvShow.swift
//  WatchThis
//
//  Created by Damonique Thomas on 3/25/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

// The basic information of a TV show
struct TVShow: Codable, Identifiable {
    let id: Int
    let name: String
    var genre_ids: [Int]?
    var popularity: Float?
    var firstAirDate: String?
    var backdropPath: String?
    var voteAverage: Float?
    var overview: String?
    var posterPath: String?
}

// The detail information of a TV show
struct TVShowDetails: Details, Identifiable {
    let id: Int
    let name: String
    var popularity: Float?
    var firstAirDate: String?
    var backdropPath: String?
    var voteAverage: Double?
    var overview: String?
    var posterPath: String?
    var createdBy: [Person]?
    var episodeRunTime: [Int]?
    var genres: [Genre]?
    var inProduction: Bool?
    var languages: [String]?
    var lastAirDate: String?
    var lastEpisodeToAir: Episode?
    var nextEpisodeToAir: Episode?
    var networks: [Network]?
    var numberOfEpisodes: Int?
    var numberOfSeasons: Int?
    var seasons: [Season]?
    var status: String?
    var type: String?
    var credits: Credits?
    var videos: VideoResults?
    var similar: TVShowResults?
    
    var title: String {
        return name
    }
}

struct TVShowResults: Codable  {
    let results: [TVShowDetails]
    let page: Int
    let totalResults: Int
    let totalPages: Int
}

struct Season: Codable, Identifiable {
    var lastAirDate: String?
    var episodeCount: Int?
    var name: String?
    var overview: String?
    var posterPath: String?
    var seasonNumber: Int?
    var episodes: [Episode]?
    var videos: VideoResults?
    var credits: Credits?
    
    var id: Int {
        return seasonNumber!
    }
}

struct Episode: Codable, Identifiable {
    var airDate: String?
    var episodeNumber: Int?
    var name: String?
    var overview: String?
    var stillPath: String?
    var seasonNumber: Int?
    var showId: Int?
    var guestStars: [Cast]?
    
    var id: Int {
        return episodeNumber!
    }
}

enum TVShowList: String, Codable {
    case Popular
    case Trending
    case MostWatchedWeekly
    case Anticipated
}

#if DEBUG
let testTVShowDetail = TVShowDetails(
    id: 1416,
    name:"Grey's Anatomy",
    popularity: 124.38,
    firstAirDate: "2005-03-27",
    backdropPath: "/y6JABtgWMVYPx84Rvy7tROU5aNH.jpg",
    voteAverage: 6.4,
    overview: "Follows the personal and professional lives of a group of doctors at Seattle’s Grey Sloan Memorial Hospital.",
    posterPath: "/eqgIOObafPJitt8JNh1LuO2fvqu.jpg",
    numberOfEpisodes: 341,
    numberOfSeasons: 15
)

let testSeasons: [Season] = [
    Season(episodeCount: 3, name: "Specials", posterPath: "/foM4ImvUXPrD2NvtkHyixq5vhPx.jpg"),
    Season(episodeCount: 5, name: "Season 1", posterPath: "/foM4ImvUXPrD2NvtkHyixq5vhPx.jpg"),
    Season(episodeCount: 7, name: "Season 2", posterPath: "/foM4ImvUXPrD2NvtkHyixq5vhPx.jpg"),
    Season(episodeCount: 9, name: "Season 3", posterPath: "/foM4ImvUXPrD2NvtkHyixq5vhPx.jpg"),
    Season(episodeCount: 12, name: "Season 4", posterPath: "/foM4ImvUXPrD2NvtkHyixq5vhPx.jpg"),
]
#endif
