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
            totalStudyMins: Int,
            fixedRequiredStudyHours: Int?,
            fixedRewardCoin: Int?
        ),
        currentCoin: Int,
        currentCountry: String
    ) {
        self.locationId = locationDetials.locationId
        self.travelDistanceAndCost = TicketInfo.calculateTravelDistanceAndCost(from: coordinate.from, to: coordinate.to)
        self.requiredStudyHours = locationDetials.fixedRequiredStudyHours ?? TicketInfo.calculateMissionStudyTime(for: self.travelDistanceAndCost)
        self.rewardCoin = locationDetials.fixedRewardCoin ?? TicketInfo.calculateRewardCoin(for: self.travelDistanceAndCost)
        self.totalStudyHours = locationDetials.totalStudyHours
        self.totalStudyMins = locationDetials.totalStudyMins
        self.destination = locationDetials.destination
        self.countryAndRegion = locationDetials.country + " / " + locationDetials.region
        self.currentCoin = currentCoin
        self.remainingCoin = self.currentCoin - self.travelDistanceAndCost
        self.nationalFlagImageUrlString = TicketInfo.getNationalFlagImageStringURLs(of: currentCountry, of: locationDetials.country)
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
    private static func calculateMissionStudyTime(for distance: Int) -> Int {
        // アプリ内で定める最低距離よりも小さい場合、最低限必要な勉強時間（固定値）を返す
        MyAppSettings.minDistance > distance
        ? MyAppSettings.minRequiredStudyHours
        : distance / 100
    }
    
    // 報酬コインの計算
    private static func calculateRewardCoin(for distance: Int) -> Int {
        Int(Double(distance) * 1.2)
    }
    
    private static func getNationalFlagImageStringURLs(
        of currentCountry: String,
        of destinationCountry: String
    ) -> (current: String, destination: String) {
        let dic = NationalFlagImageStringURLs.dic
        return (current: dic[currentCountry] ?? "", destination: dic[destinationCountry] ?? "")
    }
}
