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
            isShow ? KRProgressHUD.show(withMessage: "ローディング...") : KRProgressHUD.dismiss()
        }
    }
    
    // メッセージ表示制御
    var showMessage: Binder<ProgressHUDMessage> {
        return Binder(self.base) { _, message in
            message.show()
        }
    }
}
