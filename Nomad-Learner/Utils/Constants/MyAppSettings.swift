//
//  BonusCoinSettings.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/11.
//

import Foundation
import GoogleMaps
import RxSwift

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
    
    /// 背景画像切り替えインターバル時間
    public static let backgroundImageSwitchInterval = MyAppSettings.dynamicBackgroundImageSwitchInterval
    
    /// ユーザー初期所持金
    public static let userInitialCurrentCoin: Int = 10000
    /// ユーザー初期位置
    public static let userInitialLocationId: String = "mount_fuji"
    /// ユーザー初期位置 座標
    public static let userInitialLocationCoordinate = CLLocationCoordinate2D(latitude: 35.361, longitude: 138.727)
    /// ユーザー初期位置 座標 カメラ
    public static let userInitialLocationCoordinateWithZoom = GMSCameraPosition(target: MyAppSettings.userInitialLocationCoordinate , zoom: 1.0)
}

extension MyAppSettings {
    /// 背景画像切り替えインターバル時間
    private static var dynamicBackgroundImageSwitchInterval: RxTimeInterval {
        #if DEVELOP // 開発環境
        return RxTimeInterval.seconds(10) // 10秒
        #else // 本番環境
        return RxTimeInterval.seconds(300) // 5分
        #endif
    }
}
