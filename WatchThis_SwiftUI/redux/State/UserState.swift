//
//  UserState.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/17/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct UserState: FluxState, Codable {
    var customLists: [UUID: CustomList] = [:]
}
