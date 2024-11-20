//
//  TextField.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/29.
//

import UIKit

extension UITextField {
    
    // フォントの一括指定
    @objc var substituteFontName: String {
        get {
            return font!.fontName
        }
        set {
            // 通常フォントのみ適用
            if font!.fontName.range(of: "Regular") != nil {
                font = UIFont(name: newValue, size: font!.pointSize)
            }
        }
    }
    
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
