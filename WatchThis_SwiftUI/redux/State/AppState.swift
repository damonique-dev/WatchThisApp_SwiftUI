//
//  AppState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 8/28/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import UIKit
import SwiftUIFlux

fileprivate var savePath: URL!
fileprivate let encoder = JSONEncoder()
fileprivate let decoder = JSONDecoder()

struct AppState: FluxState, Codable {
    var tvShowState: TVShowState
    var peopleState: PeopleState
    var movieState: MovieState
    var userState: UserState
    
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
            self.movieState = savedState.movieState
            self.userState = savedState.userState
        } else {
            self.tvShowState = TVShowState()
            self.peopleState = PeopleState()
            self.movieState = MovieState()
            self.userState = UserState()
        }
    }
    
    func archiveState() {
        let shows = tvShowState.tvShow.filter { (arg) -> Bool in
            let (key, _) = arg
            for list in Array(userState.customLists.values) {
                if list.items.contains(where: { (id, item) in
                    return id == key && item.itemType == .TVShow
                }) {
                    return true
                }
            }
            return tvShowState.favoriteShows.contains(key)
        }
        let movies = movieState.movieDetails.filter { (arg) -> Bool in
            let (key, _) = arg
            for list in Array(userState.customLists.values) {
                if list.items.contains(where: { (id, item) in
                    return id == key && item.itemType == .TVShow
                }) {
                    return true
                }
            }
            return movieState.favoriteMovies.contains(key)
        }
        let people = peopleState.people.filter { (arg) -> Bool in
            let (key, _) = arg
            for list in Array(userState.customLists.values) {
                if list.items.contains(where: { (id, item) in
                    return id == key && item.itemType == .TVShow
                }) {
                    return true
                }
            }
            return peopleState.favoritePeople.contains(key)
        }
        var savingState = AppState()
        
        // Save Shows
        savingState.tvShowState.tvShow = shows
        savingState.tvShowState.favoriteShows = tvShowState.favoriteShows
        savingState.tvShowState.tvSearchQueries = tvShowState.tvSearchQueries
        
        // Save Movies
        savingState.movieState.movieDetails = movies
        savingState.movieState.favoriteMovies = movieState.favoriteMovies
        savingState.movieState.movieSearchQueries = movieState.movieSearchQueries
        
        // Save People
        savingState.peopleState.people = people
        savingState.peopleState.favoritePeople = peopleState.favoritePeople
        
        // Save Users
        savingState.userState.customLists = userState.customLists
        
        guard let data = try? encoder.encode(savingState) else {
            return
        }
        try? data.write(to: savePath)
    }
    
    #if DEBUG
    init(tvShowState: TVShowState, peopleState: PeopleState, movieState: MovieState, userState: UserState) {
        self.tvShowState = tvShowState
        self.peopleState = peopleState
        self.movieState = movieState
        self.userState = userState
    }
    #endif
}
