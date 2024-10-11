//
//  EditProfileTextView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import Foundation
import UIKit

class EditProfileTextView: UITextView {
    
    init(text: String) {
        super.init(frame: .zero, textContainer: nil)
        self.text = text
        self.backgroundColor = .clear
        self.font = UIFont.systemFont(ofSize: UIConstants.TextSize.medium, weight: .medium)
        self.textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
