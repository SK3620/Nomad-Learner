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
    
    // MARK: - SignIn With Auth Provider Result
    enum SignInWithAuthProviderResult {
        case success(FirebaseAuth.User)
        case failure(MyAppError)
    }
    
    // MARK: - Output
    let usernameValidation: Driver<AuthInputValidation>
    let emailValidation: Driver<AuthInputValidation>
    let passwordValidation: Driver<AuthInputValidation>
    let isLoading: Driver<Bool>
    let authButtonEnabled: Driver<Bool>
    let didAuthenticate: Driver<Bool>
    let authError: Driver<MyAppError>
    let authMode: Driver<AuthMode>
    let didDeleteAccount: Driver<ProgressHUDMessage>
    
    // MARK: - Private properties
    private let signInWithAuthProviderRelay = BehaviorRelay<SignInWithAuthProviderResult?>(value: nil)
    private let deleteAccountRelay = BehaviorRelay<(email: String, password: String)?>(value: nil)
    
    var willDeleteAccountActionType: AlertActionType {
        AlertActionType.willDeleteAccount(
            onConfirm: { email, password in self.deleteAccountRelay.accept((email: email!, password: password!))},
            onCancel: {}
        )
    }
    
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
        
        let myAppErrorRelay = BehaviorRelay<MyAppError?>(value: nil)
        
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
        
        // username, email, passwordのストリームを一本化
        let credentials = Driver.combineLatest(input.username, input.email, input.password, resultSelector: { (username: $0, email: $1, password: $2) })
        let credentialsWithAuthMode = Driver.combineLatest(credentials, authMode)
        
        // 認証（サインイン/サインアップ）
        let authResults = input.authButtonTaps
            .asObservable()
            .withLatestFrom(credentialsWithAuthMode)
            .flatMapLatest { tuple, mode in
                switch mode {
                case .signIn:
                    authService.signIn(email: tuple.email, password: tuple.password, shouldReauthenticate: false)
                        .materialize()
                        .trackActivity(indicator)
                case .signUp:
                    authService.signUp(username: tuple.username, email: tuple.email, password: tuple.password)
                        .map { User(
                            userId: $0.uid,
                            username: $0.displayName!,
                            currentLocationId: MyAppSettings.userInitialLocationId
                        ) }
                        .flatMap { mainService.saveUserProfile(user: $0, shouldUpdate: false) }
                        .materialize()
                        .trackActivity(indicator)
                }
            }
            .do(onNext: { myAppErrorRelay.accept($0.event.error as? MyAppError )})
        
        // プロバイダー認証完了後のユーザー情報保存
        let saveUserProfileResultWithProvider = signInWithAuthProviderRelay
            .compactMap { $0 }
            .flatMap {
                switch $0 {
                case .success(let user):
                    return authService.checkUUIDExists(with: user.uid)
                        .flatMap { userIdExists in
                            if userIdExists {
                                return Observable.just(())
                            } else {
                                let userProfile = User(
                                    userId: user.uid,
                                    username: user.displayName ?? "",
                                    currentLocationId: MyAppSettings.userInitialLocationId
                                )
                                return mainService.saveUserProfile(user: userProfile, shouldUpdate: false)
                            }
                        }
                        .catch { error in // ストリームを終了させない
                            myAppErrorRelay.accept(error as? MyAppError)
                            return .empty()
                        }
                case .failure(let myAppError): // ストリームを終了させない
                    myAppErrorRelay.accept(myAppError)
                    return .empty()
                }
            }
            .materialize()
        
        // アカウント削除
        let deleteAccountResult = self.deleteAccountRelay
            .compactMap { $0 }
            .flatMap { email, password in
                authService.signIn(email: email, password: password, shouldReauthenticate: true) // 再認証が必要
                    .concatMap { _ in authService.deleteAccount(email: email, password: password) }
                    .trackActivity(indicator)
                    .catch { error in // ストリームを終了させない
                        myAppErrorRelay.accept(error as? MyAppError)
                        return .empty()
                    }
            }
        
        // SignIn, SingUp, プロバイダー認証後のユーザー情報保存処理結果を一つに集約
        let mergedAuthResults = Observable
            .merge(authResults, saveUserProfileResultWithProvider)
            .share(replay: 1)
        
        // 認証完了
        self.didAuthenticate = mergedAuthResults
            .map { $0.event.element != nil }
            .asDriver(onErrorJustReturn: false)
        
        // アカウント削除完了
        self.didDeleteAccount = deleteAccountResult
            .map { _ in .didDeleteAccount }
            .asDriver(onErrorJustReturn: .none)
        
        // 認証失敗
        self.authError = myAppErrorRelay
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .unknown)
    }
}

extension AuthViewModel {
    // プロバイダーによる認証結果を制御
    func handleSignInWithAuthProviderResult(user: FirebaseAuth.User?, error: Error?) {
        // サインイン結果に応じてイベントを生成
        let result: SignInWithAuthProviderResult
        if let user = user {
            result = .success(user)
        } else if let error = error {
            result = .failure(.signInFailed(error))
        } else {
            result = .failure(.unknown)
        }
        // イベントを通知
        signInWithAuthProviderRelay.accept(result)
    }
}
