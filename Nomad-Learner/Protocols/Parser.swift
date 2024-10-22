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



