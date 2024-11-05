//
//  LocationStatus.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/30.
//

import Foundation

struct LocationStatus {
    let locationId: String // ロケーションID
    let userCount: Int // 参加人数
    let isMyCurrentLocation: Bool // 現在地か否か
    let isCompleted: Bool // 必要な合計勉強時間をクリアしているか否か
    let isOngoing: Bool // 進行中かどうか
    
    init(
        locationId: String,
        userCount: Int,
        isMyCurrentLocation: Bool,
        isCompleted: Bool,
        isOngoing: Bool
    ) {
        self.locationId = locationId
        self.userCount = userCount
        self.isMyCurrentLocation = isMyCurrentLocation
        self.isCompleted = isCompleted
        self.isOngoing = isOngoing
    }
    
}
