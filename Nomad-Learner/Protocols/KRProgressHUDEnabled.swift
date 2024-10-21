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
    var showProgress: Binder<Bool> {
        return Binder.init(self.base, binding: { progress, isShow in
            if isShow {
                KRProgressHUD.show(withMessage: "Loading...")
            } else {
                KRProgressHUD.dismiss()
            }
        })
    }
}

extension Reactive where Base: KRProgressHUDEnabled {
    var showMessage: Binder<ProgressHUDMessage> {
        return Binder.init(self.base) { progress, value in
            guard value != .none else { return }
            // showProgressのdismiss()より後に実行
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                KRProgressHUD.showSuccess(withMessage: value.message)
            }
        }
    }
}

enum ProgressHUDMessage {
    case didDeleteAccount
    case none
    
    var message: String {
        switch self {
        case .didDeleteAccount:
            return "Account deleted successfully."
        case .none:
            return ""
        }
    }
}
