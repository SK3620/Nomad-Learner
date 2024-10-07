//
//  LocationCategory.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation

enum LocationCategory: String, CaseIterable {
    case mountain = "Mountain"
    case book = "Book"
    case leaf = "Leaf"
    case person = "Person"
    case airplane = "Airplane"
    case tennisBall = "Tennis Ball"

    var title: String {
        return self.rawValue
    }

    var systemImageName: String {
        switch self {
        case .mountain:
            return "mountain.2"
        case .book:
            return "book"
        case .leaf:
            return "leaf"
        case .person:
            return "person"
        case .airplane:
            return "airplane"
        case .tennisBall:
            return "tennisball"
        }
    }
}
