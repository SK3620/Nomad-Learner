//
//  StudyTimeLabel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import Foundation
import UIKit

class ProfileLabel: UILabel {
    
    private var textPadding: UIEdgeInsets = UIEdgeInsets.zero
    
    init(text: String = "", fontSize: CGFloat, textColor: UIColor, isRounded: Bool = false, horizontalPadding: CGFloat = 8, verticalPadding: CGFloat = 4) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        
        // 各丸の枠線をつける
        if isRounded {
            self.font = UIFont.boldSystemFont(ofSize: fontSize)
            self.layer.cornerRadius = (intrinsicContentSize.height + verticalPadding) / 2
            self.layer.masksToBounds = true
            self.backgroundColor = .white
            self.textPadding = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileLabel {
    // テキスト内部にパディングをつける
    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: textPadding)
        super.drawText(in: paddedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let width = originalSize.width + textPadding.left + textPadding.right
        let height = originalSize.height + textPadding.top + textPadding.bottom
        return CGSize(width: width, height: height)
    }
}
