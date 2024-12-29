//
//  aaaa.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation
import UIKit

enum AlertActionType {
    // エラー
    case error(MyAppError, onConfim: () -> Void = {})
    
    // アカウント削除
    case willDeleteAccount(onConfirm: (String?, String?) -> Void, onCancel: () -> Void = {})
    // お試し利用
    case willFreeTrialUse(onConfirm: () -> Void)
    
    // お試し利用中による制限機能へのアクセス不可
    case featureAccessDeniedInTrial(onConfirm: () -> Void = {})
        
    // 更新保留中の勉強記録データ
    case savePendingUpdateData(dataSaveError: MyAppError? = nil, onConfirm: () -> Void, onCancel: () -> Void)
    // 出発画面表示
    case willShowDepartVC(onConfirm: () -> Void, ticketInfo: TicketInfo)
    
    // お試し利用中の退出
    case exitRoomInTrial(onConfirm: () -> Void)
    // 退出
    case exitRoom(onConfirm: () -> Void)
    // 休憩
    case breakTime(onConfirm: () -> Void)
    // コミュニティ
    case community(onConfirm: () -> Void)
    
    // 報告
    case didCancelMail(onConfirm: () -> Void = {})
    case didSaveMail(onConfirm: () -> Void = {})
    case didSendMail(onConfirm: () -> Void = {})
    
    
    var comfirmActionStyle: UIAlertAction.Style {
        switch self {
        case .exitRoom,
                .exitRoomInTrial,
                .willDeleteAccount:
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
        case .error(let error, _):
            return error.alertTitle
        case .willDeleteAccount:
            return "アカウントを削除する"
        case .willFreeTrialUse:
            return "お試しで使ってみる"
        case .featureAccessDeniedInTrial:
            return "この機能は制限されています"
        case .savePendingUpdateData(let saveRetryError, _, _):
            return saveRetryError != nil ? "エラー" : ""
        case .willShowDepartVC:
            return "確認"
        case .exitRoom,
                .exitRoomInTrial:
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
        case .willFreeTrialUse:
            return "\nアプリの一部の機能をお試しで使用することができます。\n全ての機能を利用するためには、アカウントを作成する必要があります。"
        case .featureAccessDeniedInTrial:
            return "\nこの機能はお試し利用中はご利用できません。\n全ての機能を利用するためには、アカウントを作成する必要があります。"
        case .savePendingUpdateData(let dataSaveError, _, _):
            return "\(dataSaveError?.errorDescription ?? "前回の勉強記録が保存されていません。")\n保存しますか？"
        case .willShowDepartVC(_, let ticketInfo):
            return "\n一度訪問すると、次回の「\(ticketInfo.destination)」への訪問時以降、以下の項目は変更されません。\n\n必要な勉強時間：\(ticketInfo.requiredStudyHours)時間\n報酬コイン：\(ticketInfo.rewardCoin)コイン"
        case .exitRoomInTrial:
            return "\n本当に終了してもよろしいですか？\n\nお試し利用中のため、勉強記録や旅先への訪問実績などのデータは保存/反映されません。全ての機能を利用するためには、アカウントを作成する必要があります。"
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
        case .willFreeTrialUse:
            return "使ってみる"
        case .savePendingUpdateData:
            return "保存"
        case .exitRoom,
                .exitRoomInTrial:
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
                .featureAccessDeniedInTrial,
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
            
        case .willShowDepartVC(let onConfirm, _),
                .willFreeTrialUse(let onConfirm),
                .featureAccessDeniedInTrial(let onConfirm),
                .exitRoomInTrial(let onConfirm),
                .exitRoom(let onConfirm),
                .breakTime(let onConfirm),
                .community(let onConfirm),
                .didSendMail(let onConfirm),
                .didCancelMail(let onConfirm),
                .didSaveMail(let onConfirm):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: {})
            
        case .error(_, let onConfirm):
            return (onConfirm: { _, _ in onConfirm() }, onCancel: {})
        }
    }
}
