//
//  aaa.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation

extension AuthViewModel {
    enum AuthMode {
        // サインイン画面
        case signIn
        // サインアップ画面
        case signUp
        
        var authButtonTitleToString: String {
            switch self {
            case .signIn:
                return "サインイン"
            case .signUp:
                return "サインアップ"
            }
        }
        
        var sectionSwitchTitleToString: String {
            switch self {
            case .signIn:
                return "アカウントを作成する▶︎"
            case .signUp:
                return "すでにアカウントを持っている▶︎"
            }
        }
    }
}
