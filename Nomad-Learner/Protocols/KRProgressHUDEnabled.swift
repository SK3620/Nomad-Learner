//
//  KRProgressHUDEnabled.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/02.
//

import Foundation
import RxSwift
import RxCocoa
import KRProgressHUD
import UIKit

protocol KRProgressHUDEnabled: AnyObject {}

extension Reactive where Base: KRProgressHUDEnabled {
    // ローディング表示制御
    var showProgress: Binder<Bool> {
        return Binder(self.base) { _, isShow in
            KRProgressHUD.setDefaultStyle()
            isShow ? KRProgressHUD.show(withMessage: "Loading...") : KRProgressHUD.dismiss()
        }
    }
    
    // メッセージ表示制御
    var showMessage: Binder<ProgressHUDMessage> {
        return Binder(self.base) { _, message in
            guard message != .none else { return }
            message.show()
        }
    }
}

// ProgressHUDメッセージに関する列挙型
enum ProgressHUDMessage {
    case didDeleteAccount
    case insufficientCoin
    case inDevelopment
    case none
    
    var message: String {
        switch self {
        case .didDeleteAccount:
            return "アカウントを正常に削除しました。"
        case .insufficientCoin:
            return "所持金が足りません。"
        case .inDevelopment:
            return "現在開発中の機能です。\n乞うご期待を！"
        case .none:
            return ""
        }
    }
    
    // 適切なスタイルを返す
    var style: ProgressHUDStyle {
        switch self {
        case .inDevelopment:
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
            KRProgressHUD.showSuccess(withMessage: message)
        case .insufficientCoin:
            KRProgressHUD.showWarning(withMessage: message)
        case .inDevelopment:
            KRProgressHUD.showInfo(withMessage: message)
        case .none:
            break
        }
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
        KRProgressHUD.set(font: UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!)
        KRProgressHUD.set(duration: 2.5)
    }
}
