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
    private var adjustableTextViews: [UITextView] = [] // 調整可能なUITextViewを格納する配列
    
    private var originY: CGFloat = 0 // 最初のY座標を保持

    // 調整が必要なUITextViewを指定するメソッド
    func setAdjustableTextViews(_ textViews: [UITextView]) {
        self.adjustableTextViews = textViews
    }
    
    // キーボード表示時にビューを調整するメソッド
    func adjustViewOnKeyboardAppear(view: UIView) {
        // キーボードが表示される直前に一度だけ呼ばれる
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { _ in
                // フォーカスされているUITextViewが、調整対象に含まれている場合のみ処理
                if let focusedView = view.findFirstResponder() as? UITextView,
                   self.adjustableTextViews.contains(focusedView) {
                    // キーボード表示前のビューのY座標を記録
                    self.originY = view.frame.origin.y
                }
            })
            .disposed(by: disposeBag)

        // キーボードの高さを監視し、ビューを調整
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                
                // フォーカスされているUITextViewが、調整対象に含まれている場合
                if let focusedView = view.findFirstResponder() as? UITextView,
                   self.adjustableTextViews.contains(focusedView) {
                    
                    // UITextViewの位置を、viewControllerの座標系に変換
                    let focusedViewFrameInView = focusedView.convert(focusedView.bounds, to: view)
                    
                    // キーボードとUITextViewの位置関係を計算
                    let keyboardTopY = view.viewHeight - focusedViewFrameInView.maxY
                    let diff = keyboardHeight - keyboardTopY
                    
                    // キーボードが表示されている場合は、UITextViewの位置を調整
                    // キーボードが表示されていない場合は元の位置に戻す
                    view.frame.origin.y = keyboardHeight > 0 ? -diff : self.originY
                }
            })
            .disposed(by: disposeBag)
    }
}

// UIView拡張: フォーカスされているビュー（最初のレスポンダー）を再帰的に探す
private extension UIView {
    func findFirstResponder() -> UIView? {
        // 自身が最初のレスポンダーの場合、そのビューを返す
        if self.isFirstResponder {
            return self
        }
        // 子ビューを再帰的に検索して、最初のレスポンダーを返す
        for subview in subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
