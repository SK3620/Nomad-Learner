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

protocol AlertEnabled: UIViewController {}

extension Reactive where Base: AlertEnabled {
    var showAlert: Binder<AlertActionType> {
        return Binder(self.base, binding: { base, alertAction in
            let alertController = UIAlertController(
                title: alertAction.title,
                message: alertAction.message,
                preferredStyle: .alert
            )
            
            // Confirm アクション
            let confirmAction = UIAlertAction(
                title: alertAction.onComfirmTitle,
                style: alertAction.comfirmActionStyle,
                handler:  { _ in
                    alertAction.handlers.onConfirm()
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
    case error(Error)
    case exitRoom(onConfirm: () -> Void, onCancel: () -> Void = {})
    case breakTime(onConfirm: () -> Void, onCancel: () -> Void = {})
    case community(onConfirm: () -> Void, onCancel: () -> Void = {})
    
    var comfirmActionStyle: UIAlertAction.Style {
        switch self {
        case .exitRoom:
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
            return error.localizedDescription
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
    
    // Confirm と Cancel のハンドラー
    var handlers: (onConfirm: () -> Void, onCancel: () -> Void) {
        switch self {
        case .exitRoom(let onConfirm, let onCancel),
                .breakTime(let onConfirm, let onCancel),
                .community(let onConfirm, let onCancel):
            return (onConfirm: onConfirm, onCancel: onCancel)
            
        case .error:
            // エラーの場合は特にアクションが必要ないと仮定
            return (onConfirm: {}, onCancel: {})
        }
    }
}
