//
//  MyAppError.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

enum MyAppError: Error {
    
    // 共通
    case userNotFound
    case handleAll(Error?)
    case unknown
    
    // 利用規約同意画面
    case loadTermsAndConditionsFailed(Error?)
    
    // 認証画面
    case signInFailed(Error)
    case signUpFailed(Error)
    case reauthenticateFailed
    case deleteAccountFailed(Error?)
    
    // マップ画面
    case saveUserProfileImageFailed(Error?)
    case saveUserProfileFailed(Error?)
    case fetchLocationInfoFailed(Error?)
    case fetchUserProfileFailed(Error?)
    case savePendingUpdateDataRetryFailed(Error)
    
    // フライト中画面
    case updateCurrentCoinAndLocationIdFailed(Error?)
    case incrementUserCountFailed(Error?)
    case addUserIdToLocationFailed(Error?)
    
    // フライト中画面＆勉強部屋画面
    case fetchUserIdsInLocationFailed(Error?)
    case fetchUserProfilesFailed(Error?)
    
    // 勉強部屋画面退出時
    case removeUserIdFromLocationFailed(Error?)
    case decrementUserCountFailed(Error?)
    case saveStudyProgressAndRewardsFailed(Error?)
    case updateCurrentCoinFailed(Error?)
    
    // テスト用
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
           case .loadTermsAndConditionsFailed:
               return NSLocalizedString("ページの読み込みに失敗しました。インターネット接続を確認してください。", comment: "利用規約読み込み失敗メッセージ")
           case .signInFailed:
               return NSLocalizedString("サインインに失敗しました。もう一度お試しください。", comment: "サインイン失敗メッセージ")
           case .signUpFailed:
               return NSLocalizedString("サインアップに失敗しました。もう一度お試しください。", comment: "サインアップ失敗メッセージ")
           case .reauthenticateFailed:
               return NSLocalizedString("アカウントの再認証に失敗しました。もう一度お試しください。", comment: "再認証失敗メッセージ")
           case .deleteAccountFailed:
               return NSLocalizedString("アカウントの削除に失敗しました。もう一度お試しください。", comment: "アカウント削除失敗メッセージ")
           case .savePendingUpdateDataRetryFailed:
               return NSLocalizedString("前回の勉強記録の保存に失敗しました。", comment: "勉強記録保存失敗のメッセージ")
           case .testError(let text):
               return NSLocalizedString("テストエラー: \(text)", comment: "テストエラーメッセージ")
           case .unknown:
               return NSLocalizedString("不明なエラーが発生しました。もう一度お試しください。", comment: "不明なエラーメッセージ")
           default:
               return NSLocalizedString("データの保存/取得に失敗しました。もう一度お試しください。", comment: "不明なエラーメッセージ")
           }
       }
       
    // MARK: - Debug Descriptions (デバッグ用)
    var debugDescription: String {
        switch self {
        case .loadTermsAndConditionsFailed(let error):
            return NSLocalizedString("ページの読み込みに失敗しました。インターネット接続を確認してください。エラー: \(String(describing: error)).", comment: "利用規約読み込み失敗メッセージ")
        case .signInFailed(let error):
            return NSLocalizedString("サインインに失敗しました。エラー: \(error.localizedDescription)。入力したメールアドレスとパスワードを確認してください。", comment: "サインインエラーメッセージ")
            
        case .signUpFailed(let error):
            return NSLocalizedString("サインアップに失敗しました。エラー: \(error.localizedDescription)。メールの形式やその他の入力内容を確認してください。", comment: "サインアップエラーメッセージ")
            
        case .reauthenticateFailed:
            return NSLocalizedString("アカウントの削除に失敗しました。（再認証失敗）", comment: "再認証エラーメッセージ")
            
        case .deleteAccountFailed(let error):
            return NSLocalizedString("アカウントの削除に失敗しました。エラー: \(String(describing: error)).", comment: "アカウント削除エラーメッセージ")
            
        case .saveUserProfileFailed(let error):
            return NSLocalizedString("ユーザープロフィールの保存に失敗しました。エラー: \(String(describing: error)).", comment: "プロフィール保存エラーメッセージ")
            
        case .fetchUserProfileFailed(let error):
            return NSLocalizedString("ユーザープロフィールの取得に失敗しました。エラー: \(String(describing: error)).", comment: "プロフィール取得エラーメッセージ")
            
        case .saveUserProfileImageFailed(let error):
            return NSLocalizedString("ユーザープロフィール画像の保存に失敗しました。エラー: \(String(describing: error)).", comment: "プロフィール画像保存エラーメッセージ")
            
        case .fetchLocationInfoFailed(let error):
            return NSLocalizedString("ロケーション情報の取得に失敗しました。エラー: \(String(describing: error)).", comment: "ロケーション情報取得エラーメッセージ")
            
        case .savePendingUpdateDataRetryFailed(let error):
            return NSLocalizedString("前回の勉強記録の保存に失敗しました。エラー: \(String(describing: error)).", comment: "勉強記録保存失敗のメッセージ")
            
        case .userNotFound:
            return NSLocalizedString("指定されたユーザーが見つかりませんでした。ユーザーIDを確認してください。", comment: "ユーザー未発見エラーメッセージ")
            
        case .updateCurrentCoinAndLocationIdFailed(let error):
            return NSLocalizedString("現在のコインおよびロケーションIDの更新に失敗しました。エラー: \(String(describing: error)).", comment: "コインとロケーションID更新エラーメッセージ")
            
        case .incrementUserCountFailed(let error):
            return NSLocalizedString("ユーザー数のインクリメントに失敗しました。エラー: \(String(describing: error)).", comment: "ユーザー数インクリメントエラーメッセージ")
            
        case .addUserIdToLocationFailed(let error):
            return NSLocalizedString("ユーザーIDのロケーションへの追加に失敗しました。エラー: \(String(describing: error)).", comment: "ユーザーID追加失敗エラーメッセージ")
            
        case .fetchUserIdsInLocationFailed(let error):
            return NSLocalizedString("ロケーション内のユーザーIDの取得に失敗しました。エラー: \(String(describing: error)).", comment: "ユーザーID取得失敗エラーメッセージ")
            
        case .fetchUserProfilesFailed(let error):
            return NSLocalizedString("ユーザープロフィールの取得に失敗しました。エラー: \(String(describing: error)).", comment: "ユーザープロフィール取得失敗エラーメッセージ")
            
        case .removeUserIdFromLocationFailed(let error):
            return NSLocalizedString("ロケーションからユーザーIDの削除に失敗しました。エラー: \(String(describing: error)).", comment: "ユーザーID削除失敗エラーメッセージ")
            
        case .decrementUserCountFailed(let error):
            return NSLocalizedString("ユーザー数のデクリメントに失敗しました。エラー: \(String(describing: error)).", comment: "ユーザー数デクリメント失敗エラーメッセージ")
            
        case .saveStudyProgressAndRewardsFailed(let error):
            return NSLocalizedString("学習進捗および報酬の保存に失敗しました。エラー: \(String(describing: error)).", comment: "学習進捗と報酬保存失敗エラーメッセージ")
            
        case .updateCurrentCoinFailed(let error):
            return NSLocalizedString("現在のコインの更新に失敗しました。エラー: \(String(describing: error)).", comment: "コイン更新失敗エラーメッセージ")
            
        case .handleAll(let error):
            return NSLocalizedString("エラーが発生しました。もう一度お試しください。エラー: \(String(describing: error)).", comment: "一般的なエラーメッセージ")
            
        case .unknown:
            return NSLocalizedString("不明なエラーが発生しました。詳細な調査が必要です。", comment: "不明なエラーメッセージ")
            
        case .testError(let text):
            return NSLocalizedString("テストエラー: \(text)", comment: "テストエラーメッセージ")
        }
    }
}
