//
//  ExtensionedUILabel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit

extension UILabel {
    
    // フォントの一括指定
    @objc var substituteFontName: String {
        get {
            return font.fontName
        }
        set {
            // 通常フォントのみ適用
            if font.fontName.range(of: "Regular") != nil {
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
            if font.fontName.range(of: "Semibold") != nil {
                font = UIFont(name: newValue, size: font.pointSize)
            }
        }
    }
    
    // ラベルのテキスト内容の幅
    func contentSizeWidth() -> CGFloat {
        return intrinsicContentSize.width
    }
    
    // ラベルのテキスト内容の高さ
    func contentSizeHeight() -> CGFloat {
        return intrinsicContentSize.height
    }
}
