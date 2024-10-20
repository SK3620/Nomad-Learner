//
//  User.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/20.
//

import Foundation

struct User {
    let userId: String
    let username: String
    let currentCoin: Int
    let livingPlaceAndWork: String
    let studyContent: String
    let goal: String
    let visitedCountries: Int
    let weeklyTime: Int
    let totalTime: Int
    let visitedLocatioins: [VisitedLocation]
}
