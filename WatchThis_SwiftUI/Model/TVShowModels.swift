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
    var first_air_date: String?
    var backdrop_path: String?
    var vote_average: Float?
    var overview: String?
    var poster_path: String?
}

// The detail information of a TV show
struct TVShowDetails: Codable, Identifiable {
    let id: Int
    let name: String
    var popularity: Float?
    var first_air_date: String?
    var backdrop_path: String?
    var vote_average: Float?
    var overview: String?
    var poster_path: String?
    var created_by: [Person]?
    var episode_run_time: [Int]?
    var genres: [Genre]?
    var in_production: Bool?
    var languages: [String]?
    var last_air_date: String?
    var last_episode_to_air: Episode?
    var next_episode_to_air: Episode?
    var networks: [Network]?
    var number_of_episodes: Int?
    var number_of_seasons: Int?
    var seasons: [Season]?
    var status: String?
    var type: String?
    var cast: [Person]?
    var videos: VideoResults?
}

struct TVShowResults: Codable  {
    let results: [TVShowDetails]
    let page: Int
    let total_results: Int
    let total_pages: Int
}

struct Season: Codable, Identifiable {
    var last_air_date: String?
    var episode_count: Int?
    var id: Int?
    var name: String?
    var overview: String?
    var poster_path: String?
    var season_number: Int?
    var episodes: [Episode]?
    var videos: [Video]?
}

struct Episode: Codable, Identifiable {
    var air_date: String?
    var episode_number: Int?
    var id: Int?
    var name: String?
    var overview: String?
    var still_path: String?
    var season_number: Int?
    var show_id: Int?
}

struct VideoResults: Codable {
    var results: [Video]?
}

struct Video: Codable, Identifiable {
    var id: String?
    var name: String?
    var site: String?
    var key: String?
    var type: String?
    var size: Int?
}

struct Genre: Codable, Identifiable {
    var id: Int?
    var name: String?
}

struct TraktListResults: Codable {
    var show: TraktList?
}

struct TraktList: Codable {
    var title: String?
    var year: Int?
    var ids: Ids?
}

struct Ids: Codable {
    var trakt: Int?
    var tmdb: Int?
    var imdb: String?
}

enum TVShowList: String, Codable {
    case Popular
    case Trending
}

//struct Forecast: Codable, Identifiable {
//    var date: String?
//    var tvShows: [TVShow]?
//}

#if DEBUG
let testTVShowDetail = TVShowDetails(
    id: 1416,
    name:"Grey's Anatomy",
    popularity: 124.38,
    first_air_date: "2005-03-27",
    backdrop_path: "/y6JABtgWMVYPx84Rvy7tROU5aNH.jpg",
    overview: "Follows the personal and professional lives of a group of doctors at Seattle’s Grey Sloan Memorial Hospital.",
    poster_path: "/eqgIOObafPJitt8JNh1LuO2fvqu.jpg",
    number_of_episodes: 341,
    number_of_seasons: 15
)

let testSeasons: [Season] = [
    Season(episode_count: 3, name: "Specials"),
    Season(episode_count: 5, name: "Season 1"),
    Season(episode_count: 7, name: "Season 2"),
    Season(episode_count: 9, name: "Season 3"),
    Season(episode_count: 12, name: "Season 4"),
]
#endif
