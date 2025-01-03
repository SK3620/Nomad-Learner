//
//  User.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

struct User {
    var userId: String
    var username: String
    var profileImageUrl: String
    var currentLocationId: String
    var currentCoin: Int
    var livingPlaceAndWork: String
    var studyContent: String
    var goal: String
    var others: String
    var progressSum: StudyProgressSummary?
    
    init(
        userId: String = "",
        username: String = "ー",
        profileImageUrl: String = "",
        currentLocationId: String = "",
        currentCoin: Int = 0,
        livingPlaceAndWork: String = "ー",
        studyContent: String = "ー",
        goal: String = "ー",
        others: String = "ー"
    ) {
        self.userId = userId
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.currentLocationId = currentLocationId
        self.currentCoin = currentCoin
        self.livingPlaceAndWork = livingPlaceAndWork
        self.studyContent = studyContent
        self.goal = goal
        self.others = others
    }
}

extension User {
    // Userのプロパティを辞書形式に変換（プロフィール情報のみ）
    var toDictionary: [String: Any] {
        return [
            "userId": userId,
            "username": username,
            "profileImageUrl": profileImageUrl,
            "currentLocationId": currentLocationId,
            "currentCoin": currentCoin,
            "livingPlaceAndWork": livingPlaceAndWork,
            "studyContent": studyContent,
            "goal": goal,
            "others": others
        ]
    }
    
    var toDictionaryForUpdate: [String: Any] {
        return [
            "username": username,
            "profileImageUrl": profileImageUrl,
            "livingPlaceAndWork": livingPlaceAndWork,
            "studyContent": studyContent,
            "goal": goal,
            "other": others
        ]
    }
}
