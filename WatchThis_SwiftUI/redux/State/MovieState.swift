//
//  MovieState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/11/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

struct MovieState: FluxState, Codable {
    var movieDetails: [Int: MovieDetails] = [:]
    var movieCast: [Int: [Cast]] = [:]
    var movieCrew: [Int: [Crew]] = [:]
    var movieSearch: [String: [MovieDetails]] = [:]
    var similarMovies: [Int: [MovieDetails]] = [:]
    var nowShowingMovies: [MovieDetails] = []
    var movieLists: [MovieList : [Int]] = [:]
    
    var favoriteMovies: Set<Int> = Set()
    var movieSearchQueries: [String] = []
    var customMovieLists: [UUID: CustomMovieList] = [:]
}
