//
//  LocationInfo.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/28.
//

import Foundation
import GoogleMaps

struct LocationInfo {
    let locationId: String
    let fixedLocation: FixedLocation
    let dynamicLocation: DynamicLocation?
    let visitedLocation: VisitedLocation?
    let ticketInfo: TicketInfo
    let locationStatus: LocationStatus
    
    init(
        locationId: String,
        fixedLocation: FixedLocation,
        dynamicLocation: DynamicLocation?,
        visitedLocation: VisitedLocation?,
        ticketInfo: TicketInfo,
        locationStatus: LocationStatus
    ) {
        self.locationId = locationId
        self.fixedLocation = fixedLocation
        self.dynamicLocation = dynamicLocation
        self.visitedLocation = visitedLocation
        self.ticketInfo = ticketInfo
        self.locationStatus = locationStatus
    }
}
