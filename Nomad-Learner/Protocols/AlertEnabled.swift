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
