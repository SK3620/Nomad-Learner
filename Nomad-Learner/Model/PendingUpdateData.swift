//
//  PendingUpdate.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/18.
//

import Foundation
import RealmSwift

// 更新保留中の勉強記録データ
class PendingUpdateData: Object {
    // VisitedLocationプロパティ -----
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
    ) -> PendingUpdateData {
        let pendingUpdateData = PendingUpdateData()
        pendingUpdateData.totalStudyHours = visitedLocation.totalStudyHours
        pendingUpdateData.totalStudyMins = visitedLocation.totalStudyMins
        pendingUpdateData.fixedRequiredStudyHours = visitedLocation.fixedRequiredStudyHours!
        pendingUpdateData.fixedRewardCoin = visitedLocation.fixedRewardCoin!
        pendingUpdateData.completionFlag = visitedLocation.completionFlag
        pendingUpdateData.bonusCoin = visitedLocation.bonusCoin
        pendingUpdateData.addedRewardCoin = addedRewardCoin
        
        return pendingUpdateData
    }
}
