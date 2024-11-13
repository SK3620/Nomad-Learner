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

class FixedLocation: Object {
    @Persisted var locationId: String
    @Persisted var location: String
    @Persisted var country: String
    @Persisted var region: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var imageUrls: List<String>
}

extension FixedLocation {
    // imageUrlsを配列に変換するメソッド
    var imageUrlsArr: [String] {
        return Array(imageUrls)
    }
    // 座標
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
