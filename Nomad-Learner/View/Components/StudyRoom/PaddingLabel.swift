//
//  PaddingLabel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit

class PaddingLabel: UILabel {
    
    public var padding: UIEdgeInsets = .zero
    
    // テキストの描画範囲を余白のInsetを加えたものにする/textを入れるrectangleにInsetを生成して余白入れる
    public override func drawText(in rect: CGRect) {
        // drawText → Draws the label’s text, or its shadow, in the specified rectangle.
        super.drawText(in: rect.inset(by: self.padding))
    }
    
    // Intrinsic Content Sizeを余白のInset加えたものにする
    public override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += self.padding.top + self.padding.bottom
        intrinsicContentSize.width += self.padding.left + self.padding.right
        return intrinsicContentSize
    }
}
