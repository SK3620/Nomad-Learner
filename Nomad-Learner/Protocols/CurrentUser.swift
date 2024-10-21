//
//  CurrentUser.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/04.
//

import Foundation
import FirebaseAuth
import Firebase

class CurrentUser {
    static let user = Auth.auth().currentUser
}
