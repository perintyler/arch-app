//
//  UserData.swift
//  arch_mobile
//
//  Created by Tyler Perin on 10/16/18.
//  Copyright © 2018 arch. All rights reserved.
//

import Foundation

struct AppData: Decodable {
    var venues: [Venue]
    var user_events: [Event]
    var num_unread_notifs: Int
}
