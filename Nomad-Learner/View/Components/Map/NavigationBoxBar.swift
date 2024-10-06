//
//  NavigationBoxBar.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/06.
//

import Foundation
import UIKit

class NavigationBoxBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = UIConstants.Layer.radius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
