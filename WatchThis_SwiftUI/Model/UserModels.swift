//
//  UserModels.swift
//  WatchThis
//
//  Created by Damonique Thomas on 8/19/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation

class User: NSObject {
    var email: String?
    var id: String?
    var name: String?
    var profileImagePath: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        if let idString = id {
            profileImagePath = "https://graph.facebook.com/\(idString)/picture?type=large" as String
        }
    }
}

