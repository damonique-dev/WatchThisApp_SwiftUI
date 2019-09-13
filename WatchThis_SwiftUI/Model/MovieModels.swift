//
//  MovieModels.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/11/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct MovieDetails: Details {
    let id: Int
    let title: String
    var posterPath: String?
    var backgroundPath: String?
    var overview: String?
    var genres: [Genre]?
    var releaseDate: String?
    var runtime: Int?
    var revenue: Int?
    var budget: Int?
    var videos: VideoResults?
    var credits: Credits?
    var similar: MovieResults?
//    var status: MovieStatus?
}

struct MovieResults: Codable  {
    let results: [MovieDetails]
    let page: Int
    let totalResults: Int
    let totalPages: Int
}

enum MovieStatus {
    case Rumored
    case Planned
    case InProduction
    case PostProduction
    case Released
    case Canceled
}

enum MovieList: String, Codable {
    case Popular
    case Trending
    case MostWatchedWeekly
    case TopGrossing
    case NowShowing
    case Anticipated
}
