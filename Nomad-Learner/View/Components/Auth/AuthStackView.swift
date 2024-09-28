//
//  AuthBox.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/28.
//

import UIKit
import Then
import SnapKit

class AuthStackView: UIStackView {
    // 入力欄
    private let usernameTextField = AuthTextField(placeholder: "Username", imageName: "person")
    private let emailTextField = AuthTextField(placeholder: "Email Address", keyboardType: .emailAddress, imageName: "envelope")
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true, imageName: "lock")
    
    // Forget Passwordボタンコンテナビュー
    private let forgetPasswordButtonContainer = UIView()
    // Forget Passwordボタン
    private let forgetPasswordButton = UIButton(type: .system).then {
        $0.setTitle("forget your password?", for: .normal)
    }
    
    // SignUp/SignInボタン
    private let authButton = UIButton(type: .system).then {
        $0.setTitle("Sign Up / Sign Up", for: .normal)
        $0.layer.cornerRadius = UIConstants.Button.height / 2
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.Font.smallFont)
        $0.tintColor = .white
        $0.backgroundColor = .blue
    }
    
    // 初期化処理
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        forgetPasswordButtonContainer.snp.makeConstraints {
            $0.height.equalTo(UIConstants.Button.height)
        }
        forgetPasswordButtonContainer.addSubview(forgetPasswordButton)
        
        // サブビューの追加
        addArrangedSubview(usernameTextField)
        addArrangedSubview(emailTextField)
        addArrangedSubview(passwordTextField)
        addArrangedSubview(forgetPasswordButtonContainer)
        addArrangedSubview(authButton)
        
        forgetPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.right.equalTo(passwordTextField.snp.right)
        }
        
        authButton.snp.makeConstraints {
            $0.height.equalTo(UIConstants.Button.height)
        }
    }
}
