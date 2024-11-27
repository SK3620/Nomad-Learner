//
//  aaa.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/27.
//

import Foundation
import FirebaseAuth

extension AuthViewModel {
    // 認証プロバイダーを使用した認証結果
    enum SignInWithAuthProviderResult {
        case success(FirebaseAuth.User)
        case failure(MyAppError)
    }
}
