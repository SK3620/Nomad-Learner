//
//  Parse.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/21.
//

import Foundation

final class FixedLocationParser {
    // FixedLocationをパース
    static func parse(_ locationId: String, _ data: [String: Any]) -> FixedLocation? {
        guard let location = data["location"] as? String,
              let country = data["country"] as? String,
              let region = data["region"] as? String,
              let latitude = data["latitude"] as? Double,
              let longitude = data["longitude"] as? Double,
              let imageUrls = data["imageUrls"] as? [String] else {
            return nil
        }
        
        let locationObj = FixedLocation()
        locationObj.locationId = locationId
        locationObj.location = location
        locationObj.country = country
        locationObj.region = region
        locationObj.latitude = latitude
        locationObj.longitude = longitude
        locationObj.imageUrls.append(objectsIn: imageUrls)
        
        return locationObj
    }
}

final class UserParser {
    // Userをパース
    static func parse(_ data: [String: Any]) -> User? {
        guard let username = data["username"] as? String,
              let profileImageUrl = data["profileImageUrl"] as? String,
              let currentLocationId = data["currentLocationId"] as? String,
              let currentCoin = data["currentCoin"] as? Int,
              let livingPlaceAndWork = data["livingPlaceAndWork"] as? String,
              let studyContent = data["studyContent"] as? String,
              let goal = data["goal"] as? String,
              let visitedCountries = data["visitedCountries"] as? Int,
              let weeklyTime = data["weeklyTime"] as? Int,
              let totalTime = data["totalTime"] as? Int else {
            return nil
        }
        
        return User(
            username: username,
            profileImageUrl: profileImageUrl,
            currentLocationId: currentLocationId,
            currentCoin: currentCoin,
            livingPlaceAndWork: livingPlaceAndWork,
            studyContent: studyContent,
            goal: goal,
            visitedCountries: visitedCountries,
            weeklyTime: weeklyTime,
            totalTime: totalTime
        )
    }
}

final class VisitedLocationParser {
    // VisitedLocationをパース
    static func parse(_ documentID: String, _ data: [String: Any]) -> VisitedLocation? {
        guard let locationId = data["locationId"] as? String,
              let coordinatesData = data["coordinates"] as? [String: Any],
              let latitude = coordinatesData["latitude"] as? Double,
              let longitude = coordinatesData["longitude"] as? Double,
              let totalStudyTime = data["totalStudyTime"] as? Double,
              let visitTimesData = data["visitTimes"] as? [String: Any],
              let startTime = visitTimesData["startTime"] as? TimeInterval,
              let endTime = visitTimesData["endTime"] as? TimeInterval else {
            return nil
        }
        
        let coordinates = GeoPoint(
            latitude: latitude,
            longitude: longitude
        )
        let visitTimes = VisitTimes(
            startTime: Date(timeIntervalSince1970: startTime),
            endTime: Date(timeIntervalSince1970: endTime)
        )
        
        return VisitedLocation(
            locationId: locationId,
            coordinates: coordinates,
            totalStudyTime: totalStudyTime,
            visitTimes: visitTimes
        )
    }
}

final class LocationParser {
    // locationをパース
    static func parse(_ documentID: String, _ data: [String: Any]) -> DynamicLocation? {
        guard let userCount = data["userCount"] as? Int else {
            return nil
        }
        
        return DynamicLocation(
            locationId: documentID,
            userCount: userCount
        )
    }
}
