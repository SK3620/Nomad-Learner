//
//  LocationsInfo.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/28.
//

import Foundation

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
        let studyHoursForBonus = bonusCoin / BonusCoinSettings.multiplier
        
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
