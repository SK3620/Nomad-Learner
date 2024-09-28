//
//  ExtensionedUILabel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit

extension UILabel {
    
    @objc var substituteFontName: String {
        get {
            return font.fontName
        }
        set {
            // 通常フォントのみ適用
            if font.fontName.range(of: "Medium") == nil {
                font = UIFont(name: newValue, size: font.pointSize)
            }
        }
    }
    
    @objc var substituteFontBoldName: String {
        get {
            return font.fontName
        }
        set {
            // ボールドフォントのみ適用
            if font.fontName.range(of: "Medium") != nil {
                font = UIFont(name: newValue, size: font.pointSize)
            }
        }
    }
}
