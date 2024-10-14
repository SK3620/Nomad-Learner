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
    // プロフィール
    private let profileRelay: BehaviorRelay<[Profile]> = BehaviorRelay<[Profile]>(value: [])
    // チャット欄のメッセージ
    private let messageRelay: BehaviorRelay<[Message]> = BehaviorRelay<[Message]>(value: [])
    // タップされたIndexPath
    private let tappedIndexRelay: BehaviorRelay<IndexPath> = BehaviorRelay<IndexPath>(value: IndexPath(row: 0, section: 0))
    
    // MARK: - Output 外部公開
    var profiles: Driver<[Profile]> {
        return profileRelay.asDriver()
    }
    var messages: Driver<[Message]> {
        return messageRelay.asDriver()
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
}
