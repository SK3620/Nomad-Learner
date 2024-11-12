//
//  AuthViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/01.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class AuthViewModel {
    
    // MARK: - Auth mode
    enum AuthMode {
        // サインイン画面
        case signIn
        // サインアップ画面
        case signUp
        
        var authButtonTitleToString: String {
            switch self {
            case .signIn:
                return "Sign In"
            case .signUp:
                return "Sign Up"
            }
        }
        
        var sectionSwitchTitleToString: String {
            switch self {
            case .signIn:
                return "Create an account"
            case .signUp:
                return "Already have an account"
            }
        }
    }
    
    
    // MARK: - Input
    /*
     let username: Driver<String>
     let email: Driver<String>
     let password: Driver<String>
     let authButtonTaps: Signal<Void>
     let authModeToggleTaps: Signal<Void>
     */
    
    // MARK: - Output
    let usernameValidation: Driver<AuthInputValidation>
    let emailValidation: Driver<AuthInputValidation>
    let passwordValidation: Driver<AuthInputValidation>
    let isLoading: Driver<Bool>
    let authButtonEnabled: Driver<Bool>
    let didAuthenticate: Driver<Bool>
    let authError: Driver<MyAppError>
    let authMode: Driver<AuthMode>
    let deleteAccountError: Driver<MyAppError>
    let didDeleteAccount: Driver<ProgressHUDMessage>
    var deleteAccount: Driver<(email: String, password: String)>
    
    // MARK: - Private properties
    private let deleteAccountRelay: BehaviorRelay<(email: String, password: String)>
    
    lazy var willDeleteAccountActionType = AlertActionType.willDeleteAccount(
        onConfirm: { email, password in self.deleteAccountRelay.accept((email: email!, password: password!))},
        onCancel: {}
    )
    
    init(input: (
        username: Driver<String>,
        email: Driver<String>,
        password: Driver<String>,
        authButtonTaps: Signal<Void>,
        authModeToggleTaps: Signal<Void>
    ),
         authService: AuthServiceProtocol,
         mainService: MainServiceProtocol
    ) {
        
        // deleteAccountRelayの初期化
        self.deleteAccountRelay = BehaviorRelay(value: (email: "", password: ""))
        self.deleteAccount = deleteAccountRelay.asDriver(onErrorJustReturn: (email: "", password: ""))
        
        // .skip() → 最初のバリデーションをスキップ
        // .startWith() → combineLatestを作動させるため、初期値を流す
        self.usernameValidation = input.username
            .distinctUntilChanged()
            .skip(1)
            .map { $0.validateUsername() }
            .startWith(.initialValidating)
        
        self.emailValidation = input.email
            .distinctUntilChanged()
            .skip(1)
            .map { $0.validateEmail() }
            .startWith(.initialValidating)
        
        self.passwordValidation = input.password
            .distinctUntilChanged()
            .skip(1)
            .map { $0.validatePassword() }
            .startWith(.initialValidating)
        
        // インジケーター
        let indicator = ActivityIndicator()
        self.isLoading = indicator.asDriver()
        
        // SignIn/SignUp画面の切り替え
        self.authMode = input.authModeToggleTaps
            .scan(AuthMode.signIn, accumulator: { currentMode, _ in
                currentMode == .signIn ? .signUp : .signIn
            })
            .startWith(.signIn)
            .asDriver(onErrorJustReturn: .signIn)
        
        // username, email, passwordのストリームを一本化
        let credentials = Driver.combineLatest(input.username, input.email, input.password, resultSelector: { (username: $0, email: $1, password: $2) })
        let credentialsWithAuthMode = Driver.combineLatest(credentials, authMode)
        
        // 認証
        let authResults = input.authButtonTaps
            .asObservable()
            .withLatestFrom(credentialsWithAuthMode)
            .flatMapLatest { tuple, mode in
                switch mode {
                case .signIn:
                    authService.signIn(email: tuple.email, password: tuple.password)
                        .materialize()
                        .trackActivity(indicator)
                case .signUp:
                    authService.signUp(username: tuple.username, email: tuple.email, password: tuple.password)
                        .flatMap { user in
                            print("ユーザー名: \(user.displayName!) uid: \(user.uid)")
                            // 保存するユーザー情報
                            let userProfile = User(
                                username: user.displayName!,
                                currentLocationId: UserInitialLocation.id // 初期位置
                            )
                            // サインアップ後、ユーザープロフィール情報を保存
                            return mainService.saveUserProfile(user: userProfile, shouldUpdate: false)
                                .map { _ in user } // FirebaseAuth.Userに変換 流すイベントの型を合わせる
                        }
                        .materialize()
                        .trackActivity(indicator)
                }
            }
            .share(replay: 1)
        
        // 認証完了
        self.didAuthenticate = authResults
            .map { $0.event.element != nil }
            .asDriver(onErrorJustReturn: false)
       
        // 認証失敗
        self.authError = authResults
            .compactMap { $0.event.error as? MyAppError }
            .asDriver(onErrorJustReturn: MyAppError.unknown)
        
        // 認証ボタンの非/活性判定
        self.authButtonEnabled = Driver.combineLatest(
            authMode,
            usernameValidation,
            emailValidation,
            passwordValidation,
            isLoading
        ) { mode, username, email, password, isLoading in
            switch mode {
            case .signIn:
                return email.isValid && password.isValid && !isLoading
            case .signUp:
                return username.isValid && email.isValid && password.isValid && !isLoading
            }
        }
        
        // アカウント削除
        let deleteAccountResult = self.deleteAccount
            .asObservable()
            .flatMapLatest { email, password in 
                authService.deleteAccount(email: email, password: password)
                    .materialize()
                    .trackActivity(indicator)
            }
            .share(replay: 1)
        
        // アカウント削除処理完了
        self.didDeleteAccount = deleteAccountResult
            .filter { $0.event.element != nil }
            .map { _ in .didDeleteAccount }
            .asDriver(onErrorJustReturn: ProgressHUDMessage.none)
        
        // アカウント削除エラー
        self.deleteAccountError = deleteAccountResult
            .compactMap { $0.event.error as? MyAppError }
            .asDriver(onErrorJustReturn: MyAppError.unknown)
    }
}
