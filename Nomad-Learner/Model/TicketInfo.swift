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
    let missionStudyTime: Int // 必要な合計勉強時間
    let rewardCoin: Int // 報酬コイン
    let totalStudyHours: Int // そのロケーションでの合計勉強時間（時間単位）
    let totalStudyMins: Int // そのロケーションでの合計勉強時間（分単位）
    let destination: String // 目的地
    let countryAndRegion: String // 目的地の国と地域
    let currentCoin: Int // 所持金
    let remainingCoin: Int // 旅費支払い後の残高
    
    init(
        coordinate: (
            from: CLLocationCoordinate2D,
            to: CLLocationCoordinate2D
        ),
        locationDetials: (
            locationId: String,
            destination: String,
            country: String,
            region: String,
            totalStudyHours: Int,
            totalStudyMins: Int
        ),
        currentCoin: Int
    ) {
        self.locationId = locationDetials.locationId
        self.travelDistanceAndCost = TicketInfo.calculateTravelDistanceAndCost(from: coordinate.from, to: coordinate.to)
        self.missionStudyTime = TicketInfo.calculateMissionStudyTime(for: self.travelDistanceAndCost)
        self.rewardCoin = TicketInfo.calculateRewardCoin(for: self.travelDistanceAndCost)
        self.totalStudyHours = locationDetials.totalStudyHours
        self.totalStudyMins = locationDetials.totalStudyMins
        self.destination = locationDetials.destination
        self.countryAndRegion = locationDetials.country + " / " + locationDetials.region
        self.currentCoin = currentCoin
        self.remainingCoin = self.currentCoin - self.travelDistanceAndCost
    }
    
    init() {
        self.locationId = ""
        self.travelDistanceAndCost = 0
        self.missionStudyTime = 0
        self.rewardCoin = 0
        self.totalStudyHours = 0
        self.totalStudyMins = 0
        self.destination = "ー"
        self.countryAndRegion = "ー"
        self.currentCoin = 0
        self.remainingCoin = 0
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
    private static func calculateMissionStudyTime(for distance: Int) -> Int {
        distance / 100
    }
    
    // 報酬コインの計算
    private static func calculateRewardCoin(for distance: Int) -> Int {
        Int(Double(distance) * 1.2)
    }
}
