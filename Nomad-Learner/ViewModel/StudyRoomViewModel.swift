//
//  StudyRoomViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import Foundation
import RxSwift
import RxCocoa

class StudyRoomViewModel {
    
    // 画面レイアウト切り替え
    enum RoomLayout {
        case displayAll // 全て表示
        case hideProfile // プロフィール欄非表示
        case hideChat // チャット欄非表示
        case hideAll // 全て非表示
    }
    
    // UIメニューアクション
    enum MenuAction {
        case breakTime // 休憩
        case community // コミュニティ
        case exitRoom // 退出
    }
    
    // プロフィール
    private let profileRelay = BehaviorRelay<[Profile]>(value: [])
    // チャット欄のメッセージ
    private let messageRelay = BehaviorRelay<[Message]>(value: [])
    // 画面レイアウト
    private let roomLayoutRelay = BehaviorRelay<RoomLayout>(value: .displayAll)
    // UIメニューアクション
    private let menuActionRelay = BehaviorRelay<MenuAction?>(value: .none)
    // 押下されたIndexPath
    private let tappedIndexRelay = BehaviorRelay<IndexPath>(value: IndexPath(row: 0, section: 0))
    
    // MARK: - Output 外部公開
    var profiles: Driver<[Profile]> {
        return profileRelay.asDriver()
    }
    var messages: Driver<[Message]> {
        return messageRelay.asDriver()
    }
    var roomLayout: Driver<RoomLayout> {
        return roomLayoutRelay.asDriver()
    }
    var menuAction: Driver<MenuAction?> {
        return menuActionRelay.asDriver()
    }
    var tappedIndex: Driver<IndexPath> {
        return tappedIndexRelay.asDriver()
    }
    
    init() {
        
        profileRelay.accept(Profile.profiles)
        messageRelay.accept(Message.messages)
    }
}

extension StudyRoomViewModel {
    
    // 押下されたcellのIndexPath情報を保持させる
    public func tappedProfile(at indexPath: IndexPath) {
        tappedIndexRelay.accept(indexPath)
    }
    
    // レイアウトの切り替え
    public func switchRoomLayout() {
        let layout = roomLayoutRelay.value
        switch layout {
        case .displayAll:
            roomLayoutRelay.accept(.hideProfile)
        case .hideProfile:
            roomLayoutRelay.accept(.hideChat)
        case .hideChat:
            roomLayoutRelay.accept(.hideAll)
        case .hideAll:
            roomLayoutRelay.accept(.displayAll)
        }
    }
    
    // メニューで選択されたアクション（休憩、退出、コミュニティ）を発行
    public func handleMenuAction(action: MenuAction) {
        switch action {
        case .breakTime:
            menuActionRelay.accept(.breakTime)
        case .community:
            menuActionRelay.accept(.community)
        case .exitRoom:
            menuActionRelay.accept(.exitRoom)
        }
    }
}
