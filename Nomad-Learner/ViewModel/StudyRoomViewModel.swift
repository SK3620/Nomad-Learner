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
        
    private let profileRelay: BehaviorRelay<[Profile]> = BehaviorRelay<[Profile]>(value: [])
    private let messageRelay: BehaviorRelay<[Message]> = BehaviorRelay<[Message]>(value: [])
    
    // MARK: - Output 外部公開
    var profiles: Driver<[Profile]> {
        return profileRelay.asDriver()
    }
    var messages: Driver<[Message]> {
        return messageRelay.asDriver()
    }
    
    init() {
        profileRelay.accept(Profile.profiles)
        messageRelay.accept(Message.messages)
    }
}

extension StudyRoomViewModel {
    
}
