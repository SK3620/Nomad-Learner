//
//  PendingUpdate.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/18.
//

import Foundation
import RealmSwift

// 更新保留中の勉強記録データ
// 1アカウント1PendingUpdateData
class PendingUpdateData: Object {
    // VisitedLocationプロパティ -----
    @Persisted var userId: String // ユニーク
    @Persisted var locationId: String
    @Persisted var totalStudyHours: Int
    @Persisted var totalStudyMins: Int
    @Persisted var fixedRequiredStudyHours: Int
    @Persisted var fixedRewardCoin: Int
    @Persisted var completionFlag: Int
    @Persisted var bonusCoin: Int
    // -----
    @Persisted var addedRewardCoin: Int // 追加プロパティ
}

extension PendingUpdateData {
    public static func create(
        visitedLocation: VisitedLocation,
        addedRewardCoin: Int
    ) -> PendingUpdateData? {
        guard let userId = FBAuth.currentUserId else { return nil }
        let pendingUpdateData = PendingUpdateData()
        pendingUpdateData.userId = userId
        pendingUpdateData.locationId = visitedLocation.locationId
        pendingUpdateData.totalStudyHours = visitedLocation.totalStudyHours
        pendingUpdateData.totalStudyMins = visitedLocation.totalStudyMins
        pendingUpdateData.fixedRequiredStudyHours = visitedLocation.fixedRequiredStudyHours!
        pendingUpdateData.fixedRewardCoin = visitedLocation.fixedRewardCoin!
        pendingUpdateData.completionFlag = visitedLocation.completionFlag
        pendingUpdateData.bonusCoin = visitedLocation.bonusCoin
        pendingUpdateData.addedRewardCoin = addedRewardCoin
        
        return pendingUpdateData
    }
    
    var toVisitedLocation: VisitedLocation {
        return VisitedLocation(
            locationId: locationId,
            totalStudyHours: totalStudyHours,
            totalStudyMins: totalStudyMins,
            fixedRequiredStudyHours: fixedRequiredStudyHours,
            fixedRewardCoin: fixedRewardCoin,
            completionFlag: completionFlag,
            bonusCoin: bonusCoin
        )
    }
}
