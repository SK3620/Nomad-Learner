//
//  AuthBox.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit
import Then
import SnapKit

class BottomAuthStackView: UIStackView {
    
    // SignUp/SignInボタン
    let authButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 44 / 2
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.tintColor = .white
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    // テキスト付き区切り線
    private let separatorWithText = SeparatorWithLabelView(text: "or")
    
    // Google, Apple, Twitterボタン
    private let providerButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing // ボタンを最大限埋めて均等に配置
    }
    
    // 区切り線
    private let separator = SeparatorWithLabelView()
    
    // SignIn/SignUp画面切り替え
    let authModeToggleButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setTitle("パスワードを忘れた", for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    // アカウント削除ボタン
    let deleteAccountButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.setTitle("アカウントを削除する▶︎", for: .normal)
        $0.tintColor = .red
    }
    
    // 初期化処理
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        distribution = .fillProportionally
        spacing = 8
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addArrangedSubview(authButton)
        addArrangedSubview(separatorWithText)
        addArrangedSubview(providerButtonStackView)
        addArrangedSubview(separator)
        addArrangedSubview(authModeToggleButton)
        addArrangedSubview(deleteAccountButton)
        
        // SignUp/SignInボタン
        authButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        // テキスト付き区切り線
        separatorWithText.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        // Google, Apple, Twitterボタン
        providerButtonStackView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.equalTo(separatorWithText).inset(32 * 2)
        }
        
        // 区切り線
        separator.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        // Dont't you have an account? ボタン
        authModeToggleButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        // アカウント削除ボタン
        deleteAccountButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
    
    // FirebaseUI認証ボタンをstackViewへ追加
    func addProviderButton(_ button: UIButton) {
        // ボタンのタイトルを空に設定
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 44 / 2
        button.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        // UIImageViewプロパティをカスタマイズ
        if let imageView = button.imageView {
            imageView.snp.makeConstraints {
                $0.size.equalTo(button).inset(8)
                $0.center.equalTo(button) // ボタン中央に配置
            }
        }
        providerButtonStackView.addArrangedSubview(button)
    }
}

extension BottomAuthStackView {
    
    // SignIn/SignUp画面に応じてUI要素を調整
    func transform(to screenMode: AuthViewModel.AuthMode) {
        authButton.setTitle(screenMode.authButtonTitleToString, for: .normal)
        authModeToggleButton.setTitle(screenMode.sectionSwitchTitleToString, for: .normal)
    }
    
    // SignIn/SignUpボタンの非/活性状態の調整
    func updateAuthButtonState(_ isValid: Bool) {
        let color = ColorCodes.primaryPurple.color()
        authButton.isEnabled = isValid
        authButton.backgroundColor = isValid ? color : color.withAlphaComponent(0.3)
    }
}
