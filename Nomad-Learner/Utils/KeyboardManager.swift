//
//  KeyboardManager.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/29.
//

import UIKit
import Foundation

class KeyboardManager {
    private var viewController: UIViewController
    // レイアウト調整の基準にしたいTextField（オプション）
    private var targetBaseTextField: UITextField?
    private var originalY: CGFloat = 0
    
    init(viewController: UIViewController, textField: UITextField? = nil) {
        self.viewController = viewController
        self.targetBaseTextField = textField
        originalY = viewController.view.frame.origin.y
        registerForKeyboardNotifications()
    }
    
    // 登録解除
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // キーボード表示・非表示の通知を登録
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // キーボードが表示されるときに呼び出される
    @objc private func keyboardWillShow(notification: Notification) {
        // UIViewのサブビューを検索し、最初に見つかったfirstResponder（現在入力を受け付けているビュー → TextField）を返す
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // 現在のfirstResponder（TextField）を取得する。targetBaseTextFieldが設定されている場合はそれを優先
        let activeTextField = targetBaseTextField ?? self.findFirstResponder(in: viewController.view) as? UITextField
        guard let textField = activeTextField else {
            return
        }
        
        // UITextFieldの位置をviewControllerの座標系に変換
        let textFieldFrameInView = textField.convert(textField.bounds, to: viewController.view)
        
        let keyboardTopY = viewController.view.frame.height - keyboardFrame.height
        
        // TextFieldがキーボードに隠れる場合は画面を持ち上げる
        if textFieldFrameInView.maxY > keyboardTopY {
            let adjustmentHeight = textFieldFrameInView.maxY - keyboardTopY + UIConstants.Layout.standardPadding
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.viewController.view.frame.origin.y = self.originalY - adjustmentHeight
            })
        }
    }
    
    // フォーカスされているビューを探して返す
    private func findFirstResponder(in view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            } else if let firstResponder = self.findFirstResponder(in: subView) {
                return firstResponder
            }
        }
        return nil
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.viewController.view.frame.origin.y = self.originalY
        })
    }
}
