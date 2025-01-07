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
    
    // テキスト全体のスタイル設定と特定の単語に色や影を適用
    func createAttributedText(
        text: String,
        highlightedWords: [String] = [],
        highlightColor: UIColor = ColorCodes.primaryPurple.color(),
        font: UIFont,
        lineSpacing: CGFloat = 6,
        kern: CGFloat = 0.8
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = .center
        textAlignment = .center
        numberOfLines = 0
        
        // 全体のフォントや間隔を設定
        attributedString.addAttributes([
            .font: font,
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: text.count))
        
        // 特定の文字列の色と下線を変更
        highlightedWords.forEach { word in
            let regex = try! NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: word))
            let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))
            
            matches.forEach { match in
                let range = match.range
                let shadow = NSShadow()
                shadow.shadowColor = UIColor.orange // ぼやけた影の色
                shadow.shadowBlurRadius = 10 // ぼやけ具合
                
                attributedString.addAttributes([
                    .foregroundColor: highlightColor,
                    .shadow: shadow,
                ], range: range)
            }
        }
        
        return attributedString
    }
}
