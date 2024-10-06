//
//  ValidationLabel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/03.
//

import UIKit
import SnapKit

class ValidationLabel: UILabel {

    init() {
        super.init(frame: .zero)
        self.textColor = .red
        self.font = UIFont.systemFont(ofSize: UIConstants.UILabel.fontSize)
        self.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
