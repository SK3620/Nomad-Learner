//
//  Array.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/24.
//

import Foundation
import GoogleMaps

extension Array {
    // 現在地のロケーション情報を取得
    func getCurrentLocationInfo(with currentLocationId: String) -> LocationInfo? {
        let locationsInfo = self as! [LocationInfo]
        let currentLocation = locationsInfo.first(where: { $0.locationId == currentLocationId })
        return currentLocation
    }
    // 現在地の座標を取得
    func getCurrentCoordinate(with currentLocationId: String) -> CLLocationCoordinate2D {
        let locationsInfo = self as! [LocationInfo]
        let currentLocation = locationsInfo.first(where: { $0.locationId == currentLocationId })
        return CLLocationCoordinate2D(
            latitude: currentLocation!.fixedLocation.latitude,
            longitude: currentLocation!.fixedLocation.longitude
        )
    }
    // 報酬コイン獲得ProgressHUD構造体生成
    func createRewardCoinProgressHUDInfo(with userProfile: User) -> RewardCoinProgressHUDInfo? {
        let currentLocationId = userProfile.currentLocationId
        // completionFlag: 0→未達成, 1→初達成, 2以降→すでに達成 "0"の場合はProgressHUDを表示しない
        guard let currentLocationInfo = getCurrentLocationInfo(with: currentLocationId),
              let visitedLocation = currentLocationInfo.visitedLocation,
                currentLocationInfo.visitedLocation?.completionFlag != 0 else {
            return nil
        }
        
        let completionFlag = visitedLocation.completionFlag
        let currentCoin = userProfile.currentCoin
        let rewardCoin = visitedLocation.fixedRewardCoin ?? 0
        let bonusCoin = visitedLocation.bonusCoin
        // 元々の保有コイン
        let originalCoin = currentCoin - ((completionFlag == 1 ? rewardCoin : 0) + bonusCoin)
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

extension Array where Element == User {
    func moveMyUserProfileToFront() -> [User] {
        guard let myUserId = FBAuth.currentUserId else { return self }
        
        // 自分の User を探して先頭に移動させた新しい配列を作成
        var updatedArray = self
        if let currentUser = self.first(where: { $0.userId == myUserId }) {
            updatedArray.removeAll { $0.userId == myUserId } // 既存の自分を削除
            updatedArray.insert(currentUser, at: 0)         // 先頭に挿入
        }
        return updatedArray
    }
}
