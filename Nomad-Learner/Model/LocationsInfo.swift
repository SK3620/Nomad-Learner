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
            ticketInfo: self.ticketsInfo.first(where: {$0.locationId == locationId })!
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
