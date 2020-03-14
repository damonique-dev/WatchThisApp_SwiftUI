//
//  UserModels.swift
//  WatchThis
//
//  Created by Damonique Thomas on 8/19/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

struct CustomList: Codable, Identifiable {
    var id: UUID
    var listName: String
    var items: [String: ListItem] = [:]
}

struct ListItem: Codable, Identifiable {
    let id = UUID()
    let slug: String
    let itemType: ItemType
}

enum ItemType: String, Codable {
    case TVShow
    case Movie
    case Person
}
