//
//  AppState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import UIKit

fileprivate var savePath: URL!
fileprivate let encoder = JSONEncoder()
fileprivate let decoder = JSONDecoder()

struct AppState: FluxState, Codable {
    var tvShowState: TVShowState
    var peopleState: PeopleState
    
    init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            savePath = documentDirectory.appendingPathComponent("userData")
        } catch let error {
            fatalError("Couldn't create save state data with error: \(error)")
        }
        
        if let data = try? Data(contentsOf: savePath),
            let savedState = try? decoder.decode(AppState.self, from: data) {
            self.tvShowState = savedState.tvShowState
            self.peopleState = savedState.peopleState
        } else {
            self.tvShowState = TVShowState()
            self.peopleState = PeopleState()
        }
    }
    
    func archiveState() {
        let shows = tvShowState.tvShow.filter { (arg) -> Bool in
            let (key, _) = arg
            return tvShowState.favoriteShows.contains(key)
        }
        var savingState = AppState()
        savingState.tvShowState.tvShow = shows
        savingState.tvShowState.favoriteShows = tvShowState.favoriteShows
        savingState.tvShowState.searchQueries = tvShowState.searchQueries
        guard let data = try? encoder.encode(savingState) else {
            return
        }
        try? data.write(to: savePath)
    }
    
    #if DEBUG
    init(tvShowState: TVShowState, peopleState: PeopleState) {
        self.tvShowState = tvShowState
        self.peopleState = peopleState
    }
    #endif
}
