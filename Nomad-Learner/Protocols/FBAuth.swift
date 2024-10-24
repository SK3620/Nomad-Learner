//
//  CurrentUser.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/04.
//

import Foundation
import FirebaseAuth
import Firebase

class FBAuth {
    /// 現在ログインしているユーザーを返す
    static var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    /// 現在ログインしているユーザーのUIDを返す
    static var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    /// 現在ログインしているユーザーのメールアドレスを返す
    static var currentUserEmail: String? {
        return Auth.auth().currentUser?.email
    }
    
    /// 現在ログインしているユーザーの表示名を返す
    static var currentUserDisplayName: String? {
        return Auth.auth().currentUser?.displayName
    }
}
