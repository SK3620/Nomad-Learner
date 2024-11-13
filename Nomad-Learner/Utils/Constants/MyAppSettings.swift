//
//  BonusCoinSettings.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/11.
//

import Foundation

struct MyAppSettings {
    /// このアプリで定める最低距離（km）
    public static let minDistance: Int = 1000
    /// 必要な最低勉強時間（時間単位）
    public static let minRequiredStudyHours: Int = 24
        
    /// ボーナスコイン計算用の固定値
    public static let bonusCoinMultiplier: Int = 50
    
    /// ユーザー初期位置
    public static let userInitialLocationId = "mount_fuji"
}
