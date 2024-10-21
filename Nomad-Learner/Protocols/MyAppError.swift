//
//  MyAppError.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

enum MyError: Error {
    case unknown
}


enum MyAppError: Error {
    case signInFailed(Error)
    case signUpFailed(Error)
    case userNotFound(Error?)
    case deleteAccountFailed(Error)
    case unknown
    
    // MARK: - LocalizedError Implementation
    public var errorDescription: String? {
#if DEVELOP // 開発
        return debugDescription
#else // 本番
        return description
#endif
    }
    
    // MARK: - Localized Descriptions
    var description: String {
        switch self {
        case .signInFailed:
            return NSLocalizedString("Unable to sign in.", comment: "Failed to sign in")
        case .signUpFailed:
            return NSLocalizedString("Unable to sign up.", comment: "Failed to sign up")
        case .userNotFound:
            return NSLocalizedString("Unable to find user.", comment: "User does not exist")
        case.deleteAccountFailed:
            return NSLocalizedString("Unable to delete an account.", comment: "User does not exist")
        case .unknown:
            return NSLocalizedString("An unknown error occurred. Please try again.", comment: "Unknown error")
        }
    }
    
    // MARK: - Debug Descriptions
    var debugDescription: String {
        switch self {
        case .signInFailed(let error):
            return "Sign-in failed due to error: \(error.localizedDescription). Check the email and password provided."
        case .signUpFailed(let error):
            return "Sign-up failed due to error: \(error.localizedDescription). Please ensure the email format is correct and try again."
        case .userNotFound(let error):
            return "User not found. Error: \((error?.localizedDescription) ?? ""). Ensure the email is registered or sign up for a new account."
        case .deleteAccountFailed(let error):
            return "Account deletion failed due to error: \(error.localizedDescription). Ensure the credentials are correct and try again."
        case .unknown:
            return "An unknown error occurred. Please investigate further."
        }
    }
}
