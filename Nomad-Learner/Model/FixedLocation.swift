//
//  FixedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation
import RealmSwift
import Kingfisher
import GoogleMaps

struct FixedLocation {
    var locationId: String
    var category: String
    var location: String
    var country: String
    var region: String
    var latitude: Double
    var longitude: Double
    var imageUrls: [String]
    
    init(
        locationId: String,
        category: String,
        location: String,
        country: String,
        region: String,
        latitude: Double,
        longitude: Double,
        imageUrls: [String]
    ) {
        self.locationId = locationId
        self.category = category
        self.location = location
        self.country = country
        self.region = region
        self.latitude = latitude
        self.longitude = longitude
        self.imageUrls = imageUrls
    }
}

extension FixedLocation {
    // 座標
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    // チケット情報作成用にフォーマットされたデータ
    var formattedDataForTicketInfo: (
        locationId: String,
        coordinate: CLLocationCoordinate2D,
        destination: String,
        country: String,
        region: String
    ) {
        return (
            locationId: locationId,
            coordinate: coordinate,
            destination: location,
            country: country,
            region: region
        )
    }
}
