//
//  LocationStatus.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/27.
//

import Foundation

struct DynamicLocation {
    var locationId: String
    var userCount: Int
    
    init(locationId: String = "", userCount: Int = 0) {
        self.locationId = locationId
        self.userCount = userCount
    }
}

extension DynamicLocation {
    var toDictionary: [String: Any] {
        return [
            "userCount": userCount
        ]
    }
}
