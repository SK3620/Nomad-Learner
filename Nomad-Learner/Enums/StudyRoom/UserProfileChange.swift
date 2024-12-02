//
//  a.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/12/02.
//

import Foundation
import UIKit

enum UserProfileChange {
    case added(User) // 勉強開始（入室）
    case removed(User) // 勉強終了（退室）
    
    var userInfo: (profileImageUrl: String, username: String) {
        switch self {
        case .added(let user):
            return (user.profileImageUrl, user.username)
        case .removed(let user):
            return (user.profileImageUrl, user.username)
        }
    }
    
    var massage: String {
        switch self {
        case .added:
            return "勉強開始！"
        case .removed:
            return "終了！"
        }
    }
    
    // 開始/終了 色
    var colorOnChanges: UIColor {
        switch self {
        case .added:
            return ColorCodes.completedGreen.color()
        case .removed:
            return .red
        }
    }
}
