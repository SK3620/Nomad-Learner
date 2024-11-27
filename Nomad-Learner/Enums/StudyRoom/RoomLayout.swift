//
//  RoomLayout.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation

extension StudyRoomViewModel {
    // 画面レイアウト切り替え
    enum RoomLayout {
        case displayAll // 全て表示
        case hideProfile // プロフィール欄非表示
        case hideChat // チャット欄非表示
        case hideAll // 全て非表示
    }
}
