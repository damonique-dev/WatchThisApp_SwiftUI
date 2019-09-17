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
    var tvShowCast: [Int: [Cast]] = [:]
    var tvShowCrew: [Int: [Crew]] = [:]
    var tvShowSearch: [String: [TVShowDetails]] = [:]
    var similarShows: [Int: [TVShowDetails]] = [:]
    
    // [TVShowId: [SeasonId: Season]]
    var tvShowSeasons: [Int: [Int: Season]] = [:]
        
    var tvLists: [TVShowList : [Int]] = [:]
    
    var favoriteShows: Set<Int> = Set()
    var tvSearchQueries: [String] = []
    var customTVLists: [UUID: CustomTVList] = [:]
}
