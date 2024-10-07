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
    
    // 画面の幅を取得
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // 画面の高さを取得
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // View自身の幅を取得
    var viewWidth: CGFloat {
        return self.frame.size.width
    }
    
    // View自身の高さを取得
    var viewHeight: CGFloat {
        return self.frame.size.height
    }
    
    // Safe area の高さを除いた画面の高さを取得
    var safeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        return screenHeight - topPadding - bottomPadding
    }
    
    // Viewのx座標（左上）の位置を取得
    var viewX: CGFloat {
        return self.frame.origin.x
    }
    
    // Viewのy座標（左上）の位置を取得
    var viewY: CGFloat {
        return self.frame.origin.y
    }
}
