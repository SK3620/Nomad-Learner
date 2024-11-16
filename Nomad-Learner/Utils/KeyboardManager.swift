//
//  KeyboardManager.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class KeyboardManager {
    private let disposeBag = DisposeBag()
    private var view: UIView = UIView()
    private var adjustableTextViews: [UITextView] = [] // 調整対象のUITextView群
    private var originY: CGFloat = 0 // 初期Y座標
    
    // 調整対象のUITextView群を設定
    func setAdjustableTextViews(_ textViews: [UITextView]) {
        self.adjustableTextViews = textViews
    }
    
    // キーボード表示時のビュー調整処理
    func adjustViewForKeyboardAppearance(in view: UIView) {
        // キーボードが表示される直前にビューの位置を設定
        RxKeyboard.instance.willShowVisibleHeight
            .map { _ in view }
            .drive(setInitialViewOriginY)
            .disposed(by: disposeBag)
        
        // キーボード高さに基づいてビューの調整を行う
        RxKeyboard.instance.visibleHeight
            .drive(adjustViewPosition)
            .disposed(by: disposeBag)
    }
}

private extension KeyboardManager {
    
    // キーボード表示前のビューのY座標を記録
    var setInitialViewOriginY: Binder<UIView> {
        return Binder(self) { base, view in
            base.view = view
            if let focusedTextView = view.findFirstResponder() as? UITextView,
               base.adjustableTextViews.contains(focusedTextView) {
                base.originY = view.frame.origin.y
            }
        }
    }
    
    // キーボード高さに基づいてビュー位置を調整
    var adjustViewPosition: Binder<CGFloat> {
        return Binder(self) { base, keyboardHeight in
            guard let focusedTextView = base.view.findFirstResponder() as? UITextView,
                  base.adjustableTextViews.contains(focusedTextView) else { return }
            
            let focusedViewFrameInView = focusedTextView.convert(focusedTextView.bounds, to: base.view)
            let keyboardTopY = base.view.viewHeight - focusedViewFrameInView.maxY
            let adjustment = keyboardHeight - keyboardTopY
                        
            if adjustment > 0 || base.view.frame.origin.y != base.originY {
                base.view.frame.origin.y = keyboardHeight > 0 ? -adjustment : base.originY
            }
        }
    }
}

// UIView拡張: 最初のレスポンダーを再帰的に探す
private extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
