//
//  VisitedLocation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

struct VisitedLocation {
    let locationId: String
    let totalStudyHours: Int // 合計勉強時間（時間単位）
    let totalStudyMins: Int  // 合計勉強時間（分単位）
    let fixedRequiredStudyHours: Int? // 必要  な合計勉強時間（時間単位）（固定値）
    let fixedRewardCoin: Int? // 報酬コイン（固定値）
    let visitTimes: VisitTimes
    
    init(
        locationId: String = "",
        totalStudyHours: Int = 0,
        totalStudyMins: Int = 0,
        fixedRequiredStudyHours: Int? = nil,
        fixedRewardCoin: Int? = nil,
        visitTimes: VisitTimes = VisitTimes()
    ) {
        self.locationId = locationId
        self.totalStudyHours = totalStudyHours
        self.totalStudyMins = totalStudyMins
        self.fixedRequiredStudyHours = fixedRequiredStudyHours
        self.fixedRewardCoin = fixedRewardCoin
        self.visitTimes = visitTimes
    }
    
    // 辞書形式への変換
    var toDictionary: [String: Any] {
        return [
            "locationId": locationId,
            "totalStudyHours": totalStudyHours,
            "totalStudyMins": totalStudyMins,
            "visitTimes": visitTimes.toDictionary
        ]
    }
}

// 位置情報の訪問時間を管理する構造体
struct VisitTimes {
    let startTime: Date
    let endTime: Date
    
    init(
        startTime: Date = Date(),
        endTime: Date = Date()
    ) {
        self.startTime = startTime
        self.endTime = endTime
    }
    
    // 辞書形式への変換
    var toDictionary: [String: Any] {
        return [
            "startTime": startTime.timeIntervalSince1970, // UNIXタイムスタンプ形式
            "endTime": endTime.timeIntervalSince1970
        ]
    }
}
