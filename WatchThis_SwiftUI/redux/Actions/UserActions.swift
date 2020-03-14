//
//  UserActions.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/17/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct UserActions {
    struct CreateNewCustomList: Action {
        let listName: String
        let uuid: UUID
    }
    
    struct AddToCustomList: Action {
        let customListUUID: UUID
        let itemType: ItemType
        let slug: String
    }
    
    struct RemoveFromCustomList: Action {
        let customListUUID: UUID
        let itemType: ItemType
        let slug: String
    }
}
