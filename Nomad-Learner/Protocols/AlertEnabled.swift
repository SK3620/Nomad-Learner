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
            let alertController = UIAlertController(
                title: alertAction.title,
                message: alertAction.message,
                preferredStyle: .alert
            )
            
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
    case error(MyAppError)
    case willDeleteAccount(onConfirm: (String?, String?) -> Void, user: FirebaseAuth.User?, onCancel: () -> Void = {})
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
        return .cancel
    }
    
    var title: String {
        switch self {
        case .error:
            return "Error"
        case .willDeleteAccount:
            return "Delete an Account"
        case .exitRoom:
            return "Exit Room"
        case .breakTime:
            return "Take a Break"
        case .community:
            return "Join Community"
        }
    }
    
    var message: String {
        switch self {
        case .error(let error):
            return error.errorDescription ?? ""
        case .willDeleteAccount(_, let user, _):
            return user.loginStatusMessage
        case .exitRoom:
            return "Do you really want to exit the room?"
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
            return "Delete"
        case .exitRoom:
            return "Exit"
        case .breakTime:
            return "Break"
        case .community:
            return "Join"
        }
    }
    
    var onCancelTitle: String {
       return "Cancel"
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
            return "email"
        default:
            return nil
        }
    }
    
    var secondTextField: String? {
        switch self {
        case .willDeleteAccount:
            return "password"
        default:
            return nil
        }
    }
    
    // Confirm と Cancel のハンドラー
        var handlers: (onConfirm: (String?, String?) -> Void, onCancel: () -> Void) {
            switch self {
            case .willDeleteAccount(let onConfirm, _, let onCancel):
                return (onConfirm: onConfirm, onCancel: onCancel)
            case .exitRoom(let onConfirm, let onCancel),
                 .breakTime(let onConfirm, let onCancel),
                 .community(let onConfirm, let onCancel):
                return (onConfirm: { _, _ in onConfirm() }, onCancel: onCancel)
            case .error:
                return (onConfirm: { _, _ in }, onCancel: {})
            }
        }
}

extension FirebaseAuth.User? {
    var loginStatusMessage: String {
        if let self = self {
            return "Are you sure you want to delete your account? \n\nusername: \(self.displayName ?? "")\nemail: \(self.email ?? "")"
        } else {
            return "No logged-in user found."
        }
    }
}
