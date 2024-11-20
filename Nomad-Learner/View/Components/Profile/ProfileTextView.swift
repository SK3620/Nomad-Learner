//
//  ProfileTextView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import Foundation
import UIKit

class ProfileTextView: UITextView {
    
    init(text: String) {
        super.init(frame: .zero, textContainer: nil)
        self.text = text
        self.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
