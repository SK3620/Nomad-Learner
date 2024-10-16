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
import RxSwift
import RxCocoa
import KRProgressHUD

// MARK: - Customize AuthPickerViewController
class CustomAuthPickerViewController: FUIAuthPickerViewController, UITextFieldDelegate {
    
    private var keyboardManager: KeyboardManager?
    
    private lazy var scrollView = view.subviews[0].then {
        $0.backgroundColor = .white
    }
    
    private lazy var contentView = scrollView.subviews[0].then {
        $0.backgroundColor = .white
    }
    
    private lazy var authStackView: AuthStackView = AuthStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = UIConstants.Layout.semiMediumPadding
    }
    
    // MapVC（マップ画面）へ遷移
    private var toMapVC: Void {
        Router.showMap(vc: self)
    }
    
    private var viewModel: AuthViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIのセットアップ等
        setupUI()
        // viewModelとのバインディング
        bind()
    }
    
    private func setupUI() {
        // UItextFieldデリゲート設定
        authStackView.authTextFields.forEach {
            $0.delegate = self
        }
        // passwordTextFieldを基準にキーボード出現時のレイアウト調整
        keyboardManager = KeyboardManager(viewController: self, textField: authStackView.authTextFields[2])
        
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
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // タイトルなし
        self.title = ""
    }
}

extension CustomAuthPickerViewController: AlertEnabled, KRProgressHUDEnabled {
    private func bind() {
        self.viewModel = AuthViewModel(
            input:
                (
                    username: authStackView.usernameTextField.rx.text.orEmpty.asDriver(),
                    email: authStackView.emailTextField.rx.text.orEmpty.asDriver(),
                    password: authStackView.passwordTextField.rx.text.orEmpty.asDriver(),
                    authButtonTaps: authStackView.authButton.rx.tap.asSignal(),
                    authModeToggleTaps: authStackView.authModeToggleButton.rx.tap.asSignal()
                ),
            authService: AuthService.shared,
            keyChainManager: KeyChainManager.shared
        )
        
        // emailとpassword入力欄にキーチェーンに保存した認証情報を表示
        viewModel.savedEmail
            .drive(authStackView.emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.savedPassword
            .drive(authStackView.passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 各入力欄の真下にバリデーションメッセージを表示
        viewModel.usernameValidation
            .drive(authStackView.usernameValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.emailValidation
            .drive(authStackView.emailValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.passwordValidation
            .drive(authStackView.passwordValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        // SignIn/SignUp画面モードの切り替え
        viewModel.authMode
            .drive(onNext: { [weak self] mode in
                guard let self = self else { return }
                self.authStackView.apply(.transform(to: mode))
            })
            .disposed(by: disposeBag)
        
        // 認証ボタンの非/活性判定
        viewModel.authButtonEnabled
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.authStackView.apply(.updateAuthButtonState(isValid))
            })
            .disposed(by: disposeBag)
        
        // 認証完了
        viewModel.didAuthenticate
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.authStackView.apply(.clearTextField)
                // 暫定でdismissを呼ぶ（なぜか認証成功時ProgressHudが非表示にならない）
                KRProgressHUD.dismiss()
                // 画面遷移
                self.toMapVC
            })
            .disposed(by: disposeBag)
        
        // ローディング
        viewModel.isLoading
            .drive(self.rx.showProgress)
            .disposed(by: disposeBag)
        
        // 認証エラーアラート表示
        viewModel.authError
            .map { AlertActionType.error($0)}
            .drive(self.rx.showAlert)
            .disposed(by: disposeBag)
    }
}
