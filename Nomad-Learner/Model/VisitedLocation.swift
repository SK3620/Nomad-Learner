//
//  VisitedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

import Foundation

struct VisitedLocation {
    let locationId: String
    let coordinates: GeoPoint
    let totalStudyTime: Double
    let visitTimes: VisitTimes
    
    init(
        locationId: String = "",
        coordinates: GeoPoint = GeoPoint(),
        totalStudyTime: Double = 0,
        visitTimes: VisitTimes = VisitTimes()
    ) {
        self.locationId = locationId
        self.coordinates = coordinates
        self.totalStudyTime = totalStudyTime
        self.visitTimes = visitTimes
    }
}

struct VisitTimes {
    let startTime: Date
    let endTime: Date
    
    init(
        startTime: Date = Date(),
        endTime: Date = Date()
    ) {
        self.startTime = startTime
        self.endTime = endTime
    }
}

struct GeoPoint {
    let latitude: Double
    let longitude: Double
    
    init(
        latitude: Double = 0.0,
        longitude: Double = 0.0
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension VisitedLocation {
    // VisitedLocationのプロパティを辞書形式に変換します。
    var toDictionary: [String: Any] {
        return [
            "locationId": locationId,
            "coordinates": coordinates.toDictionary, // GeoPointも辞書形式に変換
            "totalStudyTime": totalStudyTime,
            "visitTimes": visitTimes.toDictionary // VisitTimesも辞書形式に変換
        ]
    }
}

extension VisitTimes {
    /// VisitTimesのプロパティを辞書形式に変換します。
    var toDictionary: [String: Any] {
        return [
            "startTime": startTime.timeIntervalSince1970, // UNIXタイムスタンプとして保存
            "endTime": endTime.timeIntervalSince1970 // UNIXタイムスタンプとして保存
        ]
    }
}

extension GeoPoint {
    /// GeoPointのプロパティを辞書形式に変換します。
    var toDictionary: [String: Any] {
        return [
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}
