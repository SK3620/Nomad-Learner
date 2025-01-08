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
    public static let maxRequiredStudyHours: Int = 8
        
    /// ボーナスコイン計算用の固定値
    public static let bonusCoinMultiplier: Int = 1000
    
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
    // アプリ概要
    public static let appOverviewPageTitle  = "Nomad-Learner"
    public static let appOverviewPageSubtitle = "「旅✖️自習」で自習をもっとワクワクに！"
    public static let appOverviewPageDesc1 = "世界中を旅するような感覚で\n他のユーザーと共に自習しよう"
    public static let appOverviewPageDesc2 = "旅先を選んで、その場所で自習を開始\n目標の自習時間を達成すると\n報酬コインがもらえます"
    public static let appOverviewPageDesc3 = "貯めたコインで次の旅先へ進もう！"
    public static let appOverviewPageBluredDesc1 = "世界中を旅するような感覚"
    public static let appOverviewPageBluredDesc2 = "旅先を選んで、その場所で自習を開始\n目標の自習時間を達成すると\n報酬コインがもらえます"
        
    // 旅先選択
    public static let selectLocationPageTitle  = "旅先を選ぼう"
    public static let selectLocationPageDesc1 = "マップ上の約70箇所から旅先を選ぼう"
    public static let selectLocationPageDesc2 = "マーカー上の数字は、現在その旅先で\n自習中のユーザー数を表します"
    public static let selectLocationPageBluredDesc1 = "約70箇所"
    public static let selectLocationPageBluredDesc2 = "現在その旅先で\n自習中のユーザー数"
    
    // ロケーション情報確認
    public static let confirmLocationInfoPageTitle  = "表示内容を確認"
    public static let confirmLocationInfoPageDesc1 = "① 旅費を支払うための「保有コイン」"
    public static let confirmLocationInfoPageDesc2 = "② 現在地から旅先までの\n「距離」と「旅費」"
    public static let confirmLocationInfoPageDesc3 = "③ 報酬コインを獲得するために\n「必要な自習時間」"
    public static let confirmLocationInfoPageDesc4 = "④ 獲得できる「報酬コイン」"
    public static let confirmLocationInfoPageBluredDesc1 = "「保有コイン」"
    public static let confirmLocationInfoPageBluredDesc2 = ["「距離」", "「旅費」"]
    public static let confirmLocationInfoPageBluredDesc3 = "「必要な自習時間」"
    public static let confirmLocationInfoPageBluredDesc4 = "「報酬コイン」"

    // 出発
    public static let departPageTitle  = "いざ出発！"
    public static let departPageDesc1 = "チケット内容を確認"
    public static let departPageDesc2 = "保有コインで旅費を支払って出発！"
    public static let departPageBluredDesc = "チケット内容"
    
    // 自習開始
    public static let studyStartPageTitle  = "旅先で自習開始！"
    public static let studyStartPageDesc1 = "タイマーで自習時間を計測"
    public static let studyStartPageDesc2 = "目標である「必要な自習時間」を目指そう！"
    public static let studyStartPageDesc3 = "旅先の様々な景色を背景に\n旅先で出会ったユーザーと共に自習しよう！"
    public static let studyStartPageBluredDesc2 = "目標である「必要な自習時間」を目指そう！"
    public static let studyStartPageBluredDesc3 = "旅先の様々な景色を背景に"

    // 自習終了（中断）
    public static let studyMidwayFinishPageTitle  = "途中で自習を\n終了してもOK"
    public static let studyMidwayFinishPageDesc = "好きなときにいつでも自習を終了して\n他の旅先で自習を始めることも可能"
    public static let studyMidwayFinishPageBluredDesc = "他の旅先で自習を始めることも可能"
    
    // 自習終了（目標の自習時間クリア）
    public static let studyFinishPageTitle  = "自習を終了すると…"
    public static let studyFinishPageDesc1 = "その旅先で自習した合計時間を表示"
    public static let studyFinishPageDesc2 = "その旅先での目標の自習時間を達成すると\n報酬コインがもらえます"
    public static let studyFinishPageDesc3 = "貯めたコインで次の旅先へ進もう！"
    public static let studyFinishPageBluredDesc2 = "目標の自習時間を達成すると"
    
    // アプリを使い始める
    public static let appStartPageTitle  = "始めよう！"
    public static let appStartPageDesc1 = "スタート地点は日本！"
    public static let appStartPageDesc2 = "旅先を選んでいざ出発＆自習を始めよう！"
    public static let appStartPageBluredDesc1 = "スタート地点は日本！"
}

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
