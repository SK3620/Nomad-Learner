//
//  BonusCoinSettings.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/11.
//

import Foundation
import GoogleMaps

struct MyAppSettings {
    /// このアプリで定める最低距離（km）
    public static let minDistance: Int = 1000
    /// 必要な最低勉強時間（時間単位）
    public static let minRequiredStudyHours: Int = 24
    /// 必要な最大勉強時間（時間単位）
    public static let maxRequiredStudyHours: Int = 100
        
    /// 報酬コイン計算用の固定値
    public static let rewardCoinMultiplier: Double = 1.7
    /// ボーナスコイン計算用の固定値
    public static let bonusCoinMultiplier: Int = 100
    
    /// ユーザー初期位置
    public static let userInitialLocationId = "mount_fuji"
    /// ユーザー初期位置 座標
    public static let userInitialLocationCoordinate = CLLocationCoordinate2D(latitude: 35.361, longitude: 138.727)
    /// ユーザー初期位置 座標 カメラ
    public static let userInitialLocationCoordinateWithZoom = GMSCameraPosition(target: MyAppSettings.userInitialLocationCoordinate , zoom: 1.0)
}
