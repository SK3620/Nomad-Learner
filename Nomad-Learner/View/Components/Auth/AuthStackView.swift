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
    lazy var usernameTextField = AuthTextField(
        placeholder: "ユーザー名",
        leftImageName: "person"
    )
    lazy var emailTextField = AuthTextField(
        placeholder: "メールアドレス",
        keyboardType: .emailAddress,
        leftImageName: "envelope"
    )
    lazy var passwordTextField = AuthTextField(
        placeholder: "パスワード",
        isSecureTextEntry: true,
        leftImageName: "lock",
        needsRightImage: true
    )
    
    // バリデーションメッセージ
    lazy var usernameValidation: UILabel = ValidationLabel()
    lazy var emailValidation: UILabel = ValidationLabel()
    lazy var passwordValidation: UILabel = ValidationLabel()
    
    // 間隔を空けるための空のView
    lazy var emptyView = UIView()
    
    /*
    // Forget Passwordボタン
    lazy var passwordResetButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.Font.smallFont)
        $0.setTitle("forget your password?", for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
     */
    
    // SignUp/SignInボタン
    lazy var authButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = UIConstants.Button.height / 2
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.Font.smallFont)
        $0.tintColor = .white
        $0.backgroundColor = ColorCodes.primaryPurple.color()
    }
    
    // テキスト付き区切り線
    private lazy var separatorWithText = SeparatorWithLabelView(text: "or")
    
    // Google, Apple, Twitterボタン
    private lazy var providerButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing // ボタンを最大限埋めて均等に配置
    }
    
    // 区切り線
    private lazy var separator = SeparatorWithLabelView()
    
    // SignIn/SignUp画面切り替え
    lazy var authModeToggleButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.Font.smallFont)
        $0.setTitle("パスワードを忘れた", for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    // アカウント削除ボタン
    let deleteAccountButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.Font.smallFont)
        $0.setTitle("アカウントを削除する", for: .normal)
        $0.tintColor = .red
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
        
        // サブビューの追加
        addArrangedSubview(usernameTextField)
        addArrangedSubview(emailTextField)
        addArrangedSubview(passwordTextField)
        addArrangedSubview(emptyView)
        addArrangedSubview(authButton)
        addArrangedSubview(separatorWithText)
        addArrangedSubview(providerButtonStackView)
        addArrangedSubview(separator)
        addArrangedSubview(authModeToggleButton)
        addArrangedSubview(deleteAccountButton)
        
        self.addSubview(usernameValidation)
        self.addSubview(emailValidation)
        self.addSubview(passwordValidation)
        // self.addSubview(passwordResetButton)
        
        // ユーザー名バリデーションメッセージ
        usernameValidation.snp.makeConstraints {
            $0.top.equalTo(usernameTextField.snp.bottom).offset(UIConstants.Layout.extraSmallPadding)
            $0.right.equalToSuperview()
        }
        
        // メールアドレスバリデーションメッセージ
        emailValidation.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
                .offset(UIConstants.Layout.extraSmallPadding)
            $0.right.equalToSuperview()
        }
        
        // パスワードバリデーションメッセージ
        passwordValidation.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
                .offset(UIConstants.Layout.extraSmallPadding)
            $0.right.equalToSuperview()
        }
        
        /*
        // Forget Passwordボタン
        passwordResetButton.snp.makeConstraints {
            $0.top.equalTo(passwordValidation.snp.bottom)
            $0.right.equalToSuperview()
        }
         */
        
        // 間隔を空けるための空のView
        emptyView.snp.makeConstraints {
            $0.height.equalTo(UIConstants.StackViewElement.height)
        }
        
        // SignUp/SignInボタン
        authButton.snp.makeConstraints {
            $0.height.equalTo(UIConstants.StackViewElement.height)
        }
        
        // テキスト付き区切り線
        separatorWithText.snp.makeConstraints {
            $0.height.equalTo(UIConstants.StackViewElement.height)
        }
        
        // Google, Apple, Twitterボタン
        providerButtonStackView.snp.makeConstraints {
            $0.height.equalTo(UIConstants.StackViewElement.height)
            $0.horizontalEdges.equalTo(separatorWithText).inset(UIConstants.Layout.largePadding * 2)
        }
        
        // 区切り線
        separator.snp.makeConstraints {
            $0.height.equalTo(UIConstants.StackViewElement.height)
        }
        
        // Dont't you have an account? ボタン
        authModeToggleButton.snp.makeConstraints {
            $0.height.equalTo(UIConstants.StackViewElement.height)
        }
        
        // アカウント削除ボタン
        deleteAccountButton.snp.makeConstraints {
            $0.height.equalTo(UIConstants.StackViewElement.height)
        }
    }
    
    // FirebaseUI認証ボタンをstackViewへ追加
    func addProviderButton(_ button: UIButton) {
        // ボタンのタイトルを空に設定
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = UIConstants.Button.height / 2
        button.snp.makeConstraints {
            $0.size.equalTo(UIConstants.Button.height)
        }
        // UIImageViewプロパティをカスタマイズ
        if let imageView = button.imageView {
            imageView.snp.makeConstraints {
                $0.size.equalTo(button).inset(UIConstants.Layout.smallPadding)
                $0.center.equalTo(button) // ボタン中央に配置
            }
        }
        providerButtonStackView.addArrangedSubview(button)
    }
}

extension AuthStackView {
    
    // ViewModel状態に応じてUIを更新
    enum UIUpdate {
        case transform(to: AuthViewModel.AuthMode)
        case updateAuthButtonState(Bool)
        case clearTextField
    }
    
    func apply(_ update: UIUpdate) {
        switch update {
        case .transform(let mode):
            transform(to: mode)
        case .updateAuthButtonState(let isValid):
            updateAuthButtonState(isValid)
        case .clearTextField:
            clearTextField()
        }
    }
    
    // SignIn/SignUp画面に応じてUI要素を調整
    private func transform(to screenMode: AuthViewModel.AuthMode) {
        usernameTextField.isHidden = screenMode == .signIn
        usernameValidation.isHidden = screenMode == .signIn
        // passwordResetButton.isHidden = screenMode == .signUp
        authButton.setTitle(screenMode.authButtonTitleToString, for: .normal)
        authModeToggleButton.setTitle(screenMode.sectionSwitchTitleToString, for: .normal)
    }
    
    // SignIn/SignUpボタンの非/活性状態の調整
    private func updateAuthButtonState(_ isValid: Bool) {
        let color = ColorCodes.primaryPurple.color()
        authButton.isEnabled = isValid
        authButton.backgroundColor = isValid ? color : color.withAlphaComponent(0.3)
    }
    
    // 認証成功時、入力フィールドをクリア
    private func clearTextField() {
        usernameTextField.text = ""
        usernameTextField.sendActions(for: .valueChanged)
        emailTextField.text = ""
        emailTextField.sendActions(for: .valueChanged)
        passwordTextField.text = ""
        passwordTextField.sendActions(for: .valueChanged)
    }
}
