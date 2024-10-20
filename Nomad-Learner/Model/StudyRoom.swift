//
//  StudyRoom.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

struct StudyRoom {
    let locationIds: [UsersInLocation]
}

struct UsersInLocation {
    let locationId: String
    let users: [User]
}
