//
//  AppState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import UIKit

struct AppState: FluxState, Codable {
    var tvShowState: TVShowState
    var peopleState: PeopleState
    var images: [String: [ImageService.Size: Data]]
    
    init() {
        self.tvShowState = TVShowState()
        self.peopleState = PeopleState()
        self.images = [:]
    }
    
    #if DEBUG
    init(tvShowState: TVShowState, peopleState: PeopleState) {
        self.tvShowState = tvShowState
        self.peopleState = peopleState
        self.images = [:]
    }
    #endif
}
