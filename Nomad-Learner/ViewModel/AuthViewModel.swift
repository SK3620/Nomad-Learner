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
     let authModeToggleTaps: Signal<AuthMode>
     */
    
    // MARK: - Output
    let usernameValidation: Driver<AuthInputValidation>
    let emailValidation: Driver<AuthInputValidation>
    let passwordValidation: Driver<AuthInputValidation>
    let isLoading: Driver<Bool>
    let authButtonEnabled: Driver<Bool>
    let didAuthenticate: Driver<Bool>
    let authError: Driver<Error>
    let authMode: Driver<AuthMode>
    
    // MARK: - Private properties
    private let authService: AuthServiceProtocol
    
    init(input: (
        username: Driver<String>,
        email: Driver<String>,
        password: Driver<String>,
        authButtonTaps: Signal<Void>,
        authModeToggleTaps: Signal<Void>
    ),
         authService: AuthServiceProtocol
    ) {
        
        self.authService = authService
        
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
                        .materialize()
                        .trackActivity(indicator)
                }
            }
            .startWith(.next(nil)) // 初期値を持たせてcombineLatestを稼働させる
            .share(replay: 1)
        
        // ログイン状態
        let isLoggedIn = authService
            .addStateDidChangeListener()
                
        // 認証完了
        self.didAuthenticate = Observable.combineLatest(authResults, isLoggedIn)
            .filter { event, isLoggedIn in
                event.element != nil || isLoggedIn
            }
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        
        // 認証失敗
        self.authError = authResults
            .compactMap { $0.event.error }
            .asDriver(onErrorJustReturn: MyError.unknown)
        
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
    }
}