//
//  ImageCacheManager.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/24.
//

import Foundation
import Kingfisher

class ImageCacheManager {
    // 画像をあらかじめ読み込んでおく
    static func prefetch(from urls: [URL]) {
        let prefether = ImagePrefetcher(urls: urls)
        prefether.start()
    }
}
