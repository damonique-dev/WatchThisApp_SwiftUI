//
//  UserModels.swift
//  WatchThis
//
//  Created by Damonique Thomas on 8/19/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

protocol CustomList: Codable, Identifiable {
    var id: UUID { get }
    var listName: String { get set }
    var ids: Set<Int> { get }
}

struct CustomTVList: CustomList {
    let id: UUID
    var listName: String
    var tvIds: Set<Int> = Set()
    
    var ids: Set<Int> {
        return tvIds
    }
}

struct CustomMovieList: CustomList {
    let id = UUID()
    var listName: String
    var movieIds: Set<Int> = Set()
    
    var ids: Set<Int> {
        return movieIds
    }
}

struct CustomPeopleList: CustomList {
    let id = UUID()
    var listName: String
    var peopleIds: Set<Int> = Set()
    
    var ids: Set<Int> {
        return peopleIds
    }
}
