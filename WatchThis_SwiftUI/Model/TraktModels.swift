//
//  TraktModels.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/11/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct TraktShowListResults: Codable {
    var show: TraktList?
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
