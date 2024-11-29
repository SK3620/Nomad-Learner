//
//  TicketInfo.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/28.
//

import Foundation
import GoogleMaps

struct TicketInfo {
    let locationId: String // ロケーションID
    let travelDistanceAndCost: Int // 距離と旅費
    let requiredStudyHours: Int // 必要な合計勉強時間（時間単位）
    let rewardCoin: Int // 報酬コイン
    let totalStudyHours: Int // そのロケーションでの合計勉強時間（時間単位）
    let totalStudyMins: Int // そのロケーションでの合計勉強時間（分単位）
    let destination: String // 目的地
    let countryAndRegion: String // 目的地の国と地域
    let currentCoin: Int // 所持金
    let remainingCoin: Int // 旅費支払い後の残高
    let nationalFlagImageUrlString: (current: String, destination: String) // 現在地と目的地の国旗画像URL文字列
    
    init(
        currentCoin: Int,
        currentLocationInfo: FixedLocation,
        fixedLocation: FixedLocation,
        visitedLocation: VisitedLocation?
    ) {
        self.locationId = fixedLocation.locationId
        self.travelDistanceAndCost = TicketInfo.calculateTravelDistanceAndCost(from: currentLocationInfo.coordinate, to: fixedLocation.coordinate)
        self.requiredStudyHours = visitedLocation?.fixedRequiredStudyHours ?? TicketInfo.calculateRequiredStudyHours(for: travelDistanceAndCost)
        self.rewardCoin = visitedLocation?.fixedRewardCoin ?? TicketInfo.calculateRewardCoin(for: travelDistanceAndCost)
        self.totalStudyHours = visitedLocation?.totalStudyHours ?? 0
        self.totalStudyMins = visitedLocation?.totalStudyMins ?? 0
        self.destination = fixedLocation.location
        self.countryAndRegion = fixedLocation.country + " / " + fixedLocation.region
        self.currentCoin = currentCoin
        self.remainingCoin = currentCoin - travelDistanceAndCost
        self.nationalFlagImageUrlString = (currentLocationInfo.nationalFlagImageUrl, fixedLocation.nationalFlagImageUrl)
    }
    
    init() {
        self.locationId = ""
        self.travelDistanceAndCost = 0
        self.requiredStudyHours = 0
        self.rewardCoin = 0
        self.totalStudyHours = 00
        self.totalStudyMins = 00
        self.destination = "ー"
        self.countryAndRegion = "ー"
        self.currentCoin = 0
        self.remainingCoin = 0
        self.nationalFlagImageUrlString =  (current: "", destination: "")
    }
}

extension TicketInfo {
    // 距離を計算（距離==旅費）
    private static func calculateTravelDistanceAndCost(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Int {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return Int(fromLocation.distance(from: toLocation) / 1000)
    }
    
    // 必要な合計勉強時間を計算
    private static func calculateRequiredStudyHours(for distance: Int) -> Int {
        // 10000km以上は必要な最大勉強時間（固定値）を返す
        if distance >= 10000 {
            return MyAppSettings.maxRequiredStudyHours
        }
        
        let requiredStudyHours: Int
        
        if distance < 1_000 {
            // 1,000km未満の場合の計算
            requiredStudyHours = (distance / 10) / 2
            return max(requiredStudyHours, MyAppSettings.minRequiredStudyHours)
        } else {
            // 1,000km以上10,000km未満の場合の計算
            requiredStudyHours = ((distance / 100) + 100) / 2
            return requiredStudyHours
        }
    }
    
    // 報酬コインの計算
    private static func calculateRewardCoin(for distance: Int) -> Int {
        Int(Double(distance) * MyAppSettings.rewardCoinMultiplier)
    }
}
