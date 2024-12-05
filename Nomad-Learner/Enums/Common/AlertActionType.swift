//
//  aaaa.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation
import UIKit

enum AlertActionType {
    case error(MyAppError, onConfim: () -> Void = {})
    case willDeleteAccount(onConfirm: (String?, String?) -> Void, onCancel: () -> Void = {})
    case savePendingUpdateData(saveRetryError: MyAppError? = nil, onConfirm: () -> Void, onCancel: () -> Void)
    case willShowDepartVC(onConfirm: () -> Void, onCancel: () -> Void = {}, ticketInfo: TicketInfo)
    case exitRoom(onConfirm: () -> Void, onCancel: () -> Void = {})
    case breakTime(onConfirm: () -> Void, onCancel: () -> Void = {})
    case community(onConfirm: () -> Void, onCancel: () -> Void = {})
    
    case didCancelMail(onConfirm: () -> Void = {})
    case didSaveMail(onConfirm: () -> Void = {})
    case didSendMail(onConfirm: () -> Void = {})
    
    
    var comfirmActionStyle: UIAlertAction.Style {
        switch self {
        case .exitRoom, .willDeleteAccount:
            return .destructive
        default:
            return .default
        }
    }
    
    var cancelActionStyle: UIAlertAction.Style {
        switch self {
        default:
            return .cancel
        }
    }
    
    var title: String {
        switch self {
        case .error:
            return "エラー"
        case .willDeleteAccount:
            return "アカウントを削除する"
        case .savePendingUpdateData(let saveRetryError, _, _):
            return saveRetryError != nil ? "エラー" : ""
        case .willShowDepartVC:
            return "確認"
        case .exitRoom:
            return "終了する"
        case .breakTime:
            return "休憩する"
        case .community:
            return "コミュニティ"
        case .didSaveMail:
            return "メールを保存しました"
        case .didCancelMail:
            return "メールの送信をキャンセルしました"
        case .didSendMail:
            return "メールを送信しました"
        }
    }
    
    var message: String {
        switch self {
        case .error(let error, _):
            return "\n" + (error.errorDescription ?? "")
        case .willDeleteAccount:
            return "\n本当にアカウントを削除してもよろしいですか？"
        case .savePendingUpdateData(let saveRetryError, _, _):
            return "\(saveRetryError?.errorDescription ?? "前回の勉強記録が保存されていません。")\n保存しますか？"
        case .willShowDepartVC(_, _, let ticketInfo):
            return "\n一度訪問すると、次回の「\(ticketInfo.destination)」への訪問時以降、以下の項目は変更されません。\n\n必要な勉強時間：\(ticketInfo.requiredStudyHours)時間\n報酬コイン：\(ticketInfo.rewardCoin)コイン"
        case .exitRoom:
            return "\n本当に終了してもよろしいですか？\n（終了後、勉強時間が記録されます。）"
        case .breakTime:
            return "\nIt's time to take a break."
        case .community:
            return "\nJoin the community and connect with others!"
        default:
            return ""
        }
    }
    
    var onComfirmTitle: String {
        switch self {
        case .willDeleteAccount:
            return "削除"
        case .savePendingUpdateData:
            return "保存"
        case .exitRoom:
            return "終了"
        case .breakTime:
            return "休憩"
        case .community:
            return "Join"
        default:
            return "OK"
        }
    }
    
    var onCancelTitle: String {
        switch self {
        case .savePendingUpdateData:
            return "破棄"
        default:
            return "キャンセル"
        }
    }
    
    // キャンセルアクションの表示/非表示
    var shouldShowCancelAction: Bool {
        switch self {
        case .error,
                .didSaveMail,
                .didSendMail,
                .didCancelMail:
            return false
        default:
            return true
        }
    }
    
    var shouldAddTextField: Bool {
        switch self {
        case .willDeleteAccount:
            return true
        default:
            return false
        }
    }
    
    var firstTextField: String? {
        switch self {
        case .willDeleteAccount:
            return "メールアドレス"
        default:
            return nil
        }
    }
    
    var secondTextField: String? {
        switch self {
        case .willDeleteAccount:
            return "パスワード"
        default:
            return nil
        }
    }
    
    // Confirm と Cancel のハンドラー
    var handlers: (onConfirm: (String?, String?) -> Void, onCancel: () -> Void) {
        switch self {
        case .willDeleteAccount(let onConfirm, let onCancel):
            return (onConfirm: onConfirm, onCancel: onCancel)
            
        case .savePendingUpdateData(_, let onConfirm, let onCancel):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: { onCancel() })
            
        case .willShowDepartVC(let onConfirm, _, _),
                .exitRoom(let onConfirm, _),
                .breakTime(let onConfirm, _),
                .community(let onConfirm, _),
                .didSendMail(let onConfirm),
                .didCancelMail(let onConfirm),
                .didSaveMail(let onConfirm):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: {})
            
        case .error(_, let onConfirm):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: {})
        }
    }
}
