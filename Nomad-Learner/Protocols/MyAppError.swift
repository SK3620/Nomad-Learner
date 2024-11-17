//
//  MyAppError.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

enum MyAppError: Error {
    case signInFailed(Error)
    case signUpFailed(Error)
    case reauthenticateFailed
    case deleteAccountFailed(Error?)
    
    case saveDataFailed(Error?)
    case saveUserProfileImageFailed(Error?)
    case saveUserProfileFailed(Error?)
    
    case fetchDataFailed(Error?)
    case fetchLocationInfoFailed(Error?)
    case fetchUserProfileFailed(Error?)
    
    case handleAll(Error?)
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
               return NSLocalizedString("サインインに失敗しました。もう一度お試しください。", comment: "サインイン失敗メッセージ")
           case .signUpFailed:
               return NSLocalizedString("サインアップに失敗しました。もう一度お試しください。", comment: "サインアップ失敗メッセージ")
           case .reauthenticateFailed:
               return NSLocalizedString("アカウントの再認証に失敗しました。もう一度お試しください。", comment: "再認証失敗メッセージ")
           case .deleteAccountFailed:
               return NSLocalizedString("アカウントの削除に失敗しました。もう一度お試しください。", comment: "アカウント削除失敗メッセージ")
           case .saveUserProfileFailed:
               return NSLocalizedString("ユーザープロフィールの保存に失敗しました。もう一度お試しください。", comment: "プロフィール保存失敗メッセージ")
           case .fetchUserProfileFailed:
               return NSLocalizedString("ユーザープロフィールの取得に失敗しました。もう一度お試しください。", comment: "プロフィール取得失敗メッセージ")
           case .handleAll:
               return NSLocalizedString("エラーが発生しました。もう一度お試しください。", comment: "一般的なエラーメッセージ")
           case .unknown:
               return NSLocalizedString("不明なエラーが発生しました。再試行してください。", comment: "不明なエラーメッセージ")
           case .testError(let text):
               return NSLocalizedString("テストエラー: \(text)", comment: "テストエラーメッセージ")
           case .saveDataFailed:
               return NSLocalizedString("データの保存に失敗しました。もう一度お試しください。", comment: "データ保存失敗メッセージ")
           case .saveUserProfileImageFailed:
               return NSLocalizedString("ユーザープロフィール画像の保存に失敗しました。もう一度お試しください。", comment: "プロフィール画像保存失敗メッセージ")
           case .fetchDataFailed:
               return NSLocalizedString("データの取得に失敗しました。もう一度お試しください。", comment: "データ取得失敗メッセージ")
           case .fetchLocationInfoFailed:
               return NSLocalizedString("ロケーション情報の取得に失敗しました。もう一度お試しください。", comment: "位置情報取得失敗メッセージ")
           }
       }
       
       // MARK: - Debug Descriptions (デバッグ用)
       var debugDescription: String {
           switch self {
           case .signInFailed(let error):
               return NSLocalizedString("サインインに失敗しました。エラー: \(error)。入力したメールアドレスとパスワードを確認してください。", comment: "サインインエラーメッセージ")
           case .signUpFailed(let error):
               return NSLocalizedString("サインアップに失敗しました。エラー: \(error)。メールの形式やその他の入力内容を確認してください。", comment: "サインアップエラーメッセージ")
           case .reauthenticateFailed:
               return NSLocalizedString("アカウントの削除に失敗しました。（再認証失敗）", comment: "再認証エラーメッセージ")
           case .deleteAccountFailed(let error):
               return NSLocalizedString("アカウントの削除に失敗しました。エラー: \(String(describing: error))", comment: "アカウント削除エラーメッセージ")
           case .saveUserProfileFailed(let error):
               return NSLocalizedString("ユーザープロフィールの保存に失敗しました。エラー: \(String(describing: error))。", comment: "プロフィール保存エラーメッセージ")
           case .fetchUserProfileFailed(let error):
               return NSLocalizedString("ユーザープロフィールの取得に失敗しました。エラー: \(String(describing: error))。", comment: "プロフィール取得エラーメッセージ")
           case .handleAll(let error):
               return NSLocalizedString("エラーが発生しました。もう一度お試しください。エラー: \(String(describing: error))。", comment: "一般的なエラーメッセージ")
           case .unknown:
               return NSLocalizedString("不明なエラーが発生しました。詳細な調査が必要です。", comment: "不明なエラーメッセージ")
           case .testError(let text):
               return NSLocalizedString("テストエラー: \(text)", comment: "テストエラーメッセージ")
           case .saveDataFailed(let error):
               return NSLocalizedString("データの保存に失敗しました。エラー: \(String(describing: error))。", comment: "データ保存エラーメッセージ")
           case .saveUserProfileImageFailed(let error):
               return NSLocalizedString("ユーザープロフィール画像の保存に失敗しました。エラー: \(String(describing: error))。", comment: "プロフィール画像保存エラーメッセージ")
           case .fetchDataFailed(let error):
               return NSLocalizedString("データの取得に失敗しました。エラー: \(String(describing: error))。", comment: "データ取得エラーメッセージ")
           case .fetchLocationInfoFailed(let error):
               return NSLocalizedString("ロケーション情報の取得に失敗しました。エラー: \(String(describing: error))。", comment: "ロケーション情報取得エラーメッセージ")
           }
       }
}
