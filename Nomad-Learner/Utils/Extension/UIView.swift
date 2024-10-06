//
//  UIView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/06.
//

import Foundation
import UIKit

extension UIView {
    
    func applyShadow(
        color: UIColor = .black, // 影の色
        opacity: Float = 0.2, // 透明度
        offset: CGSize = CGSize(width: 0, height: 2), // オフセット
        radius: CGFloat = 4 // ぼかし
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}
