//
//  LocationLabel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation
import UIKit

class LocationLabel: UILabel {
    
    init(textColor: UIColor, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.text = "Coffee shop and tea / USA General street 19 "
        self.numberOfLines = 1
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
