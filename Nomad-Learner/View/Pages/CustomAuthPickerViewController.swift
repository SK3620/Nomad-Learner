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
    
    private lazy var authStackView: AuthStackView = AuthStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = UIConstants.Layout.semiMediumPadding
    }
    
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
            mainService: MainService.shared
        )
        
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
            .drive(switchAuthScreenMode)
            .disposed(by: disposeBag)
        
        // 認証ボタンの非/活性判定
        viewModel.authButtonEnabled
            .drive(processWhenAutheticated)
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
        authStackView.deleteAccountButton.rx.tap.asDriver()
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
    // SignIn/SignUp画面モードの切り替え
    private var switchAuthScreenMode: Binder<AuthViewModel.AuthMode> {
        return Binder(self) { base, authMode in base.authStackView.apply(.transform(to: authMode)) }
    }
    // 認証ボタンの非/活性判定
    private var updateAuthButtonState: Binder<Bool> {
        return Binder(self) { base, isValid in base.authStackView.apply(.updateAuthButtonState(isValid)) }
    }
    // 認証完了後の処理
    private var processWhenAutheticated: Binder<Bool> {
        return Binder(self) { base, authenticated in
            guard authenticated else { return }
            base.authStackView.apply(.clearTextField)
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
