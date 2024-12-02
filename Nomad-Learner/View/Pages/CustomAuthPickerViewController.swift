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
class CustomAuthPickerViewController: FUIAuthPickerViewController {
    
    private lazy var scrollView = view.subviews[0].then {
        $0.backgroundColor = .white
    }
    
    private lazy var contentView = scrollView.subviews[0].then {
        $0.backgroundColor = .white
    }
    
    private lazy var backgroundViewForAppIcon = UIView().then {
        $0.addSubview(self.appIconImageView)
    }
    
    private let appIconImageView = UIImageView(image: UIImage(named: "Logo"))
    
    private let authTextFieldStackView: AuthInfoInputStackView = AuthInfoInputStackView()
    
    private let bottomAuthStackView: BottomAuthStackView = BottomAuthStackView()
    
    private lazy var authStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.authTextFieldStackView,
            self.bottomAuthStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 56
        return stackView
    }()
    
    var viewModel: AuthViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIのセットアップ等
        setupUI()
        // 自動ログイン（UIの更新を待つ？）
        if let _ = FBAuth.currentUser {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Router.showMap(vc: self)
            }
        }
        // viewModelとのバインディング
        bind()
    }
    
    private func setupUI() {
      
        contentView.addSubview(backgroundViewForAppIcon)
        contentView.addSubview(authStackView)
        
        // 画面いっぱいに広げる
        contentView.snp.makeConstraints {
            $0.size.edges.equalTo(view)
        }
        
        backgroundViewForAppIcon.snp.makeConstraints {
            $0.bottom.equalTo(authStackView.snp.top)
            $0.top.right.left.equalToSuperview()
        }
        
        appIconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(view.screenHeight * 0.11)
        }
        
        authStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        // FirebaseUIのボタンを取得してauthStackViewに追加
        self.view.subviews[0].subviews[0].subviews[0].subviews.forEach { (view: UIView) in
            if let button = view as? UIButton {
                // 新しい制約でStackViewに追加
                bottomAuthStackView.addProviderButton(button)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // タイトルなし
        self.title = ""
    }
}

extension CustomAuthPickerViewController: AlertEnabled, KRProgressHUDEnabled {
    private func bind() {
        
        // パスワード表示/非表示切り替え
        authTextFieldStackView.passwordTextField.togglePasswordVisibilityButton.rx.tap
            .bind(to: togglePasswordVisibility)
            .disposed(by: disposeBag)
        
        self.viewModel = AuthViewModel(
            input:
                (
                    username: authTextFieldStackView.usernameTextField.rx.text.orEmpty.asDriver(),
                    email: authTextFieldStackView.emailTextField.rx.text.orEmpty.asDriver(),
                    password: authTextFieldStackView.passwordTextField.rx.text.orEmpty.asDriver(),
                    authButtonTaps: bottomAuthStackView.authButton.rx.tap.asSignal(),
                    authModeToggleTaps: bottomAuthStackView.authModeToggleButton.rx.tap.asSignal()
                ),
            authService: AuthService.shared, 
            mainService: MainService.shared
        )
        
        // 各入力欄の真下にバリデーションメッセージを表示
        viewModel.usernameValidation
            .drive(authTextFieldStackView.usernameValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.emailValidation
            .drive(authTextFieldStackView.emailValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.passwordValidation
            .drive(authTextFieldStackView.passwordValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        // SignIn/SignUp画面モードの切り替え
        viewModel.authMode
            .drive(switchAuthScreenMode)
            .disposed(by: disposeBag)
        
        // 認証ボタンの非/活性判定
        viewModel.authButtonEnabled
            .drive(updateAuthButtonState)
            .disposed(by: disposeBag)
        
        // 認証完了
        viewModel.didAuthenticate
            .drive(processWhenAutheticated)
            .disposed(by: disposeBag)
        
        // ローディングインジケーター
        viewModel.isLoading
            .drive(self.rx.showProgress)
            .disposed(by: disposeBag)
        
        // 認証エラーアラート表示
        viewModel.authError
            .map { AlertActionType.error($0) }
            .drive(self.rx.showAlert)
            .disposed(by: disposeBag)
        
        // アカウント削除 アラート表示
        bottomAuthStackView.deleteAccountButton.rx.tap.asDriver()
            .map { self.viewModel.willDeleteAccountActionType }
            .drive(self.rx.showAlert)
            .disposed(by: disposeBag)
        
        // アカウント削除成功
        viewModel.didDeleteAccount
            .drive(self.rx.showMessage)
            .disposed(by: disposeBag)
    }
}

extension CustomAuthPickerViewController {
    // パスワード表示/非表示切り替え
    private var togglePasswordVisibility: Binder<Void> {
        return Binder(self, binding: { base, _ in base.authTextFieldStackView.passwordTextField.togglePasswordVisibility() })
    }
    // SignIn/SignUp画面モードの切り替え
    private var switchAuthScreenMode: Binder<AuthViewModel.AuthMode> {
        return Binder(self) { base, authMode in
            base.authTextFieldStackView.transform(to: authMode)
            base.bottomAuthStackView.transform(to: authMode)
        }
    }
    // 認証ボタンの非/活性判定
    private var updateAuthButtonState: Binder<Bool> {
        return Binder(self) { base, isValid in
            base.bottomAuthStackView.updateAuthButtonState(isValid)
        }
    }
    // 認証完了後の処理
    private var processWhenAutheticated: Binder<Bool> {
        return Binder(self) { base, authenticated in
            guard authenticated else { return }
            base.authTextFieldStackView.clearTextField()
            // 暫定でdismissを呼ぶ（なぜか認証成功時ProgressHudが非表示にならない）
            KRProgressHUD.dismiss()
            // 画面遷移
            Router.showMap(vc: base)
        }
    }
}

extension CustomAuthPickerViewController {
    // 自動的に回転を許可しない
    override var shouldAutorotate: Bool {
        return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
