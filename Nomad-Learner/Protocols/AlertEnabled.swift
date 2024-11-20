//
//  ErrorAlertEnabled.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

protocol AlertEnabled: UIViewController {}

extension Reactive where Base: AlertEnabled {
    var showAlert: Binder<AlertActionType> {
        return Binder(self.base, binding: { base, alertAction in
            
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W6", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            let titleString = NSAttributedString(string: alertAction.title, attributes: titleAttributes)
            
            let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W3", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            let messageString = NSAttributedString(string: alertAction.message, attributes: messageAttributes)
            
            alertController.setValue(titleString, forKey: "attributedTitle")
            alertController.setValue(messageString, forKey: "attributedMessage")
            
            if alertAction.shouldAddTextField {
                // 一つ目のアラートに追加するかの判断
                if let firstPlaceHolder = alertAction.firstTextField {
                    alertController.addTextField { textField in
                        textField.placeholder = firstPlaceHolder
                    }
                }
                // 二つ目のアラートに追加するかの判断
                if let secondPlaceHolder = alertAction.secondTextField {
                    alertController.addTextField { textField in
                        textField.placeholder = secondPlaceHolder
                        textField.isSecureTextEntry = true
                    }
                }
            }
            
            // Confirm アクション
            let confirmAction = UIAlertAction(
                title: alertAction.onComfirmTitle,
                style: alertAction.comfirmActionStyle,
                handler:  { _ in
                    if alertAction.shouldAddTextField {
                        let firstValue = alertController.textFields?[0].text ?? ""
                        let secondValue = alertController.textFields?[1].text ?? ""
                        alertAction.handlers.onConfirm(firstValue, secondValue)
                    } else {
                        alertAction.handlers.onConfirm(nil, nil)
                    }
                })
            alertController.addAction(confirmAction)
            
            // Cancel アクション
            if alertAction.shouldShowCancelAction {
                let cancelAction = UIAlertAction(
                    title: alertAction.onCancelTitle,
                    style: alertAction.cancelActionStyle,
                    handler: { _ in
                        alertAction.handlers.onCancel()
                    })
                alertController.addAction(cancelAction)
            }
            
            base.present(alertController, animated: true)
        })
    }
}


enum AlertActionType {
    case error(MyAppError, onConfim: () -> Void = {})
    case willDeleteAccount(onConfirm: (String?, String?) -> Void, onCancel: () -> Void = {})
    case savePendingUpdateData(saveRetryError: MyAppError? = nil, onConfirm: () -> Void, onCancel: () -> Void)
    case willShowDepartVC(onConfirm: () -> Void, onCancel: () -> Void = {}, ticketInfo: TicketInfo)
    case exitRoom(onConfirm: () -> Void, onCancel: () -> Void = {})
    case breakTime(onConfirm: () -> Void, onCancel: () -> Void = {})
    case community(onConfirm: () -> Void, onCancel: () -> Void = {})
    
    var comfirmActionStyle: UIAlertAction.Style {
        switch self {
        case .exitRoom, .willDeleteAccount:
            return .destructive
        default:
            return .default
        }
    }
    
    var cancelActionStyle: UIAlertAction.Style {
        switch self {
        default:
            return .cancel
        }
    }
    
    var title: String {
        switch self {
        case .error:
            return "エラー"
        case .willDeleteAccount:
            return "アカウントを削除する"
        case .savePendingUpdateData(let saveRetryError, _, _):
            return saveRetryError != nil ? "エラー" : ""
        case .willShowDepartVC:
            return "確認"
        case .exitRoom:
            return "終了する"
        case .breakTime:
            return "休憩する"
        case .community:
            return "コミュニティ"
        }
    }
    
    var message: String {
        switch self {
        case .error(let error, _):
            return error.errorDescription ?? ""
        case .willDeleteAccount:
            return "本当にアカウントを削除してもよろしいですか？"
        case .savePendingUpdateData(let saveRetryError, _, _):
            return "\(saveRetryError?.errorDescription ?? "前回の勉強記録が保存されていません。")\n保存しますか？"
        case .willShowDepartVC(_, _, let ticketInfo):
            return "次回の「\(ticketInfo.destination)」への訪問時以降、以下の項目は変更されません。\n\n必要な勉強時間：\(ticketInfo.requiredStudyHours)時間\n報酬コイン：\(ticketInfo.rewardCoin)コイン"
        case .exitRoom:
            return "本当に終了してもよろしいですか？\n（終了後、勉強時間が記録されます。）"
        case .breakTime:
            return "It's time to take a break."
        case .community:
            return "Join the community and connect with others!"
        }
    }
    
    var onComfirmTitle: String {
        switch self {
        case .error:
            return "OK"
        case .willDeleteAccount:
            return "削除"
        case .savePendingUpdateData:
            return "保存"
        case .willShowDepartVC:
            return "OK"
        case .exitRoom:
            return "終了"
        case .breakTime:
            return "休憩"
        case .community:
            return "Join"
        }
    }
    
    var onCancelTitle: String {
        switch self {
        case .savePendingUpdateData:
            return "破棄"
        default:
            return "キャンセル"
        }
    }
    
    // キャンセルアクションの表示/非表示
    var shouldShowCancelAction: Bool {
        switch self {
        case .error:
            return false
        default:
            return true
        }
    }
    
    var shouldAddTextField: Bool {
        switch self {
        case .willDeleteAccount:
            return true
        default:
            return false
        }
    }
    
    var firstTextField: String? {
        switch self {
        case .willDeleteAccount:
            return "メールアドレス"
        default:
            return nil
        }
    }
    
    var secondTextField: String? {
        switch self {
        case .willDeleteAccount:
            return "パスワード"
        default:
            return nil
        }
    }
    
    // Confirm と Cancel のハンドラー
    var handlers: (onConfirm: (String?, String?) -> Void, onCancel: () -> Void) {
        switch self {
        case .willDeleteAccount(let onConfirm, let onCancel):
            return (onConfirm: onConfirm, onCancel: onCancel)
        case .savePendingUpdateData(_, let onConfirm, let onCancel):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: { onCancel() })
        case .willShowDepartVC(let onConfirm, _, _),
                .exitRoom(let onConfirm, _),
                .breakTime(let onConfirm, _),
                .community(let onConfirm, _):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: {})
        case .error(_, let onConfirm):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: {})
        }
    }
}
