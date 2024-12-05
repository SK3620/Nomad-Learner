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
    /// 開発者メールアドレス
    public static let developerEmail = "k.n.t11193620@gmail.com"
    
    /// お試し利用用のユーザー情報（固定）
    public static let usernameForTrial = "Nomad-Learner"
    public static let userIdForTrial = MyAppSettings.dynamicUserIdForTrial
    public static let emailForTrial = "nomad@learner.jp"
    public static let passwordForTrial = "NomadLearner1234"
    
    /// 問い合わせフォームURL
    public static let contactFormUrl = URL(string: "https://tayori.com/form/7c23974951b748bcda08896854f1e7884439eb5c/")
    /// プライバシーポリシーURL
    public static let privacyPolicyUrl = URL(string: "https://doc-hosting.flycricket.io/nomad-learner-privacy-policy/5c0bb670-8511-4592-8740-ac71207bb2a4/privacy")
    /// 利用規約URL
    public static let termsAndConditionsUrl = URL(string: "https://doc-hosting.flycricket.io/nomad-learner-terms-of-use/fd03cd99-de62-4301-b93e-d04ce1176970/terms")
    
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
    /// お試し利用用のユーザーのuserId（固定）
    private static var dynamicUserIdForTrial: String {
        #if DEVELOP // 開発環境
        return "6Hlgc3PcXNVNfHJUHNjvrtGdnsd2"
        #else // 本番環境
        return "oaeQC4DAuaNm8X3dMN4p2n3xQrM2"
        #endif
    }

    /// 背景画像切り替えインターバル時間
    private static var dynamicBackgroundImageSwitchInterval: Int {
        #if DEVELOP // 開発環境
        return 1 // 1分
        #else // 本番環境
        return 5 // 5分
        #endif
    }
}
