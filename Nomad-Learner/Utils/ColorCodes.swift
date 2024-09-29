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
    case primaryBlack
    case primaryGray
    case primaryGray2
    case primaryLightGray
    case successGreen
    case successGreen2
    case failure
    case background
    case buttonBackground
}

extension ColorCodes {
    
    func color() -> UIColor {
        switch self {
        case .primaryPurple:
            return UIColor(red: 0.3, green: 0.0, blue: 0.5, alpha: 1.0)
        case .primaryLightPurple:
            return UIColor(red: 0.95, green: 0.95, blue: 1.0, alpha: 1.0)
        case .primaryBlack:
            return UIColor.black
        case .primaryGray:
            return UIColor.gray
        case .primaryGray2:
            return UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.0)
        case .primaryLightGray:
            return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
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
        }
    }
}
