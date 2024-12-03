//
//  UIScrollView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation
import UIKit

extension UIScrollView {
    
    // 目的地、地域・国scrollViewに適用させる
    func setup() {
        isScrollEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    }
    
    // 下端から50ポイント以上さらに下にスクロールさせた場合
    func isNearBottomEdge(edgeOffset: CGFloat = 50) -> Bool {
        return contentOffset.y + frame.size.height - edgeOffset >= contentSize.height
    }
}
