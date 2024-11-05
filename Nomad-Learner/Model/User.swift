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
    var visitedCountries: Int
    var weeklyTime: Int
    var totalTime: Int
    
    init(
        userId: String = "",
        username: String = "ー",
        profileImageUrl: String = "",
        currentLocationId: String = "sydney_opera_house", // 暫定で設定
        currentCoin: Int = 100000,
        livingPlaceAndWork: String = "ー",
        studyContent: String = "ー",
        goal: String = "ー",
        visitedCountries: Int = 0,
        weeklyTime: Int = 0,
        totalTime: Int = 0
    ) {
        self.userId = userId
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.currentLocationId = currentLocationId
        self.currentCoin = currentCoin
        self.livingPlaceAndWork = livingPlaceAndWork
        self.studyContent = studyContent
        self.goal = goal
        self.visitedCountries = visitedCountries
        self.weeklyTime = weeklyTime
        self.totalTime = totalTime
    }
}

extension User {
    /// Userのプロパティを辞書形式に変換します。
    var toDictionary: [String: Any] {
        return [
            "username": username,
            "profileImageUrl": profileImageUrl,
            "currentLocationId": currentLocationId,
            "currentCoin": currentCoin,
            "livingPlaceAndWork": livingPlaceAndWork,
            "studyContent": studyContent,
            "goal": goal,
            "visitedCountries": visitedCountries,
            "weeklyTime": weeklyTime,
            "totalTime": totalTime
        ]
    }
}
