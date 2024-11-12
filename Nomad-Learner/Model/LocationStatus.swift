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
    let isSufficientCoin: Bool // 所持金が足りるか否か
    let isMyCurrentLocation: Bool // 現在地か否か
    let isCompleted: Bool // 必要な合計勉強時間をクリアしているか否か
    let isOngoing: Bool // 進行中かどうか
    let isInitialLocation: Bool // 初期位置か否か
    
    init(
        locationId: String = "",
        userCount: Int = 0,
        isSufficientCoin: Bool = false,
        isMyCurrentLocation: Bool = false,
        isCompleted: Bool = false,
        isOngoing: Bool = false,
        isInitialLocation: Bool = false
    ) {
        self.locationId = locationId
        self.userCount = userCount
        self.isSufficientCoin = isSufficientCoin
        self.isMyCurrentLocation = isMyCurrentLocation
        self.isCompleted = isCompleted
        self.isOngoing = isOngoing
        self.isInitialLocation = isInitialLocation
    }
    
}
