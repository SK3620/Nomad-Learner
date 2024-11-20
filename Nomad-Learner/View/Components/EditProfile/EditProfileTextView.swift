//
//  EditProfileTextView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import Foundation
import UIKit

class EditProfileTextView: UITextView {
    
    init(text: String = "") {
        super.init(frame: .zero, textContainer: nil)
        self.text = text
        self.backgroundColor = .clear
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .black
        // キーボードに完了ボタン表示
        self.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTapped)))
    }
    
    // キーボード閉じる
    @objc func doneButtonTapped() {
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
