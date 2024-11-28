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
            KRProgressHUD.showImage(UIImage(named: "Reward")!, message: message)
        case .inDevelopment, .inDevelopment2:
            KRProgressHUD.showInfo(withMessage: message)
        case .none:
            break
        }
    }
}

extension ProgressHUDMessage {
    private func configureMessage(info: RewardCoinProgressHUDInfo) -> String {
        let bonusCoinMessage = """
            ＋\(info.bonusCoin)（50×\(info.studyHoursForBonus)時間)
        """
        
        let rewardCoinMessage: String
        // "1"（初達成）の場合のみrewardCoinを表示
        if info.completionFlag == 1 {
            rewardCoinMessage = """
                ＋\(info.rewardCoin)
            """
        } else {
            rewardCoinMessage = ""
        }
        
        let balanceChangeMessage = """
            所持金: \(info.originalCoin) → \(info.currentCoin)
        """
        
        return "\(rewardCoinMessage)\(bonusCoinMessage)\n\(balanceChangeMessage)"
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