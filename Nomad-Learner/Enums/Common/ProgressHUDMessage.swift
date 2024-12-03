//
//  KRProgressHUDEnabled.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation
import UIKit
import KRProgressHUD

// ProgressHUDメッセージに関する列挙型
enum ProgressHUDMessage {
    case didDeleteAccount
    case insufficientCoin
    case getRewardCoin(info: RewardCoinProgressHUDInfo)
    case didIntervalSelect(Int)
    case inDevelopment
    case inDevelopment2
    case none
    
    var message: String {
        switch self {
        case .didDeleteAccount:
            return "アカウントを正常に削除しました。"
        case .insufficientCoin:
            return "所持金が足りません。"
        case .getRewardCoin(let info):
            return configureMessage(info: info)
        case .didIntervalSelect(let interval):
            return "背景画像を\(interval)分ごとに切り替えます。"
        case .inDevelopment:
            return "現在開発中の機能です。\n乞うご期待を！"
        case .inDevelopment2:
            return "「 -- 」 は現在開発中の機能です。\nアップデートをお待ちください。"
        case .none:
            return ""
        }
    }
    
    // 適切なスタイルを返す
    var style: ProgressHUDStyle {
        switch self {
        case .inDevelopment, .inDevelopment2:
            return .info
        case .insufficientCoin:
            return .warning
        default:
            return .success
        }
    }
    
    // メッセージを表示
    func show() {
        style.apply()
        switch self {
        case .didDeleteAccount:
            // ローディング表示制御のdismiss()よりも後に実行させる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                KRProgressHUD.showSuccess(withMessage: message)
            }
        case .insufficientCoin:
            KRProgressHUD.showWarning(withMessage: message)
        case .getRewardCoin:
            // ローディング表示制御のdismiss()よりも後に実行させる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                KRProgressHUD.set(duration: 5.0)
                KRProgressHUD.showImage(UIImage(named: "Reward")!, message: message)
            }
        case .didIntervalSelect, .inDevelopment, .inDevelopment2:
            KRProgressHUD.showInfo(withMessage: message)
        case .none:
            break
        }
    }
}

extension ProgressHUDMessage {
    private func configureMessage(info: RewardCoinProgressHUDInfo) -> String {
        let bonusCoinMessage = "ボーナス\n＋\(info.bonusCoin)（\(MyAppSettings.bonusCoinMultiplier)×\(info.studyHoursForBonus)時間)"
        
        // "1"（初達成）の場合のみrewardCoinを表示
        let rewardCoinMessage = info.completionFlag == 1
        ? "報酬\n＋\(info.rewardCoin)"
        : "報酬\n＋\(info.rewardCoin)（獲得済み）"
        
        let balanceChangeMessage = "所持金: \(info.originalCoin) ▶︎ \(info.currentCoin)"
        
        return info.completionFlag == 1
        ? "\(rewardCoinMessage)\n\n\(bonusCoinMessage)\n\n\(balanceChangeMessage)"
        : "\(bonusCoinMessage)\n\n\(balanceChangeMessage)"
    }
}

// 状況別のカスタムスタイルを定義
enum ProgressHUDStyle {
    case success
    case info
    case warning
    
    // 共通のカスタムスタイルを適用する
    func apply() {
        KRProgressHUD.setDefaultStyle()
        switch self {
        case .success:
            KRProgressHUD.set(style: .custom(background: .white, text: ColorCodes.primaryPurple.color(), icon: ColorCodes.primaryPurple.color()))
        case .info:
            KRProgressHUD.set(style: .custom(background: .white, text: ColorCodes.primaryPurple.color(), icon: ColorCodes.primaryPurple.color()))
        case .warning:
            KRProgressHUD.set(style: .custom(background: .white, text: ColorCodes.primaryPurple.color(), icon: ColorCodes.primaryPurple.color()))
        }
    }
}

// KRProgressHUDのデフォルトスタイル設定
extension KRProgressHUD {
    static func setDefaultStyle() {
        let basicColor = ColorCodes.primaryPurple.color()
        KRProgressHUD.set(activityIndicatorViewColors: [basicColor])
        KRProgressHUD.set(font: UIFont(name: "HiraginoSans-W6", size: 14)!)
        KRProgressHUD.set(duration: 2.5)
    }
}
