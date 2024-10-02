//
//  AuthInputValidator.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/01.
//

import Foundation
import RxSwift

// MARK: - String Extension for Validation
extension String {
    
    func validateUsername() -> AuthInputValidation {
        return AuthInputValidator.validateUsername(self)
    }
    
    func validateEmail() -> AuthInputValidation {
        return AuthInputValidator.validateEmail(self)
    }
    
    func validatePassword() -> AuthInputValidation {
        return AuthInputValidator.validatePassword(self)
    }
}

// MARK: - Validation Error Messages
struct AuthInputValidationMessages {
    static let missingUsername = "Please enter a username."
    static let usernameTooLong = "Username is too long"
    static let missingEmail = "Please enter an email address."
    static let invalidEmail = "The email format is incorrect."
    static let emailAlreadyUsed = "This email is already in use."
    static let missingPassword = "Please enter a password."
    static let containsSpace = "Any spaces cannot be contained."
    static let invalidPassword = "Please include 8 to 16 characters with letters and numbers."
}

// MARK: - Auth Input Validator
class AuthInputValidator {
    
    // MARK: - Constants
    private struct Constants {
        static let maxUsernameCharCount = 16
        static let minPasswordCharCount = 8
        static let maxPasswordCharCount = 16
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let passwordRegex = "^(?=.*?[A-Za-z])(?=.*?[0-9])[A-Za-z0-9]{8,}$"
    }
        
    private static let errorMsgs = AuthInputValidationMessages.self
    
    // ユーザー名バリデーション
    static func validateUsername(_ username: String) -> AuthInputValidation {
        // 未入力チェック
        if username.isEmpty {
            return .empty(message: errorMsgs.missingUsername)
        }
        // 最大文字数制限
        if username.count > Constants.maxUsernameCharCount {
            return .failed(message: errorMsgs.usernameTooLong)
        }
        
        return .ok(message: "")
    }
    
    // メールアドレスバリデーション
    static func validateEmail(_ email: String) -> AuthInputValidation {
        // 未入力チェック
        if email.isEmpty {
            return .empty(message: errorMsgs.missingEmail)
        }
        // メールアドレス形式チェック
        let emailPred = NSPredicate(format: "SELF MATCHES %@", Constants.emailRegex)
        let isValid = emailPred.evaluate(with: email)
        
        return isValid ? .ok(message: "") : .failed(message: errorMsgs.invalidEmail)
    }
    
    // パスワードバリデーション
    static func validatePassword(_ password: String) -> AuthInputValidation {
        // 未入力チェック
        if password.isEmpty {
            return .empty(message: errorMsgs.missingPassword)
        }
        // 全角/半角スペース無効
        if password.contains(" ") || password.contains("　") {
            return .failed(message: errorMsgs.containsSpace)
        }
        
        let passwordCount = password.count
        // 最低文字数制限
        if passwordCount < Constants.minPasswordCharCount || passwordCount > Constants.maxPasswordCharCount {
            return .failed(message: errorMsgs.invalidPassword)
        }
        // 形式チェック
        let passwordRegex = "^(?=.*?[A-Za-z])(?=.*?[0-9])[A-Za-z0-9]{8,}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        
        return isValid ? .ok(message: "") : .failed(message: errorMsgs.invalidPassword)
    }
}
