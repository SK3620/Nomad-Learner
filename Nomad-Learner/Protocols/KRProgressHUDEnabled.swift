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
