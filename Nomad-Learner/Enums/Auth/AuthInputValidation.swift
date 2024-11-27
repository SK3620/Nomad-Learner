//
//  AuthInputValidation.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/01.
//

import RxSwift
import RxCocoa
import UIKit

enum AuthInputValidation {
    case initialValidating
    case ok(message: String)
    case empty(message: String)
    case validating
    case failed(message: String)

    var description: String {
        switch self {
        case .initialValidating : return ""
        case let .ok(message) : return message
        case let .empty(message) : return message
        case .validating : return ""
        case let .failed(message) : return message
        }
    }

    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension Reactive<UILabel> where Base: UILabel {
    var validationResult: Binder<AuthInputValidation> {
        return Binder.init(self.base, binding: { label, result in
            label.text = result.description
        })
    }
}
