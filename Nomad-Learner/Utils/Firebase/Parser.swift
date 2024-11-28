//
//  Parse.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/21.
//

import Foundation
import Firebase

final class FixedLocationParser {
    // FixedLocationをパース
    static func parse(_ locationId: String, _ data: [String: Any]) -> FixedLocation? {
        guard let category = data["category"] as? [String],
              let nationalFlagImageUrl = data["nationalFlagImageUrl"] as? String,
              let location = data["location"] as? String,
              let country = data["country"] as? String,
              let region = data["region"] as? String,
              let latitude = data["latitude"] as? Double,
              let longitude = data["longitude"] as? Double,
              let imageUrls = data["imageUrls"] as? [String] else {
            return nil
        }
        
        return FixedLocation(
            locationId: locationId, 
            category: category,
            nationalFlagImageUrl: nationalFlagImageUrl,
            location: location,
            country: country,
            region: region,
            latitude: latitude,
            longitude: longitude,
            imageUrls: imageUrls
        )
    }
}

final class UserParser {
    // Userをパース
    static func parse(_ documentID: String,_ data: [String: Any]) -> User? {
        guard let username = data["username"] as? String,
              let profileImageUrl = data["profileImageUrl"] as? String,
              let currentLocationId = data["currentLocationId"] as? String,
              let currentCoin = data["currentCoin"] as? Int,
              let livingPlaceAndWork = data["livingPlaceAndWork"] as? String,
              let studyContent = data["studyContent"] as? String,
              let goal = data["goal"] as? String,
              let others = data["others"] as? String else {
            return nil
        }
        
        return User(
            userId: documentID,
            username: username,
            profileImageUrl: profileImageUrl,
            currentLocationId: currentLocationId,
            currentCoin: currentCoin,
            livingPlaceAndWork: livingPlaceAndWork,
            studyContent: studyContent,
            goal: goal,
            others: others
        )
    }
}

final class VisitedLocationParser {
    // VisitedLocationをパース
    static func parse(_ documentID: String, _ data: [String: Any]) -> VisitedLocation? {
        guard let totalStudyHours = data["totalStudyHours"] as? Int,
              let totalStudyMins = data["totalStudyMins"] as? Int,
              let fixedRequiredStudyHours = data["fixedRequiredStudyHours"] as? Int,
              let fixedRewardCoin = data["fixedRewardCoin"] as? Int else {
            return nil
        }
                
        return VisitedLocation(
            locationId: documentID,
            totalStudyHours: totalStudyHours,
            totalStudyMins: totalStudyMins,
            fixedRequiredStudyHours: fixedRequiredStudyHours,
            fixedRewardCoin: fixedRewardCoin
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
