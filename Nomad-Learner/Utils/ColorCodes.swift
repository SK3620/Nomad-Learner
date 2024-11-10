//
//  ColorCodes.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/29.
//

import UIKit

enum ColorCodes {
    case primaryPurple
    case primaryLightPurple
    case primaryGray
    case primaryGray2
    case primaryLightGray
    case completedGreen
    case successGreen
    case successGreen2
    case failure
    case background
    case buttonBackground
    case modalBackground
}

extension ColorCodes {
    
    func color() -> UIColor {
        switch self {
        case .primaryPurple:
            return UIColor(red: 0.3, green: 0.0, blue: 0.5, alpha: 1.0)
        case .primaryLightPurple:
            return UIColor(red: 0.95, green: 0.95, blue: 1.0, alpha: 1.0)
        case .primaryGray:
            return UIColor.gray
        case .primaryGray2:
            return UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.0)
        case .primaryLightGray:
            return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        case .completedGreen:
            return UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case .successGreen:
            return UIColor(red: 0.1, green: 0.45, blue: 0.1, alpha: 1.0)
        case .successGreen2:
            return UIColor(red: 0.92, green: 0.98, blue: 0.94, alpha: 1.0)
        case .failure:
            return UIColor.red
        case .background:
            return UIColor.white
        case .buttonBackground:
            return UIColor(red: 0.3, green: 0.0, blue: 0.5, alpha: 1.0)
        case .modalBackground:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
}
