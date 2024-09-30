//
//  CustomAuthPickerViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit
import SwiftUI
import SnapKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseOAuthUI
import Firebase
import Then

// MARK: - Customize AuthPickerViewController
class CustomAuthPickerViewController: FUIAuthPickerViewController, UITextFieldDelegate {
    
    private var keyboardManager: KeyboardManager?
    
    private lazy var scrollView = view.subviews[0].then {
        $0.backgroundColor = .clear
    }
    
    private lazy var contentView = scrollView.subviews[0].then {
        $0.backgroundColor = .white
    }
    
    private let authStackView: AuthStackView = AuthStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = UIConstants.Layout.standardPadding
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UItextFieldデリゲート設定
        authStackView.authTextFields.forEach {
            $0.delegate = self
        }
        
        // passwordTextFieldを基準にキーボード出現時のレイアウト調整
        keyboardManager = KeyboardManager(viewController: self, textField: authStackView.authTextFields[2])
        
        setupUI()
    }
    
    private func setupUI() {
        // 入力欄＋認証ボタン等追加
        contentView.addSubview(authStackView)
        
        // 画面いっぱいに広げる
        contentView.snp.makeConstraints {
            $0.size.edges.equalTo(view)
        }
        // 最下部に設置
        authStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        // FirebaseUIのボタンを取得してauthStackViewに追加
        self.view.subviews[0].subviews[0].subviews[0].subviews.forEach { (view: UIView) in
            if let button = view as? UIButton {
                // 新しい制約でStackViewに追加
                authStackView.addProviderButton(button)
            }
        }
    }
    
    // リターンがタップされた時にキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         // タイトルなし
         self.title = ""
    }
}
