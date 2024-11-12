//
//  LocationInfo.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/28.
//

import Foundation
import GoogleMaps

struct LocationInfo {
    let fixedLocation: FixedLocation
    let visitedLocation: VisitedLocation? // 初回訪問時は値がないためOptionalで定義
    let ticketInfo: TicketInfo
    let locationStatus: LocationStatus
    
    init(
        fixedLocation: FixedLocation,
        visitedLocation: VisitedLocation?,
        ticketInfo: TicketInfo,
        locationStatus: LocationStatus
    ) {
        self.fixedLocation = fixedLocation
        self.visitedLocation = visitedLocation
        self.ticketInfo = ticketInfo
        self.locationStatus = locationStatus
    }
}
