//
//  LocationsInfo.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/28.
//

import Foundation
import GoogleMaps

struct LocationsInfo {
    let fixedLocations: [FixedLocation]
    let dynamicLocations: [DynamicLocation]
    let visitedLocations: [VisitedLocation]
    let ticketsInfo: [TicketInfo]
    let locationsStatus: [LocationStatus]
    
    init(
        fixedLocations: [FixedLocation] = [],
        dynamicLocations: [DynamicLocation] = [],
        visitedLocations: [VisitedLocation] = [],
        ticketsInfo: [TicketInfo] = [],
        locationStatus: [LocationStatus] = []
    ) {
        self.fixedLocations = fixedLocations
        self.dynamicLocations = dynamicLocations
        self.visitedLocations = visitedLocations
        self.ticketsInfo = ticketsInfo
        self.locationsStatus = locationStatus
    }
}

extension LocationsInfo {
    func createLocationInfo(of locationId: String) -> LocationInfo {
        return LocationInfo(
            fixedLocation: self.fixedLocations.first(where: { $0.locationId == locationId })!,
            visitedLocation: self.visitedLocations.first(where: { $0.locationId == locationId }),
            ticketInfo: self.ticketsInfo.first(where: { $0.locationId == locationId })!,
            locationStatus: self.locationsStatus.first(where: { $0.locationId == locationId })!
        )
    }
    
    func createRewardCoinProgressHUDInfo(userProfile: User) -> RewardCoinProgressHUDInfo? {
        let currentLocationId = userProfile.currentLocationId
        // completionFlag: 0→未達成, 1→初達成, 2以降→すでに達成 "0"の場合はProgressHUDを表示しない
        guard let visitedLocation = visitedLocations.first(where: { $0.locationId == currentLocationId }),
              visitedLocation.completionFlag != 0 else {
            return nil
        }
        
        let completionFlag = visitedLocation.completionFlag
        let currentCoin = userProfile.currentCoin
        let rewardCoin = visitedLocation.fixedRewardCoin ?? 0
        let bonusCoin = visitedLocation.bonusCoin
        // 元々の所持金
        let originalCoin = currentCoin - (rewardCoin + bonusCoin)
        // ボーナスコイン獲得に必要だった勉強時間
        let studyHoursForBonus = bonusCoin / MyAppSettings.bonusCoinMultiplier
        
        return RewardCoinProgressHUDInfo(
            completionFlag: completionFlag,
            currentCoin: currentCoin,
            originalCoin: originalCoin,
            rewardCoin: rewardCoin,
            bonusCoin: bonusCoin,
            studyHoursForBonus: studyHoursForBonus
        )
    }
}

extension LocationsInfo {
    // 現在地の座標を取得
    func getCurrentCoordinate(currentLocationId id: String) -> CLLocationCoordinate2D {
        let currentLocation = fixedLocations.first(where: { $0.locationId == id })!
        return CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
    }
    // 現在地のロケーション取得
    func getCurrentLocation(currentLocationId id: String) -> FixedLocation {
        return fixedLocations.first(where: { $0.locationId == id })!
    }
    // チケット上に表示する必要なロケーション情報を取得
    func getLocationDetailsForTicketInfo(for locationId: String) -> (
        locationId: String,
        destination: String,
        country: String,
        region: String,
        totalStudyHours: Int,
        totalStudyMins: Int,
        fixedRequiredStudyHours: Int?,
        fixedRewardCoin: Int?
    ) {
        guard let fixedLocation = fixedLocations.first(where: { $0.locationId == locationId }) else {
            return ("", "", "", "", 0, 0, nil, nil)
        }
        
        let visitedLocation = visitedLocations.first(where: { $0.locationId == locationId })
        let totalStudyHours = visitedLocation?.totalStudyHours ?? 0
        let totalStudyMins = visitedLocation?.totalStudyMins ?? 0
        let fixedRequiredStudyHours = visitedLocation?.fixedRequiredStudyHours
        let fixedRewardCoin = visitedLocation?.fixedRewardCoin
        
        return (
            fixedLocation.locationId,
            fixedLocation.location,
            fixedLocation.country,
            fixedLocation.region,
            totalStudyHours,
            totalStudyMins,
            fixedRequiredStudyHours,
            fixedRewardCoin
        )
    }
}

struct LocationsInfo2 {
    let locationId: String
    let fixedLocations: FixedLocation
    let dynamicLocations: DynamicLocation
    let visitedLocations: VisitedLocation
    let ticketsInfo: TicketInfo
    let locationsStatus: LocationStatus
    
    init(
        locationId: String,
        fixedLocations: FixedLocation,
        dynamicLocations: DynamicLocation,
        visitedLocations: VisitedLocation,
        ticketsInfo: TicketInfo,
        locationStatus: LocationStatus
    ) {
        self.locationId = locationId
        self.fixedLocations = fixedLocations
        self.dynamicLocations = dynamicLocations
        self.visitedLocations = visitedLocations
        self.ticketsInfo = ticketsInfo
        self.locationsStatus = locationStatus
    }
}
