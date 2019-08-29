//
//  TVShowState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct TVShowState: FluxState, Codable {
    var tvShow: [Int: TVShow] = [:]
    var tvShowDetail: [Int: TVShowDetails] = [:]
    var tvShowCast: [Int: [Person]] = [:]
    var tvShowSearch: [String: [TVShow]] = [:]
    var similarShows: [Int: [TVShow]] = [:]
    
    // [TVShowId: [SeasonId: Season]]
    var tvShowSeasons: [Int: [Int: Season]] = [:]
    
    var popularShows: [Int] = []
}
