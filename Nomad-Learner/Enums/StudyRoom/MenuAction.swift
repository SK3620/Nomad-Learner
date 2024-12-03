//
//  MenuAction.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation

extension StudyRoomViewModel {
    // UIメニューアクション
    enum MenuAction {
        case breakTime // 休憩
        case restart // 勉強再開
        case confirmTicket // チケット確認
        case changeBackgroundImageSwitchIntervalTime // 背景画像切り替えインターバル時間
        case community // コミュニティ
        case exitRoom // 退出
    }
}
