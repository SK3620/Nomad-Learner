//
//  UIConstants.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit

struct UIConstants {
    // TextField
    struct TextField {
        static let height: CGFloat = 44
        static let fontSize: CGFloat = 17
        static let borderHeight: CGFloat = 0.75
        static let leftIconSize: CGFloat = 24
    }
    
    // Button
    struct Button {
        static let height: CGFloat = 44
        static let cornerRadius: CGFloat = 22
        static let fontSize: CGFloat = 17
    }
    
    struct Font {
        static let smallFont: CGFloat = 17
    }
    
    // Image
    struct Image {
        static let size = 24
    }
    
    // 共通マージンやパディング
    struct Layout {
        static let standardPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 32
    }
    
    // 色やフォントのスタイル
    struct Style {
        static let borderColor: UIColor = .lightGray
        static let buttonBackgroundColor: UIColor = .systemBlue
        static let buttonTextColor: UIColor = .white
    }
}
