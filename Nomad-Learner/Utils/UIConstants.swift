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
        static let leftIconSize: CGFloat = 24
    }
    
    // UILabel
    struct UILabel {
        static let fontSize: CGFloat = 12
    }
    
    // Button
    struct Button {
        static let smallHeight: CGFloat = 42
        static let height: CGFloat = 44
        static let cornerRadius: CGFloat = 22
        static let fontSize: CGFloat = 17
    }
    
    struct StackViewElement {
        static let height: CGFloat = 44
    }
    
    struct NavigationBar {
        static let standardHeight: CGFloat = 44
    }
    
    struct TabBarHeight {
        static let height: CGFloat = 70
    }
    
    struct Font {
        static let smallFont: CGFloat = 17
    }
    
    // Image
    struct Image {
        static let small: CGFloat = 16
        static let semiMedium: CGFloat = 20
        static let medium: CGFloat = 24
        static let semiLarge: CGFloat = 28
        static let large: CGFloat = 32
        static let semiExtraLarge: CGFloat = 36
        static let extraLarge: CGFloat = 40
        static let semiSuperLarge: CGFloat = 44
        static let superLarge: CGFloat = 48
    }
    
    // 共通マージンやパディング
    struct Layout {
        static let extraSmallPadding: CGFloat = 4
        static let semiSmallPadding: CGFloat = 6
        static let smallPadding: CGFloat = 8
        static let semiStandardPadding: CGFloat = 12
        static let standardPadding: CGFloat = 16
        static let semiMediumPadding: CGFloat = 20
        static let mediumPadding: CGFloat = 24
        static let semiLargePadding: CGFloat = 28
        static let largePadding: CGFloat = 32
        static let semiExtraLargePadding: CGFloat = 36
        static let extraLargePadding: CGFloat = 40
    }
    
    struct Style {
       
    }
    
    struct Layer {
        static let radius: CGFloat = 32
    }
    
    struct TextSize {
        static let extraSmall: CGFloat = 12
        static let small: CGFloat = 14
        static let semiMedium: CGFloat = 16
        static let medium: CGFloat = 18
        static let semiLarge: CGFloat = 20
        static let large: CGFloat = 22
        static let semiExtraLarge: CGFloat = 24
        static let extraLarge: CGFloat = 26
        static let semiSuperLarge: CGFloat = 28
        static let superLarge: CGFloat = 30
    }
}
