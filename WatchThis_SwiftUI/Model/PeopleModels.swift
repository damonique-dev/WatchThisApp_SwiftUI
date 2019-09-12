//
//  Person.swift
//  WatchThis
//
//  Created by Damonique Thomas on 8/4/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

struct Credits: Codable {
    var id: Int?
    var cast: [Cast]?
    var crew: [Crew]?
}

struct Cast: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    var profile_path: String?
}

struct Crew: Codable, Identifiable {
    let id: Int
    let name: String
    var job: String?
    var profile_path: String?
}

// The basic information about a Person
struct Person: Codable, Identifiable {
    var character: String?
    var credit_id: String?
    var id: Int?
    var name: String?
    var gender: Int?
    var profile_path: String?
    var biography: String?
    var place_of_birth: String?
    var birthday: String?
    var deathday: String?
    var homepage: String?
}

struct Network: Codable {
    var id: Int?
    var name: String?
    var logo_path: String?
}

#if DEBUG
let testPeople: [Person] = [
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
    Person(character: "Meridith Grey", name: "Ellen Pompeo"),
]
#endif
