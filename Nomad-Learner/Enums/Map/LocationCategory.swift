//
//  LocationCategory.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation
import UIKit

enum LocationCategory: String, CaseIterable {
    case all = "all"
    case buildings = "buildings"
    case nature = "nature"
    
    case hasntVisited = "hasntVisisted"
    case isOngoing = "isOngoing"
    case isCompleted = "isCompleted"
    
    var title: String {
        switch self {
        case .all:
            return "全て"
        case .buildings:
            return "建造物"
        case .nature:
            return "自然"
        case .hasntVisited:
            return "未訪問"
        case .isOngoing:
            return "進行中"
        case .isCompleted:
            return "完了"
        }
    }
    
    var image: UIImage {
        switch self {
        case .all:
            return UIImage(systemName: "globe")!
        case .buildings:
            return UIImage(systemName: "building.columns")!
        case .nature:
            return UIImage(systemName: "leaf")!
        case .hasntVisited:
            return UIImage(named: "MapPinGray")!
        case .isOngoing:
            return UIImage(named: "MapPinYellow")!
        case .isCompleted:
            return UIImage(named: "MapPinGreen")!
        }
    }
    
    var unSelectedColor: UIColor {
        switch self {
        case .hasntVisited:
            return UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
        case .isOngoing:
            return UIColor(red: 203/255, green: 204/255, blue: 66/255, alpha: 1.0)
        case .isCompleted:
            return UIColor(red: 0/255, green: 179/255, blue: 0/255, alpha: 1.0)
        default:
            return ColorCodes.primaryPurple.color()
        }
    }
    
    var selectedColor: UIColor {
        switch self {
        case .hasntVisited:
            return UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1.0)
        case .isOngoing:
            return UIColor(red: 203/255, green: 204/255, blue: 66/255, alpha: 1.0)
        case .isCompleted:
            return UIColor(red: 0/255, green: 179/255, blue: 0/255, alpha: 1.0)
        default:
            return .white
        }
    }

    // カテゴリ一覧を取得
   static var categories: [LocationCategory] {
        return Array(self.allCases)
    }
}
