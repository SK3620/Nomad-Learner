//
//  MyAppError.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

/*
enum MyAppError: Error {
    case signInFailed(Error)
    case signUpFailed(Error)
    case userNotFound(Error?)
    
    // MARK: - Delete Account Error
    case deleteAccount(DeleteAccount)
    enum DeleteAccount: Error {
        case fieldEmpty // 入力欄が空
        case reSingInRequired // 再ログインが必要
        case deleteAccountFailed(Error?) // アカウント削除失敗
    }
    
    case locationEmpty
    case saveUserProfileFailed(Error)
    case fetchUserProfileFailed(Error?)
    case fetchVisitedLocationsFailed(Error?)
    case allError(Error?)
    case unknown
    
    // MARK: - LocalizedError Implementation
    public var errorDescription: String? {
#if DEVELOP // 開発
        return debugDescription
#else // 本番
        return description
#endif
    }
    
    var debugDescription: String {
       return "エラーだよん。"
    }
    
    var description: String {
       return "エラーだよん。"
    }
}
*/




enum MyAppError: Error {
    case signInFailed(Error)
    case signUpFailed(Error)
    case reauthenticateFailed
    case userNotFound(Error?)
    
    // MARK: - Delete Account Error
    case deleteAccount(DeleteAccount)
    enum DeleteAccount: Error {
        case fieldEmpty // 入力欄が空
        case reSignInRequired // 再ログインが必要
        case deleteAccountFailed(Error?) // アカウント削除失敗
    }
    
    case locationEmpty
    case saveUserProfileFailed(Error)
    case fetchUserProfileFailed(Error?)
    case fetchVisitedLocationsFailed(Error?)
    case allError(Error?)
    case unknown
    
    case testError(String)
    // MARK: - LocalizedError Implementation
    public var errorDescription: String? {
#if DEVELOP // 開発
        return debugDescription
#else // 本番
        return description
#endif
    }
    
    // MARK: - Localized Descriptions (日本語版)
    var description: String {
        switch self {
        case .signInFailed:
            return NSLocalizedString("サインインに失敗しました。もう一度お試しください。", comment: "Failed to sign in")
        case .signUpFailed:
            return NSLocalizedString("サインアップに失敗しました。もう一度お試しください。", comment: "Failed to sign up")
        case .reauthenticateFailed:
            return NSLocalizedString("アカウント削除の再認証に失敗しました。", comment: "Failed to sign up")
        case .userNotFound:
            return NSLocalizedString("ユーザーが見つかりません。", comment: "User does not exist")
        case .deleteAccount(let error):
            switch error {
            case .fieldEmpty:
                return NSLocalizedString("入力欄が空です。全てのフィールドに入力してください。", comment: "Field empty")
            case .reSignInRequired:
                return NSLocalizedString("再ログインが必要です。もう一度ログインしてください。", comment: "Re-sign in required")
            case .deleteAccountFailed:
                return NSLocalizedString("アカウントの削除に失敗しました。もう一度お試しください。", comment: "Account deletion failed")
            }
        case .locationEmpty:
            return NSLocalizedString("位置情報が取得できませんでした。", comment: "Location data missing")
        case .saveUserProfileFailed:
            return NSLocalizedString("ユーザープロフィールの保存に失敗しました。", comment: "Failed to save user profile")
        case .fetchUserProfileFailed:
            return NSLocalizedString("ユーザープロフィールの取得に失敗しました。", comment: "Failed to retrieve user profile")
        case .fetchVisitedLocationsFailed:
            return NSLocalizedString("訪問した場所のデータを取得できませんでした。", comment: "Failed to retrieve visited locations")
        case .allError:
            return NSLocalizedString("予期しないエラーが発生しました。", comment: "An unexpected error occurred")
        case .unknown:
            return NSLocalizedString("不明なエラーが発生しました。再試行してください。", comment: "Unknown error")
        case .testError(let text):
            return NSLocalizedString("テストエラー Error: \(text)", comment: "Unknown error")
        }
    }
    
    // MARK: - Debug Descriptions (デバッグ用)
    var debugDescription: String {
        switch self {
        case .signInFailed(let error):
            return "サインインに失敗しました。エラー内容: \(error)。入力されたメールアドレスとパスワードを確認してください。"
        case .signUpFailed(let error):
            return "サインアップに失敗しました。エラー内容: \(error)。メールフォーマットやその他の入力情報を確認してください。"
        case .reauthenticateFailed:
            return NSLocalizedString("アカウント削除の再認証に失敗しました。", comment: "Failed to sign up")
        case .userNotFound(let error):
            return "ユーザーが見つかりませんでした。エラー内容: \(String(describing: error))。メールアドレスが正しいか、または新規アカウントを作成してください。"
        case .deleteAccount(let error):
            switch error {
            case .fieldEmpty:
                return "アカウント削除に失敗しました。入力欄が空です。"
            case .reSignInRequired:
                return "アカウント削除に失敗しました。再ログインが必要です。"
            case .deleteAccountFailed(let error):
                return "アカウント削除に失敗しました。エラー内容: \(String(describing: error))。"
            }
        case .locationEmpty:
            return "位置情報が取得できませんでした。データが存在しません。"
        case .saveUserProfileFailed(let error):
            return "ユーザープロフィールの保存に失敗しました。エラー内容: \(error)。"
        case .fetchUserProfileFailed(let error):
            return "ユーザープロフィールの取得に失敗しました。エラー内容: \(String(describing: error))。"
        case .fetchVisitedLocationsFailed(let error):
            return "訪問した場所のデータ取得に失敗しました。エラー内容: \(String(describing: error))。"
        case .allError(let error):
            return "予期しないエラーが発生しました。エラー内容: \(String(describing: error))。"
        case .unknown:
            return "不明なエラーが発生しました。詳細な調査が必要です。"
        case .testError(let text):
            return NSLocalizedString("テストエラー Error: \(text)", comment: "Unknown error")
        }
    }
}
