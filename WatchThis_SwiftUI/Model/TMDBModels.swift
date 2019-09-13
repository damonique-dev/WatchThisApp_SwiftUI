//
//  TMDBModels.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

protocol Details: Codable, Identifiable {
    var id: Int { get }
    var posterPath: String? { get }
    var overview: String? { get }
    
    var title: String {get }
}

struct VideoResults: Codable {
    var results: [Video]?
}

struct Video: Codable, Identifiable {
    var id: String?
    var name: String?
    var site: String?
    var key: String?
    var type: String?
    var size: Int?
}

struct Genre: Codable, Identifiable {
    var id: Int?
    var name: String?
}
