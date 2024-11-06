//
//  StudyProgressSummary.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/06.
//

import Foundation

struct StudyProgressSummary {
    let totalStudyHours: Int // 合計勉強時間（時間単位）
    let totalStudyMins: Int // 合計勉強時間（分単位）
    let visitedLocationsCount: Int // 訪問国数
    let allLocationsCount: Int // 全ロケーション数
    let completedLocationsCount: Int // クリアしたロケーション数
    
    init(
        fixedLocations: [FixedLocation],
        visitedLocations: [VisitedLocation],
        locationsStatus: [LocationStatus]
    ) {
        let studyTime = StudyProgressSummary.getTotalStudyTimeForAllLocations(visitedLocations: visitedLocations)
        self.totalStudyHours = studyTime.hours
        self.totalStudyMins = studyTime.mins
        self.visitedLocationsCount = visitedLocations.count
        self.allLocationsCount = fixedLocations.count
        self.completedLocationsCount = StudyProgressSummary.getCompletedLocationsCount(locationsStatus: locationsStatus)
    }
    
    // 全ロケーションの合計勉強時間（時間/分数単位）
    private static func getTotalStudyTimeForAllLocations(visitedLocations: [VisitedLocation]) -> (hours: Int, mins: Int) {
        var totalStudyHoursForAllLocations: Int = 00
        var totalStudyMinsForAllLocations: Int = 00
        
        for visitedLocation in visitedLocations {
            totalStudyHoursForAllLocations += visitedLocation.totalStudyHours
            totalStudyMinsForAllLocations += visitedLocation.totalStudyMins
            
            // totalStudyMinsが60以上の場合、totalStudyHoursに1時間追加し、余りを分として残す
            if totalStudyMinsForAllLocations >= 60 {
                totalStudyHoursForAllLocations += totalStudyMinsForAllLocations / 60
                totalStudyMinsForAllLocations %= 60
            }
        }
        return (hours: totalStudyHoursForAllLocations, mins: totalStudyMinsForAllLocations)
    }
    
    // 完了数
    private static func getCompletedLocationsCount(locationsStatus: [LocationStatus]) -> Int {
        var completedLocationsCount: Int = 0
        for locationStatus in locationsStatus {
            if locationStatus.isCompleted {
                completedLocationsCount += 1
            }
        }
        return completedLocationsCount
    }
}
