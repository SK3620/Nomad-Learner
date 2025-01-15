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
    let isSufficientCoin: Bool // 保有コインが足りるか否か
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
    
    init (
        currentLocationId: String,
        fixedLocation: FixedLocation,
        visitedLocation: VisitedLocation?,
        dynamicLocation: DynamicLocation?,
        ticketInfo: TicketInfo
    ) {
        let locationId = fixedLocation.locationId
        // 参加人数を取得
        let userCount = dynamicLocation?.userCount ?? 0
        // 固定ロケーションIDを取得
        let fixedLocationId = fixedLocation.locationId
        // 過去に訪問したロケーションかどうか
        let hasVisited = (visitedLocation?.locationId == fixedLocationId)
        // 保有コインが足りてるか否か
        let isSufficientCoin = (ticketInfo.currentCoin >= ticketInfo.travelDistanceAndCost)
        // 現在地か否か
        let isMyCurrentLocation = (currentLocationId == fixedLocationId)
        // 訪問履歴がある && 必要な合計勉強時間をクリアしているか否か
        let isCompleted = (hasVisited && ticketInfo.totalStudyHours >= ticketInfo.requiredStudyHours)
        // 訪問履歴がある && 必要な合計勉強時間に到達していないか否か（進行中か否か）
        let isOngoing = (hasVisited && ticketInfo.totalStudyHours < ticketInfo.requiredStudyHours)
        // 初期位置か否か
        let isInitialLocation = (fixedLocation.locationId == MyAppSettings.userInitialLocationId)
        
        self.locationId = locationId
        self.userCount = userCount
        self.isSufficientCoin = isSufficientCoin
        self.isMyCurrentLocation = isMyCurrentLocation
        self.isCompleted = isCompleted
        self.isOngoing = isOngoing
        self.isInitialLocation = isInitialLocation
    }
}
