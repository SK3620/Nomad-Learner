//
//  VisitedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation
import Firebase

struct VisitedLocation {
    let locationId: String
    let totalStudyHours: Int // 合計勉強時間（時間単位）
    let totalStudyMins: Int  // 合計勉強時間（分単位）
    let fixedRequiredStudyHours: Int? // 必要  な合計勉強時間（時間単位）（固定値）
    let fixedRewardCoin: Int? // 報酬コイン（固定値）
    
    init(
        locationId: String = "",
        totalStudyHours: Int = 00,
        totalStudyMins: Int = 00,
        fixedRequiredStudyHours: Int? = nil,
        fixedRewardCoin: Int? = nil
    ) {
        self.locationId = locationId
        self.totalStudyHours = totalStudyHours
        self.totalStudyMins = totalStudyMins
        self.fixedRequiredStudyHours = fixedRequiredStudyHours
        self.fixedRewardCoin = fixedRewardCoin
    }
    
    // 辞書形式への変換
    var toDictionary: [String: Any] {
        return [
            "locationId": locationId,
            "totalStudyHours": totalStudyHours,
            "totalStudyMins": totalStudyMins,
            "fixedRequiredStudyHours": fixedRequiredStudyHours!,
            "fixedRewardCoin": fixedRewardCoin!
        ]
    }
}
