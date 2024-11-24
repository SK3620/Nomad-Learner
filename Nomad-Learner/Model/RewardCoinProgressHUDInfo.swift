//
//  RewardCoinProgressHUDInfo.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/11.
//

import Foundation

struct RewardCoinProgressHUDInfo {
    let completionFlag: Int
    let currentCoin: Int
    let originalCoin: Int
    let rewardCoin: Int
    let bonusCoin: Int
    let studyHoursForBonus: Int
    
    init(
        completionFlag: Int,
        currentCoin: Int,
        originalCoin: Int,
        rewardCoin: Int,
        bonusCoin: Int,
        studyHoursForBonus: Int
    ) {
        self.completionFlag = completionFlag
        self.currentCoin = currentCoin
        self.originalCoin = originalCoin
        self.rewardCoin = rewardCoin
        self.bonusCoin = bonusCoin
        self.studyHoursForBonus = studyHoursForBonus
    }
}
