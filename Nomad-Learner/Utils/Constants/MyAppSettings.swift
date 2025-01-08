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
    
    /// お試し利用用ユーザープロフィール情報（nilの場合は固有ユーザー）
    public static var trialUserProfile: User?
    /// お試し利用中か否か
    public static var isTrialUser: Bool { trialUserProfile != nil }
    /// お試し利用中のメッセージ１
    public static let trialUseMessage1 = "（※お試し利用中は所持金は減りません）"
    /// お試し利用中のメッセージ２
    public static let trialUseMessage2 = "　※お試し利用中は他のユーザーは表示されません。 "
    
    /// 問い合わせフォームURL
    public static let contactFormUrl = URL(string: "https://tayori.com/form/7c23974951b748bcda08896854f1e7884439eb5c/")
    /// プライバシーポリシーURL
    public static let privacyPolicyUrl = URL(string: "https://doc-hosting.flycricket.io/nomad-learner-privacy-policy/5c0bb670-8511-4592-8740-ac71207bb2a4/privacy")
    /// 利用規約URL
    public static let termsAndConditionsUrl = URL(string: "https://doc-hosting.flycricket.io/nomad-learner-terms-of-use/fd03cd99-de62-4301-b93e-d04ce1176970/terms")
    
    /// このアプリで定める最低距離（km）
    public static let minDistance: Int = 1000
    /// 必要な最低勉強時間（時間単位）
    public static let minRequiredStudyHours: Int = 2
    /// 必要な最大勉強時間（時間単位）
    public static let maxRequiredStudyHours: Int = 20
        
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

extension MyAppSettings {
    // ウォークスルー画面
    // First Page
    public static let firstPageTitle  = "旅 ✖️ 勉強"
    public static let firstPageSubtitle = "勉強をもっとワクワクに！"
    public static let firstPageDesc1 = "世界中を旅するような感覚で\n他のユーザーと共に勉強しよう"
    public static let firstPageDesc2 = "旅先でたくさん勉強してコインを貯めて\n貯めたコインでさらに世界中を旅しよう"
    public static let firstPageBluredDesc1 = "世界中を旅するような感覚"
    public static let firstPageBluredDesc2 = "たくさん勉強してコインを貯めて"
    
    // Second Page
    public static let secondPageTitle  = "旅先を選択"
    public static let secondPageDesc = "マップ上に配置された\n約70箇所から旅先を選択しよう"
    public static let secondPageBluredDesc = "約70箇所"

    // Third Page
    public static let thirdPageTitle  = "表示内容を確認"
    public static let thirdPageDesc1  = "旅先に関する以下の内容を確認しよう"
    public static let thirdPageDesc2 = "現在地から旅先までの\n「距離と旅費」"
    public static let thirdPageDesc3 = "「報酬コイン」"
    public static let thirdPageDesc4 = "報酬コインを獲得するために\n「必要な勉強時間」"
    public static let thirdPageBluredDesc2 = "「距離と旅費」"
    public static let thirdPageBluredDesc3 = "「報酬コイン」"
    public static let thirdPageBluredDesc4 = "「必要な勉強時間」"
    
    // Fourth Page
    public static let fourthPageTitle  = "いざ出発！"
    public static let fourthPageDesc1 = "コインで旅費を払います"
    public static let fourthPageDesc2 = "表示されたチケットの内容を再確認して\nいざ出発しよう！"
    public static let fourthPageBluredDesc2 = "表示されたチケットの内容を再確認して"
    
    // Fifth Page
    public static let fifthPageTitle  = "勉強開始！"
    public static let fifthPageDesc1 = "タイマーで勉強時間を計測します"
    public static let fifthPageDesc2 = "様々な景色を画面の背景に\n旅先で出会ったユーザーと共に勉強しよう！"
    public static let fifthPageDesc3 = "好きな時にいつでも勉強を終了できます"
    public static let fifthPageBluredDesc2 = "様々な景色を画面の背景に"
    
    // Sixth Page
    public static let sixthPageTitle  = "勉強を終了すると..."
    public static let sixthPageDesc1 = "その旅先で勉強した合計時間を表示します"
    public static let sixthPageDesc2 = "報酬コイン獲得を目指して\nたくさん勉強しよう"
    public static let sixthPageBluredDesc1 = "その旅先で勉強した合計時間"
    public static let sixthPageBluredDesc2 = "報酬コイン獲得を目指して"
extension MyAppSettings {
    // WalkThroughVC（ウォークスルー画面）
    // 画像名
    public static let appOverviewPageImage1 = "AppOverview1"
    public static let appOverviewPageImage2 = "AppOverview2"
    public static let appOverviewPageImage3 = "AppOverview3"
    public static let selectLocationPageImage = "SelectLocation"
    public static let confirmLocationInfoPageImage = "ConfirmLocationInfo"
    public static let departPageImage = "Depart"
    public static let studyStartPageImage1 = "StudyStart1"
    public static let studyStartPageImage2 = "StudyStart2"
    public static let studyStartPageImage3 = "StudyStart3"
    public static let studyMidwayFinishPageImage = "StudyMidwayFinish"
    public static let studyFinishPageImage = "StudyFinish"
    public static let appStartPageImage = "AppStart"
}
