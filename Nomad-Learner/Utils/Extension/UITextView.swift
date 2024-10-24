//
//  UITextView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/24.
//

import Foundation
import UIKit

extension UITextView {
    // キーボード閉じるボタンの追加
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let image = UIImage(systemName: "chevron.down")
        let doneButton = UIBarButtonItem(image: image, style: .done, target: onDone?.target, action: onDone?.action)
        doneButton.tintColor = ColorCodes.primaryPurple.color()
        toolbar.items = [spacer, doneButton]
        self.inputAccessoryView = toolbar
    }
}
