//
//  FixedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

struct FixedLocation {
    let locationID: Int
    let details: [LocationDetail]
}

struct LocationDetail {
    let name: String
    let country: String
    let region: String
    let coordinates: GeoPoint
    let imageUrls: [String]
}
