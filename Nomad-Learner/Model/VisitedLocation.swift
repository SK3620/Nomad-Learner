//
//  VisitedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

struct VisitedLocation {
    let locationId: String
    let coordinates: GeoPoint
    let totalStudyTime: Int
    let visitTimes: VisitTimes
}

struct VisitTimes {
    let startTime: Date
    let endTime: Date
}

struct GeoPoint {
    let latitude: Double
    let longitude: Double
}
