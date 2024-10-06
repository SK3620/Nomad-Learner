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

protocol ErrorAlertEnabled: UIViewController {}

extension Reactive where Base: ErrorAlertEnabled {
    var showErrorAlert: Binder<Error?> {
        return Binder.init(self.base, binding: { target, value in
            if let error = value {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                target.present(alertController, animated: true, completion: nil)
            }
        })
    }
}
