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
    private lazy var usernameTextField = AuthTextField(placeholder: "Username", imageName: "person")
    private lazy var emailTextField = AuthTextField(placeholder: "Email Address", keyboardType: .emailAddress, imageName: "envelope")
    private lazy var passwordTextField = AuthTextField(placeholder: "Password", isSecureTextEntry: true, imageName: "lock")
    
    // 各認証情報入力欄を格納する配列
    lazy var authTextFields: [UITextField] = {
        return [usernameTextField, emailTextField, passwordTextField]
    }()
    
    // Forget Passwordボタンコンテナビュー
    private lazy var forgetPasswordButtonContainer = UIView()
    // Forget Passwordボタン
    private lazy var forgetPasswordButton = UIButton(type: .system).then {
        $0.setTitle("forget your password?", for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    // SignUp/SignInボタン
    private lazy var authButton = UIButton(type: .system).then {
        $0.setTitle("Sign Up / Sign Up", for: .normal)
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
    
    // Dont't you have an account? ボタン
    private lazy var dontHaveAccountButton = UIButton(type: .system).then {
        $0.setTitle("Dont't you have an account?", for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
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
        addArrangedSubview(separatorWithText)
        addArrangedSubview(providerButtonStackView)
        addArrangedSubview(separator)
        addArrangedSubview(dontHaveAccountButton)
        
        forgetPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.right.equalTo(passwordTextField.snp.right)
        }
        
        authButton.snp.makeConstraints {
            $0.height.equalTo(UIConstants.Button.height)
        }
        
        separatorWithText.snp.makeConstraints {
            $0.height.equalTo(UIConstants.Button.height)
        }
        
        providerButtonStackView.snp.makeConstraints {
            $0.height.equalTo(UIConstants.Button.height)
            $0.horizontalEdges.equalTo(separatorWithText).inset(UIConstants.Layout.largePadding * 2)
        }
        
        separator.snp.makeConstraints {
            $0.height.equalTo(UIConstants.Button.height)
        }
        
        dontHaveAccountButton.snp.makeConstraints {
            $0.height.equalTo(UIConstants.Button.height)
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

import RxSwift

extension Observable {
  /// 要素の最初の１つを適用して処理を実行する
  ///
  /// (Variable含む）BehaviorSubject利用のObservableの現在値を適用するのに利用できる。
  /// 注；PublishSubject利用のObservableでは何も起こらない。
    func applyFirst(handler: @escaping (Element) -> Void) {
        take(1).subscribe(onNext: handler).dispose()
  }

  /// 最初の値を取得する。
  ///
  /// 注； 最初の値を持っていない場合はnilを返す。
  var firstValue: Element? {
    var v: Element?
      applyFirst(handler: {(element) -> Void in
          v = element
      })
    return v
  }

  /// 現在値を取得する(firstValueのエイリアス)
  ///
  /// (Variable含む）BehaviorSubject利用のObservableの現在値を取得するのに利用できる。
  var value: Element? { return firstValue }
}

