//
//  AuthInfoInputStackView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/30.
//

import UIKit
import Then
import SnapKit

class AuthInfoInputStackView: UIStackView {
    // 入力欄
    let usernameTextField = AuthTextField(
        placeholder: "ユーザー名",
        leftImageName: "person"
    )
    let emailTextField = AuthTextField(
        placeholder: "メールアドレス",
        keyboardType: .emailAddress,
        leftImageName: "envelope"
    )
    let passwordTextField = AuthTextField(
        placeholder: "パスワード",
        isSecureTextEntry: true,
        leftImageName: "lock",
        needsRightImage: true
    )
    
    // バリデーションメッセージ
    let usernameValidation: UILabel = ValidationLabel()
    let emailValidation: UILabel = ValidationLabel()
    let passwordValidation: UILabel = ValidationLabel()
    
    // 初期化処理
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        distribution = .fillProportionally
        spacing = 20
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addArrangedSubview(usernameTextField)
        addArrangedSubview(emailTextField)
        addArrangedSubview(passwordTextField)
        
        addSubview(usernameValidation)
        addSubview(emailValidation)
        addSubview(passwordValidation)
        
        // ユーザー名バリデーションメッセージ
        usernameValidation.snp.makeConstraints {
            $0.top.equalTo(usernameTextField.snp.bottom).offset(4)
            $0.right.equalToSuperview()
        }
        
        // メールアドレスバリデーションメッセージ
        emailValidation.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
                .offset(4)
            $0.right.equalToSuperview()
        }
        
        // パスワードバリデーションメッセージ
        passwordValidation.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
                .offset(4)
            $0.right.equalToSuperview()
        }
    }
}

extension AuthInfoInputStackView {
    
    // SignIn/SignUp画面に応じてUI要素を調整
    func transform(to screenMode: AuthViewModel.AuthMode) {
        usernameTextField.isHidden = screenMode == .signIn
        usernameValidation.isHidden = screenMode == .signIn
    }
    
    // 認証成功時、入力フィールドをクリア
    func clearTextField() {
        usernameTextField.text = ""
        usernameTextField.sendActions(for: .valueChanged)
        emailTextField.text = ""
        emailTextField.sendActions(for: .valueChanged)
        passwordTextField.text = ""
        passwordTextField.sendActions(for: .valueChanged)
    }
}
