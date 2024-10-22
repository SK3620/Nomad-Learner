//
//  FixedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation
import RealmSwift
import Kingfisher

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
    
    // 画像をあらかじめ読み込んでおく
   static func prefetchImages(from fixedLocations: [FixedLocation]) {
        // 全てのimageUrlsをURL型に変換し、nilのURLは除外
        let urls = fixedLocations
            .flatMap { $0.imageUrlsArr }
            .compactMap { URL(string: $0) }
        // 画像を事前に読み込む
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }
}
