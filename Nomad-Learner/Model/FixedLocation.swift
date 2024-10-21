//
//  FixedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation
import RealmSwift

/*
struct FixedLocation {
    let details: [LocationDetail]
}

struct LocationDetail {
    let locationId: String
    let name: String
    let country: String
    let region: String
    let coordinates: GeoPoint
    let imageUrls: [String]
}
 */


class FixedLocation: Object {
    @Persisted var locationId: String
    @Persisted var name: String
    @Persisted var country: String
    @Persisted var region: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var imageUrls: List<String>
}
